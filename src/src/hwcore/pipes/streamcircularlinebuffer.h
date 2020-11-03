/*
 *  Created on: 12. aug. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#include <systemc.h>
//#pragma once
//
#include "hwcore/hf/helperlib.h"
#include "hwcore/hw/hw.h"
#include "hwcore/pipes/data_types.h"

#ifndef __tag
#warning __tag not defined!!!
#undef _sc_stream_circularlinebuffer
#else
#define _sc_stream_circularlinebuffer JOIN(_sc_stream_circularlinebuffer, __tag)
#endif

// template <int W, int N_rows> struct internal_data;

template <int W, int N_rows>
struct internal_data : public hwcore::pipes::sc_fifo_base_dummy<struct internal_data<W, N_rows> > {
	hwcore::hf::sc_static_data_list<sc_biguint<W>, N_rows> window;
	bool skip;
	bool col_skip;
	bool eol;
	bool tlast;
	bool EOP;
	int row_idx;
	int col_idx;
};

struct internal_ctrl : public hwcore::pipes::sc_fifo_base_dummy<struct internal_ctrl> {
	int window_size_pkg;
	int stride_step_pkg;
	int window_size;
	int depth;
	int stride;
	int replay;
	int image_size;
	bool fc;
};

#if 0
template <int W, int N_rows>
struct shift_data : public hwcore::pipes::sc_fifo_base_dummy<struct internal_data<W, N_rows> > {
	hwcore::hf::sc_static_data_list<sc_biguint<W>, N_rows> window;
	bool tlast;
	bool EOP;
};

template <int W, int N_rows, int BRAM_SIZE, int SHIFT_SIZE> SC_MODULE(_sc_stream_shift) {
  private:
  public:
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N_rows>::interface_T interface_out_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T din_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N_rows>::interface_T dout_itf_t;
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<shift_data<W, N_rows> > din;
	sc_fifo_out<shift_data<W, N_rows> > dout;
	sc_out_opt<int> count_out;

	SC_CTOR_TEMPLATE(_sc_stream_shift) {

		SC_CTHREAD(thread_shift, clk.pos());
		HLS_DEBUG_EXEC(set_stack_size(100 * 1024 * 1024));
		// sc_set_stack_size(thread_handle,100000);
		reset_signal_is(reset, true);
	}

	inline int next_add(int cur) { return (cur + 1 >= SHIFT_SIZE ? 0 : cur + 1); }

	void shift_module() {
		sc_biguint<W> ram[SHIFT_SIZE][N_rows];
		hls_array_partition(ram, block factor = N_rows);

		int write_ptr = 0;
		int from_ptr = 0;
		int to_ptr = 0;
		int read_ptr = 0;
		int repeat_i = 0;

		shift_data<W, N_rows> tmp_in, tmp_out;
		int repeat_n = 0;
		int window_size = 3;
		int pkg_size = 128;
		bool last = false;
		bool done = false;
		bool eop = false;
		while (true) {
			int next_write_ptr = next_add(write_ptr);
			int next_read_ptr = next_add(read_ptr);
			if (next_write_ptr != from_ptr && !last) // allwed to write to buf (din)
			{
				if (din.nb_read(tmp_in)) {
					for (int i = 0; i < N_rows; i++) {
						hls_unroll();
						ram[write_ptr][i] = tmp_in.window.get(i);
					}
					last = tmp_in.tlast;
					eop = tmp_in.EOP;
				}
				write_ptr = next_write_ptr;
			}

			if (next_read_ptr != next_write_ptr) {
				for (int i = 0; i < N_rows; i++) {
					hls_unroll();
					tmp_out.window.get(i) = ram[read_ptr][i];
				}
				if (dout.nb_write(tmp_out)) {
					if (read_ptr == to_ptr) {
						if (repeat_i < repeat_n) {
							repeat_i++;
						}
					}
				}
			}
		}

		hwcore::hw::shiftreg_memory<sc_biguint<W>, SHIFT_SIZE> sr[N_rows];
		int cur = 0;
	}
};
#endif
#define _sc_stream_shift JOIN(_sc_stream_circularlinebuffer, _shift)

template <int W, int N_rows, int BRAM_SIZE, int SHIFT_SIZE> SC_MODULE(_sc_stream_shift) {
  private:
  public:
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N_rows>::interface_T interface_out_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T din_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N_rows>::interface_T dout_itf_t;
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<internal_data<W, N_rows> > din;
	sc_fifo_out<interface_out_T> dout;
	sc_fifo_in<internal_ctrl> ctrl;
	sc_out_opt<int> count_out;

	SC_CTOR_TEMPLATE(_sc_stream_shift) {

		SC_CTHREAD(thread_shift, clk.pos());
		HLS_DEBUG_EXEC(set_stack_size(100 * 1024 * 1024));
		// sc_set_stack_size(thread_handle,100000);
		reset_signal_is(reset, true);
	}

	void thread_shift() {
		hwcore::hf::sc_static_data_list<hwcore::hw::shiftreg_memory<sc_biguint<W>, SHIFT_SIZE>, N_rows> sr;
		// hwcore::hw::shiftreg_memory<sc_biguint<W>, SHIFT_SIZE> sr[N_rows];
		int count = 0;
		int count_in = 0;

	main:
		while (true) {
			hls_loop();

			internal_ctrl ctrl_tmp = ctrl.read();

			if (ctrl_tmp.fc) {
				internal_data<W, N_rows> tmp_in;
				sc_uint<hwcore::hf::log2_ceil<N_rows + 1>::val> fc_ptr = 0;
				sc_biguint<W> output_fc[N_rows];
				hls_array_partition_complete(output_fc);

			fc_loop:
				do {
					hls_pipeline(1);
					tmp_in = din.read();
					if (!tmp_in.EOP) {
						output_fc[(fc_ptr < N_rows ? fc_ptr : sc_uint<hwcore::hf::log2_ceil<N_rows + 1>::val>(0))] =
						    tmp_in.window.get(0);

						if (fc_ptr + 1 < N_rows && !tmp_in.tlast) {
							fc_ptr++;
						} else {

							interface_out_T raw_out;

							raw_out.template setData<sc_biguint, W, N_rows>(output_fc);
							raw_out.template setKeep<W>(fc_ptr + 1);
							raw_out.tlast = tmp_in.tlast;
							dout.write(raw_out);
							fc_ptr = 0;
						}
					}

				} while (!tmp_in.EOP);
				interface_out_T tmp;
				tmp.setEOP();
				dout.write(tmp);

			} else {
				internal_data<W, N_rows> tmp_in;
				bool stide_equal_window = (ctrl_tmp.window_size == ctrl_tmp.stride);
				bool pure_stream = stide_equal_window && (ctrl_tmp.replay == 1);
				int stride_offset = ctrl_tmp.window_size - ctrl_tmp.stride;
				int window_offset = (ctrl_tmp.window_size - 1);
				int stride_start = ctrl_tmp.stride_step_pkg - 1;
				int window_start = ctrl_tmp.window_size_pkg - 1;
			conv_loop:
				do {
					/* code */

				conv_slide_in_load_loop:
					do {
						hls_pipeline(1);
						tmp_in = din.read();

						if (!tmp_in.EOP) {
							sc_biguint<W> output_direct[N_rows];
							hls_array_partition_complete(output_direct);
							for (int i = 0; i < N_rows; i++) {
								hls_unroll();
								sr.get(i) << tmp_in.window.get(i);
								output_direct[i] = (i < ctrl_tmp.window_size ? tmp_in.window.get(i) : sc_biguint<W>(0));
							}
							interface_out_T raw_out;
							raw_out.template setData<sc_biguint, W, N_rows>(output_direct);
							raw_out.template setKeep<W>(ctrl_tmp.window_size);
							raw_out.tlast = (tmp_in.skip ? 0 : 1);
							if (!tmp_in.col_skip)
								dout.write(raw_out);
						}

					} while ((tmp_in.skip || pure_stream) && !tmp_in.EOP);
					// replay window part
					if (!tmp_in.EOP) {
						int N_re = ctrl_tmp.replay + (tmp_in.eol || stide_equal_window ? 0 : 1);
						for (int i_re = 0; i_re < N_re; i_re++) {
							hls_loop();
							int cur_row_idx;
							int local_depth_count = 0;
							int start_pos;
							bool pre_stream = (i_re == ctrl_tmp.replay);
							if (pre_stream) {
								cur_row_idx = tmp_in.row_idx - stride_offset;
								start_pos = stride_start;
							} else {
								cur_row_idx = tmp_in.row_idx - window_offset;
								start_pos = window_start;
							}

						stream_loop:
							for (int i = start_pos; i >= 0; i--) {
								hls_pipeline(1);

								sc_biguint<W> output_tmp[N_rows];
								hls_array_partition_complete(output_tmp);

								for (int w = 0; w < N_rows; w++) {
									hls_unroll();
									int cur_col_idx = tmp_in.col_idx - w;
									output_tmp[w] = (w < ctrl_tmp.window_size ? sr.get(w)[i] : sc_biguint<W>(0));
									//(0 <= cur_row_idx && cur_row_idx < ctrl_tmp.image_size && 0 <= cur_col_idx &&
									//         cur_col_idx < ctrl_tmp.image_size && w < ctrl_tmp.window_size
									//     ? sr.get(w)[i]
									//     : sc_biguint<W>(0));
								}

								interface_out_T raw_out;

								raw_out.template setData<sc_biguint, W, N_rows>(output_tmp);
								raw_out.template setKeep<W>(ctrl_tmp.window_size);
								raw_out.tlast = (i == 0 && !pre_stream ? sc_uint<1>(1) : sc_uint<1>(0));

								dout.write(raw_out);
								if (local_depth_count == ctrl_tmp.depth - 1) {
									local_depth_count = 0;
									cur_row_idx++;
								} else {
									local_depth_count++;
								}
							}
						}
					}
				} while (!tmp_in.EOP);
				interface_out_T tmp;
				tmp.setEOP();
				dout.write(tmp);
				HLS_DEBUG(1, 1, 0, "EOP");
			}
		}
	}
};

