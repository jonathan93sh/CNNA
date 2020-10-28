-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
-- Date        : Sat Feb 29 17:54:40 2020
-- Host        : jonathan-System-Product-Name running 64-bit Ubuntu 18.04.4 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home/jonathan/git/CNNAccel/Vivado/CNNAccelTest0/CNNAccelTest0.srcs/sources_1/bd/CNNA_BD/ip/CNNA_BD_axi_intc_0_0_1/CNNA_BD_axi_intc_0_0_sim_netlist.vhdl
-- Design      : CNNA_BD_axi_intc_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xczu3eg-sbva484-1-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity CNNA_BD_axi_intc_0_0_address_decoder is
  port (
    p_17_in : out STD_LOGIC;
    p_19_in : out STD_LOGIC;
    Bus_RNW_reg_reg_0 : out STD_LOGIC;
    s_axi_aresetn_0 : out STD_LOGIC;
    s_axi_aresetn_1 : out STD_LOGIC;
    s_axi_aresetn_2 : out STD_LOGIC;
    s_axi_aresetn_3 : out STD_LOGIC;
    s_axi_aresetn_4 : out STD_LOGIC;
    ip2bus_wrack_prev2 : out STD_LOGIC;
    Or128_vec2stdlogic : out STD_LOGIC;
    iar : out STD_LOGIC;
    iar1_out : out STD_LOGIC;
    iar3_out : out STD_LOGIC;
    iar5_out : out STD_LOGIC;
    iar6_out : out STD_LOGIC;
    is_write_reg : out STD_LOGIC;
    is_read_reg : out STD_LOGIC;
    ip2bus_rdack_prev2 : out STD_LOGIC;
    Or128_vec2stdlogic19_out : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_wdata_1_sp_1 : out STD_LOGIC;
    s_axi_wdata_0_sp_1 : out STD_LOGIC;
    \s_axi_wdata[0]_0\ : out STD_LOGIC;
    \s_axi_wdata[1]_0\ : out STD_LOGIC;
    s_axi_wdata_2_sp_1 : out STD_LOGIC;
    s_axi_wdata_3_sp_1 : out STD_LOGIC;
    s_axi_wdata_4_sp_1 : out STD_LOGIC;
    start2 : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]\ : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 4 downto 0 );
    p_0_in8_in : in STD_LOGIC;
    p_0_in6_in : in STD_LOGIC;
    p_0_in4_in : in STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]\ : in STD_LOGIC;
    ip2bus_wrack_int_d1 : in STD_LOGIC;
    s_axi_arready : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 3 downto 0 );
    ip2bus_rdack : in STD_LOGIC;
    s_axi_wready : in STD_LOGIC;
    ip2bus_wrack : in STD_LOGIC;
    ip2bus_rdack_int_d1 : in STD_LOGIC;
    \s_axi_rdata_i_reg[0]\ : in STD_LOGIC;
    \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\ : in STD_LOGIC_VECTOR ( 6 downto 0 );
    \s_axi_rdata_i_reg[0]_0\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[1]\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[1]_0\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[2]\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[4]\ : in STD_LOGIC_VECTOR ( 2 downto 0 );
    \s_axi_rdata_i_reg[2]_0\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[3]\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[4]_0\ : in STD_LOGIC;
    data3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    p_0_in_0 : in STD_LOGIC;
    mer : in STD_LOGIC;
    Bus_RNW_reg_reg_1 : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of CNNA_BD_axi_intc_0_0_address_decoder : entity is "address_decoder";
end CNNA_BD_axi_intc_0_0_address_decoder;

architecture STRUCTURE of CNNA_BD_axi_intc_0_0_address_decoder is
  signal Bus_RNW_reg_i_1_n_0 : STD_LOGIC;
  signal \^bus_rnw_reg_reg_0\ : STD_LOGIC;
  signal \GEN_BKEND_CE_REGISTERS[14].ce_out_i[14]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg_n_0_[18]\ : STD_LOGIC;
  signal \GEN_BKEND_CE_REGISTERS[9].ce_out_i[9]_i_2_n_0\ : STD_LOGIC;
  signal cs_ce_clr : STD_LOGIC;
  signal ip2bus_rdack_int_d1_i_2_n_0 : STD_LOGIC;
  signal ip2bus_wrack_int_d1_i_2_n_0 : STD_LOGIC;
  signal ip2bus_wrack_int_d1_i_3_n_0 : STD_LOGIC;
  signal ip2bus_wrack_int_d1_i_4_n_0 : STD_LOGIC;
  signal ip2bus_wrack_int_d1_i_5_n_0 : STD_LOGIC;
  signal ip2bus_wrack_int_d1_i_6_n_0 : STD_LOGIC;
  signal \^is_read_reg\ : STD_LOGIC;
  signal \^is_write_reg\ : STD_LOGIC;
  signal p_0_out : STD_LOGIC;
  signal p_10_in : STD_LOGIC;
  signal p_10_out : STD_LOGIC;
  signal p_11_in : STD_LOGIC;
  signal p_11_out : STD_LOGIC;
  signal p_12_in : STD_LOGIC;
  signal p_12_out : STD_LOGIC;
  signal p_13_in : STD_LOGIC;
  signal p_13_out : STD_LOGIC;
  signal p_14_in : STD_LOGIC;
  signal p_14_out : STD_LOGIC;
  signal p_15_in : STD_LOGIC;
  signal p_15_out : STD_LOGIC;
  signal p_16_in : STD_LOGIC;
  signal \^p_17_in\ : STD_LOGIC;
  signal p_17_out : STD_LOGIC;
  signal p_18_in : STD_LOGIC;
  signal \^p_19_in\ : STD_LOGIC;
  signal p_1_out : STD_LOGIC;
  signal p_2_in : STD_LOGIC;
  signal p_2_out : STD_LOGIC;
  signal p_3_in : STD_LOGIC;
  signal p_3_out : STD_LOGIC;
  signal p_4_in : STD_LOGIC;
  signal p_4_out : STD_LOGIC;
  signal p_5_in : STD_LOGIC;
  signal p_5_out : STD_LOGIC;
  signal p_6_in : STD_LOGIC;
  signal p_6_out : STD_LOGIC;
  signal p_7_in : STD_LOGIC;
  signal p_7_out : STD_LOGIC;
  signal p_8_in : STD_LOGIC;
  signal p_8_out : STD_LOGIC;
  signal p_9_in : STD_LOGIC;
  signal p_9_out : STD_LOGIC;
  signal pselect_hit_i_1 : STD_LOGIC;
  signal pselect_hit_i_2 : STD_LOGIC;
  signal \s_axi_rdata_i[31]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_i[31]_i_4_n_0\ : STD_LOGIC;
  signal s_axi_wdata_0_sn_1 : STD_LOGIC;
  signal s_axi_wdata_1_sn_1 : STD_LOGIC;
  signal s_axi_wdata_2_sn_1 : STD_LOGIC;
  signal s_axi_wdata_3_sn_1 : STD_LOGIC;
  signal s_axi_wdata_4_sn_1 : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of Bus_RNW_reg_i_1 : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \CIE_GEN.CIE_BIT_GEN[0].cie[0]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \CIE_GEN.CIE_BIT_GEN[1].cie[1]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \CIE_GEN.CIE_BIT_GEN[2].cie[2]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \CIE_GEN.CIE_BIT_GEN[3].cie[3]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[0].ce_out_i[0]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[10].ce_out_i[10]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[11].ce_out_i[11]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[12].ce_out_i[12]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[13].ce_out_i[13]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[14].ce_out_i[14]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[15].ce_out_i[15]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[15].ce_out_i[15]_i_2\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[16].ce_out_i[16]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[18].ce_out_i[18]_i_2\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[1].ce_out_i[1]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[2].ce_out_i[2]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[3].ce_out_i[3]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[4].ce_out_i[4]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[5].ce_out_i[5]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[6].ce_out_i[6]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[7].ce_out_i[7]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[8].ce_out_i[8]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[9].ce_out_i[9]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[9].ce_out_i[9]_i_2\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \REG_GEN[0].IAR_NORMAL_MODE_GEN.iar[0]_i_2\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \REG_GEN[1].IAR_NORMAL_MODE_GEN.iar[1]_i_2\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \REG_GEN[2].IAR_NORMAL_MODE_GEN.iar[2]_i_2\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \REG_GEN[3].IAR_NORMAL_MODE_GEN.iar[3]_i_2\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \REG_GEN[4].IAR_NORMAL_MODE_GEN.iar[4]_i_2\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of ip2bus_rdack_i_1 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of ip2bus_rdack_int_d1_i_1 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of ip2bus_rdack_int_d1_i_2 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of ip2bus_wrack_int_d1_i_2 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of ip2bus_wrack_int_d1_i_5 : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \mer_int[0]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \mer_int[1]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \s_axi_rdata_i[31]_i_4\ : label is "soft_lutpair11";
begin
  Bus_RNW_reg_reg_0 <= \^bus_rnw_reg_reg_0\;
  is_read_reg <= \^is_read_reg\;
  is_write_reg <= \^is_write_reg\;
  p_17_in <= \^p_17_in\;
  p_19_in <= \^p_19_in\;
  s_axi_wdata_0_sp_1 <= s_axi_wdata_0_sn_1;
  s_axi_wdata_1_sp_1 <= s_axi_wdata_1_sn_1;
  s_axi_wdata_2_sp_1 <= s_axi_wdata_2_sn_1;
  s_axi_wdata_3_sp_1 <= s_axi_wdata_3_sn_1;
  s_axi_wdata_4_sp_1 <= s_axi_wdata_4_sn_1;
Bus_RNW_reg_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Bus_RNW_reg_reg_1,
      I1 => start2,
      I2 => \^bus_rnw_reg_reg_0\,
      O => Bus_RNW_reg_i_1_n_0
    );
Bus_RNW_reg_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => Bus_RNW_reg_i_1_n_0,
      Q => \^bus_rnw_reg_reg_0\,
      R => '0'
    );
\CIE_GEN.CIE_BIT_GEN[0].cie[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => s_axi_wdata(0),
      I1 => p_14_in,
      I2 => \^bus_rnw_reg_reg_0\,
      O => \s_axi_wdata[0]_0\
    );
\CIE_GEN.CIE_BIT_GEN[1].cie[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => s_axi_wdata(1),
      I1 => p_14_in,
      I2 => \^bus_rnw_reg_reg_0\,
      O => \s_axi_wdata[1]_0\
    );
\CIE_GEN.CIE_BIT_GEN[2].cie[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => s_axi_wdata(2),
      I1 => p_14_in,
      I2 => \^bus_rnw_reg_reg_0\,
      O => s_axi_wdata_2_sn_1
    );
\CIE_GEN.CIE_BIT_GEN[3].cie[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => s_axi_wdata(3),
      I1 => p_14_in,
      I2 => \^bus_rnw_reg_reg_0\,
      O => s_axi_wdata_3_sn_1
    );
\CIE_GEN.CIE_BIT_GEN[4].cie[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => s_axi_wdata(4),
      I1 => p_14_in,
      I2 => \^bus_rnw_reg_reg_0\,
      O => s_axi_wdata_4_sn_1
    );
\GEN_BKEND_CE_REGISTERS[0].ce_out_i[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000002"
    )
        port map (
      I0 => pselect_hit_i_2,
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      I4 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      O => p_15_out
    );
\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_15_out,
      Q => \^p_19_in\,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[10].ce_out_i[10]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00400000"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I1 => pselect_hit_i_2,
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      I4 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      O => p_5_out
    );
\GEN_BKEND_CE_REGISTERS[10].ce_out_i_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_5_out,
      Q => p_9_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[11].ce_out_i[11]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"40000000"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I4 => pselect_hit_i_2,
      O => p_4_out
    );
\GEN_BKEND_CE_REGISTERS[11].ce_out_i_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_4_out,
      Q => p_8_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[12].ce_out_i[12]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00400000"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I1 => pselect_hit_i_2,
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      I4 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      O => p_3_out
    );
\GEN_BKEND_CE_REGISTERS[12].ce_out_i_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_3_out,
      Q => p_7_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[13].ce_out_i[13]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"08000000"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I4 => pselect_hit_i_2,
      O => p_2_out
    );
\GEN_BKEND_CE_REGISTERS[13].ce_out_i_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_2_out,
      Q => p_6_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[14].ce_out_i[14]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"40000000"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I1 => pselect_hit_i_2,
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      I4 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      O => \GEN_BKEND_CE_REGISTERS[14].ce_out_i[14]_i_1_n_0\
    );
\GEN_BKEND_CE_REGISTERS[14].ce_out_i_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => \GEN_BKEND_CE_REGISTERS[14].ce_out_i[14]_i_1_n_0\,
      Q => p_5_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[15].ce_out_i[15]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"80000000"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I1 => pselect_hit_i_2,
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      I4 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      O => p_17_out
    );
\GEN_BKEND_CE_REGISTERS[15].ce_out_i[15]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0004"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(4),
      I1 => start2,
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(6),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(5),
      O => pselect_hit_i_2
    );
\GEN_BKEND_CE_REGISTERS[15].ce_out_i_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_17_out,
      Q => p_4_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[16].ce_out_i[16]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"4"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(5),
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(6),
      O => pselect_hit_i_1
    );
\GEN_BKEND_CE_REGISTERS[16].ce_out_i_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => pselect_hit_i_1,
      Q => p_3_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[17].ce_out_i[17]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(6),
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      O => p_0_out
    );
\GEN_BKEND_CE_REGISTERS[17].ce_out_i_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_0_out,
      Q => p_2_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[18].ce_out_i[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"EF"
    )
        port map (
      I0 => \^is_write_reg\,
      I1 => \^is_read_reg\,
      I2 => s_axi_aresetn,
      O => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[18].ce_out_i[18]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"4"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(6),
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      O => p_1_out
    );
\GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_1_out,
      Q => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg_n_0_[18]\,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[1].ce_out_i[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00010000"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(4),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(6),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(5),
      I4 => \GEN_BKEND_CE_REGISTERS[9].ce_out_i[9]_i_2_n_0\,
      O => p_14_out
    );
\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_14_out,
      Q => p_18_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[2].ce_out_i[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00020000"
    )
        port map (
      I0 => pselect_hit_i_2,
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      I4 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      O => p_13_out
    );
\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_13_out,
      Q => \^p_17_in\,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[3].ce_out_i[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00080000"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I4 => pselect_hit_i_2,
      O => p_12_out
    );
\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_12_out,
      Q => p_16_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[4].ce_out_i[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00020000"
    )
        port map (
      I0 => pselect_hit_i_2,
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      I4 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      O => p_11_out
    );
\GEN_BKEND_CE_REGISTERS[4].ce_out_i_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_11_out,
      Q => p_15_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[5].ce_out_i[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00200000"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I4 => pselect_hit_i_2,
      O => p_10_out
    );
