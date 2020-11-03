/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include <systemc.h>

#include "hwcore/pipes/pipes.h"

#include "hwcore/cnn/cnn.h"
#include "hwcore/cnn/pool.h"
#include "hwcore/hw/statusreg.h"
#include "hwcore/pipes/streambias.h"

#include "hwcore/cnn/data_buffer.h"
#define __tag inst_1
#include "hwcore/pipes/streamstitching.h"
#define __tag inst_1
#include "hwcore/pipes/streamlastfix.h"
#define __tag inst_1
#include "hwcore/pipes/streamrealign.h"
#define __tag inst_1
#include "hwcore/pipes/streamresize.h"
#define __tag inst_2
#include "hwcore/pipes/streamresize.h"
#define __tag inst_3
#include "hwcore/pipes/streamresize.h"
#define __tag inst_4
#include "hwcore/pipes/streamresize.h"
#define __tag inst_1
#include "hwcore/pipes/streamsplit.h"
#define __tag inst_2
#include "hwcore/pipes/streamsplit.h"
#define __tag inst_3
#include "hwcore/pipes/streamsplit.h"

template <int data_W = 16, int data_P = 2, int input_BW_N = 32, int output_BW_N = 32, int T_pe_n = 16,
          int T_pe_bw_n = 16, int T_wbuf_size = 1024, int T_data_buf_clb_size = 1024, int T_data_buf_clb_n = 3,
          int T_data_buf_shift_size = 1024, int T_data_out_n = 1, int T_pool_size_param = 1024,
          int T_PE_pipeline_II = 1, int T_pe_pre_fifo_deep = 1>
