/*
 *  Created on: 24. OCT. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include "hwcore/hf/helperlib.h"
#include "hwcore/hw/circularbuffer.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

#ifndef __tag
#warning __tag not defined!!!
#undef _sc_stream_imagedatafix
#else
#define _sc_stream_imagedatafix JOIN(_sc_stream_imagedatafix, __tag)
#endif

template <int W, int P, int BW> SC_MODULE(_sc_stream_pixel_2_stream) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * 8>::interface_T din_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * BW>::interface_T dout_T;

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<sc_ufixed<8, 0> > din_red, din_green, din_blue;

	sc_fifo_in<bool> din_last;

	sc_fifo_out<dout_T> dout;

	SC_CTOR(_sc_stream_pixel_2_stream) {
		SC_CTHREAD(thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread() {
		sc_fixed<W, P> tmp_data_out[BW];
		bool last = false;
		hls_array_partition_complete(tmp_data_out);
		dout_T tmp_out;
		tmp_out.setKeep();
		for (int i = 0; i < BW; i++) {
			hls_unroll();
			tmp_data_out[i] = 0;
		}
		bool r_ready = false;
		bool g_ready = false;
		bool b_ready = false;
		bool last_ready = false;

		while (true) {

			hls_pipeline(1);
			if (r_ready && g_ready && r_ready && last_ready) {
				tmp_out.tlast = (last ? 1 : 0);
				tmp_out.template setDataFixed<W, P, BW>(tmp_data_out);
				if (dout.nb_write(tmp_out)) {
					// HLS_DEBUG(1, 1, 0, "f")
					r_ready = false;
					g_ready = false;
					b_ready = false;
					last_ready = false;
				}
			}

			if (!r_ready) {
				sc_ufixed<8, 0> tmp;
				r_ready = din_red.nb_read(tmp);
				tmp_data_out[0] = tmp;
			}

			if (!g_ready) {
				sc_ufixed<8, 0> tmp;
				g_ready = din_green.nb_read(tmp);
				tmp_data_out[1] = tmp;
			}

			if (!b_ready) {
				sc_ufixed<8, 0> tmp;
				b_ready = din_blue.nb_read(tmp);
				tmp_data_out[2] = tmp;
			}

			if (!last_ready) {
				last_ready = din_last.nb_read(last);
			}

			// tmp_data_out[0] = din_red.read();
			// tmp_data_out[1] = din_green.read();
			// tmp_data_out[2] = din_red.read();
			// tmp_out.tlast = din_last.read();
			// tmp_out.template setDataFixed<W, P, BW>(tmp_data_out);
			// dout.write(tmp_out);
		}
	}
};

template <int W> SC_MODULE(_sc_stream_router_merge) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;
	sc_in<bool> clk, reset;

	sc_fifo_in<interface_T> din_a;
	sc_fifo_in<interface_T> din_b;
	sc_fifo_in<sc_uint<1> > ctrl_channel;
	sc_fifo_out<interface_T> dout;

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
	}

	SC_CTOR_TEMPLATE(_sc_stream_router_merge) {

		SC_CTHREAD(thread_sc_stream_router, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_router() {
		HLS_DEBUG(1, 1, 0, "init thread");

		while (true) {
			hls_loop();

			sc_uint<1> channel = ctrl_channel.read();
			HLS_DEBUG(1, 1, 0, "got channel -- %d", channel.to_uint());
			interface_T tmp;

			do {
				hls_pipeline(1);

				switch (channel.to_uint()) {
				case 0:

					tmp = din_a.read();
					HLS_DEBUG(1, 1, 5, "got data -- %s @ A", tmp.data.to_string().c_str());
					break;
				case 1:
					tmp = din_b.read();
					HLS_DEBUG(1, 1, 5, "got data -- %s @ B", tmp.data.to_string().c_str());
					break;
				default:
					break;
				}

				dout.write(tmp);

			} while (tmp.tlast == 0);
			HLS_DEBUG(1, 1, 0, "-- done");
		}
	}
};

template <int W, int P, int BW, int W_full = (W * BW), int byte_BW = W_full / 8, int pixel_pipeline = (BW + 2) / 3>
SC_MODULE(_sc_stream_imagedatafix) {

	// enum { byte_BW = 8 / W_full };

	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * BW>::interface_T din_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * BW>::interface_T dout_T;

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<din_T> din;
	sc_fifo_out<dout_T> dout;
	sc_fifo_in<sc_uint<1> > enable;

	sc_fifo<sc_uint<1> > merge_ctrl;

	sc_fifo<sc_ufixed<8, 0> > red, green, blue;
	sc_fifo<bool> last;
	_sc_stream_pixel_2_stream<W, P, BW> p2s;
	sc_fifo<dout_T> p2s_dout;

	sc_fifo<dout_T> forward_dout;
	_sc_stream_router_merge<W * BW> merge;

	SC_CTOR(_sc_stream_imagedatafix)
	    : merge_ctrl(1), red(4), green(4), blue(4), last(4), p2s_dout(1), forward_dout(1), p2s("p2s"), merge("merge") {
		SC_MODULE_LINK(p2s);
		SC_MODULE_LINK(merge);

		p2s.din_red(red);
		p2s.din_green(green);
		p2s.din_blue(blue);
		p2s.din_last(last);
		p2s.dout(p2s_dout);

		merge.din_a(p2s_dout);
		merge.din_b(forward_dout);
		merge.ctrl_channel(merge_ctrl);
		merge.dout(dout);

		SC_CTHREAD(thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread() {
		while (true) {
			HLS_DEBUG(1, 1, 0, "waiting on ctrl");
			bool en = enable.read() == 1;
			if (en) {
				HLS_DEBUG(1, 1, 0, "[state raw_pixel]");
				merge_ctrl.write(0);
				din_T tmp_in;
				din_T tmp_out;
				sc_ufixed<8, 0> raw_pixels[byte_BW];
				hls_array_partition_complete(raw_pixels);
				sc_uint<4> ptr = 0;
				sc_uint<hwcore::hf::log2_ceil<byte_BW + 1>::val> itr = 0;
				do {
					hls_pipeline(3);
					if (itr == 0) {
						tmp_in = din.read();
						tmp_in.template getDatauFixed<8, 0, byte_BW>(raw_pixels);
						if (tmp_in.tlast == 1) {
							HLS_DEBUG(1, 1, 0, "got tlast");
						}
					}

					if (itr < byte_BW && ptr == 0) {
						red.write(raw_pixels[itr]);
						itr++;
						ptr = 1;
					}

					if (itr < byte_BW && ptr == 1) {
						green.write(raw_pixels[itr]);
						itr++;
						ptr = 2;
					}
#warning do only works if PE_BW is equal with DMA_BW
					if (itr < byte_BW && ptr == 2) {
						blue.write(raw_pixels[itr]);
						bool l = (itr == (byte_BW - 1) && tmp_in.tlast == 1);
						last.write(l);
						itr++;
						ptr = 0;
					}

					if (itr >= byte_BW) {
						itr = 0;
					}

				} while (!(tmp_in.tlast == 1 && itr == 0));
			} else {
				HLS_DEBUG(1, 1, 0, "[state normal data]");
				merge_ctrl.write(1);
				din_T tmp_in;
				do {
					hls_pipeline(1);
					tmp_in = din.read();
					forward_dout.write(tmp_in);
				} while (tmp_in.tlast == 0);
				HLS_DEBUG(1, 1, 0, "forward done");
			}
		}
	}
};

namespace hwcore {
namespace pipes {
template <int W, int P, int BW> using sc_stream_imagedatafix = _sc_stream_imagedatafix<W, P, BW>;
}
} // namespace hwcore