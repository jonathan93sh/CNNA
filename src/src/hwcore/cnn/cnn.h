/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include "hwcore/cnn/data_buffer.h"
#include "hwcore/cnn/pe.h"
#include "hwcore/cnn/top_cnn.h"
#include "hwcore/cnn/weight_buffer.h"
#include "hwcore/hw/statusreg.h"
#include "hwcore/pipes/pipes.h"
#include <systemc.h>

#ifdef __RTL_SIMULATION__
#include "syn/systemc/cnn.h"
#endif

#ifndef P_data_P
#define P_data_P 2
#warning Using defualt parameter!
#endif
#ifndef P_data_W
#define P_data_W 16
#warning Using defualt parameter!
#endif
#ifndef P_input_width
#define P_input_width 128
#warning Using defualt parameter!
#endif
#ifndef P_output_width
#define P_output_width 128
#warning Using defualt parameter!
#endif

// calculatd parameter

#define P_input_BW_N (P_input_width / P_data_W)

#define P_output_BW_N (P_output_width / P_data_W)
// end

#ifndef P_pe_n
#define P_pe_n 8
#warning Using defualt parameter!
#endif
#ifndef P_pe_bw_n
#define P_pe_bw_n P_input_BW_N
#warning Using defualt parameter!
#endif
#ifndef P_wbuf_size
#define P_wbuf_size 3072
#warning Using defualt parameter!
#endif
#ifndef P_data_buf_clb_size
#define P_data_buf_clb_size 8192
#warning Using defualt parameter!
#endif
#ifndef P_data_buf_clb_n
#define P_data_buf_clb_n 3
#warning Using defualt parameter!
#endif
#ifndef P_data_buf_shift_size
#define P_data_buf_shift_size 384
#warning Using defualt parameter!
#endif
#ifndef P_data_out_n
#define P_data_out_n 1
#warning Using defualt parameter!
#endif
#ifndef P_pool_size
#define P_pool_size 1024
#warning Using defualt parameter!
#endif

#if P_pool_size < 512
#error bad pool size!!!
#endif

