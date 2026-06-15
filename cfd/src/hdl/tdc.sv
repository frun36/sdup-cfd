`timescale 1ns / 1ps

module tdc #(
    parameter integer DATA_MUX = 16,
    parameter integer FPGA_TIME_WIDTH = 16,  // DATA_MUX bit width will be added to timestamp width
    localparam integer TIMESTAMP_WIDTH = FPGA_TIME_WIDTH + $clog2(DATA_MUX)
) (
    input wire clk,
    input wire rst,
    input wire lhc_clk,
    input wire din_valid,
    output reg [TIMESTAMP_WIDTH-1:0] timestamps[DATA_MUX]
);
  reg [FPGA_TIME_WIDTH-1:0] fpga_time_counter;
  reg lhc_clk_prev;

  always @(posedge clk) begin
    if (rst) begin
      fpga_time_counter <= 0;
      lhc_clk_prev <= 0;
    end else if (din_valid) begin
      if (lhc_clk_prev == 1'b0 && lhc_clk == 1'b1) fpga_time_counter <= 0;
      else fpga_time_counter <= fpga_time_counter + 1'b1;
    end
    lhc_clk_prev <= lhc_clk;
  end
  integer i;
  always_comb begin
    for (i = 0; i < DATA_MUX; i = i + 1) begin
      timestamps[i] = {fpga_time_counter, $clog2(DATA_MUX)'(i)};
    end
  end
endmodule

