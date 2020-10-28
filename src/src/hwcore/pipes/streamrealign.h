/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
//#pragma once
#define SC_INCLUDE_FX
#include "hwcore/hf/helperlib.h"
#include "hwcore/hw/circularbuffer.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

#ifndef __tag
#warning __tag not defined!!!
#undef _sc_stream_realign
#undef _sc_stream_realign_v2
#else
#define _sc_stream_realign JOIN(_sc_stream_realign, __tag)
#define _sc_stream_realign_v2 JOIN(_sc_stream_realign_v2, __tag)
#endif

template <int W_input = 32, int W_out = W_input> SC_MODULE(_sc_stream_realign) {
  private:
  public:
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W_input>::interface_T din_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W_out>::interface_T dout_itf_t;

	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W_input>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W_out>::interface_T out_T;

	sc_in<bool> clk, reset;

	sc_fifo_in<sc_uint<16> > ctrl;
	sc_fifo_in<in_T> din;
	sc_fifo_out<out_T> dout;
	// sc_fifo_out<DATA_STREAM_t<W_out> > dout[N];
	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(ctrl);
		// SC_TRACE_ADD(din);
		// SC_TRACE_ADD(dout);
	}
	SC_CTOR_TEMPLATE(_sc_stream_realign) {
		//#//pragma HLS array_partition variable=dout complete
		SC_CTHREAD(thread_sc_stream_realign, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_realign() {
		HLS_DEBUG(1, 1, 0, "init thread");
		hwcore::hw::circle_buffer<8, ((W_input < W_out ? W_out : W_input) / 8) * 2> cbuffer;

		while (true) {
			sc_uint<16> W_Nrow = ctrl.read();
			HLS_DEBUG(1, 1, 0, "got new ctrl input W_Nrow: %d", W_Nrow.to_uint());
			cbuffer.reset();
			in_T din_tmp;

			out_T dout_tmp;

			sc_uint<16> W_Nrow_left = W_Nrow;
			do {

				din_tmp = din.read();

				for (int i = 0; i < W_input / 8; i++) {
#pragma HLS UNROLL
					if (din_tmp.tkeep[i] == 1) {
						cbuffer.push(din_tmp.template getData<sc_uint, 8>(i));
					}
				}

				if (cbuffer.count() >= W_Nrow_left) {
					dout_tmp.setKeep(W_Nrow_left);
					dout_tmp.tlast = 1;
					for (int i = 0; i < W_Nrow_left; i++) {
#pragma HLS UNROLL
						dout_tmp.template setData<sc_uint, 8>(cbuffer.pop(), i);
					}

					dout.write(dout_tmp);

					W_Nrow_left = W_Nrow;
				} else if (cbuffer.count() >= W_out / 8) {
					dout_tmp.setKeep();
					dout_tmp.tlast = 0;
					for (int i = 0; i < W_out / 8; i++) {
#pragma HLS UNROLL
						dout_tmp.template setData<sc_uint, 8>(cbuffer.pop(), i);
					}
					dout.write(dout_tmp);
					W_Nrow_left -= W_out / 8;
				}

			} while (din_tmp.tlast == 0);

			dout_tmp.setEOP();
			dout.write(dout_tmp);
		}
	}
};

template <int W_input = 32, int W_out = W_input, int ctrl_w = 16> SC_MODULE(_sc_stream_realign_v2) {
  private:
  public:
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W_input>::interface_T din_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W_out>::interface_T dout_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W_input>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W_out>::interface_T out_T;

	sc_in<bool> clk, reset;

	sc_fifo_in<sc_uint<ctrl_w> > ctrl;
	sc_fifo_in<in_T> din;
	sc_fifo_out<out_T> dout;
	// sc_fifo_out<DATA_STREAM_t<W_out> > dout[N];
	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(ctrl);
		// SC_TRACE_ADD(din);
		// SC_TRACE_ADD(dout);
	}
	SC_CTOR_TEMPLATE(_sc_stream_realign_v2) {
		//#//pragma HLS array_partition variable=dout complete
		SC_CTHREAD(thread_sc_stream_realign_v2, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_realign_v2() {
		HLS_DEBUG(1, 1, 0, "init thread");
		// hwcore::hw::circle_buffer<8, ((W_input < W_out ? W_out : W_input) / 8) * 2>
		// cbuffer;

		while (true) {
			hls_loop();
			sc_uint<ctrl_w> W_pkg_Nrow = ctrl.read();
			HLS_DEBUG(1, 1, 0, "got new ctrl input W_pkg_Nrow: %d", W_pkg_Nrow.to_uint());
			// cbuffer.reset();
			in_T din_tmp;
			sc_uint<1> last = 0;
			// out_T dout_tmp;

			sc_uint<ctrl_w> W_Nrow_left = W_pkg_Nrow;
			if (W_pkg_Nrow == 0) {
				do {
					hls_pipeline(1);
					din_tmp = din.read();
					dout.write(din_tmp);
				} while (din_tmp.tlast == 0);
			} else {
				do {
					hls_loop();
					int lol;
					int heg;
					for (int i = 0; i < W_pkg_Nrow; i++) {
						hls_pipeline(1);

						din_tmp = din.read();
						last = din_tmp.tlast;
						if (i == W_pkg_Nrow - 1 || last)
							din_tmp.tlast = 1;

						HLS_DEBUG_EXEC(if (last && i != W_pkg_Nrow - 1) {
							HLS_DEBUG(1, 1, 0, "error");
							sc_assert(false);
						});

						dout.write(din_tmp);
						/*if(din_tmp.tlast == 0) // check for illegal stream
						    break;*/
					}
					int dummy;
				} while (last == 0);
			}

			in_T dout_tmp;
			dout_tmp.setEOP();
			dout.write(dout_tmp);
		}
	}
};

namespace hwcore {
namespace pipes {

#ifndef __tag

template <int W_input = 32, int W_out = W_input, int ctrl_w = 16>
using sc_stream_realign = ::_sc_stream_realign_v2<W_input, W_out, ctrl_w>;
#else
namespace __tag {

template <int W_input = 32, int W_out = W_input, int ctrl_w = 16>
using sc_stream_realign = ::_sc_stream_realign_v2<W_input, W_out, ctrl_w>;
}
#endif

} // namespace pipes

} // namespace hwcore

#ifndef __tag
//#endif
#else
#undef __tag
#endif