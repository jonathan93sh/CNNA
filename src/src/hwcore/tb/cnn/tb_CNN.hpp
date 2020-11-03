/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include <systemc.h>
//#if __RTL_SIMULATION__
//#include "cnn_rtl_wrapper.h"
//#else
//#include "hwcore/cnn/cnn.h"
//#endif

#include "hwcore/cnn/cnn.h"
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/pipes.h"

#if __RTL_SIMULATION__

//#include "DMA_performance_tester_rtl_wrapper.h"

//#else
//#include "DMA_generic_performance_tester.hpp"
#endif

SC_MODULE(mon_CNN) {
	sc_in<bool> clk;
	sc_out<bool> reset;

	sc_fifo_in<hwcore::pipes::sc_data_stream_t<OUTPUT_WIDTH> > data_in;

	SC_CTOR_DEFAULT(mon_CNN) {
		SC_CTHREAD(mon_thread, clk.pos());
		// sensitive << clk;
	}

	void mon_thread() {
		reset.write(true);
		wait();
		wait();
		wait();
		wait();
		wait();
		wait();
		wait();
		reset.write(false);
		for (int i = 0; i < 20; i++)
			wait();

		int counter = 1;
		int last_count = 1;

		sc_fixed<DATA_W, DATA_P> value = -1.0;
		sc_fixed<DATA_W, DATA_P> value_inc = 0.123;

		sc_fixed<DATA_W, DATA_P> Win[16 * 16];
		sc_fixed<DATA_W, DATA_P> Xin[16 * 16];
		for (int wIdx = 0; wIdx < 16 * 16; wIdx++) {
			Win[wIdx] = value;
			value += value_inc;
			if (value > 1.0) {
				value = -1.0;
			}
		}

		for (int xIdx = 0; xIdx < 16 * 16; xIdx++) {
			Xin[xIdx] = value;
			value += value_inc;
			if (value > 1.0) {
				value = -1.0;
			}
		}

		sc_fixed<DATA_W, DATA_P> Y_golden[16 * 16];

		for (int a = 0; a < 16; a++) {
			for (int b = 0; b < 16; b++) {
				sc_fixed<DATA_W, DATA_P> tmp = 0;
				for (int wi = 0; wi < 16; wi++) {
					tmp += Win[wi + (b * 16)] * Xin[(a * 16) + wi];
				}
				Y_golden[(a * 16) + b] = tmp;
			}
		}

		sc_fixed<DATA_W, DATA_P> Y[16 * 16];
		hwcore::pipes::sc_data_stream_t<OUTPUT_WIDTH> tmp;
		for (int a = 0; a < 16; a++) {
			for (int b = 0; b < 16 / OUTPUT_BW_N; b++) {
				tmp = data_in.read();
				sc_fixed<DATA_W, DATA_P> data_in[OUTPUT_BW_N];

				tmp.getDataFixed<DATA_W, DATA_P, OUTPUT_BW_N>(data_in);

				for (int i = 0; i < OUTPUT_BW_N; i++) {
					Y[(a * 16) + (b * OUTPUT_BW_N) + i] = data_in[i];
					HLS_DEBUG(1, 1, 0, "got knew value: ")
					std::cout << "    |--> " << data_in[i].to_float() << " index nr: " << counter << " tlast? "
					          << tmp.tlast.to_int() << std::endl
					          << std::flush;
					counter++;
				}
			}
		}

		bool ok = true;
		if (tmp.tlast.to_int() != 1) {
			ok = false;
			std::cout << "error - missing tlast!!!" << std::endl << std::flush;
		}

		for (int i = 0; i < 16 * 16; i++) {
			std::cout << "[ " << i << " ] Y = " << Y[i].to_float() << std::endl
			          << std::flush; // " == Y_golden = " << Y_golden[i].to_float() << std::endl << std::flush;
			                         /* if(Y[i]!=Y_golden[i])
			                         {
			                             std::cout << "error not equal!!!" << std::endl << std::flush;
			                             ok = false;
			                         }*/
		}
		HLS_DEBUG(1, 1, 0, "Simulation done");
		if (!ok) {
			HLS_DEBUG(1, 1, 0, "Simulation done - with errors!!!");
		}
		sc_stop();
	}
};

