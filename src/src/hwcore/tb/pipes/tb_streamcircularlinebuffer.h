#pragma once
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/stream2Dwindow2vec.h"
#include "hwcore/pipes/streamcircularlinebuffer.h"
#include "hwcore/pipes/streamsplit.h"
#include <systemc.h>

//#define debug_cout std::cout << "[" << sc_time_stamp().to_string() << "] - " << __FILE__ << " - "

template <int W, int N_rows> SC_MODULE(tb_top_streamcircularlinebuffer) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N_rows>::interface_T interface_out_T;
	sc_clock clk;
	sc_in<bool> iclk;
	sc_signal<bool> reset;

	hwcore::pipes::sc_stream_circularlinebuffer<W, N_rows, 1024, 1024> clb;

	// hwcore::pipes::sc_stream_2D_2_vec<W, N_rows, 1024> m2d2vec;

	sc_fifo<interface_T> din;      // in
	sc_fifo<interface_out_T> dout; //, doutA, doutB, dout_vec; // out
	// hwcore::pipes::sc_stream_splitter_clone<interface_out_T, 2> split_dout;
	// sc_fifo<int> ctrl_row_size_pkg; // in clb
	// sc_fifo<int> ctrl_stride;       // in clb

	sc_fifo<sc_uint<16> > ctrl_row_size_pkg;
	sc_fifo<sc_uint<16> > ctrl_window_size;
	sc_fifo<sc_uint<16> > ctrl_depth;
	sc_fifo<sc_uint<16> > ctrl_stride;
	sc_fifo<sc_uint<16> > ctrl_replay;
	sc_fifo<sc_uint<16> > ctrl_zeropad;

	sc_fifo<int> output;
	sc_fifo<int> last;

	int _replay[2];
	int _size[2];
	int _channels[2];
	int _stride[2];
	int _w[3];

	SC_CTOR(tb_top_streamcircularlinebuffer)
	    : clk("clock", sc_time(10, SC_NS)), clb("clb"), din(1), dout(1), ctrl_row_size_pkg(1), ctrl_window_size(1),
	      ctrl_depth(1), ctrl_stride(1), ctrl_replay(1), ctrl_zeropad(1), output(1), last(1), _replay({1, 2}),
	      _size({8, 12}), _channels({1, 3}), _stride({1 - 1, 3 - 1}), _w({1, 3, N_rows}) {
		iclk(clk);
		clb.clk(clk);
		clb.reset(reset);
		clb.din(din);
		clb.ctrl_row_size_pkg(ctrl_row_size_pkg);
		clb.ctrl_window_size(ctrl_window_size);
		clb.ctrl_depth(ctrl_depth);
		clb.ctrl_stride(ctrl_stride);
		clb.ctrl_replay(ctrl_replay);
		clb.ctrl_zeropad(ctrl_zeropad);
		clb.dout(dout);

		SC_CTHREAD(waveform, iclk.pos());
		// SC_CTHREAD(monitor, iclk.pos());
		// SC_CTHREAD(monitor_vec_no_asserts, iclk.pos());
		SC_THREAD(downsize);
		SC_THREAD(monitor_vec);
	}

	int func(int a, int b, int c = 0) {
		int tmp = ((a & 0xFF) << 16) | ((b & 0xFF) << 8) | ((c & 0xFF) << 0);

		return tmp;
	}

	void func_inv(int in, int &a, int &b, int &c) {
		a = (in >> 16) & 0xFF;
		b = (in >> 8) & 0xFF;
		c = (in >> 0) & 0xFF;
	}

	void waveform() {
		debug_cout << " - [waveform start]" << std::endl;
		wait();
		interface_T tmp_out;
		reset.write(1);
		for (int i = 0; i < 5; i++)
			wait();
		reset.write(0);

		for (int re_i = 0; re_i < 2; re_i++) {
			int re = _replay[re_i];
			for (int size_i = 0; size_i < 2; size_i++) // size
			{
				int size = _size[size_i];
				for (int channels_i = 0; channels_i < 2; channels_i++) // N channels
				{
					int channels = _channels[channels_i];
					for (int stride_i = 0; stride_i < 2; stride_i++) // stride row only
					{
						int stride = _stride[stride_i];
						for (int w_i = 0; w_i < 3; w_i++) {
							int w = _w[w_i];
							ctrl_row_size_pkg.write(size);
							ctrl_depth.write(channels);
							ctrl_window_size.write(w);

							ctrl_stride.write(stride);
							ctrl_replay.write(re);
							ctrl_zeropad.write(0);
							// ctrl_stride_vec.write(stride);
							// ctrl_N_channels_vec.write(channels);
							// ctrl_N_row_pkg_vec.write(size);
							// ctrl_size_vec.write(N_rows); //warning Need to explore here

							for (int a = 0; a < size; a++) {
								for (int b = 0; b < size; b++) {
									for (int c = 0; c < channels; c++) {
										tmp_out.data = func(a, b, c);
										tmp_out.setKeep();
										tmp_out.tlast = (a == size - 1 && b == size - 1 && c == channels - 1 ? 1 : 0);
										debug_cout << "(waveform)[size,chan,stride,w_size,replay]=[" << size << ","
										           << channels << "," << stride << "," << w << "," << re
										           << "],[a,b,c]=[" << a << "," << b << "," << c << "][data]=["
										           << func(a, b, c) << "]" << std::endl;
										din.write(tmp_out);
									}
								}
							}
							debug_cout << "(waveform)[EOP]" << std::endl;

							tmp_out.setEOP();
							din.write(tmp_out);
						}
					}
				}
			}
		}
		tmp_out.setEOP();
		din.write(tmp_out);
		debug_cout << " - [waveform done]" << std::endl;
		while (true) {
			wait();
		}
	}
