# Source code for the Convolutinal Neural Network Accelerator (CNNA), IP Core, Vivado project and bit file
This directory contains the SystemC source code for the IP Core and Vivado project to build the system

# Development Tools
This code requires a development platform with Linux, Python (Anaconda) and Xilinx Vivado 2019.1 installed.

# Modify files to build CNNA IP Core
src/Makefile -> must be updated with the path for the Vivado/2019.1 installation
src/cosim.mk -> the variable VIVADO_SYSTEMC_MODELS must be updated with path to SystemC in the Vivado/2016.1 installation
src/bit_file_gen.tcl -> to be updated with path to location of project (first lines in file)
CNNAccelTest0/CNNAAccelTest0.xpr -> Vivado project must be updated wit correct path to the Vivado/2019.1 installation

# To build the project
To build the CNNA16 configuration [16,128,8,1,32] execute:
src/make build_bit PARAM_LIST='P_data_P=2 P_data_W=16 P_X_fifo_deep=1 P_Y_fifo_deep=1 P_BUF_fifo_deep=1 P_W_fifo_deep=1 HLS_DEBUG_LEVEL=0 P_input_width=128  P_output_width=128 P_pe_n=8 P_pe_bw_n=8 P_wbuf_size=2336 P_data_buf_clb_size=4096 P_data_buf_clb_n=3 P_data_buf_shift_size=192 P_data_out_n=1 P_PE_pipeline_II=1 P_pe_pre_fifo_deep=1 P_pool_size=1024' -j8> make.log 2>&1

src/jupyterlab/HEB.py -> Python script to create and make the bit file stored in src/IP_catalog/[IP core]/bitfiles, this script creates the parameters to make based on configuration

# To clean the project
src/make clean_rtl -> Cleans SystemC build, RTL and Vivado project
 
# Result stored in 
src/IP_catalog/ -> this catalog contains the bit file for the CNNA accelerator with a uniq name for specific configuration