SC_MODULE(wave_CNN) {
	SC_MODULE_CLK_RESET_SIGNAL;
	sc_fifo_out<hwcore::pipes::sc_data_stream_t<INPUT_WIDTH> > data_out;
	sc_out<sc_uint<16 + 1> > weight_ctrl; //, data_ctrl;
	sc_out<sc_uint<16 + 1> > weight_ctrl_replay;

	sc_out<sc_uint<16 + 1> > ctrl_row_size_pkg;
	sc_out<sc_uint<16 + 1> > ctrl_window_size;
	sc_out<sc_uint<16 + 1> > ctrl_depth;
	sc_out<sc_uint<16 + 1> > ctrl_stride;
	sc_out<sc_uint<16 + 1> > ctrl_replay;

	sc_out<sc_uint<1 + 1> > ctrl_channel;
	sc_out<sc_uint<16 + 1> > ctrl_row_N;
	sc_in<sc_uint<1> > ready;

	template <class interface, typename T> void do_cmd(interface & itf, T value) {
		while (ready.read() == 0) {
			wait();
		}
		itf.write((value << 1) | 0b01);
		while (ready.read() == 1) {
			wait();
		}
		while (ready.read() == 0) {
			wait();
		}
		itf.write(0);
		wait();
	}

	SC_CTOR_DEFAULT(wave_CNN) {
		SC_CTHREAD(wave_thread, clk.pos());
		SC_CTHREAD(sending_ctrls, clk.pos());
	}
	void sending_ctrls() {

		wait();
		while (reset.read()) {
			wait();
		}
		for (int i = 0; i < 20; i++)
			wait();
		ctrl_channel.write(0);
		ctrl_row_N.write(0);
		weight_ctrl.write(0);
		// data_ctrl.write(0);
		do_cmd(ctrl_channel, 0);
		do_cmd(ctrl_row_N, 16 / INPUT_BW_N);
		do_cmd(weight_ctrl, hwcore::pipes::sc_stream_buffer<>::ctrls::newset);
		do_cmd(ctrl_depth, 1);
		do_cmd(ctrl_replay, 1);
		do_cmd(ctrl_stride, 0);
		do_cmd(ctrl_row_size_pkg, 1024);
		do_cmd(ctrl_window_size, 1);
		for (int a = 0; a < 16; a++) {
			do_cmd(ctrl_channel, 1);
			do_cmd(weight_ctrl, hwcore::pipes::sc_stream_buffer<>::ctrls::reapeat);
			// do_cmd(data_ctrl,hwcore::pipes::sc_stream_buffer<>::ctrls::newset);
		}
		while (true) {
			wait();
		}
	}

	void wave_thread() {
		// sending dummy weights.
		wait();
		while (reset.read()) {
			wait();
		}
		for (int i = 0; i < 15; i++)
			wait();

		sc_fixed<DATA_W, DATA_P> value = -1.0;
		sc_fixed<DATA_W, DATA_P> value_inc = 0.123;

		HLS_DEBUG(1, 1, 0, "sending data -- weights!----------------------");
		sc_fixed<DATA_W, DATA_P> Win[16 * 16];
		sc_fixed<DATA_W, DATA_P> Xin[16 * 16];
		for (int wIdx = 0; wIdx < 16 * 16; wIdx++) {
			Win[wIdx] = value;
			value += value_inc;
			if (value > 1.0) {
				value = -1.0;
			}
		}

		for (int xIdx = 0; xIdx < 16 * 16; xIdx++) {
			Xin[xIdx] = value;
			value += value_inc;
			if (value > 1.0) {
				value = -1.0;
			}
		}

		for (int a = 0; a < (16 * 16) / INPUT_BW_N; a++) {
			hwcore::pipes::sc_data_stream_t<INPUT_WIDTH> tmp;
			tmp.setDataFixed<DATA_W, DATA_P, INPUT_BW_N>(&Win[a * INPUT_BW_N]);
			tmp.setKeep();
			if (a == ((16 * 16) / INPUT_BW_N) - 1) {
				tmp.tlast = 1;
				HLS_DEBUG(1, 1, 0, "sending data -- TLAST!----------------------");
			} else {
				tmp.tlast = 0;
			}
			HLS_DEBUG(1, 1, 5, "sending data -- %s", tmp.data.to_string().c_str());
			data_out.write(tmp);
		}

		// sending input data
		HLS_DEBUG(1, 1, 0, "sending data -- Input!----------------------");

		for (int a = 0; a < 16; a++) {

			for (int i = 0; i < 16 / INPUT_BW_N; i++) {
				hwcore::pipes::sc_data_stream_t<INPUT_WIDTH> tmp;
				tmp.setDataFixed<DATA_W, DATA_P, INPUT_BW_N>(&Xin[(i * INPUT_BW_N) + (a * 16)]);
				tmp.setKeep();
				if (a == (16) - 1 && i == (16 / INPUT_BW_N) - 1) {
					tmp.tlast = 1;
					HLS_DEBUG(1, 1, 0, "sending Input data -- TLAST!----------------------");
				} else {
					tmp.tlast = 0;
				}
				HLS_DEBUG(1, 1, 5, "sending Input data -- %s", tmp.data.to_string().c_str());
				data_out.write(tmp);
			}
		}
		/*HLS_DEBUG(1,1,0,"sending data -- Firing!----------------------");
		data_ctrl.write(hwcore::pipes::sc_stream_buffer<>::ctrls::reapeat);*/

		while (true) {
			wait();
		}
	}
};

