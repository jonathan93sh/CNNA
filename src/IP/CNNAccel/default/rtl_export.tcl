############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
############################################################
open_project CNNAccel
set_top cnn
add_files ../src/hwcore/cnn/cnn.h -cflags "-D__SYNTHESIS__ -I./../src/."
add_files ../src/hwcore/cnn/cnn.cpp -cflags "-D__SYNTHESIS__ -I./../src/."
add_files -tb CNNAccel/main.cpp -cflags "-I../src/. -DHW_COSIM -Wno-unknown-pragmas"
add_files -tb ../src/hwcore/cnn/cnn.cpp -cflags "-I../src/. -Wno-unknown-pragmas"
open_solution "default"
#set_part {xc7z020clg484-1}
set_part {xczu3eg-sbva484-1-e} -tool vivado
create_clock -period 5 -name default
config_export -format ip_catalog -rtl verilog -version 1.7
#source "./CNNAccel/default/directives.tcl"
#csim_design -clean
csynth_design
#cosim_design
export_design -flow impl -rtl verilog -format ip_catalog
