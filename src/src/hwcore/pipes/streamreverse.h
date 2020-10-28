/*
 *  Created on: 29. aug. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

#ifndef __tag
#warning __tag not defined!!!
#undef _sc_stream_reverse
#else
#define _sc_stream_reverse JOIN(_sc_stream_reverse, __tag)
#endif

template <int W, int N> SC_MODULE(_sc_stream_reverse) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N>::interface_T din_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N>::interface_T dout_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N>::interface_T itf_T;
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<itf_T> din;
	sc_fifo_out<itf_T> dout;

	SC_CTOR_TEMPLATE(_sc_stream_reverse) {
		SC_CTHREAD(thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread() {
		itf_T tmp_in;
		while (true) {
			hls_loop();
			do {
				hls_pipeline(1);
				tmp_in = din.read();
				itf_T tmp_out;
				tmp_out.tlast = tmp_in.tlast;
				for (int i = 0; i < N; i++) {
					hls_unroll();
					int rev = N - i - 1;
					tmp_out.template setData<sc_bv, W>(tmp_in.template getData<sc_bv, W>(rev), i);
					tmp_out.template setKeep<W>(tmp_in.template getKeep<W>(rev), i);
				}
				dout.write(tmp_out);
			} while (!tmp_in.EOP());
		}
	}
};

namespace hwcore {
namespace pipes {
#ifndef __tag
template <int W, int N> using sc_stream_reverse = _sc_stream_reverse<W, N>;
#else
namespace __tag {
template <int W, int N> using sc_stream_reverse = _sc_stream_reverse<W, N>;
}
#endif
} // namespace pipes
} // namespace hwcore

#ifndef __tag
//#endif
#else
#undef __tag
#endif