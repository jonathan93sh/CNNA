-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2019.1
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sc_status_module_getStatus_egress_out is
port (
    status_add : IN STD_LOGIC_VECTOR (31 downto 0);
    egress_out_0 : OUT STD_LOGIC_VECTOR (7 downto 0);
    egress_out_0_ap_vld : OUT STD_LOGIC;
    egress_out_1 : OUT STD_LOGIC_VECTOR (7 downto 0);
    egress_out_1_ap_vld : OUT STD_LOGIC;
    egress_out_2 : OUT STD_LOGIC_VECTOR (31 downto 0);
    egress_out_2_ap_vld : OUT STD_LOGIC );
end;


architecture behav of sc_status_module_getStatus_egress_out is 
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_lv8_1 : STD_LOGIC_VECTOR (7 downto 0) := "00000001";
    constant ap_const_lv32_FFFFFFFF : STD_LOGIC_VECTOR (31 downto 0) := "11111111111111111111111111111111";
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_logic_1 : STD_LOGIC := '1';



begin



    egress_out_0 <= ap_const_lv8_1;
    egress_out_0_ap_vld <= ap_const_logic_1;
    egress_out_1 <= status_add(8 - 1 downto 0);
    egress_out_1_ap_vld <= ap_const_logic_1;
    egress_out_2 <= ap_const_lv32_FFFFFFFF;
    egress_out_2_ap_vld <= ap_const_logic_1;
end behav;
