// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Tue Sep 24 12:48:12 2019
// Host        : jonathan-ThinkPad-T520 running 64-bit Ubuntu 18.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/jonathan/git/CNNAccel/src/vivado/CNNA/CNNA.srcs/sources_1/bd/design_1/ip/design_1_cnn_0_0/design_1_cnn_0_0_stub.v
// Design      : design_1_cnn_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "cnn_top,Vivado 2019.1" *)
module design_1_cnn_0_0(M_AXIS_DATA_TVALID, M_AXIS_DATA_TREADY, 
  M_AXIS_DATA_TDATA, M_AXIS_DATA_TLAST, M_AXIS_DATA_TKEEP, S_AXIS_DATA_TVALID, 
  S_AXIS_DATA_TREADY, S_AXIS_DATA_TDATA, S_AXIS_DATA_TLAST, S_AXIS_DATA_TKEEP, 
  s_axi_slv0_AWADDR, s_axi_slv0_AWVALID, s_axi_slv0_AWREADY, s_axi_slv0_WDATA, 
  s_axi_slv0_WSTRB, s_axi_slv0_WVALID, s_axi_slv0_WREADY, s_axi_slv0_BRESP, 
  s_axi_slv0_BVALID, s_axi_slv0_BREADY, s_axi_slv0_ARADDR, s_axi_slv0_ARVALID, 
  s_axi_slv0_ARREADY, s_axi_slv0_RDATA, s_axi_slv0_RRESP, s_axi_slv0_RVALID, 
  s_axi_slv0_RREADY, aclk, aresetn)
/* synthesis syn_black_box black_box_pad_pin="M_AXIS_DATA_TVALID,M_AXIS_DATA_TREADY,M_AXIS_DATA_TDATA[63:0],M_AXIS_DATA_TLAST[0:0],M_AXIS_DATA_TKEEP[7:0],S_AXIS_DATA_TVALID,S_AXIS_DATA_TREADY,S_AXIS_DATA_TDATA[63:0],S_AXIS_DATA_TLAST[0:0],S_AXIS_DATA_TKEEP[7:0],s_axi_slv0_AWADDR[6:0],s_axi_slv0_AWVALID,s_axi_slv0_AWREADY,s_axi_slv0_WDATA[31:0],s_axi_slv0_WSTRB[3:0],s_axi_slv0_WVALID,s_axi_slv0_WREADY,s_axi_slv0_BRESP[1:0],s_axi_slv0_BVALID,s_axi_slv0_BREADY,s_axi_slv0_ARADDR[6:0],s_axi_slv0_ARVALID,s_axi_slv0_ARREADY,s_axi_slv0_RDATA[31:0],s_axi_slv0_RRESP[1:0],s_axi_slv0_RVALID,s_axi_slv0_RREADY,aclk,aresetn" */;
  output M_AXIS_DATA_TVALID;
  input M_AXIS_DATA_TREADY;
  output [63:0]M_AXIS_DATA_TDATA;
  output [0:0]M_AXIS_DATA_TLAST;
  output [7:0]M_AXIS_DATA_TKEEP;
  input S_AXIS_DATA_TVALID;
  output S_AXIS_DATA_TREADY;
  input [63:0]S_AXIS_DATA_TDATA;
  input [0:0]S_AXIS_DATA_TLAST;
  input [7:0]S_AXIS_DATA_TKEEP;
  input [6:0]s_axi_slv0_AWADDR;
  input s_axi_slv0_AWVALID;
  output s_axi_slv0_AWREADY;
  input [31:0]s_axi_slv0_WDATA;
  input [3:0]s_axi_slv0_WSTRB;
  input s_axi_slv0_WVALID;
  output s_axi_slv0_WREADY;
  output [1:0]s_axi_slv0_BRESP;
  output s_axi_slv0_BVALID;
  input s_axi_slv0_BREADY;
  input [6:0]s_axi_slv0_ARADDR;
  input s_axi_slv0_ARVALID;
  output s_axi_slv0_ARREADY;
  output [31:0]s_axi_slv0_RDATA;
  output [1:0]s_axi_slv0_RRESP;
  output s_axi_slv0_RVALID;
  input s_axi_slv0_RREADY;
  input aclk;
  input aresetn;
endmodule
