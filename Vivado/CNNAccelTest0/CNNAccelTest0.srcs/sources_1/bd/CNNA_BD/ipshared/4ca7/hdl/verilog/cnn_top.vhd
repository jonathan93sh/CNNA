-- ==============================================================
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.1 (64-bit)
-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity cnn_top is
    generic (
        C_S_AXI_SLV0_ADDR_WIDTH :  integer := 5;
        C_S_AXI_SLV0_DATA_WIDTH :  integer := 32;
        RESET_ACTIVE_LOW :  integer := 1
    );
    port (
        M_AXIS_Y_TVALID : out  std_logic;
        M_AXIS_Y_TREADY : in  std_logic;
        M_AXIS_Y_TDATA : out  std_logic_vector(128 - 1 downto 0);
        M_AXIS_Y_TLAST : out  std_logic_vector(1 - 1 downto 0);
        M_AXIS_Y_TKEEP : out  std_logic_vector(16 - 1 downto 0);
        S_AXIS_BUF_TVALID : in  std_logic;
        S_AXIS_BUF_TREADY : out  std_logic;
        S_AXIS_BUF_TDATA : in  std_logic_vector(128 - 1 downto 0);
        S_AXIS_BUF_TLAST : in  std_logic_vector(1 - 1 downto 0);
        S_AXIS_BUF_TKEEP : in  std_logic_vector(16 - 1 downto 0);
        S_AXIS_CTRL_TVALID : in  std_logic;
        S_AXIS_CTRL_TREADY : out  std_logic;
        S_AXIS_CTRL_TDATA : in  std_logic_vector(64 - 1 downto 0);
        S_AXIS_CTRL_TLAST : in  std_logic_vector(1 - 1 downto 0);
        S_AXIS_CTRL_TKEEP : in  std_logic_vector(8 - 1 downto 0);
        S_AXIS_W_TVALID : in  std_logic;
        S_AXIS_W_TREADY : out  std_logic;
        S_AXIS_W_TDATA : in  std_logic_vector(128 - 1 downto 0);
        S_AXIS_W_TLAST : in  std_logic_vector(1 - 1 downto 0);
        S_AXIS_W_TKEEP : in  std_logic_vector(16 - 1 downto 0);
        S_AXIS_X_TVALID : in  std_logic;
        S_AXIS_X_TREADY : out  std_logic;
        S_AXIS_X_TDATA : in  std_logic_vector(128 - 1 downto 0);
        S_AXIS_X_TLAST : in  std_logic_vector(1 - 1 downto 0);
        S_AXIS_X_TKEEP : in  std_logic_vector(16 - 1 downto 0);
        s_axi_slv0_AWADDR : in  std_logic_vector(C_S_AXI_SLV0_ADDR_WIDTH - 1 downto 0);
        s_axi_slv0_AWVALID : in  std_logic;
        s_axi_slv0_AWREADY : out  std_logic;
        s_axi_slv0_WDATA : in  std_logic_vector(C_S_AXI_SLV0_DATA_WIDTH - 1 downto 0);
        s_axi_slv0_WSTRB : in  std_logic_vector(C_S_AXI_SLV0_DATA_WIDTH/8 - 1 downto 0);
        s_axi_slv0_WVALID : in  std_logic;
        s_axi_slv0_WREADY : out  std_logic;
        s_axi_slv0_BRESP : out  std_logic_vector(2 - 1 downto 0);
        s_axi_slv0_BVALID : out  std_logic;
        s_axi_slv0_BREADY : in  std_logic;
        s_axi_slv0_ARADDR : in  std_logic_vector(C_S_AXI_SLV0_ADDR_WIDTH - 1 downto 0);
        s_axi_slv0_ARVALID : in  std_logic;
        s_axi_slv0_ARREADY : out  std_logic;
        s_axi_slv0_RDATA : out  std_logic_vector(C_S_AXI_SLV0_DATA_WIDTH - 1 downto 0);
        s_axi_slv0_RRESP : out  std_logic_vector(2 - 1 downto 0);
        s_axi_slv0_RVALID : out  std_logic;
        s_axi_slv0_RREADY : in  std_logic;
        aresetn : in  std_logic;
        aclk : in  std_logic
    );

