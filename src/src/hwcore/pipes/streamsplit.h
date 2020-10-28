/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */

#define SC_INCLUDE_FX
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

#ifndef __tag
#warning __tag not defined!!!
#undef _sc_stream_splitter_clone
#undef _sc_stream_splitter_clone_EOP
#undef _sc_stream_splitter
#undef _sc_stream_splitter_fix
#else
#define _sc_stream_splitter_clone JOIN(_sc_stream_splitter_clone, __tag)
#define _sc_stream_splitter_clone_EOP JOIN(_sc_stream_splitter_clone_EOP, __tag)
#define _sc_stream_splitter JOIN(_sc_stream_splitter, __tag)
#define _sc_stream_splitter_fix JOIN(_sc_stream_splitter_fix, __tag)
#endif

template <int W, int N, bool SendEOP = true, bool Unvalid_fill = true> SC_MODULE(_sc_stream_splitter) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;

	sc_in<bool> clk, reset;

	sc_fifo_in<interface_T> din;
	sc_fifo_out<interface_T> dout[N];

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(din);
		// for(int i=0;i<N;i++)
		//{
		//    SC_TRACE_ADD(dout[i]);
		//}
	}

	SC_CTOR_TEMPLATE(_sc_stream_splitter) {
		hls_array_partition_complete(dout);
		SC_CTHREAD(thread_sc_stream_splitter, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_splitter() {
		HLS_DEBUG(1, 1, 0, "init thread");
		sc_uint<hwcore::hf::log2_ceil<N>::val> idx = 0; // sc_uint<hf::log2_ceil<N>::val>
		// int last_count = 0;
		while (true) {
			hls_loop();
			idx = 0;
			interface_T tmp_in;

			do {
				hls_pipeline(1);
				din.read(tmp_in);
				if (!tmp_in.EOP()) {
					dout[idx].write(tmp_in);

					if (tmp_in.tlast == 1) {
						if (idx == N - 1) {
							idx = 0;
						} else {
							idx++;
						}
					}
				}

			} while (!tmp_in.EOP());

			if (Unvalid_fill) {

				for (int i = 0; i < N; i++) {
					hls_unroll();
					if (i >= idx && idx != 0) {
						tmp_in.setUnvalid();
						dout[i].write(tmp_in);
					}
				}
			}

			if (SendEOP) {
				for (int i = 0; i < N; i++) {
					hls_unroll();
					tmp_in.setEOP();
					dout[i].write(tmp_in);
				}
			}
		}
	}
};

template <int W, int N, bool SendEOP = true, bool Unvalid_fill = true> SC_MODULE(_sc_stream_splitter_fix) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;

	sc_in<bool> clk, reset;

	sc_fifo_in<interface_T> din;
	sc_fifo_out<interface_T> dout[N];

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(din);
		// for(int i=0;i<N;i++)
		//{
		//    SC_TRACE_ADD(dout[i]);
		//}
	}

	SC_CTOR_TEMPLATE(_sc_stream_splitter_fix) {
		hls_array_partition_complete(dout);
		SC_CTHREAD(thread_sc_stream_splitter_fix, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_splitter_fix() {
		HLS_DEBUG(1, 1, 0, "init thread");
		sc_uint<hwcore::hf::log2_ceil<N>::val> idx = 0; // sc_uint<hf::log2_ceil<N>::val>
		// int last_count = 0;
		while (true) {
			hls_loop();
			idx = 0;
			interface_T tmp_in;

			do {
				hls_pipeline(1);
				din.read(tmp_in);

				dout[idx].write(tmp_in);
				if (idx == N - 1) {
					idx = 0;
				} else {
					idx++;
				}

			} while (tmp_in.tlast == 0);

			if (Unvalid_fill) {

				for (int i = 0; i < N; i++) {
					hls_unroll();
					if (i >= idx && idx != 0) {
						tmp_in.setUnvalid();
						dout[i].write(tmp_in);
					}
				}
			}

			if (SendEOP) {
				for (int i = 0; i < N; i++) {
					hls_unroll();
					tmp_in.setEOP();
					dout[i].write(tmp_in);
				}
			}
		}
	}
};

template <class T, int N> SC_MODULE(_sc_stream_splitter_clone) {

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<T> din;
	// hwcore::hf::sc_vector< sc_fifo_out<T >, N > dout;
	sc_fifo_out<T> dout[N];
	SC_CTOR_TEMPLATE(_sc_stream_splitter_clone) {
		hls_array_partition_complete(dout);

		SC_CTHREAD(thread_sc_stream_splitter_clone, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_splitter_clone() {
	main_loop:
		while (true) {
			hls_loop();
			T tmp_in;
			din.read(tmp_in);
			for (int i = 0; i < N; i++) {
				hls_unroll();
				dout[i].write(tmp_in);
			}
		}
	}
};

template <class T, int N> SC_MODULE(_sc_stream_splitter_clone_EOP) {

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<T> din;
	// hwcore::hf::sc_vector< sc_fifo_out<T >, N > dout;
	sc_fifo_out<T> dout[N];
	SC_CTOR_TEMPLATE(_sc_stream_splitter_clone_EOP) {
		hls_array_partition_complete(dout);

		SC_CTHREAD(thread_sc_stream_splitter_clone_EOP, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_splitter_clone_EOP() {
	main_loop:
		while (true) {
			hls_loop();
			T tmp_in;
			do {
				hls_pipeline(1);
				din.read(tmp_in);
				for (int i = 0; i < N; i++) {
					hls_unroll();
					dout[i].write(tmp_in);
				}

			} while (!tmp_in.EOP());
		}
	}
};

namespace hwcore {
namespace pipes {

#ifndef __tag
template <int W, int N, bool SendEOP = true, bool Unvalid_fill = true>
using sc_stream_splitter = ::_sc_stream_splitter<W, N, SendEOP, Unvalid_fill>;

template <int W, int N, bool SendEOP = true, bool Unvalid_fill = true>
using sc_stream_splitter_fix = ::_sc_stream_splitter_fix<W, N, SendEOP, Unvalid_fill>;

template <class T, int N> using sc_stream_splitter_clone = ::_sc_stream_splitter_clone<T, N>;
template <class T, int N> using sc_stream_splitter_clone_EOP = ::_sc_stream_splitter_clone_EOP<T, N>;
#else
namespace __tag {
template <int W, int N, bool SendEOP = true, bool Unvalid_fill = true>
using sc_stream_splitter = ::_sc_stream_splitter<W, N, SendEOP, Unvalid_fill>;

template <int W, int N, bool SendEOP = true, bool Unvalid_fill = true>
using sc_stream_splitter_fix = ::_sc_stream_splitter_fix<W, N, SendEOP, Unvalid_fill>;

template <class T, int N> using sc_stream_splitter_clone = ::_sc_stream_splitter_clone<T, N>;
template <class T, int N> using sc_stream_splitter_clone_EOP = ::_sc_stream_splitter_clone_EOP<T, N>;
} // namespace __tag
#endif

} // namespace pipes
} // namespace hwcore

#ifndef __tag
//#endif
#else
#undef __tag
#endif