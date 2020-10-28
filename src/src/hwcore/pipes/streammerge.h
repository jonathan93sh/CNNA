/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

template <int Win, int N> SC_MODULE(_sc_stream_merge_raw) {

  private:
  public:
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * Win>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * Win * N>::interface_T out_T;
	sc_in<bool> clk, reset;
	sc_fifo_in<in_T> din[N];
	sc_fifo_out<out_T> dout;

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// for(int i=0;i<N;i++)
		//    SC_TRACE_ADD(din[i]);
		// SC_TRACE_ADD(dout);
	}

	SC_CTOR_TEMPLATE(_sc_stream_merge_raw) {
		hls_array_partition_complete(din);
		SC_CTHREAD(thread_sc_stream_merge_raw, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_merge_raw() {
		HLS_DEBUG(1, 1, 0, "init thread");
		sc_biguint<N> LAST = 0;
		sc_biguint<N> READ_DONE = 0;
		const sc_biguint<N> READ_DONE_HIGH = hwcore::hf::HIGH<sc_biguint, 1 * N>();
		out_T tmp_out;

		while (true) {
			hls_loop();
			bool tlast = false;
			do {
				wait();
				for (int i = 0; i < N; i++) {
					hls_unroll();
					if (READ_DONE[i] == 0) {
						if (LAST[i] == 0) {
							in_T tmp_in;
							if (din[i].nb_read(tmp_in)) {

								tmp_out.template setData<sc_bv, Win>(tmp_in.data, i);
								tmp_out.template setKeep<Win>(tmp_in.template getKeep<Win>(0), i);
								LAST[i] = tmp_in.tlast;
								if (i == 0 && LAST[i]) {
									tlast = true;
								}
								READ_DONE[i] = 1;
							}
						} else {
							READ_DONE[i] = 1;
							tmp_out.template setKeep<Win>(0, i);
						}
					}
				}
			} while (READ_DONE != READ_DONE_HIGH);

			READ_DONE = 0;

			if (tlast) {
				LAST = 0;

				tmp_out.tlast = 1;
			} else {
				tmp_out.tlast = 0;
			}

			dout.write(tmp_out);
		}
	}
};

namespace hwcore {
namespace pipes {

template <int Win, int N> using sc_stream_merge_raw = ::_sc_stream_merge_raw<Win, N>;

} // namespace pipes
} // namespace hwcore