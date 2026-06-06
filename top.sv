`timescale 1ns / 1ps

module top #(
    parameter integer BIT_WIDTH_IN = 12, // Input signal (ADC) bit width
    parameter integer DATA_MUX = 16,
    parameter integer DELAY = 10,
    // Allow for fractional multiplication by having a divisor and multiplier
    parameter integer SCALE_DIV = 8, // has to be a power of 2
    parameter integer SCALE_MULT = 11, // has to be lower than 2*SCALE_DIV
    parameter integer BIT_WIDTH_OUT = BIT_WIDTH_IN + $clog2(SCALE_DIV) + 1 // Allow for maximum multiply of 2.0
) (
    input  wire                 clk,
    input  wire                 rst,
    input  wire [BIT_WIDTH_IN-1:0] din  [DATA_MUX],
    input wire signed [BIT_WIDTH_OUT:0] cfd_threshold,  // hysteresis for noise immunity
    input wire signed [BIT_WIDTH_OUT:0] cfd_zero, // detects cfd_zero crossing
    output wire                 pulse[DATA_MUX]
);
  wire signed [BIT_WIDTH_OUT:0] dout[DATA_MUX]; // One bit more for a sign bit

  cfd #(
      .BIT_WIDTH_IN(BIT_WIDTH_IN),
      .DELAY(DELAY),
      .DATA_MUX(DATA_MUX),
      .SCALE_DIV(SCALE_DIV),
      .SCALE_MULT(SCALE_MULT),
      .BIT_WIDTH_OUT(BIT_WIDTH_OUT)
  ) uut_cfd (
      .clk (clk),
      .rst (rst),
      .din (din),
      .dout(dout)
  );

  zero_crossing_detector #(
      .BIT_WIDTH_OUT(BIT_WIDTH_OUT)
  ) uut_zcd (
      .clk(clk),
      .rst(rst),
      .din(dout),
      .cfd_threshold(cfd_threshold),
      .cfd_zero(cfd_zero),
      .zc_pulse(pulse)
  );
endmodule