SC_MODULE(tb_CNN) {
#if __RTL_SIMULATION__
	// DMA_performance_tester_rtl_wrapper u1;
#else
	// DMA_performance_tester u1;
#endif

	sc_clock clk;
	sc_signal<bool> reset;

	wave_CNN wave;

	sc_fifo<hwcore::pipes::sc_data_stream_t<INPUT_WIDTH> > wave_2_u1;
	sc_signal<sc_uint<31 + 1> > weight_ctrl; //, data_ctrl;
	sc_signal<sc_uint<16 + 1> > ctrl_row_size_pkg;
	sc_signal<sc_uint<16 + 1> > ctrl_window_size;
	sc_signal<sc_uint<16 + 1> > ctrl_depth;
	sc_signal<sc_uint<16 + 1> > ctrl_stride;
	sc_signal<sc_uint<16 + 1> > ctrl_replay;
	sc_signal<sc_uint<1 + 1> > ctrl_channel;
	sc_signal<sc_uint<16 + 1> > ctrl_row_N;
	sc_signal<sc_uint<1> > ready;
	// sc_fifo<hwcore::pipes::sc_data_stream_t<16> > wave_2_u1;
	::cnn cnn_u1;
	// hwcore::cnn::top_cnn<16,8,1,1,16,16> cnn_u1;

	sc_fifo<hwcore::pipes::sc_data_stream_t<OUTPUT_WIDTH> > u1_2_mon;

	mon_CNN mon;

	sc_trace_file *tracePtr;

	SC_CTOR_DEFAULT(tb_CNN) : SC_INST(wave), SC_INST(cnn_u1), SC_INST(mon), clk("clk", sc_time(10, SC_NS)) {

		SC_MODULE_LINK(wave);
		SC_MODULE_LINK(mon);
		SC_MODULE_LINK(cnn_u1);

		wave.ctrl_row_size_pkg(ctrl_row_size_pkg);
		wave.ctrl_window_size(ctrl_window_size);
		wave.ctrl_depth(ctrl_depth);
		wave.ctrl_stride(ctrl_stride);
		wave.ctrl_replay(ctrl_replay);

		wave.ready(ready);
		wave.data_out(wave_2_u1);
		// wave.data_ctrl(data_ctrl);
		wave.weight_ctrl(weight_ctrl);
		wave.ctrl_row_N(ctrl_row_N);
		wave.ctrl_channel(ctrl_channel);

		cnn_u1.ready(ready);

		cnn_u1.ctrl_row_size_pkg(ctrl_row_size_pkg);
		cnn_u1.ctrl_window_size(ctrl_window_size);
		cnn_u1.ctrl_depth(ctrl_depth);
		cnn_u1.ctrl_stride(ctrl_stride);
		cnn_u1.ctrl_replay(ctrl_replay);

		cnn_u1.ctrl_row_N(ctrl_row_N);
		cnn_u1.weight_ctrls(weight_ctrl);
		// cnn_u1.data_ctrls(data_ctrl);
		cnn_u1.ctrl_channel(ctrl_channel);

		cnn_u1.data_sink(wave_2_u1);
		cnn_u1.data_source(u1_2_mon);
		mon.data_in(u1_2_mon);

		tracePtr = sc_create_vcd_trace_file("tb_CNN");
		trace(tracePtr);
	}

	inline void trace(sc_trace_file * trace) {
		SC_TRACE_ADD(clk);
		SC_TRACE_ADD(reset);

		SC_TRACE_ADD_MODULE(wave_2_u1);
		SC_TRACE_ADD_MODULE(data_ctrl);
		SC_TRACE_ADD_MODULE(weight_ctrl);
		SC_TRACE_ADD_MODULE(ctrl_row_N);
		SC_TRACE_ADD_MODULE(ctrl_channel);
		SC_TRACE_ADD_MODULE(cnn_u1);
		SC_TRACE_ADD_MODULE(u1_2_mon);
	}

	virtual ~tb_CNN() { sc_close_vcd_trace_file(tracePtr); }
};

