#pragma once

#include <systemc.h>

#include "hwcore/hf/helperlib.h"
#include "hwcore/pipes/data_types.h"
#include "hwcore/pipes/streamimagedatafix.h"

#include <algorithm>
#include <list>

#define W 16
#define I 2
#define BW 8

SC_MODULE(tb_top_imagedata_fix) {
	sc_clock clk;
	sc_in<bool> iclk;
	sc_signal<bool> reset;

	typedef hwcore::pipes::sc_stream_imagedatafix<W, I, BW> stream_image_t;
	typedef typename stream_image_t::din_T fifo_t;

	stream_image_t imagefix_u0;

	sc_fifo<fifo_t> din;
	sc_fifo<fifo_t> dout;
	sc_fifo<sc_uint<1> > enable;

	SC_CTOR(tb_top_imagedata_fix) : clk("clk", sc_time(10, SC_NS)), SC_INST(imagefix_u0) {
		iclk(clk);
		SC_MODULE_LINK(imagefix_u0);
		imagefix_u0.din(din);
		imagefix_u0.dout(dout);
		imagefix_u0.enable(enable);

		SC_CTHREAD(wave_thread, iclk.pos());
		HLS_DEBUG_EXEC(set_stack_size(128 * 10 * 1024 * 1024));
		SC_CTHREAD(mon_thread, iclk.pos());
		HLS_DEBUG_EXEC(set_stack_size(128 * 10 * 1024 * 1024));
	}

	sc_ufixed<8, 0> func(int a, int b, int c) {
		sc_ufixed<8, 0> tmp = 0;
		tmp(7, 5) = a;
		tmp(4, 2) = b;
		tmp(1, 0) = c;

		return tmp;
	}

	void func_inv(sc_ufixed<8, 0> in, int &a, int &b, int &c) {
		a = in(7, 5).to_int();
		b = in(4, 2).to_int();
		c = in(1, 0).to_int();
	}

	void wave_thread() {
		reset.write(1);
		wait();
		reset.write(0);
		wait();
		sc_assert(BW >= 3);
		const int image_size = 32;

		sc_fixed<W, I> *realign_data = new sc_fixed<W, I>[image_size * image_size * BW];
		for (int x = 0; x < image_size; x++) {
			for (int y = 0; y < image_size; y++) {
				for (int z = 0; z < BW; z++) {
					int ptr_to = (x * image_size * BW) + (y * BW) + z;
					if (z < 3) {
						realign_data[ptr_to] = func(x, y, z);
						std::cout << realign_data[ptr_to].to_float() << std::endl;
					} else {
						realign_data[ptr_to] = 0;
					}
				}
			}
		}

		enable.write(0);
		for (int i = 0; i < image_size * image_size; i++) {
			fifo_t tmp_out;
			tmp_out.setKeep();
			tmp_out.setDataFixed<W, I, BW>(&realign_data[i * BW]);
			tmp_out.tlast = (i == (image_size * image_size) - 1 ? 1 : 0);
			din.write(tmp_out);
		}

		sc_ufixed<8, 0> *raw_data = new sc_ufixed<8, 0>[image_size * image_size * 3];
		for (int x = 0; x < image_size; x++) {
			for (int y = 0; y < image_size; y++) {
				for (int z = 0; z < 3; z++) {
					int ptr_to = (x * image_size * 3) + (y * 3) + z;
					raw_data[ptr_to] = func(x, y, z);
					std::cout << raw_data[ptr_to].to_float() << std::endl;
				}
			}
		}

		enable.write(1);

		const int N = (image_size * image_size * 3 * 8) / (BW * W);
		const int N_pr_pkg = (BW * W) / 8;
		for (int i = 0; i < N; i++) {
			fifo_t tmp_out;
			tmp_out.setKeep();
			tmp_out.setDataUfixed<8, 0, (BW * W) / 8>(&raw_data[i * N_pr_pkg]);
			tmp_out.tlast = (i == N - 1 ? 1 : 0);
			din.write(tmp_out);
		}
		while (true) {
			wait();
		}
	}

	void mon_thread() {
		std::list<fifo_t> realign_data;
		std::list<fifo_t> raw_data;

		fifo_t tmp;
		do {
			tmp = dout.read();
			realign_data.push_back(tmp);
		} while (tmp.tlast == 0);
		std::cout << "mon got N samples " << realign_data.size() << std::endl;
		do {
			tmp = dout.read();
			raw_data.push_back(tmp);
		} while (tmp.tlast == 0);
		std::cout << "mon got N samples " << raw_data.size() << std::endl;

		sc_assert(raw_data.size() == realign_data.size());

		auto itr_realign_data = realign_data.begin();
		auto itr_raw_data = raw_data.begin();

		for (int i = 0; i < realign_data.size(); i++) {
			sc_assert(*itr_realign_data == *itr_raw_data);
			itr_realign_data++;
			itr_raw_data++;
		}

		wait();
		sc_stop();
	}
};
