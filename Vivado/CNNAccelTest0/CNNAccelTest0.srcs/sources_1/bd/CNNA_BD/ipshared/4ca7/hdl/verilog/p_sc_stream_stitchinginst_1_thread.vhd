-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2019.1
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity p_sc_stream_stitchinginst_1_thread is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    din_buf_0_dout : IN STD_LOGIC_VECTOR (127 downto 0);
    din_buf_0_empty_n : IN STD_LOGIC;
    din_buf_0_read : OUT STD_LOGIC;
    din_buf_1_dout : IN STD_LOGIC_VECTOR (0 downto 0);
    din_buf_1_empty_n : IN STD_LOGIC;
    din_buf_1_read : OUT STD_LOGIC;
    din_buf_2_dout : IN STD_LOGIC_VECTOR (15 downto 0);
    din_buf_2_empty_n : IN STD_LOGIC;
    din_buf_2_read : OUT STD_LOGIC;
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
    ctrl_depth_dout : IN STD_LOGIC_VECTOR (15 downto 0);
    ctrl_depth_empty_n : IN STD_LOGIC;
    ctrl_depth_read : OUT STD_LOGIC;
    ctrl_buf_depth_dout : IN STD_LOGIC_VECTOR (15 downto 0);
    ctrl_buf_depth_empty_n : IN STD_LOGIC;
    ctrl_buf_depth_read : OUT STD_LOGIC );
end;


