-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2019.1
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity p_sc_stream_reverseinst_db_thread is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    din_0_dout : IN STD_LOGIC_VECTOR (383 downto 0);
    din_0_empty_n : IN STD_LOGIC;
    din_0_read : OUT STD_LOGIC;
    din_1_dout : IN STD_LOGIC_VECTOR (0 downto 0);
    din_1_empty_n : IN STD_LOGIC;
    din_1_read : OUT STD_LOGIC;
    din_2_dout : IN STD_LOGIC_VECTOR (47 downto 0);
    din_2_empty_n : IN STD_LOGIC;
    din_2_read : OUT STD_LOGIC;
    dout_0_din : OUT STD_LOGIC_VECTOR (383 downto 0);
    dout_0_full_n : IN STD_LOGIC;
    dout_0_write : OUT STD_LOGIC;
    dout_1_din : OUT STD_LOGIC_VECTOR (0 downto 0);
    dout_1_full_n : IN STD_LOGIC;
    dout_1_write : OUT STD_LOGIC;
    dout_2_din : OUT STD_LOGIC_VECTOR (47 downto 0);
    dout_2_full_n : IN STD_LOGIC;
    dout_2_write : OUT STD_LOGIC );
end;


architecture behav of p_sc_stream_reverseinst_db_thread is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state2 : STD_LOGIC_VECTOR (3 downto 0) := "0010";
    constant ap_ST_fsm_state3 : STD_LOGIC_VECTOR (3 downto 0) := "0100";
    constant ap_ST_fsm_state4 : STD_LOGIC_VECTOR (3 downto 0) := "1000";
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_lv32_100 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000100000000";
    constant ap_const_lv32_17F : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000101111111";
    constant ap_const_lv32_20 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000100000";
    constant ap_const_lv32_80 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000010000000";
    constant ap_const_lv32_FF : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000011111111";
    constant ap_const_lv32_10 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000010000";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_lv32_2F : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000101111";
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_boolean_1 : BOOLEAN := true;

    signal din_0_blk_n : STD_LOGIC;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (3 downto 0) := "0010";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state3 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state3 : signal is "none";
    signal din_1_blk_n : STD_LOGIC;
    signal din_2_blk_n : STD_LOGIC;
    signal dout_0_blk_n : STD_LOGIC;
    signal dout_1_blk_n : STD_LOGIC;
    signal dout_2_blk_n : STD_LOGIC;
    signal io_acc_block_signal_op28 : STD_LOGIC;
    signal io_acc_block_signal_op40 : STD_LOGIC;
    signal ap_block_state3 : BOOLEAN;
    signal val_tlast_V_fu_115_p1 : STD_LOGIC_VECTOR (0 downto 0);
    signal trunc_ln647_fu_160_p1 : STD_LOGIC_VECTOR (127 downto 0);
    signal p_Result_11_1_fu_142_p4 : STD_LOGIC_VECTOR (127 downto 0);
    signal p_Result_s_fu_124_p4 : STD_LOGIC_VECTOR (127 downto 0);
    signal p_Result_2_fu_175_p3 : STD_LOGIC_VECTOR (0 downto 0);
    signal p_Result_1_fu_152_p3 : STD_LOGIC_VECTOR (0 downto 0);
    signal p_Result_s_2181_fu_134_p3 : STD_LOGIC_VECTOR (0 downto 0);
    signal trunc_ln182_fu_284_p1 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_8_fu_288_p3 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_NS_fsm : STD_LOGIC_VECTOR (3 downto 0);


