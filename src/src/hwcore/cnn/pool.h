#pragma once
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

#define T_pool_size 1024
template <int W, int I, int BW_N, int Nin, int T_pool_size_ignore = 1024, int Nout = 1, int BW_N_double = BW_N * 2>
SC_MODULE(_sc_pooling) {

	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nin * BW_N>::interface_T din_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nout * BW_N>::interface_T dout_T;

	enum { eMAX = 0, eMIN, eAVG };
	const int buffer_factor;

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<din_T> din;
	sc_fifo_out<dout_T> dout;

	sc_fifo_in<sc_uint<16> > ctrl_depth;
	sc_fifo_in<sc_uint<16> > ctrl_type;
	sc_fifo_in<sc_uint<16> > ctrl_N;
	sc_fifo_in<sc_uint<16> > ctrl_pooling_size;

	SC_CTOR(_sc_pooling) : buffer_factor(BW_N * 2) {
		SC_CTHREAD(pooling_thread, clk.pos());
		reset_signal_is(reset, true);
		HLS_DEBUG_EXEC(sc_assert(T_pool_size >= 1024));
	}

	void pooling_thread() {

		sc_fixed<W, I, SC_TRN, SC_SAT> buffer[T_pool_size / BW_N][BW_N];
		hls_array_partition(buffer, cyclic factor = Nin);
#pragma HLS resource variable = buffer core = RAM_2P_BRAM

		while (true) {
			hls_loop();
			sc_uint<16> depth = ctrl_depth.read();
			int type = ctrl_type.read();
			int pooling_size = ctrl_pooling_size.read();
			int N = 0;
			sc_fixed<W, I, SC_TRN, SC_SAT> scale = 0;
			/*if (type == eAVG) {
			    N = ctrl_N.read();
			    scale = sc_fixed<W, I, SC_TRN, SC_SAT>(1.0) / (sc_fixed<W, I, SC_TRN, SC_SAT>)N;
			}*/

			/*if (depth >= T_pool_size) {
			    depth = T_pool_size;
			}*/

			HLS_DEBUG(1, 1, 0, "init, depth:%d, type:%d, T_pool_size:%d, N:%d, scale:%f.", depth.to_int(), type,
			          pooling_size, N, scale.to_float());

			din_T tmp_in;
			dout_T tmp_out;

			do {
				hls_loop();
				bool init = true;
				do {
					hls_loop();
					for (int i = 0; i < depth / BW_N; i++) {
						hls_pipeline(BW_N);

						//#pragma HLS latency min = 5

						tmp_in = din.read();
						if (tmp_in.EOP())
							break;

						sc_fixed<W, I, SC_TRN, SC_SAT> tmp_buffer_in[Nin * BW_N];
						hls_array_partition_complete(tmp_buffer_in);

						tmp_in.template getDataFixed<W, I, Nin * BW_N>(tmp_buffer_in);

						for (int a = 0; a < Nin * BW_N; a++) {

							HLS_DEBUG(1, 1, 0, "[%d.%d]:%f", i, a, tmp_buffer_in[a].to_float());
						}

						for (int a = 0; a < BW_N; a++) {

							sc_fixed<W, I, SC_TRN, SC_SAT> pool_value = buffer[i][a];
							for (int b = 0; b < Nin; b++) {

								sc_fixed<W, I, SC_TRN, SC_SAT> value = tmp_buffer_in[b * BW_N + a];

								if (b < pooling_size) {
									if (init && (b == 0)) {
										pool_value = value;
									} else {

										switch (type) {
										case eMAX:
											if (pool_value < value) {
												pool_value = value;
											}
											break;
										case eMIN:
											if (pool_value > value) {
												pool_value = value;
											}
											break;
											/*case eAVG:
											    pool_value += value;
											    break;*/

										default:
											break;
										}
									}
								}
							}
							buffer[i][a] = pool_value;
							HLS_DEBUG(1, 1, 0, "[%d,%d]pool value:%f", i, a, pool_value.to_float());
						}
					}
					init = false;
				} while (tmp_in.tlast == 0);
				HLS_DEBUG(1, 1, 0, "tlast");
				if (!tmp_in.EOP()) {
					for (int i = 0; i < depth / (BW_N * Nout); i++) {
						hls_pipeline(1);
						sc_fixed<W, I, SC_TRN, SC_SAT> tmp_buffer[Nout * BW_N];
						hls_array_partition_complete(tmp_buffer);

						for (int a = 0; a < Nout; a++) { // a=0
							for (int b = 0; b < BW_N; b++) {

								tmp_buffer[a * BW_N + b] = buffer[i * Nout + a][b];

								HLS_DEBUG(1, 1, 0, "output:[%d,%d,%d]:%f", i, a, b,
								          tmp_buffer[a * BW_N + b].to_float());
							}
						}
						tmp_out.template setDataFixed<W, I, BW_N * Nout>(tmp_buffer);
						tmp_out.tlast = 0;
						tmp_out.setKeep();
						dout.write(tmp_out);
					}
				}

			} while (!tmp_in.EOP());
			tmp_out.setEOP();
			dout.write(tmp_out);
			HLS_DEBUG(1, 1, 0, "EOP");
		}
	}
};

namespace hwcore {
namespace cnn {
template <int W, int I, int BW_N, int Nin, int T_pool_size_param = 1024, int Nout = 1>
using sc_pooling = ::_sc_pooling<W, I, BW_N, Nin, T_pool_size_param, Nout>;
}
} // namespace hwcore