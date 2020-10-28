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
        C_S_AXI_SLV0_ADDR_WIDTH :  integer := 7;
        C_S_AXI_SLV0_DATA_WIDTH :  integer := 32;
        RESET_ACTIVE_LOW :  integer := 1
    );
    port (
        M_AXIS_DATA_TVALID : out  std_logic;
        M_AXIS_DATA_TREADY : in  std_logic;
        M_AXIS_DATA_TDATA : out  std_logic_vector(64 - 1 downto 0);
        M_AXIS_DATA_TLAST : out  std_logic_vector(1 - 1 downto 0);
        M_AXIS_DATA_TKEEP : out  std_logic_vector(8 - 1 downto 0);
        S_AXIS_DATA_TVALID : in  std_logic;
        S_AXIS_DATA_TREADY : out  std_logic;
        S_AXIS_DATA_TDATA : in  std_logic_vector(64 - 1 downto 0);
        S_AXIS_DATA_TLAST : in  std_logic_vector(1 - 1 downto 0);
        S_AXIS_DATA_TKEEP : in  std_logic_vector(8 - 1 downto 0);
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
            data_source_0_din : out  std_logic_vector(64 - 1 downto 0);
            data_source_0_full_n : in  std_logic;
            data_source_0_write : out  std_logic;
            data_source_1_din : out  std_logic_vector(1 - 1 downto 0);
            data_source_1_full_n : in  std_logic;
            data_source_1_write : out  std_logic;
            data_source_2_din : out  std_logic_vector(8 - 1 downto 0);
            data_source_2_full_n : in  std_logic;
            data_source_2_write : out  std_logic;
            data_sink_0_dout : in  std_logic_vector(64 - 1 downto 0);
            data_sink_0_empty_n : in  std_logic;
            data_sink_0_read : out  std_logic;
            data_sink_1_dout : in  std_logic_vector(1 - 1 downto 0);
            data_sink_1_empty_n : in  std_logic;
            data_sink_1_read : out  std_logic;
            data_sink_2_dout : in  std_logic_vector(8 - 1 downto 0);
            data_sink_2_empty_n : in  std_logic;
            data_sink_2_read : out  std_logic;
            weight_ctrls : in  std_logic_vector(17 - 1 downto 0);
            ctrl_image_size : in  std_logic_vector(32 - 1 downto 0);
            ctrl_row_size_pkg : in  std_logic_vector(17 - 1 downto 0);
            ctrl_window_size : in  std_logic_vector(17 - 1 downto 0);
            ctrl_depth : in  std_logic_vector(17 - 1 downto 0);
            ctrl_stride : in  std_logic_vector(17 - 1 downto 0);
            ctrl_replay : in  std_logic_vector(17 - 1 downto 0);
            ctrl_channel : in  std_logic_vector(2 - 1 downto 0);
            ctrl_row_N : in  std_logic_vector(17 - 1 downto 0);
            ready : out  std_logic_vector(1 - 1 downto 0);
            reset : in  std_logic;
            clk : in  std_logic
        );
    end component;

    component cnn_M_AXIS_DATA_if is
        port (
            ACLK :  in std_logic;
            ARESETN :  in std_logic;
            data_source_0_din :  in std_logic_vector(64 - 1 downto 0);
            data_source_0_full_n :  out std_logic;
            data_source_0_write :  in std_logic;
            data_source_1_din :  in std_logic_vector(1 - 1 downto 0);
            data_source_1_full_n :  out std_logic;
            data_source_1_write :  in std_logic;
            data_source_2_din :  in std_logic_vector(8 - 1 downto 0);
            data_source_2_full_n :  out std_logic;
            data_source_2_write :  in std_logic;
            TVALID :  out std_logic;
            TREADY :  in std_logic;
            TDATA :  out std_logic_vector(64 - 1 downto 0);
            TLAST :  out std_logic_vector(1 - 1 downto 0);
            TKEEP :  out std_logic_vector(8 - 1 downto 0));
    end component;

    component cnn_S_AXIS_DATA_if is
        port (
            ACLK :  in std_logic;
            ARESETN :  in std_logic;
            data_sink_0_dout :  out std_logic_vector(64 - 1 downto 0);
            data_sink_0_empty_n :  out std_logic;
            data_sink_0_read :  in std_logic;
            data_sink_1_dout :  out std_logic_vector(1 - 1 downto 0);
            data_sink_1_empty_n :  out std_logic;
            data_sink_1_read :  in std_logic;
            data_sink_2_dout :  out std_logic_vector(8 - 1 downto 0);
            data_sink_2_empty_n :  out std_logic;
            data_sink_2_read :  in std_logic;
            TVALID :  in std_logic;
            TREADY :  out std_logic;
            TDATA :  in std_logic_vector(64 - 1 downto 0);
            TLAST :  in std_logic_vector(1 - 1 downto 0);
            TKEEP :  in std_logic_vector(8 - 1 downto 0));
    end component;

    component cnn_slv0_if is
        generic (
            C_ADDR_WIDTH :  integer;
            C_DATA_WIDTH :  integer);
        port (
            ACLK :  in std_logic;
            ARESETN :  in std_logic;
            I_weight_ctrls :  out std_logic_vector(17 - 1 downto 0);
            I_ctrl_image_size :  out std_logic_vector(32 - 1 downto 0);
            I_ctrl_row_size_pkg :  out std_logic_vector(17 - 1 downto 0);
            I_ctrl_window_size :  out std_logic_vector(17 - 1 downto 0);
            I_ctrl_depth :  out std_logic_vector(17 - 1 downto 0);
            I_ctrl_stride :  out std_logic_vector(17 - 1 downto 0);
            I_ctrl_replay :  out std_logic_vector(17 - 1 downto 0);
            I_ctrl_channel :  out std_logic_vector(2 - 1 downto 0);
            I_ctrl_row_N :  out std_logic_vector(17 - 1 downto 0);
            O_ready :  in std_logic_vector(1 - 1 downto 0);
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

    signal sig_cnn_data_source_0_din :  std_logic_vector(64 - 1 downto 0);
    signal sig_cnn_data_source_0_full_n :  std_logic;
    signal sig_cnn_data_source_0_write :  std_logic;
    signal sig_cnn_data_source_1_din :  std_logic_vector(1 - 1 downto 0);
    signal sig_cnn_data_source_1_full_n :  std_logic;
    signal sig_cnn_data_source_1_write :  std_logic;
    signal sig_cnn_data_source_2_din :  std_logic_vector(8 - 1 downto 0);
    signal sig_cnn_data_source_2_full_n :  std_logic;
    signal sig_cnn_data_source_2_write :  std_logic;
    signal sig_cnn_data_sink_0_dout :  std_logic_vector(64 - 1 downto 0);
    signal sig_cnn_data_sink_0_empty_n :  std_logic;
    signal sig_cnn_data_sink_0_read :  std_logic;
    signal sig_cnn_data_sink_1_dout :  std_logic_vector(1 - 1 downto 0);
    signal sig_cnn_data_sink_1_empty_n :  std_logic;
    signal sig_cnn_data_sink_1_read :  std_logic;
    signal sig_cnn_data_sink_2_dout :  std_logic_vector(8 - 1 downto 0);
    signal sig_cnn_data_sink_2_empty_n :  std_logic;
    signal sig_cnn_data_sink_2_read :  std_logic;
    signal sig_cnn_weight_ctrls :  std_logic_vector(17 - 1 downto 0);
    signal sig_cnn_ctrl_image_size :  std_logic_vector(32 - 1 downto 0);
    signal sig_cnn_ctrl_row_size_pkg :  std_logic_vector(17 - 1 downto 0);
    signal sig_cnn_ctrl_window_size :  std_logic_vector(17 - 1 downto 0);
    signal sig_cnn_ctrl_depth :  std_logic_vector(17 - 1 downto 0);
    signal sig_cnn_ctrl_stride :  std_logic_vector(17 - 1 downto 0);
    signal sig_cnn_ctrl_replay :  std_logic_vector(17 - 1 downto 0);
    signal sig_cnn_ctrl_channel :  std_logic_vector(2 - 1 downto 0);
    signal sig_cnn_ctrl_row_N :  std_logic_vector(17 - 1 downto 0);
    signal sig_cnn_ready :  std_logic_vector(1 - 1 downto 0);
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
            data_sink_0_dout => sig_cnn_data_sink_0_dout,
            data_sink_0_empty_n => sig_cnn_data_sink_0_empty_n,
            data_sink_0_read => sig_cnn_data_sink_0_read,
            data_sink_1_dout => sig_cnn_data_sink_1_dout,
            data_sink_1_empty_n => sig_cnn_data_sink_1_empty_n,
            data_sink_1_read => sig_cnn_data_sink_1_read,
            data_sink_2_dout => sig_cnn_data_sink_2_dout,
            data_sink_2_empty_n => sig_cnn_data_sink_2_empty_n,
            data_sink_2_read => sig_cnn_data_sink_2_read,
            weight_ctrls => sig_cnn_weight_ctrls,
            ctrl_image_size => sig_cnn_ctrl_image_size,
            ctrl_row_size_pkg => sig_cnn_ctrl_row_size_pkg,
            ctrl_window_size => sig_cnn_ctrl_window_size,
            ctrl_depth => sig_cnn_ctrl_depth,
            ctrl_stride => sig_cnn_ctrl_stride,
            ctrl_replay => sig_cnn_ctrl_replay,
            ctrl_channel => sig_cnn_ctrl_channel,
            ctrl_row_N => sig_cnn_ctrl_row_N,
            ready => sig_cnn_ready,
            reset => sig_cnn_reset,
            clk => aclk
        );

    cnn_M_AXIS_DATA_if_U : component cnn_M_AXIS_DATA_if
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
            TVALID => M_AXIS_DATA_TVALID,
            TREADY => M_AXIS_DATA_TREADY,
            TDATA => M_AXIS_DATA_TDATA,
            TLAST => M_AXIS_DATA_TLAST,
            TKEEP => M_AXIS_DATA_TKEEP);

    cnn_S_AXIS_DATA_if_U : component cnn_S_AXIS_DATA_if
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
            TVALID => S_AXIS_DATA_TVALID,
            TREADY => S_AXIS_DATA_TREADY,
            TDATA => S_AXIS_DATA_TDATA,
            TLAST => S_AXIS_DATA_TLAST,
            TKEEP => S_AXIS_DATA_TKEEP);

    cnn_slv0_if_U : component cnn_slv0_if
        generic map (
            C_ADDR_WIDTH => C_S_AXI_SLV0_ADDR_WIDTH,
            C_DATA_WIDTH => C_S_AXI_SLV0_DATA_WIDTH)
        port map (
            ACLK => aclk,
            ARESETN => aresetn,
            I_weight_ctrls => sig_cnn_weight_ctrls,
            I_ctrl_image_size => sig_cnn_ctrl_image_size,
            I_ctrl_row_size_pkg => sig_cnn_ctrl_row_size_pkg,
            I_ctrl_window_size => sig_cnn_ctrl_window_size,
            I_ctrl_depth => sig_cnn_ctrl_depth,
            I_ctrl_stride => sig_cnn_ctrl_stride,
            I_ctrl_replay => sig_cnn_ctrl_replay,
            I_ctrl_channel => sig_cnn_ctrl_channel,
            I_ctrl_row_N => sig_cnn_ctrl_row_N,
            O_ready => sig_cnn_ready,
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