SC_MODULE(_top_cnn) {
  public:
	enum {
		dma_input_width = data_W * input_BW_N,
		dma_output_width = data_W * output_BW_N,
		data_flow_width = data_W * T_pe_bw_n,
		data_flow_pe_width = data_W * T_pe_bw_n * T_data_out_n,
		data_flow_pe_bias_width = data_W * ((T_pe_bw_n * T_data_out_n) + 1),
		data_pe_merge_width = data_W * T_pe_n
	};

	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * data_flow_pe_width>::interface_T data_flow_pe_T;
	typedef
	    typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * data_flow_pe_bias_width>::interface_T data_flow_pe_bias_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * data_flow_width>::interface_T data_flow_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * data_W>::interface_T data_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * data_W * T_pe_n>::interface_T data_pe_merge_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * dma_input_width>::interface_T in_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * dma_output_width>::interface_T out_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * data_flow_width * T_data_buf_clb_n>::interface_T
	    data_db_raw_T;

  public:
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<in_T> data_sink;
	sc_fifo_in<in_T> data_buf_sink;
	sc_fifo_in<in_T> w_sink;

	sc_fifo_out<out_T> data_source;

	sc_fifo_in<sc_uint<31> > weight_ctrls_in;

	sc_fifo_in<sc_uint<32> > ctrl_image_size;
	sc_fifo_in<sc_uint<16> > ctrl_row_size_pkg;
	sc_fifo_in<sc_uint<16> > ctrl_window_size;
	sc_fifo_in<sc_uint<16> > ctrl_depth;
	sc_fifo_in<sc_uint<16> > ctrl_stride;
	sc_fifo_in<sc_uint<16> > ctrl_replay;
	sc_fifo_in<sc_uint<16> > ctrl_zeropad;
	sc_fifo_in<sc_uint<1> > ctrl_db_output;
	sc_fifo_in<sc_uint<1> > ctrl_image_data;

	sc_fifo_in<sc_uint<16> > ctrl_row_N;

	sc_fifo_in<sc_uint<16> > ctrl_acf;

	hwcore::pipes::inst_1::sc_stream_resize<dma_input_width, data_flow_width> resize_u0;
	//#error bruge resize værdier istedet for dma_bw !!!

	sc_fifo<data_flow_T> data_2_u1;

	// weight part
	// hwcore::cnn::weight_buffer2<data_flow_width, T_pe_n, 1> wb_u2;
	hwcore::pipes::inst_3::sc_stream_resize<dma_input_width, data_flow_pe_width> wb_resize;
	sc_fifo<data_flow_pe_T> wb_re_2_u1;
	// hwcore::pipes::inst_1::sc_stream_realign<data_flow_pe_width> realign_u0;
	// sc_fifo<data_flow_pe_T> wb_u0_2_u1;
	hwcore::pipes::sc_stream_splitter_fix<data_flow_pe_width, T_pe_n> wb_package_splitter_u1;
	hwcore::hf::sc_static_list<sc_fifo<data_flow_pe_T>, T_pe_n> wb_u1_2_u2;

	hwcore::pipes::inst_1::sc_stream_splitter_clone<sc_uint<31>, T_pe_n> wb_ctrls_splitter;
	hwcore::hf::sc_static_list<sc_fifo<sc_uint<31> >, T_pe_n> wb_ctrls_split_2_buf;

	hwcore::hf::sc_static_list<hwcore::pipes::sc_stream_buffer_not_stream_while_write<data_flow_pe_width, T_wbuf_size>,
	                           T_pe_n>
	    wb_weight_buf_u2;
	hwcore::hf::sc_static_list<sc_fifo<data_flow_pe_T>, T_pe_n> wb_buf_2_bias;
	hwcore::hf::sc_static_list<hwcore::pipes::sc_stream_bias<data_W, T_pe_bw_n * T_data_out_n>, T_pe_n> wb_bias;
	hwcore::hf::sc_static_list<sc_fifo<data_flow_pe_bias_T>, T_pe_n> wb_2_pe;

	// data part
	_data_buffer_TWO_D<data_W, data_P, T_pe_bw_n, T_data_buf_clb_n, T_data_buf_clb_size, T_data_buf_shift_size,
	                   T_data_out_n>
	    db_u3_1;
	// hwcore::cnn::data_buffer_fc_only<1*data_flow_width> db_u3_1;
	sc_fifo<data_flow_pe_T> db_u3_2_splitter;
	sc_fifo<data_db_raw_T> db_u3_2_pool;
	hwcore::pipes::inst_2::sc_stream_splitter_clone_EOP<data_flow_pe_T, T_pe_n> db_u3_stream_split;

	hwcore::hf::sc_static_list2<sc_fifo<data_flow_pe_T>, T_pe_n> u3_2_u4_array;

	// pooling

	sc_fifo_in<sc_uint<16> > ctrl_pool_depth;
	sc_fifo_in<sc_uint<16> > ctrl_pool_type;
	sc_fifo_in<sc_uint<16> > ctrl_pool_N;
	sc_fifo_in<sc_uint<16> > ctrl_pool_size;

	hwcore::cnn::sc_pooling<data_W, data_P, T_pe_bw_n, T_data_buf_clb_n, T_pool_size_param> pool;
	sc_fifo<data_flow_T> pool_2_re;
	hwcore::pipes::inst_4::sc_stream_resize<data_flow_width, dma_output_width> pool_re;
	sc_fifo<out_T> pool_2_u7;

	inline void pooling_connect() {
		SC_MODULE_LINK(pool);
		SC_MODULE_LINK(pool_re);
		pool.din(db_u3_2_pool);
		pool.dout(pool_2_re);
		pool.ctrl_depth(ctrl_pool_depth);
		pool.ctrl_type(ctrl_pool_type);
		pool.ctrl_N(ctrl_pool_N);
		pool.ctrl_pooling_size(ctrl_pool_size);
		pool_re.din(pool_2_re);
		pool_re.dout(pool_2_u7);
	}

	// PE array

	hwcore::pipes::inst_3::sc_stream_splitter_clone<sc_uint<16>, T_pe_n> ctrl_acf_splitter;
	hwcore::hf::sc_static_list<sc_fifo<sc_uint<16> >, T_pe_n> ctrl_acf_splitter_2_pe;

	hwcore::hf::sc_static_list2<hwcore::cnn::PE<data_W, data_P, T_pe_bw_n * T_data_out_n, T_PE_pipeline_II>, T_pe_n>
	    PE_array_u4;

	hwcore::hf::sc_static_list2<sc_fifo<data_T>, T_pe_n> u4_2_u5_array; //

	hwcore::pipes::sc_stream_merge_raw<data_W, T_pe_n> merge_u5;

	sc_fifo<data_pe_merge_T> u5_2_u6;

	hwcore::pipes::inst_2::sc_stream_resize<data_pe_merge_width, dma_output_width> resize_u6;
	sc_fifo<out_T> u6_2_u7;
	// output
	sc_fifo_in<sc_uint<1> > ctrl_output_channel;
	sc_fifo_in<sc_uint<16> > ctrl_stitch_depth;
	sc_fifo_in<sc_uint<16> > ctrl_stitch_buf_depth;

	hwcore::pipes::sc_stream_router_merge_eop<dma_output_width> merge_output_u7;
	sc_fifo<out_T> u7_2_u8;
	hwcore::pipes::inst_1::sc_stream_last_fix<dma_output_width> last_fix_u8;
	sc_fifo<out_T> u8_2_u9;

	hwcore::pipes::inst_1::sc_stream_stitching<dma_output_width> stitch_u9;

	inline void output_connect() {
		SC_MODULE_LINK(merge_output_u7);
		SC_MODULE_LINK(last_fix_u8);
		SC_MODULE_LINK(stitch_u9);
		merge_output_u7.din_a(u6_2_u7);
		merge_output_u7.din_b(pool_2_u7);
		merge_output_u7.dout(u7_2_u8);
		merge_output_u7.ctrl_channel(ctrl_output_channel);
		last_fix_u8.din(u7_2_u8);
		last_fix_u8.dout(u8_2_u9);
		stitch_u9.din(u8_2_u9);
		stitch_u9.din_buf(data_buf_sink);
		stitch_u9.dout(data_source);
		stitch_u9.ctrl_depth(ctrl_stitch_depth);
		stitch_u9.ctrl_buf_depth(ctrl_stitch_buf_depth);
	}

	struct wb_package_splitter_u1_link {
		static inline void link(_top_cnn &ref, const unsigned i) {

			ref.wb_package_splitter_u1.dout[i](ref.wb_u1_2_u2.get(i));

			ref.wb_ctrls_splitter.dout[i](ref.wb_ctrls_split_2_buf.get(i));

			ref.wb_weight_buf_u2.get(i).clk(ref.clk);
			ref.wb_weight_buf_u2.get(i).reset(ref.reset);
			ref.wb_weight_buf_u2.get(i).din(ref.wb_u1_2_u2.get(i));
			ref.wb_weight_buf_u2.get(i).ctrls_in(ref.wb_ctrls_split_2_buf.get(i));
			ref.wb_weight_buf_u2.get(i).dout(ref.wb_buf_2_bias.get(i));

			ref.wb_bias.get(i).clk(ref.clk);
			ref.wb_bias.get(i).reset(ref.reset);
			ref.wb_bias.get(i).din(ref.wb_buf_2_bias.get(i));
			ref.wb_bias.get(i).dout(ref.wb_2_pe.get(i));

			ref.db_u3_stream_split.dout[i](ref.u3_2_u4_array.get(i));

			ref.ctrl_acf_splitter.dout[i](ref.ctrl_acf_splitter_2_pe.get(i));
			ref.PE_array_u4.get(i).ctrl_acf(ref.ctrl_acf_splitter_2_pe.get(i));

			ref.PE_array_u4.get(i).clk(ref.clk);
			ref.PE_array_u4.get(i).reset(ref.reset);
			ref.PE_array_u4.get(i).Win(ref.wb_2_pe.get(i));
			ref.PE_array_u4.get(i).Xin(ref.u3_2_u4_array.get(i));
			ref.PE_array_u4.get(i).dout(ref.u4_2_u5_array.get(i));
			ref.merge_u5.din[i](ref.u4_2_u5_array.get(i));
		}
	};

	SC_CTOR_TEMPLATE(_top_cnn)
	    : SC_INST(resize_u0), data_2_u1(1), SC_INST(wb_resize), wb_re_2_u1(1), SC_INST(wb_package_splitter_u1),
	      wb_u1_2_u2(1), SC_INST(wb_ctrls_splitter), wb_ctrls_split_2_buf(1), SC_INST(wb_weight_buf_u2),
	      wb_2_pe(T_pe_pre_fifo_deep), SC_INST(db_u3_1), db_u3_2_splitter(1), SC_INST(db_u3_stream_split),
	      u3_2_u4_array(1), SC_INST(PE_array_u4), u4_2_u5_array(1), SC_INST(merge_u5), u5_2_u6(1), SC_INST(resize_u6),
	      u6_2_u7(1), SC_INST(last_fix_u8), SC_INST(ctrl_acf_splitter), SC_INST(ctrl_acf_splitter_2_pe),
	      wb_buf_2_bias(1), SC_INST(wb_bias), SC_INST(pool), pool_2_re(1), SC_INST(pool_re), pool_2_u7(1),
	      SC_INST(merge_output_u7), SC_INST(stitch_u9), u8_2_u9(16)

	{
		// resize_u0 ---------------------
		SC_MODULE_LINK(resize_u0);
		resize_u0.din(data_sink);
		resize_u0.dout(data_2_u1);

		// wb_u2 --------------------
		SC_MODULE_LINK(wb_resize);
		wb_resize.din(w_sink);
		wb_resize.dout(wb_re_2_u1);
		/*SC_MODULE_LINK(realign_u0);
		realign_u0.din(wb_re_2_u0);
		realign_u0.ctrl(ctrl_row_N);
		realign_u0.dout(wb_u0_2_u1);*/
		SC_MODULE_LINK(wb_package_splitter_u1);
		wb_package_splitter_u1.din(wb_re_2_u1);
		SC_MODULE_LINK(wb_ctrls_splitter);
		wb_ctrls_splitter.din(weight_ctrls_in);

		hwcore::hf::unroll<1 * T_pe_n, wb_package_splitter_u1_link>::link(*this);

		// db_u3_1 -----------------------
		SC_MODULE_LINK(db_u3_1);
		db_u3_1.din(data_2_u1);
		// db_u3_1.ctrls_in(data_ctrls_in);
		db_u3_1.ctrl_depth(ctrl_depth);
		db_u3_1.ctrl_replay(ctrl_replay);
		db_u3_1.ctrl_row_size_pkg(ctrl_row_size_pkg);
		db_u3_1.ctrl_stride(ctrl_stride);
		db_u3_1.ctrl_window_size(ctrl_window_size);
		db_u3_1.ctrl_image_size(ctrl_image_size);
		db_u3_1.ctrl_zeropad(ctrl_zeropad);
		db_u3_1.ctrl_db_output(ctrl_db_output);
		db_u3_1.ctrl_image_data(ctrl_image_data);
		db_u3_1.dout_raw(db_u3_2_pool);
		db_u3_1.dout(db_u3_2_splitter);
		SC_MODULE_LINK(db_u3_stream_split);
		db_u3_stream_split.din(db_u3_2_splitter);
		// pooling
		pooling_connect();
		// PE
		SC_MODULE_LINK(ctrl_acf_splitter);
		ctrl_acf_splitter.din(ctrl_acf);

		SC_MODULE_LINK(merge_u5);
		merge_u5.dout(u5_2_u6);
		SC_MODULE_LINK(resize_u6);
		resize_u6.din(u5_2_u6);
		resize_u6.dout(u6_2_u7);
		// output
		output_connect();

		// status reg

		// sc_status_end_connect(status, r3_package_handler_u1_s_state);
	}

  public:
	inline void trace(sc_trace_file * trace) {
		/*SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);
		//SC_TRACE_ADD(data_sink);
		//SC_TRACE_ADD(data_ctrls_in);
		//SC_TRACE_ADD(ctrl_channel);
		//SC_TRACE_ADD(ctrl_row_N);
		SC_TRACE_ADD_MODULE(data_2_u1);
		SC_TRACE_ADD_MODULE(package_handler_u1);
		SC_TRACE_ADD_MODULE(u1_2_u2);
		SC_TRACE_ADD_MODULE(u1_2_u3);
		SC_TRACE_ADD_MODULE(wb_u2);
		//SC_TRACE_ADD_MODULE(db_u3);
		SC_TRACE_ADD_MODULE(db_u3_2_splitter);
		for(int i=0;i<T_pe_n;i++)
		{
		    SC_TRACE_ADD_MODULE(u2_2_u4_array.get(i));
		    SC_TRACE_ADD_MODULE(u3_2_u4_array.get(i));
		    SC_TRACE_ADD_MODULE(PE_array_u4.get(i));
		    SC_TRACE_ADD_MODULE(u4_2_u5_array.get(i));
		}
		SC_TRACE_ADD_MODULE(merge_u5);
		SC_TRACE_ADD_MODULE(u5_2_u6);
		SC_TRACE_ADD_MODULE(resize_u6);

		//data_source
		//SC_TRACE_ADD(data_source);*/
	}
};

namespace hwcore {
namespace cnn {

template <int data_W = 16, int data_P = 2, int input_BW_N = 32, int output_BW_N = 32, int T_pe_n = 16,
          int T_pe_bw_n = 16, int T_wbuf_size = 1024, int T_data_buf_clb_size = 1024, int T_data_buf_clb_n = 3,
          int T_data_buf_shift_size = 1024, int T_data_out_n = 1, int T_pool_size_param = 1024,
          int T_PE_pipeline_II = 1, int T_pe_pre_fifo_deep = 1>
using top_cnn = ::_top_cnn<data_W, data_P, input_BW_N, output_BW_N, T_pe_n, T_pe_bw_n, T_wbuf_size, T_data_buf_clb_size,
                           T_data_buf_clb_n, T_data_buf_shift_size, T_data_out_n, T_pool_size_param, T_PE_pipeline_II,
                           T_pe_pre_fifo_deep>;

} // namespace cnn
} // namespace hwcore