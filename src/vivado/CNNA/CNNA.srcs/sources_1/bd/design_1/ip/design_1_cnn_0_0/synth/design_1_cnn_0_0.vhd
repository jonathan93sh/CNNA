-- (c) Copyright 1995-2019 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:hls:cnn:1.0
-- IP Revision: 1909241116

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY design_1_cnn_0_0 IS
  PORT (
    M_AXIS_DATA_TVALID : OUT STD_LOGIC;
    M_AXIS_DATA_TREADY : IN STD_LOGIC;
    M_AXIS_DATA_TDATA : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    M_AXIS_DATA_TLAST : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    M_AXIS_DATA_TKEEP : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    S_AXIS_DATA_TVALID : IN STD_LOGIC;
    S_AXIS_DATA_TREADY : OUT STD_LOGIC;
    S_AXIS_DATA_TDATA : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    S_AXIS_DATA_TLAST : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    S_AXIS_DATA_TKEEP : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axi_slv0_AWADDR : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    s_axi_slv0_AWVALID : IN STD_LOGIC;
    s_axi_slv0_AWREADY : OUT STD_LOGIC;
    s_axi_slv0_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_slv0_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_slv0_WVALID : IN STD_LOGIC;
    s_axi_slv0_WREADY : OUT STD_LOGIC;
    s_axi_slv0_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_slv0_BVALID : OUT STD_LOGIC;
    s_axi_slv0_BREADY : IN STD_LOGIC;
    s_axi_slv0_ARADDR : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    s_axi_slv0_ARVALID : IN STD_LOGIC;
    s_axi_slv0_ARREADY : OUT STD_LOGIC;
    s_axi_slv0_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_slv0_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_slv0_RVALID : OUT STD_LOGIC;
    s_axi_slv0_RREADY : IN STD_LOGIC;
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC
  );
END design_1_cnn_0_0;

ARCHITECTURE design_1_cnn_0_0_arch OF design_1_cnn_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_cnn_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT cnn_top IS
    GENERIC (
      C_S_AXI_SLV0_ADDR_WIDTH : INTEGER;
      C_S_AXI_SLV0_DATA_WIDTH : INTEGER
    );
    PORT (
      M_AXIS_DATA_TVALID : OUT STD_LOGIC;
      M_AXIS_DATA_TREADY : IN STD_LOGIC;
      M_AXIS_DATA_TDATA : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      M_AXIS_DATA_TLAST : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      M_AXIS_DATA_TKEEP : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      S_AXIS_DATA_TVALID : IN STD_LOGIC;
      S_AXIS_DATA_TREADY : OUT STD_LOGIC;
      S_AXIS_DATA_TDATA : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      S_AXIS_DATA_TLAST : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      S_AXIS_DATA_TKEEP : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axi_slv0_AWADDR : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      s_axi_slv0_AWVALID : IN STD_LOGIC;
      s_axi_slv0_AWREADY : OUT STD_LOGIC;
      s_axi_slv0_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_slv0_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_slv0_WVALID : IN STD_LOGIC;
      s_axi_slv0_WREADY : OUT STD_LOGIC;
      s_axi_slv0_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_slv0_BVALID : OUT STD_LOGIC;
      s_axi_slv0_BREADY : IN STD_LOGIC;
      s_axi_slv0_ARADDR : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      s_axi_slv0_ARVALID : IN STD_LOGIC;
      s_axi_slv0_ARREADY : OUT STD_LOGIC;
      s_axi_slv0_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_slv0_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_slv0_RVALID : OUT STD_LOGIC;
      s_axi_slv0_RREADY : IN STD_LOGIC;
      aclk : IN STD_LOGIC;
      aresetn : IN STD_LOGIC
    );
  END COMPONENT cnn_top;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF design_1_cnn_0_0_arch: ARCHITECTURE IS "cnn_top,Vivado 2019.1";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF design_1_cnn_0_0_arch : ARCHITECTURE IS "design_1_cnn_0_0,cnn_top,{}";
  ATTRIBUTE CORE_GENERATION_INFO : STRING;
  ATTRIBUTE CORE_GENERATION_INFO OF design_1_cnn_0_0_arch: ARCHITECTURE IS "design_1_cnn_0_0,cnn_top,{x_ipProduct=Vivado 2019.1,x_ipVendor=xilinx.com,x_ipLibrary=hls,x_ipName=cnn,x_ipVersion=1.0,x_ipCoreRevision=1909241116,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_S_AXI_SLV0_ADDR_WIDTH=7,C_S_AXI_SLV0_DATA_WIDTH=32}";
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF design_1_cnn_0_0_arch: ARCHITECTURE IS "HLS";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF aresetn: SIGNAL IS "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 aresetn RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF aclk: SIGNAL IS "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF M_AXIS_DATA:S_AXIS_DATA:S_AXI_SLV0, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_RREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_RVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_RRESP: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_RDATA: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_ARREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_ARVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_ARADDR: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_BREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_BVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_BRESP: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_WREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_WVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_WSTRB: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_WDATA: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_AWREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_AWVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 AWVALID";
  ATTRIBUTE X_INTERFACE_PARAMETER OF s_axi_slv0_AWADDR: SIGNAL IS "XIL_INTERFACENAME S_AXI_SLV0, ADDR_WIDTH 7, DATA_WIDTH 32, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, NUM_READ_THREADS" & 
