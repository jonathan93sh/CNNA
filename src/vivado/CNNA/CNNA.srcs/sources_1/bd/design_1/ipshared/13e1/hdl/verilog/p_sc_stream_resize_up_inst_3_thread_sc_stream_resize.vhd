-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2019.1
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity p_sc_stream_resize_up_inst_3_thread_sc_stream_resize is
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


architecture behav of p_sc_stream_resize_up_inst_3_thread_sc_stream_resize is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (2 downto 0) := "001";
    constant ap_ST_fsm_state2 : STD_LOGIC_VECTOR (2 downto 0) := "010";
    constant ap_ST_fsm_pp0_stage0 : STD_LOGIC_VECTOR (2 downto 0) := "100";
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_boolean_0 : BOOLEAN := false;
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_lv384_lc_1 : STD_LOGIC_VECTOR (383 downto 0) := "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    constant ap_const_lv48_0 : STD_LOGIC_VECTOR (47 downto 0) := "000000000000000000000000000000000000000000000000";
    constant ap_const_lv32_F : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001111";
    constant ap_const_lv14_0 : STD_LOGIC_VECTOR (13 downto 0) := "00000000000000";
    constant ap_const_lv16_0 : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
    constant ap_const_lv7_0 : STD_LOGIC_VECTOR (6 downto 0) := "0000000";
    constant ap_const_lv384_lc_5 : STD_LOGIC_VECTOR (383 downto 0) := "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
    constant ap_const_lv384_lc_6 : STD_LOGIC_VECTOR (383 downto 0) := "111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
    constant ap_const_lv4_0 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    constant ap_const_lv48_FFFF : STD_LOGIC_VECTOR (47 downto 0) := "000000000000000000000000000000001111111111111111";
    constant ap_const_lv48_FFFFFFFFFFFF : STD_LOGIC_VECTOR (47 downto 0) := "111111111111111111111111111111111111111111111111";

    signal dout_0_blk_n : STD_LOGIC;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (2 downto 0) := "001";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_pp0_stage0 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_pp0_stage0 : signal is "none";
    signal ap_enable_reg_pp0_iter1 : STD_LOGIC := '0';
    signal ap_block_pp0_stage0 : BOOLEAN;
    signal p_emptyn_3_reg_356 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmpV_tlast_V_reg_365 : STD_LOGIC_VECTOR (0 downto 0);
    signal icmp_ln118_reg_375 : STD_LOGIC_VECTOR (0 downto 0);
    signal or_ln125_reg_389 : STD_LOGIC_VECTOR (0 downto 0);
    signal dout_1_blk_n : STD_LOGIC;
    signal dout_2_blk_n : STD_LOGIC;
    signal p_emptyn_3_fu_146_p1 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_block_state3_pp0_stage0_iter0 : BOOLEAN;
    signal io_acc_block_signal_op76 : STD_LOGIC;
    signal ap_predicate_op76_write_state4 : BOOLEAN;
    signal io_acc_block_signal_op79 : STD_LOGIC;
    signal ap_predicate_op79_write_state4 : BOOLEAN;
    signal ap_block_state4_pp0_stage0_iter1 : BOOLEAN;
    signal ap_block_pp0_stage0_11001 : BOOLEAN;
    signal tmpV_data_V_reg_360 : STD_LOGIC_VECTOR (127 downto 0);
    signal tmpV_tlast_V_fu_154_p1 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmpV_tkeep_V_reg_370 : STD_LOGIC_VECTOR (15 downto 0);
    signal icmp_ln118_fu_184_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal trunc_ln414_fu_193_p1 : STD_LOGIC_VECTOR (1 downto 0);
    signal trunc_ln414_reg_379 : STD_LOGIC_VECTOR (1 downto 0);
    signal trunc_ln414_1_fu_197_p1 : STD_LOGIC_VECTOR (1 downto 0);
    signal trunc_ln414_1_reg_384 : STD_LOGIC_VECTOR (1 downto 0);
    signal or_ln125_fu_207_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_enable_reg_pp0_iter0 : STD_LOGIC := '0';
    signal ap_CS_fsm_state2 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state2 : signal is "none";
    signal ap_block_pp0_stage0_subdone : BOOLEAN;
    signal index_assign_fu_98 : STD_LOGIC_VECTOR (31 downto 0);
    signal idx_fu_213_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal p_Val2_s_fu_102 : STD_LOGIC_VECTOR (383 downto 0);
    signal p_Result_s_fu_268_p2 : STD_LOGIC_VECTOR (383 downto 0);
    signal p_Val2_2_fu_106 : STD_LOGIC_VECTOR (47 downto 0);
    signal p_Result_10_fu_313_p2 : STD_LOGIC_VECTOR (47 downto 0);
    signal p_emptyn_nbread_fu_110_p4_0 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_block_pp0_stage0_01001 : BOOLEAN;
    signal tmp_9_fu_162_p3 : STD_LOGIC_VECTOR (0 downto 0);
    signal trunc_ln118_fu_170_p1 : STD_LOGIC_VECTOR (0 downto 0);
    signal and_ln_fu_174_p4 : STD_LOGIC_VECTOR (15 downto 0);
    signal icmp_ln125_fu_201_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_10_fu_230_p3 : STD_LOGIC_VECTOR (8 downto 0);
    signal zext_ln414_fu_237_p1 : STD_LOGIC_VECTOR (383 downto 0);
    signal shl_ln414_fu_241_p2 : STD_LOGIC_VECTOR (383 downto 0);
    signal xor_ln414_fu_247_p2 : STD_LOGIC_VECTOR (383 downto 0);
    signal zext_ln414_1_fu_259_p1 : STD_LOGIC_VECTOR (383 downto 0);
    signal and_ln414_fu_253_p2 : STD_LOGIC_VECTOR (383 downto 0);
    signal shl_ln414_1_fu_262_p2 : STD_LOGIC_VECTOR (383 downto 0);
    signal tmp_11_fu_275_p3 : STD_LOGIC_VECTOR (5 downto 0);
    signal zext_ln414_2_fu_282_p1 : STD_LOGIC_VECTOR (47 downto 0);
    signal shl_ln414_2_fu_286_p2 : STD_LOGIC_VECTOR (47 downto 0);
    signal xor_ln414_1_fu_292_p2 : STD_LOGIC_VECTOR (47 downto 0);
    signal zext_ln414_3_fu_304_p1 : STD_LOGIC_VECTOR (47 downto 0);
    signal and_ln414_1_fu_298_p2 : STD_LOGIC_VECTOR (47 downto 0);
    signal shl_ln414_3_fu_307_p2 : STD_LOGIC_VECTOR (47 downto 0);
    signal ap_NS_fsm : STD_LOGIC_VECTOR (2 downto 0);
    signal ap_idle_pp0 : STD_LOGIC;
    signal ap_enable_pp0 : STD_LOGIC;
    signal ap_condition_183 : BOOLEAN;
    signal ap_condition_152 : BOOLEAN;
    signal ap_condition_58 : BOOLEAN;
    signal ap_condition_151 : BOOLEAN;