//! V2 ------------------------------------###############--------------------------------------------- V2

template <int W, int N_rows, int BRAM_SIZE, int SHIFT_SIZE> SC_MODULE(_sc_stream_circularlinebuffer_v2) {
  public:
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N_rows>::interface_T interface_out_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T din_itf_t;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * N_rows>::interface_T dout_itf_t;

  private:
	sc_fifo<internal_data<W, N_rows> > clb_2_shift;
	sc_fifo<internal_ctrl> clb_2_shift_ctrl;
	_sc_stream_shift<W, N_rows, BRAM_SIZE, SHIFT_SIZE> clb_shift;

  public:
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<interface_T> din;
	sc_fifo_out<interface_out_T> dout;
	sc_fifo_in<sc_uint<16> > ctrl_row_size_pkg;
	sc_fifo_in<sc_uint<16> > ctrl_window_size;
	sc_fifo_in<sc_uint<16> > ctrl_depth;
	sc_fifo_in<sc_uint<16> > ctrl_stride;
	sc_fifo_in<sc_uint<16> > ctrl_replay;
	sc_fifo_in<sc_uint<16> > ctrl_zeropad;

	sc_out_opt<int> count_in;
	sc_out_opt<int> count_out;

	SC_CTOR_TEMPLATE(_sc_stream_circularlinebuffer_v2)
	    : SC_INST(ctrl_row_size_pkg), SC_INST(ctrl_window_size), clb_2_shift(4), SC_INST(clb_shift),
	      clb_2_shift_ctrl(1) {
		SC_CTHREAD(thread_clb, clk.pos());
		HLS_DEBUG_EXEC(set_stack_size(100 * 1024 * 1024));

		SC_MODULE_LINK(clb_shift);
		clb_shift.din(clb_2_shift);
		clb_shift.dout(dout);
		clb_shift.count_out(count_out);
		clb_shift.ctrl(clb_2_shift_ctrl);

		// sc_set_stack_size(thread_handle,100000);
		reset_signal_is(reset, true);
	}

	void thread_clb() {
		int count = 0;
		count_in.write(count);
		hwcore::hw::circular_line_buffer<N_rows, BRAM_SIZE, W> clb;

		sc_uint<16> row_size, row_size_pkg, stride, col_size, depth, window_size, replay, zero_pad;

		interface_T raw_in;
		sc_biguint<W> tmp_in;
		sc_biguint<W> window_tmp[N_rows];
		hls_array_partition_complete(window_tmp);

		internal_ctrl shift_ctrl;

		while (true) {
			hls_loop();

			raw_in.data = 0;
			raw_in.tlast = 0;
			raw_in.setKeep();
			tmp_in = 0;
			for (int i = 0; i < N_rows; i++) {
				hls_unroll();
				window_tmp[i] = 0;
			}

			HLS_DEBUG(1, 1, 0, "Waiting on ctrls");
			row_size = ctrl_row_size_pkg.read();
			stride = ctrl_stride.read();
			depth = ctrl_depth.read();
			window_size = ctrl_window_size.read();
			replay = ctrl_replay.read();
			zero_pad = ctrl_zeropad.read();

			int row_size_pkg = row_size * depth;
			int window_size_pkg = window_size * depth;
			HLS_DEBUG(1, 1, 0,
			          "got ctrls (size,stride,depth,w_size,replay): (%d,%d,%d,%d,%d) -------------------- new image",
			          row_size_pkg, stride.to_int(), depth.to_int(), window_size.to_int(), replay.to_int());
			// zero_pad = ctrl_zero_pad.read();
			bool EOP = false;
			int stride_count_col = 0;
			int col_nr = 0;
			int zp_count = zero_pad;

			bool fc_en = (window_size_pkg == 0 && zero_pad == 0 && stride == 0);

			shift_ctrl.depth = depth;
			shift_ctrl.fc = fc_en;
			shift_ctrl.image_size = row_size + zero_pad * 2;
			shift_ctrl.replay = replay;
			shift_ctrl.stride = stride + 1;
			shift_ctrl.stride_step_pkg = (window_size - shift_ctrl.stride) * depth;
			shift_ctrl.window_size = window_size;
			shift_ctrl.window_size_pkg = window_size_pkg;

			if (fc_en) { // fc part
				clb_2_shift_ctrl.write(shift_ctrl);
				fc(clb, replay);
			} else { // conv part
				clb_2_shift_ctrl.write(shift_ctrl);
				int u_start = -(zero_pad * depth);
				int u_end = row_size_pkg + (zero_pad * depth);
				do {
					hls_loop();
					const bool stride_skip_col =
					    (stride_count_col == 0 ? false : true) || (col_nr + zero_pad < window_size - 1);

					stride_count_col =
					    (stride_count_col >= stride || (col_nr + zero_pad < window_size - 1) ? 0
					                                                                         : stride_count_col + 1);

					// HLS_DEBUG(1, 1, 0, "stride skip (skip,stride_count_col,stride): (%s,%d,%d)", (stride_skip ?
					// "true" : "false"), stride_count_col, stride);
					// for (int re = 0; re <= replay; re++) {

					int stride_count_row = 0;
					int row_nr = 0;
					int stride_count_channels_row = 0;

					for (int u = u_start; u < u_end; u++) { //
						hls_pipeline(1);
						//				|-|-|s|
						//				|w|w|w|
						// 				|z|d|d|
						// nr 0		     |
						// nr 1            |
						// nr 2 (w_s-1)      |
						const bool stride_skip = stride_skip_col || (stride_count_row == 0 ? false : true) ||
						                         (stride_count_channels_row != depth - 1) ||
						                         (row_nr < window_size - 1); // ||
						//(row_nr + zero_pad < window_size - 1);

						// HLS_DEBUG(1, 1, 0, "row operation (%d/%d)", u + 1, row_size_pkg);
						// if (re == 0) {
						if (0 <= u && u < row_size_pkg && zp_count == zero_pad) {
							din.read(raw_in); // din.read(raw_in);
							count++;
							count_in.write(count);
							tmp_in = raw_in.data;
						} else {
							tmp_in = 0;
						}

						//}

						// HLS_DEBUG(1, 1, 0, "got data: %d, EOP? %s, tlast: %d", tmp_in.to_int(), (raw_in.EOP() ?
						// "true" : "false"), raw_in.tlast.to_int());

						HLS_DEBUG(1, 1, 0,
						          "(size,stride,depth,w_size,replay): (%d,%d,%d,%d,%d) - "
						          "[col,row,row_raw,skip][%d,%d,%d,%s] - data_in: %d, EOP? %s, "
						          "tlast: %d",
						          row_size_pkg, stride.to_int(), depth.to_int(), window_size.to_int(), replay.to_int(),
						          col_nr, row_nr, row_size_pkg, (stride_skip ? "true" : "false"), tmp_in.to_int(),
						          (raw_in.EOP() ? "true" : "false"), raw_in.tlast.to_int());

						clb.exec(tmp_in, u, window_tmp, true); // re == 0);

						// send to shift reg
						internal_data<W, N_rows> tmp_out;
						// tmp_out.window_size_pkg = window_size_pkg;
						// tmp_out.window_size = window_size;
						tmp_out.skip = stride_skip;
						tmp_out.col_skip = stride_skip_col;
						tmp_out.tlast = raw_in.tlast;
						tmp_out.EOP = raw_in.EOP();
						// tmp_out.replay = replay;
						tmp_out.col_idx = col_nr;
						tmp_out.row_idx = row_nr;
						tmp_out.eol = (u == u_end - 1);
						// tmp_out.image_size = row_size;
						// tmp_out.depth = depth;

						for (int i = 0; i < N_rows; i++) {
							hls_unroll();
							if (col_nr - i < 0) {
								tmp_out.window.get(i) = 0;
							} else {
								tmp_out.window.get(i) = window_tmp[N_rows - i - 1];
							}

							//(col_nr + zero_pad + (N_rows - i - 1) < window_size - 1 ? 0 : window_tmp[i]);
						}
						clb_2_shift.write(tmp_out);
						if (!stride_skip) {
						}
						HLS_DEBUG(1, 1, 0, "PKG out(%d)", count);

						if (stride_count_channels_row + 1 >= depth) {
							stride_count_channels_row = 0;
							stride_count_row = (stride_count_row >= stride || (row_nr < window_size - 1)
							                        ? 0
							                        : stride_count_row + 1); // || (row_nr + zero_pad < window_size - 1)
							row_nr++;
						} else {
							stride_count_channels_row++;
						}

						// forward
						if (raw_in.EOP()) {
							break;
						}
					}
					/*clb.flush(row_size_pkg - 1);
					HLS_DEBUG(1, 1, 0, "flush line");*/
					//}
					clb.EOL_Handle();
					col_nr++;
					HLS_DEBUG(1, 1, 0, "EOL");
					if (raw_in.tlast == 1) //|| col_nr >= row_size - 1)
					{
						if (zp_count == 0) {
							zp_count = zero_pad;
							col_nr = 0;
							stride_count_col = 0;
							HLS_DEBUG(1, 1, 0, "got tlast, waiting for next image ---------------------");
						} else {
							zp_count--;
						}
					}
				} while (!raw_in.EOP() && !(row_size_pkg <= 0));
				HLS_DEBUG(1, 1, 0, "got EOP");
			}
		}
	}

	void fc(hwcore::hw::circular_line_buffer<N_rows, BRAM_SIZE, W> & clb, int replay) {
		interface_T raw_in;
		// sc_biguint<W> tmp_in;
		// sc_biguint<W> window_tmp[N_rows];
		internal_data<W, N_rows> tmp_out;
		tmp_out.skip = false;
		tmp_out.col_idx = 0;
		tmp_out.row_idx = 0;

		for (int i = 0; i < N_rows; i++) {
			hls_unroll();
			tmp_out.window.get(i) = 0;
		}

		do {
			hls_loop();
			// int ptr_ram = 0;
			// int ptr_add = 0;
			// int size_counter = 0;
			do {
				hls_pipeline(1);
				din.read(raw_in);
				/*size_counter++;
				clb.get_raw_ram().get(ptr_ram).exec(raw_in.data, (ptr_add < BRAM_SIZE ? ptr_add : 0), true);
*/
				tmp_out.tlast = raw_in.tlast;
				tmp_out.EOP = raw_in.EOP();
				if (raw_in.EOP()) {
					HLS_DEBUG(1, 1, 0, "EOP");
				}
				tmp_out.window.get(0) = raw_in.data;

				clb_2_shift.write(tmp_out);
				/*
				                if (ptr_ram + 1 < N_rows - 1) {
				                    ptr_ram++;
				                } else {
				                    ptr_ram = 0;
				                    ptr_add++;
				                }
				*/
			} while (raw_in.tlast == 0);
			/*
			            for (int i = 0; i < N_rows - 1; i++) {
			                hls_unroll();
			                clb.get_raw_ram().get(i).flush();
			            }

			            if (!raw_in.EOP()) {
			                for (int re = 0; re < replay; re++) {
			                    hls_loop();
			                    ptr_ram = 0;
			                    ptr_add = 0;
			                    for (int i = 0; i < size_counter; i++) {
			                        hls_pipeline(1);
			                        tmp_out.tlast = (i == size_counter - 1);
			                        tmp_out.EOP = false;

			                        tmp_out.window.get(0) =
			                            clb.get_raw_ram().get(ptr_ram).exec(0, (ptr_add < BRAM_SIZE ? ptr_add : 0),
			   false);

			                        clb_2_shift.write(tmp_out);

			                        if (ptr_ram + 1 < N_rows - 1) {
			                            ptr_ram++;
			                        } else {
			                            ptr_ram = 0;
			                            ptr_add++;
			                        }
			                    }
			                }
			            }
			            */

		} while (!raw_in.EOP());
	}
};

namespace hwcore {
namespace pipes {
template <int W, int N_rows, int BRAM_SIZE, int SHIFT_SIZE>
using sc_stream_circularlinebuffer = ::_sc_stream_circularlinebuffer_v2<W, N_rows, BRAM_SIZE, SHIFT_SIZE>;
}
} // namespace hwcore