\GEN_BKEND_CE_REGISTERS[5].ce_out_i_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_10_out,
      Q => p_14_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[6].ce_out_i[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"02000000"
    )
        port map (
      I0 => pselect_hit_i_2,
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      I4 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      O => p_9_out
    );
\GEN_BKEND_CE_REGISTERS[6].ce_out_i_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_9_out,
      Q => p_13_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[7].ce_out_i[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"40000000"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I1 => pselect_hit_i_2,
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      I4 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      O => p_8_out
    );
\GEN_BKEND_CE_REGISTERS[7].ce_out_i_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_8_out,
      Q => p_12_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[8].ce_out_i[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000040"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I1 => pselect_hit_i_2,
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      I4 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      O => p_7_out
    );
\GEN_BKEND_CE_REGISTERS[8].ce_out_i_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_7_out,
      Q => p_11_in,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[9].ce_out_i[9]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000008"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[9].ce_out_i[9]_i_2_n_0\,
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(4),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(6),
      I4 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(5),
      O => p_6_out
    );
\GEN_BKEND_CE_REGISTERS[9].ce_out_i[9]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"10"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      O => \GEN_BKEND_CE_REGISTERS[9].ce_out_i[9]_i_2_n_0\
    );
\GEN_BKEND_CE_REGISTERS[9].ce_out_i_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => start2,
      D => p_6_out,
      Q => p_10_in,
      R => cs_ce_clr
    );
\REG_GEN[0].IAR_NORMAL_MODE_GEN.iar[0]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \^bus_rnw_reg_reg_0\,
      I1 => p_16_in,
      I2 => s_axi_wdata(0),
      O => iar6_out
    );
\REG_GEN[1].IAR_NORMAL_MODE_GEN.iar[1]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \^bus_rnw_reg_reg_0\,
      I1 => p_16_in,
      I2 => s_axi_wdata(1),
      O => iar5_out
    );
\REG_GEN[2].IAR_NORMAL_MODE_GEN.iar[2]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \^bus_rnw_reg_reg_0\,
      I1 => p_16_in,
      I2 => s_axi_wdata(2),
      O => iar3_out
    );
\REG_GEN[3].IAR_NORMAL_MODE_GEN.iar[3]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \^bus_rnw_reg_reg_0\,
      I1 => p_16_in,
      I2 => s_axi_wdata(3),
      O => iar1_out
    );
\REG_GEN[4].IAR_NORMAL_MODE_GEN.iar[4]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \^bus_rnw_reg_reg_0\,
      I1 => p_16_in,
      I2 => s_axi_wdata(4),
      O => iar
    );
\SIE_GEN.SIE_BIT_GEN[0].sie[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"02000000"
    )
        port map (
      I0 => s_axi_aresetn,
      I1 => \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]\,
      I2 => \^bus_rnw_reg_reg_0\,
      I3 => p_15_in,
      I4 => s_axi_wdata(0),
      O => s_axi_aresetn_0
    );
\SIE_GEN.SIE_BIT_GEN[1].sie[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"02000000"
    )
        port map (
      I0 => s_axi_aresetn,
      I1 => p_0_in8_in,
      I2 => \^bus_rnw_reg_reg_0\,
      I3 => p_15_in,
      I4 => s_axi_wdata(1),
      O => s_axi_aresetn_1
    );
\SIE_GEN.SIE_BIT_GEN[2].sie[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"02000000"
    )
        port map (
      I0 => s_axi_aresetn,
      I1 => p_0_in6_in,
      I2 => \^bus_rnw_reg_reg_0\,
      I3 => p_15_in,
      I4 => s_axi_wdata(2),
      O => s_axi_aresetn_2
    );
\SIE_GEN.SIE_BIT_GEN[3].sie[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"02000000"
    )
        port map (
      I0 => s_axi_aresetn,
      I1 => p_0_in4_in,
      I2 => \^bus_rnw_reg_reg_0\,
      I3 => p_15_in,
      I4 => s_axi_wdata(3),
      O => s_axi_aresetn_3
    );
\SIE_GEN.SIE_BIT_GEN[4].sie[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"02000000"
    )
        port map (
      I0 => s_axi_aresetn,
      I1 => \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]\,
      I2 => \^bus_rnw_reg_reg_0\,
      I3 => p_15_in,
      I4 => s_axi_wdata(4),
      O => s_axi_aresetn_4
    );
ip2bus_rdack_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000FFC8"
    )
        port map (
      I0 => p_16_in,
      I1 => \^bus_rnw_reg_reg_0\,
      I2 => ip2bus_wrack_int_d1_i_3_n_0,
      I3 => ip2bus_rdack_int_d1_i_2_n_0,
      I4 => ip2bus_rdack_int_d1,
      O => ip2bus_rdack_prev2
    );
ip2bus_rdack_int_d1_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FAEA"
    )
        port map (
      I0 => ip2bus_rdack_int_d1_i_2_n_0,
      I1 => ip2bus_wrack_int_d1_i_3_n_0,
      I2 => \^bus_rnw_reg_reg_0\,
      I3 => p_16_in,
      O => Or128_vec2stdlogic19_out
    );
ip2bus_rdack_int_d1_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CCCCCCC8"
    )
        port map (
      I0 => p_12_in,
      I1 => \^bus_rnw_reg_reg_0\,
      I2 => p_13_in,
      I3 => p_10_in,
      I4 => p_11_in,
      O => ip2bus_rdack_int_d1_i_2_n_0
    );
ip2bus_wrack_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000033333332"
    )
        port map (
      I0 => ip2bus_wrack_int_d1_i_3_n_0,
      I1 => \^bus_rnw_reg_reg_0\,
      I2 => p_12_in,
      I3 => p_16_in,
      I4 => ip2bus_wrack_int_d1_i_2_n_0,
      I5 => ip2bus_wrack_int_d1,
      O => ip2bus_wrack_prev2
    );
ip2bus_wrack_int_d1_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00FF00FE"
    )
        port map (
      I0 => ip2bus_wrack_int_d1_i_2_n_0,
      I1 => p_16_in,
      I2 => p_12_in,
      I3 => \^bus_rnw_reg_reg_0\,
      I4 => ip2bus_wrack_int_d1_i_3_n_0,
      O => Or128_vec2stdlogic
    );
ip2bus_wrack_int_d1_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => p_13_in,
      I1 => p_10_in,
      I2 => p_11_in,
      O => ip2bus_wrack_int_d1_i_2_n_0
    );
ip2bus_wrack_int_d1_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => ip2bus_wrack_int_d1_i_4_n_0,
      I1 => p_7_in,
      I2 => p_5_in,
      I3 => p_4_in,
      I4 => ip2bus_wrack_int_d1_i_5_n_0,
      I5 => ip2bus_wrack_int_d1_i_6_n_0,
      O => ip2bus_wrack_int_d1_i_3_n_0
    );
ip2bus_wrack_int_d1_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => p_9_in,
      I1 => p_6_in,
      I2 => p_15_in,
      I3 => p_14_in,
      O => ip2bus_wrack_int_d1_i_4_n_0
    );
ip2bus_wrack_int_d1_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => p_8_in,
      I1 => p_18_in,
      I2 => \^p_19_in\,
      I3 => \^p_17_in\,
      O => ip2bus_wrack_int_d1_i_5_n_0
    );
ip2bus_wrack_int_d1_i_6: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg_n_0_[18]\,
      I1 => p_2_in,
      I2 => p_3_in,
      O => ip2bus_wrack_int_d1_i_6_n_0
    );
\mer_int[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => s_axi_wdata(0),
      I1 => p_12_in,
      I2 => \^bus_rnw_reg_reg_0\,
      I3 => mer,
      O => s_axi_wdata_0_sn_1
    );
\mer_int[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF20"
    )
        port map (
      I0 => s_axi_wdata(1),
      I1 => \^bus_rnw_reg_reg_0\,
      I2 => p_12_in,
      I3 => p_0_in_0,
      O => s_axi_wdata_1_sn_1
    );
s_axi_arready_INST_0: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF00020000"
    )
        port map (
      I0 => s_axi_arready,
      I1 => Q(1),
      I2 => Q(0),
      I3 => Q(2),
      I4 => Q(3),
      I5 => ip2bus_rdack,
      O => \^is_read_reg\
    );
\s_axi_rdata_i[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF000200"
    )
        port map (
      I0 => \s_axi_rdata_i_reg[0]\,
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I3 => \s_axi_rdata_i[31]_i_2_n_0\,
      I4 => \s_axi_rdata_i_reg[0]_0\,
      O => D(0)
    );
\s_axi_rdata_i[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF000200"
    )
        port map (
      I0 => \s_axi_rdata_i_reg[1]\,
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I3 => \s_axi_rdata_i[31]_i_2_n_0\,
      I4 => \s_axi_rdata_i_reg[1]_0\,
      O => D(1)
    );
\s_axi_rdata_i[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8A88828002000200"
    )
        port map (
      I0 => \s_axi_rdata_i[31]_i_2_n_0\,
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I3 => \s_axi_rdata_i_reg[2]\,
      I4 => \s_axi_rdata_i_reg[4]\(0),
      I5 => \s_axi_rdata_i_reg[2]_0\,
      O => D(2)
    );
\s_axi_rdata_i[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0200008002000000"
    )
        port map (
      I0 => \s_axi_rdata_i[31]_i_2_n_0\,
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(1),
      I3 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I4 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I5 => data3(0),
      O => D(5)
    );
\s_axi_rdata_i[31]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0101010001000100"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(4),
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(5),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(6),
      I3 => ip2bus_rdack_int_d1_i_2_n_0,
      I4 => \s_axi_rdata_i[31]_i_4_n_0\,
      I5 => \^bus_rnw_reg_reg_0\,
      O => \s_axi_rdata_i[31]_i_2_n_0\
    );
\s_axi_rdata_i[31]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => \^p_17_in\,
      I1 => \^p_19_in\,
      I2 => p_18_in,
      O => \s_axi_rdata_i[31]_i_4_n_0\
    );
\s_axi_rdata_i[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8A88828002000200"
    )
        port map (
      I0 => \s_axi_rdata_i[31]_i_2_n_0\,
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I3 => \s_axi_rdata_i_reg[3]\,
      I4 => \s_axi_rdata_i_reg[4]\(1),
      I5 => \s_axi_rdata_i_reg[2]_0\,
      O => D(3)
    );
\s_axi_rdata_i[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8A88828002000200"
    )
        port map (
      I0 => \s_axi_rdata_i[31]_i_2_n_0\,
      I1 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0),
      I2 => \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(3),
      I3 => \s_axi_rdata_i_reg[4]_0\,
      I4 => \s_axi_rdata_i_reg[4]\(2),
      I5 => \s_axi_rdata_i_reg[2]_0\,
      O => D(4)
    );
s_axi_wready_INST_0: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF00020000"
    )
        port map (
      I0 => s_axi_wready,
      I1 => Q(1),
      I2 => Q(0),
      I3 => Q(2),
      I4 => Q(3),
      I5 => ip2bus_wrack,
      O => \^is_write_reg\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity CNNA_BD_axi_intc_0_0_intc_core is
  port (
    p_0_in : out STD_LOGIC;
    p_0_in_0 : out STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]_0\ : out STD_LOGIC;
    p_0_in8_in : out STD_LOGIC;
    p_0_in6_in : out STD_LOGIC;
    p_0_in4_in : out STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]_0\ : out STD_LOGIC;
    mer : out STD_LOGIC;
    irq : out STD_LOGIC;
    \REG_GEN[0].ier_reg[0]_0\ : out STD_LOGIC;
    \REG_GEN[1].ier_reg[1]_0\ : out STD_LOGIC;
    \REG_GEN[2].ier_reg[2]_0\ : out STD_LOGIC;
    \bus2ip_addr_i_reg[4]\ : out STD_LOGIC;
    \bus2ip_addr_i_reg[4]_0\ : out STD_LOGIC;
    data3 : out STD_LOGIC_VECTOR ( 0 to 0 );
    \IPR_GEN.ipr_reg[4]_0\ : out STD_LOGIC_VECTOR ( 4 downto 0 );
    iar6_out : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    iar5_out : in STD_LOGIC;
    iar3_out : in STD_LOGIC;
    iar1_out : in STD_LOGIC;
    iar : in STD_LOGIC;
    \mer_int_reg[1]_0\ : in STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]_1\ : in STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[1].sie_reg[1]_0\ : in STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[2].sie_reg[2]_0\ : in STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[3].sie_reg[3]_0\ : in STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]_1\ : in STD_LOGIC;
    \CIE_GEN.CIE_BIT_GEN[0].cie_reg[0]_0\ : in STD_LOGIC;
    \CIE_GEN.CIE_BIT_GEN[1].cie_reg[1]_0\ : in STD_LOGIC;
    \CIE_GEN.CIE_BIT_GEN[2].cie_reg[2]_0\ : in STD_LOGIC;
    \CIE_GEN.CIE_BIT_GEN[3].cie_reg[3]_0\ : in STD_LOGIC;
    \CIE_GEN.CIE_BIT_GEN[4].cie_reg[4]_0\ : in STD_LOGIC;
    \mer_int_reg[0]_0\ : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_wdata : in STD_LOGIC_VECTOR ( 4 downto 0 );
    Bus_RNW_reg : in STD_LOGIC;
    p_19_in : in STD_LOGIC;
    intr : in STD_LOGIC_VECTOR ( 4 downto 0 );
    p_17_in : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of CNNA_BD_axi_intc_0_0_intc_core : entity is "intc_core";
end CNNA_BD_axi_intc_0_0_intc_core;