" 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_slv0_AWADDR: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI_SLV0 AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXIS_DATA_TKEEP: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS_DATA TKEEP";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXIS_DATA_TLAST: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS_DATA TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXIS_DATA_TDATA: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS_DATA TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXIS_DATA_TREADY: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS_DATA TREADY";
  ATTRIBUTE X_INTERFACE_PARAMETER OF S_AXIS_DATA_TVALID: SIGNAL IS "XIL_INTERFACENAME S_AXIS_DATA, TDATA_NUM_BYTES 8, TUSER_WIDTH 0, LAYERED_METADATA undef, TDEST_WIDTH 0, TID_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXIS_DATA_TVALID: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS_DATA TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_DATA_TKEEP: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS_DATA TKEEP";
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_DATA_TLAST: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS_DATA TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_DATA_TDATA: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS_DATA TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_DATA_TREADY: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS_DATA TREADY";
  ATTRIBUTE X_INTERFACE_PARAMETER OF M_AXIS_DATA_TVALID: SIGNAL IS "XIL_INTERFACENAME M_AXIS_DATA, TDATA_NUM_BYTES 8, TUSER_WIDTH 0, TDEST_WIDTH 0, TID_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF M_AXIS_DATA_TVALID: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS_DATA TVALID";
BEGIN
  U0 : cnn_top
    GENERIC MAP (
      C_S_AXI_SLV0_ADDR_WIDTH => 7,
      C_S_AXI_SLV0_DATA_WIDTH => 32
    )
    PORT MAP (
      M_AXIS_DATA_TVALID => M_AXIS_DATA_TVALID,
      M_AXIS_DATA_TREADY => M_AXIS_DATA_TREADY,
      M_AXIS_DATA_TDATA => M_AXIS_DATA_TDATA,
      M_AXIS_DATA_TLAST => M_AXIS_DATA_TLAST,
      M_AXIS_DATA_TKEEP => M_AXIS_DATA_TKEEP,
      S_AXIS_DATA_TVALID => S_AXIS_DATA_TVALID,
      S_AXIS_DATA_TREADY => S_AXIS_DATA_TREADY,
      S_AXIS_DATA_TDATA => S_AXIS_DATA_TDATA,
      S_AXIS_DATA_TLAST => S_AXIS_DATA_TLAST,
      S_AXIS_DATA_TKEEP => S_AXIS_DATA_TKEEP,
      s_axi_slv0_AWADDR => s_axi_slv0_AWADDR,
      s_axi_slv0_AWVALID => s_axi_slv0_AWVALID,
      s_axi_slv0_AWREADY => s_axi_slv0_AWREADY,
      s_axi_slv0_WDATA => s_axi_slv0_WDATA,
      s_axi_slv0_WSTRB => s_axi_slv0_WSTRB,
      s_axi_slv0_WVALID => s_axi_slv0_WVALID,
      s_axi_slv0_WREADY => s_axi_slv0_WREADY,
      s_axi_slv0_BRESP => s_axi_slv0_BRESP,
      s_axi_slv0_BVALID => s_axi_slv0_BVALID,
      s_axi_slv0_BREADY => s_axi_slv0_BREADY,
      s_axi_slv0_ARADDR => s_axi_slv0_ARADDR,
      s_axi_slv0_ARVALID => s_axi_slv0_ARVALID,
      s_axi_slv0_ARREADY => s_axi_slv0_ARREADY,
      s_axi_slv0_RDATA => s_axi_slv0_RDATA,
      s_axi_slv0_RRESP => s_axi_slv0_RRESP,
      s_axi_slv0_RVALID => s_axi_slv0_RVALID,
      s_axi_slv0_RREADY => s_axi_slv0_RREADY,
      aclk => aclk,
      aresetn => aresetn
    );
END design_1_cnn_0_0_arch;
