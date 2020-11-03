/*
 *  Created on: 24. OCT. 2019
 *      Author: Jonathan Horsted Schougaard
 */

#define SC_INCLUDE_FX
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

#ifndef __tag
#warning __tag not defined!!!
#undef _sc_stream_stitching
#else
#define _sc_stream_stitching JOIN(_sc_stream_stitching, __tag)
#endif

template <int W> SC_MODULE(_sc_stream_stitching) {

	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T din_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T dout_T;

	sc_in<bool> clk, reset;

	sc_fifo_in<din_T> din_buf;
	sc_fifo_in<din_T> din;
	sc_fifo_out<dout_T> dout;

	sc_fifo_in<sc_uint<16> > ctrl_depth;
	sc_fifo_in<sc_uint<16> > ctrl_buf_depth;

	SC_CTOR(_sc_stream_stitching) {
		SC_CTHREAD(thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread() {
		din_T tmp_in;
		while (true) {
			sc_uint<16> depth = ctrl_depth.read();
			sc_uint<16> buf_depth = ctrl_buf_depth.read();
			sc_uint<16> ptr = 0;
			bool last = false;
			do {
				hls_pipeline(1);
				if (ptr < buf_depth) {
					tmp_in = din_buf.read();
					tmp_in.tlast = 0;

				} else {
					tmp_in = din.read();
					last = (tmp_in.tlast == 1);
				}

				dout.write(tmp_in);

				ptr = (ptr + 1 >= depth ? sc_uint<16>(0) : sc_uint<16>(ptr + 1));

			} while (!last);
		}
	}
};

namespace hwcore {
namespace pipes {

#ifndef __tag
template <int W> using sc_stream_stitching = _sc_stream_stitching<W>;
#else
namespace __tag {
template <int W> using sc_stream_stitching = _sc_stream_stitching<W>;
} // namespace __tag
#endif

} // namespace pipes
} // namespace hwcore
