############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
############################################################
open_project generic
set_top generic_module
add_files generic/scmodule.cpp -cflags "-I../src/. -D__SYNTHESIS__"
open_solution "defualt"
set_part {xczu3eg-sbva484-1-e} -tool vivado
create_clock -period 10 -name default
#source "./generic/defualt/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -format ip_catalog