begin




    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_fsm_state1;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter0_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter0 <= ap_const_logic_0;
            else
                if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
                    ap_enable_reg_pp0_iter0 <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter1_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter1 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter1 <= ap_enable_reg_pp0_iter0;
                elsif ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
                    ap_enable_reg_pp0_iter1 <= ap_const_logic_0;
                end if; 
            end if;
        end if;
    end process;


    index_assign_fu_98_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (((tmpV_tlast_V_fu_154_p1 = ap_const_lv1_0) and (or_ln125_fu_207_p2 = ap_const_lv1_0) and (p_emptyn_3_fu_146_p1 = ap_const_lv1_1)) or ((icmp_ln118_fu_184_p2 = ap_const_lv1_0) and (or_ln125_fu_207_p2 = ap_const_lv1_0) and (p_emptyn_3_fu_146_p1 = ap_const_lv1_1))))) then 
                index_assign_fu_98 <= idx_fu_213_p2;
            elsif (((ap_const_logic_1 = ap_CS_fsm_state2) or ((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (((tmpV_tlast_V_fu_154_p1 = ap_const_lv1_0) and (p_emptyn_3_fu_146_p1 = ap_const_lv1_1) and (or_ln125_fu_207_p2 = ap_const_lv1_1)) or ((icmp_ln118_fu_184_p2 = ap_const_lv1_0) and (p_emptyn_3_fu_146_p1 = ap_const_lv1_1) and (or_ln125_fu_207_p2 = ap_const_lv1_1)))) or ((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (icmp_ln118_fu_184_p2 = ap_const_lv1_1) and (tmpV_tlast_V_fu_154_p1 = ap_const_lv1_1) and (p_emptyn_3_fu_146_p1 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1)))) then 
                index_assign_fu_98 <= ap_const_lv32_0;
            end if; 
        end if;
    end process;

    p_Val2_2_fu_106_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (((or_ln125_reg_389 = ap_const_lv1_0) and (tmpV_tlast_V_reg_365 = ap_const_lv1_0) and (p_emptyn_3_reg_356 = ap_const_lv1_1)) or ((or_ln125_reg_389 = ap_const_lv1_0) and (icmp_ln118_reg_375 = ap_const_lv1_0) and (p_emptyn_3_reg_356 = ap_const_lv1_1))))) then 
                p_Val2_2_fu_106 <= p_Result_10_fu_313_p2;
            elsif (((ap_const_logic_1 = ap_CS_fsm_state2) or ((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (((tmpV_tlast_V_reg_365 = ap_const_lv1_0) and (or_ln125_reg_389 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1)) or ((icmp_ln118_reg_375 = ap_const_lv1_0) and (or_ln125_reg_389 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1)))) or ((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (icmp_ln118_reg_375 = ap_const_lv1_1) and (tmpV_tlast_V_reg_365 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0)))) then 
                p_Val2_2_fu_106 <= ap_const_lv48_0;
            end if; 
        end if;
    end process;

    p_Val2_s_fu_102_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_151)) then
                if ((ap_const_boolean_1 = ap_condition_58)) then 
                    p_Val2_s_fu_102 <= ap_const_lv384_lc_1;
                elsif ((ap_const_boolean_1 = ap_condition_152)) then 
                    p_Val2_s_fu_102 <= p_Result_s_fu_268_p2;
                end if;
            end if; 
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (tmpV_tlast_V_fu_154_p1 = ap_const_lv1_1) and (p_emptyn_3_fu_146_p1 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then
                icmp_ln118_reg_375 <= icmp_ln118_fu_184_p2;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (((tmpV_tlast_V_fu_154_p1 = ap_const_lv1_0) and (p_emptyn_3_fu_146_p1 = ap_const_lv1_1)) or ((icmp_ln118_fu_184_p2 = ap_const_lv1_0) and (p_emptyn_3_fu_146_p1 = ap_const_lv1_1))))) then
                or_ln125_reg_389 <= or_ln125_fu_207_p2;
                trunc_ln414_1_reg_384 <= trunc_ln414_1_fu_197_p1;
                trunc_ln414_reg_379 <= trunc_ln414_fu_193_p1;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then
                p_emptyn_3_reg_356 <= p_emptyn_nbread_fu_110_p4_0;
                tmpV_data_V_reg_360 <= din_0_dout;
                tmpV_tkeep_V_reg_370 <= din_2_dout;
                tmpV_tlast_V_reg_365 <= din_1_dout;
            end if;
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_CS_fsm)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                ap_NS_fsm <= ap_ST_fsm_state2;
            when ap_ST_fsm_state2 => 
                ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
            when ap_ST_fsm_pp0_stage0 => 
                ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
            when others =>  
                ap_NS_fsm <= "XXX";
        end case;
    end process;
    and_ln414_1_fu_298_p2 <= (xor_ln414_1_fu_292_p2 and p_Val2_2_fu_106);
    and_ln414_fu_253_p2 <= (xor_ln414_fu_247_p2 and p_Val2_s_fu_102);
    and_ln_fu_174_p4 <= ((tmp_9_fu_162_p3 & ap_const_lv14_0) & trunc_ln118_fu_170_p1);
    ap_CS_fsm_pp0_stage0 <= ap_CS_fsm(2);
    ap_CS_fsm_state2 <= ap_CS_fsm(1);
        ap_block_pp0_stage0 <= not((ap_const_boolean_1 = ap_const_boolean_1));

    ap_block_pp0_stage0_01001_assign_proc : process(ap_enable_reg_pp0_iter1, io_acc_block_signal_op76, ap_predicate_op76_write_state4, io_acc_block_signal_op79, ap_predicate_op79_write_state4)
    begin
                ap_block_pp0_stage0_01001 <= ((ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (((ap_predicate_op79_write_state4 = ap_const_boolean_1) and (io_acc_block_signal_op79 = ap_const_logic_0)) or ((ap_predicate_op76_write_state4 = ap_const_boolean_1) and (io_acc_block_signal_op76 = ap_const_logic_0))));
    end process;


    ap_block_pp0_stage0_11001_assign_proc : process(ap_enable_reg_pp0_iter1, io_acc_block_signal_op76, ap_predicate_op76_write_state4, io_acc_block_signal_op79, ap_predicate_op79_write_state4)
    begin
                ap_block_pp0_stage0_11001 <= ((ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (((ap_predicate_op79_write_state4 = ap_const_boolean_1) and (io_acc_block_signal_op79 = ap_const_logic_0)) or ((ap_predicate_op76_write_state4 = ap_const_boolean_1) and (io_acc_block_signal_op76 = ap_const_logic_0))));
    end process;


    ap_block_pp0_stage0_subdone_assign_proc : process(ap_enable_reg_pp0_iter1, io_acc_block_signal_op76, ap_predicate_op76_write_state4, io_acc_block_signal_op79, ap_predicate_op79_write_state4)
    begin
                ap_block_pp0_stage0_subdone <= ((ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (((ap_predicate_op79_write_state4 = ap_const_boolean_1) and (io_acc_block_signal_op79 = ap_const_logic_0)) or ((ap_predicate_op76_write_state4 = ap_const_boolean_1) and (io_acc_block_signal_op76 = ap_const_logic_0))));
    end process;

        ap_block_state3_pp0_stage0_iter0 <= not((ap_const_boolean_1 = ap_const_boolean_1));

    ap_block_state4_pp0_stage0_iter1_assign_proc : process(io_acc_block_signal_op76, ap_predicate_op76_write_state4, io_acc_block_signal_op79, ap_predicate_op79_write_state4)
    begin
                ap_block_state4_pp0_stage0_iter1 <= (((ap_predicate_op79_write_state4 = ap_const_boolean_1) and (io_acc_block_signal_op79 = ap_const_logic_0)) or ((ap_predicate_op76_write_state4 = ap_const_boolean_1) and (io_acc_block_signal_op76 = ap_const_logic_0)));
    end process;


    ap_condition_151_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0_11001)
    begin
                ap_condition_151 <= ((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0));
    end process;


    ap_condition_152_assign_proc : process(p_emptyn_3_reg_356, tmpV_tlast_V_reg_365, icmp_ln118_reg_375)
    begin
                ap_condition_152 <= (((tmpV_tlast_V_reg_365 = ap_const_lv1_0) and (p_emptyn_3_reg_356 = ap_const_lv1_1)) or ((icmp_ln118_reg_375 = ap_const_lv1_0) and (p_emptyn_3_reg_356 = ap_const_lv1_1)));
    end process;


    ap_condition_183_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0_01001)
    begin
                ap_condition_183 <= ((ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_01001));
    end process;


    ap_condition_58_assign_proc : process(p_emptyn_3_reg_356, tmpV_tlast_V_reg_365, icmp_ln118_reg_375)
    begin
                ap_condition_58 <= ((icmp_ln118_reg_375 = ap_const_lv1_1) and (tmpV_tlast_V_reg_365 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1));
    end process;

    ap_enable_pp0 <= (ap_idle_pp0 xor ap_const_logic_1);

    ap_idle_pp0_assign_proc : process(ap_enable_reg_pp0_iter1, ap_enable_reg_pp0_iter0)
    begin
        if (((ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_0))) then 
            ap_idle_pp0 <= ap_const_logic_1;
        else 
            ap_idle_pp0 <= ap_const_logic_0;
        end if; 
    end process;


    ap_predicate_op76_write_state4_assign_proc : process(p_emptyn_3_reg_356, tmpV_tlast_V_reg_365, icmp_ln118_reg_375, or_ln125_reg_389)
    begin
                ap_predicate_op76_write_state4 <= (((tmpV_tlast_V_reg_365 = ap_const_lv1_0) and (or_ln125_reg_389 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1)) or ((icmp_ln118_reg_375 = ap_const_lv1_0) and (or_ln125_reg_389 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1)));
    end process;


    ap_predicate_op79_write_state4_assign_proc : process(p_emptyn_3_reg_356, tmpV_tlast_V_reg_365, icmp_ln118_reg_375)
    begin
                ap_predicate_op79_write_state4 <= ((icmp_ln118_reg_375 = ap_const_lv1_1) and (tmpV_tlast_V_reg_365 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1));
    end process;


    din_0_read_assign_proc : process(din_0_empty_n, din_1_empty_n, din_2_empty_n, ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0_11001, ap_enable_reg_pp0_iter0)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and ((din_2_empty_n and din_1_empty_n and din_0_empty_n) = ap_const_logic_1) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1))) then 
            din_0_read <= ap_const_logic_1;
        else 
            din_0_read <= ap_const_logic_0;
        end if; 
    end process;


    din_1_read_assign_proc : process(din_0_empty_n, din_1_empty_n, din_2_empty_n, ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0_11001, ap_enable_reg_pp0_iter0)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and ((din_2_empty_n and din_1_empty_n and din_0_empty_n) = ap_const_logic_1) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1))) then 
            din_1_read <= ap_const_logic_1;
        else 
            din_1_read <= ap_const_logic_0;
        end if; 
    end process;


    din_2_read_assign_proc : process(din_0_empty_n, din_1_empty_n, din_2_empty_n, ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0_11001, ap_enable_reg_pp0_iter0)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and ((din_2_empty_n and din_1_empty_n and din_0_empty_n) = ap_const_logic_1) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1))) then 
            din_2_read <= ap_const_logic_1;
        else 
            din_2_read <= ap_const_logic_0;
        end if; 
    end process;


    dout_0_blk_n_assign_proc : process(dout_0_full_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0, p_emptyn_3_reg_356, tmpV_tlast_V_reg_365, icmp_ln118_reg_375, or_ln125_reg_389)
    begin
        if ((((ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (((tmpV_tlast_V_reg_365 = ap_const_lv1_0) and (or_ln125_reg_389 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1)) or ((icmp_ln118_reg_375 = ap_const_lv1_0) and (or_ln125_reg_389 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1)))) or ((icmp_ln118_reg_375 = ap_const_lv1_1) and (tmpV_tlast_V_reg_365 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0)))) then 
            dout_0_blk_n <= dout_0_full_n;
        else 
            dout_0_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    dout_0_din_assign_proc : process(ap_predicate_op76_write_state4, ap_predicate_op79_write_state4, p_Result_s_fu_268_p2, ap_condition_183)
    begin
        if ((ap_const_boolean_1 = ap_condition_183)) then
            if ((ap_predicate_op79_write_state4 = ap_const_boolean_1)) then 
                dout_0_din <= ap_const_lv384_lc_1;
            elsif ((ap_predicate_op76_write_state4 = ap_const_boolean_1)) then 
                dout_0_din <= p_Result_s_fu_268_p2;
            else 
                dout_0_din <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
            end if;
        else 
            dout_0_din <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end if; 
    end process;


    dout_0_write_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_predicate_op76_write_state4, ap_predicate_op79_write_state4, ap_block_pp0_stage0_11001)
    begin
        if ((((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_predicate_op79_write_state4 = ap_const_boolean_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0)) or ((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_predicate_op76_write_state4 = ap_const_boolean_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0)))) then 
            dout_0_write <= ap_const_logic_1;
        else 
            dout_0_write <= ap_const_logic_0;
        end if; 
    end process;


    dout_1_blk_n_assign_proc : process(dout_1_full_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0, p_emptyn_3_reg_356, tmpV_tlast_V_reg_365, icmp_ln118_reg_375, or_ln125_reg_389)
    begin
        if ((((ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (((tmpV_tlast_V_reg_365 = ap_const_lv1_0) and (or_ln125_reg_389 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1)) or ((icmp_ln118_reg_375 = ap_const_lv1_0) and (or_ln125_reg_389 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1)))) or ((icmp_ln118_reg_375 = ap_const_lv1_1) and (tmpV_tlast_V_reg_365 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0)))) then 
            dout_1_blk_n <= dout_1_full_n;
        else 
            dout_1_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    dout_1_din_assign_proc : process(tmpV_tlast_V_reg_365, ap_predicate_op76_write_state4, ap_predicate_op79_write_state4, ap_condition_183)
    begin
        if ((ap_const_boolean_1 = ap_condition_183)) then
            if ((ap_predicate_op79_write_state4 = ap_const_boolean_1)) then 
                dout_1_din <= ap_const_lv1_1;
            elsif ((ap_predicate_op76_write_state4 = ap_const_boolean_1)) then 
                dout_1_din <= tmpV_tlast_V_reg_365;
            else 
                dout_1_din <= "X";
            end if;
        else 
            dout_1_din <= "X";
        end if; 
    end process;


    dout_1_write_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_predicate_op76_write_state4, ap_predicate_op79_write_state4, ap_block_pp0_stage0_11001)
    begin
        if ((((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_predicate_op79_write_state4 = ap_const_boolean_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0)) or ((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_predicate_op76_write_state4 = ap_const_boolean_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0)))) then 
            dout_1_write <= ap_const_logic_1;
        else 
            dout_1_write <= ap_const_logic_0;
        end if; 
    end process;


    dout_2_blk_n_assign_proc : process(dout_2_full_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0, p_emptyn_3_reg_356, tmpV_tlast_V_reg_365, icmp_ln118_reg_375, or_ln125_reg_389)
    begin
        if ((((ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (((tmpV_tlast_V_reg_365 = ap_const_lv1_0) and (or_ln125_reg_389 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1)) or ((icmp_ln118_reg_375 = ap_const_lv1_0) and (or_ln125_reg_389 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1)))) or ((icmp_ln118_reg_375 = ap_const_lv1_1) and (tmpV_tlast_V_reg_365 = ap_const_lv1_1) and (p_emptyn_3_reg_356 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0)))) then 
            dout_2_blk_n <= dout_2_full_n;
        else 
            dout_2_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    dout_2_din_assign_proc : process(ap_predicate_op76_write_state4, ap_predicate_op79_write_state4, p_Result_10_fu_313_p2, ap_condition_183)
    begin
        if ((ap_const_boolean_1 = ap_condition_183)) then
            if ((ap_predicate_op79_write_state4 = ap_const_boolean_1)) then 
                dout_2_din <= ap_const_lv48_0;
            elsif ((ap_predicate_op76_write_state4 = ap_const_boolean_1)) then 
                dout_2_din <= p_Result_10_fu_313_p2;
            else 
                dout_2_din <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
            end if;
        else 
            dout_2_din <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end if; 
    end process;


    dout_2_write_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_predicate_op76_write_state4, ap_predicate_op79_write_state4, ap_block_pp0_stage0_11001)
    begin
        if ((((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_predicate_op79_write_state4 = ap_const_boolean_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0)) or ((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_predicate_op76_write_state4 = ap_const_boolean_1) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0)))) then 
            dout_2_write <= ap_const_logic_1;
        else 
            dout_2_write <= ap_const_logic_0;
        end if; 
    end process;

    icmp_ln118_fu_184_p2 <= "1" when (and_ln_fu_174_p4 = ap_const_lv16_0) else "0";
    icmp_ln125_fu_201_p2 <= "1" when (index_assign_fu_98 = ap_const_lv32_2) else "0";
    idx_fu_213_p2 <= std_logic_vector(unsigned(index_assign_fu_98) + unsigned(ap_const_lv32_1));
    io_acc_block_signal_op76 <= (dout_2_full_n and dout_1_full_n and dout_0_full_n);
    io_acc_block_signal_op79 <= (dout_2_full_n and dout_1_full_n and dout_0_full_n);
    or_ln125_fu_207_p2 <= (icmp_ln125_fu_201_p2 or din_1_dout);
    p_Result_10_fu_313_p2 <= (shl_ln414_3_fu_307_p2 or and_ln414_1_fu_298_p2);
    p_Result_s_fu_268_p2 <= (shl_ln414_1_fu_262_p2 or and_ln414_fu_253_p2);
    p_emptyn_3_fu_146_p1 <= p_emptyn_nbread_fu_110_p4_0;
    p_emptyn_nbread_fu_110_p4_0 <= (0=>(din_2_empty_n and din_1_empty_n and din_0_empty_n), others=>'-');
    shl_ln414_1_fu_262_p2 <= std_logic_vector(shift_left(unsigned(zext_ln414_1_fu_259_p1),to_integer(unsigned('0' & zext_ln414_fu_237_p1(31-1 downto 0)))));
    shl_ln414_2_fu_286_p2 <= std_logic_vector(shift_left(unsigned(ap_const_lv48_FFFF),to_integer(unsigned('0' & zext_ln414_2_fu_282_p1(31-1 downto 0)))));
    shl_ln414_3_fu_307_p2 <= std_logic_vector(shift_left(unsigned(zext_ln414_3_fu_304_p1),to_integer(unsigned('0' & zext_ln414_2_fu_282_p1(31-1 downto 0)))));
    shl_ln414_fu_241_p2 <= std_logic_vector(shift_left(unsigned(ap_const_lv384_lc_5),to_integer(unsigned('0' & zext_ln414_fu_237_p1(31-1 downto 0)))));
    tmpV_tlast_V_fu_154_p1 <= din_1_dout;
    tmp_10_fu_230_p3 <= (trunc_ln414_reg_379 & ap_const_lv7_0);
    tmp_11_fu_275_p3 <= (trunc_ln414_1_reg_384 & ap_const_lv4_0);
    tmp_9_fu_162_p3 <= din_2_dout(15 downto 15);
    trunc_ln118_fu_170_p1 <= din_2_dout(1 - 1 downto 0);
    trunc_ln414_1_fu_197_p1 <= index_assign_fu_98(2 - 1 downto 0);
    trunc_ln414_fu_193_p1 <= index_assign_fu_98(2 - 1 downto 0);
    xor_ln414_1_fu_292_p2 <= (shl_ln414_2_fu_286_p2 xor ap_const_lv48_FFFFFFFFFFFF);
    xor_ln414_fu_247_p2 <= (shl_ln414_fu_241_p2 xor ap_const_lv384_lc_6);
    zext_ln414_1_fu_259_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(tmpV_data_V_reg_360),384));
    zext_ln414_2_fu_282_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(tmp_11_fu_275_p3),48));
    zext_ln414_3_fu_304_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(tmpV_tkeep_V_reg_370),48));
    zext_ln414_fu_237_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(tmp_10_fu_230_p3),384));
end behav;