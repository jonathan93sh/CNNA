############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
############################################################
open_project CNNAccelDMA
set_top cnna_dma
add_files CNNAccelDMA/solution1/cnnadma.cpp
add_files CNNAccelDMA/solution1/cnnadma.h
open_solution "solution1"
set_part {xczu3eg-sbva484-1-e} -tool vivado
create_clock -period 10 -name default
#source "./CNNAccelDMA/solution1/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -format ip_catalog
