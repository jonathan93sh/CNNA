/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/pipes.h"
#include <systemc.h>

template <int W> SC_MODULE(_sc_stream_router) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;
	sc_in<bool> clk, reset;

	sc_fifo_in<interface_T> din;
	sc_fifo_in<sc_uint<1> > ctrl_channel;
	// sc_fifo_in<sc_uint<16>> ctrl_N_packages;
	sc_fifo_out<interface_T> dout_a;
	sc_fifo_out<interface_T> dout_b;

	// status
	sc_out_opt<int> s_packed_in, s_packed_out_A, s_packed_out_B, s_state;

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(din);
		// SC_TRACE_ADD(ctrl_channel);
		// SC_TRACE_ADD(dout_a);
		// SC_TRACE_ADD(dout_b);
	}

	SC_CTOR_TEMPLATE(_sc_stream_router) {

		/*sc_set_port_optional(s_packed_in);
		sc_set_port_optional(s_packed_out_A);
		sc_set_port_optional(s_packed_out_B);
		sc_set_port_optional(s_state);*/

		SC_CTHREAD(thread_sc_stream_router, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_router() {
		HLS_DEBUG(1, 1, 0, "init thread");
		int packed_in = 0;

		int packed_out_A = 0;

		s_packed_out_A.write(packed_out_A);
		int packed_out_B = 0;
		s_packed_out_B.write(packed_out_B);
		int state = 0;
		s_state.write(state);
		while (true) {
			hls_loop();
			s_state.write(-1);
			sc_uint<1> channel = ctrl_channel.read();
			s_state.write(channel.to_int());
			HLS_DEBUG(1, 1, 0, "got channel -- %d", channel.to_uint());
			interface_T tmp;

			do {
				hls_pipeline(1);
				tmp = din.read();
				packed_in++;
				s_packed_in.write(packed_in);

				if (tmp.tlast == 1U) {
					HLS_DEBUG(1, 1, 5, "TLAST");
				}

				switch (channel.to_uint()) {
				case 0:
					HLS_DEBUG(1, 1, 5, "forward data -- %s @ A", tmp.data.to_string().c_str());
					dout_a.write(tmp);
					packed_out_A++;
					s_packed_out_A.write(packed_out_A);
					break;
				case 1:
					HLS_DEBUG(1, 1, 5, "forward data -- %s @ B", tmp.data.to_string().c_str());
					dout_b.write(tmp);
					packed_out_B++;
					s_packed_out_B.write(packed_out_B);
					break;
				default:
					break;
				}

			} while (tmp.tlast == 0U);
			HLS_DEBUG(1, 1, 0, "-- done");
		}
	}
};

template <int W> SC_MODULE(_sc_stream_router_eop) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;
	sc_in<bool> clk, reset;

	sc_fifo_in<interface_T> din;
	sc_fifo_in<sc_uint<1> > ctrl_channel;
	// sc_fifo_in<sc_uint<16>> ctrl_N_packages;
	sc_fifo_out<interface_T> dout_a;
	sc_fifo_out<interface_T> dout_b;

	// status
	sc_out_opt<int> s_packed_in, s_packed_out_A, s_packed_out_B, s_state;

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(din);
		// SC_TRACE_ADD(ctrl_channel);
		// SC_TRACE_ADD(dout_a);
		// SC_TRACE_ADD(dout_b);
	}

	SC_CTOR_TEMPLATE(_sc_stream_router_eop) {

		/*sc_set_port_optional(s_packed_in);
		sc_set_port_optional(s_packed_out_A);
		sc_set_port_optional(s_packed_out_B);
		sc_set_port_optional(s_state);*/

		SC_CTHREAD(thread_sc_stream_router, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_router() {
		HLS_DEBUG(1, 1, 0, "init thread");
		int packed_in = 0;

		int packed_out_A = 0;

		s_packed_out_A.write(packed_out_A);
		int packed_out_B = 0;
		s_packed_out_B.write(packed_out_B);
		int state = 0;
		s_state.write(state);
		while (true) {
			hls_loop();
			s_state.write(-1);
			sc_uint<1> channel = ctrl_channel.read();
			s_state.write(channel.to_int());
			HLS_DEBUG(1, 1, 0, "got channel -- %d", channel.to_uint());
			interface_T tmp;

			do {
				hls_pipeline(1);
				tmp = din.read();
				packed_in++;
				s_packed_in.write(packed_in);

				if (tmp.tlast == 1U) {
					HLS_DEBUG(1, 1, 5, "TLAST");
				}

				switch (channel.to_uint()) {
				case 0:
					HLS_DEBUG(1, 1, 5, "forward data -- %s @ A", tmp.data.to_string().c_str());
					dout_a.write(tmp);
					packed_out_A++;
					s_packed_out_A.write(packed_out_A);
					break;
				case 1:
					HLS_DEBUG(1, 1, 5, "forward data -- %s @ B", tmp.data.to_string().c_str());
					dout_b.write(tmp);
					packed_out_B++;
					s_packed_out_B.write(packed_out_B);
					break;
				default:
					break;
				}

			} while (!tmp.EOP());
			HLS_DEBUG(1, 1, 0, "-- done");
		}
	}
};

template <int W> SC_MODULE(_sc_stream_router_merge_eop) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;
	sc_in<bool> clk, reset;

	sc_fifo_in<interface_T> din_a;
	sc_fifo_in<interface_T> din_b;
	sc_fifo_in<sc_uint<1> > ctrl_channel;
	// sc_fifo_in<sc_uint<16>> ctrl_N_packages;
	sc_fifo_out<interface_T> dout;

	// status
	// sc_out_opt<int> s_packed_in, s_packed_out_A, s_packed_out_B, s_state;

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(din);
		// SC_TRACE_ADD(ctrl_channel);
		// SC_TRACE_ADD(dout_a);
		// SC_TRACE_ADD(dout_b);
	}

	SC_CTOR_TEMPLATE(_sc_stream_router_merge_eop) {

		/*sc_set_port_optional(s_packed_in);
		sc_set_port_optional(s_packed_out_A);
		sc_set_port_optional(s_packed_out_B);
		sc_set_port_optional(s_state);*/

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

				if (tmp.tlast == 1U) {
					HLS_DEBUG(1, 1, 5, "TLAST");
				}

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

			} while (!tmp.EOP());
			HLS_DEBUG(1, 1, 0, "-- done");
		}
	}
};

namespace hwcore {
namespace pipes {
template <int W> using sc_stream_router = ::_sc_stream_router<W>;
template <int W> using sc_stream_router_eop = ::_sc_stream_router_eop<W>;
template <int W> using sc_stream_router_merge_eop = ::_sc_stream_router_merge_eop<W>;
} // namespace pipes
} // namespace hwcore