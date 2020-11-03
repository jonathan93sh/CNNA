-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
-- Date        : Tue Sep 24 12:48:12 2019
-- Host        : jonathan-ThinkPad-T520 running 64-bit Ubuntu 18.04.3 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/jonathan/git/CNNAccel/src/vivado/CNNA/CNNA.srcs/sources_1/bd/design_1/ip/design_1_cnn_0_0/design_1_cnn_0_0_stub.vhdl
-- Design      : design_1_cnn_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu3eg-sbva484-1-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_cnn_0_0 is
  Port ( 
    M_AXIS_DATA_TVALID : out STD_LOGIC;
    M_AXIS_DATA_TREADY : in STD_LOGIC;
    M_AXIS_DATA_TDATA : out STD_LOGIC_VECTOR ( 63 downto 0 );
    M_AXIS_DATA_TLAST : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXIS_DATA_TKEEP : out STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXIS_DATA_TVALID : in STD_LOGIC;
    S_AXIS_DATA_TREADY : out STD_LOGIC;
    S_AXIS_DATA_TDATA : in STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXIS_DATA_TLAST : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXIS_DATA_TKEEP : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_slv0_AWADDR : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_slv0_AWVALID : in STD_LOGIC;
    s_axi_slv0_AWREADY : out STD_LOGIC;
    s_axi_slv0_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_slv0_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_slv0_WVALID : in STD_LOGIC;
    s_axi_slv0_WREADY : out STD_LOGIC;
    s_axi_slv0_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_slv0_BVALID : out STD_LOGIC;
    s_axi_slv0_BREADY : in STD_LOGIC;
    s_axi_slv0_ARADDR : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_slv0_ARVALID : in STD_LOGIC;
    s_axi_slv0_ARREADY : out STD_LOGIC;
    s_axi_slv0_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_slv0_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_slv0_RVALID : out STD_LOGIC;
    s_axi_slv0_RREADY : in STD_LOGIC;
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC
  );

end design_1_cnn_0_0;

architecture stub of design_1_cnn_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "M_AXIS_DATA_TVALID,M_AXIS_DATA_TREADY,M_AXIS_DATA_TDATA[63:0],M_AXIS_DATA_TLAST[0:0],M_AXIS_DATA_TKEEP[7:0],S_AXIS_DATA_TVALID,S_AXIS_DATA_TREADY,S_AXIS_DATA_TDATA[63:0],S_AXIS_DATA_TLAST[0:0],S_AXIS_DATA_TKEEP[7:0],s_axi_slv0_AWADDR[6:0],s_axi_slv0_AWVALID,s_axi_slv0_AWREADY,s_axi_slv0_WDATA[31:0],s_axi_slv0_WSTRB[3:0],s_axi_slv0_WVALID,s_axi_slv0_WREADY,s_axi_slv0_BRESP[1:0],s_axi_slv0_BVALID,s_axi_slv0_BREADY,s_axi_slv0_ARADDR[6:0],s_axi_slv0_ARVALID,s_axi_slv0_ARREADY,s_axi_slv0_RDATA[31:0],s_axi_slv0_RRESP[1:0],s_axi_slv0_RVALID,s_axi_slv0_RREADY,aclk,aresetn";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "cnn_top,Vivado 2019.1";
begin
end;
