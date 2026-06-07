`timescale 1ns / 1ps

module cfd #(
    parameter integer BIT_WIDTH_IN = 12, // Input signal (ADC) bit width
    parameter integer DELAY = 10,
    parameter integer DATA_MUX = 16,
    // Allow for fractional multiplication by having a divisor and multiplier
    parameter integer SCALE_DIV = 8, // has to be a power of 2
    parameter integer SCALE_MULT = 11, // has to be lower than 2*SCALE_DIV
    parameter integer BIT_WIDTH_OUT = BIT_WIDTH_IN + $clog2(SCALE_DIV) + 1 // Allow for maximum multiply of 2.0
) (
    input  wire                       clk,
    input  wire                       rst,
    input  wire       [BIT_WIDTH_IN-1:0] din [DATA_MUX],
    output reg signed [BIT_WIDTH_OUT:0] dout[DATA_MUX] // One bit more for a sign bit
);
  // Data from previous iteration used in delay computations
  reg [BIT_WIDTH_IN-1:0] prev_iter_data[DELAY];
  // Data from current iteration with prepended delay samples
  reg [BIT_WIDTH_IN-1:0] buff[DELAY+DATA_MUX];

  integer i;
  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < DELAY; i = i + 1) begin
        prev_iter_data[i] <= 0;
      end
      for (i = 0; i < DATA_MUX + DELAY; i = i + 1) begin
        buff[i] <= 0;
      end
    end else begin
      // Previous iteration samples at start of buffer
      for (i = 0; i < DELAY; i = i + 1) begin
        buff[i] <= prev_iter_data[i];
      end
      // Current iteration samples
      for (i = 0; i < DATA_MUX; i = i + 1) begin
        buff[DELAY+i] <= din[i];
      end
      // Last current iteration samples as previous samples
      for (i = 0; i < DELAY; i = i + 1) begin
        prev_iter_data[i] <= din[DATA_MUX-DELAY+i];  // DELAY < DATA_MUX (TODO: generalize)
      end
    end
  end

  integer j;
  always @(posedge clk) begin
    if (rst) begin
      for (j = 0; j < DATA_MUX; j = j + 1) begin
        dout[j] <= 0;
      end
    end else begin
      for (j = 0; j < DATA_MUX; j = j + 1) begin
        logic [BIT_WIDTH_OUT-1:0] d_delayed;
        logic [BIT_WIDTH_OUT-1:0] d_inverted;

        d_delayed = (BIT_WIDTH_OUT)'(buff[j] * SCALE_MULT);
        d_inverted = (BIT_WIDTH_OUT)'(buff[DELAY+j] * SCALE_DIV);

        dout[j] <= $signed({1'b0, d_delayed}) - $signed({1'b0, d_inverted});
      end
    end
  end
endmodule
