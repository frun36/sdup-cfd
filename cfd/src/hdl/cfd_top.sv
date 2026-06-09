`timescale 1ns / 1ps

module cfd_top #(
    parameter integer BIT_WIDTH_IN = 12,  // Input signal (ADC) bit width
    parameter integer DATA_MUX = 16,
    parameter integer DELAY = 10,
    // Allow for fractional multiplication by having a divisor and multiplier
    parameter integer SCALE_DIV = 8,  // has to be a power of 2
    parameter integer SCALE_MULT = 11,  // has to be lower than 2*SCALE_DIV
    parameter integer BIT_WIDTH_OUT = BIT_WIDTH_IN + $clog2(
        SCALE_DIV
    ) + 1,  // Maximum multiply by 2
    parameter integer FPGA_TIME_WIDTH = 16,  // DATA_MUX bit width will be added to timestamp width
    localparam integer TIMESTAMP_WIDTH = FPGA_TIME_WIDTH + $clog2(DATA_MUX)
) (
    input wire clk,
    input wire rst,
    input wire lhc_clk,
    input wire din_valid,
    input wire [BIT_WIDTH_IN-1:0] din[DATA_MUX],
    input wire signed [BIT_WIDTH_OUT:0] cfd_threshold,  // hysteresis for noise immunity
    input wire signed [BIT_WIDTH_OUT:0] cfd_zero,  // detects cfd_zero crossing
    output reg pulse,
    output reg [TIMESTAMP_WIDTH-1:0] timestamp
);
  wire signed [BIT_WIDTH_OUT:0] dout[DATA_MUX];  // One bit more for a sign bit

  wire cfd_dout_valid;
  wire zcd_out_valid;

  wire pulses[DATA_MUX];
  wire [TIMESTAMP_WIDTH-1:0] timestamps[DATA_MUX];

  cfd #(
      .BIT_WIDTH_IN(BIT_WIDTH_IN),
      .DELAY(DELAY),
      .DATA_MUX(DATA_MUX),
      .SCALE_DIV(SCALE_DIV),
      .SCALE_MULT(SCALE_MULT),
      .BIT_WIDTH_OUT(BIT_WIDTH_OUT)
  ) uut_cfd (
      .clk(clk),
      .rst(rst),
      .din_valid(din_valid),
      .din(din),
      .dout_valid(cfd_dout_valid),
      .dout(dout)
  );

  zero_crossing_detector #(
      .DATA_MUX(DATA_MUX),
      .BIT_WIDTH_OUT(BIT_WIDTH_OUT)
  ) uut_zcd (
      .clk(clk),
      .rst(rst),
      .din_valid(cfd_dout_valid),
      .din(dout),
      .out_valid(zcd_out_valid),
      .cfd_threshold(cfd_threshold),
      .cfd_zero(cfd_zero),
      .zc_pulse(pulses)
  );


  tdc #(
      .DATA_MUX(DATA_MUX),
      .FPGA_TIME_WIDTH(FPGA_TIME_WIDTH)
  ) uut_tdc (
      .clk(clk),
      .rst(rst),
      .din_valid(zcd_out_valid),
      .lhc_clk(lhc_clk),
      .timestamps(timestamps)
  );


  // Condense output
  integer i;
  always_comb begin
    pulse = 1'b0;
    timestamp = '0;

    if (zcd_out_valid) begin
      // Loop backwards - lowest index has priority
      for (i = DATA_MUX - 1; i >= 0; i--) begin
        if (pulses[i]) begin
          pulse = 1'b1;
          timestamp = timestamps[i];
        end
      end
    end
  end
endmodule
