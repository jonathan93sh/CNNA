// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.1 (64-bit)
// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// ==============================================================
`timescale 1ns/1ps
module cnn_slv0_if
#(parameter
    C_ADDR_WIDTH = 7,
    C_DATA_WIDTH = 32
)(
    // axi4 lite slave signals
    input  wire                      ACLK,
    input  wire                      ARESETN,
    input  wire [C_ADDR_WIDTH-1:0]   AWADDR,
    input  wire                      AWVALID,
    output wire                      AWREADY,
    input  wire [C_DATA_WIDTH-1:0]   WDATA,
    input  wire [C_DATA_WIDTH/8-1:0] WSTRB,
    input  wire                      WVALID,
    output wire                      WREADY,
    output wire [1:0]                BRESP,
    output wire                      BVALID,
    input  wire                      BREADY,
    input  wire [C_ADDR_WIDTH-1:0]   ARADDR,
    input  wire                      ARVALID,
    output wire                      ARREADY,
    output wire [C_DATA_WIDTH-1:0]   RDATA,
    output wire [1:0]                RRESP,
    output wire                      RVALID,
    input  wire                      RREADY,
    // user signals
    output wire [16:0]               I_weight_ctrls,
    output wire [31:0]               I_ctrl_image_size,
    output wire [16:0]               I_ctrl_row_size_pkg,
    output wire [16:0]               I_ctrl_window_size,
    output wire [16:0]               I_ctrl_depth,
    output wire [16:0]               I_ctrl_stride,
    output wire [16:0]               I_ctrl_replay,
    output wire [1:0]                I_ctrl_channel,
    output wire [16:0]               I_ctrl_row_N,
    input  wire [0:0]                O_ready
);
//------------------------Address Info-------------------
// 0x00 : reserved
// 0x04 : reserved
// 0x08 : reserved
// 0x0c : reserved
// 0x10 : reserved
// 0x14 : Data signal of weight_ctrls
//        bit 16~0 - weight_ctrls[16:0] (Read/Write)
//        others   - reserved
// 0x18 : reserved
// 0x1c : Data signal of ctrl_image_size
//        bit 31~0 - ctrl_image_size[31:0] (Read/Write)
// 0x20 : reserved
// 0x24 : Data signal of ctrl_row_size_pkg
//        bit 16~0 - ctrl_row_size_pkg[16:0] (Read/Write)
//        others   - reserved
// 0x28 : reserved
// 0x2c : Data signal of ctrl_window_size
//        bit 16~0 - ctrl_window_size[16:0] (Read/Write)
//        others   - reserved
// 0x30 : reserved
// 0x34 : Data signal of ctrl_depth
//        bit 16~0 - ctrl_depth[16:0] (Read/Write)
//        others   - reserved
// 0x38 : reserved
// 0x3c : Data signal of ctrl_stride
//        bit 16~0 - ctrl_stride[16:0] (Read/Write)
//        others   - reserved
// 0x40 : reserved
// 0x44 : Data signal of ctrl_replay
//        bit 16~0 - ctrl_replay[16:0] (Read/Write)
//        others   - reserved
// 0x48 : reserved
// 0x4c : Data signal of ctrl_channel
//        bit 1~0 - ctrl_channel[1:0] (Read/Write)
//        others  - reserved
// 0x50 : reserved
// 0x54 : Data signal of ctrl_row_N
//        bit 16~0 - ctrl_row_N[16:0] (Read/Write)
//        others   - reserved
// 0x58 : reserved
// 0x5c : Data signal of ready
//        bit 0  - ready[0] (Read)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

//------------------------Parameter----------------------
// address bits
localparam
    ADDR_BITS = 7;

// address
localparam
    ADDR_WEIGHT_CTRLS_CTRL        = 7'h10,
    ADDR_WEIGHT_CTRLS_DATA_0      = 7'h14,
    ADDR_CTRL_IMAGE_SIZE_CTRL     = 7'h18,
    ADDR_CTRL_IMAGE_SIZE_DATA_0   = 7'h1c,
    ADDR_CTRL_ROW_SIZE_PKG_CTRL   = 7'h20,
    ADDR_CTRL_ROW_SIZE_PKG_DATA_0 = 7'h24,
    ADDR_CTRL_WINDOW_SIZE_CTRL    = 7'h28,
    ADDR_CTRL_WINDOW_SIZE_DATA_0  = 7'h2c,
    ADDR_CTRL_DEPTH_CTRL          = 7'h30,
    ADDR_CTRL_DEPTH_DATA_0        = 7'h34,
    ADDR_CTRL_STRIDE_CTRL         = 7'h38,
    ADDR_CTRL_STRIDE_DATA_0       = 7'h3c,
    ADDR_CTRL_REPLAY_CTRL         = 7'h40,
    ADDR_CTRL_REPLAY_DATA_0       = 7'h44,
    ADDR_CTRL_CHANNEL_CTRL        = 7'h48,
    ADDR_CTRL_CHANNEL_DATA_0      = 7'h4c,
    ADDR_CTRL_ROW_N_CTRL          = 7'h50,
    ADDR_CTRL_ROW_N_DATA_0        = 7'h54,
    ADDR_READY_CTRL               = 7'h58,
    ADDR_READY_DATA_0             = 7'h5c;

// axi write fsm
localparam
    WRIDLE = 2'd0,
    WRDATA = 2'd1,
    WRRESP = 2'd2;

// axi read fsm
localparam
    RDIDLE = 2'd0,
    RDDATA = 2'd1;

//------------------------Local signal-------------------
// axi write
reg  [1:0]           wstate;
reg  [1:0]           wnext;
reg  [ADDR_BITS-1:0] waddr;
wire [31:0]          wmask;
wire                 aw_hs;
wire                 w_hs;
// axi read
reg  [1:0]           rstate;
reg  [1:0]           rnext;
reg  [31:0]          rdata;
wire                 ar_hs;
wire [ADDR_BITS-1:0] raddr;
// internal registers
reg  [16:0]          _weight_ctrls;
reg  [31:0]          _ctrl_image_size;
reg  [16:0]          _ctrl_row_size_pkg;
reg  [16:0]          _ctrl_window_size;
reg  [16:0]          _ctrl_depth;
reg  [16:0]          _ctrl_stride;
reg  [16:0]          _ctrl_replay;
reg  [1:0]           _ctrl_channel;
reg  [16:0]          _ctrl_row_N;
wire [0:0]           _ready;

//------------------------Body---------------------------
//++++++++++++++++++++++++axi write++++++++++++++++++++++
assign AWREADY = (wstate == WRIDLE);
assign WREADY  = (wstate == WRDATA);
assign BRESP   = 2'b00;  // OKAY
assign BVALID  = (wstate == WRRESP);
assign wmask   = { {8{WSTRB[3]}}, {8{WSTRB[2]}}, {8{WSTRB[1]}}, {8{WSTRB[0]}} };
assign aw_hs   = AWVALID & AWREADY;
assign w_hs    = WVALID & WREADY;

// wstate
always @(posedge ACLK) begin
    if (~ARESETN)
        wstate <= WRIDLE;
    else
        wstate <= wnext;
end

// wnext
always @(*) begin
    case (wstate)
        WRIDLE:
            if (AWVALID)
                wnext = WRDATA;
            else
                wnext = WRIDLE;
        WRDATA:
            if (WVALID)
                wnext = WRRESP;
            else
                wnext = WRDATA;
        WRRESP:
            if (BREADY)
                wnext = WRIDLE;
            else
                wnext = WRRESP;
        default:
            wnext = WRIDLE;
    endcase
end

// waddr
always @(posedge ACLK) begin
    if (aw_hs)
        waddr <= AWADDR[ADDR_BITS-1:0];
end
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++axi read+++++++++++++++++++++++
assign ARREADY = (rstate == RDIDLE);
assign RDATA   = rdata;
assign RRESP   = 2'b00;  // OKAY
assign RVALID  = (rstate == RDDATA);
assign ar_hs   = ARVALID & ARREADY;
assign raddr   = ARADDR[ADDR_BITS-1:0];

// rstate
always @(posedge ACLK) begin
    if (~ARESETN)
        rstate <= RDIDLE;
    else
        rstate <= rnext;
end

// rnext
always @(*) begin
    case (rstate)
        RDIDLE:
            if (ARVALID)
                rnext = RDDATA;
            else
                rnext = RDIDLE;
        RDDATA:
            if (RREADY)
                rnext = RDIDLE;
            else
                rnext = RDDATA;
        default:
            rnext = RDIDLE;
    endcase
end

// rdata
always @(posedge ACLK) begin
    if (ar_hs) begin
        rdata <= 1'b0;
        case (raddr)
            ADDR_WEIGHT_CTRLS_DATA_0: begin
                rdata <= _weight_ctrls[16:0];
            end
            ADDR_CTRL_IMAGE_SIZE_DATA_0: begin
                rdata <= _ctrl_image_size[31:0];
            end
            ADDR_CTRL_ROW_SIZE_PKG_DATA_0: begin
                rdata <= _ctrl_row_size_pkg[16:0];
            end
            ADDR_CTRL_WINDOW_SIZE_DATA_0: begin
                rdata <= _ctrl_window_size[16:0];
            end
            ADDR_CTRL_DEPTH_DATA_0: begin
                rdata <= _ctrl_depth[16:0];
            end
            ADDR_CTRL_STRIDE_DATA_0: begin
                rdata <= _ctrl_stride[16:0];
            end
            ADDR_CTRL_REPLAY_DATA_0: begin
                rdata <= _ctrl_replay[16:0];
            end
            ADDR_CTRL_CHANNEL_DATA_0: begin
                rdata <= _ctrl_channel[1:0];
            end
            ADDR_CTRL_ROW_N_DATA_0: begin
                rdata <= _ctrl_row_N[16:0];
            end
            ADDR_READY_DATA_0: begin
                rdata <= _ready[0:0];
            end
        endcase
    end
end
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++internal registers+++++++++++++
assign I_weight_ctrls      = _weight_ctrls;
assign I_ctrl_image_size   = _ctrl_image_size;
assign I_ctrl_row_size_pkg = _ctrl_row_size_pkg;
assign I_ctrl_window_size  = _ctrl_window_size;
assign I_ctrl_depth        = _ctrl_depth;
assign I_ctrl_stride       = _ctrl_stride;
assign I_ctrl_replay       = _ctrl_replay;
assign I_ctrl_channel      = _ctrl_channel;
assign I_ctrl_row_N        = _ctrl_row_N;
assign _ready              = O_ready;

// _weight_ctrls[16:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_WEIGHT_CTRLS_DATA_0)
        _weight_ctrls[16:0] <= (WDATA[31:0] & wmask) | (_weight_ctrls[16:0] & ~wmask);
end

// _ctrl_image_size[31:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_CTRL_IMAGE_SIZE_DATA_0)
        _ctrl_image_size[31:0] <= (WDATA[31:0] & wmask) | (_ctrl_image_size[31:0] & ~wmask);
end

// _ctrl_row_size_pkg[16:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_CTRL_ROW_SIZE_PKG_DATA_0)
        _ctrl_row_size_pkg[16:0] <= (WDATA[31:0] & wmask) | (_ctrl_row_size_pkg[16:0] & ~wmask);
end

// _ctrl_window_size[16:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_CTRL_WINDOW_SIZE_DATA_0)
        _ctrl_window_size[16:0] <= (WDATA[31:0] & wmask) | (_ctrl_window_size[16:0] & ~wmask);
end

// _ctrl_depth[16:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_CTRL_DEPTH_DATA_0)
        _ctrl_depth[16:0] <= (WDATA[31:0] & wmask) | (_ctrl_depth[16:0] & ~wmask);
end

// _ctrl_stride[16:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_CTRL_STRIDE_DATA_0)
        _ctrl_stride[16:0] <= (WDATA[31:0] & wmask) | (_ctrl_stride[16:0] & ~wmask);
end

// _ctrl_replay[16:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_CTRL_REPLAY_DATA_0)
        _ctrl_replay[16:0] <= (WDATA[31:0] & wmask) | (_ctrl_replay[16:0] & ~wmask);
end

// _ctrl_channel[1:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_CTRL_CHANNEL_DATA_0)
        _ctrl_channel[1:0] <= (WDATA[31:0] & wmask) | (_ctrl_channel[1:0] & ~wmask);
end

// _ctrl_row_N[16:0]
always @(posedge ACLK) begin
    if (w_hs && waddr == ADDR_CTRL_ROW_N_DATA_0)
        _ctrl_row_N[16:0] <= (WDATA[31:0] & wmask) | (_ctrl_row_N[16:0] & ~wmask);
end

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++

endmodule
