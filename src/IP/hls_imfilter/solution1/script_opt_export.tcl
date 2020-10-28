############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
############################################################
open_project hls_imfilter
set_top imfilter
add_files ../hwcore/dsp/imfilter.cpp -cflags "-D__SYNTHESIS__ -I./../."
open_solution "solution1"
set_part {xc7z020clg484-1} -tool vivado
create_clock -period 10 -name default
config_export -format ip_catalog -rtl vhdl
#source "./hls_imfilter/solution1/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -flow syn -rtl vhdl -format ip_catalog
