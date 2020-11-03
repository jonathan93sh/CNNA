#pragma once

#include <systemc>

template <int ID, int NUM_STAGE, int din0_WIDTH, int din1_WIDTH, int din2_WIDTH, int dout_WIDTH>
SC_MODULE(simcore_am_0) {
	sc_in<sc_dt::sc_lv<din0_WIDTH> > din0;
	sc_in<sc_dt::sc_lv<din1_WIDTH> > din1;
	sc_in<sc_dt::sc_lv<din2_WIDTH> > din2;
	sc_out<sc_dt::sc_lv<dout_WIDTH> > dout;

	
	SC_CTOR(simcore_am_0) {
		SC_METHOD(logic);
		sensitive << din0 << din1 << din2;
	}

	void logic() {
		sc_uint<27> a = din0.read();
		sc_uint<27> d = din1.read();
		sc_uint<18> b = din2.read();
		sc_uint<27> ad = a + d;
		sc_uint<45> m = ad * b;
		dout.write((sc_uint<dout_WIDTH>)m);
	}
};