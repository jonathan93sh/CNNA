/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#ifdef HW_COSIM
//#define __GMP_WITHIN_CONFIGURE
#endif
#define DEBUG_SYSTEMC
#define SC_INCLUDE_FX
#include "hwcore/tb/cnn/tb_pe.hpp"
#include <systemc.h>

unsigned errors = 0;
const char simulation_name[] = "tb_pe";

int sc_main(int argc, char *argv[]) {
	cout << "INFO: Elaborating " << simulation_name << endl;
	sc_core::sc_report_handler::set_actions("/IEEE_Std_1666/deprecated", sc_core::SC_DO_NOTHING);
	sc_report_handler::set_actions(SC_ID_LOGIC_X_TO_BOOL_, SC_LOG);
	sc_report_handler::set_actions(SC_ID_VECTOR_CONTAINS_LOGIC_VALUE_, SC_LOG);
	// sc_report_handler::set_actions( SC_ID_OBJECT_EXISTS_, SC_LOG);
	// sc_set_time_resolution(1,SC_PS);
	// sc_set_default_time_unit(1,SC_NS);
	// ModuleSingle modulesingle("modulesingle_i");
	return 0;
	tb_pe<sizeof(int) * 8, sizeof(int) * 4, 1> tb_01("tb_pe");

	cout << "INFO: Simulating " << simulation_name << endl;
	sc_time time_out(1000, SC_US);
	sc_start(time_out);
	return errors ? 1 : 0;
	cout << "INFO: end time is: " << sc_time_stamp().to_string() << ", and max time is: " << time_out.to_string()
	     << std::endl
	     << std::flush;
	sc_assert(sc_time_stamp() != time_out);
	cout << "INFO: Post-processing " << simulation_name << endl;
	cout << "INFO: Simulation " << simulation_name << " " << (errors ? "FAILED" : "PASSED") << " with " << errors
	     << " errors" << std::endl
	     << std::flush;
#ifdef __RTL_SIMULATION__
	cout << "HW cosim done" << endl;
#endif
	return errors ? 1 : 0;
}
// test2