begin




    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_fsm_state2;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    ap_NS_fsm_assign_proc : process (ap_CS_fsm, ap_CS_fsm_state3, io_acc_block_signal_op28, io_acc_block_signal_op40, val_tlast_V_fu_115_p1, trunc_ln182_fu_284_p1, tmp_8_fu_288_p3)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state2 => 
                ap_NS_fsm <= ap_ST_fsm_state3;
            when ap_ST_fsm_state3 => 
                if ((not(((io_acc_block_signal_op40 = ap_const_logic_0) or (io_acc_block_signal_op28 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state3) and ((val_tlast_V_fu_115_p1 = ap_const_lv1_0) or ((tmp_8_fu_288_p3 = ap_const_lv1_1) or (trunc_ln182_fu_284_p1 = ap_const_lv1_1))))) then
                    ap_NS_fsm <= ap_ST_fsm_state3;
                elsif ((not(((io_acc_block_signal_op40 = ap_const_logic_0) or (io_acc_block_signal_op28 = ap_const_logic_0))) and (val_tlast_V_fu_115_p1 = ap_const_lv1_1) and (tmp_8_fu_288_p3 = ap_const_lv1_0) and (trunc_ln182_fu_284_p1 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state3))) then
                    ap_NS_fsm <= ap_ST_fsm_state4;
                else
                    ap_NS_fsm <= ap_ST_fsm_state3;
                end if;
            when ap_ST_fsm_state4 => 
                ap_NS_fsm <= ap_ST_fsm_state2;
            when others =>  
                ap_NS_fsm <= "XXXX";
        end case;
    end process;
    ap_CS_fsm_state3 <= ap_CS_fsm(2);

    ap_block_state3_assign_proc : process(io_acc_block_signal_op28, io_acc_block_signal_op40)
    begin
                ap_block_state3 <= ((io_acc_block_signal_op40 = ap_const_logic_0) or (io_acc_block_signal_op28 = ap_const_logic_0));
    end process;


    din_0_blk_n_assign_proc : process(din_0_empty_n, ap_CS_fsm_state3)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state3)) then 
            din_0_blk_n <= din_0_empty_n;
        else 
            din_0_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_0_read_assign_proc : process(ap_CS_fsm_state3, io_acc_block_signal_op28, io_acc_block_signal_op40)
    begin
        if ((not(((io_acc_block_signal_op40 = ap_const_logic_0) or (io_acc_block_signal_op28 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state3))) then 
            din_0_read <= ap_const_logic_1;
        else 
            din_0_read <= ap_const_logic_0;
        end if; 
    end process;


    din_1_blk_n_assign_proc : process(din_1_empty_n, ap_CS_fsm_state3)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state3)) then 
            din_1_blk_n <= din_1_empty_n;
        else 
            din_1_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_1_read_assign_proc : process(ap_CS_fsm_state3, io_acc_block_signal_op28, io_acc_block_signal_op40)
    begin
        if ((not(((io_acc_block_signal_op40 = ap_const_logic_0) or (io_acc_block_signal_op28 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state3))) then 
            din_1_read <= ap_const_logic_1;
        else 
            din_1_read <= ap_const_logic_0;
        end if; 
    end process;


    din_2_blk_n_assign_proc : process(din_2_empty_n, ap_CS_fsm_state3)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state3)) then 
            din_2_blk_n <= din_2_empty_n;
        else 
            din_2_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_2_read_assign_proc : process(ap_CS_fsm_state3, io_acc_block_signal_op28, io_acc_block_signal_op40)
    begin
        if ((not(((io_acc_block_signal_op40 = ap_const_logic_0) or (io_acc_block_signal_op28 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state3))) then 
            din_2_read <= ap_const_logic_1;
        else 
            din_2_read <= ap_const_logic_0;
        end if; 
    end process;


    dout_0_blk_n_assign_proc : process(dout_0_full_n, ap_CS_fsm_state3)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state3)) then 
            dout_0_blk_n <= dout_0_full_n;
        else 
            dout_0_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    dout_0_din <= ((trunc_ln647_fu_160_p1 & p_Result_11_1_fu_142_p4) & p_Result_s_fu_124_p4);

    dout_0_write_assign_proc : process(ap_CS_fsm_state3, io_acc_block_signal_op28, io_acc_block_signal_op40)
    begin
        if ((not(((io_acc_block_signal_op40 = ap_const_logic_0) or (io_acc_block_signal_op28 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state3))) then 
            dout_0_write <= ap_const_logic_1;
        else 
            dout_0_write <= ap_const_logic_0;
        end if; 
    end process;


    dout_1_blk_n_assign_proc : process(dout_1_full_n, ap_CS_fsm_state3)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state3)) then 
            dout_1_blk_n <= dout_1_full_n;
        else 
            dout_1_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    dout_1_din <= din_1_dout;

    dout_1_write_assign_proc : process(ap_CS_fsm_state3, io_acc_block_signal_op28, io_acc_block_signal_op40)
    begin
        if ((not(((io_acc_block_signal_op40 = ap_const_logic_0) or (io_acc_block_signal_op28 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state3))) then 
            dout_1_write <= ap_const_logic_1;
        else 
            dout_1_write <= ap_const_logic_0;
        end if; 
    end process;


    dout_2_blk_n_assign_proc : process(dout_2_full_n, ap_CS_fsm_state3)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state3)) then 
            dout_2_blk_n <= dout_2_full_n;
        else 
            dout_2_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    dout_2_din <= (((((((((((((((((((((((((((((((((((((((((((((((p_Result_2_fu_175_p3 & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_2_fu_175_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_1_fu_152_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3) & p_Result_s_2181_fu_134_p3);

    dout_2_write_assign_proc : process(ap_CS_fsm_state3, io_acc_block_signal_op28, io_acc_block_signal_op40)
    begin
        if ((not(((io_acc_block_signal_op40 = ap_const_logic_0) or (io_acc_block_signal_op28 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state3))) then 
            dout_2_write <= ap_const_logic_1;
        else 
            dout_2_write <= ap_const_logic_0;
        end if; 
    end process;

    io_acc_block_signal_op28 <= (din_2_empty_n and din_1_empty_n and din_0_empty_n);
    io_acc_block_signal_op40 <= (dout_2_full_n and dout_1_full_n and dout_0_full_n);
    p_Result_11_1_fu_142_p4 <= din_0_dout(255 downto 128);
    p_Result_1_fu_152_p3 <= din_2_dout(16 downto 16);
    p_Result_2_fu_175_p3 <= din_2_dout(0 downto 0);
    p_Result_s_2181_fu_134_p3 <= din_2_dout(32 downto 32);
    p_Result_s_fu_124_p4 <= din_0_dout(383 downto 256);
    tmp_8_fu_288_p3 <= din_2_dout(47 downto 47);
    trunc_ln182_fu_284_p1 <= din_2_dout(1 - 1 downto 0);
    trunc_ln647_fu_160_p1 <= din_0_dout(128 - 1 downto 0);
    val_tlast_V_fu_115_p1 <= din_1_dout;
end behav;
