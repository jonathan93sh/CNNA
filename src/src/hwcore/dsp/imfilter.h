#pragma once
#define SC_INCLUDE_FX

#include <systemc.h>
#include "hwcore/hf/helperlib.h"
#include "hwcore/hw/hw.h"
#include "hwcore/pipes/pipes.h"
#include "hwcore/pipes/data_types.h"
#include "hwcore/dsp/param.h"

#define im_WIDTH 512
#define im_HIGH 512
#define N_ROWS 3
#define W_WIDTH 32
#define P_DATA 16

#ifndef HWCORE_DSP_PARAM_ENABLE
#define X_W W_WIDTH
#define X_P P_DATA
#define W_W W_WIDTH
#define W_P P_DATA
#define Y_W W_WIDTH
#define Y_P P_DATA
#else
#define X_P HWCORE_P1
#define X_W HWCORE_P2
#define W_P HWCORE_P3
#define W_W HWCORE_P4
#define Y_P HWCORE_P5
#define Y_W HWCORE_P6
#endif

/*namespace hwcore
{
namespace dsp
{*/

//typedef hwcore::pipes::DATA_STREAM_t<W_WIDTH> DATA_STREAM_16;



SC_MODULE(imfilter)
{
private:
  public:
	
	typedef sc_fixed<W_WIDTH,P_DATA> fixed_t;
	typedef sc_fixed<X_W,X_P> fixed_X_t;
	typedef sc_fixed<W_W,W_P> fixed_W_t;
	typedef sc_fixed<Y_W,Y_P> fixed_Y_t;
	typedef typename hwcore::pipes::sc_data_stream_t<W_WIDTH> data_t;
	//typedef hwcore::pipes::DATA_t<16>::interface_T data_base_t;

	SC_MODULE_CLK_RESET_SIGNAL;

	sc_in<fixed_t> Win[N_ROWS*N_ROWS];
	/*sc_fifo_in<hwcore::pipes::DATA_STREAM_16 > din;
	sc_fifo_out<hwcore::pipes::DATA_STREAM_16 > dout;*/
	sc_fifo_in<hwcore::pipes::SC_DATA_T(W_WIDTH) > din;
	sc_fifo_out<hwcore::pipes::SC_DATA_T(W_WIDTH) > dout;

	SC_CTOR_DEFAULT(imfilter)
	{
		#pragma HLS ARRAY_PARTITION variable=Win complete dim=1

		SC_CTHREAD(imfilter_thread, clk.pos());
		reset_signal_is(reset,true);
	}

	

	void imfilter_thread();
};

/*} // namespace dsp
} // namespace hwcore*/
