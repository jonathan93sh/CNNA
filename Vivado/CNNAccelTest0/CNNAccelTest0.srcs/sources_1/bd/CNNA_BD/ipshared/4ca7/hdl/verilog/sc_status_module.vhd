-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2019.1
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sc_status_module is
port (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    status_add : IN STD_LOGIC_VECTOR (31 downto 0);
    status_val : OUT STD_LOGIC_VECTOR (31 downto 0);
    egress_out_0 : OUT STD_LOGIC_VECTOR (7 downto 0);
    egress_out_1 : OUT STD_LOGIC_VECTOR (7 downto 0);
    egress_out_2 : OUT STD_LOGIC_VECTOR (31 downto 0);
    egress_in : IN STD_LOGIC_VECTOR (31 downto 0) );
end;


architecture behav of sc_status_module is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "sc_status_module,hls_ip_2019_1,{HLS_INPUT_TYPE=sc,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xczu3eg-sbva484-1-e,HLS_INPUT_CLOCK=5.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=0.000000,HLS_SYN_LAT=1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=0,HLS_SYN_LUT=0,HLS_VERSION=2019_1}";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_boolean_1 : BOOLEAN := true;

    signal sc_status_module_1_load_fu_110_p1 : STD_LOGIC_VECTOR (0 downto 0);
    signal call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_0 : STD_LOGIC_VECTOR (7 downto 0);
    signal call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_0_ap_vld : STD_LOGIC;
    signal call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_1 : STD_LOGIC_VECTOR (7 downto 0);
    signal call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_1_ap_vld : STD_LOGIC;
    signal call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_2 : STD_LOGIC_VECTOR (31 downto 0);
    signal call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_2_ap_vld : STD_LOGIC;
    signal call_ln51_sc_status_module_getStatus_egress_in_fu_86_status_val : STD_LOGIC_VECTOR (31 downto 0);
    signal call_ln51_sc_status_module_getStatus_egress_in_fu_86_status_val_ap_vld : STD_LOGIC;
    signal sc_status_module_s_load_fu_106_p1 : STD_LOGIC_VECTOR (0 downto 0);

    component sc_status_module_getStatus_egress_out IS
    port (
        status_add : IN STD_LOGIC_VECTOR (31 downto 0);
        egress_out_0 : OUT STD_LOGIC_VECTOR (7 downto 0);
        egress_out_0_ap_vld : OUT STD_LOGIC;
        egress_out_1 : OUT STD_LOGIC_VECTOR (7 downto 0);
        egress_out_1_ap_vld : OUT STD_LOGIC;
        egress_out_2 : OUT STD_LOGIC_VECTOR (31 downto 0);
        egress_out_2_ap_vld : OUT STD_LOGIC );
    end component;


    component sc_status_module_getStatus_egress_in IS
    port (
        status_val : OUT STD_LOGIC_VECTOR (31 downto 0);
        status_val_ap_vld : OUT STD_LOGIC;
        egress_in : IN STD_LOGIC_VECTOR (31 downto 0) );
    end component;



begin
    call_ln48_sc_status_module_getStatus_egress_out_fu_66 : component sc_status_module_getStatus_egress_out
    port map (
        status_add => status_add,
        egress_out_0 => call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_0,
        egress_out_0_ap_vld => call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_0_ap_vld,
        egress_out_1 => call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_1,
        egress_out_1_ap_vld => call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_1_ap_vld,
        egress_out_2 => call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_2,
        egress_out_2_ap_vld => call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_2_ap_vld);

    call_ln51_sc_status_module_getStatus_egress_in_fu_86 : component sc_status_module_getStatus_egress_in
    port map (
        status_val => call_ln51_sc_status_module_getStatus_egress_in_fu_86_status_val,
        status_val_ap_vld => call_ln51_sc_status_module_getStatus_egress_in_fu_86_status_val_ap_vld,
        egress_in => egress_in);




    egress_out_0 <= call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_0;
    egress_out_1 <= call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_1;
    egress_out_2 <= call_ln48_sc_status_module_getStatus_egress_out_fu_66_egress_out_2;
    sc_status_module_1_load_fu_110_p1 <= ap_const_lv1_0;
    sc_status_module_s_load_fu_106_p1 <= ap_const_lv1_0;
    status_val <= call_ln51_sc_status_module_getStatus_egress_in_fu_86_status_val;
end behav;