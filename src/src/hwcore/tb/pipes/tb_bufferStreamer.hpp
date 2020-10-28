/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#pragma once
#define SC_INCLUDE_FX
#include "hwcore/pipes/pipes.h"
#include <systemc.h>

#if __RTL_SIMULATION__

//#include "DMA_performance_tester_rtl_wrapper.h"

//#else
//#include "DMA_generic_performance_tester.hpp"
#endif

const long test_size = 250;

SC_MODULE(mon_bufferstreamer) {
	sc_fifo_out<sc_uint<31> > ctrl_out;
	sc_fifo_in<hwcore::pipes::sc_data_stream_t<16> > data_in;
	SC_CTOR(mon_bufferstreamer) { SC_THREAD(mon_thread); }

	void mon_thread() {
		uint16_t data_gen = 0;
		std::cout << "(mon) req. newset (start) " << std::endl;
		ctrl_out.write(hwcore::pipes::sc_stream_buffer<>::ctrls::newset);
		std::cout << "(mon) req. newset (done) " << std::endl;
		hwcore::pipes::sc_data_stream_t<16> raw_tmp;
		for (int a = 0; a < 5; a++) {
			ctrl_out.write(hwcore::pipes::sc_stream_buffer<>::ctrls::reapeat);
			for (int i = 0; i < test_size; i++) {
				raw_tmp = data_in.read();
				uint16_t tmp = raw_tmp.data.to_uint();
				std::cout << "(mon) got new data: " << tmp << ", last? " << (raw_tmp.tlast ? "true" : "false")
				          << std::endl;
				sc_assert((i == test_size - 1) == (raw_tmp.tlast == 1));
				sc_assert(tmp == i);
				if (tmp != i) {
					sc_stop();
				}
			}
			raw_tmp = data_in.read();
			uint16_t tmp = raw_tmp.data.to_uint();
			std::cout << "(mon) got new data: " << tmp << ", last? " << (raw_tmp.tlast ? "true" : "false") << std::endl;
			sc_assert(raw_tmp.EOP());
		}

		std::cout << "(mon) req. newset (start) " << std::endl;
		ctrl_out.write(hwcore::pipes::sc_stream_buffer<>::ctrls::newset);
		std::cout << "(mon) req. newset (done) " << std::endl;

		for (int a = 0; a < 5; a++) {
			ctrl_out.write(hwcore::pipes::sc_stream_buffer<>::ctrls::reapeat);
			for (int i = 0; i < test_size; i++) {
				raw_tmp = data_in.read();
				uint16_t tmp = raw_tmp.data.to_uint();
				std::cout << "(mon) got new data: " << tmp << ", last? " << (raw_tmp.tlast ? "true" : "false")
				          << std::endl;
				sc_assert((i == test_size - 1) == (raw_tmp.tlast == 1));
				sc_assert(tmp == i + 0xBF);
				if (tmp != i + 0xBF) {
					sc_stop();
				}
			}
			raw_tmp = data_in.read();
			uint16_t tmp = raw_tmp.data.to_uint();
			std::cout << "(mon) got new data: " << tmp << ", last? " << (raw_tmp.tlast ? "true" : "false") << std::endl;
			sc_assert(raw_tmp.EOP());
		}

		std::cout << "Test finish no errors" << std::endl;

		sc_stop();
	}
};

SC_MODULE(wave_bufferstreamer) {
	sc_fifo_out<hwcore::pipes::sc_data_stream_t<16> > data_out;

	SC_CTOR(wave_bufferstreamer) { SC_THREAD(wave_thread); }

	void wave_thread() {
		hwcore::pipes::sc_data_stream_t<16> tmp;
		for (int i = 0; i < test_size; i++) {

			tmp.data = i;
			std::cout << "(wave) write new data: " << i << std::endl;
			tmp.tkeep = 0b11;
			tmp.tlast = (i == test_size - 1);
			std::cout << "(wave) tlast " << (tmp.tlast ? "true" : "false") << std::endl;
			data_out.write(tmp);
		}

		tmp.setEOP();
		data_out.write(tmp);

		for (int i = 0; i < test_size; i++) {
			tmp.data = i + 0xBF;
			std::cout << "(wave) write new data: " << i << std::endl;
			tmp.tkeep = 0b11;
			tmp.tlast = (i == test_size - 1);
			std::cout << "(wave) tlast " << (tmp.tlast ? "true" : "false") << std::endl;
			data_out.write(tmp);
		}

		tmp.setEOP();
		data_out.write(tmp);
	}
};

SC_MODULE(tb_bufferstreamer) {
#if __RTL_SIMULATION__
	// DMA_performance_tester_rtl_wrapper u1;
#else
	// DMA_performance_tester u1;
#endif

	sc_clock clk;
	sc_signal<bool> reset;

	hwcore::pipes::sc_stream_buffer_not_stream_while_write<16> bs_u1;
	wave_bufferstreamer wave;
	mon_bufferstreamer mon;

	sc_fifo<hwcore::pipes::sc_data_stream_t<16> > bs2mon_data;
	sc_fifo<sc_uint<31> > mon2bs_ctrl;

	sc_fifo<hwcore::pipes::sc_data_stream_t<16> > wave2bs_data;

	SC_CTOR(tb_bufferstreamer) : bs_u1("BS"), wave("wave"), mon("mon"), clk("clock", sc_time(10, SC_NS)) {
		bs_u1.clk(clk);
		bs_u1.reset(reset);
		bs_u1.din(wave2bs_data);
		bs_u1.dout(bs2mon_data);
		bs_u1.ctrls_in(mon2bs_ctrl);

		wave.data_out(wave2bs_data);
		mon.ctrl_out(mon2bs_ctrl);
		mon.data_in(bs2mon_data);
	}
};
