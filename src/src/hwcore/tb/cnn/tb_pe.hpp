#pragma once
#include "hwcore/cnn/pe.h"
#include <systemc.h>

#define debug_cout std::cout << "[" << sc_time_stamp().to_string() << "] - " << __FILE__ << " - "

template <int W, int P, int N> SC_MODULE(tb_pe) {
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W + 1 * W>::interface_T interface_W_T;
	typedef typename hwcore::pipes::SC_DATA_STREAM_T_trait<1 * W>::interface_T interface_out_T;
	sc_clock clk;
	sc_in<bool> iclk;
	sc_signal<bool> reset;

	hwcore::cnn::PE<W, P, N> pe;

	sc_fifo<interface_T> xin; // in
	sc_fifo<interface_W_T> win;
	sc_fifo<interface_out_T> dout;  // out
	sc_fifo<sc_uint<16> > ctrl_acf; // out

	SC_CTOR(tb_pe) : clk("clock", sc_time(10, SC_NS)), pe("pe"), xin(1), dout(1), win(1), ctrl_acf(1) {
		iclk(clk);
		pe.clk(clk);
		pe.reset(reset);
		pe.Win(win);
		pe.Xin(xin);
		pe.dout(dout);
		pe.ctrl_acf(ctrl_acf);
		SC_CTHREAD(waveform, iclk.pos());
		SC_CTHREAD(monitor, iclk.pos());
	}

	int func(int a, int b) {
		int tmpSum = (a << 16) + (b << 16);
		return tmpSum;
	}

	void waveform() {
		debug_cout << " - [waveform start]" << std::endl;
		interface_W_T Wtmp_out;
		interface_T Xtmp_out;
		interface_T tmp_out;

		reset.write(1);
		for (int i = 0; i < 5; i++)
			wait();
		reset.write(0);
		int size = 5;
		int repeat = 7;
		for (int r = 0; r < repeat; r++) {
			ctrl_acf.write(0 | (hwcore::hf::ufixed2bv<15, 1>(1.0).to_uint() << 1));
			for (int a = 0; a < size; a++) {
				for (int b = 0; b < size; b++) {
					Xtmp_out.data = func(a, b);
					Xtmp_out.setKeep();
					Xtmp_out.tlast = (a == size - 1 && b == size - 1 ? 1 : 0);
					Wtmp_out.data = ((2 << 16) << 32) | (0 << 16);
					Wtmp_out.setKeep();
					Wtmp_out.tlast = (a == size - 1 && b == size - 1 ? 1 : 0);
					debug_cout << "(waveform)[r]=[" << r << "],[a,b]=[" << a << "," << b << "][data]=[" << func(a, b)
					           << "]" << std::endl;
					xin.write(Xtmp_out);
					win.write(Wtmp_out);
				}
			}
			tmp_out.setEOP();
			Wtmp_out.setEOP();
			xin.write(tmp_out);
			win.write(Wtmp_out);
			// dout.write(tmp_out);
			debug_cout << "(waveform)[EOP]" << std::endl;
			wait();
		}

		Xtmp_out.data = 2 << 29;

		Xtmp_out.setKeep();
		Wtmp_out.data = (4 << 16) << 32;
		Wtmp_out.setKeep();
		ctrl_acf.write(1 | (hwcore::hf::ufixed2bv<15, 1>(1.0).to_uint() << 1)); // use ReLU
		for (int i = 0; i < 20; i++) {
			Wtmp_out.tlast = (i == 20 - 1 ? 1 : 0);
			Xtmp_out.tlast = Wtmp_out.tlast;
			xin.write(Xtmp_out);
			win.write(Wtmp_out);
		}

		tmp_out.setEOP();
		Wtmp_out.setEOP();
		xin.write(tmp_out);
		win.write(Wtmp_out);

		debug_cout << " - [waveform done]" << std::endl;
		while (true) {
			wait();
		}
	}

	void monitor() {
		debug_cout << " - [waveform monitor]" << std::endl;
		sc_int<W> tmp[2];
		interface_out_T tmp_in;
		int size = 5;
		int repeat = 7;
		for (int r = 0; r < repeat; r++) {
			dout.read(tmp_in);
			tmp_in.template getData<sc_int, W, 1>(tmp);

			debug_cout << "(monitor)[r]=[" << r << "],[data]=[" << tmp[0].to_int() << "]<=>[expected][" << (200 << 16)
			           << "]" << std::endl;
			sc_assert((200 << 16) == tmp[0].to_int());

			dout.read(tmp_in);
			sc_assert(tmp_in.EOP());
			debug_cout << "(monitor)[r]=[" << r << "] looking for EOP" << std::endl;
		}

		dout.read(tmp_in);
		sc_assert(!tmp_in.EOP());

		for (int i = 0; i < W; i++) {
			if (i == W - 1)
				sc_assert(tmp_in.data[i] == 0);
			else
				sc_assert(tmp_in.data[i] == 1);
		}

		sc_stop();

		while (true) {
			wait();
		}
	}

	void monitor_vec() {}
};
