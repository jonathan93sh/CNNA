#pragma once
#include <systemc.h>

template <int ID, int NUM_STAGE, int din0_WIDTH, int din1_WIDTH, int din2_WIDTH, int dout_WIDTH>
SC_MODULE(simcore_mac_4) {
	sc_core::sc_in<sc_dt::sc_lv<din0_WIDTH> > din0;
	sc_core::sc_in<sc_dt::sc_lv<din1_WIDTH> > din1;
	sc_core::sc_in<sc_dt::sc_lv<din2_WIDTH> > din2;
	sc_core::sc_out<sc_dt::sc_lv<dout_WIDTH> > dout;

	SC_CTOR(simcore_mac_4) {
		SC_METHOD(mac_method);
		sensitive << din0 << din1 << din2;
	}

	void mac_method() {
		sc_uint<din0_WIDTH> din0_tmp = sc_uint<din0_WIDTH>(din0);
		sc_uint<din1_WIDTH> din1_tmp = sc_uint<din1_WIDTH>(din1);
		sc_int<din2_WIDTH> din2_tmp = sc_int<din2_WIDTH>(din2);
		sc_uint<dout_WIDTH> dout_tmp = (din0_tmp * din1_tmp) + din2_tmp;
		dout.write(dout_tmp);
	}
};

// simcore_mac_0<ID, 1, din0_WIDTH, din1_WIDTH, din2_WIDTH, dout_WIDTH> simcore_mac_0_U;