architecture STRUCTURE of CNNA_BD_axi_intc_0_0_intc_core is
  signal \CIE_GEN.CIE_BIT_GEN[0].cie_reg_n_0_[0]\ : STD_LOGIC;
  signal \INTR_DETECT_GEN[0].LVL_DETECT_GEN.hw_intr[0]_i_1_n_0\ : STD_LOGIC;
  signal \INTR_DETECT_GEN[1].LVL_DETECT_GEN.hw_intr[1]_i_1_n_0\ : STD_LOGIC;
  signal \INTR_DETECT_GEN[2].LVL_DETECT_GEN.hw_intr[2]_i_1_n_0\ : STD_LOGIC;
  signal \INTR_DETECT_GEN[3].LVL_DETECT_GEN.hw_intr[3]_i_1_n_0\ : STD_LOGIC;
  signal \INTR_DETECT_GEN[4].LVL_DETECT_GEN.hw_intr[4]_i_1_n_0\ : STD_LOGIC;
  signal \IPR_GEN.ipr[0]_i_1_n_0\ : STD_LOGIC;
  signal \IPR_GEN.ipr[1]_i_1_n_0\ : STD_LOGIC;
  signal \IPR_GEN.ipr[2]_i_1_n_0\ : STD_LOGIC;
  signal \IPR_GEN.ipr[3]_i_1_n_0\ : STD_LOGIC;
  signal \IPR_GEN.ipr[4]_i_1_n_0\ : STD_LOGIC;
  signal \IRQ_LEVEL_GEN.IRQ_LEVEL_NORMAL_ON_AXI_CLK_GEN.Irq_i_1_n_0\ : STD_LOGIC;
  signal \IVR_GEN.ivr[0]_i_2_n_0\ : STD_LOGIC;
  signal \IVR_GEN.ivr[0]_i_3_n_0\ : STD_LOGIC;
  signal \IVR_GEN.ivr[1]_i_2_n_0\ : STD_LOGIC;
  signal \IVR_GEN.ivr[2]_i_1_n_0\ : STD_LOGIC;
  signal \IVR_GEN.ivr_reg_n_0_[0]\ : STD_LOGIC;
  signal \IVR_GEN.ivr_reg_n_0_[1]\ : STD_LOGIC;
  signal \IVR_GEN.ivr_reg_n_0_[2]\ : STD_LOGIC;
  signal \REG_GEN[0].IAR_NORMAL_MODE_GEN.iar_reg_n_0_[0]\ : STD_LOGIC;
  signal \REG_GEN[0].ier[0]_i_2_n_0\ : STD_LOGIC;
  signal \REG_GEN[0].ier_reg_n_0_[0]\ : STD_LOGIC;
  signal \REG_GEN[0].isr[0]_i_1_n_0\ : STD_LOGIC;
  signal \REG_GEN[0].isr_reg_n_0_[0]\ : STD_LOGIC;
  signal \REG_GEN[1].ier[1]_i_2_n_0\ : STD_LOGIC;
  signal \REG_GEN[1].isr[1]_i_1_n_0\ : STD_LOGIC;
  signal \REG_GEN[2].ier[2]_i_2_n_0\ : STD_LOGIC;
  signal \REG_GEN[2].isr[2]_i_1_n_0\ : STD_LOGIC;
  signal \REG_GEN[3].IAR_NORMAL_MODE_GEN.iar_reg_n_0_[3]\ : STD_LOGIC;
  signal \REG_GEN[3].ier[3]_i_2_n_0\ : STD_LOGIC;
  signal \REG_GEN[3].isr[3]_i_1_n_0\ : STD_LOGIC;
  signal \REG_GEN[4].IAR_NORMAL_MODE_GEN.iar_reg_n_0_[4]\ : STD_LOGIC;
  signal \REG_GEN[4].ier[4]_i_2_n_0\ : STD_LOGIC;
  signal \REG_GEN[4].isr[4]_i_1_n_0\ : STD_LOGIC;
  signal \^sie_gen.sie_bit_gen[0].sie_reg[0]_0\ : STD_LOGIC;
  signal \^sie_gen.sie_bit_gen[4].sie_reg[4]_0\ : STD_LOGIC;
  signal hw_intr : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal \^irq\ : STD_LOGIC;
  signal irq_gen : STD_LOGIC;
  signal irq_gen_i_1_n_0 : STD_LOGIC;
  signal ivr_in : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^mer\ : STD_LOGIC;
  signal \^p_0_in\ : STD_LOGIC;
  signal p_0_in11_in : STD_LOGIC;
  signal p_0_in13_in : STD_LOGIC;
  signal p_0_in15_in : STD_LOGIC;
  signal p_0_in17_in : STD_LOGIC;
  signal p_0_in21_in : STD_LOGIC;
  signal p_0_in23_in : STD_LOGIC;
  signal p_0_in25_in : STD_LOGIC;
  signal p_0_in27_in : STD_LOGIC;
  signal \^p_0_in4_in\ : STD_LOGIC;
  signal \^p_0_in6_in\ : STD_LOGIC;
  signal p_0_in7_in : STD_LOGIC;
  signal \^p_0_in8_in\ : STD_LOGIC;
  signal p_0_in9_in : STD_LOGIC;
  signal \^p_0_in_0\ : STD_LOGIC;
  signal p_12_out : STD_LOGIC;
  signal p_14_out : STD_LOGIC;
  signal p_16_out : STD_LOGIC;
  signal p_18_out : STD_LOGIC;
  signal p_1_in10_in : STD_LOGIC;
  signal p_1_in12_in : STD_LOGIC;
  signal p_1_in14_in : STD_LOGIC;
  signal p_1_in8_in : STD_LOGIC;
  signal p_20_out : STD_LOGIC;
  signal p_22_out : STD_LOGIC;
  signal p_24_out : STD_LOGIC;
  signal p_25_in : STD_LOGIC;
  signal p_26_out : STD_LOGIC;
  signal p_28_out : STD_LOGIC;
  signal p_30_out : STD_LOGIC;
  signal \s_axi_rdata_i[4]_i_4_n_0\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \IPR_GEN.ipr[0]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \IPR_GEN.ipr[1]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \IPR_GEN.ipr[2]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \IPR_GEN.ipr[3]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \IPR_GEN.ipr[4]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \IVR_GEN.ivr[0]_i_2\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \IVR_GEN.ivr[0]_i_3\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \IVR_GEN.ivr[2]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of irq_gen_i_1 : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \s_axi_rdata_i[0]_i_2\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \s_axi_rdata_i[1]_i_2\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \s_axi_rdata_i[2]_i_2\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \s_axi_rdata_i[31]_i_3\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \s_axi_rdata_i[3]_i_2\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \s_axi_rdata_i[4]_i_2\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \s_axi_rdata_i[4]_i_4\ : label is "soft_lutpair31";
begin
  \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]_0\ <= \^sie_gen.sie_bit_gen[0].sie_reg[0]_0\;
  \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]_0\ <= \^sie_gen.sie_bit_gen[4].sie_reg[4]_0\;
  irq <= \^irq\;
  mer <= \^mer\;
  p_0_in <= \^p_0_in\;
  p_0_in4_in <= \^p_0_in4_in\;
  p_0_in6_in <= \^p_0_in6_in\;
  p_0_in8_in <= \^p_0_in8_in\;
  p_0_in_0 <= \^p_0_in_0\;
\CIE_GEN.CIE_BIT_GEN[0].cie_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \CIE_GEN.CIE_BIT_GEN[0].cie_reg[0]_0\,
      Q => \CIE_GEN.CIE_BIT_GEN[0].cie_reg_n_0_[0]\,
      R => p_30_out
    );
\CIE_GEN.CIE_BIT_GEN[1].cie_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \CIE_GEN.CIE_BIT_GEN[1].cie_reg[1]_0\,
      Q => p_0_in27_in,
      R => p_28_out
    );
\CIE_GEN.CIE_BIT_GEN[2].cie_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \CIE_GEN.CIE_BIT_GEN[2].cie_reg[2]_0\,
      Q => p_0_in25_in,
      R => p_26_out
    );
\CIE_GEN.CIE_BIT_GEN[3].cie_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \CIE_GEN.CIE_BIT_GEN[3].cie_reg[3]_0\,
      Q => p_0_in23_in,
      R => p_24_out
    );
\CIE_GEN.CIE_BIT_GEN[4].cie_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \CIE_GEN.CIE_BIT_GEN[4].cie_reg[4]_0\,
      Q => p_0_in21_in,
      R => p_22_out
    );
\INTR_DETECT_GEN[0].LVL_DETECT_GEN.hw_intr[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => intr(0),
      I1 => hw_intr(0),
      O => \INTR_DETECT_GEN[0].LVL_DETECT_GEN.hw_intr[0]_i_1_n_0\
    );
\INTR_DETECT_GEN[0].LVL_DETECT_GEN.hw_intr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \INTR_DETECT_GEN[0].LVL_DETECT_GEN.hw_intr[0]_i_1_n_0\,
      Q => hw_intr(0),
      R => p_20_out
    );
\INTR_DETECT_GEN[1].LVL_DETECT_GEN.hw_intr[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => intr(1),
      I1 => hw_intr(1),
      O => \INTR_DETECT_GEN[1].LVL_DETECT_GEN.hw_intr[1]_i_1_n_0\
    );
\INTR_DETECT_GEN[1].LVL_DETECT_GEN.hw_intr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \INTR_DETECT_GEN[1].LVL_DETECT_GEN.hw_intr[1]_i_1_n_0\,
      Q => hw_intr(1),
      R => p_18_out
    );
\INTR_DETECT_GEN[2].LVL_DETECT_GEN.hw_intr[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => intr(2),
      I1 => hw_intr(2),
      O => \INTR_DETECT_GEN[2].LVL_DETECT_GEN.hw_intr[2]_i_1_n_0\
    );
\INTR_DETECT_GEN[2].LVL_DETECT_GEN.hw_intr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \INTR_DETECT_GEN[2].LVL_DETECT_GEN.hw_intr[2]_i_1_n_0\,
      Q => hw_intr(2),
      R => p_16_out
    );
\INTR_DETECT_GEN[3].LVL_DETECT_GEN.hw_intr[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => intr(3),
      I1 => hw_intr(3),
      O => \INTR_DETECT_GEN[3].LVL_DETECT_GEN.hw_intr[3]_i_1_n_0\
    );
\INTR_DETECT_GEN[3].LVL_DETECT_GEN.hw_intr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \INTR_DETECT_GEN[3].LVL_DETECT_GEN.hw_intr[3]_i_1_n_0\,
      Q => hw_intr(3),
      R => p_14_out
    );
\INTR_DETECT_GEN[4].LVL_DETECT_GEN.hw_intr[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => intr(4),
      I1 => hw_intr(4),
      O => \INTR_DETECT_GEN[4].LVL_DETECT_GEN.hw_intr[4]_i_1_n_0\
    );
\INTR_DETECT_GEN[4].LVL_DETECT_GEN.hw_intr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \INTR_DETECT_GEN[4].LVL_DETECT_GEN.hw_intr[4]_i_1_n_0\,
      Q => hw_intr(4),
      R => p_12_out
    );
\IPR_GEN.ipr[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \REG_GEN[0].isr_reg_n_0_[0]\,
      I1 => \REG_GEN[0].ier_reg_n_0_[0]\,
      O => \IPR_GEN.ipr[0]_i_1_n_0\
    );
\IPR_GEN.ipr[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => p_1_in14_in,
      I1 => p_0_in13_in,
      O => \IPR_GEN.ipr[1]_i_1_n_0\
    );
\IPR_GEN.ipr[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => p_1_in12_in,
      I1 => p_0_in11_in,
      O => \IPR_GEN.ipr[2]_i_1_n_0\
    );
\IPR_GEN.ipr[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => p_1_in10_in,
      I1 => p_0_in9_in,
      O => \IPR_GEN.ipr[3]_i_1_n_0\
    );
\IPR_GEN.ipr[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => p_1_in8_in,
      I1 => p_0_in7_in,
      O => \IPR_GEN.ipr[4]_i_1_n_0\
    );
\IPR_GEN.ipr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \IPR_GEN.ipr[0]_i_1_n_0\,
      Q => \IPR_GEN.ipr_reg[4]_0\(0),
      R => \^p_0_in\
    );
\IPR_GEN.ipr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \IPR_GEN.ipr[1]_i_1_n_0\,
      Q => \IPR_GEN.ipr_reg[4]_0\(1),
      R => \^p_0_in\
    );
\IPR_GEN.ipr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \IPR_GEN.ipr[2]_i_1_n_0\,
      Q => \IPR_GEN.ipr_reg[4]_0\(2),
      R => \^p_0_in\
    );
\IPR_GEN.ipr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \IPR_GEN.ipr[3]_i_1_n_0\,
      Q => \IPR_GEN.ipr_reg[4]_0\(3),
      R => \^p_0_in\
    );
\IPR_GEN.ipr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \IPR_GEN.ipr[4]_i_1_n_0\,
      Q => \IPR_GEN.ipr_reg[4]_0\(4),
      R => \^p_0_in\
    );
\IRQ_LEVEL_GEN.IRQ_LEVEL_NORMAL_ON_AXI_CLK_GEN.Irq_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8880"
    )
        port map (
      I0 => s_axi_aresetn,
      I1 => irq_gen,
      I2 => \^irq\,
      I3 => \^mer\,
      O => \IRQ_LEVEL_GEN.IRQ_LEVEL_NORMAL_ON_AXI_CLK_GEN.Irq_i_1_n_0\
    );
\IRQ_LEVEL_GEN.IRQ_LEVEL_NORMAL_ON_AXI_CLK_GEN.Irq_reg\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \IRQ_LEVEL_GEN.IRQ_LEVEL_NORMAL_ON_AXI_CLK_GEN.Irq_i_1_n_0\,
      Q => \^irq\,
      R => '0'
    );
\IVR_GEN.ivr[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF00404040"
    )
        port map (
      I0 => \IVR_GEN.ivr[0]_i_2_n_0\,
      I1 => p_1_in14_in,
      I2 => p_0_in13_in,
      I3 => \REG_GEN[0].ier_reg_n_0_[0]\,
      I4 => \REG_GEN[0].isr_reg_n_0_[0]\,
      I5 => \IVR_GEN.ivr[0]_i_3_n_0\,
      O => ivr_in(0)
    );
\IVR_GEN.ivr[0]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"2A"
    )
        port map (
      I0 => p_25_in,
      I1 => p_0_in9_in,
      I2 => p_1_in10_in,
      O => \IVR_GEN.ivr[0]_i_2_n_0\
    );
\IVR_GEN.ivr[0]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F0707070"
    )
        port map (
      I0 => p_0_in7_in,
      I1 => p_1_in8_in,
      I2 => p_25_in,
      I3 => p_0_in9_in,
      I4 => p_1_in10_in,
      O => \IVR_GEN.ivr[0]_i_3_n_0\
    );
\IVR_GEN.ivr[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"C055FF55FF55FF55"
    )
        port map (
      I0 => \IVR_GEN.ivr[1]_i_2_n_0\,
      I1 => p_1_in10_in,
      I2 => p_0_in9_in,
      I3 => p_25_in,
      I4 => p_1_in8_in,
      I5 => p_0_in7_in,
      O => ivr_in(1)
    );
\IVR_GEN.ivr[1]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => p_0_in13_in,
      I1 => p_1_in14_in,
      I2 => \REG_GEN[0].ier_reg_n_0_[0]\,
      I3 => \REG_GEN[0].isr_reg_n_0_[0]\,
      O => \IVR_GEN.ivr[1]_i_2_n_0\
    );
\IVR_GEN.ivr[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"70FF"
    )
        port map (
      I0 => p_1_in10_in,
      I1 => p_0_in9_in,
      I2 => p_25_in,
      I3 => s_axi_aresetn,
      O => \IVR_GEN.ivr[2]_i_1_n_0\
    );
\IVR_GEN.ivr_reg[0]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ivr_in(0),
      Q => \IVR_GEN.ivr_reg_n_0_[0]\,
      S => \^p_0_in\
    );
