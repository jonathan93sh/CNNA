-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2019.1
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Summer is
port (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    din_0_dout : IN STD_LOGIC_VECTOR (31 downto 0);
    din_0_empty_n : IN STD_LOGIC;
    din_0_read : OUT STD_LOGIC;
    din_1_dout : IN STD_LOGIC_VECTOR (0 downto 0);
    din_1_empty_n : IN STD_LOGIC;
    din_1_read : OUT STD_LOGIC;
    din_2_dout : IN STD_LOGIC_VECTOR (3 downto 0);
    din_2_empty_n : IN STD_LOGIC;
    din_2_read : OUT STD_LOGIC;
    dout_0_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    dout_0_full_n : IN STD_LOGIC;
    dout_0_write : OUT STD_LOGIC;
    dout_1_din : OUT STD_LOGIC_VECTOR (0 downto 0);
    dout_1_full_n : IN STD_LOGIC;
    dout_1_write : OUT STD_LOGIC;
    dout_2_din : OUT STD_LOGIC_VECTOR (1 downto 0);
    dout_2_full_n : IN STD_LOGIC;
    dout_2_write : OUT STD_LOGIC;
    ctrl_acf_dout : IN STD_LOGIC_VECTOR (15 downto 0);
    ctrl_acf_empty_n : IN STD_LOGIC;
    ctrl_acf_read : OUT STD_LOGIC;
    count_out : OUT STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000" );
end;


architecture behav of Summer is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "Summer,hls_ip_2019_1,{HLS_INPUT_TYPE=sc,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xczu3eg-sbva484-1-e,HLS_INPUT_CLOCK=5.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=4.559750,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=2,HLS_SYN_FF=715,HLS_SYN_LUT=1033,HLS_VERSION=2019_1}";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_boolean_1 : BOOLEAN := true;

    signal grp_Summer_PE_sum_thread_fu_78_din_0_read : STD_LOGIC;
    signal grp_Summer_PE_sum_thread_fu_78_din_1_read : STD_LOGIC;
    signal grp_Summer_PE_sum_thread_fu_78_din_2_read : STD_LOGIC;
    signal grp_Summer_PE_sum_thread_fu_78_dout_0_din : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_Summer_PE_sum_thread_fu_78_dout_0_write : STD_LOGIC;
    signal grp_Summer_PE_sum_thread_fu_78_dout_1_din : STD_LOGIC_VECTOR (0 downto 0);
    signal grp_Summer_PE_sum_thread_fu_78_dout_1_write : STD_LOGIC;
    signal grp_Summer_PE_sum_thread_fu_78_dout_2_din : STD_LOGIC_VECTOR (1 downto 0);
    signal grp_Summer_PE_sum_thread_fu_78_dout_2_write : STD_LOGIC;
    signal grp_Summer_PE_sum_thread_fu_78_ctrl_acf_read : STD_LOGIC;
    signal grp_Summer_PE_sum_thread_fu_78_count_out : STD_LOGIC_VECTOR (31 downto 0);
    signal grp_Summer_PE_sum_thread_fu_78_count_out_ap_vld : STD_LOGIC;

    component Summer_PE_sum_thread IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        din_0_dout : IN STD_LOGIC_VECTOR (31 downto 0);
        din_0_empty_n : IN STD_LOGIC;
        din_0_read : OUT STD_LOGIC;
        din_1_dout : IN STD_LOGIC_VECTOR (0 downto 0);
        din_1_empty_n : IN STD_LOGIC;
        din_1_read : OUT STD_LOGIC;
        din_2_dout : IN STD_LOGIC_VECTOR (3 downto 0);
        din_2_empty_n : IN STD_LOGIC;
        din_2_read : OUT STD_LOGIC;
        dout_0_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dout_0_full_n : IN STD_LOGIC;
        dout_0_write : OUT STD_LOGIC;
        dout_1_din : OUT STD_LOGIC_VECTOR (0 downto 0);
        dout_1_full_n : IN STD_LOGIC;
        dout_1_write : OUT STD_LOGIC;
        dout_2_din : OUT STD_LOGIC_VECTOR (1 downto 0);
        dout_2_full_n : IN STD_LOGIC;
        dout_2_write : OUT STD_LOGIC;
        ctrl_acf_dout : IN STD_LOGIC_VECTOR (15 downto 0);
        ctrl_acf_empty_n : IN STD_LOGIC;
        ctrl_acf_read : OUT STD_LOGIC;
        count_out : OUT STD_LOGIC_VECTOR (31 downto 0);
        count_out_ap_vld : OUT STD_LOGIC );
    end component;



