`timescale 1ns / 1ps

module cfd_axis_wrapper #(
    parameter integer BIT_WIDTH_IN = 12,  
    parameter integer DATA_MUX = 16,
    parameter integer DELAY = 10,
    parameter integer SCALE_DIV = 8,  
    parameter integer SCALE_MULT = 11,  
    parameter integer BIT_WIDTH_OUT = BIT_WIDTH_IN + $clog2(SCALE_DIV) + 1,  
    parameter integer FPGA_TIME_WIDTH = 16,
    // Calculated parameters for AXI interfaces
    parameter integer S_AXIS_TDATA_WIDTH = BIT_WIDTH_IN * DATA_MUX,
    parameter integer M_AXIS_TDATA_WIDTH = 32 // With headroom
) (
    input  wire aclk,
    input  wire aresetn,

    // Timestamp counter reset
    input  wire lhc_clk,

    // AXI4-Stream Slave Interface (Input Data)
    input  wire [S_AXIS_TDATA_WIDTH-1:0] s_axis_tdata,
    input  wire                          s_axis_tvalid,
    output wire                          s_axis_tready, // Ignored

    // AXI4-Stream Master Interface (Output Data)
    output wire [M_AXIS_TDATA_WIDTH-1:0] m_axis_tdata,
    output wire                          m_axis_tvalid,
    input  wire                          m_axis_tready, // Ignored

    // For AXI-Lite (later)
    input  wire signed [BIT_WIDTH_OUT:0] cfd_threshold,
    input  wire signed [BIT_WIDTH_OUT:0] cfd_zero
);

    // Active-high reset for your internal module
    wire rst = ~aresetn;

	// Unpack data from AXI
    wire [BIT_WIDTH_IN-1:0] din_unpacked [DATA_MUX];    
    genvar i;
    generate
        for (i = 0; i < DATA_MUX; i = i + 1) begin : gen_unpack
            assign din_unpacked[i] = s_axis_tdata[(i * BIT_WIDTH_IN) +: BIT_WIDTH_IN];
        end
    endgenerate

    // Always ready to accept data
    assign s_axis_tready = 1'b1;

    cfd_top #(
        .BIT_WIDTH_IN(BIT_WIDTH_IN),
        .DATA_MUX(DATA_MUX),
        .DELAY(DELAY),
        .SCALE_DIV(SCALE_DIV),
        .SCALE_MULT(SCALE_MULT),
        .BIT_WIDTH_OUT(BIT_WIDTH_OUT),
        .FPGA_TIME_WIDTH(FPGA_TIME_WIDTH)
    ) u_cfd_top (
        .clk(aclk),
        .rst(rst),
        .lhc_clk(lhc_clk),
        .din_valid(s_axis_tvalid),
        .din(din_unpacked),
        .cfd_threshold(cfd_threshold),
        .cfd_zero(cfd_zero),
        .pulse(m_axis_tvalid),
        .timestamp(m_axis_tdata)
    );

endmodule