architecture behav of p_sc_stream_stitchinginst_1_thread is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state2 : STD_LOGIC_VECTOR (3 downto 0) := "0010";
    constant ap_ST_fsm_pp0_stage0 : STD_LOGIC_VECTOR (3 downto 0) := "0100";
    constant ap_ST_fsm_state5 : STD_LOGIC_VECTOR (3 downto 0) := "1000";
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_boolean_0 : BOOLEAN := false;
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv16_0 : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
    constant ap_const_lv17_1 : STD_LOGIC_VECTOR (16 downto 0) := "00000000000000001";
    constant ap_const_lv16_1 : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000001";

    signal din_buf_0_blk_n : STD_LOGIC;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (3 downto 0) := "0010";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_pp0_stage0 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_pp0_stage0 : signal is "none";
    signal ap_enable_reg_pp0_iter0 : STD_LOGIC := '0';
    signal ap_block_pp0_stage0 : BOOLEAN;
    signal icmp_ln887_fu_201_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal din_buf_1_blk_n : STD_LOGIC;
    signal din_buf_2_blk_n : STD_LOGIC;
    signal din_0_blk_n : STD_LOGIC;
    signal din_1_blk_n : STD_LOGIC;
    signal din_2_blk_n : STD_LOGIC;
    signal dout_0_blk_n : STD_LOGIC;
    signal ap_enable_reg_pp0_iter1 : STD_LOGIC := '0';
    signal dout_1_blk_n : STD_LOGIC;
    signal dout_2_blk_n : STD_LOGIC;
    signal ctrl_depth_blk_n : STD_LOGIC;
    signal ap_CS_fsm_state2 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state2 : signal is "none";
    signal ctrl_buf_depth_blk_n : STD_LOGIC;
    signal p_0101_0_reg_131 : STD_LOGIC_VECTOR (15 downto 0);
    signal last_0_reg_142 : STD_LOGIC_VECTOR (0 downto 0);
    signal last_1_reg_153 : STD_LOGIC_VECTOR (0 downto 0);
    signal val_V_1_reg_256 : STD_LOGIC_VECTOR (15 downto 0);
    signal ap_block_state2 : BOOLEAN;
    signal zext_ln44_fu_197_p1 : STD_LOGIC_VECTOR (16 downto 0);
    signal zext_ln44_reg_261 : STD_LOGIC_VECTOR (16 downto 0);
    signal io_acc_block_signal_op42 : STD_LOGIC;
    signal io_acc_block_signal_op47 : STD_LOGIC;
    signal ap_block_state3_pp0_stage0_iter0 : BOOLEAN;
    signal io_acc_block_signal_op62 : STD_LOGIC;
    signal ap_block_state4_pp0_stage0_iter1 : BOOLEAN;
    signal ap_block_pp0_stage0_11001 : BOOLEAN;
    signal ptr_V_fu_248_p3 : STD_LOGIC_VECTOR (15 downto 0);
    signal ptr_V_reg_295 : STD_LOGIC_VECTOR (15 downto 0);
    signal ap_block_pp0_stage0_subdone : BOOLEAN;
    signal ap_phi_mux_last_1_phi_fu_157_p4 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_phi_mux_p_0101_0_phi_fu_135_p4 : STD_LOGIC_VECTOR (15 downto 0);
    signal ap_phi_mux_last_0_phi_fu_146_p4 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_phi_reg_pp0_iter0_last_1_reg_153 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_phi_reg_pp0_iter0_tmp_tkeep_V_reg_165 : STD_LOGIC_VECTOR (15 downto 0);
    signal ap_phi_reg_pp0_iter1_tmp_tkeep_V_reg_165 : STD_LOGIC_VECTOR (15 downto 0);
    signal ap_phi_reg_pp0_iter0_tmp_tlast_V_reg_175 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_phi_reg_pp0_iter1_tmp_tlast_V_reg_175 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_phi_reg_pp0_iter0_tmp_data_V_reg_187 : STD_LOGIC_VECTOR (127 downto 0);
    signal ap_phi_reg_pp0_iter1_tmp_data_V_reg_187 : STD_LOGIC_VECTOR (127 downto 0);
    signal ap_block_pp0_stage0_01001 : BOOLEAN;
    signal zext_ln215_fu_227_p1 : STD_LOGIC_VECTOR (16 downto 0);
    signal ret_V_fu_231_p2 : STD_LOGIC_VECTOR (16 downto 0);
    signal icmp_ln891_fu_237_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal add_ln215_fu_242_p2 : STD_LOGIC_VECTOR (15 downto 0);
    signal ap_NS_fsm : STD_LOGIC_VECTOR (3 downto 0);
    signal ap_idle_pp0 : STD_LOGIC;
    signal ap_enable_pp0 : STD_LOGIC;
    signal ap_condition_70 : BOOLEAN;
    signal ap_condition_155 : BOOLEAN;


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
                if (((ap_phi_mux_last_1_phi_fu_157_p4 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))) then 
                    ap_enable_reg_pp0_iter0 <= ap_const_logic_0;
                elsif ((not(((ctrl_buf_depth_empty_n = ap_const_logic_0) or (ctrl_depth_empty_n = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
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
                elsif ((not(((ctrl_buf_depth_empty_n = ap_const_logic_0) or (ctrl_depth_empty_n = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
                    ap_enable_reg_pp0_iter1 <= ap_const_logic_0;
                end if; 
            end if;
        end if;
    end process;


    ap_phi_reg_pp0_iter1_tmp_data_V_reg_187_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_155)) then
                if ((icmp_ln887_fu_201_p2 = ap_const_lv1_0)) then 
                    ap_phi_reg_pp0_iter1_tmp_data_V_reg_187 <= din_0_dout;
                elsif ((icmp_ln887_fu_201_p2 = ap_const_lv1_1)) then 
                    ap_phi_reg_pp0_iter1_tmp_data_V_reg_187 <= din_buf_0_dout;
                elsif ((ap_const_boolean_1 = ap_const_boolean_1)) then 
                    ap_phi_reg_pp0_iter1_tmp_data_V_reg_187 <= ap_phi_reg_pp0_iter0_tmp_data_V_reg_187;
                end if;
            end if; 
        end if;
    end process;

    ap_phi_reg_pp0_iter1_tmp_tkeep_V_reg_165_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_155)) then
                if ((icmp_ln887_fu_201_p2 = ap_const_lv1_0)) then 
                    ap_phi_reg_pp0_iter1_tmp_tkeep_V_reg_165 <= din_2_dout;
                elsif ((icmp_ln887_fu_201_p2 = ap_const_lv1_1)) then 
                    ap_phi_reg_pp0_iter1_tmp_tkeep_V_reg_165 <= din_buf_2_dout;
                elsif ((ap_const_boolean_1 = ap_const_boolean_1)) then 
                    ap_phi_reg_pp0_iter1_tmp_tkeep_V_reg_165 <= ap_phi_reg_pp0_iter0_tmp_tkeep_V_reg_165;
                end if;
            end if; 
        end if;
    end process;

    ap_phi_reg_pp0_iter1_tmp_tlast_V_reg_175_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_155)) then
                if ((icmp_ln887_fu_201_p2 = ap_const_lv1_0)) then 
                    ap_phi_reg_pp0_iter1_tmp_tlast_V_reg_175 <= din_1_dout;
                elsif ((icmp_ln887_fu_201_p2 = ap_const_lv1_1)) then 
                    ap_phi_reg_pp0_iter1_tmp_tlast_V_reg_175 <= ap_const_lv1_0;
                elsif ((ap_const_boolean_1 = ap_const_boolean_1)) then 
                    ap_phi_reg_pp0_iter1_tmp_tlast_V_reg_175 <= ap_phi_reg_pp0_iter0_tmp_tlast_V_reg_175;
                end if;
            end if; 
        end if;
    end process;

    last_0_reg_142_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((last_1_reg_153 = ap_const_lv1_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
                last_0_reg_142 <= last_1_reg_153;
            elsif ((not(((ctrl_buf_depth_empty_n = ap_const_logic_0) or (ctrl_depth_empty_n = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
                last_0_reg_142 <= ap_const_lv1_0;
            end if; 
        end if;
    end process;

    last_1_reg_153_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_155)) then
                if ((icmp_ln887_fu_201_p2 = ap_const_lv1_0)) then 
                    last_1_reg_153 <= din_1_dout;
                elsif ((icmp_ln887_fu_201_p2 = ap_const_lv1_1)) then 
                    last_1_reg_153 <= ap_phi_mux_last_0_phi_fu_146_p4;
                elsif ((ap_const_boolean_1 = ap_const_boolean_1)) then 
                    last_1_reg_153 <= ap_phi_reg_pp0_iter0_last_1_reg_153;
                end if;
            end if; 
        end if;
    end process;

    p_0101_0_reg_131_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((last_1_reg_153 = ap_const_lv1_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
                p_0101_0_reg_131 <= ptr_V_reg_295;
            elsif ((not(((ctrl_buf_depth_empty_n = ap_const_logic_0) or (ctrl_depth_empty_n = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
                p_0101_0_reg_131 <= ap_const_lv16_0;
            end if; 
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then
                ptr_V_reg_295 <= ptr_V_fu_248_p3;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((not(((ctrl_buf_depth_empty_n = ap_const_logic_0) or (ctrl_depth_empty_n = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then
                val_V_1_reg_256 <= ctrl_buf_depth_dout;
                    zext_ln44_reg_261(15 downto 0) <= zext_ln44_fu_197_p1(15 downto 0);
            end if;
        end if;
    end process;
    zext_ln44_reg_261(16) <= '0';

    ap_NS_fsm_assign_proc : process (ctrl_depth_empty_n, ctrl_buf_depth_empty_n, ap_CS_fsm, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_enable_reg_pp0_iter1, ap_CS_fsm_state2, ap_block_pp0_stage0_subdone)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state2 => 
                if ((not(((ctrl_buf_depth_empty_n = ap_const_logic_0) or (ctrl_depth_empty_n = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then
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
    add_ln215_fu_242_p2 <= std_logic_vector(unsigned(ap_phi_mux_p_0101_0_phi_fu_135_p4) + unsigned(ap_const_lv16_1));
    ap_CS_fsm_pp0_stage0 <= ap_CS_fsm(2);
    ap_CS_fsm_state2 <= ap_CS_fsm(1);
        ap_block_pp0_stage0 <= not((ap_const_boolean_1 = ap_const_boolean_1));

    ap_block_pp0_stage0_01001_assign_proc : process(ap_enable_reg_pp0_iter0, icmp_ln887_fu_201_p2, ap_enable_reg_pp0_iter1, io_acc_block_signal_op42, io_acc_block_signal_op47, io_acc_block_signal_op62)
    begin
                ap_block_pp0_stage0_01001 <= (((io_acc_block_signal_op62 = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1)) or ((ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (((icmp_ln887_fu_201_p2 = ap_const_lv1_0) and (io_acc_block_signal_op42 = ap_const_logic_0)) or ((icmp_ln887_fu_201_p2 = ap_const_lv1_1) and (io_acc_block_signal_op47 = ap_const_logic_0)))));
    end process;


    ap_block_pp0_stage0_11001_assign_proc : process(ap_enable_reg_pp0_iter0, icmp_ln887_fu_201_p2, ap_enable_reg_pp0_iter1, io_acc_block_signal_op42, io_acc_block_signal_op47, io_acc_block_signal_op62)
    begin
                ap_block_pp0_stage0_11001 <= (((io_acc_block_signal_op62 = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1)) or ((ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (((icmp_ln887_fu_201_p2 = ap_const_lv1_0) and (io_acc_block_signal_op42 = ap_const_logic_0)) or ((icmp_ln887_fu_201_p2 = ap_const_lv1_1) and (io_acc_block_signal_op47 = ap_const_logic_0)))));
    end process;


    ap_block_pp0_stage0_subdone_assign_proc : process(ap_enable_reg_pp0_iter0, icmp_ln887_fu_201_p2, ap_enable_reg_pp0_iter1, io_acc_block_signal_op42, io_acc_block_signal_op47, io_acc_block_signal_op62)
    begin
                ap_block_pp0_stage0_subdone <= (((io_acc_block_signal_op62 = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1)) or ((ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (((icmp_ln887_fu_201_p2 = ap_const_lv1_0) and (io_acc_block_signal_op42 = ap_const_logic_0)) or ((icmp_ln887_fu_201_p2 = ap_const_lv1_1) and (io_acc_block_signal_op47 = ap_const_logic_0)))));
    end process;


    ap_block_state2_assign_proc : process(ctrl_depth_empty_n, ctrl_buf_depth_empty_n)
    begin
                ap_block_state2 <= ((ctrl_buf_depth_empty_n = ap_const_logic_0) or (ctrl_depth_empty_n = ap_const_logic_0));
    end process;


    ap_block_state3_pp0_stage0_iter0_assign_proc : process(icmp_ln887_fu_201_p2, io_acc_block_signal_op42, io_acc_block_signal_op47)
    begin
                ap_block_state3_pp0_stage0_iter0 <= (((icmp_ln887_fu_201_p2 = ap_const_lv1_0) and (io_acc_block_signal_op42 = ap_const_logic_0)) or ((icmp_ln887_fu_201_p2 = ap_const_lv1_1) and (io_acc_block_signal_op47 = ap_const_logic_0)));
    end process;


    ap_block_state4_pp0_stage0_iter1_assign_proc : process(io_acc_block_signal_op62)
    begin
                ap_block_state4_pp0_stage0_iter1 <= (io_acc_block_signal_op62 = ap_const_logic_0);
    end process;


    ap_condition_155_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0_11001)
    begin
                ap_condition_155 <= ((ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001));
    end process;


    ap_condition_70_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0)
    begin
                ap_condition_70 <= ((ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0));
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


    ap_phi_mux_last_0_phi_fu_146_p4_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0, ap_enable_reg_pp0_iter1, last_0_reg_142, last_1_reg_153)
    begin
        if (((last_1_reg_153 = ap_const_lv1_0) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            ap_phi_mux_last_0_phi_fu_146_p4 <= last_1_reg_153;
        else 
            ap_phi_mux_last_0_phi_fu_146_p4 <= last_0_reg_142;
        end if; 
    end process;


    ap_phi_mux_last_1_phi_fu_157_p4_assign_proc : process(din_1_dout, icmp_ln887_fu_201_p2, ap_phi_mux_last_0_phi_fu_146_p4, ap_phi_reg_pp0_iter0_last_1_reg_153, ap_condition_70)
    begin
        if ((ap_const_boolean_1 = ap_condition_70)) then
            if ((icmp_ln887_fu_201_p2 = ap_const_lv1_0)) then 
                ap_phi_mux_last_1_phi_fu_157_p4 <= din_1_dout;
            elsif ((icmp_ln887_fu_201_p2 = ap_const_lv1_1)) then 
                ap_phi_mux_last_1_phi_fu_157_p4 <= ap_phi_mux_last_0_phi_fu_146_p4;
            else 
                ap_phi_mux_last_1_phi_fu_157_p4 <= ap_phi_reg_pp0_iter0_last_1_reg_153;
            end if;
        else 
            ap_phi_mux_last_1_phi_fu_157_p4 <= ap_phi_reg_pp0_iter0_last_1_reg_153;
        end if; 
    end process;


    ap_phi_mux_p_0101_0_phi_fu_135_p4_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0, ap_enable_reg_pp0_iter1, p_0101_0_reg_131, last_1_reg_153, ptr_V_reg_295)
    begin
        if (((last_1_reg_153 = ap_const_lv1_0) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            ap_phi_mux_p_0101_0_phi_fu_135_p4 <= ptr_V_reg_295;
        else 
            ap_phi_mux_p_0101_0_phi_fu_135_p4 <= p_0101_0_reg_131;
        end if; 
    end process;

    ap_phi_reg_pp0_iter0_last_1_reg_153 <= "X";
    ap_phi_reg_pp0_iter0_tmp_data_V_reg_187 <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    ap_phi_reg_pp0_iter0_tmp_tkeep_V_reg_165 <= "XXXXXXXXXXXXXXXX";
    ap_phi_reg_pp0_iter0_tmp_tlast_V_reg_175 <= "X";

    ctrl_buf_depth_blk_n_assign_proc : process(ctrl_buf_depth_empty_n, ap_CS_fsm_state2)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            ctrl_buf_depth_blk_n <= ctrl_buf_depth_empty_n;
        else 
            ctrl_buf_depth_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    ctrl_buf_depth_read_assign_proc : process(ctrl_depth_empty_n, ctrl_buf_depth_empty_n, ap_CS_fsm_state2)
    begin
        if ((not(((ctrl_buf_depth_empty_n = ap_const_logic_0) or (ctrl_depth_empty_n = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            ctrl_buf_depth_read <= ap_const_logic_1;
        else 
            ctrl_buf_depth_read <= ap_const_logic_0;
        end if; 
    end process;


    ctrl_depth_blk_n_assign_proc : process(ctrl_depth_empty_n, ap_CS_fsm_state2)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            ctrl_depth_blk_n <= ctrl_depth_empty_n;
        else 
            ctrl_depth_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    ctrl_depth_read_assign_proc : process(ctrl_depth_empty_n, ctrl_buf_depth_empty_n, ap_CS_fsm_state2)
    begin
        if ((not(((ctrl_buf_depth_empty_n = ap_const_logic_0) or (ctrl_depth_empty_n = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            ctrl_depth_read <= ap_const_logic_1;
        else 
            ctrl_depth_read <= ap_const_logic_0;
        end if; 
    end process;


    din_0_blk_n_assign_proc : process(din_0_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0, icmp_ln887_fu_201_p2)
    begin
        if (((icmp_ln887_fu_201_p2 = ap_const_lv1_0) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            din_0_blk_n <= din_0_empty_n;
        else 
            din_0_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_0_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, icmp_ln887_fu_201_p2, ap_block_pp0_stage0_11001)
    begin
        if (((icmp_ln887_fu_201_p2 = ap_const_lv1_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            din_0_read <= ap_const_logic_1;
        else 
            din_0_read <= ap_const_logic_0;
        end if; 
    end process;


    din_1_blk_n_assign_proc : process(din_1_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0, icmp_ln887_fu_201_p2)
    begin
        if (((icmp_ln887_fu_201_p2 = ap_const_lv1_0) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            din_1_blk_n <= din_1_empty_n;
        else 
            din_1_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_1_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, icmp_ln887_fu_201_p2, ap_block_pp0_stage0_11001)
    begin
        if (((icmp_ln887_fu_201_p2 = ap_const_lv1_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            din_1_read <= ap_const_logic_1;
        else 
            din_1_read <= ap_const_logic_0;
        end if; 
    end process;


    din_2_blk_n_assign_proc : process(din_2_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0, icmp_ln887_fu_201_p2)
    begin
        if (((icmp_ln887_fu_201_p2 = ap_const_lv1_0) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            din_2_blk_n <= din_2_empty_n;
        else 
            din_2_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_2_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, icmp_ln887_fu_201_p2, ap_block_pp0_stage0_11001)
    begin
        if (((icmp_ln887_fu_201_p2 = ap_const_lv1_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            din_2_read <= ap_const_logic_1;
        else 
            din_2_read <= ap_const_logic_0;
        end if; 
    end process;


    din_buf_0_blk_n_assign_proc : process(din_buf_0_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0, icmp_ln887_fu_201_p2)
    begin
        if (((icmp_ln887_fu_201_p2 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            din_buf_0_blk_n <= din_buf_0_empty_n;
        else 
            din_buf_0_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_buf_0_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, icmp_ln887_fu_201_p2, ap_block_pp0_stage0_11001)
    begin
        if (((icmp_ln887_fu_201_p2 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            din_buf_0_read <= ap_const_logic_1;
        else 
            din_buf_0_read <= ap_const_logic_0;
        end if; 
    end process;


    din_buf_1_blk_n_assign_proc : process(din_buf_1_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0, icmp_ln887_fu_201_p2)
    begin
        if (((icmp_ln887_fu_201_p2 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            din_buf_1_blk_n <= din_buf_1_empty_n;
        else 
            din_buf_1_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_buf_1_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, icmp_ln887_fu_201_p2, ap_block_pp0_stage0_11001)
    begin
        if (((icmp_ln887_fu_201_p2 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            din_buf_1_read <= ap_const_logic_1;
        else 
            din_buf_1_read <= ap_const_logic_0;
        end if; 
    end process;


    din_buf_2_blk_n_assign_proc : process(din_buf_2_empty_n, ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0, icmp_ln887_fu_201_p2)
    begin
        if (((icmp_ln887_fu_201_p2 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_pp0_stage0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            din_buf_2_blk_n <= din_buf_2_empty_n;
        else 
            din_buf_2_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    din_buf_2_read_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, icmp_ln887_fu_201_p2, ap_block_pp0_stage0_11001)
    begin
        if (((icmp_ln887_fu_201_p2 = ap_const_lv1_1) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            din_buf_2_read <= ap_const_logic_1;
        else 
            din_buf_2_read <= ap_const_logic_0;
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

    dout_0_din <= ap_phi_reg_pp0_iter1_tmp_data_V_reg_187;

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

    dout_1_din <= ap_phi_reg_pp0_iter1_tmp_tlast_V_reg_175;

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

    dout_2_din <= ap_phi_reg_pp0_iter1_tmp_tkeep_V_reg_165;

    dout_2_write_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0_11001)
    begin
        if (((ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            dout_2_write <= ap_const_logic_1;
        else 
            dout_2_write <= ap_const_logic_0;
        end if; 
    end process;

    icmp_ln887_fu_201_p2 <= "1" when (unsigned(ap_phi_mux_p_0101_0_phi_fu_135_p4) < unsigned(val_V_1_reg_256)) else "0";
    icmp_ln891_fu_237_p2 <= "1" when (unsigned(ret_V_fu_231_p2) < unsigned(zext_ln44_reg_261)) else "0";
    io_acc_block_signal_op42 <= (din_2_empty_n and din_1_empty_n and din_0_empty_n);
    io_acc_block_signal_op47 <= (din_buf_2_empty_n and din_buf_1_empty_n and din_buf_0_empty_n);
    io_acc_block_signal_op62 <= (dout_2_full_n and dout_1_full_n and dout_0_full_n);
    ptr_V_fu_248_p3 <= 
        add_ln215_fu_242_p2 when (icmp_ln891_fu_237_p2(0) = '1') else 
        ap_const_lv16_0;
    ret_V_fu_231_p2 <= std_logic_vector(unsigned(zext_ln215_fu_227_p1) + unsigned(ap_const_lv17_1));
    zext_ln215_fu_227_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(ap_phi_mux_p_0101_0_phi_fu_135_p4),17));
    zext_ln44_fu_197_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(ctrl_depth_dout),17));
end behav;