#ifndef P_PE_pipeline_II
#define P_PE_pipeline_II 1
#warning Using defualt parameter!
#endif
#ifndef P_pe_pre_fifo_deep
#define P_pe_pre_fifo_deep 1
#warning Using defualt parameter!
#endif
#ifndef P_X_fifo_deep
#define P_X_fifo_deep 1
#warning Using defualt parameter!
#endif
#ifndef P_W_fifo_deep
#define P_W_fifo_deep 1
#warning Using defualt parameter!
#endif
#ifndef P_Y_fifo_deep
#define P_Y_fifo_deep 1
#warning Using defualt parameter!
#endif
#ifndef P_BUF_fifo_deep
#define P_BUF_fifo_deep 1
#warning Using defualt parameter!
#endif
SC_MODULE(cnn) {
	// typedef

	typedef hwcore::cnn::top_cnn<P_data_W, P_data_P, P_input_BW_N, P_output_BW_N, P_pe_n, P_pe_bw_n, P_wbuf_size,
	                             P_data_buf_clb_size, P_data_buf_clb_n, P_data_buf_shift_size, P_data_out_n,
	                             P_pool_size, P_PE_pipeline_II, P_pe_pre_fifo_deep>
	    top_cnn_t;
	// interface
	SC_MODULE_CLK_RESET_SIGNAL;

	sc_fifo_in<hwcore::pipes::SC_DATA_T(P_input_width)> data_sink;
	sc_fifo_in<hwcore::pipes::SC_DATA_T(P_input_width)> data_buf_sink;
	sc_fifo_in<hwcore::pipes::SC_DATA_T(P_input_width)> w_sink;
	sc_fifo_in<hwcore::pipes::SC_DATA_T(64)> ctrl_sink;

	sc_fifo_out<hwcore::pipes::SC_DATA_T(P_output_width)> data_source;

#if __RTL_SIMULATION__
	sc_status_module_create_interface_only(reg1);
	ap_rtl::cnn rtl_wrapper_cnn;
	SC_FIFO_IN_TRANS<P_input_width> data_sink_trans;
	SC_FIFO_IN_TRANS<P_input_width> data_buf_sink_trans;
	SC_FIFO_IN_TRANS<P_input_width> w_sink_trans;
	SC_FIFO_IN_TRANS<64> ctrl_sink_trans;

	SC_FIFO_OUT_TRANS<P_output_width> data_source_trans;

	sc_signal<sc_logic> reset_s;

	sc_signal<sc_lv<32> > status_add_s;

	sc_signal<sc_lv<32> > status_val_s;

	void signal_connection() {

		sc_dt::sc_logic reset_tmp = (sc_dt::sc_logic)reset.read();
		reset_s.write(reset_tmp);

		status_add_s.write(status_add.read());
		status_val.write(status_val_s.read().to_int());
	}

	SC_CTOR(cnn)
	    : rtl_wrapper_cnn("rtl_wrapper_cnn"), data_sink_trans("data_sink_trans"),
	      data_buf_sink_trans("data_buf_sink_trans"), data_source_trans("data_source_trans"),
	      w_sink_trans("w_sink_trans"), ctrl_sink_trans("ctrl_sink_trans") {
		// SC_MODULE_LINK(rtl_wrapper_cnn);
		SC_FIFO_IN_TRANS_CONNECT(rtl_wrapper_cnn, data_sink_trans, data_sink);
		SC_FIFO_IN_TRANS_CONNECT(rtl_wrapper_cnn, data_buf_sink_trans, data_buf_sink);
		SC_FIFO_IN_TRANS_CONNECT(rtl_wrapper_cnn, w_sink_trans, w_sink);
		SC_FIFO_IN_TRANS_CONNECT(rtl_wrapper_cnn, ctrl_sink_trans, ctrl_sink);

		SC_FIFO_OUT_TRANS_CONNECT(rtl_wrapper_cnn, data_source_trans, data_source);

		rtl_wrapper_cnn.clk(clk);
		rtl_wrapper_cnn.reset(reset_s);

		rtl_wrapper_cnn.status_add(status_add_s);
		rtl_wrapper_cnn.status_val(status_val_s);

		SC_METHOD(signal_connection);

		sensitive << status_add << status_val_s << reset;
	}

#else

	sc_status_module_create(reg1);
	sc_status_reg_create(r0_dma_ingress);
	sc_status_reg_create(r1_dma_egress);
	sc_status_reg_create(r2_data_W);
	sc_status_reg_create(r3_data_P);
	sc_status_reg_create(r4_input_BW_N);
	sc_status_reg_create(r5_output_BW_N);
	sc_status_reg_create(r6_pe_n);
	sc_status_reg_create(r7_pe_bw_n);
	sc_status_reg_create(r8_wbuf_size);
	sc_status_reg_create(r9_data_buf_clb_size);
	sc_status_reg_create(r10_data_buf_clb_n);
	sc_status_reg_create(r11_data_buf_shift_size);
	sc_status_reg_create(r12_data_out_n);

	sc_status_end_create(regend);

	void status_reg_param_link() {
		r2_data_W_status.write(P_data_W);
		r3_data_P_status.write(P_data_P);
		r4_input_BW_N_status.write(P_input_BW_N);
		r5_output_BW_N_status.write(P_pool_size);
		r6_pe_n_status.write(P_pe_n);
		r7_pe_bw_n_status.write(P_pe_bw_n);
		r8_wbuf_size_status.write(P_wbuf_size);
		r9_data_buf_clb_size_status.write(P_data_buf_clb_size);
		r10_data_buf_clb_n_status.write(P_data_buf_clb_n);
		r11_data_buf_shift_size_status.write(P_data_buf_shift_size);
		r12_data_out_n_status.write(P_data_out_n);
	}

	sc_fifo<hwcore::pipes::SC_DATA_T(P_input_width)> data_sink_forward;
	sc_fifo<hwcore::pipes::SC_DATA_T(P_input_width)> data_buf_sink_forward;
	sc_fifo<hwcore::pipes::SC_DATA_T(P_input_width)> w_sink_forward;
	sc_fifo<hwcore::pipes::SC_DATA_T(P_output_width)> data_source_forward;

	sc_fifo<sc_uint<31> > weight_ctrls_fifo;

	sc_fifo<sc_uint<32> > ctrl_image_size_fifo;
	sc_fifo<sc_uint<16> > ctrl_row_size_pkg_fifo;
	sc_fifo<sc_uint<16> > ctrl_window_size_fifo;
	sc_fifo<sc_uint<16> > ctrl_depth_fifo;
	sc_fifo<sc_uint<16> > ctrl_stride_fifo;
	sc_fifo<sc_uint<16> > ctrl_replay_fifo;
	sc_fifo<sc_uint<16> > ctrl_zeropad_fifo;

	sc_fifo<sc_uint<1> > ctrl_output_channel_fifo;
	sc_fifo<sc_uint<16> > ctrl_stitch_depth_fifo;
	sc_fifo<sc_uint<16> > ctrl_stitch_buf_depth_fifo;

	sc_fifo<sc_uint<1> > ctrl_db_output_fifo;
	sc_fifo<sc_uint<1> > ctrl_image_data_fifo;
	sc_fifo<sc_uint<16> > ctrl_pool_depth_fifo;
	sc_fifo<sc_uint<16> > ctrl_pool_type_fifo;
	sc_fifo<sc_uint<16> > ctrl_pool_N_fifo;
	sc_fifo<sc_uint<16> > ctrl_pool_size_fifo;

	sc_fifo<sc_uint<16> > ctrl_row_N_fifo;

	sc_fifo<sc_uint<16> > ctrl_acf_fifo;

	// modules

	hwcore::cnn::top_cnn<P_data_W, P_data_P, P_input_BW_N, P_output_BW_N, P_pe_n, P_pe_bw_n, P_wbuf_size,
	                     P_data_buf_clb_size, P_data_buf_clb_n, P_data_buf_shift_size, P_data_out_n>
	    top_cnn;

	sc_status_reg_create_dummy(top_cnn_reg);

	SC_CTOR(cnn)
	    : data_sink_forward(P_X_fifo_deep), data_buf_sink_forward(P_BUF_fifo_deep), w_sink_forward(P_W_fifo_deep),
	      data_source_forward(P_Y_fifo_deep), weight_ctrls_fifo(16), ctrl_row_size_pkg_fifo(16),
	      ctrl_window_size_fifo(16), ctrl_depth_fifo(16), ctrl_stride_fifo(16), ctrl_replay_fifo(16),
	      ctrl_row_N_fifo(16), ctrl_acf_fifo(16), ctrl_zeropad_fifo(16), SC_INST(top_cnn), SC_INST(reg1),
	      SC_INST(regend), SC_INST(r0_dma_ingress), SC_INST(r1_dma_egress), SC_INST(r2_data_W), SC_INST(r3_data_P),
	      SC_INST(r4_input_BW_N), SC_INST(r5_output_BW_N), SC_INST(r6_pe_n), SC_INST(r7_pe_bw_n), SC_INST(r8_wbuf_size),
	      SC_INST(r9_data_buf_clb_size), SC_INST(r10_data_buf_clb_n), SC_INST(r11_data_buf_shift_size),
	      SC_INST(r12_data_out_n), ctrl_output_channel_fifo(16), ctrl_db_output_fifo(16), ctrl_pool_depth_fifo(16),
	      ctrl_pool_type_fifo(16), ctrl_pool_N_fifo(16), ctrl_pool_size_fifo(16), ctrl_stitch_depth_fifo(16),
	      ctrl_stitch_buf_depth_fifo(1), ctrl_image_data_fifo(16)

	{
		top_cnn.clk(clk);
		top_cnn.reset(reset);

		/*SC_METHOD(reset_logic);
		sensitive << reset << iclear;

		SC_CTHREAD(clear_reg, clk.pos());*/

		top_cnn.data_sink(data_sink_forward);
		top_cnn.data_buf_sink(data_buf_sink_forward);
		top_cnn.w_sink(w_sink_forward);

		top_cnn.data_source(data_source_forward);
		top_cnn.weight_ctrls_in(weight_ctrls_fifo);

		// top_cnn.data_ctrls_in(data_ctrls_fifo);
		top_cnn.ctrl_row_N(ctrl_row_N_fifo);

		top_cnn.ctrl_row_size_pkg(ctrl_row_size_pkg_fifo);
		top_cnn.ctrl_window_size(ctrl_window_size_fifo);
		top_cnn.ctrl_depth(ctrl_depth_fifo);
		top_cnn.ctrl_stride(ctrl_stride_fifo);
		top_cnn.ctrl_replay(ctrl_replay_fifo);
		top_cnn.ctrl_image_size(ctrl_image_size_fifo);
		top_cnn.ctrl_acf(ctrl_acf_fifo);
		top_cnn.ctrl_zeropad(ctrl_zeropad_fifo);

		top_cnn.ctrl_output_channel(ctrl_output_channel_fifo);
		top_cnn.ctrl_stitch_depth(ctrl_stitch_depth_fifo);
		top_cnn.ctrl_stitch_buf_depth(ctrl_stitch_buf_depth_fifo);

		top_cnn.ctrl_db_output(ctrl_db_output_fifo);
		top_cnn.ctrl_image_data(ctrl_image_data_fifo);
		top_cnn.ctrl_pool_depth(ctrl_pool_depth_fifo);
		top_cnn.ctrl_pool_type(ctrl_pool_type_fifo);
		top_cnn.ctrl_pool_N(ctrl_pool_N_fifo);
		top_cnn.ctrl_pool_size(ctrl_pool_size_fifo);

		// status reg
		sc_status_module_connect(reg1);
		sc_status_reg_connect(r0_dma_ingress, reg1);
		sc_status_reg_connect(r1_dma_egress, r0_dma_ingress);
		sc_status_reg_connect(r2_data_W, r1_dma_egress);
		sc_status_reg_connect(r3_data_P, r2_data_W);
		sc_status_reg_connect(r4_input_BW_N, r3_data_P);
		sc_status_reg_connect(r5_output_BW_N, r4_input_BW_N);
		sc_status_reg_connect(r6_pe_n, r5_output_BW_N);
		sc_status_reg_connect(r7_pe_bw_n, r6_pe_n);
		sc_status_reg_connect(r8_wbuf_size, r7_pe_bw_n);
		sc_status_reg_connect(r9_data_buf_clb_size, r8_wbuf_size);
		sc_status_reg_connect(r10_data_buf_clb_n, r9_data_buf_clb_size);
		sc_status_reg_connect(r11_data_buf_shift_size, r10_data_buf_clb_n);
		sc_status_reg_connect(r12_data_out_n, r11_data_buf_shift_size);
		sc_status_end_connect(regend, r12_data_out_n);

		SC_CTHREAD(thread_cnn_stream_source, clk.pos());
		reset_signal_is(reset, true);
		SC_CTHREAD(thread_cnn_stream_sink, clk.pos());
		reset_signal_is(reset, true);
		SC_CTHREAD(thread_cnn_stream_buf_sink, clk.pos());
		reset_signal_is(reset, true);
		SC_CTHREAD(thread_cnn_stream_w_sink, clk.pos());
		reset_signal_is(reset, true);
		SC_CTHREAD(thread_cnn_ctrl, clk.pos());
		reset_signal_is(reset, true);
	}

	void thread_cnn_stream_source() {
		SC_STREAM_INTERFACE_CREATE_SOURCE(data_source, "-bus_bundle M_AXIS_Y")
		int count = 0;
		while (true) {
			hls_pipeline(1);
			hwcore::pipes::SC_DATA_T(P_output_width) tmp_out = data_source_forward.read();
			data_source.write(tmp_out);
			count++;
			r0_dma_ingress_status.write(count);
		}
	}

	void thread_cnn_stream_sink() {
		SC_STREAM_INTERFACE_CREATE_SINK(data_sink, "-bus_bundle S_AXIS_X")
		int count = 0;
		while (true) {
			hls_pipeline(1);
			hwcore::pipes::SC_DATA_T(P_input_width) tmp_in = data_sink.read();
			data_sink_forward.write(tmp_in);
			count++;
			r1_dma_egress_status.write(count);
		}
	}

	void thread_cnn_stream_buf_sink() {
		SC_STREAM_INTERFACE_CREATE_SINK(data_buf_sink, "-bus_bundle S_AXIS_BUF")
		while (true) {
			hls_pipeline(1);
			hwcore::pipes::SC_DATA_T(P_input_width) tmp_in = data_buf_sink.read();
			data_buf_sink_forward.write(tmp_in);
		}
	}

	void thread_cnn_stream_w_sink() {
		SC_STREAM_INTERFACE_CREATE_SINK(w_sink, "-bus_bundle S_AXIS_W")
		while (true) {
			hls_pipeline(1);
			hwcore::pipes::SC_DATA_T(P_input_width) tmp_in = w_sink.read();
			w_sink_forward.write(tmp_in);
		}
	}

	void thread_cnn_ctrl() {
		SC_STREAM_INTERFACE_CREATE_SINK(ctrl_sink, "-bus_bundle S_AXIS_CTRL")
		hwcore::pipes::SC_DATA_T(64) tmp_in;
		status_reg_param_link();
		while (true) {
			do {
				hls_pipeline(1);
				tmp_in = ctrl_sink.read();
				sc_uint<64> raw = tmp_in.data;

				sc_uint<56> value = raw(56 - 1, 0);

				sc_uint<8> address;
				if (tmp_in.tkeep == 0) {
					address = -1;
				} else {
					address = raw(64 - 1, 56);
				}

#define add_new_reg_interface(name_, nr_)                                                                              \
	case nr_:                                                                                                          \
		name_##_fifo.write(value);                                                                                     \
		break;

				switch (address) {
					add_new_reg_interface(weight_ctrls, 0);

					add_new_reg_interface(ctrl_row_N, 1);
					add_new_reg_interface(ctrl_row_size_pkg, 2);
					add_new_reg_interface(ctrl_window_size, 3);
					add_new_reg_interface(ctrl_depth, 4);
					add_new_reg_interface(ctrl_stride, 5);
					add_new_reg_interface(ctrl_replay, 6);
					add_new_reg_interface(ctrl_image_size, 7);
					add_new_reg_interface(ctrl_acf, 8);
					add_new_reg_interface(ctrl_zeropad, 9);

					add_new_reg_interface(ctrl_output_channel, 10);
					add_new_reg_interface(ctrl_stitch_depth, 11);
					add_new_reg_interface(ctrl_stitch_buf_depth, 12);

					add_new_reg_interface(ctrl_db_output, 13);
					add_new_reg_interface(ctrl_image_data, 14);
					add_new_reg_interface(ctrl_pool_depth, 15);
					add_new_reg_interface(ctrl_pool_type, 16);
					add_new_reg_interface(ctrl_pool_N, 17);
					add_new_reg_interface(ctrl_pool_size, 18);
				default:
					break;
				};
			} while (tmp_in.tlast == 0);
		}
	}

#endif
};
