/*
 *  Created on: 21. jun. 2019
 *      Author: Jonathan Horsted Schougaard
 */
#ifdef HW_COSIM
//#define __GMP_WITHIN_CONFIGURE
#endif
#define SC_INCLUDE_FX
#include <systemc.h>
#include "hwcore/tb/improc/tb_imfilter.h"

unsigned errors = 0;
const char simulation_name[] = "dma tester test";

int sc_main(int argc, char* argv[]) {
  cout << "INFO: Elaborating "<< simulation_name << endl;
  sc_core::sc_report_handler::set_actions( "/IEEE_Std_1666/deprecated",
                                             sc_core::SC_DO_NOTHING );
  sc_report_handler::set_actions( SC_ID_LOGIC_X_TO_BOOL_, SC_LOG);
  sc_report_handler::set_actions( SC_ID_VECTOR_CONTAINS_LOGIC_VALUE_, SC_LOG);
  sc_report_handler::set_actions( SC_ID_OBJECT_EXISTS_, SC_LOG);
  //sc_set_time_resolution(1,SC_PS);
  //sc_set_default_time_unit(1,SC_NS);
  //ModuleSingle modulesingle("modulesingle_i");
  TB_imfilter_top tb_01;

  cout << "INFO: Simulating "<< simulation_name << endl;
  sc_start();
  cout << "INFO: Post-processing "<< simulation_name << endl;
  cout << "INFO: Simulation " << simulation_name
       << " " << (errors?"FAILED":"PASSED")
       << " with " << errors << " errors"
       << std::endl;
#ifdef __RTL_SIMULATION__
  cout << "HW cosim done" << endl;
#endif
  return errors?1:0;
}
