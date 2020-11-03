-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2019.1
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cnn_thread_cnn_stream_sink is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    data_sink_0_dout : IN STD_LOGIC_VECTOR (63 downto 0);
    data_sink_0_empty_n : IN STD_LOGIC;
    data_sink_0_read : OUT STD_LOGIC;
    data_sink_1_dout : IN STD_LOGIC_VECTOR (0 downto 0);
    data_sink_1_empty_n : IN STD_LOGIC;
    data_sink_1_read : OUT STD_LOGIC;
    data_sink_2_dout : IN STD_LOGIC_VECTOR (7 downto 0);
    data_sink_2_empty_n : IN STD_LOGIC;
    data_sink_2_read : OUT STD_LOGIC;
    sc_fifo_chn_3_din : OUT STD_LOGIC_VECTOR (63 downto 0);
    sc_fifo_chn_3_full_n : IN STD_LOGIC;
    sc_fifo_chn_3_write : OUT STD_LOGIC;
    sc_fifo_chn_4_din : OUT STD_LOGIC_VECTOR (0 downto 0);
    sc_fifo_chn_4_full_n : IN STD_LOGIC;
    sc_fifo_chn_4_write : OUT STD_LOGIC;
    sc_fifo_chn_5_din : OUT STD_LOGIC_VECTOR (7 downto 0);
    sc_fifo_chn_5_full_n : IN STD_LOGIC;
    sc_fifo_chn_5_write : OUT STD_LOGIC );
end;


