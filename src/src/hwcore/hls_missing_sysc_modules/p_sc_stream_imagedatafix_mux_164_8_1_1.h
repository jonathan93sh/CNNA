#pragma once
#include <systemc.h>

template <int x, int y, int DIN0, int DIN1, int DIN2, int DIN3, int DIN4, int DIN5, int DIN6, int DIN7, int DIN8,
          int DIN9, int DIN10, int DIN11, int DIN12, int DIN13, int DIN14, int DIN15, int DIN16, int DOUT>
SC_MODULE(p_sc_stream_imagedatafix_mux_164_8_1_1) {
	sc_in<sc_lv<DIN0> > din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11, din12, din13, din14,
	    din15;
	sc_in<sc_lv<DIN16> > din16;
	sc_out<sc_lv<DOUT> > dout;

	void logic() {

		switch (din16.read().to_uint()) {
		case 0:
			dout.write(din0.read());
			break;
		case 1:
			dout.write(din1.read());
			break;
		case 2:
			dout.write(din2.read());
			break;
		case 3:
			dout.write(din3.read());
			break;
		case 4:
			dout.write(din4.read());
			break;
		case 5:
			dout.write(din5.read());
			break;
		case 6:
			dout.write(din6.read());
			break;
		case 7:
			dout.write(din7.read());
			break;
		case 8:
			dout.write(din8.read());
			break;
		case 9:
			dout.write(din9.read());
			break;
		case 10:
			dout.write(din10.read());
			break;
		case 11:
			dout.write(din11.read());
			break;
		case 12:
			dout.write(din12.read());
			break;
		case 13:
			dout.write(din13.read());
			break;
		case 14:
			dout.write(din14.read());
			break;
		case 15:
			dout.write(din15.read());
			break;

		default:
			dout.write(0);
			break;
		}
	}

	SC_CTOR(p_sc_stream_imagedatafix_mux_164_8_1_1) {
		SC_METHOD(logic)
		sensitive << din0 << din1 << din2 << din3 << din4 << din5 << din6 << din7 << din8 << din9 << din10 << din11
		          << din12 << din13 << din14 << din15 << din16;
	}
};