#if 0
    void monitor()
    {
        debug_cout << " - [waveform monitor]" << std::endl;
        sc_int<W> tmp[N_rows];
        interface_out_T tmp_in;

        for (int size = 1; size < 32 + 1; size *= 2) //size
        {
            for (int channels = 1; channels < 4; channels++) // N channels
            {
                for (int stride = 0; stride < 6; stride += 3) // stride row only
                {

                    for (int a = 0; a < size; a++)
                    {
                        bool stride_skip = (a % (stride + 1) == 0 ? false : true);
                        if (!stride_skip)
                        {

                            for (int b = 0; b < size; b++)
                            {
                                for (int c = 0; c < channels; c++)
                                {
                                    doutB.read(tmp_in);
                                    tmp_in.template getData<sc_int, W, N_rows>(tmp);
                                    for (int w = 0; w < N_rows; w++)
                                    {

                                        if (w <= a)
                                        {
                                            debug_cout << "(monitor)[size,chan,stride]=[" << size << "," << channels << "," << stride << "],[a,b,c,w]=[" << a << "," << b << "," << c << "," << w << "][data]=[" << tmp[N_rows - w - 1].to_int() << "]<=>[expected][" << func(a - w, b, c) << "]" << std::endl;
                                            sc_assert(func(a - w, b, c) == tmp[N_rows - w - 1].to_int());
                                        }
                                    }
                                }
                            }
                        }
                    }
                    doutB.read(tmp_in);
                    debug_cout << "(monitor)[size,chan,stride]=[" << size << "," << channels << "," << stride << "] looking for EOP" << std::endl;
                    sc_assert(tmp_in.EOP());
                }
            }
        }

        sc_stop();

        while (true)
        {
            wait();
        }
    }

    void monitor_vec_no_asserts()
    {
        debug_cout << " - [waveform 2D2vec monitor - no asserts]" << std::endl;
        sc_int<W> tmp[N_rows];
        interface_out_T tmp_in;
        while (true)
        {
            dout_vec.read(tmp_in);
            tmp_in.template getData<sc_int, W, N_rows>(tmp);
            for (int w = 0; w < N_rows; w++)
            {
                debug_cout << "(monitor_vec)[w,data]=[" << w << "," << tmp[N_rows - w - 1].to_int() << std::endl;
            }
        }
    }
#endif

#if 1

	void downsize() {
		interface_out_T tmp_in;
		sc_int<W> data[N_rows];
		while (true) {
			dout.read(tmp_in);

			debug_cout << "got data: " << tmp_in.data.to_string() << std::endl;

			tmp_in.template getData<sc_int, W, N_rows>(data);
			if (!tmp_in.EOP()) {
				for (int i = N_rows - 1; i >= 0; i--) {
					// debug_cout << "data: " << data[i].to_int() << std::endl;

					if (tmp_in.template getKeep<W>(i) == 1) {
						debug_cout << "forward data: " << data[i].to_int() << std::endl;
						last.write(tmp_in.tlast.to_int());
						output.write(data[i].to_int());
					}
				}
			}
		}
	}

	void conv2d(int size, int channels, int stride, int window_size, int row_replay) {
		debug_cout << "new image ---------------------- " << std::endl;
		for (int a = window_size - 1; a < size; a++) {
			if ((a - window_size + 1) % (stride) != 0)
				continue;

			for (int b = window_size - 1; b < size; b++) {
				if ((b - window_size + 1) % (stride) != 0)
					continue;

				for (int re = 0; re < row_replay; re++) {
					for (int wb = 0; wb < window_size; wb++) {
						for (int c = channels - 1; c >= 0; c--) {
							for (int wa = 0; wa < window_size; wa++) {
								int data = output.read();
								int tlast = last.read();

								int _a, _b, _c;
								func_inv(data, _a, _b, _c);

								debug_cout << "[size,chan,stride,wSize,replay]=[" << size << "," << channels << ","
								           << stride << "," << window_size << "," << row_replay << "]"
								           << " - [a,b,wa,wb,c,re]=[" << a << "," << b << "," << wa << "," << wb << ","
								           << c << "," << re << "]"
								           << " - (got <=> expected) = (" << data << " <=> " << func(a - wa, b - wb, c)
								           << ") is last? " << (tlast ? "true" : "false") << std::endl;
								debug_cout << "data pos [_a,_b,_c] = " << _a << ", " << _b << ", " << _c << std::endl;
// sc_assert(data == func(a - wa, b - wb, c));
#warning fix this function !!!
							}
						}
					}
				}
			}
		}
		debug_cout << "---------- done --------" << std::endl;
	}

	void monitor_vec() {
		for (int re_i = 0; re_i < 2; re_i++) {
			int re = _replay[re_i];
			for (int size_i = 0; size_i < 2; size_i++) // size
			{
				int size = _size[size_i];
				for (int channels_i = 0; channels_i < 2; channels_i++) // N channels
				{
					int channels = _channels[channels_i];
					for (int stride_i = 0; stride_i < 2; stride_i++) // stride row only
					{
						int stride = _stride[stride_i];
						for (int w_i = 0; w_i < 3; w_i++) {
							int w = _w[w_i];
							conv2d(size, channels, stride + 1, w, re);
							debug_cout << "Image done" << std::endl;
							debug_cout << "[size,chan,stride,wSize]=[" << size << "," << channels << "," << stride
							           << "," << w << "]" << std::endl;
						}
					}
				}
			}
		}
		sc_stop();
	}
#endif
};
