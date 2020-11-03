// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Sat Feb 29 21:52:02 2020
// Host        : jonathan-System-Product-Name running 64-bit Ubuntu 18.04.4 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top CNNA_BD_cnn_0_0 -prefix
//               CNNA_BD_cnn_0_0_ CNNA_BD_cnn_0_0_stub.v
// Design      : CNNA_BD_cnn_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "cnn_top,Vivado 2019.1" *)
module CNNA_BD_cnn_0_0(M_AXIS_Y_TVALID, M_AXIS_Y_TREADY, 
  M_AXIS_Y_TDATA, M_AXIS_Y_TLAST, M_AXIS_Y_TKEEP, S_AXIS_BUF_TVALID, S_AXIS_BUF_TREADY, 
  S_AXIS_BUF_TDATA, S_AXIS_BUF_TLAST, S_AXIS_BUF_TKEEP, S_AXIS_CTRL_TVALID, 
  S_AXIS_CTRL_TREADY, S_AXIS_CTRL_TDATA, S_AXIS_CTRL_TLAST, S_AXIS_CTRL_TKEEP, 
  S_AXIS_W_TVALID, S_AXIS_W_TREADY, S_AXIS_W_TDATA, S_AXIS_W_TLAST, S_AXIS_W_TKEEP, 
  S_AXIS_X_TVALID, S_AXIS_X_TREADY, S_AXIS_X_TDATA, S_AXIS_X_TLAST, S_AXIS_X_TKEEP, 
  s_axi_slv0_AWADDR, s_axi_slv0_AWVALID, s_axi_slv0_AWREADY, s_axi_slv0_WDATA, 
  s_axi_slv0_WSTRB, s_axi_slv0_WVALID, s_axi_slv0_WREADY, s_axi_slv0_BRESP, 
  s_axi_slv0_BVALID, s_axi_slv0_BREADY, s_axi_slv0_ARADDR, s_axi_slv0_ARVALID, 
  s_axi_slv0_ARREADY, s_axi_slv0_RDATA, s_axi_slv0_RRESP, s_axi_slv0_RVALID, 
  s_axi_slv0_RREADY, aclk, aresetn)
/* synthesis syn_black_box black_box_pad_pin="M_AXIS_Y_TVALID,M_AXIS_Y_TREADY,M_AXIS_Y_TDATA[127:0],M_AXIS_Y_TLAST[0:0],M_AXIS_Y_TKEEP[15:0],S_AXIS_BUF_TVALID,S_AXIS_BUF_TREADY,S_AXIS_BUF_TDATA[127:0],S_AXIS_BUF_TLAST[0:0],S_AXIS_BUF_TKEEP[15:0],S_AXIS_CTRL_TVALID,S_AXIS_CTRL_TREADY,S_AXIS_CTRL_TDATA[63:0],S_AXIS_CTRL_TLAST[0:0],S_AXIS_CTRL_TKEEP[7:0],S_AXIS_W_TVALID,S_AXIS_W_TREADY,S_AXIS_W_TDATA[127:0],S_AXIS_W_TLAST[0:0],S_AXIS_W_TKEEP[15:0],S_AXIS_X_TVALID,S_AXIS_X_TREADY,S_AXIS_X_TDATA[127:0],S_AXIS_X_TLAST[0:0],S_AXIS_X_TKEEP[15:0],s_axi_slv0_AWADDR[7:0],s_axi_slv0_AWVALID,s_axi_slv0_AWREADY,s_axi_slv0_WDATA[31:0],s_axi_slv0_WSTRB[3:0],s_axi_slv0_WVALID,s_axi_slv0_WREADY,s_axi_slv0_BRESP[1:0],s_axi_slv0_BVALID,s_axi_slv0_BREADY,s_axi_slv0_ARADDR[7:0],s_axi_slv0_ARVALID,s_axi_slv0_ARREADY,s_axi_slv0_RDATA[31:0],s_axi_slv0_RRESP[1:0],s_axi_slv0_RVALID,s_axi_slv0_RREADY,aclk,aresetn" */;
  output M_AXIS_Y_TVALID;
  input M_AXIS_Y_TREADY;
  output [127:0]M_AXIS_Y_TDATA;
  output [0:0]M_AXIS_Y_TLAST;
  output [15:0]M_AXIS_Y_TKEEP;
  input S_AXIS_BUF_TVALID;
  output S_AXIS_BUF_TREADY;
  input [127:0]S_AXIS_BUF_TDATA;
  input [0:0]S_AXIS_BUF_TLAST;
  input [15:0]S_AXIS_BUF_TKEEP;
  input S_AXIS_CTRL_TVALID;
  output S_AXIS_CTRL_TREADY;
  input [63:0]S_AXIS_CTRL_TDATA;
  input [0:0]S_AXIS_CTRL_TLAST;
  input [7:0]S_AXIS_CTRL_TKEEP;
  input S_AXIS_W_TVALID;
  output S_AXIS_W_TREADY;
  input [127:0]S_AXIS_W_TDATA;
  input [0:0]S_AXIS_W_TLAST;
  input [15:0]S_AXIS_W_TKEEP;
  input S_AXIS_X_TVALID;
  output S_AXIS_X_TREADY;
  input [127:0]S_AXIS_X_TDATA;
  input [0:0]S_AXIS_X_TLAST;
  input [15:0]S_AXIS_X_TKEEP;
  input [7:0]s_axi_slv0_AWADDR;
  input s_axi_slv0_AWVALID;
  output s_axi_slv0_AWREADY;
  input [31:0]s_axi_slv0_WDATA;
  input [3:0]s_axi_slv0_WSTRB;
  input s_axi_slv0_WVALID;
  output s_axi_slv0_WREADY;
  output [1:0]s_axi_slv0_BRESP;
  output s_axi_slv0_BVALID;
  input s_axi_slv0_BREADY;
  input [7:0]s_axi_slv0_ARADDR;
  input s_axi_slv0_ARVALID;
  output s_axi_slv0_ARREADY;
  output [31:0]s_axi_slv0_RDATA;
  output [1:0]s_axi_slv0_RRESP;
  output s_axi_slv0_RVALID;
  input s_axi_slv0_RREADY;
  input aclk;
  input aresetn;
endmodule
