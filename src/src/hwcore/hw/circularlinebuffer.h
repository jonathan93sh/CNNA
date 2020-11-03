/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include "hwcore/hf/helperlib.h"
#include "hwcore/hw/singleportram.h"
#include <systemc.h>

namespace hwcore {
namespace hw {

template <int N, int WIDTH, int W> class circular_line_buffer {
	hf::sc_vector<singleport_ram<WIDTH, W>, N - 1> buffer;
	sc_int<hf::log2_ceil<N * 2>::val + 1> sel;          // sc_uint<hf::log2_ceil<N - 1>::val>
	sc_int<hf::log2_ceil<N * 2>::val + 1> sel_W[N - 1]; // sc_uint<hf::log2_ceil<N>::val>
	bool sel_write[N - 1];

  public:
	inline circular_line_buffer() : sel(0) {
#pragma HLS array_partition variable = sel_W complete
#pragma HLS array_partition variable = sel_write complete
		EOL_Handle();
	}

	template <int P>
	inline bool exec_fixed(sc_fixed<W, P> din, sc_uint<hf::log2_ceil<WIDTH>::val> col, sc_fixed<W, P> window[N]) {
		sc_biguint<W> window_tmp[N];
#pragma HLS array_partition variable = window_tmp complete
		sc_biguint<W> din_tmp = hf::fixed2bv<W, P>(din);

		bool ret = exec(din_tmp, col, window_tmp);

		for (int i = 0; i < N; i++) {
#pragma HLS UNROLL
			window[i] = hf::bv2fixed<W, P>(window_tmp[i]);
		}

		return ret;
	}

	inline void EOL_Handle() {
		// int sel_next = (sel + 1) % (N - 1); // (sel == N ? 0 : sel+1);//sc_uint<hf::log2_ceil<N - 1>::val>//sel = 2,
		// sel_next = 0. sel_W[2] = 1, sel_W[0] = 2
		typedef sc_int<hf::log2_ceil<N * 2>::val + 1> sel_t;
		sel_t sel_next;
		if (sel + (sel_t)1 == (sel_t)(N - 1)) {
			sel_next = 0;

		} else {
			sel_next = sel + (sel_t)1;
		}
		//= (sel + (sel_t)1 == (sel_t)(N - 1) ? (sel_t)0 : sel + (sel_t)1);

		for (sc_int<hf::log2_ceil<N * 2>::val + 1> i = 0; i < sel_t(N - 1); i++) {
#pragma HLS UNROLL
			sel_write[i] = (sel_next == i);
			// sel_W[i] = ((sel_next + i)) % (N - 1); //  (sel_next + i >= N ? sel_next + (i-(N - 1)) : sel_next + i );
			// sel_W[i]; // = (sel_next + i >= sel_t(N - 1) ? (sel_next + i) - sel_t(N - 1) : sel_next + i);
			if (sel_next + i >= sel_t(N - 1)) {
				sel_W[i] = (sel_next + i) - sel_t(N - 1);
			} else {
				sel_W[i] = sel_next + i;
			}
		}

		sel = sel_next;
	}

	inline void flush(sc_uint<hf::log2_ceil<WIDTH>::val> col) {
		for (int i = 0; i < N - 1; i++) {
#pragma HLS UNROLL
			// if(sel_write[i])
			buffer[i].flush(col);
		}
	}

	inline bool exec(sc_biguint<W> din, sc_uint<hf::log2_ceil<WIDTH>::val> col, sc_biguint<W> window[N],
	                 bool write = true) {

		sc_biguint<W> tmp[N - 1];
#pragma HLS array_partition variable = tmp complete

	loop_c_buffer_operation:
		for (int i = 0; i < N - 1; i++) {
#pragma HLS UNROLL
			tmp[i] = buffer[i].exec(din, col, sel_write[i] && write);
		}

	loop_c_window:
		for (int i = 0; i < N - 1; i++) {
#pragma HLS UNROLL
			window[i] = tmp[sel_W[i]];
		}

		window[N - 1] = din;

		return true;
	}

	hf::sc_vector<singleport_ram<WIDTH, W>, N - 1> &get_raw_ram() { return buffer; }
};

template <int N, int WIDTH, int W> class circular_line_buffer_with_replay {
	circular_line_buffer<N + 1, WIDTH, W> clb;

  public:
	inline circular_line_buffer_with_replay() {}

	template <int P>
	inline bool exec_fixed(sc_fixed<W, P> din, sc_uint<hf::log2_ceil<WIDTH>::val> col, sc_fixed<W, P> window[N]) {
		sc_biguint<W> window_tmp[N];
#pragma HLS array_partition variable = window_tmp complete
		sc_biguint<W> din_tmp = hf::fixed2bv<W, P>(din);

		bool ret = exec(din_tmp, col, window_tmp);

		for (int i = 0; i < N; i++) {
#pragma HLS UNROLL
			window[i] = hf::bv2fixed<W, P>(window_tmp[i]);
		}

		return ret;
	}

	inline void EOL_Handle() { clb.EOL_Handle(); }

	inline void flush(sc_uint<hf::log2_ceil<WIDTH>::val> col) { clb.flush(col); }

	inline bool exec(sc_biguint<W> din, sc_uint<hf::log2_ceil<WIDTH>::val> col, sc_biguint<W> window[N],
	                 bool write = true) {

		sc_biguint<W> tmp[N + 1];
#pragma HLS array_partition variable = tmp complete

		clb.exec(din, col, tmp, write);

		for (int i = 0; i < N - 1; i++) {
			window[i] = tmp[i + 1];
		}

		if (write) {
			window[N - 1] = din;
		} else {
			window[N - 1] = tmp[0];
		}

		return true;
	}
};

} // namespace hw
} // namespace hwcore