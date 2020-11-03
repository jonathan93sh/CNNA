#ifdef HW_COSIM
//#define __GMP_WITHIN_CONFIGURE
#endif
#define DEBUG_SYSTEMC
#define SC_INCLUDE_FX
#include <systemc.h>

//---include
#pragma once
#define SC_INCLUDE_FX
#include <systemc.h>
#if __RTL_SIMULATION__
//#include "cnn_rtl_wrapper.h"
#else
//#include "hwcore/cnn/cnn.h"
#endif
#include "hwcore/cnn/cnn.h"
#include "hwcore/pipes/pipes.h"
#include "hwcore/hf/helperlib.h"

#if __RTL_SIMULATION__

//#include "DMA_performance_tester_rtl_wrapper.h"

//#else
//#include "DMA_generic_performance_tester.hpp"
#endif


SC_MODULE(mon_CNN)
{
	sc_in<bool> clk;
	sc_out<bool> reset;

	sc_fifo_in<hwcore::pipes::sc_data_stream_t<OUTPUT_WIDTH> > data_in;

	SC_CTOR_DEFAULT(mon_CNN)
	{
		SC_THREAD(mon_thread);
		sensitive << clk;
	}

	void mon_thread()
	{
		reset.write(true);
		wait();
		reset.write(false);
		for(int i=0;i<10;i++)
			wait();

		int counter = 1;
		while(true)
		{
			hwcore::pipes::sc_data_stream_t<OUTPUT_WIDTH> tmp = data_in.read();

			sc_fixed<DATA_W,DATA_P> data_in[OUTPUT_BW_N];

			tmp.getDataFixed<DATA_W,DATA_P,OUTPUT_BW_N>(data_in);
			for(int i = 0; i < OUTPUT_BW_N; i++)
			{
				HLS_DEBUG(1,1,0,"got knew value: ")
				std::cout << "    |--> " << data_in[i].to_float() << " index nr: " << counter << " tlast? " << tmp.tlast.to_int() << std::endl << std::flush;
				counter++;
			}

			if(tmp.tlast.to_int() == 1)
			{
				sc_stop();
			}


		}
	}
};

SC_MODULE(wave_CNN)
{
	SC_MODULE_CLK_RESET_SIGNAL;
	sc_fifo_out<hwcore::pipes::sc_data_stream_t<INPUT_WIDTH> > data_out;
	sc_out<sc_uint<1+1> > weight_ctrl, data_ctrl, ctrl_channel;
	sc_out<sc_uint<16+1> > ctrl_row_N;
	sc_in<sc_uint<1> > ready;

	template<class interface, typename T>
	void do_cmd(interface & itf,T value)
	{
		while(ready.read() == 0){wait();}
		itf.write((value<<1)|0b01);
		wait();
		while(ready.read() == 0){wait();}
		itf.write(0);
	}

	SC_CTOR_DEFAULT(wave_CNN)
	{
		SC_CTHREAD(wave_thread,clk.pos());
	}

	void wave_thread()
	{
		// sending dummy weights.
		ctrl_channel.write(0);
		ctrl_row_N.write(0);
		weight_ctrl.write(0);
		data_ctrl.write(0);
		wait();
		wait();
		do_cmd(ctrl_channel,0);
		do_cmd(ctrl_row_N,DATA_W/INPUT_BW_N);
		do_cmd(weight_ctrl,hwcore::pipes::sc_stream_buffer<>::ctrls::newset);

		sc_fixed<DATA_W,DATA_P> value = -1.0;
		sc_fixed<DATA_W,DATA_P> value_inc = 0.0123;

		HLS_DEBUG(1,1,0,"sending data -- weights!----------------------");
		sc_fixed<DATA_W,DATA_P> Win[16*16];
		sc_fixed<DATA_W,DATA_P> Xin[16*16];
		for(int wIdx=0;wIdx<16*16;wIdx++)
		{
			Win[wIdx] = value;
			value += value_inc;
		}

		for(int xIdx=0;xIdx<16*16;xIdx++)
		{
			Xin[xIdx] = value;
			value -= value_inc;
		}


		for(int a=0;a<(16*16)/INPUT_BW_N;a++)
		{
			hwcore::pipes::sc_data_stream_t<INPUT_WIDTH> tmp;
			tmp.setDataFixed<DATA_W,DATA_P,INPUT_BW_N>(&Win[a*INPUT_BW_N]);
			tmp.setKeep();
			if(a==((16*16)/INPUT_BW_N)-1)
			{
				tmp.tlast = 1;
				HLS_DEBUG(1,1,0,"sending data -- TLAST!----------------------");
			}
			else
			{
				tmp.tlast = 0;
			}
			HLS_DEBUG(1,1,5,"sending data -- %s", tmp.data.to_string().c_str());
			data_out.write(tmp);
		}

		// sending input data
		HLS_DEBUG(1,1,0,"sending data -- Input!----------------------");

		for(int a=0;a<16;a++)
		{

			do_cmd(ctrl_channel,1);
			do_cmd(weight_ctrl,hwcore::pipes::sc_stream_buffer<>::ctrls::reapeat);
			do_cmd(data_ctrl,hwcore::pipes::sc_stream_buffer<>::ctrls::newset);

			for(int i=0;i<16/INPUT_BW_N;i++)
			{
				hwcore::pipes::sc_data_stream_t<INPUT_WIDTH> tmp;
				tmp.setDataFixed<DATA_W,DATA_P,INPUT_BW_N>(&Xin[i*INPUT_BW_N]);
				tmp.setKeep();
				if(a==(16/INPUT_BW_N)-1)
				{
					tmp.tlast = 1;
					HLS_DEBUG(1,1,0,"sending Input data -- TLAST!----------------------");
				}
				else
				{
					tmp.tlast = 0;
				}
				HLS_DEBUG(1,1,5,"sending Input data -- %s", tmp.data.to_string().c_str());
				data_out.write(tmp);

			}
		}
		/*HLS_DEBUG(1,1,0,"sending data -- Firing!----------------------");
		data_ctrl.write(hwcore::pipes::sc_stream_buffer<>::ctrls::reapeat);*/

		while (true)
		{
			wait();
		}


	}
};

