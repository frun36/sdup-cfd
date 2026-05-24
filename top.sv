`timescale 1ns / 1ps

module top #(
    parameter BIT_WIDTH = 12,
    parameter DELAY = 10,
    parameter SCALE_SHIFT = 1,
    parameter CFD_THR = 0,
    parameter DATA_MUX = 16
) (
    input  wire                 clk,
    input  wire                 rst,
    input  wire [BIT_WIDTH-1:0] din  [DATA_MUX],
    output wire                 pulse
);
  wire [BIT_WIDTH:0] dout[DATA_MUX];

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

  // zero_crossing_detector #(
  //     .BIT_WIDTH(BIT_WIDTH),
  //     .THRESHOLD(CFD_THR)
  // ) uut_zcd (
  //     .clk(clk),
  //     .rst(rst),
  //     .data_in($signed(dout)),
  //     .zc_pulse(zc_pulse),
  //     .state_pos(state_pos)
  // );
  //
  // assign pulse = zc_pulse & state_pos;
  assign pulse = 0;
endmodule
