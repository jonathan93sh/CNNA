#define SC_INCLUDE_FX
#include <systemc.h>
//#include "hwcore/hf/helperlib.h"
//#include "hwcore/pipes/data_types.h"
//#include "hwcore/cnn/data_buffer.h"
//#include "hwcore/cnn/pe.h"
#include "hwcore/pipes/streamresizedown.h"

#if 0
#ifdef __SYNTHESIS__
#include <ap_fixed.h>
template<int W, int I>
using sc_fixed_sat=ap_fixed<W, I, AP_RND, AP_SAT>;
#else
template<int W, int I>
using sc_fixed_sat=sc_fixed<W, I, SC_RND, SC_SAT>;
#endif
#endif


SC_MODULE(generic_module)
{

public:



	sc_in<bool> clk;                                                                                                   \
	sc_in<bool> reset;

hwcore::pipes::sc_stream_resize_down_fast_v2<32,3,1> rsd;

	/*sc_fifo_in<in_T> din;
	sc_fifo_out<out_T> dout;
	sc_fifo_in<sc_uint<32> > ctrl_image_size;
	sc_fifo_in<sc_uint<16> > ctrl_row_size_pkg;
	sc_fifo_in<sc_uint<16> > ctrl_window_size;
	sc_fifo_in<sc_uint<16> > ctrl_depth;
	sc_fifo_in<sc_uint<16> > ctrl_stride;
	sc_fifo_in<sc_uint<16> > ctrl_replay;*/

	//_data_buffer_TWO_D<32,6,1000,1000,1> test;
	SC_CTOR(generic_module)
	:rsd("rsd")
	 {

		reset_signal_is(reset,true);
		rsd.clk(clk);
		rsd.reset(reset);
		/*test.din(din);
		test.dout(dout);
		test.ctrl_image_size(ctrl_image_size);
		test.ctrl_row_size_pkg(ctrl_row_size_pkg);
		test.ctrl_window_size(ctrl_window_size);
		test.ctrl_depth(ctrl_depth);
		test.ctrl_stride(ctrl_stride);
		test.ctrl_replay(ctrl_replay);*/

	 }
};

