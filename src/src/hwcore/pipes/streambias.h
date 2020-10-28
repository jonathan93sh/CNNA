#pragma once
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

template <int W, int N> SC_MODULE(_sc_stream_bias) {

	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W *(N + 1)>::interface_T out_T;

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<in_T> din;
	sc_fifo_out<out_T> dout;

	SC_CTOR(_sc_stream_bias) {
		SC_CTHREAD(thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread() {
		in_T tmp_in;
		out_T tmp_out;

		while (true) {
			hls_loop();
			tmp_in = din.read();

			if (tmp_in.EOP()) {
				tmp_out.setEOP();
				dout.write(tmp_out);
			} else {
				sc_bv<W> out_buf[N + 1];
				hls_array_partition_complete(out_buf);
				out_buf[(N + 1) - 1] = tmp_in.template getData<sc_bv, W>(0);
				do {
					hls_pipeline(1);
					tmp_in = din.read();
					tmp_in.template getData<sc_bv, W, N>(out_buf);
					tmp_out.template setData<sc_bv, W, N + 1>(out_buf);
					tmp_out.tlast = tmp_in.tlast;
					for (int i = 0; i < N; i++) {
						tmp_out.template setKeep<W>(tmp_in.template getKeep<W>(i), i);
					}
					tmp_out.template setKeep<W>(1, (N + 1) - 1);
					dout.write(tmp_out);
					out_buf[(N + 1) - 1] = 0;
				} while (tmp_in.tlast == 0);
			}
		}
	}
};

namespace hwcore {
namespace pipes {
template <int W, int N> using sc_stream_bias = _sc_stream_bias<W, N>;
}
} // namespace hwcore