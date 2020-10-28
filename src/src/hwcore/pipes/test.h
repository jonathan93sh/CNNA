/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/pipes.h"
#include <systemc.h>

template <int width, int testVal = 1> class testname : sc_module {
  public:
	SC_MODULE_CLK_RESET_SIGNAL;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * width>::interface_T interface;
	// sc_fifo_in<int > din;
	// sc_fifo_out<int > dout;
	sc_fifo_in<interface> din;
	// sc_fifo_out<typename hwcore::pipes::SC_DATA_STREAM_T_trait<1*width>::interface_T > dout;
	sc_fifo_out<interface> dout;
	//#define SC_CTOR(user_module_name)                                             \
    //    typedef user_module_name SC_CURRENT_USER_MODULE;                          \
    //    user_module_name( ::sc_core::sc_module_name )
	typedef testname SC_CURRENT_USER_MODULE;
	inline explicit testname(sc_module_name) //::sc_core::sc_module_name = "test" )
	{

		SC_CTHREAD(test_thread, clk.pos());
		reset_signal_is(reset, true);
	}

	void test_thread() {
		while (true) {

			interface test = din.read();
			dout.write(test);
		}
	}
};

namespace tester {
template <int width, int testVal = 1> using testname = ::testname<width, testVal>;
}

template <int width, int testVal = 1> struct test : ::sc_core::sc_module {
  public:
	tester::testname<width, testVal> lol;

	SC_MODULE_CLK_RESET_SIGNAL;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * width>::interface_T interface;
	// sc_fifo_in<int > din;
	// sc_fifo_out<int > dout;
	sc_fifo_in<interface> din;
	// sc_fifo_out<typename hwcore::pipes::SC_DATA_STREAM_T_trait<1*width>::interface_T > dout;
	sc_fifo_out<interface> dout;
	//#define SC_CTOR(user_module_name)                                             \
//    typedef user_module_name SC_CURRENT_USER_MODULE;                          \
//    user_module_name( ::sc_core::sc_module_name )
	typedef test SC_CURRENT_USER_MODULE;
	inline explicit test(::sc_core::sc_module_name) //::sc_core::sc_module_name = "test" )
	    : lol("loler") {

		lol.clk(clk);
		lol.reset(reset);
		lol.din(din);
		lol.dout(dout);

		// SC_CTHREAD(test_thread,clk.pos());
		reset_signal_is(reset, true);
	}

	/*void test_thread()
	{
	    while(true)
	    {

	        interface test = din.read();
	        dout.write(test);
	    }
	}*/
};