architecture behav of cnn_thread_cnn_stream_sink is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state2 : STD_LOGIC_VECTOR (1 downto 0) := "10";
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_boolean_1 : BOOLEAN := true;

    signal data_sink_0_blk_n : STD_LOGIC;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (1 downto 0) := "10";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state2 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state2 : signal is "none";
    signal data_sink_1_blk_n : STD_LOGIC;
    signal data_sink_2_blk_n : STD_LOGIC;
    signal sc_fifo_chn_3_blk_n : STD_LOGIC;
    signal sc_fifo_chn_4_blk_n : STD_LOGIC;
    signal sc_fifo_chn_5_blk_n : STD_LOGIC;
    signal io_acc_block_signal_op1206 : STD_LOGIC;
    signal io_acc_block_signal_op1210 : STD_LOGIC;
    signal ap_block_state2 : BOOLEAN;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (1 downto 0);


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


    ap_NS_fsm_assign_proc : process (ap_CS_fsm, ap_CS_fsm_state2, io_acc_block_signal_op1206, io_acc_block_signal_op1210)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state2 => 
                ap_NS_fsm <= ap_ST_fsm_state2;
            when others =>  
                ap_NS_fsm <= "XX";
        end case;
    end process;
    ap_CS_fsm_state2 <= ap_CS_fsm(1);

    ap_block_state2_assign_proc : process(io_acc_block_signal_op1206, io_acc_block_signal_op1210)
    begin
                ap_block_state2 <= ((io_acc_block_signal_op1210 = ap_const_logic_0) or (io_acc_block_signal_op1206 = ap_const_logic_0));
    end process;


    data_sink_0_blk_n_assign_proc : process(data_sink_0_empty_n, ap_CS_fsm_state2)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            data_sink_0_blk_n <= data_sink_0_empty_n;
        else 
            data_sink_0_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    data_sink_0_read_assign_proc : process(ap_CS_fsm_state2, io_acc_block_signal_op1206, io_acc_block_signal_op1210)
    begin
        if ((not(((io_acc_block_signal_op1210 = ap_const_logic_0) or (io_acc_block_signal_op1206 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            data_sink_0_read <= ap_const_logic_1;
        else 
            data_sink_0_read <= ap_const_logic_0;
        end if; 
    end process;


    data_sink_1_blk_n_assign_proc : process(data_sink_1_empty_n, ap_CS_fsm_state2)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            data_sink_1_blk_n <= data_sink_1_empty_n;
        else 
            data_sink_1_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    data_sink_1_read_assign_proc : process(ap_CS_fsm_state2, io_acc_block_signal_op1206, io_acc_block_signal_op1210)
    begin
        if ((not(((io_acc_block_signal_op1210 = ap_const_logic_0) or (io_acc_block_signal_op1206 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            data_sink_1_read <= ap_const_logic_1;
        else 
            data_sink_1_read <= ap_const_logic_0;
        end if; 
    end process;


    data_sink_2_blk_n_assign_proc : process(data_sink_2_empty_n, ap_CS_fsm_state2)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            data_sink_2_blk_n <= data_sink_2_empty_n;
        else 
            data_sink_2_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    data_sink_2_read_assign_proc : process(ap_CS_fsm_state2, io_acc_block_signal_op1206, io_acc_block_signal_op1210)
    begin
        if ((not(((io_acc_block_signal_op1210 = ap_const_logic_0) or (io_acc_block_signal_op1206 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            data_sink_2_read <= ap_const_logic_1;
        else 
            data_sink_2_read <= ap_const_logic_0;
        end if; 
    end process;

    io_acc_block_signal_op1206 <= (data_sink_2_empty_n and data_sink_1_empty_n and data_sink_0_empty_n);
    io_acc_block_signal_op1210 <= (sc_fifo_chn_5_full_n and sc_fifo_chn_4_full_n and sc_fifo_chn_3_full_n);

    sc_fifo_chn_3_blk_n_assign_proc : process(sc_fifo_chn_3_full_n, ap_CS_fsm_state2)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            sc_fifo_chn_3_blk_n <= sc_fifo_chn_3_full_n;
        else 
            sc_fifo_chn_3_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    sc_fifo_chn_3_din <= data_sink_0_dout;

    sc_fifo_chn_3_write_assign_proc : process(ap_CS_fsm_state2, io_acc_block_signal_op1206, io_acc_block_signal_op1210)
    begin
        if ((not(((io_acc_block_signal_op1210 = ap_const_logic_0) or (io_acc_block_signal_op1206 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            sc_fifo_chn_3_write <= ap_const_logic_1;
        else 
            sc_fifo_chn_3_write <= ap_const_logic_0;
        end if; 
    end process;


    sc_fifo_chn_4_blk_n_assign_proc : process(sc_fifo_chn_4_full_n, ap_CS_fsm_state2)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            sc_fifo_chn_4_blk_n <= sc_fifo_chn_4_full_n;
        else 
            sc_fifo_chn_4_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    sc_fifo_chn_4_din <= data_sink_1_dout;

    sc_fifo_chn_4_write_assign_proc : process(ap_CS_fsm_state2, io_acc_block_signal_op1206, io_acc_block_signal_op1210)
    begin
        if ((not(((io_acc_block_signal_op1210 = ap_const_logic_0) or (io_acc_block_signal_op1206 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            sc_fifo_chn_4_write <= ap_const_logic_1;
        else 
            sc_fifo_chn_4_write <= ap_const_logic_0;
        end if; 
    end process;


    sc_fifo_chn_5_blk_n_assign_proc : process(sc_fifo_chn_5_full_n, ap_CS_fsm_state2)
    begin
        if ((ap_const_logic_1 = ap_CS_fsm_state2)) then 
            sc_fifo_chn_5_blk_n <= sc_fifo_chn_5_full_n;
        else 
            sc_fifo_chn_5_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    sc_fifo_chn_5_din <= data_sink_2_dout;

    sc_fifo_chn_5_write_assign_proc : process(ap_CS_fsm_state2, io_acc_block_signal_op1206, io_acc_block_signal_op1210)
    begin
        if ((not(((io_acc_block_signal_op1210 = ap_const_logic_0) or (io_acc_block_signal_op1206 = ap_const_logic_0))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            sc_fifo_chn_5_write <= ap_const_logic_1;
        else 
            sc_fifo_chn_5_write <= ap_const_logic_0;
        end if; 
    end process;

end behav;