begin
    grp_Summer_PE_sum_thread_fu_78 : component Summer_PE_sum_thread
    port map (
        ap_clk => clk,
        ap_rst => reset,
        din_0_dout => din_0_dout,
        din_0_empty_n => din_0_empty_n,
        din_0_read => grp_Summer_PE_sum_thread_fu_78_din_0_read,
        din_1_dout => din_1_dout,
        din_1_empty_n => din_1_empty_n,
        din_1_read => grp_Summer_PE_sum_thread_fu_78_din_1_read,
        din_2_dout => din_2_dout,
        din_2_empty_n => din_2_empty_n,
        din_2_read => grp_Summer_PE_sum_thread_fu_78_din_2_read,
        dout_0_din => grp_Summer_PE_sum_thread_fu_78_dout_0_din,
        dout_0_full_n => dout_0_full_n,
        dout_0_write => grp_Summer_PE_sum_thread_fu_78_dout_0_write,
        dout_1_din => grp_Summer_PE_sum_thread_fu_78_dout_1_din,
        dout_1_full_n => dout_1_full_n,
        dout_1_write => grp_Summer_PE_sum_thread_fu_78_dout_1_write,
        dout_2_din => grp_Summer_PE_sum_thread_fu_78_dout_2_din,
        dout_2_full_n => dout_2_full_n,
        dout_2_write => grp_Summer_PE_sum_thread_fu_78_dout_2_write,
        ctrl_acf_dout => ctrl_acf_dout,
        ctrl_acf_empty_n => ctrl_acf_empty_n,
        ctrl_acf_read => grp_Summer_PE_sum_thread_fu_78_ctrl_acf_read,
        count_out => grp_Summer_PE_sum_thread_fu_78_count_out,
        count_out_ap_vld => grp_Summer_PE_sum_thread_fu_78_count_out_ap_vld);





    count_out_assign_proc : process(clk)
    begin
        if (clk'event and clk =  '1') then
            if (reset = '1') then
                count_out <= ap_const_lv32_0;
            else
                if ((grp_Summer_PE_sum_thread_fu_78_count_out_ap_vld = ap_const_logic_1)) then 
                    count_out <= grp_Summer_PE_sum_thread_fu_78_count_out;
                end if; 
            end if;
        end if;
    end process;

    ctrl_acf_read <= grp_Summer_PE_sum_thread_fu_78_ctrl_acf_read;
    din_0_read <= grp_Summer_PE_sum_thread_fu_78_din_0_read;
    din_1_read <= grp_Summer_PE_sum_thread_fu_78_din_1_read;
    din_2_read <= grp_Summer_PE_sum_thread_fu_78_din_2_read;
    dout_0_din <= grp_Summer_PE_sum_thread_fu_78_dout_0_din;
    dout_0_write <= grp_Summer_PE_sum_thread_fu_78_dout_0_write;
    dout_1_din <= grp_Summer_PE_sum_thread_fu_78_dout_1_din;
    dout_1_write <= grp_Summer_PE_sum_thread_fu_78_dout_1_write;
    dout_2_din <= grp_Summer_PE_sum_thread_fu_78_dout_2_din;
    dout_2_write <= grp_Summer_PE_sum_thread_fu_78_dout_2_write;
end behav;
