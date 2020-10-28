/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include "hwcore/hf/helperlib.h"
#include "hwcore/hw/singleportram.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

template <int W = 16, bool stream_while_write = false, int L = (((18 * 1024) / W) * 4)> SC_MODULE(_sc_stream_buffer) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;
	enum ctrls { newset = 0, reapeat = 1 };

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<interface_T> din;
	sc_fifo_in<sc_uint<16> > ctrls_in;
	sc_fifo_in<sc_uint<16> > ctrls_replay;

	sc_fifo_out<interface_T> dout;

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(din);
		// SC_TRACE_ADD(ctrls_in);
		// SC_TRACE_ADD(dout);
	}

	SC_CTOR_TEMPLATE(_sc_stream_buffer) {
		//#//pragma HLS function_instantiate variable=pW,pstream_while_write,pL
		// dummy_rtl_generator(W+stream_while_write+L);

		//#//pragma HLS function_instantiate variable=W_value,stream_while_write_value,L_value
		SC_CTHREAD(thread_sc_stream_buffer, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_buffer() {
		/// pragma HLS function_instantiate variable=SC_CURRENT_USER_MODULE
		// dummy_rtl_generator(W+stream_while_write+L);

		//#pragma HLS function_instantiate variable=W_value,stream_while_write_value,L_value
		//#//pragma HLS function_instantiate variable=W,stream_while_write,L
		//#/pragma HLS function_instantiate variable=W_value,stream_while_write_value,L_value
		HLS_DEBUG(1, 1, 0, "init thread");
		hwcore::hw::singleport_ram<L, (W) + ((W) / 8) + 1> buf;
		unsigned high_addr = 0;
		while (true) {
			interface_T tmp_in;
			interface_T tmp_out;
			int ctrls_tmp = ctrls_in.read();
			if (ctrls_tmp == 0) {
				HLS_DEBUG(1, 1, 0, "reading -- start");
				high_addr = 0;
				do {
#pragma HLS pipeline II = 1
					tmp_in = din.read();
					HLS_DEBUG(1, 1, 5, "reading -- got data: %s @ address: %d tlast? %s",
					          tmp_in.data.to_string().c_str(), high_addr, (tmp_in.tlast ? "true" : "false"));
					if (stream_while_write)
						dout.write(tmp_in); // if(stream_while_write)
					if (!tmp_in.EOP()) {
						buf.exec(hwcore::hf::bv_merge<1, (W / 8) + W>(
						             tmp_in.tlast, hwcore::hf::bv_merge<W / 8, W>(tmp_in.tkeep, tmp_in.data)),
						         high_addr, true);
						high_addr++;
					}

				} while (!tmp_in.EOP());
				/*if (stream_while_write)
				{
				    HLS_DEBUG(1, 1, 0, "sending EOP");
				    tmp_in.setEOP();
				    dout.write(tmp_in);
				}*/
				buf.flush(high_addr - 1);
				HLS_DEBUG(1, 1, 0, "reading -- done");
			} else {

				int ctrls_replay_tmp = ctrls_replay.read();

				for (int re = 0; re < ctrls_tmp; re++) {
					HLS_DEBUG(1, 1, 0, "writing -- start");

					int i = 0;
					int re_w = ctrls_replay_tmp;
					int start = 0;
					while (i < high_addr) {
#pragma HLS pipeline II = 1
						sc_bv<W + (W / 8) + 1> tmp = buf.exec_read(0, i);
						tmp_out.data = tmp(W - 1, 0);
						tmp_out.tkeep = tmp((W + (W / 8)) - 1, W);
						tmp_out.tlast = tmp.get_bit(W + (W / 8));
						HLS_DEBUG(1, 1, 5, "writing -- sending data: %s @ address: %d / %d tlast? %s",
						          tmp_out.data.to_string().c_str(), i, high_addr - 1,
						          (tmp_out.tlast ? "true" : "false"));
						// tmp_out.tfinal = (i == high_addr-1 ? 1 : 0);
						dout.write(tmp_out);
						if (tmp_out.tlast == 1) {
							if (re_w != 0) {
								i = start;
								re_w--;
							} else {
								i++;
								start = i;
								re_w = ctrls_replay_tmp;
							}
						} else {
							i++;
						}
					}

#if 0
				for (int re = 0; re < ctrls_tmp; re++) {
					HLS_DEBUG(1, 1, 0, "writing -- start");
					for (int i = 0; i < high_addr; i++) {
#pragma HLS pipeline II = 1
						sc_bv<W + (W / 8) + 1> tmp = buf.exec(0, i, false);
						tmp_out.data = tmp(W - 1, 0);
						tmp_out.tkeep = tmp((W + (W / 8)) - 1, W);
						tmp_out.tlast = tmp.get_bit(W + (W / 8));
						HLS_DEBUG(1, 1, 5, "writing -- sending data: %s @ address: %d / %d tlast? %s",
						          tmp_out.data.to_string().c_str(), i, high_addr - 1,
						          (tmp_out.tlast ? "true" : "false"));
						// tmp_out.tfinal = (i == high_addr-1 ? 1 : 0);
						dout.write(tmp_out);
					}
					/*HLS_DEBUG(1, 1, 0, "sending EOP");
					tmp_out.setEOP();
					dout.write(tmp_out);*/
					HLS_DEBUG(1, 1, 0, "writing -- done");
#endif
				}
			}
		}
	}
};

template <int W = 16, int L = (((18 * 1024) / W) * 4)> //, bool stream_while_write = false>
SC_MODULE(_sc_stream_buffer_not_stream_while_write) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;
	enum ctrls { newset = 0, reapeat = 1 };

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<interface_T> din;
	sc_fifo_in<sc_uint<31> > ctrls_in;

	sc_fifo_out<interface_T> dout;
	sc_out_opt<int> count_in;
	sc_out_opt<int> count_out;
	sc_out_opt<int> state;

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(din);
		// SC_TRACE_ADD(ctrls_in);
		// SC_TRACE_ADD(dout);
	}

	SC_CTOR_TEMPLATE(_sc_stream_buffer_not_stream_while_write) {
		SC_CTHREAD(thread_sc_stream_buffer_not_stream_while_write, clk.pos());
		HLS_DEBUG_EXEC(set_stack_size(100 * 1024 * 1024));
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_buffer_not_stream_while_write() {
		HLS_DEBUG(1, 1, 0, "init thread");
		// hwcore::hw::singleport_ram<L, (W) + ((W) / 8) + 1> buf;

		sc_bv<W + (W / 8) + 1> buf[L];
		hls_array_partition(buf, block factor = 1);
		sc_uint<hwcore::hf::log2_ceil<L>::val> high_addr = 0;
		sc_uint<hwcore::hf::log2_ceil<L>::val> cur_addr = 0;
		while (true) {
			hls_loop();
			interface_T tmp_in, tmp_in_pre;
			interface_T tmp_out;
			sc_uint<31> ctrls_in_raw = ctrls_in.read();

			sc_uint<20> ctrls_tmp = ctrls_in_raw(19, 0);
			sc_uint<10> last_interval = ctrls_in_raw(29, 20);
			// bool stream_while_write = ctrls_in_raw[29] == 1;

			bool overwrite_last = (last_interval != 0);
			bool forward = ctrls_in_raw[30] == 1;
			if (forward) {
				tmp_in_pre = din.read();
				if (!tmp_in_pre.EOP()) {
					do {
						hls_pipeline(1);
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
				tmp_out.setEOP();
				dout.write(tmp_out);

			} else if (ctrls_tmp == 0) {
				HLS_DEBUG(1, 1, 0, "reading -- start");
				high_addr = 0;
				cur_addr = 0;
				sc_uint<14> last_counter = 0;
				bool new_data = false;
				do {
					hls_pipeline_raw(2);
					wait();

					if (cur_addr < high_addr) { // stream_while_write &&
						sc_bv<W + (W / 8) + 1> tmp = buf[cur_addr];
						tmp_out.data = tmp(W - 1, 0);
						tmp_out.tkeep = tmp((W + (W / 8)) - 1, W);

						tmp_out.tlast = tmp.get_bit(W + (W / 8));

						if (dout.nb_write(tmp_out))
							cur_addr++;
					}

					new_data = din.nb_read(tmp_in);
					if (new_data) {
						HLS_DEBUG(5, 1, 5, "reading -- got data: %s @ address: %d tlast? %s",
						          tmp_in.data.to_string().c_str(), high_addr.to_int(),
						          (tmp_in.tlast ? "true" : "false"));
						if (!tmp_in.EOP()) {
							sc_bv<1> tlast;

							if (overwrite_last) {
								tlast = (last_counter == last_interval - 1);
							} else {
								tlast = tmp_in.tlast;
							}

							buf[high_addr] = hwcore::hf::bv_merge<1, (W / 8) + W>(
							    tlast, hwcore::hf::bv_merge<W / 8, W>(tmp_in.tkeep, tmp_in.data));
							high_addr++;
							if (last_counter == last_interval - 1) {
								last_counter = 0;
							} else {
								last_counter++;
							}
						}
					}
				} while (!(new_data && tmp_in.EOP()));

				HLS_DEBUG(1, 1, 0, "reading -- done");
			} else {
				// int ctrls_replay_tmp = ctrls_replay.read();
				sc_uint<28> replay = ctrls_tmp;
				for (sc_uint<28> re = 0; re < replay; re++) {
					hls_loop();
					HLS_DEBUG(1, 1, 0, "writing -- start");

					for (sc_uint<hwcore::hf::log2_ceil<L + 1>::val> i = cur_addr; i < high_addr; i++) {
						hls_pipeline(1);
						sc_bv<W + (W / 8) + 1> tmp = buf[i];
						tmp_out.data = tmp(W - 1, 0);
						tmp_out.tkeep = tmp((W + (W / 8)) - 1, W);
						tmp_out.tlast = tmp.get_bit(W + (W / 8));
						HLS_DEBUG(5, 1, 5, "writing -- sending data: %s @ address: %d / %d tlast? %s",
						          tmp_out.data.to_string().c_str(), i.to_int(), high_addr.to_int() - 1,
						          (tmp_out.tlast ? "true" : "false"));
						// tmp_out.tfinal = (i == high_addr-1 ? 1 : 0);
						dout.write(tmp_out);
					}
					cur_addr = 0;
				}
				tmp_out.setEOP();
				dout.write(tmp_out);

				HLS_DEBUG(1, 1, 0, "writing -- done and sending EOP");
			}
		}
	}
};

namespace hwcore {
namespace pipes {
template <int W = 16, bool stream_while_write = false, int L = (((18 * 1024) / W) * 4)>
using sc_stream_buffer = ::_sc_stream_buffer<W, stream_while_write, L>;
#warning "replace with: not stream while write version"
template <int W = 16, int L = (((18 * 1024) / W) * 4)> //, bool stream_while_write = false>
using sc_stream_buffer_not_stream_while_write =
    ::_sc_stream_buffer_not_stream_while_write<W, L>; //, stream_while_write>;

} // namespace pipes
} // namespace hwcore
