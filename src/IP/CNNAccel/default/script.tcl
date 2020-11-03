############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
############################################################
open_project CNNAccel
set_top cnn
add_files ../src/hwcore/cnn/cnn.cpp -cflags "-D__SYNTHESIS__ -I./../src/. -DP_data_P=2 -DP_data_W=16 -DP_X_fifo_deep=1 -DP_Y_fifo_deep=1 -DP_BUF_fifo_deep=1 -DP_W_fifo_deep=1 -DHLS_DEBUG_LEVEL=999 -DP_input_width=128 -DP_output_width=128 -DP_pe_n=8 -DP_pe_bw_n=8 -DP_wbuf_size=1547 -DP_data_buf_clb_size=4096 -DP_data_buf_clb_n=3 -DP_data_buf_shift_size=192 -DP_data_out_n=3 -DP_PE_pipeline_II=1 -DP_pe_pre_fifo_deep=1 -DP_pool_size=1024"
add_files ../src/hwcore/cnn/cnn.h -cflags "-D__SYNTHESIS__ -I./../src/. -DP_data_P=2 -DP_data_W=16 -DP_X_fifo_deep=1 -DP_Y_fifo_deep=1 -DP_BUF_fifo_deep=1 -DP_W_fifo_deep=1 -DHLS_DEBUG_LEVEL=999 -DP_input_width=128 -DP_output_width=128 -DP_pe_n=8 -DP_pe_bw_n=8 -DP_wbuf_size=1547 -DP_data_buf_clb_size=4096 -DP_data_buf_clb_n=3 -DP_data_buf_shift_size=192 -DP_data_out_n=3 -DP_PE_pipeline_II=1 -DP_pe_pre_fifo_deep=1 -DP_pool_size=1024"
add_files -tb ../src/hwcore/cnn/cnn.cpp -cflags "-I../src/. -D__SYNTHESIS__ -DP_data_P=2 -DP_data_W=16 -DP_X_fifo_deep=1 -DP_Y_fifo_deep=1 -DP_BUF_fifo_deep=1 -DP_W_fifo_deep=1 -DHLS_DEBUG_LEVEL=999 -DP_input_width=128 -DP_output_width=128 -DP_pe_n=8 -DP_pe_bw_n=8 -DP_wbuf_size=1547 -DP_data_buf_clb_size=4096 -DP_data_buf_clb_n=3 -DP_data_buf_shift_size=192 -DP_data_out_n=3 -DP_PE_pipeline_II=1 -DP_pe_pre_fifo_deep=1 -DP_pool_size=1024 -Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
add_files -tb CNNAccel/main.cpp -cflags "-I../src/. -D__SYNTHESIS__ -DP_data_P=2 -DP_data_W=16 -DP_X_fifo_deep=1 -DP_Y_fifo_deep=1 -DP_BUF_fifo_deep=1 -DP_W_fifo_deep=1 -DHLS_DEBUG_LEVEL=999 -DP_input_width=128 -DP_output_width=128 -DP_pe_n=8 -DP_pe_bw_n=8 -DP_wbuf_size=1547 -DP_data_buf_clb_size=4096 -DP_data_buf_clb_n=3 -DP_data_buf_shift_size=192 -DP_data_out_n=3 -DP_PE_pipeline_II=1 -DP_pe_pre_fifo_deep=1 -DP_pool_size=1024 -Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
open_solution "default"
set_part {xczu3eg-sbva484-1-e} -tool vivado
create_clock -period 3.333 -name default
config_export -format ip_catalog -rtl verilog -version 3.122.158
#source "./CNNAccel/default/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -flow syn -rtl verilog -format ip_catalog -version "3.122.158"
