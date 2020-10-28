/*
 *  Created on: 15. aug. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#include "hwcore/hf/helperlib.h"
#include "hwcore/hw/hw.h"
#include "hwcore/pipes/data_types.h"
#include <systemc.h>

#ifndef __tag
#warning __tag not defined!!!
#undef _sc_stream_2D_2_vec
#else
#define _sc_stream_2D_2_vec JOIN(_sc_stream_2D_2_vec, __tag)
#endif

template <typename T, int maxShift, int stepSize> struct hw_rol {
	inline T rol(T &data, int shift) {
		if (shift >= maxShift) {
			return data.lrotate(maxShift * stepSize);
		} else {
			return hw_rol<T, maxShift - 1, stepSize>(data, shift);
		}
	}
};

template <typename T, int stepSize> struct hw_rol<T, 0, stepSize> {
	inline T rol(T &data, int shift) { return data; }
};

template <typename T, int maxShift, int stepSize> struct hw_shift_left {
	hw_shift_left<T, maxShift - 1, stepSize> _next;

	inline T shift(T &data, int shift) {
		if (shift >= maxShift) {
			return data << (maxShift * stepSize);
		} else {
			return _next.shift(data, shift);
		}
	}
};

template <typename T, int stepSize> struct hw_shift_left<T, 0, stepSize> {
	inline T shift(T &data, int shift) { return data; }
};

template <typename T, int maxShift, int stepSize> struct hw_shift_right {
	hw_shift_right<T, maxShift - 1, stepSize> _next;
	inline T shift(T &data, int shift) {
		if (shift >= maxShift) {
			return data >> (maxShift * stepSize);
		} else {
			return _next.shift(data, shift);
		}
	}
};

template <typename T, int stepSize> struct hw_shift_right<T, 0, stepSize> {
	inline T shift(T &data, int shift) { return data; }
};

template <int W, int N_rows, int BRAM_SIZE> SC_MODULE(_sc_stream_2D_2_vec) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N_rows>::interface_T interface_T;
	// typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W*BW*N_rows>::interface_T interface_out_T;

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<interface_T> din;
	sc_fifo_out<interface_T> dout;

	sc_fifo_in<int> ctrl_stride;
	sc_fifo_in<int> ctrl_N_channels;
	sc_fifo_in<int> ctrl_N_row_pkg;

	sc_fifo_in<int> ctrl_size;

	SC_CTOR(_sc_stream_2D_2_vec) {
		SC_CTHREAD(thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread() {

		sc_bv<W * N_rows * 2> buffer;
		sc_bv<W * N_rows * 2> out_buffer;
		hw_shift_left<sc_bv<W * N_rows * 2>, N_rows * 2, W> shifter;
		hw_shift_right<sc_bv<W * N_rows * 2>, N_rows * 2, W> shifter_right;
		while (true) {
#warning Not supporting EOP
			HLS_DEBUG(1, 1, 0, "waiting on ctrls");
			int size = ctrl_size.read();
			int stride = ctrl_stride.read();
			int channels = ctrl_N_channels.read();
			int row_pkg = ctrl_N_row_pkg.read();
			// int N_raw_data = channels*row_pkg;
			HLS_DEBUG(1, 1, 0, "got ctrls: size %d, stride %d, channels %d, row_pkg %d", size, stride, channels,
			          row_pkg);
			int ptr = 0;
			int next_trans = 0;
			bool last = false;
			bool EOP = false;
			int stride_count = 0;
			do {
				for (int pkg = 0; pkg < row_pkg; pkg++) // warning bad pipelining fixme
				{
					bool stride_skip = (stride_count == 0 ? false : true);
					stride_count = (stride_count + 1 >= stride ? 0 : stride_count + 1);

					for (int chan = 0; chan < channels; chan) {
						interface_T tmp;
						HLS_DEBUG(1, 1, 0, "waiting on data");
						din.read(tmp);
						HLS_DEBUG(1, 1, 0, "got data");
						EOP = tmp.EOP();
						last = tmp.tlast;
						if (EOP)
							break;
						if (!stride_skip) {

							buffer(0, W * N_rows - 1) = tmp.data;

							out_buffer = shifter.shift(out_buffer, size) | shifter_right.shift(buffer, N_rows - size);

							ptr += size;
							if ((ptr >= N_rows || last) && !EOP) {
								interface_T tmp_out;
								int cut = ptr - N_rows;
								tmp_out.data = shifter_right.shift(out_buffer, cut)(0, 1 * W * N_rows - 1);
								tmp_out.tlast = last;

								tmp_out.template setKeep<W>((ptr >= N_rows ? N_rows : ptr));
								HLS_DEBUG(1, 1, 0, "sending data");
								dout.write(tmp_out);
								HLS_DEBUG(1, 1, 0, "sending data - done");
								if (!last)
									ptr -= N_rows;
								else
									ptr = 0;
							}
						}
					}
					if (EOP)
						break;
				}

				// ptr = (ptr+1 < out_BW_MUL ? ptr+1 : 0);

			} while (!EOP);
			interface_T tmp_out;
			tmp_out.setEOP();
			dout.write(tmp_out);
		}
	}
};

namespace hwcore {
namespace pipes {
template <int W, int N_rows, int BRAM_SIZE> using sc_stream_2D_2_vec = _sc_stream_2D_2_vec<W, N_rows, BRAM_SIZE>;
}
} // namespace hwcore