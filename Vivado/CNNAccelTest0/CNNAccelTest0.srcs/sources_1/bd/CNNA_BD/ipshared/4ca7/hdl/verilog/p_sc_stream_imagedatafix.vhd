-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2019.1
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity p_sc_stream_imagedatafix is
port (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    din_0_dout : IN STD_LOGIC_VECTOR (127 downto 0);
    din_0_empty_n : IN STD_LOGIC;
    din_0_read : OUT STD_LOGIC;
    din_1_dout : IN STD_LOGIC_VECTOR (0 downto 0);
    din_1_empty_n : IN STD_LOGIC;
    din_1_read : OUT STD_LOGIC;
    din_2_dout : IN STD_LOGIC_VECTOR (15 downto 0);
    din_2_empty_n : IN STD_LOGIC;
    din_2_read : OUT STD_LOGIC;
    dout_0_din : OUT STD_LOGIC_VECTOR (127 downto 0);
    dout_0_full_n : IN STD_LOGIC;
    dout_0_write : OUT STD_LOGIC;
    dout_1_din : OUT STD_LOGIC_VECTOR (0 downto 0);
    dout_1_full_n : IN STD_LOGIC;
    dout_1_write : OUT STD_LOGIC;
    dout_2_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    dout_2_full_n : IN STD_LOGIC;
    dout_2_write : OUT STD_LOGIC;
    enable_dout : IN STD_LOGIC_VECTOR (0 downto 0);
    enable_empty_n : IN STD_LOGIC;
    enable_read : OUT STD_LOGIC );
end;


