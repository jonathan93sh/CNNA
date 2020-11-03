/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include "hwcore/hf/helperlib.h"
#include <systemc.h>

namespace hwcore {
namespace hw {

template <int N, int W> class singleport_ram {

	sc_uint<hf::log2_ceil<N>::val> addr_int; // hf::log2_ceil<N>::val
	sc_biguint<W * 2> ram[N / 2];
	// sc_uint<W*2> ram[N/2];
	sc_uint<1> cnt;
	sc_biguint<W * 2> read_data;
	sc_biguint<W * 2> write_data;

  public:
	singleport_ram() : cnt(0), read_data(0), write_data(0) {
#pragma HLS array_partition variable = ram block factor = 1
#ifndef __SYNTHESIS__
		for (int i = 0; i < N / 2; i++) {
			ram[i] = -1;
		}
#endif
	}

	sc_biguint<W> exec_read(sc_biguint<W> data_in, sc_uint<hf::log2_ceil<N>::val> addr) {

		HLS_DEBUG_EXEC(sc_assert((addr >> 1) < (N / 2)));
		sc_biguint<W> tmp;
		cnt[0] = addr[0];
		sc_biguint<W * 2> read_tmp = ram[addr_int >> 1];

		if (cnt == 0)
			tmp = read_data(W - 1, 0);
		else
			tmp = read_data((W * 2) - 1, W);

		return tmp;
	}

	sc_biguint<W> exec(sc_biguint<W> data_in, sc_uint<hf::log2_ceil<N>::val> addr, bool write) {
		HLS_DEBUG_EXEC(sc_assert((addr >> 1) < (N / 2)));
		cnt[0] = addr[0];
		sc_biguint<W> tmp;
		// const sc_uint<hf::log2_ceil<N>::val> addr_high = N-1;
		addr_int = addr; // (addr < addr_high ? addr : sc_uint<hf::log2_ceil<N>::val>(0U));
		// write part
		if (write) {
			if (cnt == 0)
				write_data(W - 1, 0) = data_in;
			else
				write_data((W * 2) - 1, W) = data_in;
		}

		// ram operation

		if (cnt == 0)
			read_data = ram[addr_int >> 1];
		else if (write)
			ram[addr_int >> 1] = write_data;

		// read part

		if (cnt == 0)
			tmp = read_data(W - 1, 0);
		else
			tmp = read_data((W * 2) - 1, W);

		// cnt++;

		return tmp;
	}

	void flush() { ram[addr_int >> 1] = write_data; }

	sc_biguint<W * 2> &get_ram(int rawptr) { return ram[(rawptr < N / 2 ? rawptr : 0)]; }
};

} // namespace hw
} // namespace hwcore