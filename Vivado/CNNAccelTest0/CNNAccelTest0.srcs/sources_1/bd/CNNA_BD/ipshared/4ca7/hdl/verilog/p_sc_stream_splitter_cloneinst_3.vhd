-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2019.1
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity p_sc_stream_splitter_cloneinst_3 is
port (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    din_dout : IN STD_LOGIC_VECTOR (15 downto 0);
    din_empty_n : IN STD_LOGIC;
    din_read : OUT STD_LOGIC;
    dout_0_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    dout_0_full_n : IN STD_LOGIC;
    dout_0_write : OUT STD_LOGIC;
    dout_1_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    dout_1_full_n : IN STD_LOGIC;
    dout_1_write : OUT STD_LOGIC;
    dout_2_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    dout_2_full_n : IN STD_LOGIC;
    dout_2_write : OUT STD_LOGIC;
    dout_3_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    dout_3_full_n : IN STD_LOGIC;
    dout_3_write : OUT STD_LOGIC;
    dout_4_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    dout_4_full_n : IN STD_LOGIC;
    dout_4_write : OUT STD_LOGIC;
    dout_5_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    dout_5_full_n : IN STD_LOGIC;
    dout_5_write : OUT STD_LOGIC;
    dout_6_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    dout_6_full_n : IN STD_LOGIC;
    dout_6_write : OUT STD_LOGIC;
    dout_7_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    dout_7_full_n : IN STD_LOGIC;
    dout_7_write : OUT STD_LOGIC );
end;


architecture behav of p_sc_stream_splitter_cloneinst_3 is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "p_sc_stream_splitter_cloneinst_3,hls_ip_2019_1,{HLS_INPUT_TYPE=sc,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xczu3eg-sbva484-1-e,HLS_INPUT_CLOCK=5.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=4.334000,HLS_SYN_LAT=2,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=2,HLS_SYN_LUT=92,HLS_VERSION=2019_1}";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_boolean_1 : BOOLEAN := true;

    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_din_read : STD_LOGIC;
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_0_din : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_0_write : STD_LOGIC;
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_1_din : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_1_write : STD_LOGIC;
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_2_din : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_2_write : STD_LOGIC;
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_3_din : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_3_write : STD_LOGIC;
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_4_din : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_4_write : STD_LOGIC;
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_5_din : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_5_write : STD_LOGIC;
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_6_din : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_6_write : STD_LOGIC;
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_7_din : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_7_write : STD_LOGIC;

    component p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        din_dout : IN STD_LOGIC_VECTOR (15 downto 0);
        din_empty_n : IN STD_LOGIC;
        din_read : OUT STD_LOGIC;
        dout_0_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dout_0_full_n : IN STD_LOGIC;
        dout_0_write : OUT STD_LOGIC;
        dout_1_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dout_1_full_n : IN STD_LOGIC;
        dout_1_write : OUT STD_LOGIC;
        dout_2_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dout_2_full_n : IN STD_LOGIC;
        dout_2_write : OUT STD_LOGIC;
        dout_3_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dout_3_full_n : IN STD_LOGIC;
        dout_3_write : OUT STD_LOGIC;
        dout_4_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dout_4_full_n : IN STD_LOGIC;
        dout_4_write : OUT STD_LOGIC;
        dout_5_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dout_5_full_n : IN STD_LOGIC;
        dout_5_write : OUT STD_LOGIC;
        dout_6_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dout_6_full_n : IN STD_LOGIC;
        dout_6_write : OUT STD_LOGIC;
        dout_7_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dout_7_full_n : IN STD_LOGIC;
        dout_7_write : OUT STD_LOGIC );
    end component;



begin
    grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70 : component p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone
    port map (
        ap_clk => clk,
        ap_rst => reset,
        din_dout => din_dout,
        din_empty_n => din_empty_n,
        din_read => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_din_read,
        dout_0_din => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_0_din,
        dout_0_full_n => dout_0_full_n,
        dout_0_write => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_0_write,
        dout_1_din => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_1_din,
        dout_1_full_n => dout_1_full_n,
        dout_1_write => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_1_write,
        dout_2_din => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_2_din,
        dout_2_full_n => dout_2_full_n,
        dout_2_write => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_2_write,
        dout_3_din => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_3_din,
        dout_3_full_n => dout_3_full_n,
        dout_3_write => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_3_write,
        dout_4_din => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_4_din,
        dout_4_full_n => dout_4_full_n,
        dout_4_write => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_4_write,
        dout_5_din => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_5_din,
        dout_5_full_n => dout_5_full_n,
        dout_5_write => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_5_write,
        dout_6_din => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_6_din,
        dout_6_full_n => dout_6_full_n,
        dout_6_write => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_6_write,
        dout_7_din => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_7_din,
        dout_7_full_n => dout_7_full_n,
        dout_7_write => grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_7_write);




    din_read <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_din_read;
    dout_0_din <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_0_din;
    dout_0_write <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_0_write;
    dout_1_din <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_1_din;
    dout_1_write <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_1_write;
    dout_2_din <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_2_din;
    dout_2_write <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_2_write;
    dout_3_din <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_3_din;
    dout_3_write <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_3_write;
    dout_4_din <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_4_din;
    dout_4_write <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_4_write;
    dout_5_din <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_5_din;
    dout_5_write <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_5_write;
    dout_6_din <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_6_din;
    dout_6_write <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_6_write;
    dout_7_din <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_7_din;
    dout_7_write <= grp_p_sc_stream_splitter_cloneinst_3_thread_sc_stream_splitter_clone_fu_70_dout_7_write;
end behav;
