/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

#ifndef __tag
#warning __tag not defined!!!
#undef _sc_stream_resize_down
#undef _sc_stream_resize_up
#undef _sc_stream_resize_equal
#else
#undef _sc_stream_resize_down
#undef _sc_stream_resize_up
#undef _sc_stream_resize_equal
#define _sc_stream_resize_down JOIN(_sc_stream_resize_down_, __tag)
#define _sc_stream_resize_up JOIN(_sc_stream_resize_up_, __tag)
#define _sc_stream_resize_equal JOIN(_sc_stream_resize_equal_, __tag)
#endif

template <int Win, int Wout, int factor_down = (Win / Wout)> SC_MODULE(_sc_stream_resize_down) {

	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * Win>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * Wout>::interface_T out_T;

	enum {
		// raw_resize_N = (Win >= Wout ? (int)ceil((float)Win / (float)Wout) : (int)ceil((float)Wout / (float)Win))
		raw_resize_N =
		    (Win >= Wout ? hwcore::hf::const_float<Win, Wout>::CEIL : hwcore::hf::const_float<Wout, Win>::CEIL)
	};

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<in_T> din;
	sc_fifo_out<out_T> dout;

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(din);
		// SC_TRACE_ADD(dout);
	}

	SC_CTOR_TEMPLATE(_sc_stream_resize_down) {
		SC_CTHREAD(thread_sc_stream_resize, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_resize() {
		HLS_DEBUG(1, 1, 0, "init thread");

		while (true) {
			hls_pipeline_raw(factor_down);
			in_T tmp_in;
			out_T tmp_out;

			IF_SC_FIFO_NB_READ_FLUSH(din, tmp_in) {

				if (tmp_in.EOP()) {
					wait_approx();
					tmp_out.setEOP();
					dout.write(tmp_out);
				} else {
					hwcore::pipes::sc_data_stream_t<raw_resize_N * Wout> tmp_in_fit;
					tmp_in_fit.template fit<Win>(tmp_in);

					for (int i = 0; i < raw_resize_N; i++) {
						hls_loop();
						tmp_out.data = tmp_in_fit.template getData<sc_bv, Wout>(i);
						tmp_out.tkeep = tmp_in_fit.tkeep((Wout / 8) * (i + 1) - 1, (Wout / 8) * i);
						if (i == raw_resize_N - 1) {
							tmp_out.tlast = tmp_in_fit.tlast;
						} else {
							tmp_out.tlast = 0;
						}

						dout.write(tmp_out);
					}
				}
			}
		}
	}
};

template <int Win, int Wout> SC_MODULE(_sc_stream_resize_up) {

	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * Win>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * Wout>::interface_T out_T;

	enum {
		// raw_resize_N = (Win >= Wout ? (int)ceil((float)Win / (float)Wout) : (int)ceil((float)Wout / (float)Win))
		raw_resize_N =
		    (Win >= Wout ? hwcore::hf::const_float<Win, Wout>::CEIL : hwcore::hf::const_float<Wout, Win>::CEIL)
	};

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<in_T> din;
	sc_fifo_out<out_T> dout;

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(din);
		// SC_TRACE_ADD(dout);
	}

	SC_CTOR_TEMPLATE(_sc_stream_resize_up) {
		SC_CTHREAD(thread_sc_stream_resize, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_sc_stream_resize() {
		HLS_DEBUG(1, 1, 0, "init thread");

		out_T tmp_out;
		tmp_out.setKeep(0);
		int idx = 0;
		bool EOP = false;
		while (true) {
			hls_pipeline(1);
			in_T tmp_in;
			if (EOP) {
				tmp_out.setEOP();
				dout.write(tmp_out);
				EOP = false;
			} else if (!din.nb_read(tmp_in)) {
				wait();
			} else {

				if (tmp_in.EOP()) {
					if (idx != 0) {
						tmp_out.tlast = 1;
						dout.write(tmp_out);
					}

					EOP = true;
					tmp_out.setKeep(0);
					idx = 0;
				} else {
					tmp_out.template setData<sc_bv, Win>(tmp_in.data, idx);
					tmp_out.tkeep((Win / 8) * (idx + 1) - 1, (Win / 8) * idx) = tmp_in.tkeep;
					if (idx == raw_resize_N - 1 || tmp_in.tlast == 1U) {
						tmp_out.tlast = tmp_in.tlast;
						dout.write(tmp_out);
						tmp_out.setKeep(0);
						idx = 0;
					} else {
						idx++;
					}
				}
			}
		}
	}
};

template <int Win, int Wout> SC_MODULE(_sc_stream_resize_equal) {

	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * Win>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * Wout>::interface_T out_T;

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<in_T> din;
	sc_fifo_out<out_T> dout;

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		// SC_TRACE_ADD(din);
		// SC_TRACE_ADD(dout);
	}

	SC_CTOR_TEMPLATE(_sc_stream_resize_equal) {

		SC_CTHREAD(thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread() {
		in_T tmp;
		while (true) {
			do {
				hls_pipeline(1);
				din.read(tmp);
				dout.write(tmp);
			} while (tmp.tlast == 0);
		}
	}
};

namespace hwcore {
namespace pipes {
#ifndef __tag
template <int Win, int Wout>
using _sc_stream_resize_force = typename hwcore::hf::switch_if_t<(Win >= Wout), ::_sc_stream_resize_down<Win, Wout>,
                                                                 ::_sc_stream_resize_up<Win, Wout> >::type;

template <int Win, int Wout>
using sc_stream_resize = typename hwcore::hf::switch_if_t<(Win == Wout), ::_sc_stream_resize_equal<Win, Wout>,
                                                          _sc_stream_resize_force<Win, Wout> >::type;
#else
namespace __tag {
template <int Win, int Wout>
using _sc_stream_resize_force = typename hwcore::hf::switch_if_t<(Win >= Wout), ::_sc_stream_resize_down<Win, Wout>,
                                                                 ::_sc_stream_resize_up<Win, Wout> >::type;

template <int Win, int Wout>
using sc_stream_resize = typename hwcore::hf::switch_if_t<(Win == Wout), ::_sc_stream_resize_equal<Win, Wout>,
                                                          _sc_stream_resize_force<Win, Wout> >::type;

} // namespace __tag
#endif
} // namespace pipes
} // namespace hwcore

#ifndef __tag
//#endif
#else
#undef __tag
#endif