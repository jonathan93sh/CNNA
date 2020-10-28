#include <systemc.h>
//
#include "hwcore/hf/helperlib.h"
#include <random>
#define sc_fifo hwcore::hf::sc_fifo_with_trace
//
#include "hwcore/cnn/cnn.h"

#include "hwcore/pipes/data_types.h"
#include <cmath>

SC_MODULE(tb_cnn_2d) {
#if __RTL_SIMULATION__
	// DMA_performance_tester_rtl_wrapper u1;
#else
	// DMA_performance_tester u1;
#endif
	typedef sc_fixed<P_data_W, P_data_P> sc_data;
	sc_data func(int a, int b, int c, int d) {
		int tmp = ((d & 0xFF) << 24) | ((c & 0xFF) << 16) | ((b & 0xFF) << 8) | ((a & 0xFF) << 0);

		return (sc_data)tmp;
	}

	void func_inv(sc_data in, int &a, int &b, int &c, int &d) {
		a = (in.to_int() >> 0) & 0xFF;
		b = (in.to_int() >> 8) & 0xFF;
		c = (in.to_int() >> 16) & 0xFF;
		d = (in.to_int() >> 24) & 0xFF;
	}

	struct dma_pkg : public hwcore::pipes::sc_fifo_base_dummy<dma_pkg> {
		typedef sc_bv<P_input_width> sc_data_raw;
		sc_data_raw *data_array;
		uint64 size;
	};

	sc_clock clk;
	sc_in<bool> iclk;
	sc_signal<bool> reset;

	sc_fifo<hwcore::pipes::sc_data_stream_t<P_input_width> > dma_source;
	sc_fifo<hwcore::pipes::sc_data_stream_t<P_input_width> > dma_buf_source;
	sc_fifo<hwcore::pipes::sc_data_stream_t<P_input_width> > dma_w_source;
	sc_fifo<hwcore::pipes::sc_data_stream_t<64> > dma_ctrl_source;

	sc_fifo<hwcore::pipes::sc_data_stream_t<P_output_width> > dma_sink;

	enum {
		weight_ctrl = 0,
		ctrl_row_N = 1,
		ctrl_row_size_pkg = 2,
		ctrl_window_size = 3,
		ctrl_depth = 4,
		ctrl_stride = 5,
		ctrl_replay = 6,
		ctrl_image_size = 7,
		ctrl_acf = 8,
		ctrl_zeropad = 9,
		ctrl_output_channel = 10,
		ctrl_stitch_depth = 11,
		ctrl_stitch_buf_depth = 12,
		ctrl_db_output = 13,
		ctrl_image_data = 14,
		ctrl_pool_depth = 15,
		ctrl_pool_type = 16,
		ctrl_pool_N = 17,
		ctrl_pool_size = 18
	};

	sc_signal<int> status_add, status_val;
	// sc_fifo<hwcore::pipes::sc_data_stream_t<16> > wave_2_u1;
	::cnn cnn_u1;
	// hwcore::cnn::top_cnn<16,8,1,1,16,16> cnn_u1;

	sc_trace_file *tracePtr;
	ofstream of;

	void log_time(std::string msg) { of << msg << ":" << sc_time_stamp().to_string() << std::endl; }
	void log(std::string msg) { of << msg << std::endl; }

	void fifo_debug() {
		sc_time time_interval(1000, SC_NS);
		while (true) {
			wait(time_interval);

			auto list = hwcore::hf::sc_trace_fifo::getList();
			for (auto fifo_wrap : list) {
				int total = fifo_wrap->num_available() + fifo_wrap->num_free();
				int used = fifo_wrap->num_available();
				sc_port_base *writer = fifo_wrap->getWriter();
				const char *w_name = (writer ? writer->name() : fifo_wrap->name());
				sc_port_base *reader = fifo_wrap->getReader();
				const char *r_name = (reader ? reader->name() : fifo_wrap->name());
				std::cout << "[fifo debug][ " << sc_time_stamp() << " ][Used/Total] name [writer --> reader]: [" << used
				          << " / " << total << "] " << fifo_wrap->name() << " [" << w_name << " --> " << r_name << "]"
				          << std::endl;
			}
		}
	}

	void status_reg_dump() {
		sc_time time_interval(1000, SC_NS);
		while (true) {

			status_add.write(-1);
			for (int i = 0; i < 10; i++)
				wait();
			int N_reg = status_val.read();
			for (int reg_n = 0; reg_n < N_reg; reg_n++) {
				status_add.write(reg_n);
				for (int i = 0; i < 10; i++)
					wait();
				int reg_value = status_val.read();
				std::cout << "[status reg dump][ " << sc_time_stamp() << " ]reg[" << reg_n << "] = " << reg_value
				          << std::endl;
			}
			wait(time_interval);
		}
	}

	SC_CTOR_DEFAULT(tb_cnn_2d) : SC_INST(cnn_u1), clk("clk", sc_time(5.625, SC_NS)) {
		of.open("result.txt");
		srand(0xbeef);
		SC_MODULE_LINK(cnn_u1);
		iclk(clk);

		cnn_u1.status_add(status_add);
		cnn_u1.status_val(status_val);

		cnn_u1.data_sink(dma_source);
		cnn_u1.data_buf_sink(dma_buf_source);
		cnn_u1.w_sink(dma_w_source);
		cnn_u1.data_source(dma_sink);
		cnn_u1.ctrl_sink(dma_ctrl_source);

		SC_CTHREAD(cpu_thread_vgg19_test, iclk.pos());
		SC_CTHREAD(dma_sink_thread, iclk.pos());
		SC_CTHREAD(dma_source_thread, iclk.pos());
		SC_CTHREAD(dma_source_buf_thread, iclk.pos());
		SC_CTHREAD(dma_source_w_thread, iclk.pos());
		SC_CTHREAD(dma_source_ctrl_thread, iclk.pos());
		SC_CTHREAD(fifo_debug, iclk.pos());
		SC_CTHREAD(status_reg_dump, iclk.pos());
		HLS_DEBUG_EXEC(set_stack_size(128 * 10 * 1024 * 1024));
		tracePtr = sc_create_vcd_trace_file("tb_CNN");
		trace(tracePtr);
	}

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);

		// SC_TRACE_ADD_MODULE(wave_2_u1);
		// SC_TRACE_ADD_MODULE(data_ctrl);
		SC_TRACE_ADD_MODULE(weight_ctrl);
		SC_TRACE_ADD_MODULE(ctrl_row_N);
		SC_TRACE_ADD_MODULE(ctrl_channel);
		SC_TRACE_ADD_MODULE(cnn_u1);
		// SC_TRACE_ADD_MODULE(u1_2_mon);
	}

	void do_cmd(sc_uint<8> regnr, sc_uint<56> value) {

		sc_uint<64> pkg = (regnr, value);
		dma_source_ctrl_ctrl.write(pkg);
	}

	const int dma_bw = P_input_BW_N;
	const int pe_bw = P_pe_bw_n;
	const int pe_n = P_pe_n;
	const int db_out_n = P_data_out_n;
	// typedef sc_fixed<P_data_W, P_data_P> sc_data;

	void cpu_thread_vgg19_test() {
		std::cout << "dma_bw:" << dma_bw << ", pe_bw: " << pe_bw << ", pe_n: " << pe_n << ", db_out_n: " << P_data_out_n
		          << std::endl;

		reset.write(1);
		for (int i = 0; i < 10; i++)
			wait();
		reset.write(0);

		wait();

		pooling_test_512();
		conv_test(16, 1, 64, 64);

		const int image_size = 32;
		const int N_images = 1;
		const int depth = 3;
		int N_W = 64;
#if 0
		sc_data *X = new sc_data[image_size * image_size * depth * N_images];
		{
			fstream input;
			input.open("/home/jonathan/vgg19/dog.txt", ios::in);
			char test[512];
			char *end;
			const int total_size = image_size * image_size * depth * N_images;
			std::cout << total_size << std::endl;
			int idx = 0;
			for (int i = 0; i < N_images; i++) {
				for (int x = 0; x < image_size; x++) {
					for (int y = 0; y < image_size; y++) {
						for (int z = 0; z < depth; z++) {
							input.getline(test, 512);
							double tmp = std::strtod(test, &end);

							std::cout << "W[" << i << "," << x << "," << y << "," << z << "] = " << tmp << std::endl;
							X[idx] = tmp;
							idx++;
						}
					}
				}
			}
		}
#endif

		sc_ufixed<8, 0> *X = new sc_ufixed<8, 0>[image_size * image_size * depth * N_images];
		{
			fstream input;
			input.open("/home/jonathan/vgg19/dog.txt", ios::in);
			char test[512];
			char *end;
			const int total_size = image_size * image_size * depth * N_images;
			std::cout << total_size << std::endl;
			int idx = 0;
			for (int i = 0; i < N_images; i++) {
				for (int x = 0; x < image_size; x++) {
					for (int y = 0; y < image_size; y++) {
						for (int z = 0; z < depth; z++) {
							double tmp;
							if (z < 3) {
								input.getline(test, 512);
								tmp = std::strtod(test, &end);
							} else {
								tmp = 0;
							}

							X[idx] = tmp;
							std::cout << "W[" << i << "," << x << "," << y << "," << z << "] = " << X[idx].to_double()
							          << "(" << tmp << ")" << std::endl;
							idx++;
						}
					}
				}
			}
		}

		double *Y = new double[image_size * image_size * N_W * N_images];
		{
			int zN = 64;
			fstream input;
			input.open("/home/jonathan/vgg19/dog_out.txt", ios::in);
			char test[512];
			char *end;
			input.getline(test, 512);
			int idx = 0;
			for (int i = 0; i < N_images; i++) {
				for (int x = 0; x < image_size; x++) {
					for (int y = 0; y < image_size; y++) {
						for (int z = 0; z < zN; z++) {
							input.getline(test, 512);
							double tmp = std::strtod(test, &end);

							std::cout << "Y[" << i << "," << x << "," << y << "," << z << "] = " << tmp << std::endl;
							if (z < N_W) {
								Y[idx] = tmp;
								idx++;
							}
						}
					}
				}
			}
		}

		// std::string line = ;
		sc_data *W;
		{
			fstream conv1;
			conv1.open("/home/jonathan/vgg19/weights.txt", ios::in);
			char test[512];
			conv1.getline(test, 512);
			std::string line(test);
			char *end;
			int x = 3;
			int y = 3;
			int z = 3;
			int w = 64;

			W = new sc_data[(x * y * z * N_W) + N_W];

			int idx = 0;
			double tmp;
			for (int wi = 0; wi < N_W; wi++) {
				conv1.getline(test, 512);
				tmp = std::strtod(test, &end);
				W[idx] = tmp;
				std::cout << "B[" << wi << "] = " << tmp << std::endl;
				idx++;
				for (int xi = 0; xi < x; xi++) {
					for (int yi = 0; yi < y; yi++) {
						for (int zi = 0; zi < depth; zi++) {
							if (zi < z) {
								conv1.getline(test, 512);
								tmp = std::strtod(test, &end);
							} else {
								tmp = 0;
							}

							W[idx] = tmp;
							idx++;
							std::cout << "W[" << wi << "," << xi << "," << yi << "," << zi << "] = " << tmp
							          << std::endl;
						}
					}
				}
			}
		}

		dma_pkg dmaX;
		dma_pkg dmaW;
		dma_pkg dmaY1;
		int W_size = 3;

		int new_W_size;
		int new_depth;

		// pre_data(X, dmaX, image_size, N_images, depth, new_depth);
		pre_data_image(X, dmaX, image_size, N_images, new_depth);
		pre_weight(W, dmaW, W_size, N_W, depth, new_depth, new_W_size);
		{
			ofstream of_w_dump;
			of_w_dump.open("W_dma_dump_vgg19.txt");
			for (int i = 0; i < dmaW.size; i++) {

				auto tmp = dmaW.data_array[i];
				of_w_dump << "dma[" << i << "] = [MSB ";
				for (int a = dma_bw - 1; a >= 0; a--) {
					auto sub = tmp((P_data_W * (a + 1)) - 1, P_data_W * a);
					;
					of_w_dump << " (" << (P_data_W * (a + 1)) - 1 << "," << P_data_W * a << ")"
					          << sub.to_string(sc_dt::sc_numrep::SC_HEX) << (a == 0 ? "" : ",");
				}
				of_w_dump << " LSB]" << std::endl;
			}
		}
		pre_output(dmaY1, image_size, W_size, depth, N_images, N_W, 1);
		log_time("conv_start");
		do_conv(dmaX, dmaW, dmaY1, new_W_size, new_depth, image_size, 1, N_images, N_W, 1, true);

		double mse = 0.0f;
		for (int i = 0; i < N_images; i++) {

			for (int x = 0; x < image_size; x++) {
				for (int y = 0; y < image_size; y++) {
					for (int z = 0; z < N_W; z++) {

						int Yindx = (i * image_size * image_size * N_W) + (x * image_size * N_W) + (y * N_W) + z;
						int Yindx_add = Yindx / dma_bw;
						int Yindx_cut = Yindx % dma_bw;
						sc_fixed<P_data_W, P_data_P> got_fix = hwcore::hf::bv2fixed<P_data_W, P_data_P>(
						    dmaY1.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut));

						debug_cout << "[i,a,b,c]:[" << i << "," << x << "," << y << "," << z << "]:[expected,got] = ["
						           << Y[Yindx] << "," << got_fix.to_double() << "] Yindx = " << Yindx << "==>"
						           << Yindx_add << "." << Yindx_cut << std::endl;

						mse += (Y[Yindx] - got_fix.to_double()) * (Y[Yindx] - got_fix.to_double());
						// sc_assert(got == expected);
						//#warning fix W before uncomment
					}
				}
			}
		}

		mse = mse / (double)(N_images * image_size * image_size * N_W);

		std::cout << "mse: " << mse << std::endl;
		log(std::string("mse: ") + std::to_string(mse));
		double mse_tol = 1e-1;
		// sc_assert(mse <= mse_tol);
		log_time("conv_end");

		log_time("pool_start");
		dma_pkg dmaY2;
		pre_output(dmaY2, image_size, 2, N_W, N_images, N_W, 0, 2);
		do_pool(dmaY1, dmaY2, N_W, image_size, 2, N_images, 2, 0);
		log_time("pool_end");

		for (int i = 0; i < N_images; i++) {

			for (int x = 0; x < image_size / 2; x++) {
				for (int y = 0; y < image_size / 2; y++) {
					for (int z = 0; z < N_W; z++) {

						sc_fixed<P_data_W, P_data_P> exp_fix;

						for (int px = 0; px < 2; px++) {
							for (int py = 0; py < 2; py++) {
								int Yindx = (i * (image_size) * (image_size)*N_W) +
								            (((x * 2) + px) * image_size * N_W) + (((y * 2) + py) * N_W) + z;
								int Yindx_add = Yindx / dma_bw;
								int Yindx_cut = Yindx % dma_bw;

								sc_fixed<P_data_W, P_data_P> exp_fix_tmp = hwcore::hf::bv2fixed<P_data_W, P_data_P>(
								    dmaY1.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut));
								if ((px == 0 && py == 0) || exp_fix < exp_fix_tmp) {
									exp_fix = exp_fix_tmp;
								}
								std::cout << "exp pool [" << px << "," << py << "] [exp_fix, exp_tmp]=["
								          << exp_fix.to_float() << ", " << exp_fix_tmp.to_float() << "]" << std::endl;
							}
						}

						int Yindx = (i * (image_size / 2) * (image_size / 2) * N_W) + (x * (image_size / 2) * N_W) +
						            (y * N_W) + z;
						int Yindx_add = Yindx / dma_bw;
						int Yindx_cut = Yindx % dma_bw;
						sc_fixed<P_data_W, P_data_P> got_fix = hwcore::hf::bv2fixed<P_data_W, P_data_P>(
						    dmaY2.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut));

						debug_cout << "[i,a,b,c]:[" << i << "," << x << "," << y << "," << z << "]:[expected,got] = ["
						           << exp_fix.to_double() << "," << got_fix.to_double() << "] Yindx = " << Yindx
						           << "==>" << Yindx_add << "." << Yindx_cut << std::endl;

						sc_assert(got_fix == exp_fix);
						//#warning fix W before uncomment
					}
				}
			}
		}

		fc_test(dmaY2, image_size / 2, N_W, N_images, 128);

		{
			/*
			dma_pkg dmaWfc;
			dma_pkg dmaY3;
			int outputs = 2;
			int inputs = (image_size / 2) * (image_size / 2) * N_W;
			pre_fc_output(dmaY3, outputs * N_images);
			int w_row_N;
			sc_data *Wfc = new sc_data[outputs * (1 + inputs)];

			for (int i = 0; i < outputs; i++) {
			    Wfc[i * (1 + inputs)] = sc_data(0.001f * (float)((rand() % 100) - 50));
			    for (int x = 0; x < inputs; x++) {
			        Wfc[(i * (1 + inputs)) + x + 1] = sc_data(0.001f * (float)((rand() % 100) - 50));
			    }
			}
			int outputs_raw;
			pre_fc_weight(Wfc, dmaWfc, inputs, outputs, outputs_raw, w_row_N);

			log_time("fc_start");
			do_fc(dmaY2, dmaWfc, dmaY3, inputs, outputs_raw, N_images, w_row_N);

			mse = 0.0;
			for (int i = 0; i < N_images; i++) {
			    for (int x = 0; x < outputs; x++) {
			        double exp = Wfc[x * (1 + inputs)].to_double();
			        for (int in = 0; in < inputs; in++) {
			            int Yindx = (i * inputs) + in;
			            int Yindx_add = Yindx / dma_bw;
			            int Yindx_cut = Yindx % dma_bw;
			            sc_fixed<P_data_W, P_data_P, SC_TRN, SC_SAT> input_data = hwcore::hf::bv2fixed<P_data_W,
			P_data_P>( dmaY2.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut)); exp += Wfc[(x
			* (1 + inputs)) + in + 1].to_double() * input_data.to_double();
			        }

			        int Yindx = (i * outputs) + x;
			        int Yindx_add = Yindx / dma_bw;
			        int Yindx_cut = Yindx % dma_bw;
			        sc_fixed<P_data_W, P_data_P> input_data = hwcore::hf::bv2fixed<P_data_W, P_data_P>(
			            dmaY3.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut));

			        std::cout << "[" << i << "," << x << "] : [exp <==> got] = [" << exp << " <==> "
			                  << input_data.to_double() << "]" << std::endl;

			        mse += (exp - input_data.to_double()) * (exp - input_data.to_double());
			        // sc_assert(exp == input_data);
			    }
			}

			mse /= (double)(N_images * outputs);
			std::cout << "mse: " << mse << std::endl;
			log(std::string("mse: ") + std::to_string(mse));
			// double mse_tol = 1e-1;
			// sc_assert(mse <= mse_tol);

			log_time("fc_end");
			*/
		}
		sc_stop();
		while (true) {
			std::cout << "done" << std::endl;
			wait();
		}
	}

	void conv_test(int image_size, int N_images, int depth, int N_W) {
		dma_pkg dmaX;
		dma_pkg dmaW;
		dma_pkg dmaY1;
		int W_size = 3;

		int new_W_size;
		int new_depth;

		pre_data(nullptr, dmaX, image_size, N_images, depth, new_depth);
		// pre_data_image(X, dmaX, image_size, N_images, new_depth);
		pre_weight(nullptr, dmaW, W_size, N_W, depth, new_depth, new_W_size);

		pre_output(dmaY1, image_size, W_size, depth, N_images, N_W, 1);
		log_time("conv_start-" + std::to_string(image_size) + "-" + std::to_string(depth) + "-" + std::to_string(N_W));
		do_conv(dmaX, dmaW, dmaY1, new_W_size, new_depth, image_size, 1, N_images, N_W, 1, false);

		log(std::string("mse: ") + std::to_string(0.0f));
		// sc_assert(mse <= mse_tol);
		log_time("conv_end-" + std::to_string(image_size) + "-" + std::to_string(depth) + "-" + std::to_string(N_W));
	}

	void fc_test(dma_pkg & dmaY2, int image_size, int depth, int N_images, int n_neurons) {
		log_time("fc_start");
		double mse = 0.0;

		for (int i = 0; i < n_neurons / pe_n; i++) {

			dma_pkg dmaWfc;
			dma_pkg dmaY3;
			int outputs = pe_n;
			int inputs = image_size * image_size * depth;
			pre_fc_output(dmaY3, outputs * N_images);
			int w_row_N;
			sc_data *Wfc = new sc_data[outputs * (1 + inputs)];

			for (int i = 0; i < outputs; i++) {
				Wfc[i * (1 + inputs)] = sc_data(0.001f * (float)((rand() % 100) - 50));
				for (int x = 0; x < inputs; x++) {
					Wfc[(i * (1 + inputs)) + x + 1] = sc_data(0.001f * (float)((rand() % 100) - 50));
				}
			}
			int outputs_raw;
			pre_fc_weight(Wfc, dmaWfc, inputs, outputs, outputs_raw, w_row_N);

			do_fc(dmaY2, dmaWfc, dmaY3, inputs, outputs_raw, N_images, w_row_N);

			for (int i = 0; i < N_images; i++) {
				for (int x = 0; x < outputs; x++) {
					double exp = Wfc[x * (1 + inputs)].to_double();
					for (int in = 0; in < inputs; in++) {
						int Yindx = (i * inputs) + in;
						int Yindx_add = Yindx / dma_bw;
						int Yindx_cut = Yindx % dma_bw;
						sc_fixed<P_data_W, P_data_P, SC_TRN, SC_SAT> input_data =
						    hwcore::hf::bv2fixed<P_data_W, P_data_P>(
						        dmaY2.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut));
						exp += Wfc[(x * (1 + inputs)) + in + 1].to_double() * input_data.to_double();
					}

					int Yindx = (i * outputs) + x;
					int Yindx_add = Yindx / dma_bw;
					int Yindx_cut = Yindx % dma_bw;
					sc_fixed<P_data_W, P_data_P> input_data = hwcore::hf::bv2fixed<P_data_W, P_data_P>(
					    dmaY3.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut));

					std::cout << "[" << i << "," << x << "] : [exp <==> got] = [" << exp << " <==> "
					          << input_data.to_double() << "]" << std::endl;

					mse += (sc_data(exp).to_double() - input_data.to_double()) *
					       (sc_data(exp).to_double() - input_data.to_double());
					// sc_assert(exp == input_data);
				}
			}
		}
		mse /= (double)(N_images * n_neurons);
		std::cout << "mse: " << mse << std::endl;
		log(std::string("mse: ") + std::to_string(mse));
		// double mse_tol = 1e-1;
		// sc_assert(mse <= mse_tol);

		log_time("fc_end");
	}

	void pooling_test_512() {

		const int image_size = 28;
		const int N_images = 1;
		const int depth = 512;

		sc_data *X = new sc_data[image_size * image_size * depth * N_images];

		{
			const int total_size = image_size * image_size * depth * N_images;
			std::cout << total_size << std::endl;
			int idx = 0;
			for (int i = 0; i < N_images; i++) {
				for (int x = 0; x < image_size; x++) {
					for (int y = 0; y < image_size; y++) {
						for (int z = 0; z < depth; z++) {
							// input.getline(test, 512);
							double tmp = 0.001 * ((rand() % 2000) - 1000);
							std::cout << "W[" << i << "," << x << "," << y << "," << z << "] = " << tmp << std::endl;
							X[idx] = tmp;
							idx++;
						}
					}
				}
			}
		}

		dma_pkg dmaX;
		int new_W_size;
		int new_depth;

		pre_data(X, dmaX, image_size, N_images, depth, new_depth);

		log_time("pool512_start");
		dma_pkg dmaY2;
		pre_output(dmaY2, image_size, 2, depth, N_images, depth, 0, 2);
		do_pool(dmaX, dmaY2, depth, image_size, 2, N_images, 2, 0);
		log_time("pool512_end");

		for (int i = 0; i < N_images; i++) {

			for (int x = 0; x < image_size / 2; x++) {
				for (int y = 0; y < image_size / 2; y++) {
					for (int z = 0; z < depth; z++) {

						sc_fixed<P_data_W, P_data_P> exp_fix;

						for (int px = 0; px < 2; px++) {
							for (int py = 0; py < 2; py++) {
								int Yindx = (i * (image_size) * (image_size)*depth) +
								            (((x * 2) + px) * image_size * depth) + (((y * 2) + py) * depth) + z;
								int Yindx_add = Yindx / dma_bw;
								int Yindx_cut = Yindx % dma_bw;

								sc_fixed<P_data_W, P_data_P> exp_fix_tmp = hwcore::hf::bv2fixed<P_data_W, P_data_P>(
								    dmaX.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut));
								if ((px == 0 && py == 0) || exp_fix < exp_fix_tmp) {
									exp_fix = exp_fix_tmp;
								}
								std::cout << "exp pool [" << px << "," << py << "] [exp_fix, exp_tmp]=["
								          << exp_fix.to_float() << ", " << exp_fix_tmp.to_float() << "]" << std::endl;
							}
						}

						int Yindx = (i * (image_size / 2) * (image_size / 2) * depth) + (x * (image_size / 2) * depth) +
						            (y * depth) + z;
						int Yindx_add = Yindx / dma_bw;
						int Yindx_cut = Yindx % dma_bw;
						sc_fixed<P_data_W, P_data_P> got_fix = hwcore::hf::bv2fixed<P_data_W, P_data_P>(
						    dmaY2.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut));

						debug_cout << "[i,a,b,c]:[" << i << "," << x << "," << y << "," << z << "]:[expected,got] = ["
						           << exp_fix.to_double() << "," << got_fix.to_double() << "] Yindx = " << Yindx
						           << "==>" << Yindx_add << "." << Yindx_cut << std::endl;

						sc_assert(got_fix == exp_fix);
						//#warning fix W before uncomment
					}
				}
			}
		}
	}

	void cpu_thread_fc_only() {
		int N_images = 1;
		int image_size = 16;
		int depth = 8;
		int N_W = 8;

		sc_data *X = new sc_data[image_size * image_size * depth * N_images];
		{
			const int total_size = image_size * image_size * depth * N_images;
			std::cout << total_size << std::endl;
			int idx = 0;
			for (int i = 0; i < N_images; i++) {
				for (int x = 0; x < image_size * image_size * depth; x++) {

					std::cout << "W[" << i << "," << x << "] = " << x << std::endl;
					X[idx] = x;
					idx++;
				}
			}
		}
		int new_depth;
		dma_pkg dmaX;
		pre_data(X, dmaX, image_size, N_images, depth, new_depth);
		sc_assert(depth == new_depth);
		dma_pkg dmaWfc;

		dma_pkg dmaY3;
		int outputs = pe_n;
		int inputs = (image_size) * (image_size)*depth;
		// int inputs_raw = (image_size) * (image_size)*new_depth;

		int w_row_N;
		sc_data *Wfc = new sc_data[outputs * (1 + inputs)];

		for (int i = 0; i < outputs; i++) {
			Wfc[i * (1 + inputs)] = 0; // sc_data(0.001f * (float)((rand() % 100) - 50));
			for (int x = 0; x < inputs; x++) {
				Wfc[(i * (1 + inputs)) + x + 1] = x; // sc_data(0.001f * (float)((rand() % 100) - 50));
			}
		}
		int outputs_raw;
		pre_fc_weight(Wfc, dmaWfc, inputs, outputs, outputs_raw, w_row_N);
		pre_fc_output(dmaY3, outputs_raw * N_images);

		log_time("fc_start");
		do_fc(dmaX, dmaWfc, dmaY3, inputs, outputs_raw, N_images, w_row_N);
		/*
		mse = 0.0;
		for (int i = 0; i < N_images; i++) {
		    for (int x = 0; x < outputs; x++) {
		        sc_fixed<P_data_W * 2, P_data_P * 2, SC_TRN, SC_SAT> exp = Wfc[x * (1 + inputs)];
		        for (int in = 0; in < inputs; in++) {
		            int Yindx = (i * inputs) + in;
		            int Yindx_add = Yindx / dma_bw;
		            int Yindx_cut = Yindx % dma_bw;
		            sc_fixed<P_data_W, P_data_P, SC_TRN, SC_SAT> input_data = hwcore::hf::bv2fixed<P_data_W, P_data_P>(
		                dmaY2.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut));
		            exp += (sc_fixed<P_data_W * 2, P_data_P * 2, SC_TRN, SC_SAT>)Wfc[(x * (1 + inputs)) + in + 1] *
		                   (sc_fixed<P_data_W * 2, P_data_P * 2, SC_TRN, SC_SAT>)input_data;
		        }
		        sc_fixed<P_data_W, P_data_P, SC_TRN, SC_SAT> exp_small = exp;
		        int Yindx = (i * outputs) + x;
		        int Yindx_add = Yindx / dma_bw;
		        int Yindx_cut = Yindx % dma_bw;
		        sc_fixed<P_data_W, P_data_P> input_data = hwcore::hf::bv2fixed<P_data_W, P_data_P>(
		            dmaY3.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut));

		        std::cout << "[" << i << "," << x << "] : [exp <==> got] = [" << exp_small.to_double() << " <==> "
		                  << input_data.to_double() << "]" << std::endl;

		        mse +=
		            (exp_small.to_double() - input_data.to_double()) * (exp_small.to_double() - input_data.to_double());
		        // sc_assert(exp == input_data);
		    }
		}

		mse /= (double)(N_images * outputs);
		std::cout << "mse: " << mse << std::endl;
		log(std::string("mse: ") + std::to_string(mse));
		// double mse_tol = 1e-1;
		// sc_assert(mse <= mse_tol);
*/
		log_time("fc_end");
		sc_stop();
		while (true) {
			std::cout << "done" << std::endl;
			wait();
		}
	}

	void cpu_thread() {

		std::cout << "dma_bw:" << dma_bw << ", pe_bw: " << pe_bw << ", pe_n: " << pe_n << ", db_out_n: " << P_data_out_n
		          << std::endl;

		reset.write(1);
		for (int i = 0; i < 10; i++)
			wait();
		reset.write(0);

		const int image_size = 8;
		const int N_images = 1;
		const int depth = fix_size(8, pe_bw);
		const int W_size = 3;
		const int N_W = 8;

		sc_data *X = new sc_data[image_size * image_size * depth * N_images];
		const int total_size = image_size * image_size * depth * N_images;
		std::cout << total_size << std::endl;
		int idx = 0;
		for (int i = 0; i < N_images; i++) {
			for (int x = 0; x < image_size; x++) {
				for (int y = 0; y < image_size; y++) {
					for (int z = 0; z < depth; z++) {
						sc_data tmp = func(x, y, z, i);
						std::cout << "image data: " << tmp.to_string() << std::endl;
						X[idx] = tmp;
						idx++;
					}
				}
			}
		}
		sc_data *W = new sc_data[(W_size * W_size * depth * N_W) + N_W];
		idx = 0;
		const int w_indx = (int)floor(W_size / 2.0f);
		for (int i = 0; i < N_W; i++) {
			W[idx] = i;
			idx++;
			for (int x = 0; x < W_size; x++) {

				for (int y = 0; y < W_size; y++) {
					for (int z = 0; z < depth; z++) {
						if (z == i % depth && y == (i / depth) % W_size && x == (i / (depth * W_size)) % W_size) {
							W[idx] = 1;
						} else {
							W[idx] = 0;
						}
						std::cout << "w data: " << W[idx].to_string() << std::endl;
						idx++;
					}
				}
			}
		}

		dma_pkg dmaX;
		dma_pkg dmaW;
		dma_pkg dmaY1;
		dma_pkg dmaY2;
		dma_pkg dmaWfc;
		dma_pkg dmaY3;
		int new_W_size;
		int new_depth;

		int output_fc = 2;
		pre_output(dmaY2, image_size, 2, N_W, N_images, N_W, 0, 2);
		pre_fc_output(dmaY3, output_fc * N_images);
		int w_row_N;

		int output_raw_fc;
		pre_fc_weight(nullptr, dmaWfc, (dmaY2.size * dma_bw) / N_images, 64, output_raw_fc, w_row_N);
		pre_data(X, dmaX, image_size, N_images, depth, new_depth);
		pre_weight(W, dmaW, W_size, N_W, depth, new_depth, new_W_size);
		pre_output(dmaY1, image_size, W_size, depth, N_images, N_W, 1);
		log_time("conv_start");
		do_conv(dmaX, dmaW, dmaY1, new_W_size, new_depth, image_size, 1, N_images, N_W, 1);
		int zp = 1;
		for (int i = 0; i < N_images; i++) {

			for (int x = 0; x < image_size; x++) {
				for (int y = 0; y < image_size; y++) {
					for (int z = 0; z < N_W; z++) {
						int off_x = ((z / (new_depth * new_W_size)) % new_W_size) - zp;
						int off_y = ((z / new_depth) % new_W_size) - zp;
						int off_z = z % new_depth;

						int expected = 0;
						if (0 <= x + off_x && x + off_x < image_size && 0 <= y + off_y && y + off_y < image_size) {
							expected = func(x + off_x, y + off_y, off_z, i);
						}

						int Yindx = (i * image_size * image_size * N_W) + (x * image_size * N_W) + (y * N_W) + z;
						int Yindx_add = Yindx / dma_bw;
						int Yindx_cut = Yindx % dma_bw;
						sc_fixed<P_data_W, P_data_P> got_fix = hwcore::hf::bv2fixed<P_data_W, P_data_P>(
						    dmaY1.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut));
						int got = got_fix.to_int() - z;

						debug_cout << "[i,a,b,c]:[" << i << "," << x << "," << y << "," << z << "]- func(" << x + off_x
						           << "," << y + off_y << "," << off_z << "," << i << ")=[expected,got]:[" << expected
						           << "," << got << "] Yindx = " << Yindx << "==>" << Yindx_add << "." << Yindx_cut
						           << std::endl;

						int _x;
						int _y;
						int _z;
						int _i;
						func_inv(got_fix - sc_fixed<P_data_W, P_data_P>(z), _x, _y, _z, _i);
						debug_cout << "invfunc got [x,y,z,i]:[" << _x << "," << _y << "," << _z << "," << _i << "]"
						           << std::endl;

						sc_assert(got == expected);
						//#warning fix W before uncomment
					}
				}
			}
		}

		log_time("conv_end");
		log_time("pool_start");
		do_pool(dmaY1, dmaY2, N_W, image_size, 2, N_images, 2, 0);
		log_time("pool_end");
		// pre_process(X, W, dmaX, dmaW, dmaY, image_size, W_size, depth, new_W_size, new_depth, N_images, N_W, 1);
		log_time("fc_start");
		do_fc(dmaY2, dmaWfc, dmaY3, dmaY2.size * dma_bw, dmaY3.size * dma_bw, N_images, w_row_N);
		log_time("fc_end");
		sc_stop();
		while (true) {
			std::cout << "done" << std::endl;
			wait();
		}
		// do_conv(dmaX, dmaW, dmaY, new_W_size, new_depth, image_size, 1, N_images, N_W, 1);
	}

	void pre_fc_weight(sc_data * W, dma_pkg & dmaW, int N_input, int N_output, int &N_output_raw, int &w_row_N) {
		N_output_raw = pe_n; // fix_size(N_output, pe_n);

		sc_assert(N_output <= N_output_raw);

		int w_bw = pe_bw * db_out_n;
		w_row_N = fix_size(N_input, w_bw) + w_bw;
		// w_row_N = //fix_size(w_row_N + 1, pe_bw * db_out_n);

		sc_assert((w_row_N * N_output_raw) % dma_bw == 0);
		int size_raw = w_row_N * N_output_raw;
		dmaW.data_array = new dma_pkg::sc_data_raw[size_raw / dma_bw];
		dmaW.size = size_raw / dma_bw;

		for (int out = 0; out < N_output_raw; out++) {

			int bias_ptr_from = out * (1 + N_input);

			int bias_ptr_to = out * w_bw;

			if (out < N_output)
				insert_data_2_buf(dmaW, W[bias_ptr_from], bias_ptr_to, dma_bw);
			else
				insert_data_2_buf(dmaW, 0, bias_ptr_to, dma_bw);

			for (int in = 0; in < N_input; in++) {
				int ptr_from = (out * (1 + N_input)) + in + 1;

				int in_ptr_sub = in % w_bw;
				int in_ptr_big = in / w_bw;
				int ptr_to = ((1 + in_ptr_big) * N_output_raw * w_bw) + out * w_bw + in_ptr_sub;
				//= (out * w_row_N) + in + w_bw;
				if (out < N_output)
					insert_data_2_buf(dmaW, W[ptr_from], ptr_to, dma_bw);
				else
					insert_data_2_buf(dmaW, 0, ptr_to, dma_bw);
			}
		}
	}

	void pre_fc_output(dma_pkg & dmaY, int N_output) {
		N_output = fix_size(N_output, dma_bw);
		sc_assert((N_output) % dma_bw == 0);

		dmaY.data_array = new dma_pkg::sc_data_raw[(N_output) / dma_bw];
		dmaY.size = (N_output) / dma_bw;
	}

	int fix_size(int old, int align) {
		int tmp = (old % align);
		if (tmp == 0) {
			return old;
		} else {
			return old + (align - tmp);
		}
	}

	void realign_dma_buffer(sc_data * data, dma_pkg & dma_data, int depth, int new_depth, int dma_bw) {
		int ori_i = 0;

		for (int i = 0; i < dma_data.size * dma_bw; i++) {

			int Yindx_add = i / dma_bw;
			int Yindx_cut = i % dma_bw;
			sc_bv<P_data_W> tmp;

			if (i % new_depth < depth) {

				// tmp <<= P_data_W;
				std::cout << ori_i << ":" << (data ? data[ori_i].to_string() : "null") << std::endl;
				tmp = hwcore::hf::fixed2bv((data ? data[ori_i] : sc_data(0)));
				ori_i++;
			} else {
				tmp = 0;
			}

			dma_data.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut) = tmp;

			if (Yindx_cut == dma_bw - 1) {
				std::cout << "DMA data(" << Yindx_add << ", " << dma_data.size
				          << "): " << dma_data.data_array[Yindx_add].to_string() << std::endl;
			}
		}
	}

	void insert_data_2_buf(dma_pkg & dma_data, sc_data tmp, int idx, int _dma_bw, int data_w = P_data_W) {
		int Yindx_add = idx / _dma_bw;
		int Yindx_cut = idx % _dma_bw;
		sc_assert(Yindx_add < dma_data.size);
		sc_assert(Yindx_cut < _dma_bw);
		dma_data.data_array[Yindx_add](data_w * (Yindx_cut + 1) - 1, data_w * (Yindx_cut)) = hwcore::hf::fixed2bv(tmp);
	}

	void realign_dma_buffer_W(sc_data * data, dma_pkg & dma_data, int depth, int new_depth, int _dma_bw, int N,
	                          int w_size, int bw) {

		for (int i = 0; i < N; i++) {

			int bias_ptr_from = i * (1 + (w_size * w_size * depth));

			int pe_index_sub = i % pe_n;
			int pe_index_ptr = i / pe_n;

			// int bias_ptr_to = i * (bw + (w_size * w_size * new_depth));
			int bias_ptr_to = (pe_index_sub * bw) + (pe_index_ptr * pe_n * (bw + (w_size * w_size * new_depth)));

			insert_data_2_buf(dma_data, (data ? data[bias_ptr_from] : sc_data(0)), bias_ptr_to, _dma_bw);

			for (int x = 0; x < w_size; x++) {
				for (int y = 0; y < w_size; y++) {
					for (int z = 0; z < depth; z++) {

						int ptr_from =
						    (i * (1 + (w_size * w_size * depth))) + (x * w_size * depth) + (y * depth) + z + 1;

						int z_sub = z % pe_bw;
						int z_ptr = z / pe_bw;

						// int ptr_to = (i * (bw + (w_size * w_size * new_depth))) + (y * w_size * new_depth) +
						//             (z_ptr * w_size * pe_bw) + ((w_size - x - 1) * pe_bw) + z_sub + bw;
						int ptr_to_sub = ((y * w_size * new_depth) + (z_ptr * w_size * pe_bw) +
						                  ((w_size - x - 1) * pe_bw) + z_sub + bw);

						int ptr_to_pe_sub = ptr_to_sub % (bw);
						int ptr_to_pe_ptr = ptr_to_sub / (bw);

						int ptr_to = bias_ptr_to + ptr_to_pe_ptr * (pe_n * bw) + ptr_to_pe_sub;

						// int ptr_to = (i * (bw + (w_size * w_size * new_depth))) + (y * w_size * new_depth) +
						//             (z_ptr * w_size * pe_bw) + ((w_size - x - 1) * pe_bw) + z_sub + bw;

						// ptr_to =

						std::cout << "[x][y][z][w]=[" << x << "][" << y << "][" << z << "][" << i << "]=[from <=> to]["
						          << ptr_from << "<=>" << ptr_to << "] rel [" << ptr_from - 1 << "<=>" << ptr_to - bw
						          << "] : " << (data ? data[ptr_from].to_float() : 0.0f) << std::endl;

						insert_data_2_buf(dma_data, (data ? data[ptr_from] : sc_data(0)), ptr_to, _dma_bw);
					}
				}
			}
		}
	}

	void pre_data(sc_data * X, dma_pkg & dmaX, int image_size, int Nimages, int depth, int &new_depth) {

		new_depth = fix_size(depth, pe_bw);
		sc_assert((image_size * image_size * new_depth) % pe_bw == 0);
		dmaX.data_array = new dma_pkg::sc_data_raw[(image_size * image_size * new_depth * Nimages) / dma_bw];
		dmaX.size = (image_size * image_size * new_depth * Nimages) / dma_bw;
		realign_dma_buffer(X, dmaX, depth, new_depth, dma_bw);
	}

	void pre_data_image(sc_ufixed<8, 0> * X, dma_pkg & dmaX, int image_size, int Nimages, int &new_depth) {
		new_depth = fix_size(3, pe_bw);
		dmaX.size = (image_size * image_size * 3 * 8) / (dma_bw * P_data_W);
		sc_assert(((image_size * image_size * 3 * 8) % (dma_bw * P_data_W)) == 0);

		dmaX.data_array = new dma_pkg::sc_data_raw[dmaX.size];

		for (int x = 0; x < image_size; x++) {
			for (int y = 0; y < image_size; y++) {
				for (int z = 0; z < 3; z++) {
					int ptr_from = (x * image_size * 3) + (y * 3) + z;
					int ptr_to = (x * image_size * 3) + (y * 3) + z;

					int dma8bit_bw = (dma_bw * P_data_W) / 8;
					int Yindx_add = ptr_to / dma8bit_bw;
					int Yindx_cut = ptr_to % dma8bit_bw;
					sc_assert(Yindx_add < dmaX.size);
					sc_assert(Yindx_cut < dma8bit_bw);
					sc_assert(dma8bit_bw * 8 == dma_bw * P_data_W);
					sc_ufixed<8, 0> tmp = X[ptr_from];
					dmaX.data_array[Yindx_add](8 * (Yindx_cut + 1) - 1, 8 * (Yindx_cut)) = hwcore::hf::ufixed2bv(tmp);

					// insert_data_2_buf(dmaX, X[ptr_from], ptr_to, dma_bw, 8);
				}
			}
		}
	}

	void pre_weight(sc_data * W, dma_pkg & dmaW, int W_size, int Nwindows, int depth, int &new_depth, int &new_W_size) {
		new_depth = fix_size(depth, pe_bw);
		int tmp = fix_size(W_size * W_size, db_out_n); //(pe_bw * db_out_n) / new_depth);
		new_W_size = sqrt(tmp);
		sc_assert(((new_W_size * new_W_size * new_depth) + (pe_bw * db_out_n)) % pe_bw * db_out_n == 0);
		int bias_size = (pe_bw * db_out_n);
		dmaW.data_array =
		    new dma_pkg::sc_data_raw[(((new_W_size * new_W_size * new_depth) + bias_size) * Nwindows) / dma_bw];
		dmaW.size = (((new_W_size * new_W_size * new_depth) + bias_size) * Nwindows) / dma_bw;
		sc_assert(new_W_size == W_size);
		realign_dma_buffer_W(W, dmaW, depth, new_depth, dma_bw, Nwindows, W_size, pe_bw * db_out_n);
	}

	void pre_output(dma_pkg & dmaY, int image_size, int W_size, int depth, int Nimages, int Nwindows, int zp,
	                int stride = 1) {
		// sc_assert(stride == 1); // todo add this.
		// new_depth = fix_size(depth, pe_bw);
		int Y_size = (int)ceil(
		    ((float)image_size - ((floor(((float)W_size / 2.0f)) - (float)zp) * 2.0f / (float)stride)) / (float)stride);
		int Y_depth = fix_size(Nwindows, pe_n); // * 2;
		dmaY.data_array = new dma_pkg::sc_data_raw[(Y_size * Y_size * Y_depth * Nimages) / dma_bw];
		dmaY.size = (Y_size * Y_size * Y_depth * Nimages) / dma_bw;
	}

	void pre_process(sc_data * X, sc_data * W, dma_pkg & dmaX, dma_pkg & dmaW, dma_pkg & dmaY, int image_size,
	                 int W_size, int depth, int &new_W_size, int &new_depth, int Nimages, int Nwindows, int zp,
	                 int stride = 1) {
		sc_assert(stride == 1); // todo add this.
		new_depth = fix_size(depth, pe_bw);
		// new_depth_W = new_depth_X * db_out_n;

		{
			// sc_assert((pe_bw * db_out_n) % new_depth == 0);
			int tmp = fix_size(W_size * W_size, db_out_n); //(pe_bw * db_out_n) / new_depth);

			new_W_size = sqrt(tmp);
		}

		sc_assert((image_size * image_size * new_depth) % pe_bw == 0);
		sc_assert(((new_W_size * new_W_size * new_depth) + (pe_bw * db_out_n)) % pe_bw * db_out_n == 0);
		int bias_size = (pe_bw * db_out_n);
		dmaX.data_array = new dma_pkg::sc_data_raw[(image_size * image_size * new_depth * Nimages) / dma_bw];
		dmaX.size = (image_size * image_size * new_depth * Nimages) / dma_bw;
		dmaW.data_array =
		    new dma_pkg::sc_data_raw[(((new_W_size * new_W_size * new_depth) + bias_size) * Nwindows) / dma_bw];
		dmaW.size = (((new_W_size * new_W_size * new_depth) + bias_size) * Nwindows) / dma_bw;
		int Y_size = image_size - (((int)floor(((float)W_size / 2.0f)) - zp) * 2);
		int Y_depth = fix_size(Nwindows, pe_n); // * 2;
		dmaY.data_array = new dma_pkg::sc_data_raw[(Y_size * Y_size * Y_depth * Nimages) / dma_bw];
		dmaY.size = (Y_size * Y_size * Y_depth * Nimages) / dma_bw;

		realign_dma_buffer(X, dmaX, depth, new_depth, dma_bw);
		sc_assert(new_W_size == W_size);
		realign_dma_buffer_W(W, dmaW, depth, new_depth, dma_bw, Nwindows, W_size, pe_bw * db_out_n);
	}

	struct P_data_Pkg {
		sc_fixed<P_data_W, P_data_P> *data;
		int depth;
		int size;
		int row_size;
	};

	int do_conv(dma_pkg & X, dma_pkg & W, dma_pkg & Y, int window, int depth, int row_size, int stride, int X_N,
	            int W_N, int zp, bool raw_image_data = false, sc_ufixed<15, 1> scale = 1.0) {

		sc_time start = sc_time_stamp();
		sc_assert(depth % pe_bw == 0);
		int depth_raw = depth / pe_bw;
		sc_assert((window * window * depth) % (pe_bw * db_out_n) == 0);
		int wb_ctrl_row_N = ((window * window * depth) / (pe_bw * db_out_n)) + 1;
		int db_replay = ceil(W_N / pe_n) - 1;
		int row_size_Y = (row_size - (((int)floor((float)window / 2.0f) - zp) * 2)) / stride;
		int image_size = depth_raw * row_size * row_size; // used for align multiple images.
		// start CNNA

		do_cmd(weight_ctrl, 0 | (wb_ctrl_row_N << 20));
		// setup
		do_cmd(ctrl_image_data, (raw_image_data ? 1 : 0));
		do_cmd(ctrl_depth, depth_raw);
		do_cmd(ctrl_stride, 0); // stride
		do_cmd(ctrl_window_size, window);
		do_cmd(ctrl_row_size_pkg, row_size);
		do_cmd(ctrl_acf, 1 | (hwcore::hf::ufixed2bv<15, 1>(scale).to_uint() << 1)); // set to use ReLU
		do_cmd(ctrl_output_channel, 0);
		do_cmd(ctrl_db_output, 0);
		// setup wb
		// do_cmd(ctrl_row_N, 1); // wb_ctrl_row_N

		do_cmd(weight_ctrl, (X_N * row_size_Y * row_size_Y)); // * );
		// do_cmd(weight_ctrls_replay, row_size_Y);
		// setup db
		do_cmd(ctrl_zeropad, zp);
		do_cmd(ctrl_replay, db_replay);
		do_cmd(ctrl_image_size, image_size);
		do_cmd(ctrl_stitch_depth, 0);
		do_cmd(ctrl_stitch_buf_depth, 0);
		sc_time setup = sc_time_stamp() - start;
		// of << "paramsetup:" << (sc_time_stamp() - start).to_string() << std::endl;

		// dma magic

		dma_sink_ctrl.write(Y);
		dma_source_w_ctrl.write(W);
		dma_source_ctrl.write(X);

		dma_source_w_done.read();
		dma_source_done.read();
		std::cout << "CNNA tb write done------------------------------------------------------------------>>>"
		          << std::endl;
		dma_sink_done.read();

		std::cout << "CNNA tb done------------------------------------------------------------------<<<" << std::endl;
	}

	int do_pool(dma_pkg & X, dma_pkg & Y, int depth, int row_size, int stride, int X_N, int window, int zp) {
		// ofstream of;
		// of.open("result.txt");
		sc_time start = sc_time_stamp();
		sc_assert(depth % pe_bw == 0);
		int depth_raw = depth / pe_bw;

		int db_replay = 1;
		int row_size_Y = (row_size - (((int)floor((float)window / 2.0f) - zp) * 2)) / stride;
		int image_size = depth_raw * row_size * row_size; // used for align multiple images.
		// start CNNA

		// setup
		do_cmd(ctrl_image_data, 0);
		do_cmd(ctrl_depth, depth_raw);
		do_cmd(ctrl_stride, stride - 1); // stride
		do_cmd(ctrl_window_size, window);
		do_cmd(ctrl_row_size_pkg, row_size);
		// do_cmd(ctrl_acf, 1); // set to use ReLU
		do_cmd(ctrl_output_channel, 1);
		do_cmd(ctrl_db_output, 1);
		// setup wb
		// do_cmd(ctrl_row_N, wb_ctrl_row_N);
		// do_cmd(weight_ctrl, 0);
		// do_cmd(weight_ctrl, X_N * row_size_Y * row_size_Y); // * );
		// do_cmd(weight_ctrls_replay, row_size_Y);
		// do_cmd(ctrl_channel, 0);
		// setup db
		do_cmd(ctrl_zeropad, zp);
		do_cmd(ctrl_replay, db_replay);
		do_cmd(ctrl_image_size, image_size);
		// pool
		do_cmd(ctrl_pool_size, window);
		do_cmd(ctrl_pool_type, 0);
		do_cmd(ctrl_pool_depth, depth);
		do_cmd(ctrl_stitch_depth, 0);
		do_cmd(ctrl_stitch_buf_depth, 0);
		// do_cmd(ctrl_pool_N,0);

		sc_time setup = sc_time_stamp() - start;
		// of << "paramsetup:" << (sc_time_stamp() - start).to_string() << std::endl;

		// dma magic
		// Y.data_array
		// Y.size *= 2;
		dma_sink_ctrl.write(Y);

		// dma_source_ctrl.write(W);
		// of << "Wdone:" << (sc_time_stamp() - start).to_string() << std::endl;
		dma_source_ctrl.write(X);
		dma_source_done.read();
		// of << "Xdone:" << (sc_time_stamp() - start).to_string() << std::endl;
		std::cout << "CNNA tb write done------------------------------------------------------------------>>>"
		          << std::endl;
		dma_sink_done.read();
		// of << "done:" << (sc_time_stamp() - start).to_string() << std::endl;
		// of.close();
		std::cout << "CNNA tb done------------------------------------------------------------------<<<" << std::endl;

		for (int i = 0; i < Y.size; i++) {
			// int expected = func(a + offset, b + offset, 0, i);
			int Yindx = i;
			int Yindx_add = Yindx / dma_bw;
			int Yindx_cut = Yindx % dma_bw;
			sc_fixed<P_data_W, P_data_P> got_fix = hwcore::hf::bv2fixed<P_data_W, P_data_P>(
			    Y.data_array[Yindx_add](P_data_W * (1 + Yindx_cut) - 1, P_data_W * Yindx_cut));
			int got = got_fix.to_int();

			debug_cout << "[" << i << "]: " << got_fix.to_float() << std::endl;
			/*
			debug_cout << "[i,a,b,c]:[" << i << "," << a << "," << b << "," << c << "]- func(" << a + offset << ","
			           << b + offset << "," << 0 << "," << i << ")=[expected,got]:[" << expected << "," << got
			           << "] Yindx = " << Yindx << "==>" << Yindx_add << "." << Yindx_cut << std::endl;
			*/
		}
	}

	void do_fc(dma_pkg & X, dma_pkg & W, dma_pkg & Y, int N_in, int N_out, int X_N, int w_row_N,
	           sc_ufixed<15, 1> scale = 1.0) {
		// ofstream of;
		// of.open("result.txt");
		sc_time start = sc_time_stamp();

		sc_assert(X.size * dma_bw == N_in);
		// sc_assert(Y.size * dma_bw == N_out);
		// sc_assert(W.size * dma_bw <= w_row_N * N_out);

		// sc_assert(depth % pe_bw == 0);
		int depth_raw = 1;
		sc_assert((w_row_N) % (pe_bw * db_out_n) == 0);
		int wb_ctrl_row_N = ((w_row_N) / (pe_bw * db_out_n));
		int db_replay = ((N_out) / pe_n) - 1;
		sc_assert(db_replay == 0);
		int row_size_Y = N_out;
		int image_size = (N_in / pe_bw); // used for align multiple images.

		// setup
		do_cmd(ctrl_image_data, 0);
		do_cmd(ctrl_depth, 0);
		do_cmd(ctrl_stride, 0); // stride
		do_cmd(ctrl_window_size, 0);
		do_cmd(ctrl_row_size_pkg, (N_in / pe_bw));
		do_cmd(ctrl_acf, 0 | (hwcore::hf::ufixed2bv<15, 1>(scale).to_uint() << 1)); // set to use ReLU
		do_cmd(ctrl_output_channel, 0);
		do_cmd(ctrl_db_output, 0);
		// setup wb
		// do_cmd(ctrl_row_N, 1);
		do_cmd(weight_ctrl, 1 << 30);
		// do_cmd(weight_ctrl, X_N); // * );
		// do_cmd(weight_ctrls_replay, row_size_Y);
		// setup db
		do_cmd(ctrl_zeropad, 0);
		do_cmd(ctrl_replay, db_replay);
		do_cmd(ctrl_image_size, image_size);
		do_cmd(ctrl_stitch_depth, 0);
		do_cmd(ctrl_stitch_buf_depth, 0);
		sc_time setup = sc_time_stamp() - start;
		// of << "paramsetup:" << (sc_time_stamp() - start).to_string() << std::endl;

		// dma magic
		dma_sink_ctrl.write(Y);
		dma_source_w_ctrl.write(W);
		dma_source_ctrl.write(X);

		dma_source_w_done.read();
		dma_source_done.read();
		std::cout << "CNNA tb write done------------------------------------------------------------------>>>"
		          << std::endl;
		dma_sink_done.read();

		std::cout << "CNNA tb done------------------------------------------------------------------<<<" << std::endl;
	}

	sc_fifo<dma_pkg> dma_source_ctrl;
	sc_fifo<uint64> dma_source_done;

	void dma_source_thread() {
		while (true) {
			dma_pkg tmp = dma_source_ctrl.read();

			for (int i = 0; i < tmp.size; i++) {
				hwcore::pipes::sc_data_stream_t<P_input_width> tmp_out;
				tmp_out.data = tmp.data_array[i];
				tmp_out.tlast = (i == tmp.size - 1);
				tmp_out.setKeep();
				dma_source.write(tmp_out);
				HLS_DEBUG(1, 1, 0, "dma_x_source sending new data[%d,%d]: %s.", i + 1, tmp.size,
				          tmp_out.data.to_string().c_str());
			}
			HLS_DEBUG(1, 1, 0, "done");
			dma_source_done.write(tmp.size);
		}
	}

	sc_fifo<dma_pkg> dma_source_buf_ctrl;
	sc_fifo<uint64> dma_source_buf_done;

	void dma_source_buf_thread() {
		while (true) {
			dma_pkg tmp = dma_source_buf_ctrl.read();

			for (int i = 0; i < tmp.size; i++) {
				hwcore::pipes::sc_data_stream_t<P_input_width> tmp_out;
				tmp_out.data = tmp.data_array[i];
				tmp_out.tlast = (i == tmp.size - 1);
				tmp_out.setKeep();
				dma_buf_source.write(tmp_out);
				HLS_DEBUG(1, 1, 0, "dma_buf_source sending new data[%d,%d]: %s.", i + 1, tmp.size,
				          tmp_out.data.to_string().c_str());
			}
			HLS_DEBUG(1, 1, 0, "done");
			dma_source_buf_done.write(tmp.size);
		}
	}

	sc_fifo<dma_pkg> dma_source_w_ctrl;
	sc_fifo<uint64> dma_source_w_done;

	void dma_source_w_thread() {
		while (true) {
			dma_pkg tmp = dma_source_w_ctrl.read();

			for (int i = 0; i < tmp.size; i++) {
				hwcore::pipes::sc_data_stream_t<P_input_width> tmp_out;
				tmp_out.data = tmp.data_array[i];
				tmp_out.tlast = (i == tmp.size - 1);
				tmp_out.setKeep();
				dma_w_source.write(tmp_out);
				HLS_DEBUG(1, 1, 0, "dma_w_source sending new data[%d,%d]: %s.", i + 1, tmp.size,
				          tmp_out.data.to_string().c_str());
			}
			HLS_DEBUG(1, 1, 0, "done");
			dma_source_w_done.write(tmp.size);
		}
	}

	sc_fifo<sc_uint<64> > dma_source_ctrl_ctrl;

	void dma_source_ctrl_thread() {
		while (true) {
			sc_uint<64> tmp = dma_source_ctrl_ctrl.read();
			hwcore::pipes::sc_data_stream_t<64> tmp_out;
			tmp_out.setKeep();
			tmp_out.data = tmp;
			tmp_out.tlast = 1;

			dma_ctrl_source.write(tmp_out);
			HLS_DEBUG(1, 1, 0, "dma_ctrl_source sending new data: %s.", tmp_out.data.to_string().c_str());
		}
	}

	sc_fifo<dma_pkg> dma_sink_ctrl;
	sc_fifo<uint64> dma_sink_done;

#if 0
	void live_debug()
	{
		for(int x= 0; x < 14; x++)
		{
			for(int y=0; y < 14 ; y++)
			{
				for(int )
			}
		}
	}
#endif

	void dma_sink_thread() {
		while (true) {
			uint64 size = 0;
			dma_pkg tmp = dma_sink_ctrl.read();

			for (int i = 0; i < tmp.size; i++) {
				size++;
				hwcore::pipes::sc_data_stream_t<P_input_width> tmp_in;
				dma_sink.read(tmp_in);
				tmp.data_array[i] = tmp_in.data;
				HLS_DEBUG(1, 1, 0, "dma_sink got new data[%d,%d]: %s.", i + 1, tmp.size,
				          tmp_in.data.to_string().c_str());
				// sc_assert((tmp_in.tlast == 0 && i != tmp.size - 1) || (tmp_in.tlast == 1 && i == tmp.size - 1));
				if (tmp_in.tlast == 1) {
					// sc_assert(i == tmp.size - 1);
					break;
				}
			}
			HLS_DEBUG(1, 1, 0, "done");
			dma_sink_done.write(size);
		}
	}

	virtual ~tb_cnn_2d() { sc_close_vcd_trace_file(tracePtr); }
};
