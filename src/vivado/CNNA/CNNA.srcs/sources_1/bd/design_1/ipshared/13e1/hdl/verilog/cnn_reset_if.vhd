-- ==============================================================
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.1 (64-bit)
-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity cnn_reset_if is
    generic (
        RESET_ACTIVE_LOW : integer := 0);
    port (
        din : in std_logic;
        dout : out std_logic
    );
end entity;
architecture arch of cnn_reset_if is
begin
    dout <= not din when RESET_ACTIVE_LOW = 1 else din;
end architecture;