SC_MODULE(tb_CNN)
{
#if __RTL_SIMULATION__
	//DMA_performance_tester_rtl_wrapper u1;
#else
	//DMA_performance_tester u1;
#endif

	sc_clock clk;
	sc_signal<bool> reset;

	wave_CNN wave;

	sc_fifo<hwcore::pipes::sc_data_stream_t<INPUT_WIDTH> > wave_2_u1;
	sc_signal<sc_uint<1+1> > weight_ctrl, data_ctrl, ctrl_channel;
	sc_signal<sc_uint<16+1> > ctrl_row_N;
	sc_signal<sc_uint<1> > ready;
	//sc_fifo<hwcore::pipes::sc_data_stream_t<16> > wave_2_u1;
	cnn cnn_u1;
	//hwcore::cnn::top_cnn<16,8,1,1,16,16> cnn_u1;

	sc_fifo<hwcore::pipes::sc_data_stream_t<OUTPUT_WIDTH> > u1_2_mon;


	mon_CNN mon;

	sc_trace_file * tracePtr;

	SC_CTOR_DEFAULT(tb_CNN)
		:SC_INST(wave),SC_INST(cnn_u1),SC_INST(mon),clk("clk",sc_time(10,SC_NS))
	{

		SC_MODULE_LINK(wave);
		SC_MODULE_LINK(mon);
		SC_MODULE_LINK(cnn_u1);

		wave.ready(ready);
		wave.data_out(wave_2_u1);
		wave.data_ctrl(data_ctrl);
		wave.weight_ctrl(weight_ctrl);
		wave.ctrl_row_N(ctrl_row_N);
		wave.ctrl_channel(ctrl_channel);

		cnn_u1.ready(ready);
		cnn_u1.ctrl_row_N(ctrl_row_N);
		cnn_u1.weight_ctrls(weight_ctrl);
		cnn_u1.data_ctrls(data_ctrl);
		cnn_u1.ctrl_channel(ctrl_channel);
		cnn_u1.data_sink(wave_2_u1);
		cnn_u1.data_source(u1_2_mon);
		mon.data_in(u1_2_mon);

		tracePtr = sc_create_vcd_trace_file("tb_CNN");
		trace(tracePtr);
	}

	inline void trace(sc_trace_file *trace)
	{
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

	virtual ~tb_CNN()
	{
		sc_close_vcd_trace_file(tracePtr);
	}
};

//--end


unsigned errors = 0;
const char simulation_name[] = "tb_CNN";

int sc_main(int argc, char* argv[]) {
  cout << "INFO: Elaborating "<< simulation_name << endl;
  sc_core::sc_report_handler::set_actions( "/IEEE_Std_1666/deprecated",
                                             sc_core::SC_DO_NOTHING );
  sc_report_handler::set_actions( SC_ID_LOGIC_X_TO_BOOL_, SC_LOG);
  sc_report_handler::set_actions( SC_ID_VECTOR_CONTAINS_LOGIC_VALUE_, SC_LOG);
  sc_report_handler::set_actions( SC_ID_OBJECT_EXISTS_, SC_LOG);
  //sc_set_time_resolution(1,SC_PS);
  //sc_set_default_time_unit(1,SC_NS);
  //ModuleSingle modulesingle("modulesingle_i");
  tb_CNN tb_01("tb_CNN");

  cout << "INFO: Simulating "<< simulation_name << endl;
  sc_start(100,SC_US);
  cout << "INFO: Post-processing "<< simulation_name << endl;
  cout << "INFO: Simulation " << simulation_name
       << " " << (errors?"FAILED":"PASSED")
       << " with " << errors << " errors"
       << std::endl;
#ifdef __RTL_SIMULATION__
  cout << "HW cosim done" << endl;
#endif
  return errors?1:0;
}