-- attributes begin
-- attributes end
end entity;

architecture behav of cnn_top is
    component cnn is
        port (
            data_source_0_din : out  std_logic_vector(128 - 1 downto 0);
            data_source_0_full_n : in  std_logic;
            data_source_0_write : out  std_logic;
            data_source_1_din : out  std_logic_vector(1 - 1 downto 0);
            data_source_1_full_n : in  std_logic;
            data_source_1_write : out  std_logic;
            data_source_2_din : out  std_logic_vector(16 - 1 downto 0);
            data_source_2_full_n : in  std_logic;
            data_source_2_write : out  std_logic;
            data_buf_sink_0_dout : in  std_logic_vector(128 - 1 downto 0);
            data_buf_sink_0_empty_n : in  std_logic;
            data_buf_sink_0_read : out  std_logic;
            data_buf_sink_1_dout : in  std_logic_vector(1 - 1 downto 0);
            data_buf_sink_1_empty_n : in  std_logic;
            data_buf_sink_1_read : out  std_logic;
            data_buf_sink_2_dout : in  std_logic_vector(16 - 1 downto 0);
            data_buf_sink_2_empty_n : in  std_logic;
            data_buf_sink_2_read : out  std_logic;
            ctrl_sink_0_dout : in  std_logic_vector(64 - 1 downto 0);
            ctrl_sink_0_empty_n : in  std_logic;
            ctrl_sink_0_read : out  std_logic;
            ctrl_sink_1_dout : in  std_logic_vector(1 - 1 downto 0);
            ctrl_sink_1_empty_n : in  std_logic;
            ctrl_sink_1_read : out  std_logic;
            ctrl_sink_2_dout : in  std_logic_vector(8 - 1 downto 0);
            ctrl_sink_2_empty_n : in  std_logic;
            ctrl_sink_2_read : out  std_logic;
            w_sink_0_dout : in  std_logic_vector(128 - 1 downto 0);
            w_sink_0_empty_n : in  std_logic;
            w_sink_0_read : out  std_logic;
            w_sink_1_dout : in  std_logic_vector(1 - 1 downto 0);
            w_sink_1_empty_n : in  std_logic;
            w_sink_1_read : out  std_logic;
            w_sink_2_dout : in  std_logic_vector(16 - 1 downto 0);
            w_sink_2_empty_n : in  std_logic;
            w_sink_2_read : out  std_logic;
            data_sink_0_dout : in  std_logic_vector(128 - 1 downto 0);
            data_sink_0_empty_n : in  std_logic;
            data_sink_0_read : out  std_logic;
            data_sink_1_dout : in  std_logic_vector(1 - 1 downto 0);
            data_sink_1_empty_n : in  std_logic;
            data_sink_1_read : out  std_logic;
            data_sink_2_dout : in  std_logic_vector(16 - 1 downto 0);
            data_sink_2_empty_n : in  std_logic;
            data_sink_2_read : out  std_logic;
            status_add : in  std_logic_vector(32 - 1 downto 0);
            status_val : out  std_logic_vector(32 - 1 downto 0);
            reset : in  std_logic;
            clk : in  std_logic
        );
    end component;

    component cnn_M_AXIS_Y_if is
        port (
            ACLK :  in std_logic;
            ARESETN :  in std_logic;
            data_source_0_din :  in std_logic_vector(128 - 1 downto 0);
            data_source_0_full_n :  out std_logic;
            data_source_0_write :  in std_logic;
            data_source_1_din :  in std_logic_vector(1 - 1 downto 0);
            data_source_1_full_n :  out std_logic;
            data_source_1_write :  in std_logic;
            data_source_2_din :  in std_logic_vector(16 - 1 downto 0);
            data_source_2_full_n :  out std_logic;
            data_source_2_write :  in std_logic;
            TVALID :  out std_logic;
            TREADY :  in std_logic;
            TDATA :  out std_logic_vector(128 - 1 downto 0);
            TLAST :  out std_logic_vector(1 - 1 downto 0);
            TKEEP :  out std_logic_vector(16 - 1 downto 0));
    end component;

    component cnn_S_AXIS_BUF_if is
        port (
            ACLK :  in std_logic;
            ARESETN :  in std_logic;
            data_buf_sink_0_dout :  out std_logic_vector(128 - 1 downto 0);
            data_buf_sink_0_empty_n :  out std_logic;
            data_buf_sink_0_read :  in std_logic;
            data_buf_sink_1_dout :  out std_logic_vector(1 - 1 downto 0);
            data_buf_sink_1_empty_n :  out std_logic;
            data_buf_sink_1_read :  in std_logic;
            data_buf_sink_2_dout :  out std_logic_vector(16 - 1 downto 0);
            data_buf_sink_2_empty_n :  out std_logic;
            data_buf_sink_2_read :  in std_logic;
            TVALID :  in std_logic;
            TREADY :  out std_logic;
            TDATA :  in std_logic_vector(128 - 1 downto 0);
            TLAST :  in std_logic_vector(1 - 1 downto 0);
            TKEEP :  in std_logic_vector(16 - 1 downto 0));
    end component;

    component cnn_S_AXIS_CTRL_if is
        port (
            ACLK :  in std_logic;
            ARESETN :  in std_logic;
            ctrl_sink_0_dout :  out std_logic_vector(64 - 1 downto 0);
            ctrl_sink_0_empty_n :  out std_logic;
            ctrl_sink_0_read :  in std_logic;
            ctrl_sink_1_dout :  out std_logic_vector(1 - 1 downto 0);
            ctrl_sink_1_empty_n :  out std_logic;
            ctrl_sink_1_read :  in std_logic;
            ctrl_sink_2_dout :  out std_logic_vector(8 - 1 downto 0);
            ctrl_sink_2_empty_n :  out std_logic;
            ctrl_sink_2_read :  in std_logic;
            TVALID :  in std_logic;
            TREADY :  out std_logic;
            TDATA :  in std_logic_vector(64 - 1 downto 0);
            TLAST :  in std_logic_vector(1 - 1 downto 0);
            TKEEP :  in std_logic_vector(8 - 1 downto 0));
    end component;

    component cnn_S_AXIS_W_if is
        port (
            ACLK :  in std_logic;
            ARESETN :  in std_logic;
            w_sink_0_dout :  out std_logic_vector(128 - 1 downto 0);
            w_sink_0_empty_n :  out std_logic;
            w_sink_0_read :  in std_logic;
            w_sink_1_dout :  out std_logic_vector(1 - 1 downto 0);
            w_sink_1_empty_n :  out std_logic;
            w_sink_1_read :  in std_logic;
            w_sink_2_dout :  out std_logic_vector(16 - 1 downto 0);
            w_sink_2_empty_n :  out std_logic;
            w_sink_2_read :  in std_logic;
            TVALID :  in std_logic;
            TREADY :  out std_logic;
            TDATA :  in std_logic_vector(128 - 1 downto 0);
            TLAST :  in std_logic_vector(1 - 1 downto 0);
            TKEEP :  in std_logic_vector(16 - 1 downto 0));
    end component;

    component cnn_S_AXIS_X_if is
        port (
            ACLK :  in std_logic;
            ARESETN :  in std_logic;
            data_sink_0_dout :  out std_logic_vector(128 - 1 downto 0);
            data_sink_0_empty_n :  out std_logic;
            data_sink_0_read :  in std_logic;
            data_sink_1_dout :  out std_logic_vector(1 - 1 downto 0);
            data_sink_1_empty_n :  out std_logic;
            data_sink_1_read :  in std_logic;
            data_sink_2_dout :  out std_logic_vector(16 - 1 downto 0);
            data_sink_2_empty_n :  out std_logic;
            data_sink_2_read :  in std_logic;
            TVALID :  in std_logic;
            TREADY :  out std_logic;
            TDATA :  in std_logic_vector(128 - 1 downto 0);
            TLAST :  in std_logic_vector(1 - 1 downto 0);
            TKEEP :  in std_logic_vector(16 - 1 downto 0));
    end component;

    component cnn_slv0_if is
        generic (
            C_ADDR_WIDTH :  integer;
            C_DATA_WIDTH :  integer);
        port (
            ACLK :  in std_logic;
            ARESETN :  in std_logic;
            I_status_add :  out std_logic_vector(32 - 1 downto 0);
            O_status_val :  in std_logic_vector(32 - 1 downto 0);
            AWADDR :  in std_logic_vector(C_S_AXI_SLV0_ADDR_WIDTH - 1 downto 0);
            AWVALID :  in std_logic;
            AWREADY :  out std_logic;
            WDATA :  in std_logic_vector(C_S_AXI_SLV0_DATA_WIDTH - 1 downto 0);
            WSTRB :  in std_logic_vector(C_S_AXI_SLV0_DATA_WIDTH/8 - 1 downto 0);
            WVALID :  in std_logic;
            WREADY :  out std_logic;
            BRESP :  out std_logic_vector(2 - 1 downto 0);
            BVALID :  out std_logic;
            BREADY :  in std_logic;
            ARADDR :  in std_logic_vector(C_S_AXI_SLV0_ADDR_WIDTH - 1 downto 0);
            ARVALID :  in std_logic;
            ARREADY :  out std_logic;
            RDATA :  out std_logic_vector(C_S_AXI_SLV0_DATA_WIDTH - 1 downto 0);
            RRESP :  out std_logic_vector(2 - 1 downto 0);
            RVALID :  out std_logic;
            RREADY :  in std_logic);
    end component;

    component cnn_reset_if is
        generic (
            RESET_ACTIVE_LOW :  integer);
        port (
            dout :  out std_logic;
            din :  in std_logic);
    end component;

    signal sig_cnn_data_source_0_din :  std_logic_vector(128 - 1 downto 0);
    signal sig_cnn_data_source_0_full_n :  std_logic;
    signal sig_cnn_data_source_0_write :  std_logic;
    signal sig_cnn_data_source_1_din :  std_logic_vector(1 - 1 downto 0);
    signal sig_cnn_data_source_1_full_n :  std_logic;
    signal sig_cnn_data_source_1_write :  std_logic;
    signal sig_cnn_data_source_2_din :  std_logic_vector(16 - 1 downto 0);
    signal sig_cnn_data_source_2_full_n :  std_logic;
    signal sig_cnn_data_source_2_write :  std_logic;
    signal sig_cnn_data_buf_sink_0_dout :  std_logic_vector(128 - 1 downto 0);
    signal sig_cnn_data_buf_sink_0_empty_n :  std_logic;
    signal sig_cnn_data_buf_sink_0_read :  std_logic;
    signal sig_cnn_data_buf_sink_1_dout :  std_logic_vector(1 - 1 downto 0);
    signal sig_cnn_data_buf_sink_1_empty_n :  std_logic;
    signal sig_cnn_data_buf_sink_1_read :  std_logic;
    signal sig_cnn_data_buf_sink_2_dout :  std_logic_vector(16 - 1 downto 0);
    signal sig_cnn_data_buf_sink_2_empty_n :  std_logic;
    signal sig_cnn_data_buf_sink_2_read :  std_logic;
    signal sig_cnn_ctrl_sink_0_dout :  std_logic_vector(64 - 1 downto 0);
    signal sig_cnn_ctrl_sink_0_empty_n :  std_logic;
    signal sig_cnn_ctrl_sink_0_read :  std_logic;
    signal sig_cnn_ctrl_sink_1_dout :  std_logic_vector(1 - 1 downto 0);
    signal sig_cnn_ctrl_sink_1_empty_n :  std_logic;
    signal sig_cnn_ctrl_sink_1_read :  std_logic;
    signal sig_cnn_ctrl_sink_2_dout :  std_logic_vector(8 - 1 downto 0);
    signal sig_cnn_ctrl_sink_2_empty_n :  std_logic;
    signal sig_cnn_ctrl_sink_2_read :  std_logic;
    signal sig_cnn_w_sink_0_dout :  std_logic_vector(128 - 1 downto 0);
    signal sig_cnn_w_sink_0_empty_n :  std_logic;
    signal sig_cnn_w_sink_0_read :  std_logic;
    signal sig_cnn_w_sink_1_dout :  std_logic_vector(1 - 1 downto 0);
    signal sig_cnn_w_sink_1_empty_n :  std_logic;
    signal sig_cnn_w_sink_1_read :  std_logic;
    signal sig_cnn_w_sink_2_dout :  std_logic_vector(16 - 1 downto 0);
    signal sig_cnn_w_sink_2_empty_n :  std_logic;
    signal sig_cnn_w_sink_2_read :  std_logic;
    signal sig_cnn_data_sink_0_dout :  std_logic_vector(128 - 1 downto 0);
    signal sig_cnn_data_sink_0_empty_n :  std_logic;
    signal sig_cnn_data_sink_0_read :  std_logic;
    signal sig_cnn_data_sink_1_dout :  std_logic_vector(1 - 1 downto 0);
    signal sig_cnn_data_sink_1_empty_n :  std_logic;
    signal sig_cnn_data_sink_1_read :  std_logic;
    signal sig_cnn_data_sink_2_dout :  std_logic_vector(16 - 1 downto 0);
    signal sig_cnn_data_sink_2_empty_n :  std_logic;
    signal sig_cnn_data_sink_2_read :  std_logic;
    signal sig_cnn_status_add :  std_logic_vector(32 - 1 downto 0);
    signal sig_cnn_status_val :  std_logic_vector(32 - 1 downto 0);
    signal sig_cnn_reset :  std_logic;

