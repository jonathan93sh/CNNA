/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include <systemc.h>
// local include
#include "hwcore/hf/helperlib.h"

namespace hwcore {
namespace hw {

template <typename T, int N> class shiftreg {
  private:
	T regs[N];
	bool en;
	bool sync_rst;
	bool ld;

  public:
	shiftreg(bool load_in = true) : en(true), sync_rst(false), ld(load_in) {
#pragma HLS array_partition variable = regs complete
	}

	void set_sync_rst(bool srst) { sync_rst = srst; }

	void set_enable(bool enable) { en = enable; }

	void operator<<(T din) {
	SHIFT:
		for (int i = N - 1; i >= 0; i--) {
#pragma HLS UNROLL
			if (en) {
				if (sync_rst) {
					regs[i] = 0;
				} else {
					if (i == 0)
						regs[i] = din;
					else
						regs[i] = regs[i - 1];
				}
			}
		}
	}

	T operator[](int i) { return regs[i]; }
};

template <typename T, int N> class shiftreg_memory {
  private:
	T regs[N];
	int ptr_write;

  public:
	shiftreg_memory() : ptr_write(0), size(N) {
#pragma HLS array_partition variable = regs block factor = 1
	}

	void reset() { ptr_write = 0; }

	void operator<<(T din) {
		regs[ptr_write] = din;
		ptr_write = (ptr_write + 1 >= N ? 0 : ptr_write + 1);
	}

	T operator[](int i) {
		HLS_DEBUG_EXEC(sc_assert(i < N));
		int ptr = (ptr_write - i - 1 >= 0 ? ptr_write - i - 1 : ptr_write - i - 1 + N);
		ptr = (ptr >= 0 && ptr < N ? ptr : 0);
		return regs[ptr];
	}

	T getRaw(unsigned i) {
		unsigned ptr = (i < N ? i : N - 1);
		return regs[ptr];
	}

	void setRaw(unsigned i, T value) {
		unsigned ptr = (i < N ? i : N - 1);
		regs[ptr] = value;
	}

	const int size;
};

template <class T, int N, int size> class shiftreg_memory_array {
  private:
	shiftreg_memory<T, size> shift_array[N];
	int ptr_write;

  public:
	shiftreg_memory_array() : ptr_write(0) {}

	shiftreg_memory<T, size> &getShift(int i) { return shift_array[i]; }

	void operator<<(T din) {

		for (int i = 0; i < N; i++) {
#pragma HLS unroll
			if (i * size <= ptr_write && ptr_write <= ((i + 1) * size) - 1) {
				int ptr_tmp = ptr_write - (i * size);
				shift_array[i].setRaw(ptr_tmp, din);
			}
		}

		ptr_write = (ptr_write + 1 >= N * size ? 0 : ptr_write + 1);
	}

	T operator[](int i) {
		HLS_DEBUG_EXEC(sc_assert(i < N));
		int ptr = (ptr_write - i - 1 >= 0 ? ptr_write - i - 1 : ptr_write - i - 1 + (N * size));
		ptr = (ptr >= 0 && ptr < (N * size) ? ptr : 0);
		T tmp = 0;
		for (int i = 0; i < N; i++) {
#pragma HLS unroll
			if (i * size <= ptr && ptr <= ((i + 1) * size) - 1) {
				int ptr_tmp = ptr - (i * size);
				tmp |= shift_array[i].getRaw(ptr_tmp);
			}
		}

		return tmp;
	}
};

} // namespace hw
} // namespace hwcore