`timescale 1ns / 1ps

module top #(
    parameter integer BIT_WIDTH = 12,
    parameter integer DELAY = 10,
    parameter integer SCALE_SHIFT = 1,
    parameter integer CFD_THR = 0,
    parameter integer DATA_MUX = 16
) (
    input  wire                 clk,
    input  wire                 rst,
    input  wire [BIT_WIDTH-1:0] din  [DATA_MUX],
    output wire                 pulse[DATA_MUX]
);
  wire signed [BIT_WIDTH:0] dout[DATA_MUX];

  cfd #(
      .BIT_WIDTH(BIT_WIDTH),
      .DELAY(DELAY),
      .SCALE_SHIFT(SCALE_SHIFT),
      .DATA_MUX(DATA_MUX)
  ) uut_cfd (
      .clk (clk),
      .rst (rst),
      .din (din),
      .dout(dout)
  );

  zero_crossing_detector #(
      .BIT_WIDTH(BIT_WIDTH),
      .THRESHOLD(CFD_THR)
  ) uut_zcd (
      .clk(clk),
      .rst(rst),
      .din(dout),
      .zc_pulse(pulse)
  );
endmodule
