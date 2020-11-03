-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2019.1
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity p_sc_stream_router_merge_thread_sc_stream_router is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
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
    dout_2_write : OUT STD_LOGIC );
end;


architecture behav of p_sc_stream_router_merge_thread_sc_stream_router is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state2 : STD_LOGIC_VECTOR (3 downto 0) := "0010";
    constant ap_ST_fsm_pp0_stage0 : STD_LOGIC_VECTOR (3 downto 0) := "0100";
    constant ap_ST_fsm_state5 : STD_LOGIC_VECTOR (3 downto 0) := "1000";
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_boolean_0 : BOOLEAN := false;
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";

    signal din_a_0_blk_n : STD_LOGIC;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (3 downto 0) := "0010";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_pp0_stage0 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_pp0_stage0 : signal is "none";
    signal ap_enable_reg_pp0_iter0 : STD_LOGIC := '0';
    signal ap_block_pp0_stage0 : BOOLEAN;
    signal val_V_reg_172 : STD_LOGIC_VECTOR (0 downto 0);
    signal din_a_1_blk_n : STD_LOGIC;
    signal din_a_2_blk_n : STD_LOGIC;
    signal din_b_0_blk_n : STD_LOGIC;
    signal din_b_1_blk_n : STD_LOGIC;
    signal din_b_2_blk_n : STD_LOGIC;
    signal ctrl_channel_blk_n : STD_LOGIC;
    signal ap_CS_fsm_state2 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state2 : signal is "none";
    signal dout_0_blk_n : STD_LOGIC;
    signal ap_enable_reg_pp0_iter1 : STD_LOGIC := '0';
    signal dout_1_blk_n : STD_LOGIC;
    signal dout_2_blk_n : STD_LOGIC;
    signal tmp_tlast_V_4_reg_115 : STD_LOGIC_VECTOR (0 downto 0);
    signal io_acc_block_signal_op35 : STD_LOGIC;
    signal io_acc_block_signal_op40 : STD_LOGIC;
    signal ap_block_state3_pp0_stage0_iter0 : BOOLEAN;
    signal io_acc_block_signal_op50 : STD_LOGIC;
    signal ap_block_state4_pp0_stage0_iter1 : BOOLEAN;
    signal ap_block_pp0_stage0_11001 : BOOLEAN;
    signal ap_block_pp0_stage0_subdone : BOOLEAN;
    signal ap_phi_mux_tmp_tlast_V_4_phi_fu_119_p4 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_phi_reg_pp0_iter0_tmp_tlast_V_4_reg_115 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_phi_reg_pp0_iter0_tmp_tkeep_V_4_reg_126 : STD_LOGIC_VECTOR (15 downto 0);
    signal ap_phi_reg_pp0_iter1_tmp_tkeep_V_4_reg_126 : STD_LOGIC_VECTOR (15 downto 0);
    signal ap_phi_reg_pp0_iter0_tmp_data_V_4_reg_136 : STD_LOGIC_VECTOR (127 downto 0);
    signal ap_phi_reg_pp0_iter1_tmp_data_V_4_reg_136 : STD_LOGIC_VECTOR (127 downto 0);
    signal ap_block_pp0_stage0_01001 : BOOLEAN;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (3 downto 0);
    signal ap_idle_pp0 : STD_LOGIC;
    signal ap_enable_pp0 : STD_LOGIC;
    signal ap_condition_66 : BOOLEAN;
    signal ap_condition_142 : BOOLEAN;


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


    ap_enable_reg_pp0_iter0_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter0 <= ap_const_logic_0;
            else
                if (((ap_phi_mux_tmp_tlast_V_4_phi_fu_119_p4 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))) then 
                    ap_enable_reg_pp0_iter0 <= ap_const_logic_0;
                elsif (((ctrl_channel_empty_n = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
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
                elsif (((ctrl_channel_empty_n = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
                    ap_enable_reg_pp0_iter1 <= ap_const_logic_0;
                end if; 
            end if;
        end if;
    end process;


    ap_phi_reg_pp0_iter1_tmp_data_V_4_reg_136_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_142)) then
                if ((val_V_reg_172 = ap_const_lv1_0)) then 
                    ap_phi_reg_pp0_iter1_tmp_data_V_4_reg_136 <= din_a_0_dout;
                elsif ((val_V_reg_172 = ap_const_lv1_1)) then 
                    ap_phi_reg_pp0_iter1_tmp_data_V_4_reg_136 <= din_b_0_dout;
                elsif ((ap_const_boolean_1 = ap_const_boolean_1)) then 
                    ap_phi_reg_pp0_iter1_tmp_data_V_4_reg_136 <= ap_phi_reg_pp0_iter0_tmp_data_V_4_reg_136;
                end if;
            end if; 
        end if;
    end process;

    ap_phi_reg_pp0_iter1_tmp_tkeep_V_4_reg_126_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_142)) then
                if ((val_V_reg_172 = ap_const_lv1_0)) then 
                    ap_phi_reg_pp0_iter1_tmp_tkeep_V_4_reg_126 <= din_a_2_dout;
                elsif ((val_V_reg_172 = ap_const_lv1_1)) then 
                    ap_phi_reg_pp0_iter1_tmp_tkeep_V_4_reg_126 <= din_b_2_dout;
                elsif ((ap_const_boolean_1 = ap_const_boolean_1)) then 
                    ap_phi_reg_pp0_iter1_tmp_tkeep_V_4_reg_126 <= ap_phi_reg_pp0_iter0_tmp_tkeep_V_4_reg_126;
                end if;
            end if; 
        end if;
    end process;

    tmp_tlast_V_4_reg_115_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_142)) then
                if ((val_V_reg_172 = ap_const_lv1_0)) then 
                    tmp_tlast_V_4_reg_115 <= din_a_1_dout;
                elsif ((val_V_reg_172 = ap_const_lv1_1)) then 
                    tmp_tlast_V_4_reg_115 <= din_b_1_dout;
                elsif ((ap_const_boolean_1 = ap_const_boolean_1)) then 
                    tmp_tlast_V_4_reg_115 <= ap_phi_reg_pp0_iter0_tmp_tlast_V_4_reg_115;
                end if;
            end if; 
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ctrl_channel_empty_n = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state2))) then
                val_V_reg_172 <= ctrl_channel_dout;
            end if;
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ctrl_channel_empty_n, ap_CS_fsm, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_CS_fsm_state2, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0_subdone)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state2 => 
                if (((ctrl_channel_empty_n = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state2))) then
                    ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
                else
                    ap_NS_fsm <= ap_ST_fsm_state2;
                end if;
            when ap_ST_fsm_pp0_stage0 => 
                if (not(((ap_enable_reg_pp0_iter0 = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone)))) then
                    ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
                elsif (((ap_enable_reg_pp0_iter0 = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))) then
                    ap_NS_fsm <= ap_ST_fsm_state5;
                else
                    ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
                end if;
            when ap_ST_fsm_state5 => 
                ap_NS_fsm <= ap_ST_fsm_state2;
            when others =>  
                ap_NS_fsm <= "XXXX";
        end case;
    end process;
    ap_CS_fsm_pp0_stage0 <= ap_CS_fsm(2);
    ap_CS_fsm_state2 <= ap_CS_fsm(1);
        ap_block_pp0_stage0 <= not((ap_const_boolean_1 = ap_const_boolean_1));

    ap_block_pp0_stage0_01001_assign_proc : process(ap_enable_reg_pp0_iter0, val_V_reg_172, ap_enable_reg_pp0_iter1, io_acc_block_signal_op35, io_acc_block_signal_op40, io_acc_block_signal_op50)
    begin
                ap_block_pp0_stage0_01001 <= (((io_acc_block_signal_op50 = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1)) or ((ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (((val_V_reg_172 = ap_const_lv1_1) and (io_acc_block_signal_op40 = ap_const_logic_0)) or ((val_V_reg_172 = ap_const_lv1_0) and (io_acc_block_signal_op35 = ap_const_logic_0)))));
    end process;


    ap_block_pp0_stage0_11001_assign_proc : process(ap_enable_reg_pp0_iter0, val_V_reg_172, ap_enable_reg_pp0_iter1, io_acc_block_signal_op35, io_acc_block_signal_op40, io_acc_block_signal_op50)
    begin
                ap_block_pp0_stage0_11001 <= (((io_acc_block_signal_op50 = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1)) or ((ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (((val_V_reg_172 = ap_const_lv1_1) and (io_acc_block_signal_op40 = ap_const_logic_0)) or ((val_V_reg_172 = ap_const_lv1_0) and (io_acc_block_signal_op35 = ap_const_logic_0)))));
    end process;


    ap_block_pp0_stage0_subdone_assign_proc : process(ap_enable_reg_pp0_iter0, val_V_reg_172, ap_enable_reg_pp0_iter1, io_acc_block_signal_op35, io_acc_block_signal_op40, io_acc_block_signal_op50)
    begin
                ap_block_pp0_stage0_subdone <= (((io_acc_block_signal_op50 = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1)) or ((ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (((val_V_reg_172 = ap_const_lv1_1) and (io_acc_block_signal_op40 = ap_const_logic_0)) or ((val_V_reg_172 = ap_const_lv1_0) and (io_acc_block_signal_op35 = ap_const_logic_0)))));
    end process;


    ap_block_state3_pp0_stage0_iter0_assign_proc : process(val_V_reg_172, io_acc_block_signal_op35, io_acc_block_signal_op40)
    begin
                ap_block_state3_pp0_stage0_iter0 <= (((val_V_reg_172 = ap_const_lv1_1) and (io_acc_block_signal_op40 = ap_const_logic_0)) or ((val_V_reg_172 = ap_const_lv1_0) and (io_acc_block_signal_op35 = ap_const_logic_0)));
    end process;


    ap_block_state4_pp0_stage0_iter1_assign_proc : process(io_acc_block_signal_op50)
    begin
                ap_block_state4_pp0_stage0_iter1 <= (io_acc_block_signal_op50 = ap_const_logic_0);
    end process;


    ap_condition_142_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0_11001)
    begin
                ap_condition_142 <= ((ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001));
    end process;


    ap_condition_66_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0)
    begin
                ap_condition_66 <= ((ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0));
    end process;

    ap_enable_pp0 <= (ap_idle_pp0 xor ap_const_logic_1);

    ap_idle_pp0_assign_proc : process(ap_enable_reg_pp0_iter0, ap_enable_reg_pp0_iter1)
    begin
        if (((ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_0))) then 
            ap_idle_pp0 <= ap_const_logic_1;
        else 
            ap_idle_pp0 <= ap_const_logic_0;
        end if; 
    end process;


    ap_phi_mux_tmp_tlast_V_4_phi_fu_119_p4_assign_proc : process(din_a_1_dout, din_b_1_dout, val_V_reg_172, ap_phi_reg_pp0_iter0_tmp_tlast_V_4_reg_115, ap_condition_66)
    begin
        if ((ap_const_boolean_1 = ap_condition_66)) then
            if ((val_V_reg_172 = ap_const_lv1_0)) then 
                ap_phi_mux_tmp_tlast_V_4_phi_fu_119_p4 <= din_a_1_dout;
            elsif ((val_V_reg_172 = ap_const_lv1_1)) then 
                ap_phi_mux_tmp_tlast_V_4_phi_fu_119_p4 <= din_b_1_dout;
            else 
                ap_phi_mux_tmp_tlast_V_4_phi_fu_119_p4 <= ap_phi_reg_pp0_iter0_tmp_tlast_V_4_reg_115;
            end if;
        else 
            ap_phi_mux_tmp_tlast_V_4_phi_fu_119_p4 <= ap_phi_reg_pp0_iter0_tmp_tlast_V_4_reg_115;
        end if; 
    end process;

    ap_phi_reg_pp0_iter0_tmp_data_V_4_reg_136 <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    ap_phi_reg_pp0_iter0_tmp_tkeep_V_4_reg_126 <= "XXXXXXXXXXXXXXXX";
    ap_phi_reg_pp0_iter0_tmp_tlast_V_4_reg_115 <= "X";

    ctrl_channel_blk_n_assign_proc : process(ctrl_channel_empty_n, ap_CS_fsm_state2)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            ctrl_channel_blk_n <= ctrl_channel_empty_n;
        else 
            ctrl_channel_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    ctrl_channel_read_assign_proc : process(ctrl_channel_empty_n, ap_CS_fsm_state2)
    begin
        if (((ctrl_channel_empty_n = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            ctrl_channel_read <= ap_const_logic_1;
        else 
            ctrl_channel_read <= ap_const_logic_0;
        end if; 
    end process;


    din_a_0_blk_n_assign_proc : process(din_a_0_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0, val_V_reg_172)
    begin
        if (((val_V_reg_172 = ap_const_lv1_0) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            din_a_0_blk_n <= din_a_0_empty_n;
        else 
            din_a_0_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_a_0_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, val_V_reg_172, ap_block_pp0_stage0_11001)
    begin
        if (((val_V_reg_172 = ap_const_lv1_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            din_a_0_read <= ap_const_logic_1;
        else 
            din_a_0_read <= ap_const_logic_0;
        end if; 
    end process;


    din_a_1_blk_n_assign_proc : process(din_a_1_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0, val_V_reg_172)
    begin
        if (((val_V_reg_172 = ap_const_lv1_0) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            din_a_1_blk_n <= din_a_1_empty_n;
        else 
            din_a_1_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_a_1_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, val_V_reg_172, ap_block_pp0_stage0_11001)
    begin
        if (((val_V_reg_172 = ap_const_lv1_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            din_a_1_read <= ap_const_logic_1;
        else 
            din_a_1_read <= ap_const_logic_0;
        end if; 
    end process;


    din_a_2_blk_n_assign_proc : process(din_a_2_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0, val_V_reg_172)
    begin
        if (((val_V_reg_172 = ap_const_lv1_0) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            din_a_2_blk_n <= din_a_2_empty_n;
        else 
            din_a_2_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_a_2_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, val_V_reg_172, ap_block_pp0_stage0_11001)
    begin
        if (((val_V_reg_172 = ap_const_lv1_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            din_a_2_read <= ap_const_logic_1;
        else 
            din_a_2_read <= ap_const_logic_0;
        end if; 
    end process;


    din_b_0_blk_n_assign_proc : process(din_b_0_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0, val_V_reg_172)
    begin
        if (((val_V_reg_172 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            din_b_0_blk_n <= din_b_0_empty_n;
        else 
            din_b_0_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_b_0_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, val_V_reg_172, ap_block_pp0_stage0_11001)
    begin
        if (((val_V_reg_172 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            din_b_0_read <= ap_const_logic_1;
        else 
            din_b_0_read <= ap_const_logic_0;
        end if; 
    end process;


    din_b_1_blk_n_assign_proc : process(din_b_1_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0, val_V_reg_172)
    begin
        if (((val_V_reg_172 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            din_b_1_blk_n <= din_b_1_empty_n;
        else 
            din_b_1_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_b_1_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, val_V_reg_172, ap_block_pp0_stage0_11001)
    begin
        if (((val_V_reg_172 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            din_b_1_read <= ap_const_logic_1;
        else 
            din_b_1_read <= ap_const_logic_0;
        end if; 
    end process;


    din_b_2_blk_n_assign_proc : process(din_b_2_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0, val_V_reg_172)
    begin
        if (((val_V_reg_172 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            din_b_2_blk_n <= din_b_2_empty_n;
        else 
            din_b_2_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_b_2_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, val_V_reg_172, ap_block_pp0_stage0_11001)
    begin
        if (((val_V_reg_172 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            din_b_2_read <= ap_const_logic_1;
        else 
            din_b_2_read <= ap_const_logic_0;
        end if; 
    end process;


    dout_0_blk_n_assign_proc : process(dout_0_full_n, ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0, ap_enable_reg_pp0_iter1)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            dout_0_blk_n <= dout_0_full_n;
        else 
            dout_0_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    dout_0_din <= ap_phi_reg_pp0_iter1_tmp_data_V_4_reg_136;

    dout_0_write_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0_11001)
    begin
        if (((ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            dout_0_write <= ap_const_logic_1;
        else 
            dout_0_write <= ap_const_logic_0;
        end if; 
    end process;


    dout_1_blk_n_assign_proc : process(dout_1_full_n, ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0, ap_enable_reg_pp0_iter1)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            dout_1_blk_n <= dout_1_full_n;
        else 
            dout_1_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    dout_1_din <= tmp_tlast_V_4_reg_115;

    dout_1_write_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0_11001)
    begin
        if (((ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            dout_1_write <= ap_const_logic_1;
        else 
            dout_1_write <= ap_const_logic_0;
        end if; 
    end process;


    dout_2_blk_n_assign_proc : process(dout_2_full_n, ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0, ap_enable_reg_pp0_iter1)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            dout_2_blk_n <= dout_2_full_n;
        else 
            dout_2_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    dout_2_din <= ap_phi_reg_pp0_iter1_tmp_tkeep_V_4_reg_126;

    dout_2_write_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0_11001)
    begin
        if (((ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            dout_2_write <= ap_const_logic_1;
        else 
            dout_2_write <= ap_const_logic_0;
        end if; 
    end process;

    io_acc_block_signal_op35 <= (din_a_2_empty_n and din_a_1_empty_n and din_a_0_empty_n);
    io_acc_block_signal_op40 <= (din_b_2_empty_n and din_b_1_empty_n and din_b_0_empty_n);
    io_acc_block_signal_op50 <= (dout_2_full_n and dout_1_full_n and dout_0_full_n);
end behav;