\IVR_GEN.ivr_reg[1]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ivr_in(1),
      Q => \IVR_GEN.ivr_reg_n_0_[1]\,
      S => \^p_0_in\
    );
\IVR_GEN.ivr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \IVR_GEN.ivr[2]_i_1_n_0\,
      Q => \IVR_GEN.ivr_reg_n_0_[2]\,
      R => '0'
    );
\REG_GEN[0].IAR_NORMAL_MODE_GEN.iar[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => \REG_GEN[0].IAR_NORMAL_MODE_GEN.iar_reg_n_0_[0]\,
      I1 => s_axi_aresetn,
      O => p_20_out
    );
\REG_GEN[0].IAR_NORMAL_MODE_GEN.iar_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => iar6_out,
      Q => \REG_GEN[0].IAR_NORMAL_MODE_GEN.iar_reg_n_0_[0]\,
      R => p_20_out
    );
\REG_GEN[0].ier[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => \CIE_GEN.CIE_BIT_GEN[0].cie_reg_n_0_[0]\,
      I1 => s_axi_aresetn,
      O => p_30_out
    );
\REG_GEN[0].ier[0]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFEFFF20"
    )
        port map (
      I0 => s_axi_wdata(0),
      I1 => Bus_RNW_reg,
      I2 => p_17_in,
      I3 => \^sie_gen.sie_bit_gen[0].sie_reg[0]_0\,
      I4 => \REG_GEN[0].ier_reg_n_0_[0]\,
      O => \REG_GEN[0].ier[0]_i_2_n_0\
    );
\REG_GEN[0].ier_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \REG_GEN[0].ier[0]_i_2_n_0\,
      Q => \REG_GEN[0].ier_reg_n_0_[0]\,
      R => p_30_out
    );
\REG_GEN[0].isr[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAFCFFAAAA0C00"
    )
        port map (
      I0 => hw_intr(0),
      I1 => s_axi_wdata(0),
      I2 => Bus_RNW_reg,
      I3 => p_19_in,
      I4 => \^p_0_in_0\,
      I5 => \REG_GEN[0].isr_reg_n_0_[0]\,
      O => \REG_GEN[0].isr[0]_i_1_n_0\
    );
\REG_GEN[0].isr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \REG_GEN[0].isr[0]_i_1_n_0\,
      Q => \REG_GEN[0].isr_reg_n_0_[0]\,
      R => p_20_out
    );
\REG_GEN[1].IAR_NORMAL_MODE_GEN.iar[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => p_0_in17_in,
      I1 => s_axi_aresetn,
      O => p_18_out
    );
\REG_GEN[1].IAR_NORMAL_MODE_GEN.iar_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => iar5_out,
      Q => p_0_in17_in,
      R => p_18_out
    );
\REG_GEN[1].ier[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => p_0_in27_in,
      I1 => s_axi_aresetn,
      O => p_28_out
    );
\REG_GEN[1].ier[1]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFEFFF20"
    )
        port map (
      I0 => s_axi_wdata(1),
      I1 => Bus_RNW_reg,
      I2 => p_17_in,
      I3 => \^p_0_in8_in\,
      I4 => p_0_in13_in,
      O => \REG_GEN[1].ier[1]_i_2_n_0\
    );
\REG_GEN[1].ier_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \REG_GEN[1].ier[1]_i_2_n_0\,
      Q => p_0_in13_in,
      R => p_28_out
    );
\REG_GEN[1].isr[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAFCFFAAAA0C00"
    )
        port map (
      I0 => hw_intr(1),
      I1 => s_axi_wdata(1),
      I2 => Bus_RNW_reg,
      I3 => p_19_in,
      I4 => \^p_0_in_0\,
      I5 => p_1_in14_in,
      O => \REG_GEN[1].isr[1]_i_1_n_0\
    );
\REG_GEN[1].isr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \REG_GEN[1].isr[1]_i_1_n_0\,
      Q => p_1_in14_in,
      R => p_18_out
    );
\REG_GEN[2].IAR_NORMAL_MODE_GEN.iar[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => p_0_in15_in,
      I1 => s_axi_aresetn,
      O => p_16_out
    );
\REG_GEN[2].IAR_NORMAL_MODE_GEN.iar_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => iar3_out,
      Q => p_0_in15_in,
      R => p_16_out
    );
\REG_GEN[2].ier[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => p_0_in25_in,
      I1 => s_axi_aresetn,
      O => p_26_out
    );
\REG_GEN[2].ier[2]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFEFFF20"
    )
        port map (
      I0 => s_axi_wdata(2),
      I1 => Bus_RNW_reg,
      I2 => p_17_in,
      I3 => \^p_0_in6_in\,
      I4 => p_0_in11_in,
      O => \REG_GEN[2].ier[2]_i_2_n_0\
    );
\REG_GEN[2].ier_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \REG_GEN[2].ier[2]_i_2_n_0\,
      Q => p_0_in11_in,
      R => p_26_out
    );
\REG_GEN[2].isr[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAFCFFAAAA0C00"
    )
        port map (
      I0 => hw_intr(2),
      I1 => s_axi_wdata(2),
      I2 => Bus_RNW_reg,
      I3 => p_19_in,
      I4 => \^p_0_in_0\,
      I5 => p_1_in12_in,
      O => \REG_GEN[2].isr[2]_i_1_n_0\
    );
\REG_GEN[2].isr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \REG_GEN[2].isr[2]_i_1_n_0\,
      Q => p_1_in12_in,
      R => p_16_out
    );
\REG_GEN[3].IAR_NORMAL_MODE_GEN.iar[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => \REG_GEN[3].IAR_NORMAL_MODE_GEN.iar_reg_n_0_[3]\,
      I1 => s_axi_aresetn,
      O => p_14_out
    );
\REG_GEN[3].IAR_NORMAL_MODE_GEN.iar_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => iar1_out,
      Q => \REG_GEN[3].IAR_NORMAL_MODE_GEN.iar_reg_n_0_[3]\,
      R => p_14_out
    );
\REG_GEN[3].ier[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => p_0_in23_in,
      I1 => s_axi_aresetn,
      O => p_24_out
    );
\REG_GEN[3].ier[3]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFEFFF20"
    )
        port map (
      I0 => s_axi_wdata(3),
      I1 => Bus_RNW_reg,
      I2 => p_17_in,
      I3 => \^p_0_in4_in\,
      I4 => p_0_in9_in,
      O => \REG_GEN[3].ier[3]_i_2_n_0\
    );
\REG_GEN[3].ier_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \REG_GEN[3].ier[3]_i_2_n_0\,
      Q => p_0_in9_in,
      R => p_24_out
    );
\REG_GEN[3].isr[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAFCFFAAAA0C00"
    )
        port map (
      I0 => hw_intr(3),
      I1 => s_axi_wdata(3),
      I2 => Bus_RNW_reg,
      I3 => p_19_in,
      I4 => \^p_0_in_0\,
      I5 => p_1_in10_in,
      O => \REG_GEN[3].isr[3]_i_1_n_0\
    );
\REG_GEN[3].isr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \REG_GEN[3].isr[3]_i_1_n_0\,
      Q => p_1_in10_in,
      R => p_14_out
    );
\REG_GEN[4].IAR_NORMAL_MODE_GEN.iar[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => \REG_GEN[4].IAR_NORMAL_MODE_GEN.iar_reg_n_0_[4]\,
      I1 => s_axi_aresetn,
      O => p_12_out
    );
\REG_GEN[4].IAR_NORMAL_MODE_GEN.iar_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => iar,
      Q => \REG_GEN[4].IAR_NORMAL_MODE_GEN.iar_reg_n_0_[4]\,
      R => p_12_out
    );
\REG_GEN[4].ier[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => p_0_in21_in,
      I1 => s_axi_aresetn,
      O => p_22_out
    );
\REG_GEN[4].ier[4]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFEFFF20"
    )
        port map (
      I0 => s_axi_wdata(4),
      I1 => Bus_RNW_reg,
      I2 => p_17_in,
      I3 => \^sie_gen.sie_bit_gen[4].sie_reg[4]_0\,
      I4 => p_0_in7_in,
      O => \REG_GEN[4].ier[4]_i_2_n_0\
    );
\REG_GEN[4].ier_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \REG_GEN[4].ier[4]_i_2_n_0\,
      Q => p_0_in7_in,
      R => p_22_out
    );
\REG_GEN[4].isr[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAFCFFAAAA0C00"
    )
        port map (
      I0 => hw_intr(4),
      I1 => s_axi_wdata(4),
      I2 => Bus_RNW_reg,
      I3 => p_19_in,
      I4 => \^p_0_in_0\,
      I5 => p_1_in8_in,
      O => \REG_GEN[4].isr[4]_i_1_n_0\
    );
\REG_GEN[4].isr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \REG_GEN[4].isr[4]_i_1_n_0\,
      Q => p_1_in8_in,
      R => p_12_out
    );
\SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]_1\,
      Q => \^sie_gen.sie_bit_gen[0].sie_reg[0]_0\,
      R => '0'
    );
\SIE_GEN.SIE_BIT_GEN[1].sie_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \SIE_GEN.SIE_BIT_GEN[1].sie_reg[1]_0\,
      Q => \^p_0_in8_in\,
      R => '0'
    );
\SIE_GEN.SIE_BIT_GEN[2].sie_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \SIE_GEN.SIE_BIT_GEN[2].sie_reg[2]_0\,
      Q => \^p_0_in6_in\,
      R => '0'
    );
\SIE_GEN.SIE_BIT_GEN[3].sie_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \SIE_GEN.SIE_BIT_GEN[3].sie_reg[3]_0\,
      Q => \^p_0_in4_in\,
      R => '0'
    );
\SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]_1\,
      Q => \^sie_gen.sie_bit_gen[4].sie_reg[4]_0\,
      R => '0'
    );
irq_gen_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F888FFFF"
    )
        port map (
      I0 => p_1_in10_in,
      I1 => p_0_in9_in,
      I2 => p_1_in8_in,
      I3 => p_0_in7_in,
      I4 => p_25_in,
      O => irq_gen_i_1_n_0
    );
irq_gen_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000077707770777"
    )
        port map (
      I0 => p_0_in11_in,
      I1 => p_1_in12_in,
      I2 => \REG_GEN[0].isr_reg_n_0_[0]\,
      I3 => \REG_GEN[0].ier_reg_n_0_[0]\,
      I4 => p_1_in14_in,
      I5 => p_0_in13_in,
      O => p_25_in
    );
irq_gen_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => irq_gen_i_1_n_0,
      Q => irq_gen,
      R => \^p_0_in\
    );
\mer_int_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \mer_int_reg[0]_0\,
      Q => \^mer\,
      R => \^p_0_in\
    );
\mer_int_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \mer_int_reg[1]_0\,
      Q => \^p_0_in_0\,
      R => \^p_0_in\
    );
rst_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s_axi_aresetn,
      O => \^p_0_in\
    );
\s_axi_rdata_i[0]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F000AACC"
    )
        port map (
      I0 => \REG_GEN[0].ier_reg_n_0_[0]\,
      I1 => \REG_GEN[0].isr_reg_n_0_[0]\,
      I2 => \IVR_GEN.ivr_reg_n_0_[0]\,
      I3 => Q(0),
      I4 => Q(1),
      O => \REG_GEN[0].ier_reg[0]_0\
    );
\s_axi_rdata_i[1]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F000AACC"
    )
        port map (
      I0 => p_0_in13_in,
      I1 => p_1_in14_in,
      I2 => \IVR_GEN.ivr_reg_n_0_[1]\,
      I3 => Q(0),
      I4 => Q(1),
      O => \REG_GEN[1].ier_reg[1]_0\
    );
\s_axi_rdata_i[2]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F000AACC"
    )
        port map (
      I0 => p_0_in11_in,
      I1 => p_1_in12_in,
      I2 => \IVR_GEN.ivr_reg_n_0_[2]\,
      I3 => Q(0),
      I4 => Q(1),
      O => \REG_GEN[2].ier_reg[2]_0\
    );
\s_axi_rdata_i[31]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \IVR_GEN.ivr_reg_n_0_[2]\,
      I1 => \IVR_GEN.ivr_reg_n_0_[1]\,
      I2 => \IVR_GEN.ivr_reg_n_0_[0]\,
      O => data3(0)
    );
\s_axi_rdata_i[3]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF5140"
    )
        port map (
      I0 => Q(1),
      I1 => Q(0),
      I2 => p_0_in9_in,
      I3 => p_1_in10_in,
      I4 => \s_axi_rdata_i[4]_i_4_n_0\,
      O => \bus2ip_addr_i_reg[4]\
    );
\s_axi_rdata_i[4]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF5140"
    )
        port map (
      I0 => Q(1),
      I1 => Q(0),
      I2 => p_0_in7_in,
      I3 => p_1_in8_in,
      I4 => \s_axi_rdata_i[4]_i_4_n_0\,
      O => \bus2ip_addr_i_reg[4]_0\
    );
\s_axi_rdata_i[4]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"80000000"
    )
        port map (
      I0 => Q(1),
      I1 => Q(0),
      I2 => \IVR_GEN.ivr_reg_n_0_[0]\,
      I3 => \IVR_GEN.ivr_reg_n_0_[1]\,
      I4 => \IVR_GEN.ivr_reg_n_0_[2]\,
      O => \s_axi_rdata_i[4]_i_4_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity CNNA_BD_axi_intc_0_0_slave_attachment is
  port (
    p_17_in : out STD_LOGIC;
    p_19_in : out STD_LOGIC;
    s_axi_rresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    Bus_RNW_reg_reg : out STD_LOGIC;
    s_axi_rvalid_i_reg_0 : out STD_LOGIC;
    s_axi_bvalid_i_reg_0 : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_aresetn_0 : out STD_LOGIC;
    s_axi_aresetn_1 : out STD_LOGIC;
    s_axi_aresetn_2 : out STD_LOGIC;
    s_axi_aresetn_3 : out STD_LOGIC;
    s_axi_aresetn_4 : out STD_LOGIC;
    ip2bus_wrack_prev2 : out STD_LOGIC;
    Or128_vec2stdlogic : out STD_LOGIC;
    iar : out STD_LOGIC;
    iar1_out : out STD_LOGIC;
    iar3_out : out STD_LOGIC;
    iar5_out : out STD_LOGIC;
    iar6_out : out STD_LOGIC;
    is_write_reg_0 : out STD_LOGIC;
    is_read_reg_0 : out STD_LOGIC;
    ip2bus_rdack_prev2 : out STD_LOGIC;
    Or128_vec2stdlogic19_out : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_wdata_1_sp_1 : out STD_LOGIC;
    s_axi_wdata_0_sp_1 : out STD_LOGIC;
    \s_axi_wdata[0]_0\ : out STD_LOGIC;
    \s_axi_wdata[1]_0\ : out STD_LOGIC;
    s_axi_wdata_2_sp_1 : out STD_LOGIC;
    s_axi_wdata_3_sp_1 : out STD_LOGIC;
    s_axi_wdata_4_sp_1 : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 5 downto 0 );
    p_0_in : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    s_axi_arvalid : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]\ : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 4 downto 0 );
    p_0_in8_in : in STD_LOGIC;
    p_0_in6_in : in STD_LOGIC;
    p_0_in4_in : in STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]\ : in STD_LOGIC;
    ip2bus_wrack_int_d1 : in STD_LOGIC;
    ip2bus_rdack : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    ip2bus_wrack : in STD_LOGIC;
    ip2bus_rdack_int_d1 : in STD_LOGIC;
    \s_axi_rdata_i_reg[0]_0\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[1]_0\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[2]_0\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[4]_0\ : in STD_LOGIC_VECTOR ( 4 downto 0 );
    \s_axi_rdata_i_reg[3]_0\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[4]_1\ : in STD_LOGIC;
    data3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    mer : in STD_LOGIC;
    p_0_in_0 : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of CNNA_BD_axi_intc_0_0_slave_attachment : entity is "slave_attachment";
