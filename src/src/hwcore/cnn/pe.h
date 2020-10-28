/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

template <int W, int P, int Wout, int Pout> SC_MODULE(Summer) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * Wout>::interface_T dout_T;
	sc_in<bool> clk;
	sc_in<bool> reset;

	enum { linear = 0, ReLU = 1 };

	sc_fifo_in<interface_T> din;

	sc_fifo_out<dout_T> dout;

	sc_fifo_in<sc_uint<16> > ctrl_acf;

	sc_out_opt<int> count_out;

	void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(din);
		// SC_TRACE_ADD(dout);
	}

	SC_CTOR_TEMPLATE(Summer) {
		SC_CTHREAD(PE_sum_thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void PE_sum_thread() {
		HLS_DEBUG(1, 1, 0, "init thread");
		sc_fixed<W, P, SC_RND, SC_SAT> sum = 0;
		int count = 0;
		count_out.write(count);
		interface_T tmp_i;
		dout_T tmp_out;
		while (true) {
			hls_loop();
			sum = 0;
			sc_uint<16> acf = ctrl_acf.read();
			sc_uint<15> raw_scale = acf(15, 1);
			sc_bv<15> tmp = raw_scale;

			sc_fixed<16, 2, SC_RND, SC_SAT> scale = hwcore::hf::bv2ufixed<15, 1>(tmp);
			do {
				hls_pipeline(1);
				din.read(tmp_i);

				if (tmp_i.EOP()) {
					tmp_out.setEOP();
					dout.write(tmp_out);

				} else {
					sc_fixed<W, P> tmp_in = hwcore::hf::bv2fixed<W, P>(tmp_i.data);
					sum = sum + (sc_fixed<W, P, SC_RND, SC_SAT>)tmp_in;
					HLS_DEBUG(1, 1, 32, "PE_summer[%d] -- got: %f, sum: %f", count,
					          hwcore::hf::bv2fixed<W, P>(tmp_i.data).to_float(), sum.to_float());
					if (tmp_i.tlast) {
						sum = sum * scale;
						switch (acf[0]) {
						case 1:
							sum = (sum <= sc_fixed<W, P, SC_RND, SC_SAT>(0) ? sc_fixed<W, P, SC_RND, SC_SAT>(0) : sum);
							break;
						case 0:
							break;
						default:
							break;
						}

						sc_fixed<Wout, Pout, SC_RND, SC_SAT> tmp_out;
						tmp_out = (sc_fixed<Wout, Pout, SC_RND, SC_SAT>)sum;
						sc_fixed<Wout, Pout> tmp_out_raw = tmp_out;

						dout_T tmp_O(hwcore::hf::fixed2bv<Wout, Pout>(tmp_out_raw), false);

						if (tmp_i.unValid()) {
							tmp_O.setUnvalid(1);
						} else {
							tmp_O.setKeep();
						}

						HLS_DEBUG(1, 1, 32, "PE_summer[%d] -- writing: %s", count, tmp_O.data.to_string().c_str());
						count++;
						count_out.write(count);
						dout.write(tmp_O);
						sum = 0;
					}
				}

			} while (!tmp_i.EOP());
		}
	}
};

/*template <int W, int P, int N, int N_DSP>
SC_MODULE(PE_with_skip)
{

    const int c_N_DSP;

    sc_in<bool> clk;
    sc_in<bool> reset;

    sc_fifo_in<hwcore::pipes::sc_data_stream_t<W * N> > Win;
    sc_fifo_in<hwcore::pipes::sc_data_stream_t<(W * N)> > Xin; //, true, N

    sc_fifo<hwcore::pipes::sc_data_stream_t<W> > Add_Sum_s;

    sc_fifo_out<hwcore::pipes::sc_data_stream_t<W> > dout;

    SC_CTOR_DEFAULT(PE_with_skip)
        : c_N_DSP(N_DSP)
    {

        SC_CTHREAD(PE_IN_thread, clk.pos());
        reset_signal_is(reset, true);
        SC_CTHREAD(PE_sum_thread, clk.pos());
        reset_signal_is(reset, true);
    }

    void PE_sum_thread()
    {
        HLS_DEBUG(1, 1, 0, "init thread");
        sc_fixed<W, P> sum = 0;

        while (true)
        {
            hwcore::pipes::sc_data_stream_t<W> tmp_i;

            IF_SC_FIFO_NB_READ_FLUSH(Add_Sum_s, tmp_i)
            {
                sum += hwcore::hf::bv2fixed<W, P>(tmp_i.data);

                if (tmp_i.tlast)
                {
                    hwcore::pipes::sc_data_stream_t<W> tmp_O(hwcore::hf::fixed2bv<W, P>(sum), true);
                    dout.write(tmp_O);
                    sum = 0;
                }
            }
        }
    }

    void PE_IN_thread()
    {
        HLS_DEBUG(1, 1, 0, "init thread");
        while (true)
        {
            //wait();

            //if(Win.num_available() != 0 && Xin.num_available() != 0)
            //{
            hwcore::pipes::sc_data_stream_t<(W * N)> tmp_W = Win.read();

            hwcore::pipes::sc_data_stream_t<(W * N)> tmp_X = Xin.read();

            sc_fixed<W, P> W_in[N];
#pragma HLS array_partition variable = W complete
            sc_fixed<W, P> X[N];
#pragma HLS array_partition variable = X complete

            tmp_W.getDataFixed<W, P, N>(W_in);
            tmp_X.getDataFixed<W, P, N>(X);

            hwcore::pipes::sc_data_stream_t<W> tmp_i(0, tmp_X.tlast);

            sc_fixed<W, P> tmp_sum = 0;
            for (int a = 0; a < N / N_DSP; a++)
            {
#pragma HLS pipeline II = 1
                if (a * (N / N_DSP) >= tmp_X.tkeep)
                    break;

                sc_fixed<W, P> MUL_TMP[N_DSP];

            MUL:
                for (int b = 0; b < N_DSP; b++)
                {
#pragma HLS unroll factor = c_N_DSP

                    MUL_TMP[b] = X[(a * N_DSP) + b] * W_in[(a * N_DSP) + b];
                }

            SUM:
                for (int b = 0; b < N_DSP; b++)
                {
#pragma HLS unroll factor = c_N_DSP

                    tmp_sum += MUL_TMP[b];
                }
            }
            tmp_i.data = hwcore::hf::fixed2bv<W, P>(tmp_sum);
            tmp_i.setKeep();
            Add_Sum_s.write(tmp_i);

            //}
        }
    }
};*/

template <int W, int P, int N, int pipeline_II = 1, int unroll_factor = (N / pipeline_II),
          int sum_exstra_bit = hwcore::hf::log2_ceil<N>::val>
SC_MODULE(_PE) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W *(N + 1)>::interface_T in_W_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * 2 + sum_exstra_bit>::interface_T sum_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T out_T;
	const int c_N, c_N_half;
	Summer<(W * 2) + sum_exstra_bit, (P * 2) + sum_exstra_bit, W, P> Sum;

	sc_in<bool> clk;
	sc_in<bool> reset;

	sc_fifo_in<in_W_T> Win;
	sc_fifo_in<in_T> Xin;
	sc_fifo_in<sc_uint<16> > ctrl_acf;

	sc_fifo<sum_T> Add_Sum_s;

	// sc_fifo<hwcore::pipes::sc_data_stream_t<W> > dout_fifo;
	sc_fifo_out<out_T> dout;

	sc_out_opt<int> count_pe;
	sc_out_opt<int> count_out;

	sc_signal<int> count_out_i;
	void forward_port() { count_out.write(count_out_i.read()); }

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(Win);
		// SC_TRACE_ADD(Xin);
		SC_TRACE_ADD_MODULE(Add_Sum_s);
		SC_TRACE_ADD_MODULE(Sum);
		// SC_TRACE_ADD(dout);
	}

	SC_CTOR_TEMPLATE(_PE) : c_N(N), c_N_half(N / 2), SC_INST(Sum) {
		// HLS_DEBUG(1, 1, 0, "init");
		Sum.din(Add_Sum_s);
		Sum.dout(dout);
		Sum.clk(clk);
		Sum.reset(reset);
		Sum.count_out(count_out_i);
		Sum.ctrl_acf(ctrl_acf);
		SC_METHOD(forward_port);
		sensitive << count_out_i;
		// dout(dout_fifo);

		SC_CTHREAD(PE_thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void PE_thread() {
		HLS_DEBUG(1, 1, 0, "init thread");
		int count = 0;
		count_pe.write(count);
		sum_T tmp_i;
		while (true) {
			hls_loop();

			HLS_DEBUG(1, 1, 1, "PE enter main loop");
			in_W_T tmp_W = Win.read();
			HLS_DEBUG(1, 1, 32, "PE got W data: %s", tmp_W.data.to_string().c_str());
			in_T tmp_X = Xin.read();
			HLS_DEBUG(1, 1, 32, "PE got X data: %s", tmp_X.data.to_string().c_str());

			if (tmp_W.EOP()) // forward EOP signal
			{

				tmp_i.setEOP();
				Add_Sum_s.write(tmp_i);
			} else if (tmp_W.unValid()) // inactive no more task for this layer for this PE.
			{
				do {
					hls_pipeline(1);

					wait_approx();
					tmp_X = Xin.read();
					tmp_i.setUnvalid(tmp_X.tlast);
					Add_Sum_s.write(tmp_i);
				} while (tmp_X.tlast == 0); // todo fixme
			} else                          // do
			{
				do {

					hls_pipeline(pipeline_II);

					sc_fixed<W, P> W_in[N + 1];
					hls_array_partition_complete(W_in);

					sc_fixed<W, P> X[N];
					hls_array_partition_complete(X);

					tmp_W.template getDataFixed<W, P, N + 1>(W_in);
					tmp_X.template getDataFixed<W, P, N>(X);
					// sc_assert(tmp_W.tlast)
					if (tmp_W.tlast != tmp_X.tlast) {
						HLS_DEBUG(1, 1, 0, "tmp_W.tlast %d", tmp_W.tlast.to_int());
						HLS_DEBUG_EXEC(sc_assert(tmp_W.tlast == tmp_X.tlast));
					}

					tmp_i.data = 0;
					tmp_i.tlast = tmp_W.tlast;
					tmp_i.setKeep();
					sc_fixed<W * 2, P * 2, SC_RND, SC_SAT> prods[N];
					hls_array_partition_complete(prods);
					sc_fixed<W * 2, P * 2, SC_RND, SC_SAT> bias;

				MULLOOP:
					for (int i = 0; i < N; i++) {
						hls_unroll_factor(unroll_factor);
						prods[i] = (sc_fixed<W, P, SC_RND, SC_SAT>)W_in[i] * (sc_fixed<W, P, SC_RND, SC_SAT>)X[i];
						HLS_DEBUG(1, 1, 32, "PE[%d] -- calculation : W: %f, X:(%s) %f, prod[%d]: %f", count,
						          W_in[i].to_float(), X[i].to_hex().c_str(), X[i].to_float(), i, prods[i].to_float());
					}

					bias =
					    (sc_fixed<W, P, SC_RND, SC_SAT>)W_in[(N + 1) - 1] * sc_fixed<W * 2, P * 2, SC_RND, SC_SAT>(1);

					sc_fixed<W * 2 + sum_exstra_bit, P * 2 + sum_exstra_bit, SC_RND, SC_SAT> sum = 0;
					sum = (sc_fixed<(W * 2) + sum_exstra_bit, (P * 2) + sum_exstra_bit, SC_RND, SC_SAT>)bias;

				SUMLOOP:
					for (int i = 0; i < N; i++) {
						hls_unroll_factor(unroll_factor);
						sum += (sc_fixed<(W * 2) + sum_exstra_bit, (P * 2) + sum_exstra_bit, SC_RND, SC_SAT>)prods[i];
					}
					tmp_i.data = hwcore::hf::fixed2bv<(W * 2) + sum_exstra_bit, (P * 2) + sum_exstra_bit>(sum);
					HLS_DEBUG(1, 1, 32, "PE[%d] -- write -- calculation sum: %f", count, sum.to_float());

					Add_Sum_s.write(tmp_i);
					HLS_DEBUG(1, 1, 32, "PE[%d] -- write -- done");

					// waiting on the next samples.
					// count++;
					// count_pe.write(count);
					tmp_W = Win.read();
					HLS_DEBUG(1, 1, 32, "PE[%d] got W data last(%d): %s", count, tmp_W.tlast.to_int(),
					          tmp_W.data.to_string().c_str());
					tmp_X = Xin.read(); //, true, N
					HLS_DEBUG(1, 1, 32, "PE[%d] got X data last(%d): %s", count, tmp_X.tlast.to_int(),
					          tmp_X.data.to_string().c_str());
				} while (!tmp_X.EOP());
				if (tmp_X.EOP() != tmp_W.EOP()) {
					HLS_DEBUG_EXEC(sc_assert(tmp_X.EOP() == tmp_W.EOP()));
				}
				tmp_i.setEOP();
				Add_Sum_s.write(tmp_i);
			}
		}
	}
};

template <int W, int P, int N, int pipeline_II = 1, int unroll_factor = (N / pipeline_II),
          int sum_exstra_bit = 0> // hwcore::hf::log2_ceil<N / 2>::val>
SC_MODULE(_PE_v2) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W *(N + 1)>::interface_T in_W_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * 2 + sum_exstra_bit>::interface_T sum_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T out_T;
	const int c_N, c_N_half;
	Summer<(W * 2) + sum_exstra_bit, (P * 2) + sum_exstra_bit, W, P> Sum;

	sc_in<bool> clk;
	sc_in<bool> reset;

	sc_fifo_in<in_W_T> Win;
	sc_fifo_in<in_T> Xin;
	sc_fifo_in<sc_uint<16> > ctrl_acf;

	sc_fifo<sum_T> Add_Sum_s;

	// sc_fifo<hwcore::pipes::sc_data_stream_t<W> > dout_fifo;
	sc_fifo_out<out_T> dout;

	// sc_out_opt<int> count_pe;
	// sc_out_opt<int> count_out;

	// sc_signal<int> count_out_i;
	// void forward_port() { count_out.write(count_out_i.read()); }

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(Win);
		// SC_TRACE_ADD(Xin);
		SC_TRACE_ADD_MODULE(Add_Sum_s);
		SC_TRACE_ADD_MODULE(Sum);
		// SC_TRACE_ADD(dout);
	}

	SC_CTOR_TEMPLATE(_PE_v2) : c_N(N), c_N_half(N / 2), SC_INST(Sum) {
		// HLS_DEBUG(1, 1, 0, "init");
		Sum.din(Add_Sum_s);
		Sum.dout(dout);
		Sum.clk(clk);
		Sum.reset(reset);
		// Sum.count_out(count_out_i);
		Sum.ctrl_acf(ctrl_acf);
		// SC_METHOD(forward_port);
		// sensitive << count_out_i;
		// dout(dout_fifo);

		SC_CTHREAD(PE_thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void PE_thread() {
		HLS_DEBUG(1, 1, 0, "init thread");
		sum_T tmp_i;
		in_W_T tmp_W;
		in_T tmp_X;
		while (true) {
			do {
				hls_pipeline(pipeline_II);

				tmp_W = Win.read();
				HLS_DEBUG(10, 1, 32, "PE got W data: %s", tmp_W.data.to_string().c_str());
				tmp_X = Xin.read();
				HLS_DEBUG(10, 1, 32, "PE got X data: %s", tmp_X.data.to_string().c_str());

				sc_fixed<W, P> W_in[N + 1];
				hls_array_partition_complete(W_in);

				sc_fixed<W, P> X[N];
				hls_array_partition_complete(X);

				tmp_W.template getDataFixed<W, P, N + 1>(W_in);
				tmp_X.template getDataFixed<W, P, N>(X);

				HLS_DEBUG_EXEC(if (tmp_W.tlast != tmp_X.tlast) {
					HLS_DEBUG(1, 1, 0, "tmp_W.tlast %d", tmp_W.tlast.to_int());
					sc_assert(tmp_W.tlast == tmp_X.tlast);
				} if (tmp_X.EOP() != tmp_W.EOP()) { sc_assert(tmp_X.EOP() == tmp_W.EOP()); });

				sc_fixed<W * 2, P * 2, SC_RND, SC_SAT> bias;

				bias = (sc_fixed<W, P, SC_RND, SC_SAT>)W_in[(N + 1) - 1] * sc_fixed<W * 2, P * 2, SC_RND, SC_SAT>(1);

				sc_fixed<W * 2 + sum_exstra_bit, P * 2 + sum_exstra_bit, SC_RND, SC_SAT> sum = 0;
				sum = (sc_fixed<(W * 2) + sum_exstra_bit, (P * 2) + sum_exstra_bit, SC_RND, SC_SAT>)bias;

			DSP_LOOP:
				for (int i = 0; i < N; i++) {
					hls_unroll_factor(unroll_factor);
					sum = sum + (sc_fixed<W * 2, P * 2, SC_RND, SC_SAT>)(W_in[i] * X[i]);

					HLS_DEBUG(10, 1, 32, "PE[%d] -- calculation : W: %f, X:(%s) %f, prod[%d]: %f", 0,
					          W_in[i].to_float(), X[i].to_hex().c_str(), X[i].to_float(), i,
					          (sc_fixed<W * 2, P * 2, SC_RND, SC_SAT>)(W_in[i] * X[i]).to_float());
				}

				tmp_i.data = hwcore::hf::fixed2bv<(W * 2) + sum_exstra_bit, (P * 2) + sum_exstra_bit>(sum);
				HLS_DEBUG(1, 1, 32, "PE[%d] -- write -- calculation sum: %f", 0, sum.to_float());
				if (tmp_X.EOP()) {
					tmp_i.setEOP();
				} else {
					tmp_i.tlast = tmp_X.tlast;
					tmp_i.setKeep();
				}

				Add_Sum_s.write(tmp_i);
				HLS_DEBUG(1, 1, 32, "PE[%d] -- write -- done");
			} while (!tmp_X.EOP());
		}
	}
};

namespace hwcore {
namespace cnn {
template <int W, int P, int N, int pipeline_II = 1> using PE = ::_PE_v2<W, P, N, pipeline_II>;
} // namespace cnn
} // namespace hwcore