/*{
    #define SC_FIFO_IN_TRANSACTOR_ADD_SIGNALS(portName,width,if_type)\
    sc_signal<if_type > dma_sink_dout;\
    sc_signal< sc_logic > portName##_read;\
    sc_signal< sc_logic > portName##_empty_n;\
    sc_signal< sc_lv<width> > portName##_0_dout\
    sc_signal< sc_logic > portName##_0_read;\
    sc_signal< sc_lv<1> > portName##_1_dout;\
    sc_signal< sc_logic > portName##_1_read;\
    sc_signal< sc_lv<width/8> > portName##_2_dout;

    #define SC_FIFO_IN_TRANSACTOR_ADD(inst,portName,id)\
    inst.portName##_##id##_empty_n(portName##_empty_n);\
    inst.portName##_##id##_read(portName##_read);\
    inst.portName##_##id##_dout(portName##_dout_0);

    #define SC_FIFO_IN_TRANSACTOR_CREATE(inst,portName, width, if_type, fifo) \
    SC_FIFO_in_transactor<0, if_type >* portName##_inFifo_tr =  new SC_FIFO_in_transactor<0, if_type
>(#portName"_inFifo_tr", AESL_ResetType::active_high_sync);\
    portName##_inFifo_tr->rst(reset);\
    portName##_inFifo_tr->FifoIn(fifo);\
    portName##_inFifo_tr->clock(clk);\
    portName##_inFifo_tr->if_empty_n(portName##_empty_n);\
    portName##_inFifo_tr->if_read(portName##_read);\
    portName##_inFifo_tr->if_dout(portName##_dout);\
    SC_FIFO_IN_TRANSACTOR_ADD(cnn_u1,data_sink,0);\
    SC_FIFO_IN_TRANSACTOR_ADD(cnn_u1,data_sink,1);\
    SC_FIFO_IN_TRANSACTOR_ADD(cnn_u1,data_sink,2);\
    portName##_dout_0.write((sc_lv<width>)(portName##_dout.read().data));\
    portName##_dout_1.write((sc_lv<1>)(portName##_dout.read().tlast));\
    portName##_dout_2.write((sc_lv<width/8>)(portName##_dout.read().tkeep));

}*/