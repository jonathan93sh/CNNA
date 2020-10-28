/*
 *  Created on: 29. aug. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

#ifndef __tag
#warning __tag not defined!!!
#undef _sc_stream_last_fix
#else
#define _sc_stream_last_fix JOIN(_sc_stream_last_fix, __tag)
#endif

template <int W> SC_MODULE(_sc_stream_last_fix) {

	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T itf_T;
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<itf_T> din;
	sc_fifo_out<itf_T> dout;

	SC_CTOR_TEMPLATE(_sc_stream_last_fix) {
		SC_CTHREAD(thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread() {
		itf_T tmp_in;
		tmp_in.setEOP();
		itf_T tmp_in_pre;
		tmp_in_pre.setEOP();
		while (true) {
			hls_loop();
			tmp_in_pre = din.read();
			if (tmp_in_pre.EOP()) {
				// dout.write(tmp_in_pre);
			} else {
				do {
					hls_pipeline(1);
					wait_approx();
					tmp_in = din.read();
					if (tmp_in.EOP()) {
						tmp_in_pre.tlast = 1;
					} else {
						tmp_in_pre.tlast = 0;
					}

					dout.write(tmp_in_pre);
					tmp_in_pre = tmp_in;
				} while (!tmp_in.EOP());
			}
		}
	}
};

namespace hwcore {
namespace pipes {
#ifndef __tag
template <int W> using sc_stream_last_fix = _sc_stream_last_fix<W>;
#else
namespace __tag {
template <int W> using sc_stream_last_fix = _sc_stream_last_fix<W>;
}
#endif
} // namespace pipes
} // namespace hwcore

#ifndef __tag
//#endif
#else
#undef __tag
#endif