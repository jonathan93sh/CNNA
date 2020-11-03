/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#ifdef HW_COSIM
//#define __GMP_WITHIN_CONFIGURE
#endif
#define SC_INCLUDE_FX
#include "hwcore/hw/hw.h"
#include "hwcore/hw/statusreg.h"
#include <systemc.h>

unsigned errors = 0;
const char simulation_name[] = "dma tester test";

void singleport_ram_test() {
	std::cout << "singleport_ram_test" << std::endl;
	hwcore::hw::singleport_ram<64, 32> ram_block;

	for (int i = 0; i < 64; i++) {
		ram_block.exec(i, i, true);
	}

	for (int i = 0; i < 64; i++) {
		sc_assert(ram_block.exec(0, i, false) == i);
	}

	for (int i = 0; i < 64; i++) {
		sc_assert(ram_block.exec(123, i, true) == i);
	}

	for (int i = 0; i < 64; i++) {
		sc_assert(ram_block.exec(0, i, true) == 123);
	}
}

void cirularlinebuffer_test() {
	std::cout << "cirularlinebuffer_test" << std::endl;
	hwcore::hw::circular_line_buffer<11, 1024, 32> clb;
	sc_dt::sc_biguint<32> window[11];
	for (int a = 0; a < 32; a++) {
		for (int b = 0; b < 16; b++) {
			sc_dt::sc_biguint<32> window[11] = {0};
			clb.exec((a * b) + b, b, window);

			for (int i = 0; i < 11; i++) {
				std::cout << "window[" << i << "] = " << window[i].to_int() << std::endl;
			}

			for (int a_t = 0; a_t < 11 && a_t < a + 1; a_t++) {
				int a_t_val = a - a_t;
				// SC_REPORT_INFO(SC_INFO, std::string("window[") + std::to_string(11-a_t-1) +  "] = " +)
				std::cout << "window[" << (11 - a_t - 1) << "] = " << (window[11 - a_t - 1]).to_int()
				          << "(a_t_val:" << a_t_val << ", b:" << b << ") a_t_val*b + b:" << ((a_t_val * b) + b)
				          << std::endl;
				std::cout << std::flush;
				sc_assert(window[11 - a_t - 1].to_int() == ((a_t_val * b) + b));
			}
		}
		std::cout << "EOL:(line: " << a << ")" << std::endl;
		clb.EOL_Handle();
	}
}

SC_MODULE(tester) {
	sc_clock clk;
	sc_in<bool> iclk;
	sc_signal<bool> reset;
	sc_status_test status_test;
	sc_signal<int> add;
	sc_signal<int> status;
	// sc_fifo<int> in;
	// sc_fifo<int> out;

	SC_CTOR_DEFAULT(tester) : clk("clk", sc_time(10, SC_NS)), status_test("status") { //}, in(1), out(1) {
		iclk(clk);
		SC_CTHREAD(test_thread, iclk.pos());
		// reset_signal_is(reset, true);
		status_test.clk(clk);
		status_test.reset(reset);
		status_test.status_add(add);
		status_test.status_val(status);

		// status_test.fifo_ingress(in);
		// status_test.fifo_egress(out);
	}

	void test_thread() {
		reset.write(0);
		// in.write(123);
		// sc_assert(out.read() == 123);
		singleport_ram_test();
		cirularlinebuffer_test();
		wait();
		add.write(0);
		wait();
		debug_cout << "reg0: " << status.read() << std::endl;
		sc_assert(status.read() == -1);
		add.write(1);
		wait();
		debug_cout << "reg1: " << status.read() << std::endl;
		sc_assert(status.read() == 0xBEEF);
		add.write(2);
		wait();
		debug_cout << "reg2: " << status.read() << std::endl;
		sc_assert(status.read() == 0xFEEB);
		add.write(3);
		wait();
		debug_cout << "reg3: " << status.read() << std::endl;
		sc_assert(status.read() == 3);
		add.write(4);
		wait();
		debug_cout << "reg4: " << status.read() << std::endl;
		sc_assert(status.read() > 0);
		add.write(5);
		wait();
		/*debug_cout << "reg5: " << status.read() << std::endl;
		sc_assert(status.read() == 1);
		add.write(6);
		wait();
		debug_cout << "reg6: " << status.read() << std::endl;
		sc_assert(status.read() == 0);
		add.write(7);
		wait();*/
		debug_cout << "reg5: " << status.read() << std::endl;
		sc_assert(status.read() == 5);

		sc_stop();
	}
};

int sc_main(int argc, char *argv[]) {
	cout << "INFO: Elaborating " << simulation_name << endl;
	sc_core::sc_report_handler::set_actions("/IEEE_Std_1666/deprecated", sc_core::SC_DO_NOTHING);
	sc_report_handler::set_actions(SC_ID_LOGIC_X_TO_BOOL_, SC_LOG);
	sc_report_handler::set_actions(SC_ID_VECTOR_CONTAINS_LOGIC_VALUE_, SC_LOG);
	// sc_report_handler::set_actions( SC_ID_OBJECT_EXISTS_, SC_LOG);
	// sc_set_time_resolution(1,SC_PS);
	// sc_set_default_time_unit(1,SC_NS);
	// ModuleSingle modulesingle("modulesingle_i");
	tester tb_01("hw_test");

	cout << "INFO: Simulating " << simulation_name << endl;
	sc_time time_out(1000, SC_US);
	sc_start(time_out);
	cout << "INFO: end time is: " << sc_time_stamp().to_string() << ", and max time is: " << time_out.to_string()
	     << std::endl
	     << std::flush;
	sc_assert(sc_time_stamp() != time_out);
	cout << "INFO: Post-processing " << simulation_name << endl;
	cout << "INFO: Simulation " << simulation_name << " " << (errors ? "FAILED" : "PASSED") << " with " << errors
	     << " errors" << std::endl;
#ifdef __RTL_SIMULATION__
	cout << "HW cosim done" << endl;
#endif
	return errors ? 1 : 0;
}
