/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include <systemc.h>
//#include "cnn.h"
//#include "hwcore/pipes/pipes.h"

#include "hwcore/pipes/data_types.h"

#include "hwcore/pipes/streamimagedatafix.h"

#include "hwcore/pipes/streambuffer.h"

#include "hwcore/pipes/streamcircularlinebuffer.h"
//#include "hwcore/pipes/streampipe.h"
#define __tag inst_db
#include "hwcore/pipes/streamrealign.h"
#define __tag inst_db
#include "hwcore/pipes/streamresizedown.h"
#define __tag inst_db
#include "hwcore/pipes/streamreverse.h"
#define __tag inst_db
#include "hwcore/pipes/streamrouter.h"
#define __tag inst_db
#include "hwcore/cnn/pool.h"
#define __tag inst_db_inst2
#include "hwcore/pipes/streamresize.h"

//#define TEMPLATE_REPLACE

#ifndef TEMPLATE_REPLACE
template <int W, int P, int BW, int N_rows, int RAM_SIZE, int WINDOW_SIZE, int Nout>
#else
#define W 32
#define N_rows 12
#define RAM_SIZE 1024
#define WINDOW_SIZE 1024
#define Nout 3
#endif
SC_MODULE(_data_buffer_TWO_D) {
  public: // interface
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * BW>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * BW * Nout>::interface_T out_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W * BW * N_rows>::interface_T out_raw_T;
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<in_T> din;
	sc_fifo_out<out_T> dout;
	sc_fifo_out<out_raw_T> dout_raw;
	sc_fifo_in<sc_uint<32> > ctrl_image_size;
	sc_fifo_in<sc_uint<16> > ctrl_row_size_pkg;
	sc_fifo_in<sc_uint<16> > ctrl_window_size;
	sc_fifo_in<sc_uint<16> > ctrl_depth;
	sc_fifo_in<sc_uint<16> > ctrl_stride;
	sc_fifo_in<sc_uint<16> > ctrl_replay;
	sc_fifo_in<sc_uint<16> > ctrl_zeropad;
	sc_fifo_in<sc_uint<1> > ctrl_db_output;
	sc_fifo_in<sc_uint<1> > ctrl_image_data;

  public: // modules
	struct units_list {
		enum { realign = 0, clb, reverse, rds };
	};
	// clang-format off
	/*typedef streampipe<hwcore::pipes::sc_stream_realign<W, W, 32>, INT<1>, INT<units_list::realign>,
	                   hwcore::pipes::sc_stream_circularlinebuffer<W, N_rows, RAM_SIZE, WINDOW_SIZE>, INT<1>, INT<units_list::clb>, 
                       hwcore::pipes::sc_stream_reverse<W, N_rows>, INT<1>, INT<units_list::reverse>,
	                   hwcore::pipes::sc_stream_resize_down_skipper<W, N_rows, Nout>, INT<1>, INT<units_list::rds> >
	    pipe_t;*/
	// clang-format on

	// pipe_t stream_pipe;

	hwcore::pipes::sc_stream_imagedatafix<W, P, BW> idf_u0;
	sc_fifo<typename hwcore::pipes::inst_db::sc_stream_realign<W * BW, W * BW, 32>::dout_itf_t> u0_2_u1;
	hwcore::pipes::inst_db::sc_stream_realign<W * BW, W * BW, 32> re_u1;
	sc_fifo<typename hwcore::pipes::inst_db::sc_stream_realign<W * BW, W * BW, 32>::dout_itf_t> u1_2_u2;
	hwcore::pipes::sc_stream_circularlinebuffer<W * BW, N_rows, RAM_SIZE, WINDOW_SIZE> clb_u2;
	sc_fifo<typename hwcore::pipes::sc_stream_circularlinebuffer<W * BW, N_rows, RAM_SIZE, WINDOW_SIZE>::dout_itf_t>
	    u2_2_u4;
	// hwcore::pipes::inst_db::sc_stream_reverse<W, N_rows> rev_u3;
	// sc_fifo<out_raw_T> u3_2_u4;

	hwcore::pipes::sc_stream_router_eop<W * BW * N_rows> router_u4;
	sc_fifo<out_raw_T> u4_2_u5;

#ifndef P_db_skipper_down
	hwcore::pipes::inst_db::sc_stream_resize_down_fast_v2<W * BW, N_rows, Nout> rds_u5;
#else
	hwcore::pipes::inst_db_inst2::sc_stream_resize<W * BW * N_rows, W * BW * Nout> rds_u5;
#endif

	SC_CTOR(_data_buffer_TWO_D)
	    : SC_INST(idf_u0), u0_2_u1(1), SC_INST(re_u1), u1_2_u2(1), SC_INST(clb_u2), u2_2_u4(1), u4_2_u5(1),
	      SC_INST(rds_u5), SC_INST(ctrl_image_size), SC_INST(ctrl_row_size_pkg), SC_INST(ctrl_window_size),
	      SC_INST(ctrl_depth), SC_INST(router_u4), SC_INST(ctrl_stride), SC_INST(ctrl_replay), SC_INST(ctrl_db_output) {

		SC_MODULE_LINK(idf_u0);
		SC_MODULE_LINK(re_u1);
		SC_MODULE_LINK(clb_u2);
		// SC_MODULE_LINK(rev_u3);
		SC_MODULE_LINK(router_u4);
		SC_MODULE_LINK(rds_u5);

		idf_u0.din(din);
		idf_u0.dout(u0_2_u1);
		idf_u0.enable(ctrl_image_data);

		re_u1.din(u0_2_u1);
		re_u1.dout(u1_2_u2);
		clb_u2.din(u1_2_u2);
		clb_u2.dout(u2_2_u4);

		router_u4.din(u2_2_u4);
		router_u4.dout_a(u4_2_u5);
		router_u4.dout_b(dout_raw);
		rds_u5.din(u4_2_u5);
		rds_u5.dout(dout);

		re_u1.ctrl(ctrl_image_size);

		clb_u2.ctrl_row_size_pkg(ctrl_row_size_pkg);
		clb_u2.ctrl_window_size(ctrl_window_size);
		clb_u2.ctrl_depth(ctrl_depth);
		clb_u2.ctrl_stride(ctrl_stride);
		clb_u2.ctrl_replay(ctrl_replay);
		clb_u2.ctrl_zeropad(ctrl_zeropad);
		router_u4.ctrl_channel(ctrl_db_output);
	}
};

namespace hwcore {
namespace cnn {

template <int W, int P, int BW, int N_rows, int RAM_SIZE, int WINDOW_SIZE, int Nout>
using data_buffer_TWO_D = ::_data_buffer_TWO_D<W, P, BW, N_rows, RAM_SIZE, WINDOW_SIZE, Nout>;

} // namespace cnn
} // namespace hwcore