end CNNA_BD_axi_intc_0_0_slave_attachment;

architecture STRUCTURE of CNNA_BD_axi_intc_0_0_slave_attachment is
  signal \FSM_onehot_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[2]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[3]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state_reg_n_0_[0]\ : STD_LOGIC;
  signal \FSM_onehot_state_reg_n_0_[3]\ : STD_LOGIC;
  signal \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal IP2Bus_Data : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^q\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal bus2ip_addr : STD_LOGIC_VECTOR ( 8 downto 2 );
  signal \bus2ip_addr_i[2]_i_1_n_0\ : STD_LOGIC;
  signal \bus2ip_addr_i[3]_i_1_n_0\ : STD_LOGIC;
  signal \bus2ip_addr_i[4]_i_1_n_0\ : STD_LOGIC;
  signal \bus2ip_addr_i[5]_i_1_n_0\ : STD_LOGIC;
  signal \bus2ip_addr_i[6]_i_1_n_0\ : STD_LOGIC;
  signal \bus2ip_addr_i[7]_i_1_n_0\ : STD_LOGIC;
  signal \bus2ip_addr_i[8]_i_1_n_0\ : STD_LOGIC;
  signal \bus2ip_addr_i[8]_i_2_n_0\ : STD_LOGIC;
  signal bus2ip_rnw_i_reg_n_0 : STD_LOGIC;
  signal clear : STD_LOGIC;
  signal ip2bus_error : STD_LOGIC;
  signal is_read : STD_LOGIC;
  signal is_read_i_1_n_0 : STD_LOGIC;
  signal \^is_read_reg_0\ : STD_LOGIC;
  signal is_read_reg_n_0 : STD_LOGIC;
  signal is_write : STD_LOGIC;
  signal \^is_write_reg_0\ : STD_LOGIC;
  signal is_write_reg_n_0 : STD_LOGIC;
  signal p_5_in : STD_LOGIC;
  signal plusOp : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal rst : STD_LOGIC;
  signal \^s_axi_bresp\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s_axi_bresp_i : STD_LOGIC;
  signal \s_axi_bresp_i[1]_i_1_n_0\ : STD_LOGIC;
  signal s_axi_bvalid_i_i_1_n_0 : STD_LOGIC;
  signal \^s_axi_bvalid_i_reg_0\ : STD_LOGIC;
  signal \s_axi_rdata_i[0]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_i[1]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_i[4]_i_3_n_0\ : STD_LOGIC;
  signal s_axi_rresp_i : STD_LOGIC;
  signal s_axi_rvalid_i_i_1_n_0 : STD_LOGIC;
  signal \^s_axi_rvalid_i_reg_0\ : STD_LOGIC;
  signal s_axi_wdata_0_sn_1 : STD_LOGIC;
  signal s_axi_wdata_1_sn_1 : STD_LOGIC;
  signal s_axi_wdata_2_sn_1 : STD_LOGIC;
  signal s_axi_wdata_3_sn_1 : STD_LOGIC;
  signal s_axi_wdata_4_sn_1 : STD_LOGIC;
  signal start2 : STD_LOGIC;
  signal state : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \state1__2\ : STD_LOGIC;
  signal \state[0]_i_1_n_0\ : STD_LOGIC;
  signal \state[1]_i_1_n_0\ : STD_LOGIC;
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[0]\ : label is "iSTATE:0010,iSTATE0:0100,iSTATE1:1000,iSTATE2:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[1]\ : label is "iSTATE:0010,iSTATE0:0100,iSTATE1:1000,iSTATE2:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[2]\ : label is "iSTATE:0010,iSTATE0:0100,iSTATE1:1000,iSTATE2:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[3]\ : label is "iSTATE:0010,iSTATE0:0100,iSTATE1:1000,iSTATE2:0001";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \INCLUDE_DPHASE_TIMER.dpto_cnt[0]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \INCLUDE_DPHASE_TIMER.dpto_cnt[1]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \INCLUDE_DPHASE_TIMER.dpto_cnt[2]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \INCLUDE_DPHASE_TIMER.dpto_cnt[3]_i_2\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \bus2ip_addr_i[2]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \bus2ip_addr_i[4]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \bus2ip_addr_i[5]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \bus2ip_addr_i[6]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \bus2ip_addr_i[7]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \bus2ip_addr_i[8]_i_2\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of is_read_i_2 : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of is_write_i_1 : label is "soft_lutpair20";
begin
  Q(1 downto 0) <= \^q\(1 downto 0);
  is_read_reg_0 <= \^is_read_reg_0\;
  is_write_reg_0 <= \^is_write_reg_0\;
  s_axi_bresp(0) <= \^s_axi_bresp\(0);
  s_axi_bvalid_i_reg_0 <= \^s_axi_bvalid_i_reg_0\;
  s_axi_rvalid_i_reg_0 <= \^s_axi_rvalid_i_reg_0\;
  s_axi_wdata_0_sp_1 <= s_axi_wdata_0_sn_1;
  s_axi_wdata_1_sp_1 <= s_axi_wdata_1_sn_1;
  s_axi_wdata_2_sp_1 <= s_axi_wdata_2_sn_1;
  s_axi_wdata_3_sp_1 <= s_axi_wdata_3_sn_1;
  s_axi_wdata_4_sp_1 <= s_axi_wdata_4_sn_1;
\FSM_onehot_state[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF007000700070"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_wvalid,
      I2 => \FSM_onehot_state_reg_n_0_[0]\,
      I3 => s_axi_arvalid,
      I4 => \state1__2\,
      I5 => \FSM_onehot_state_reg_n_0_[3]\,
      O => \FSM_onehot_state[0]_i_1_n_0\
    );
\FSM_onehot_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8F88"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \FSM_onehot_state_reg_n_0_[0]\,
      I2 => \^is_read_reg_0\,
      I3 => s_axi_rresp_i,
      O => \FSM_onehot_state[1]_i_1_n_0\
    );
\FSM_onehot_state[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"44444444F4444444"
    )
        port map (
      I0 => \^is_write_reg_0\,
      I1 => s_axi_bresp_i,
      I2 => s_axi_awvalid,
      I3 => s_axi_wvalid,
      I4 => \FSM_onehot_state_reg_n_0_[0]\,
      I5 => s_axi_arvalid,
      O => \FSM_onehot_state[2]_i_1_n_0\
    );
\FSM_onehot_state[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF222F222F222"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => \state1__2\,
      I2 => s_axi_bresp_i,
      I3 => \^is_write_reg_0\,
      I4 => \^is_read_reg_0\,
      I5 => s_axi_rresp_i,
      O => \FSM_onehot_state[3]_i_1_n_0\
    );
\FSM_onehot_state[3]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => s_axi_bready,
      I1 => \^s_axi_bvalid_i_reg_0\,
      I2 => s_axi_rready,
      I3 => \^s_axi_rvalid_i_reg_0\,
      O => \state1__2\
    );
\FSM_onehot_state_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_onehot_state[0]_i_1_n_0\,
      Q => \FSM_onehot_state_reg_n_0_[0]\,
      S => rst
    );
\FSM_onehot_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_onehot_state[1]_i_1_n_0\,
      Q => s_axi_rresp_i,
      R => rst
    );
\FSM_onehot_state_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_onehot_state[2]_i_1_n_0\,
      Q => s_axi_bresp_i,
      R => rst
    );
\FSM_onehot_state_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_onehot_state[3]_i_1_n_0\,
      Q => \FSM_onehot_state_reg_n_0_[3]\,
      R => rst
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(0),
      O => plusOp(0)
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(0),
      I1 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(1),
      O => plusOp(1)
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(0),
      I1 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(1),
      I2 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(2),
      O => plusOp(2)
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => state(0),
      I1 => state(1),
      O => clear
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt[3]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(1),
      I1 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(0),
      I2 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(2),
      I3 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(3),
      O => plusOp(3)
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => plusOp(0),
      Q => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(0),
      R => clear
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => plusOp(1),
      Q => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(1),
      R => clear
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => plusOp(2),
      Q => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(2),
      R => clear
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => plusOp(3),
      Q => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(3),
      R => clear
    );
I_DECODER: entity work.CNNA_BD_axi_intc_0_0_address_decoder
     port map (
      Bus_RNW_reg_reg_0 => Bus_RNW_reg_reg,
      Bus_RNW_reg_reg_1 => bus2ip_rnw_i_reg_n_0,
      D(5) => IP2Bus_Data(31),
      D(4 downto 0) => IP2Bus_Data(4 downto 0),
      \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(6 downto 3) => bus2ip_addr(8 downto 5),
      \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(2 downto 1) => \^q\(1 downto 0),
      \GEN_BKEND_CE_REGISTERS[18].ce_out_i_reg[18]_0\(0) => bus2ip_addr(2),
      Or128_vec2stdlogic => Or128_vec2stdlogic,
      Or128_vec2stdlogic19_out => Or128_vec2stdlogic19_out,
      Q(3 downto 0) => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(3 downto 0),
      \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]\ => \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]\,
      \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]\ => \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]\,
      data3(0) => data3(0),
      iar => iar,
      iar1_out => iar1_out,
      iar3_out => iar3_out,
      iar5_out => iar5_out,
      iar6_out => iar6_out,
      ip2bus_rdack => ip2bus_rdack,
      ip2bus_rdack_int_d1 => ip2bus_rdack_int_d1,
      ip2bus_rdack_prev2 => ip2bus_rdack_prev2,
      ip2bus_wrack => ip2bus_wrack,
      ip2bus_wrack_int_d1 => ip2bus_wrack_int_d1,
      ip2bus_wrack_prev2 => ip2bus_wrack_prev2,
      is_read_reg => \^is_read_reg_0\,
      is_write_reg => \^is_write_reg_0\,
      mer => mer,
      p_0_in4_in => p_0_in4_in,
      p_0_in6_in => p_0_in6_in,
      p_0_in8_in => p_0_in8_in,
      p_0_in_0 => p_0_in_0,
      p_17_in => p_17_in,
      p_19_in => p_19_in,
      s_axi_aclk => s_axi_aclk,
      s_axi_aresetn => s_axi_aresetn,
      s_axi_aresetn_0 => s_axi_aresetn_0,
      s_axi_aresetn_1 => s_axi_aresetn_1,
      s_axi_aresetn_2 => s_axi_aresetn_2,
      s_axi_aresetn_3 => s_axi_aresetn_3,
      s_axi_aresetn_4 => s_axi_aresetn_4,
      s_axi_arready => is_read_reg_n_0,
      \s_axi_rdata_i_reg[0]\ => \s_axi_rdata_i_reg[0]_0\,
      \s_axi_rdata_i_reg[0]_0\ => \s_axi_rdata_i[0]_i_3_n_0\,
      \s_axi_rdata_i_reg[1]\ => \s_axi_rdata_i_reg[1]_0\,
      \s_axi_rdata_i_reg[1]_0\ => \s_axi_rdata_i[1]_i_3_n_0\,
      \s_axi_rdata_i_reg[2]\ => \s_axi_rdata_i_reg[2]_0\,
      \s_axi_rdata_i_reg[2]_0\ => \s_axi_rdata_i[4]_i_3_n_0\,
      \s_axi_rdata_i_reg[3]\ => \s_axi_rdata_i_reg[3]_0\,
      \s_axi_rdata_i_reg[4]\(2 downto 0) => \s_axi_rdata_i_reg[4]_0\(4 downto 2),
      \s_axi_rdata_i_reg[4]_0\ => \s_axi_rdata_i_reg[4]_1\,
      s_axi_wdata(4 downto 0) => s_axi_wdata(4 downto 0),
      \s_axi_wdata[0]_0\ => \s_axi_wdata[0]_0\,
      \s_axi_wdata[1]_0\ => \s_axi_wdata[1]_0\,
      s_axi_wdata_0_sp_1 => s_axi_wdata_0_sn_1,
      s_axi_wdata_1_sp_1 => s_axi_wdata_1_sn_1,
      s_axi_wdata_2_sp_1 => s_axi_wdata_2_sn_1,
      s_axi_wdata_3_sp_1 => s_axi_wdata_3_sn_1,
      s_axi_wdata_4_sp_1 => s_axi_wdata_4_sn_1,
      s_axi_wready => is_write_reg_n_0,
      start2 => start2
    );
\bus2ip_addr_i[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_arvalid,
      I2 => s_axi_awaddr(0),
      O => \bus2ip_addr_i[2]_i_1_n_0\
    );
\bus2ip_addr_i[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_araddr(1),
      I1 => s_axi_arvalid,
      I2 => s_axi_awaddr(1),
      O => \bus2ip_addr_i[3]_i_1_n_0\
    );
\bus2ip_addr_i[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_arvalid,
      I2 => s_axi_awaddr(2),
      O => \bus2ip_addr_i[4]_i_1_n_0\
    );
\bus2ip_addr_i[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_arvalid,
      I2 => s_axi_awaddr(3),
      O => \bus2ip_addr_i[5]_i_1_n_0\
    );
\bus2ip_addr_i[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_arvalid,
      I2 => s_axi_awaddr(4),
      O => \bus2ip_addr_i[6]_i_1_n_0\
    );
\bus2ip_addr_i[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_arvalid,
      I2 => s_axi_awaddr(5),
      O => \bus2ip_addr_i[7]_i_1_n_0\
    );
\bus2ip_addr_i[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000000F8"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_wvalid,
      I2 => s_axi_arvalid,
      I3 => state(1),
      I4 => state(0),
      O => \bus2ip_addr_i[8]_i_1_n_0\
    );