begin
    cnn_U  : component cnn
        port map (
            data_source_0_din => sig_cnn_data_source_0_din,
            data_source_0_full_n => sig_cnn_data_source_0_full_n,
            data_source_0_write => sig_cnn_data_source_0_write,
            data_source_1_din => sig_cnn_data_source_1_din,
            data_source_1_full_n => sig_cnn_data_source_1_full_n,
            data_source_1_write => sig_cnn_data_source_1_write,
            data_source_2_din => sig_cnn_data_source_2_din,
            data_source_2_full_n => sig_cnn_data_source_2_full_n,
            data_source_2_write => sig_cnn_data_source_2_write,
            data_buf_sink_0_dout => sig_cnn_data_buf_sink_0_dout,
            data_buf_sink_0_empty_n => sig_cnn_data_buf_sink_0_empty_n,
            data_buf_sink_0_read => sig_cnn_data_buf_sink_0_read,
            data_buf_sink_1_dout => sig_cnn_data_buf_sink_1_dout,
            data_buf_sink_1_empty_n => sig_cnn_data_buf_sink_1_empty_n,
            data_buf_sink_1_read => sig_cnn_data_buf_sink_1_read,
            data_buf_sink_2_dout => sig_cnn_data_buf_sink_2_dout,
            data_buf_sink_2_empty_n => sig_cnn_data_buf_sink_2_empty_n,
            data_buf_sink_2_read => sig_cnn_data_buf_sink_2_read,
            ctrl_sink_0_dout => sig_cnn_ctrl_sink_0_dout,
            ctrl_sink_0_empty_n => sig_cnn_ctrl_sink_0_empty_n,
            ctrl_sink_0_read => sig_cnn_ctrl_sink_0_read,
            ctrl_sink_1_dout => sig_cnn_ctrl_sink_1_dout,
            ctrl_sink_1_empty_n => sig_cnn_ctrl_sink_1_empty_n,
            ctrl_sink_1_read => sig_cnn_ctrl_sink_1_read,
            ctrl_sink_2_dout => sig_cnn_ctrl_sink_2_dout,
            ctrl_sink_2_empty_n => sig_cnn_ctrl_sink_2_empty_n,
            ctrl_sink_2_read => sig_cnn_ctrl_sink_2_read,
            w_sink_0_dout => sig_cnn_w_sink_0_dout,
            w_sink_0_empty_n => sig_cnn_w_sink_0_empty_n,
            w_sink_0_read => sig_cnn_w_sink_0_read,
            w_sink_1_dout => sig_cnn_w_sink_1_dout,
            w_sink_1_empty_n => sig_cnn_w_sink_1_empty_n,
            w_sink_1_read => sig_cnn_w_sink_1_read,
            w_sink_2_dout => sig_cnn_w_sink_2_dout,
            w_sink_2_empty_n => sig_cnn_w_sink_2_empty_n,
            w_sink_2_read => sig_cnn_w_sink_2_read,
            data_sink_0_dout => sig_cnn_data_sink_0_dout,
            data_sink_0_empty_n => sig_cnn_data_sink_0_empty_n,
            data_sink_0_read => sig_cnn_data_sink_0_read,
            data_sink_1_dout => sig_cnn_data_sink_1_dout,
            data_sink_1_empty_n => sig_cnn_data_sink_1_empty_n,
            data_sink_1_read => sig_cnn_data_sink_1_read,
            data_sink_2_dout => sig_cnn_data_sink_2_dout,
            data_sink_2_empty_n => sig_cnn_data_sink_2_empty_n,
            data_sink_2_read => sig_cnn_data_sink_2_read,
            status_add => sig_cnn_status_add,
            status_val => sig_cnn_status_val,
            reset => sig_cnn_reset,
            clk => aclk
        );

    cnn_M_AXIS_Y_if_U : component cnn_M_AXIS_Y_if
        port map (
            ACLK => aclk,
            ARESETN => aresetn,
            data_source_0_din => sig_cnn_data_source_0_din,
            data_source_0_full_n => sig_cnn_data_source_0_full_n,
            data_source_0_write => sig_cnn_data_source_0_write,
            data_source_1_din => sig_cnn_data_source_1_din,
            data_source_1_full_n => sig_cnn_data_source_1_full_n,
            data_source_1_write => sig_cnn_data_source_1_write,
            data_source_2_din => sig_cnn_data_source_2_din,
            data_source_2_full_n => sig_cnn_data_source_2_full_n,
            data_source_2_write => sig_cnn_data_source_2_write,
            TVALID => M_AXIS_Y_TVALID,
            TREADY => M_AXIS_Y_TREADY,
            TDATA => M_AXIS_Y_TDATA,
            TLAST => M_AXIS_Y_TLAST,
            TKEEP => M_AXIS_Y_TKEEP);

    cnn_S_AXIS_BUF_if_U : component cnn_S_AXIS_BUF_if
        port map (
            ACLK => aclk,
            ARESETN => aresetn,
            data_buf_sink_0_dout => sig_cnn_data_buf_sink_0_dout,
            data_buf_sink_0_empty_n => sig_cnn_data_buf_sink_0_empty_n,
            data_buf_sink_0_read => sig_cnn_data_buf_sink_0_read,
            data_buf_sink_1_dout => sig_cnn_data_buf_sink_1_dout,
            data_buf_sink_1_empty_n => sig_cnn_data_buf_sink_1_empty_n,
            data_buf_sink_1_read => sig_cnn_data_buf_sink_1_read,
            data_buf_sink_2_dout => sig_cnn_data_buf_sink_2_dout,
            data_buf_sink_2_empty_n => sig_cnn_data_buf_sink_2_empty_n,
            data_buf_sink_2_read => sig_cnn_data_buf_sink_2_read,
            TVALID => S_AXIS_BUF_TVALID,
            TREADY => S_AXIS_BUF_TREADY,
            TDATA => S_AXIS_BUF_TDATA,
            TLAST => S_AXIS_BUF_TLAST,
            TKEEP => S_AXIS_BUF_TKEEP);

    cnn_S_AXIS_CTRL_if_U : component cnn_S_AXIS_CTRL_if
        port map (
            ACLK => aclk,
            ARESETN => aresetn,
            ctrl_sink_0_dout => sig_cnn_ctrl_sink_0_dout,
            ctrl_sink_0_empty_n => sig_cnn_ctrl_sink_0_empty_n,
            ctrl_sink_0_read => sig_cnn_ctrl_sink_0_read,
            ctrl_sink_1_dout => sig_cnn_ctrl_sink_1_dout,
            ctrl_sink_1_empty_n => sig_cnn_ctrl_sink_1_empty_n,
            ctrl_sink_1_read => sig_cnn_ctrl_sink_1_read,
            ctrl_sink_2_dout => sig_cnn_ctrl_sink_2_dout,
            ctrl_sink_2_empty_n => sig_cnn_ctrl_sink_2_empty_n,
            ctrl_sink_2_read => sig_cnn_ctrl_sink_2_read,
            TVALID => S_AXIS_CTRL_TVALID,
            TREADY => S_AXIS_CTRL_TREADY,
            TDATA => S_AXIS_CTRL_TDATA,
            TLAST => S_AXIS_CTRL_TLAST,
            TKEEP => S_AXIS_CTRL_TKEEP);

    cnn_S_AXIS_W_if_U : component cnn_S_AXIS_W_if
        port map (
            ACLK => aclk,
            ARESETN => aresetn,
            w_sink_0_dout => sig_cnn_w_sink_0_dout,
            w_sink_0_empty_n => sig_cnn_w_sink_0_empty_n,
            w_sink_0_read => sig_cnn_w_sink_0_read,
            w_sink_1_dout => sig_cnn_w_sink_1_dout,
            w_sink_1_empty_n => sig_cnn_w_sink_1_empty_n,
            w_sink_1_read => sig_cnn_w_sink_1_read,
            w_sink_2_dout => sig_cnn_w_sink_2_dout,
            w_sink_2_empty_n => sig_cnn_w_sink_2_empty_n,
            w_sink_2_read => sig_cnn_w_sink_2_read,
            TVALID => S_AXIS_W_TVALID,
            TREADY => S_AXIS_W_TREADY,
            TDATA => S_AXIS_W_TDATA,
            TLAST => S_AXIS_W_TLAST,
            TKEEP => S_AXIS_W_TKEEP);

    cnn_S_AXIS_X_if_U : component cnn_S_AXIS_X_if
        port map (
            ACLK => aclk,
            ARESETN => aresetn,
            data_sink_0_dout => sig_cnn_data_sink_0_dout,
            data_sink_0_empty_n => sig_cnn_data_sink_0_empty_n,
            data_sink_0_read => sig_cnn_data_sink_0_read,
            data_sink_1_dout => sig_cnn_data_sink_1_dout,
            data_sink_1_empty_n => sig_cnn_data_sink_1_empty_n,
            data_sink_1_read => sig_cnn_data_sink_1_read,
            data_sink_2_dout => sig_cnn_data_sink_2_dout,
            data_sink_2_empty_n => sig_cnn_data_sink_2_empty_n,
            data_sink_2_read => sig_cnn_data_sink_2_read,
            TVALID => S_AXIS_X_TVALID,
            TREADY => S_AXIS_X_TREADY,
            TDATA => S_AXIS_X_TDATA,
            TLAST => S_AXIS_X_TLAST,
            TKEEP => S_AXIS_X_TKEEP);

    cnn_slv0_if_U : component cnn_slv0_if
        generic map (
            C_ADDR_WIDTH => C_S_AXI_SLV0_ADDR_WIDTH,
            C_DATA_WIDTH => C_S_AXI_SLV0_DATA_WIDTH)
        port map (
            ACLK => aclk,
            ARESETN => aresetn,
            I_status_add => sig_cnn_status_add,
            O_status_val => sig_cnn_status_val,
            AWADDR => s_axi_slv0_AWADDR,
            AWVALID => s_axi_slv0_AWVALID,
            AWREADY => s_axi_slv0_AWREADY,
            WDATA => s_axi_slv0_WDATA,
            WSTRB => s_axi_slv0_WSTRB,
            WVALID => s_axi_slv0_WVALID,
            WREADY => s_axi_slv0_WREADY,
            BRESP => s_axi_slv0_BRESP,
            BVALID => s_axi_slv0_BVALID,
            BREADY => s_axi_slv0_BREADY,
            ARADDR => s_axi_slv0_ARADDR,
            ARVALID => s_axi_slv0_ARVALID,
            ARREADY => s_axi_slv0_ARREADY,
            RDATA => s_axi_slv0_RDATA,
            RRESP => s_axi_slv0_RRESP,
            RVALID => s_axi_slv0_RVALID,
            RREADY => s_axi_slv0_RREADY);

    reset_if_U : component cnn_reset_if
        generic map (
            RESET_ACTIVE_LOW => RESET_ACTIVE_LOW)
        port map (
            dout => sig_cnn_reset,
            din => aresetn);

end architecture;

