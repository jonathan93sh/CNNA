#!/bin/sh -e
make build_ip PARAM_LIST='P_data_W=32 P_data_P=16 P_pe_n=8 P_pe_bw_n=4 P_wbuf_size=1000 P_data_buf_clb_size=7168 P_data_buf_clb_n=3 P_data_buf_shift_size=768 P_data_out_n=3' -j4