architecture behav of p_sc_stream_imagedatafix is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "p_sc_stream_imagedatafix,hls_ip_2019_1,{HLS_INPUT_TYPE=sc,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xczu3eg-sbva484-1-e,HLS_INPUT_CLOCK=5.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=4.334000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=728,HLS_SYN_LUT=2124,HLS_VERSION=2019_1}";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_boolean_1 : BOOLEAN := true;

    signal grp_p_sc_stream_pixel_2_stream_fu_150_din_red_read : STD_LOGIC;
    signal grp_p_sc_stream_pixel_2_stream_fu_150_din_green_read : STD_LOGIC;
    signal grp_p_sc_stream_pixel_2_stream_fu_150_din_blue_read : STD_LOGIC;
    signal grp_p_sc_stream_pixel_2_stream_fu_150_din_last_dout : STD_LOGIC;
    signal grp_p_sc_stream_pixel_2_stream_fu_150_din_last_read : STD_LOGIC;
    signal grp_p_sc_stream_pixel_2_stream_fu_150_dout_0_din : STD_LOGIC_VECTOR (127 downto 0);
    signal grp_p_sc_stream_pixel_2_stream_fu_150_dout_0_write : STD_LOGIC;
    signal grp_p_sc_stream_pixel_2_stream_fu_150_dout_1_din : STD_LOGIC_VECTOR (0 downto 0);
    signal grp_p_sc_stream_pixel_2_stream_fu_150_dout_1_write : STD_LOGIC;
    signal grp_p_sc_stream_pixel_2_stream_fu_150_dout_2_din : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_p_sc_stream_pixel_2_stream_fu_150_dout_2_write : STD_LOGIC;
    signal grp_p_sc_stream_router_merge_fu_174_din_a_0_read : STD_LOGIC;
    signal grp_p_sc_stream_router_merge_fu_174_din_a_1_read : STD_LOGIC;
    signal grp_p_sc_stream_router_merge_fu_174_din_a_2_read : STD_LOGIC;
    signal grp_p_sc_stream_router_merge_fu_174_din_b_0_read : STD_LOGIC;
    signal grp_p_sc_stream_router_merge_fu_174_din_b_1_read : STD_LOGIC;
    signal grp_p_sc_stream_router_merge_fu_174_din_b_2_read : STD_LOGIC;
    signal grp_p_sc_stream_router_merge_fu_174_ctrl_channel_read : STD_LOGIC;
    signal grp_p_sc_stream_router_merge_fu_174_dout_0_din : STD_LOGIC_VECTOR (127 downto 0);
    signal grp_p_sc_stream_router_merge_fu_174_dout_0_write : STD_LOGIC;
    signal grp_p_sc_stream_router_merge_fu_174_dout_1_din : STD_LOGIC_VECTOR (0 downto 0);
    signal grp_p_sc_stream_router_merge_fu_174_dout_1_write : STD_LOGIC;
    signal grp_p_sc_stream_router_merge_fu_174_dout_2_din : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_p_sc_stream_router_merge_fu_174_dout_2_write : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_din_0_read : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_din_1_read : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_din_2_read : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_enable_read : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_1_din : STD_LOGIC_VECTOR (0 downto 0);
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_1_write : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_114_din : STD_LOGIC_VECTOR (7 downto 0);
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_114_write : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_115_din : STD_LOGIC_VECTOR (7 downto 0);
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_115_write : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_116_din : STD_LOGIC_VECTOR (7 downto 0);
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_116_write : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_117_din : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_117_write : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_320_din : STD_LOGIC_VECTOR (127 downto 0);
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_320_write : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_421_din : STD_LOGIC_VECTOR (0 downto 0);
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_421_write : STD_LOGIC;
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_522_din : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_522_write : STD_LOGIC;
    signal sc_fifo_chn_1_full_n : STD_LOGIC;
    signal sc_fifo_chn_14_full_n : STD_LOGIC;
    signal sc_fifo_chn_15_full_n : STD_LOGIC;
    signal sc_fifo_chn_16_full_n : STD_LOGIC;
    signal sc_fifo_chn_17_din : STD_LOGIC_VECTOR (0 downto 0);
    signal sc_fifo_chn_17_full_n : STD_LOGIC;
    signal sc_fifo_chn_310_full_n : STD_LOGIC;
    signal sc_fifo_chn_411_full_n : STD_LOGIC;
    signal sc_fifo_chn_512_full_n : STD_LOGIC;
    signal sc_fifo_chn_14_dout : STD_LOGIC_VECTOR (7 downto 0);
    signal sc_fifo_chn_14_empty_n : STD_LOGIC;
    signal sc_fifo_chn_15_dout : STD_LOGIC_VECTOR (7 downto 0);
    signal sc_fifo_chn_15_empty_n : STD_LOGIC;
    signal sc_fifo_chn_16_dout : STD_LOGIC_VECTOR (7 downto 0);
    signal sc_fifo_chn_16_empty_n : STD_LOGIC;
    signal sc_fifo_chn_17_dout : STD_LOGIC_VECTOR (0 downto 0);
    signal sc_fifo_chn_17_empty_n : STD_LOGIC;
    signal sc_fifo_chn_3_full_n : STD_LOGIC;
    signal sc_fifo_chn_4_full_n : STD_LOGIC;
    signal sc_fifo_chn_5_full_n : STD_LOGIC;
    signal sc_fifo_chn_3_dout : STD_LOGIC_VECTOR (127 downto 0);
    signal sc_fifo_chn_3_empty_n : STD_LOGIC;
    signal sc_fifo_chn_4_dout : STD_LOGIC_VECTOR (0 downto 0);
    signal sc_fifo_chn_4_empty_n : STD_LOGIC;
    signal sc_fifo_chn_5_dout : STD_LOGIC_VECTOR (15 downto 0);
    signal sc_fifo_chn_5_empty_n : STD_LOGIC;
    signal sc_fifo_chn_310_dout : STD_LOGIC_VECTOR (127 downto 0);
    signal sc_fifo_chn_310_empty_n : STD_LOGIC;
    signal sc_fifo_chn_411_dout : STD_LOGIC_VECTOR (0 downto 0);
    signal sc_fifo_chn_411_empty_n : STD_LOGIC;
    signal sc_fifo_chn_512_dout : STD_LOGIC_VECTOR (15 downto 0);
    signal sc_fifo_chn_512_empty_n : STD_LOGIC;
    signal sc_fifo_chn_1_dout : STD_LOGIC_VECTOR (0 downto 0);
    signal sc_fifo_chn_1_empty_n : STD_LOGIC;

    component p_sc_stream_pixel_2_stream IS
    port (
        din_red_dout : IN STD_LOGIC_VECTOR (7 downto 0);
        din_red_empty_n : IN STD_LOGIC;
        din_red_read : OUT STD_LOGIC;
        din_green_dout : IN STD_LOGIC_VECTOR (7 downto 0);
        din_green_empty_n : IN STD_LOGIC;
        din_green_read : OUT STD_LOGIC;
        din_blue_dout : IN STD_LOGIC_VECTOR (7 downto 0);
        din_blue_empty_n : IN STD_LOGIC;
        din_blue_read : OUT STD_LOGIC;
        din_last_dout : IN STD_LOGIC;
        din_last_empty_n : IN STD_LOGIC;
        din_last_read : OUT STD_LOGIC;
        dout_0_din : OUT STD_LOGIC_VECTOR (127 downto 0);
        dout_0_full_n : IN STD_LOGIC;
        dout_0_write : OUT STD_LOGIC;
        dout_1_din : OUT STD_LOGIC_VECTOR (0 downto 0);
        dout_1_full_n : IN STD_LOGIC;
        dout_1_write : OUT STD_LOGIC;
        dout_2_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dout_2_full_n : IN STD_LOGIC;
        dout_2_write : OUT STD_LOGIC;
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC );
    end component;


    component p_sc_stream_router_merge IS
    port (
        din_a_0_dout : IN STD_LOGIC_VECTOR (127 downto 0);
        din_a_0_empty_n : IN STD_LOGIC;
        din_a_0_read : OUT STD_LOGIC;
        din_a_1_dout : IN STD_LOGIC_VECTOR (0 downto 0);
        din_a_1_empty_n : IN STD_LOGIC;
        din_a_1_read : OUT STD_LOGIC;
        din_a_2_dout : IN STD_LOGIC_VECTOR (15 downto 0);
        din_a_2_empty_n : IN STD_LOGIC;
        din_a_2_read : OUT STD_LOGIC;
        din_b_0_dout : IN STD_LOGIC_VECTOR (127 downto 0);
        din_b_0_empty_n : IN STD_LOGIC;
        din_b_0_read : OUT STD_LOGIC;
        din_b_1_dout : IN STD_LOGIC_VECTOR (0 downto 0);
        din_b_1_empty_n : IN STD_LOGIC;
        din_b_1_read : OUT STD_LOGIC;
        din_b_2_dout : IN STD_LOGIC_VECTOR (15 downto 0);
        din_b_2_empty_n : IN STD_LOGIC;
        din_b_2_read : OUT STD_LOGIC;
        ctrl_channel_dout : IN STD_LOGIC_VECTOR (0 downto 0);
        ctrl_channel_empty_n : IN STD_LOGIC;
        ctrl_channel_read : OUT STD_LOGIC;
        dout_0_din : OUT STD_LOGIC_VECTOR (127 downto 0);
        dout_0_full_n : IN STD_LOGIC;
        dout_0_write : OUT STD_LOGIC;
        dout_1_din : OUT STD_LOGIC_VECTOR (0 downto 0);
        dout_1_full_n : IN STD_LOGIC;
        dout_1_write : OUT STD_LOGIC;
        dout_2_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dout_2_full_n : IN STD_LOGIC;
        dout_2_write : OUT STD_LOGIC;
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC );
    end component;


    component p_sc_stream_imagedatafix_thread IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        din_0_dout : IN STD_LOGIC_VECTOR (127 downto 0);
        din_0_empty_n : IN STD_LOGIC;
        din_0_read : OUT STD_LOGIC;
        din_1_dout : IN STD_LOGIC_VECTOR (0 downto 0);
        din_1_empty_n : IN STD_LOGIC;
        din_1_read : OUT STD_LOGIC;
        din_2_dout : IN STD_LOGIC_VECTOR (15 downto 0);
        din_2_empty_n : IN STD_LOGIC;
        din_2_read : OUT STD_LOGIC;
        enable_dout : IN STD_LOGIC_VECTOR (0 downto 0);
        enable_empty_n : IN STD_LOGIC;
        enable_read : OUT STD_LOGIC;
        sc_fifo_chn_1_din : OUT STD_LOGIC_VECTOR (0 downto 0);
        sc_fifo_chn_1_full_n : IN STD_LOGIC;
        sc_fifo_chn_1_write : OUT STD_LOGIC;
        sc_fifo_chn_114_din : OUT STD_LOGIC_VECTOR (7 downto 0);
        sc_fifo_chn_114_full_n : IN STD_LOGIC;
        sc_fifo_chn_114_write : OUT STD_LOGIC;
        sc_fifo_chn_115_din : OUT STD_LOGIC_VECTOR (7 downto 0);
        sc_fifo_chn_115_full_n : IN STD_LOGIC;
        sc_fifo_chn_115_write : OUT STD_LOGIC;
        sc_fifo_chn_116_din : OUT STD_LOGIC_VECTOR (7 downto 0);
        sc_fifo_chn_116_full_n : IN STD_LOGIC;
        sc_fifo_chn_116_write : OUT STD_LOGIC;
        sc_fifo_chn_117_din : OUT STD_LOGIC;
        sc_fifo_chn_117_full_n : IN STD_LOGIC;
        sc_fifo_chn_117_write : OUT STD_LOGIC;
        sc_fifo_chn_320_din : OUT STD_LOGIC_VECTOR (127 downto 0);
        sc_fifo_chn_320_full_n : IN STD_LOGIC;
        sc_fifo_chn_320_write : OUT STD_LOGIC;
        sc_fifo_chn_421_din : OUT STD_LOGIC_VECTOR (0 downto 0);
        sc_fifo_chn_421_full_n : IN STD_LOGIC;
        sc_fifo_chn_421_write : OUT STD_LOGIC;
        sc_fifo_chn_522_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        sc_fifo_chn_522_full_n : IN STD_LOGIC;
        sc_fifo_chn_522_write : OUT STD_LOGIC );
    end component;


    component fifo_w1_d1_A IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (0 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (0 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component fifo_w8_d4_A IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (7 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (7 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component fifo_w1_d4_A IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (0 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (0 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component fifo_w128_d1_A IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (127 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (127 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component fifo_w16_d1_A IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (15 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (15 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;



begin
    grp_p_sc_stream_pixel_2_stream_fu_150 : component p_sc_stream_pixel_2_stream
    port map (
        din_red_dout => sc_fifo_chn_14_dout,
        din_red_empty_n => sc_fifo_chn_14_empty_n,
        din_red_read => grp_p_sc_stream_pixel_2_stream_fu_150_din_red_read,
        din_green_dout => sc_fifo_chn_15_dout,
        din_green_empty_n => sc_fifo_chn_15_empty_n,
        din_green_read => grp_p_sc_stream_pixel_2_stream_fu_150_din_green_read,
        din_blue_dout => sc_fifo_chn_16_dout,
        din_blue_empty_n => sc_fifo_chn_16_empty_n,
        din_blue_read => grp_p_sc_stream_pixel_2_stream_fu_150_din_blue_read,
        din_last_dout => grp_p_sc_stream_pixel_2_stream_fu_150_din_last_dout,
        din_last_empty_n => sc_fifo_chn_17_empty_n,
        din_last_read => grp_p_sc_stream_pixel_2_stream_fu_150_din_last_read,
        dout_0_din => grp_p_sc_stream_pixel_2_stream_fu_150_dout_0_din,
        dout_0_full_n => sc_fifo_chn_3_full_n,
        dout_0_write => grp_p_sc_stream_pixel_2_stream_fu_150_dout_0_write,
        dout_1_din => grp_p_sc_stream_pixel_2_stream_fu_150_dout_1_din,
        dout_1_full_n => sc_fifo_chn_4_full_n,
        dout_1_write => grp_p_sc_stream_pixel_2_stream_fu_150_dout_1_write,
        dout_2_din => grp_p_sc_stream_pixel_2_stream_fu_150_dout_2_din,
        dout_2_full_n => sc_fifo_chn_5_full_n,
        dout_2_write => grp_p_sc_stream_pixel_2_stream_fu_150_dout_2_write,
        reset => reset,
        clk => clk);

    grp_p_sc_stream_router_merge_fu_174 : component p_sc_stream_router_merge
    port map (
        din_a_0_dout => sc_fifo_chn_3_dout,
        din_a_0_empty_n => sc_fifo_chn_3_empty_n,
        din_a_0_read => grp_p_sc_stream_router_merge_fu_174_din_a_0_read,
        din_a_1_dout => sc_fifo_chn_4_dout,
        din_a_1_empty_n => sc_fifo_chn_4_empty_n,
        din_a_1_read => grp_p_sc_stream_router_merge_fu_174_din_a_1_read,
        din_a_2_dout => sc_fifo_chn_5_dout,
        din_a_2_empty_n => sc_fifo_chn_5_empty_n,
        din_a_2_read => grp_p_sc_stream_router_merge_fu_174_din_a_2_read,
        din_b_0_dout => sc_fifo_chn_310_dout,
        din_b_0_empty_n => sc_fifo_chn_310_empty_n,
        din_b_0_read => grp_p_sc_stream_router_merge_fu_174_din_b_0_read,
        din_b_1_dout => sc_fifo_chn_411_dout,
        din_b_1_empty_n => sc_fifo_chn_411_empty_n,
        din_b_1_read => grp_p_sc_stream_router_merge_fu_174_din_b_1_read,
        din_b_2_dout => sc_fifo_chn_512_dout,
        din_b_2_empty_n => sc_fifo_chn_512_empty_n,
        din_b_2_read => grp_p_sc_stream_router_merge_fu_174_din_b_2_read,
        ctrl_channel_dout => sc_fifo_chn_1_dout,
        ctrl_channel_empty_n => sc_fifo_chn_1_empty_n,
        ctrl_channel_read => grp_p_sc_stream_router_merge_fu_174_ctrl_channel_read,
        dout_0_din => grp_p_sc_stream_router_merge_fu_174_dout_0_din,
        dout_0_full_n => dout_0_full_n,
        dout_0_write => grp_p_sc_stream_router_merge_fu_174_dout_0_write,
        dout_1_din => grp_p_sc_stream_router_merge_fu_174_dout_1_din,
        dout_1_full_n => dout_1_full_n,
        dout_1_write => grp_p_sc_stream_router_merge_fu_174_dout_1_write,
        dout_2_din => grp_p_sc_stream_router_merge_fu_174_dout_2_din,
        dout_2_full_n => dout_2_full_n,
        dout_2_write => grp_p_sc_stream_router_merge_fu_174_dout_2_write,
        reset => reset,
        clk => clk);

    grp_p_sc_stream_imagedatafix_thread_fu_204 : component p_sc_stream_imagedatafix_thread
    port map (
        ap_clk => clk,
        ap_rst => reset,
        din_0_dout => din_0_dout,
        din_0_empty_n => din_0_empty_n,
        din_0_read => grp_p_sc_stream_imagedatafix_thread_fu_204_din_0_read,
        din_1_dout => din_1_dout,
        din_1_empty_n => din_1_empty_n,
        din_1_read => grp_p_sc_stream_imagedatafix_thread_fu_204_din_1_read,
        din_2_dout => din_2_dout,
        din_2_empty_n => din_2_empty_n,
        din_2_read => grp_p_sc_stream_imagedatafix_thread_fu_204_din_2_read,
        enable_dout => enable_dout,
        enable_empty_n => enable_empty_n,
        enable_read => grp_p_sc_stream_imagedatafix_thread_fu_204_enable_read,
        sc_fifo_chn_1_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_1_din,
        sc_fifo_chn_1_full_n => sc_fifo_chn_1_full_n,
        sc_fifo_chn_1_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_1_write,
        sc_fifo_chn_114_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_114_din,
        sc_fifo_chn_114_full_n => sc_fifo_chn_14_full_n,
        sc_fifo_chn_114_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_114_write,
        sc_fifo_chn_115_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_115_din,
        sc_fifo_chn_115_full_n => sc_fifo_chn_15_full_n,
        sc_fifo_chn_115_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_115_write,
        sc_fifo_chn_116_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_116_din,
        sc_fifo_chn_116_full_n => sc_fifo_chn_16_full_n,
        sc_fifo_chn_116_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_116_write,
        sc_fifo_chn_117_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_117_din,
        sc_fifo_chn_117_full_n => sc_fifo_chn_17_full_n,
        sc_fifo_chn_117_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_117_write,
        sc_fifo_chn_320_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_320_din,
        sc_fifo_chn_320_full_n => sc_fifo_chn_310_full_n,
        sc_fifo_chn_320_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_320_write,
        sc_fifo_chn_421_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_421_din,
        sc_fifo_chn_421_full_n => sc_fifo_chn_411_full_n,
        sc_fifo_chn_421_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_421_write,
        sc_fifo_chn_522_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_522_din,
        sc_fifo_chn_522_full_n => sc_fifo_chn_512_full_n,
        sc_fifo_chn_522_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_522_write);

    sc_fifo_chn_1_fifo_U : component fifo_w1_d1_A
    port map (
        clk => clk,
        reset => reset,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_1_din,
        if_full_n => sc_fifo_chn_1_full_n,
        if_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_1_write,
        if_dout => sc_fifo_chn_1_dout,
        if_empty_n => sc_fifo_chn_1_empty_n,
        if_read => grp_p_sc_stream_router_merge_fu_174_ctrl_channel_read);

    sc_fifo_chn_14_fifo_U : component fifo_w8_d4_A
    port map (
        clk => clk,
        reset => reset,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_114_din,
        if_full_n => sc_fifo_chn_14_full_n,
        if_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_114_write,
        if_dout => sc_fifo_chn_14_dout,
        if_empty_n => sc_fifo_chn_14_empty_n,
        if_read => grp_p_sc_stream_pixel_2_stream_fu_150_din_red_read);

    sc_fifo_chn_15_fifo_U : component fifo_w8_d4_A
    port map (
        clk => clk,
        reset => reset,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_115_din,
        if_full_n => sc_fifo_chn_15_full_n,
        if_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_115_write,
        if_dout => sc_fifo_chn_15_dout,
        if_empty_n => sc_fifo_chn_15_empty_n,
        if_read => grp_p_sc_stream_pixel_2_stream_fu_150_din_green_read);

    sc_fifo_chn_16_fifo_U : component fifo_w8_d4_A
    port map (
        clk => clk,
        reset => reset,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_116_din,
        if_full_n => sc_fifo_chn_16_full_n,
        if_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_116_write,
        if_dout => sc_fifo_chn_16_dout,
        if_empty_n => sc_fifo_chn_16_empty_n,
        if_read => grp_p_sc_stream_pixel_2_stream_fu_150_din_blue_read);

    sc_fifo_chn_17_fifo_U : component fifo_w1_d4_A
    port map (
        clk => clk,
        reset => reset,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => sc_fifo_chn_17_din,
        if_full_n => sc_fifo_chn_17_full_n,
        if_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_117_write,
        if_dout => sc_fifo_chn_17_dout,
        if_empty_n => sc_fifo_chn_17_empty_n,
        if_read => grp_p_sc_stream_pixel_2_stream_fu_150_din_last_read);

    sc_fifo_chn_3_fifo_U : component fifo_w128_d1_A
    port map (
        clk => clk,
        reset => reset,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => grp_p_sc_stream_pixel_2_stream_fu_150_dout_0_din,
        if_full_n => sc_fifo_chn_3_full_n,
        if_write => grp_p_sc_stream_pixel_2_stream_fu_150_dout_0_write,
        if_dout => sc_fifo_chn_3_dout,
        if_empty_n => sc_fifo_chn_3_empty_n,
        if_read => grp_p_sc_stream_router_merge_fu_174_din_a_0_read);

    sc_fifo_chn_4_fifo_U : component fifo_w1_d1_A
    port map (
        clk => clk,
        reset => reset,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => grp_p_sc_stream_pixel_2_stream_fu_150_dout_1_din,
        if_full_n => sc_fifo_chn_4_full_n,
        if_write => grp_p_sc_stream_pixel_2_stream_fu_150_dout_1_write,
        if_dout => sc_fifo_chn_4_dout,
        if_empty_n => sc_fifo_chn_4_empty_n,
        if_read => grp_p_sc_stream_router_merge_fu_174_din_a_1_read);

    sc_fifo_chn_5_fifo_U : component fifo_w16_d1_A
    port map (
        clk => clk,
        reset => reset,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => grp_p_sc_stream_pixel_2_stream_fu_150_dout_2_din,
        if_full_n => sc_fifo_chn_5_full_n,
        if_write => grp_p_sc_stream_pixel_2_stream_fu_150_dout_2_write,
        if_dout => sc_fifo_chn_5_dout,
        if_empty_n => sc_fifo_chn_5_empty_n,
        if_read => grp_p_sc_stream_router_merge_fu_174_din_a_2_read);

    sc_fifo_chn_310_fifo_U : component fifo_w128_d1_A
    port map (
        clk => clk,
        reset => reset,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_320_din,
        if_full_n => sc_fifo_chn_310_full_n,
        if_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_320_write,
        if_dout => sc_fifo_chn_310_dout,
        if_empty_n => sc_fifo_chn_310_empty_n,
        if_read => grp_p_sc_stream_router_merge_fu_174_din_b_0_read);

    sc_fifo_chn_411_fifo_U : component fifo_w1_d1_A
    port map (
        clk => clk,
        reset => reset,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_421_din,
        if_full_n => sc_fifo_chn_411_full_n,
        if_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_421_write,
        if_dout => sc_fifo_chn_411_dout,
        if_empty_n => sc_fifo_chn_411_empty_n,
        if_read => grp_p_sc_stream_router_merge_fu_174_din_b_1_read);

    sc_fifo_chn_512_fifo_U : component fifo_w16_d1_A
    port map (
        clk => clk,
        reset => reset,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_522_din,
        if_full_n => sc_fifo_chn_512_full_n,
        if_write => grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_522_write,
        if_dout => sc_fifo_chn_512_dout,
        if_empty_n => sc_fifo_chn_512_empty_n,
        if_read => grp_p_sc_stream_router_merge_fu_174_din_b_2_read);




    din_0_read <= grp_p_sc_stream_imagedatafix_thread_fu_204_din_0_read;
    din_1_read <= grp_p_sc_stream_imagedatafix_thread_fu_204_din_1_read;
    din_2_read <= grp_p_sc_stream_imagedatafix_thread_fu_204_din_2_read;
    dout_0_din <= grp_p_sc_stream_router_merge_fu_174_dout_0_din;
    dout_0_write <= grp_p_sc_stream_router_merge_fu_174_dout_0_write;
    dout_1_din <= grp_p_sc_stream_router_merge_fu_174_dout_1_din;
    dout_1_write <= grp_p_sc_stream_router_merge_fu_174_dout_1_write;
    dout_2_din <= grp_p_sc_stream_router_merge_fu_174_dout_2_din;
    dout_2_write <= grp_p_sc_stream_router_merge_fu_174_dout_2_write;
    enable_read <= grp_p_sc_stream_imagedatafix_thread_fu_204_enable_read;
    grp_p_sc_stream_pixel_2_stream_fu_150_din_last_dout <= sc_fifo_chn_17_dout(0);
    sc_fifo_chn_17_din <= (0=>grp_p_sc_stream_imagedatafix_thread_fu_204_sc_fifo_chn_117_din, others=>'-');
end behav;