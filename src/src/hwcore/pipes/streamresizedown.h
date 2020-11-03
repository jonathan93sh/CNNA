/*
 *  Created on: 28. aug. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

#ifndef __tag
#warning __tag not defined!!!
#undef _sc_stream_resize_down_skipper
#undef _sc_stream_resize_down_fast
#undef _sc_stream_resize_down_fast_v2
#else
#undef _sc_stream_resize_down_skipper
#undef _sc_stream_resize_down_fast
#define _sc_stream_resize_down_skipper JOIN(_sc_stream_resize_down_skipper_, __tag)
#define _sc_stream_resize_down_fast JOIN(_sc_stream_resize_down_fast_, __tag)
#define _sc_stream_resize_down_fast_v2 JOIN(_sc_stream_resize_down_fast_v2_, __tag)
#endif

template <int W, int Nin, int Nout> SC_MODULE(_sc_stream_resize_down_skipper) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nin>::interface_T din_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nout>::interface_T dout_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nin>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nout>::interface_T out_T;
	enum { down_scale = Nin / Nout };
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<in_T> din;
	sc_fifo_out<out_T> dout;

	SC_CTOR_TEMPLATE(_sc_stream_resize_down_skipper) {
		SC_CTHREAD(thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread() {
		int count_in = 0;
		int count_out = 0;
		while (true) {
			hls_loop();
			in_T tmp_in = din.read();
			count_in++;
			if (tmp_in.EOP()) {
				out_T tmp_out;
				tmp_out.setEOP();
				dout.write(tmp_out);
			} else {
				sc_uint<down_scale + 1> max = 0;
				for (int i = 0; i < down_scale; i++) {
					hls_unroll();
					max[i] = tmp_in.template getKeep<W * Nout>(i);
				}

				for (int i = 0; (max[i] != 0) && (i < down_scale); i++) {
					hls_pipeline(1);
					out_T tmp_out;
					tmp_out.data = tmp_in.template getData<sc_bv, W * Nout>(i);
					tmp_out.tkeep = tmp_in.tkeep((W * Nout / 8) * (i + 1) - 1, (W * Nout / 8) * i);
					if (max[i + 1] == 0) {
						tmp_out.tlast = tmp_in.tlast;
					} else {
						tmp_out.tlast = 0;
					}

					dout.write(tmp_out);
					count_out++;
					HLS_DEBUG(1, 1, 0, "PKG in(%d), PKG out(%d)", count_in, count_out);
				}
			}
		}
	}
};

template <int W, int Nin, int Nout> SC_MODULE(_sc_stream_resize_down_fast) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nin>::interface_T din_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nout>::interface_T dout_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nin>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nout>::interface_T out_T;
	enum { down_scale = Nin / Nout };
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<in_T> din;
	sc_fifo_out<out_T> dout;

	SC_CTOR_TEMPLATE(_sc_stream_resize_down_fast) {
		SC_CTHREAD(thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread() {
		int count_in = 0;
		int count_out = 0;
		while (true) {
			hls_loop();
			in_T tmp_in = din.read();
			count_in++;
			if (tmp_in.EOP()) {
				out_T tmp_out;
				tmp_out.setEOP();
				dout.write(tmp_out);
			} else {
				sc_uint<down_scale + 1> max = 0;
				for (int i = 0; i < down_scale; i++) {
					hls_unroll();
					max[i] = tmp_in.template getKeep<W * Nout>(i);
				}

				for (int i = 0; i < down_scale; i++) {
					hls_pipeline(1);
					out_T tmp_out;
					tmp_out.data = tmp_in.template getData<sc_bv, W * Nout>(i);
					tmp_out.tkeep = tmp_in.tkeep((W * Nout / 8) * (i + 1) - 1, (W * Nout / 8) * i);
					if (max[i + 1] == 0) {
						tmp_out.tlast = tmp_in.tlast;
					} else {
						tmp_out.tlast = 0;
					}
					if (max[i] == 1) {
						dout.write(tmp_out);
						count_out++;
					}

					HLS_DEBUG(1, 1, 0, "PKG in(%d), PKG out(%d)", count_in, count_out);
				}
			}
		}
	}
};

template <int W, int Nin, int Nout> SC_MODULE(_sc_stream_resize_down_fast_v2) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nin>::interface_T din_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nout>::interface_T dout_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nin>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * Nout>::interface_T out_T;
	enum { down_scale = Nin / Nout };
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<in_T> din;
	sc_fifo_out<out_T> dout;

	SC_CTOR_TEMPLATE(_sc_stream_resize_down_fast_v2) {
		SC_CTHREAD(thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread() {

		sc_uint<hwcore::hf::log2_ceil<down_scale + 1>::val> i = down_scale;
		sc_uint<down_scale + 1> max = 0;
		in_T tmp_in;
		while (true) {
			hls_pipeline(1);

			if (i == down_scale) {
				if (din.nb_read(tmp_in)) {
					i = 0;
					for (int a = 0; a < down_scale; a++) {
						hls_unroll();
						max[a] = tmp_in.template getKeep<W * Nout>(a);
					}
				}
			}

			if (i < down_scale) {
				if (tmp_in.EOP()) {
					out_T tmp_out;
					tmp_out.setEOP();
					if (dout.nb_write(tmp_out)) {
						i = down_scale;
					}
				} else {
					out_T tmp_out;
					tmp_out.data = tmp_in.template getData<sc_bv, W * Nout>(i);
					tmp_out.tkeep = tmp_in.tkeep((W * Nout / 8) * (i + 1) - 1, (W * Nout / 8) * i);
					if (max[i + 1] == 0) {
						tmp_out.tlast = tmp_in.tlast;
					} else {
						tmp_out.tlast = 0;
					}

					if (max[i] == 1) {
						if (dout.nb_write(tmp_out)) {
							if (tmp_out.tlast == 1) {
								i = down_scale;
							} else {
								i++;
							}
						}
					}
				}
			}
		}
	}
};
/*
template<class T>
struct get_din_data_type
{
    typedef void type;
};

void test()
{
    _sc_stream_resize_down_skipper<32,4,1> test_("test");
    decltype(test_.din)::data_type itf;
    decltype(_sc_stream_resize_down_skipper<32,4,1>::din)::data_type itf2;
}
*/
namespace hwcore {
namespace pipes {
#ifndef __tag
template <int W, int Nin, int Nout>
using sc_stream_resize_down_skipper = ::_sc_stream_resize_down_skipper<W, Nin, Nout>;
template <int W, int Nin, int Nout> using sc_stream_resize_down_fast = ::_sc_stream_resize_down_fast<W, Nin, Nout>;
template <int W, int Nin, int Nout>
using sc_stream_resize_down_fast_v2 = ::_sc_stream_resize_down_fast_v2<W, Nin, Nout>;
#else
namespace __tag {
template <int W, int Nin, int Nout>
using sc_stream_resize_down_skipper = ::_sc_stream_resize_down_skipper<W, Nin, Nout>;
template <int W, int Nin, int Nout> using sc_stream_resize_down_fast = ::_sc_stream_resize_down_fast<W, Nin, Nout>;
template <int W, int Nin, int Nout>
using sc_stream_resize_down_fast_v2 = ::_sc_stream_resize_down_fast_v2<W, Nin, Nout>;
} // namespace __tag
#endif
} // namespace pipes
} // namespace hwcore

#ifndef __tag
//#endif
#else
#undef __tag
#endif