\bus2ip_addr_i[8]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_araddr(6),
      I1 => s_axi_arvalid,
      I2 => s_axi_awaddr(6),
      O => \bus2ip_addr_i[8]_i_2_n_0\
    );
\bus2ip_addr_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \bus2ip_addr_i[8]_i_1_n_0\,
      D => \bus2ip_addr_i[2]_i_1_n_0\,
      Q => bus2ip_addr(2),
      R => rst
    );
\bus2ip_addr_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \bus2ip_addr_i[8]_i_1_n_0\,
      D => \bus2ip_addr_i[3]_i_1_n_0\,
      Q => \^q\(0),
      R => rst
    );
\bus2ip_addr_i_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \bus2ip_addr_i[8]_i_1_n_0\,
      D => \bus2ip_addr_i[4]_i_1_n_0\,
      Q => \^q\(1),
      R => rst
    );
\bus2ip_addr_i_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \bus2ip_addr_i[8]_i_1_n_0\,
      D => \bus2ip_addr_i[5]_i_1_n_0\,
      Q => bus2ip_addr(5),
      R => rst
    );
\bus2ip_addr_i_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \bus2ip_addr_i[8]_i_1_n_0\,
      D => \bus2ip_addr_i[6]_i_1_n_0\,
      Q => bus2ip_addr(6),
      R => rst
    );
\bus2ip_addr_i_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \bus2ip_addr_i[8]_i_1_n_0\,
      D => \bus2ip_addr_i[7]_i_1_n_0\,
      Q => bus2ip_addr(7),
      R => rst
    );
\bus2ip_addr_i_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \bus2ip_addr_i[8]_i_1_n_0\,
      D => \bus2ip_addr_i[8]_i_2_n_0\,
      Q => bus2ip_addr(8),
      R => rst
    );
bus2ip_rnw_i_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \bus2ip_addr_i[8]_i_1_n_0\,
      D => s_axi_arvalid,
      Q => bus2ip_rnw_i_reg_n_0,
      R => rst
    );
is_read_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFF8880000"
    )
        port map (
      I0 => s_axi_bready,
      I1 => \^s_axi_bvalid_i_reg_0\,
      I2 => s_axi_rready,
      I3 => \^s_axi_rvalid_i_reg_0\,
      I4 => \FSM_onehot_state_reg_n_0_[3]\,
      I5 => \FSM_onehot_state_reg_n_0_[0]\,
      O => is_read_i_1_n_0
    );
is_read_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => s_axi_arvalid,
      O => is_read
    );
is_read_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => is_read_i_1_n_0,
      D => is_read,
      Q => is_read_reg_n_0,
      R => rst
    );
is_write_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \FSM_onehot_state_reg_n_0_[0]\,
      I2 => s_axi_wvalid,
      I3 => s_axi_awvalid,
      O => is_write
    );
is_write_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => is_read_i_1_n_0,
      D => is_write,
      Q => is_write_reg_n_0,
      R => rst
    );
rst_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in,
      Q => rst,
      R => '0'
    );
\s_axi_bresp_i[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => ip2bus_error,
      I1 => s_axi_bresp_i,
      I2 => \^s_axi_bresp\(0),
      O => \s_axi_bresp_i[1]_i_1_n_0\
    );
\s_axi_bresp_i_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \s_axi_bresp_i[1]_i_1_n_0\,
      Q => \^s_axi_bresp\(0),
      R => rst
    );
s_axi_bvalid_i_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"08FF0808"
    )
        port map (
      I0 => \^is_write_reg_0\,
      I1 => state(1),
      I2 => state(0),
      I3 => s_axi_bready,
      I4 => \^s_axi_bvalid_i_reg_0\,
      O => s_axi_bvalid_i_i_1_n_0
    );
s_axi_bvalid_i_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => s_axi_bvalid_i_i_1_n_0,
      Q => \^s_axi_bvalid_i_reg_0\,
      R => rst
    );
\s_axi_rdata_i[0]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4303420200000000"
    )
        port map (
      I0 => bus2ip_addr(5),
      I1 => \^q\(1),
      I2 => \^q\(0),
      I3 => mer,
      I4 => \s_axi_rdata_i_reg[4]_0\(0),
      I5 => bus2ip_addr(2),
      O => \s_axi_rdata_i[0]_i_3_n_0\
    );
\s_axi_rdata_i[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4303420200000000"
    )
        port map (
      I0 => bus2ip_addr(5),
      I1 => \^q\(1),
      I2 => \^q\(0),
      I3 => p_0_in_0,
      I4 => \s_axi_rdata_i_reg[4]_0\(1),
      I5 => bus2ip_addr(2),
      O => \s_axi_rdata_i[1]_i_3_n_0\
    );
\s_axi_rdata_i[4]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q\(0),
      I1 => \^q\(1),
      O => \s_axi_rdata_i[4]_i_3_n_0\
    );
\s_axi_rdata_i_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i,
      D => IP2Bus_Data(0),
      Q => s_axi_rdata(0),
      R => rst
    );
\s_axi_rdata_i_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i,
      D => IP2Bus_Data(1),
      Q => s_axi_rdata(1),
      R => rst
    );
\s_axi_rdata_i_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i,
      D => IP2Bus_Data(2),
      Q => s_axi_rdata(2),
      R => rst
    );
\s_axi_rdata_i_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i,
      D => IP2Bus_Data(31),
      Q => s_axi_rdata(5),
      R => rst
    );
\s_axi_rdata_i_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i,
      D => IP2Bus_Data(3),
      Q => s_axi_rdata(3),
      R => rst
    );
\s_axi_rdata_i_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i,
      D => IP2Bus_Data(4),
      Q => s_axi_rdata(4),
      R => rst
    );
\s_axi_rresp_i[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"070F0F0F"
    )
        port map (
      I0 => s_axi_wstrb(3),
      I1 => s_axi_wstrb(0),
      I2 => bus2ip_rnw_i_reg_n_0,
      I3 => s_axi_wstrb(1),
      I4 => s_axi_wstrb(2),
      O => ip2bus_error
    );
\s_axi_rresp_i_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i,
      D => ip2bus_error,
      Q => s_axi_rresp(0),
      R => rst
    );
s_axi_rvalid_i_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"08FF0808"
    )
        port map (
      I0 => \^is_read_reg_0\,
      I1 => state(0),
      I2 => state(1),
      I3 => s_axi_rready,
      I4 => \^s_axi_rvalid_i_reg_0\,
      O => s_axi_rvalid_i_i_1_n_0
    );
s_axi_rvalid_i_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => s_axi_rvalid_i_i_1_n_0,
      Q => \^s_axi_rvalid_i_reg_0\,
      R => rst
    );
start2_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \bus2ip_addr_i[8]_i_1_n_0\,
      Q => start2,
      R => rst
    );
\state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"5F5FCFC0"
    )
        port map (
      I0 => \state1__2\,
      I1 => \^is_write_reg_0\,
      I2 => state(1),
      I3 => s_axi_arvalid,
      I4 => state(0),
      O => \state[0]_i_1_n_0\
    );
\state[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0FF400F4FFF4F0F4"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => p_5_in,
      I2 => state(1),
      I3 => state(0),
      I4 => \^is_read_reg_0\,
      I5 => \state1__2\,
      O => \state[1]_i_1_n_0\
    );
\state[1]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_wvalid,
      O => p_5_in
    );
\state_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \state[0]_i_1_n_0\,
      Q => state(0),
      R => rst
    );
\state_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \state[1]_i_1_n_0\,
      Q => state(1),
      R => rst
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity CNNA_BD_axi_intc_0_0_axi_lite_ipif is
  port (
    p_17_in : out STD_LOGIC;
    p_19_in : out STD_LOGIC;
    s_axi_rresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    Bus_RNW_reg : out STD_LOGIC;
    s_axi_rvalid_i_reg : out STD_LOGIC;
    s_axi_bvalid_i_reg : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_aresetn_0 : out STD_LOGIC;
    s_axi_aresetn_1 : out STD_LOGIC;
    s_axi_aresetn_2 : out STD_LOGIC;
    s_axi_aresetn_3 : out STD_LOGIC;
    s_axi_aresetn_4 : out STD_LOGIC;
    ip2bus_wrack_prev2 : out STD_LOGIC;
    Or128_vec2stdlogic : out STD_LOGIC;
    iar : out STD_LOGIC;
    iar1_out : out STD_LOGIC;
    iar3_out : out STD_LOGIC;
    iar5_out : out STD_LOGIC;
    iar6_out : out STD_LOGIC;
    is_write_reg : out STD_LOGIC;
    is_read_reg : out STD_LOGIC;
    ip2bus_rdack_prev2 : out STD_LOGIC;
    Or128_vec2stdlogic19_out : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_wdata_1_sp_1 : out STD_LOGIC;
    s_axi_wdata_0_sp_1 : out STD_LOGIC;
    \s_axi_wdata[0]_0\ : out STD_LOGIC;
    \s_axi_wdata[1]_0\ : out STD_LOGIC;
    s_axi_wdata_2_sp_1 : out STD_LOGIC;
    s_axi_wdata_3_sp_1 : out STD_LOGIC;
    s_axi_wdata_4_sp_1 : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 5 downto 0 );
    p_0_in : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    s_axi_arvalid : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]\ : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 4 downto 0 );
    p_0_in8_in : in STD_LOGIC;
    p_0_in6_in : in STD_LOGIC;
    p_0_in4_in : in STD_LOGIC;
    \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]\ : in STD_LOGIC;
    ip2bus_wrack_int_d1 : in STD_LOGIC;
    ip2bus_rdack : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    ip2bus_wrack : in STD_LOGIC;
    ip2bus_rdack_int_d1 : in STD_LOGIC;
    \s_axi_rdata_i_reg[0]\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[1]\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[2]\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[4]\ : in STD_LOGIC_VECTOR ( 4 downto 0 );
    \s_axi_rdata_i_reg[3]\ : in STD_LOGIC;
    \s_axi_rdata_i_reg[4]_0\ : in STD_LOGIC;
    data3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    mer : in STD_LOGIC;
    p_0_in_0 : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of CNNA_BD_axi_intc_0_0_axi_lite_ipif : entity is "axi_lite_ipif";
end CNNA_BD_axi_intc_0_0_axi_lite_ipif;

architecture STRUCTURE of CNNA_BD_axi_intc_0_0_axi_lite_ipif is
  signal s_axi_wdata_0_sn_1 : STD_LOGIC;
  signal s_axi_wdata_1_sn_1 : STD_LOGIC;
  signal s_axi_wdata_2_sn_1 : STD_LOGIC;
  signal s_axi_wdata_3_sn_1 : STD_LOGIC;
  signal s_axi_wdata_4_sn_1 : STD_LOGIC;
begin
  s_axi_wdata_0_sp_1 <= s_axi_wdata_0_sn_1;
  s_axi_wdata_1_sp_1 <= s_axi_wdata_1_sn_1;
  s_axi_wdata_2_sp_1 <= s_axi_wdata_2_sn_1;
  s_axi_wdata_3_sp_1 <= s_axi_wdata_3_sn_1;
  s_axi_wdata_4_sp_1 <= s_axi_wdata_4_sn_1;
