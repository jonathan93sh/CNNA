# ==============================================================
# File generated on Wed Jun 19 11:41:21 +0200 2019
# Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
# SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
# IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
# Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
# ==============================================================
add_files -tb ../main.cpp -cflags { -I../../.. -DHW_COSIM -Wno-unknown-pragmas}
add_files -tb ../../../hwcore/cnn/cnn.cpp -cflags { -I../../.. -Wno-unknown-pragmas}
add_files ../hwcore/cnn/cnn.h -cflags {-D__SYNTHESIS__ -I./../.}
add_files ../hwcore/cnn/cnn.cpp -cflags {-D__SYNTHESIS__ -I./../.}
set_part xc7z020clg484-1
create_clock -name default -period 10
config_export -format=ip_catalog
config_export -rtl=verilog
