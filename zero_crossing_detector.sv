`timescale 1ns / 1ps

module zero_crossing_detector #(
    parameter integer BIT_WIDTH = 12,
    parameter signed [BIT_WIDTH:0] CFD_THRESHOLD = 0,  // hysteresis for noise immunity
    parameter signed [BIT_WIDTH:0] CFD_ZERO = 0, // detects CFD_ZERO crossing
    parameter integer DATA_MUX = 16
) (
    input wire clk,
    input wire rst,
    input wire signed [BIT_WIDTH:0] din[DATA_MUX],  // BIT_WIDTH + 1 for sign
    output reg zc_pulse[DATA_MUX]  // Pulses high for 1 clock cycle on crossing
);
  // Flag samples based on threshold cross
  wire is_above[DATA_MUX];
  wire is_below[DATA_MUX];
  genvar i;
  generate
    for (i = 0; i < DATA_MUX; i = i + 1) begin : gen_comparators
      assign is_above[i] = $signed(din[i]) >= CFD_ZERO + CFD_THRESHOLD;
      assign is_below[i] = $signed(din[i]) <= CFD_ZERO - CFD_THRESHOLD;
    end
  endgenerate

  // Fill the inbetween samples with state of previous sample
  wire state_ripple[DATA_MUX];
  reg prev_packet_state;
  assign state_ripple[0] = is_above[0] ? 1'b1 : (is_below[0] ? 1'b0 : prev_packet_state);
  genvar j;
  generate
    for (j = 1; j < DATA_MUX; j = j + 1) begin : gen_state_chain
      assign state_ripple[j] = is_above[j] ? 1'b1 : (is_below[j] ? 1'b0 : state_ripple[j-1]);
    end
  endgenerate

  // Compute the output
  integer k;
  always @(posedge clk) begin
    if (rst) begin
      prev_packet_state <= 1'b0;
      for (k = 0; k < DATA_MUX; k = k + 1) zc_pulse[k] <= 1'b0;
    end else begin
      // Save the very last state for the next clock cycle
      prev_packet_state <= state_ripple[DATA_MUX-1];

      // Output a 1-cycle flag on a Low-to-High crossing
      zc_pulse[0] <= (state_ripple[0] == 1'b1) && (prev_packet_state == 1'b0);
      for (k = 1; k < DATA_MUX; k = k + 1) begin
        zc_pulse[k] <= (state_ripple[k] == 1'b1) && (state_ripple[k-1] == 1'b0);
      end
    end
  end
endmodule