I_SLAVE_ATTACHMENT: entity work.CNNA_BD_axi_intc_0_0_slave_attachment
     port map (
      Bus_RNW_reg_reg => Bus_RNW_reg,
      Or128_vec2stdlogic => Or128_vec2stdlogic,
      Or128_vec2stdlogic19_out => Or128_vec2stdlogic19_out,
      Q(1 downto 0) => Q(1 downto 0),
      \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]\ => \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]\,
      \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]\ => \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]\,
      data3(0) => data3(0),
      iar => iar,
      iar1_out => iar1_out,
      iar3_out => iar3_out,
      iar5_out => iar5_out,
      iar6_out => iar6_out,
      ip2bus_rdack => ip2bus_rdack,
      ip2bus_rdack_int_d1 => ip2bus_rdack_int_d1,
      ip2bus_rdack_prev2 => ip2bus_rdack_prev2,
      ip2bus_wrack => ip2bus_wrack,
      ip2bus_wrack_int_d1 => ip2bus_wrack_int_d1,
      ip2bus_wrack_prev2 => ip2bus_wrack_prev2,
      is_read_reg_0 => is_read_reg,
      is_write_reg_0 => is_write_reg,
      mer => mer,
      p_0_in => p_0_in,
      p_0_in4_in => p_0_in4_in,
      p_0_in6_in => p_0_in6_in,
      p_0_in8_in => p_0_in8_in,
      p_0_in_0 => p_0_in_0,
      p_17_in => p_17_in,
      p_19_in => p_19_in,
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(6 downto 0) => s_axi_araddr(6 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_aresetn_0 => s_axi_aresetn_0,
      s_axi_aresetn_1 => s_axi_aresetn_1,
      s_axi_aresetn_2 => s_axi_aresetn_2,
      s_axi_aresetn_3 => s_axi_aresetn_3,
      s_axi_aresetn_4 => s_axi_aresetn_4,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(6 downto 0) => s_axi_awaddr(6 downto 0),
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bready => s_axi_bready,
      s_axi_bresp(0) => s_axi_bresp(0),
      s_axi_bvalid_i_reg_0 => s_axi_bvalid_i_reg,
      s_axi_rdata(5 downto 0) => s_axi_rdata(5 downto 0),
      \s_axi_rdata_i_reg[0]_0\ => \s_axi_rdata_i_reg[0]\,
      \s_axi_rdata_i_reg[1]_0\ => \s_axi_rdata_i_reg[1]\,
      \s_axi_rdata_i_reg[2]_0\ => \s_axi_rdata_i_reg[2]\,
      \s_axi_rdata_i_reg[3]_0\ => \s_axi_rdata_i_reg[3]\,
      \s_axi_rdata_i_reg[4]_0\(4 downto 0) => \s_axi_rdata_i_reg[4]\(4 downto 0),
      \s_axi_rdata_i_reg[4]_1\ => \s_axi_rdata_i_reg[4]_0\,
      s_axi_rready => s_axi_rready,
      s_axi_rresp(0) => s_axi_rresp(0),
      s_axi_rvalid_i_reg_0 => s_axi_rvalid_i_reg,
      s_axi_wdata(4 downto 0) => s_axi_wdata(4 downto 0),
      \s_axi_wdata[0]_0\ => \s_axi_wdata[0]_0\,
      \s_axi_wdata[1]_0\ => \s_axi_wdata[1]_0\,
      s_axi_wdata_0_sp_1 => s_axi_wdata_0_sn_1,
      s_axi_wdata_1_sp_1 => s_axi_wdata_1_sn_1,
      s_axi_wdata_2_sp_1 => s_axi_wdata_2_sn_1,
      s_axi_wdata_3_sp_1 => s_axi_wdata_3_sn_1,
      s_axi_wdata_4_sp_1 => s_axi_wdata_4_sn_1,
      s_axi_wstrb(3 downto 0) => s_axi_wstrb(3 downto 0),
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity CNNA_BD_axi_intc_0_0_axi_intc is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    intr : in STD_LOGIC_VECTOR ( 4 downto 0 );
    processor_clk : in STD_LOGIC;
    processor_rst : in STD_LOGIC;
    irq : out STD_LOGIC;
    processor_ack : in STD_LOGIC_VECTOR ( 1 downto 0 );
    interrupt_address : out STD_LOGIC_VECTOR ( 31 downto 0 );
    irq_in : in STD_LOGIC;
    interrupt_address_in : in STD_LOGIC_VECTOR ( 31 downto 0 );
    processor_ack_out : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  attribute C_ADDR_WIDTH : integer;
  attribute C_ADDR_WIDTH of CNNA_BD_axi_intc_0_0_axi_intc : entity is 32;
  attribute C_ASYNC_INTR : integer;
  attribute C_ASYNC_INTR of CNNA_BD_axi_intc_0_0_axi_intc : entity is -32;
  attribute C_CASCADE_MASTER : integer;
  attribute C_CASCADE_MASTER of CNNA_BD_axi_intc_0_0_axi_intc : entity is 0;
  attribute C_DISABLE_SYNCHRONIZERS : integer;
  attribute C_DISABLE_SYNCHRONIZERS of CNNA_BD_axi_intc_0_0_axi_intc : entity is 0;
  attribute C_ENABLE_ASYNC : integer;
  attribute C_ENABLE_ASYNC of CNNA_BD_axi_intc_0_0_axi_intc : entity is 0;
  attribute C_EN_CASCADE_MODE : integer;
  attribute C_EN_CASCADE_MODE of CNNA_BD_axi_intc_0_0_axi_intc : entity is 0;
  attribute C_FAMILY : string;
  attribute C_FAMILY of CNNA_BD_axi_intc_0_0_axi_intc : entity is "zynquplus";
  attribute C_HAS_CIE : integer;
  attribute C_HAS_CIE of CNNA_BD_axi_intc_0_0_axi_intc : entity is 1;
  attribute C_HAS_FAST : integer;
  attribute C_HAS_FAST of CNNA_BD_axi_intc_0_0_axi_intc : entity is 0;
  attribute C_HAS_ILR : integer;
  attribute C_HAS_ILR of CNNA_BD_axi_intc_0_0_axi_intc : entity is 0;
  attribute C_HAS_IPR : integer;
  attribute C_HAS_IPR of CNNA_BD_axi_intc_0_0_axi_intc : entity is 1;
  attribute C_HAS_IVR : integer;
  attribute C_HAS_IVR of CNNA_BD_axi_intc_0_0_axi_intc : entity is 1;
  attribute C_HAS_SIE : integer;
  attribute C_HAS_SIE of CNNA_BD_axi_intc_0_0_axi_intc : entity is 1;
  attribute C_INSTANCE : string;
  attribute C_INSTANCE of CNNA_BD_axi_intc_0_0_axi_intc : entity is "CNNA_BD_axi_intc_0_0";
  attribute C_IRQ_ACTIVE : string;
  attribute C_IRQ_ACTIVE of CNNA_BD_axi_intc_0_0_axi_intc : entity is "1'b1";
  attribute C_IRQ_IS_LEVEL : integer;
  attribute C_IRQ_IS_LEVEL of CNNA_BD_axi_intc_0_0_axi_intc : entity is 1;
  attribute C_IVAR_RESET_VALUE : string;
  attribute C_IVAR_RESET_VALUE of CNNA_BD_axi_intc_0_0_axi_intc : entity is "64'b0000000000000000000000000000000000000000000000000000000000010000";
  attribute C_KIND_OF_EDGE : integer;
  attribute C_KIND_OF_EDGE of CNNA_BD_axi_intc_0_0_axi_intc : entity is -1;
  attribute C_KIND_OF_INTR : integer;
  attribute C_KIND_OF_INTR of CNNA_BD_axi_intc_0_0_axi_intc : entity is -32;
  attribute C_KIND_OF_LVL : integer;
  attribute C_KIND_OF_LVL of CNNA_BD_axi_intc_0_0_axi_intc : entity is -1;
  attribute C_MB_CLK_NOT_CONNECTED : integer;
  attribute C_MB_CLK_NOT_CONNECTED of CNNA_BD_axi_intc_0_0_axi_intc : entity is 1;
  attribute C_NUM_INTR_INPUTS : integer;
  attribute C_NUM_INTR_INPUTS of CNNA_BD_axi_intc_0_0_axi_intc : entity is 5;
  attribute C_NUM_SW_INTR : integer;
  attribute C_NUM_SW_INTR of CNNA_BD_axi_intc_0_0_axi_intc : entity is 0;
  attribute C_NUM_SYNC_FF : integer;
  attribute C_NUM_SYNC_FF of CNNA_BD_axi_intc_0_0_axi_intc : entity is 2;
  attribute C_S_AXI_ADDR_WIDTH : integer;
  attribute C_S_AXI_ADDR_WIDTH of CNNA_BD_axi_intc_0_0_axi_intc : entity is 9;
  attribute C_S_AXI_DATA_WIDTH : integer;
  attribute C_S_AXI_DATA_WIDTH of CNNA_BD_axi_intc_0_0_axi_intc : entity is 32;
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of CNNA_BD_axi_intc_0_0_axi_intc : entity is "axi_intc";
  attribute hdl : string;
  attribute hdl of CNNA_BD_axi_intc_0_0_axi_intc : entity is "VHDL";
  attribute imp_netlist : string;
  attribute imp_netlist of CNNA_BD_axi_intc_0_0_axi_intc : entity is "TRUE";
  attribute ip_group : string;
  attribute ip_group of CNNA_BD_axi_intc_0_0_axi_intc : entity is "LOGICORE";
  attribute iptype : string;
  attribute iptype of CNNA_BD_axi_intc_0_0_axi_intc : entity is "PERIPHERAL";
  attribute run_ngcbuild : string;
  attribute run_ngcbuild of CNNA_BD_axi_intc_0_0_axi_intc : entity is "TRUE";
  attribute style : string;
  attribute style of CNNA_BD_axi_intc_0_0_axi_intc : entity is "HDL";
end CNNA_BD_axi_intc_0_0_axi_intc;

architecture STRUCTURE of CNNA_BD_axi_intc_0_0_axi_intc is
  signal \<const0>\ : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_10 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_11 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_25 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_26 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_27 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_28 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_29 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_30 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_31 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_7 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_8 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_9 : STD_LOGIC;
  signal INTC_CORE_I_n_10 : STD_LOGIC;
  signal INTC_CORE_I_n_11 : STD_LOGIC;
  signal INTC_CORE_I_n_12 : STD_LOGIC;
  signal INTC_CORE_I_n_13 : STD_LOGIC;
  signal INTC_CORE_I_n_2 : STD_LOGIC;
  signal INTC_CORE_I_n_6 : STD_LOGIC;
  signal INTC_CORE_I_n_9 : STD_LOGIC;
  signal \I_SLAVE_ATTACHMENT/I_DECODER/Bus_RNW_reg\ : STD_LOGIC;
  signal \I_SLAVE_ATTACHMENT/I_DECODER/p_17_in\ : STD_LOGIC;
  signal \I_SLAVE_ATTACHMENT/I_DECODER/p_19_in\ : STD_LOGIC;
  signal Or128_vec2stdlogic : STD_LOGIC;
  signal Or128_vec2stdlogic19_out : STD_LOGIC;
  signal bus2ip_addr : STD_LOGIC_VECTOR ( 4 downto 3 );
  signal data3 : STD_LOGIC_VECTOR ( 31 to 31 );
  signal iar : STD_LOGIC;
  signal iar1_out : STD_LOGIC;
  signal iar3_out : STD_LOGIC;
  signal iar5_out : STD_LOGIC;
  signal iar6_out : STD_LOGIC;
  signal ip2bus_rdack : STD_LOGIC;
  signal ip2bus_rdack_int_d1 : STD_LOGIC;
  signal ip2bus_rdack_prev2 : STD_LOGIC;
  signal ip2bus_wrack : STD_LOGIC;
  signal ip2bus_wrack_int_d1 : STD_LOGIC;
  signal ip2bus_wrack_prev2 : STD_LOGIC;
  signal ipr : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal mer : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal p_0_in4_in : STD_LOGIC;
  signal p_0_in6_in : STD_LOGIC;
  signal p_0_in8_in : STD_LOGIC;
  signal p_0_in_0 : STD_LOGIC;
  signal \^s_axi_bresp\ : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \^s_axi_rdata\ : STD_LOGIC_VECTOR ( 30 downto 0 );
  signal \^s_axi_rresp\ : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \^s_axi_wready\ : STD_LOGIC;
  attribute sigis : string;
  attribute sigis of s_axi_aclk : signal is "Clk";
  attribute sigis of s_axi_aresetn : signal is "Rstn";
  attribute BUFFER_TYPE : string;
  attribute BUFFER_TYPE of intr : signal is "none";
begin
  interrupt_address(31) <= \<const0>\;
  interrupt_address(30) <= \<const0>\;
  interrupt_address(29) <= \<const0>\;
  interrupt_address(28) <= \<const0>\;
  interrupt_address(27) <= \<const0>\;
  interrupt_address(26) <= \<const0>\;
  interrupt_address(25) <= \<const0>\;
  interrupt_address(24) <= \<const0>\;
  interrupt_address(23) <= \<const0>\;
  interrupt_address(22) <= \<const0>\;
  interrupt_address(21) <= \<const0>\;
  interrupt_address(20) <= \<const0>\;
  interrupt_address(19) <= \<const0>\;
  interrupt_address(18) <= \<const0>\;
  interrupt_address(17) <= \<const0>\;
  interrupt_address(16) <= \<const0>\;
  interrupt_address(15) <= \<const0>\;
  interrupt_address(14) <= \<const0>\;
  interrupt_address(13) <= \<const0>\;
  interrupt_address(12) <= \<const0>\;
  interrupt_address(11) <= \<const0>\;
  interrupt_address(10) <= \<const0>\;
  interrupt_address(9) <= \<const0>\;
  interrupt_address(8) <= \<const0>\;
  interrupt_address(7) <= \<const0>\;
  interrupt_address(6) <= \<const0>\;
  interrupt_address(5) <= \<const0>\;
  interrupt_address(4) <= \<const0>\;
  interrupt_address(3) <= \<const0>\;
  interrupt_address(2) <= \<const0>\;
  interrupt_address(1) <= \<const0>\;
  interrupt_address(0) <= \<const0>\;
  processor_ack_out(1) <= \<const0>\;
  processor_ack_out(0) <= \<const0>\;
  s_axi_awready <= \^s_axi_wready\;
  s_axi_bresp(1) <= \^s_axi_bresp\(1);
  s_axi_bresp(0) <= \<const0>\;
  s_axi_rdata(31) <= \^s_axi_rdata\(30);
  s_axi_rdata(30) <= \^s_axi_rdata\(30);
  s_axi_rdata(29) <= \^s_axi_rdata\(30);
  s_axi_rdata(28) <= \^s_axi_rdata\(30);
  s_axi_rdata(27) <= \^s_axi_rdata\(30);
  s_axi_rdata(26) <= \^s_axi_rdata\(30);
  s_axi_rdata(25) <= \^s_axi_rdata\(30);
  s_axi_rdata(24) <= \^s_axi_rdata\(30);
  s_axi_rdata(23) <= \^s_axi_rdata\(30);
  s_axi_rdata(22) <= \^s_axi_rdata\(30);
  s_axi_rdata(21) <= \^s_axi_rdata\(30);
  s_axi_rdata(20) <= \^s_axi_rdata\(30);
  s_axi_rdata(19) <= \^s_axi_rdata\(30);
  s_axi_rdata(18) <= \^s_axi_rdata\(30);
  s_axi_rdata(17) <= \^s_axi_rdata\(30);
  s_axi_rdata(16) <= \^s_axi_rdata\(30);
  s_axi_rdata(15) <= \^s_axi_rdata\(30);
  s_axi_rdata(14) <= \^s_axi_rdata\(30);
  s_axi_rdata(13) <= \^s_axi_rdata\(30);
  s_axi_rdata(12) <= \^s_axi_rdata\(30);
  s_axi_rdata(11) <= \^s_axi_rdata\(30);
  s_axi_rdata(10) <= \^s_axi_rdata\(30);
  s_axi_rdata(9) <= \^s_axi_rdata\(30);
  s_axi_rdata(8) <= \^s_axi_rdata\(30);
  s_axi_rdata(7) <= \^s_axi_rdata\(30);
  s_axi_rdata(6) <= \^s_axi_rdata\(30);
  s_axi_rdata(5) <= \^s_axi_rdata\(30);
  s_axi_rdata(4 downto 0) <= \^s_axi_rdata\(4 downto 0);
  s_axi_rresp(1) <= \^s_axi_rresp\(1);
  s_axi_rresp(0) <= \<const0>\;
  s_axi_wready <= \^s_axi_wready\;
AXI_LITE_IPIF_I: entity work.CNNA_BD_axi_intc_0_0_axi_lite_ipif
     port map (
      Bus_RNW_reg => \I_SLAVE_ATTACHMENT/I_DECODER/Bus_RNW_reg\,
      Or128_vec2stdlogic => Or128_vec2stdlogic,
      Or128_vec2stdlogic19_out => Or128_vec2stdlogic19_out,
      Q(1 downto 0) => bus2ip_addr(4 downto 3),
      \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]\ => INTC_CORE_I_n_2,
      \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]\ => INTC_CORE_I_n_6,
      data3(0) => data3(31),
      iar => iar,
      iar1_out => iar1_out,
      iar3_out => iar3_out,
      iar5_out => iar5_out,
      iar6_out => iar6_out,
      ip2bus_rdack => ip2bus_rdack,
      ip2bus_rdack_int_d1 => ip2bus_rdack_int_d1,
      ip2bus_rdack_prev2 => ip2bus_rdack_prev2,
      ip2bus_wrack => ip2bus_wrack,
      ip2bus_wrack_int_d1 => ip2bus_wrack_int_d1,
      ip2bus_wrack_prev2 => ip2bus_wrack_prev2,
      is_read_reg => s_axi_arready,
      is_write_reg => \^s_axi_wready\,
      mer => mer,
      p_0_in => p_0_in,
      p_0_in4_in => p_0_in4_in,
      p_0_in6_in => p_0_in6_in,
      p_0_in8_in => p_0_in8_in,
      p_0_in_0 => p_0_in_0,
      p_17_in => \I_SLAVE_ATTACHMENT/I_DECODER/p_17_in\,
      p_19_in => \I_SLAVE_ATTACHMENT/I_DECODER/p_19_in\,
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(6 downto 0) => s_axi_araddr(8 downto 2),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_aresetn_0 => AXI_LITE_IPIF_I_n_7,
      s_axi_aresetn_1 => AXI_LITE_IPIF_I_n_8,
      s_axi_aresetn_2 => AXI_LITE_IPIF_I_n_9,
      s_axi_aresetn_3 => AXI_LITE_IPIF_I_n_10,
      s_axi_aresetn_4 => AXI_LITE_IPIF_I_n_11,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(6 downto 0) => s_axi_awaddr(8 downto 2),
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bready => s_axi_bready,
      s_axi_bresp(0) => \^s_axi_bresp\(1),
      s_axi_bvalid_i_reg => s_axi_bvalid,
      s_axi_rdata(5) => \^s_axi_rdata\(30),
      s_axi_rdata(4 downto 0) => \^s_axi_rdata\(4 downto 0),
      \s_axi_rdata_i_reg[0]\ => INTC_CORE_I_n_9,
      \s_axi_rdata_i_reg[1]\ => INTC_CORE_I_n_10,
      \s_axi_rdata_i_reg[2]\ => INTC_CORE_I_n_11,
      \s_axi_rdata_i_reg[3]\ => INTC_CORE_I_n_12,
      \s_axi_rdata_i_reg[4]\(4 downto 0) => ipr(4 downto 0),
      \s_axi_rdata_i_reg[4]_0\ => INTC_CORE_I_n_13,
      s_axi_rready => s_axi_rready,
      s_axi_rresp(0) => \^s_axi_rresp\(1),
      s_axi_rvalid_i_reg => s_axi_rvalid,
      s_axi_wdata(4 downto 0) => s_axi_wdata(4 downto 0),
      \s_axi_wdata[0]_0\ => AXI_LITE_IPIF_I_n_27,
      \s_axi_wdata[1]_0\ => AXI_LITE_IPIF_I_n_28,
      s_axi_wdata_0_sp_1 => AXI_LITE_IPIF_I_n_26,
      s_axi_wdata_1_sp_1 => AXI_LITE_IPIF_I_n_25,
      s_axi_wdata_2_sp_1 => AXI_LITE_IPIF_I_n_29,
      s_axi_wdata_3_sp_1 => AXI_LITE_IPIF_I_n_30,
      s_axi_wdata_4_sp_1 => AXI_LITE_IPIF_I_n_31,
      s_axi_wstrb(3 downto 0) => s_axi_wstrb(3 downto 0),
      s_axi_wvalid => s_axi_wvalid
    );
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
INTC_CORE_I: entity work.CNNA_BD_axi_intc_0_0_intc_core
     port map (
      Bus_RNW_reg => \I_SLAVE_ATTACHMENT/I_DECODER/Bus_RNW_reg\,
      \CIE_GEN.CIE_BIT_GEN[0].cie_reg[0]_0\ => AXI_LITE_IPIF_I_n_27,
      \CIE_GEN.CIE_BIT_GEN[1].cie_reg[1]_0\ => AXI_LITE_IPIF_I_n_28,
      \CIE_GEN.CIE_BIT_GEN[2].cie_reg[2]_0\ => AXI_LITE_IPIF_I_n_29,
      \CIE_GEN.CIE_BIT_GEN[3].cie_reg[3]_0\ => AXI_LITE_IPIF_I_n_30,
      \CIE_GEN.CIE_BIT_GEN[4].cie_reg[4]_0\ => AXI_LITE_IPIF_I_n_31,
      \IPR_GEN.ipr_reg[4]_0\(4 downto 0) => ipr(4 downto 0),
      Q(1 downto 0) => bus2ip_addr(4 downto 3),
      \REG_GEN[0].ier_reg[0]_0\ => INTC_CORE_I_n_9,
      \REG_GEN[1].ier_reg[1]_0\ => INTC_CORE_I_n_10,
      \REG_GEN[2].ier_reg[2]_0\ => INTC_CORE_I_n_11,
      \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]_0\ => INTC_CORE_I_n_2,
      \SIE_GEN.SIE_BIT_GEN[0].sie_reg[0]_1\ => AXI_LITE_IPIF_I_n_7,
      \SIE_GEN.SIE_BIT_GEN[1].sie_reg[1]_0\ => AXI_LITE_IPIF_I_n_8,
      \SIE_GEN.SIE_BIT_GEN[2].sie_reg[2]_0\ => AXI_LITE_IPIF_I_n_9,
      \SIE_GEN.SIE_BIT_GEN[3].sie_reg[3]_0\ => AXI_LITE_IPIF_I_n_10,
      \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]_0\ => INTC_CORE_I_n_6,
      \SIE_GEN.SIE_BIT_GEN[4].sie_reg[4]_1\ => AXI_LITE_IPIF_I_n_11,
      \bus2ip_addr_i_reg[4]\ => INTC_CORE_I_n_12,
      \bus2ip_addr_i_reg[4]_0\ => INTC_CORE_I_n_13,
      data3(0) => data3(31),
      iar => iar,
      iar1_out => iar1_out,
      iar3_out => iar3_out,
      iar5_out => iar5_out,
      iar6_out => iar6_out,
      intr(4 downto 0) => intr(4 downto 0),
      irq => irq,
      mer => mer,
      \mer_int_reg[0]_0\ => AXI_LITE_IPIF_I_n_26,
      \mer_int_reg[1]_0\ => AXI_LITE_IPIF_I_n_25,
      p_0_in => p_0_in,
      p_0_in4_in => p_0_in4_in,
      p_0_in6_in => p_0_in6_in,
      p_0_in8_in => p_0_in8_in,
      p_0_in_0 => p_0_in_0,
      p_17_in => \I_SLAVE_ATTACHMENT/I_DECODER/p_17_in\,
      p_19_in => \I_SLAVE_ATTACHMENT/I_DECODER/p_19_in\,
      s_axi_aclk => s_axi_aclk,
      s_axi_aresetn => s_axi_aresetn,
      s_axi_wdata(4 downto 0) => s_axi_wdata(4 downto 0)
    );
ip2bus_rdack_int_d1_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => Or128_vec2stdlogic19_out,
      Q => ip2bus_rdack_int_d1,
      R => p_0_in
    );
ip2bus_rdack_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_rdack_prev2,
      Q => ip2bus_rdack,
      R => p_0_in
    );
ip2bus_wrack_int_d1_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => Or128_vec2stdlogic,
      Q => ip2bus_wrack_int_d1,
      R => p_0_in
    );
ip2bus_wrack_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_wrack_prev2,
      Q => ip2bus_wrack,
      R => p_0_in
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity CNNA_BD_axi_intc_0_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    intr : in STD_LOGIC_VECTOR ( 4 downto 0 );
    irq : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of CNNA_BD_axi_intc_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of CNNA_BD_axi_intc_0_0 : entity is "CNNA_BD_axi_intc_0_0,axi_intc,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of CNNA_BD_axi_intc_0_0 : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of CNNA_BD_axi_intc_0_0 : entity is "axi_intc,Vivado 2019.1";
end CNNA_BD_axi_intc_0_0;

architecture STRUCTURE of CNNA_BD_axi_intc_0_0 is
  signal NLW_U0_interrupt_address_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_processor_ack_out_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute C_ADDR_WIDTH : integer;
  attribute C_ADDR_WIDTH of U0 : label is 32;
  attribute C_ASYNC_INTR : integer;
  attribute C_ASYNC_INTR of U0 : label is -32;
  attribute C_CASCADE_MASTER : integer;
  attribute C_CASCADE_MASTER of U0 : label is 0;
  attribute C_DISABLE_SYNCHRONIZERS : integer;
  attribute C_DISABLE_SYNCHRONIZERS of U0 : label is 0;
  attribute C_ENABLE_ASYNC : integer;
  attribute C_ENABLE_ASYNC of U0 : label is 0;
  attribute C_EN_CASCADE_MODE : integer;
  attribute C_EN_CASCADE_MODE of U0 : label is 0;
  attribute C_FAMILY : string;
  attribute C_FAMILY of U0 : label is "zynquplus";
  attribute C_HAS_CIE : integer;
  attribute C_HAS_CIE of U0 : label is 1;
  attribute C_HAS_FAST : integer;
  attribute C_HAS_FAST of U0 : label is 0;
  attribute C_HAS_ILR : integer;
  attribute C_HAS_ILR of U0 : label is 0;
  attribute C_HAS_IPR : integer;
  attribute C_HAS_IPR of U0 : label is 1;
  attribute C_HAS_IVR : integer;
  attribute C_HAS_IVR of U0 : label is 1;
  attribute C_HAS_SIE : integer;
  attribute C_HAS_SIE of U0 : label is 1;
  attribute C_INSTANCE : string;
  attribute C_INSTANCE of U0 : label is "CNNA_BD_axi_intc_0_0";
  attribute C_IRQ_ACTIVE : string;
  attribute C_IRQ_ACTIVE of U0 : label is "1'b1";
  attribute C_IRQ_IS_LEVEL : integer;
  attribute C_IRQ_IS_LEVEL of U0 : label is 1;
  attribute C_IVAR_RESET_VALUE : string;
  attribute C_IVAR_RESET_VALUE of U0 : label is "64'b0000000000000000000000000000000000000000000000000000000000010000";
  attribute C_KIND_OF_EDGE : integer;
  attribute C_KIND_OF_EDGE of U0 : label is -1;
  attribute C_KIND_OF_INTR : integer;
  attribute C_KIND_OF_INTR of U0 : label is -32;
  attribute C_KIND_OF_LVL : integer;
  attribute C_KIND_OF_LVL of U0 : label is -1;
  attribute C_MB_CLK_NOT_CONNECTED : integer;
  attribute C_MB_CLK_NOT_CONNECTED of U0 : label is 1;
  attribute C_NUM_INTR_INPUTS : integer;
  attribute C_NUM_INTR_INPUTS of U0 : label is 5;
  attribute C_NUM_SW_INTR : integer;
  attribute C_NUM_SW_INTR of U0 : label is 0;
  attribute C_NUM_SYNC_FF : integer;
  attribute C_NUM_SYNC_FF of U0 : label is 2;
  attribute C_S_AXI_ADDR_WIDTH : integer;
  attribute C_S_AXI_ADDR_WIDTH of U0 : label is 9;
  attribute C_S_AXI_DATA_WIDTH : integer;
  attribute C_S_AXI_DATA_WIDTH of U0 : label is 32;
  attribute hdl : string;
  attribute hdl of U0 : label is "VHDL";
  attribute imp_netlist : string;
  attribute imp_netlist of U0 : label is "TRUE";
  attribute ip_group : string;
  attribute ip_group of U0 : label is "LOGICORE";
  attribute iptype : string;
  attribute iptype of U0 : label is "PERIPHERAL";
  attribute run_ngcbuild : string;
  attribute run_ngcbuild of U0 : label is "TRUE";
  attribute style : string;
  attribute style of U0 : label is "HDL";
  attribute x_interface_info : string;
  attribute x_interface_info of irq : signal is "xilinx.com:interface:mbinterrupt:1.0 interrupt INTERRUPT";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of irq : signal is "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, LOW_LATENCY 0";
  attribute x_interface_info of s_axi_aclk : signal is "xilinx.com:signal:clock:1.0 s_axi_aclk CLK";
  attribute x_interface_parameter of s_axi_aclk : signal is "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF s_axi, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 177776001, PHASE 0.000, CLK_DOMAIN CNNA_BD_zynq_ultra_ps_e_0_1_pl_clk0, INSERT_VIP 0";
  attribute x_interface_info of s_axi_aresetn : signal is "xilinx.com:signal:reset:1.0 s_resetn RST";
  attribute x_interface_parameter of s_axi_aresetn : signal is "XIL_INTERFACENAME s_resetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute x_interface_info of s_axi_arready : signal is "xilinx.com:interface:aximm:1.0 s_axi ARREADY";
  attribute x_interface_info of s_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi ARVALID";
  attribute x_interface_info of s_axi_awready : signal is "xilinx.com:interface:aximm:1.0 s_axi AWREADY";
  attribute x_interface_info of s_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi AWVALID";
  attribute x_interface_info of s_axi_bready : signal is "xilinx.com:interface:aximm:1.0 s_axi BREADY";
  attribute x_interface_info of s_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi BVALID";
  attribute x_interface_info of s_axi_rready : signal is "xilinx.com:interface:aximm:1.0 s_axi RREADY";
  attribute x_interface_info of s_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi RVALID";
  attribute x_interface_info of s_axi_wready : signal is "xilinx.com:interface:aximm:1.0 s_axi WREADY";
  attribute x_interface_info of s_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi WVALID";
  attribute x_interface_info of intr : signal is "xilinx.com:signal:interrupt:1.0 interrupt_input INTERRUPT";
  attribute x_interface_parameter of intr : signal is "XIL_INTERFACENAME interrupt_input, SENSITIVITY LEVEL_HIGH:LEVEL_HIGH:LEVEL_HIGH:LEVEL_HIGH:LEVEL_HIGH, PortWidth 5";
  attribute x_interface_info of s_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 s_axi ARADDR";
  attribute x_interface_info of s_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 s_axi AWADDR";
  attribute x_interface_parameter of s_axi_awaddr : signal is "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 177776001, ID_WIDTH 0, ADDR_WIDTH 9, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN CNNA_BD_zynq_ultra_ps_e_0_1_pl_clk0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute x_interface_info of s_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 s_axi BRESP";
  attribute x_interface_info of s_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 s_axi RDATA";
  attribute x_interface_info of s_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 s_axi RRESP";
  attribute x_interface_info of s_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 s_axi WDATA";
  attribute x_interface_info of s_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 s_axi WSTRB";
begin
U0: entity work.CNNA_BD_axi_intc_0_0_axi_intc
     port map (
      interrupt_address(31 downto 0) => NLW_U0_interrupt_address_UNCONNECTED(31 downto 0),
      interrupt_address_in(31 downto 0) => B"00000000000000000000000000000000",
      intr(4 downto 0) => intr(4 downto 0),
      irq => irq,
      irq_in => '0',
      processor_ack(1 downto 0) => B"00",
      processor_ack_out(1 downto 0) => NLW_U0_processor_ack_out_UNCONNECTED(1 downto 0),
      processor_clk => '0',
      processor_rst => '0',
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(8 downto 0) => s_axi_araddr(8 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(8 downto 0) => s_axi_awaddr(8 downto 0),
      s_axi_awready => s_axi_awready,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bready => s_axi_bready,
      s_axi_bresp(1 downto 0) => s_axi_bresp(1 downto 0),
      s_axi_bvalid => s_axi_bvalid,
      s_axi_rdata(31 downto 0) => s_axi_rdata(31 downto 0),
      s_axi_rready => s_axi_rready,
      s_axi_rresp(1 downto 0) => s_axi_rresp(1 downto 0),
      s_axi_rvalid => s_axi_rvalid,
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(3 downto 0) => s_axi_wstrb(3 downto 0),
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
