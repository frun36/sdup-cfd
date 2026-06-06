`timescale 1ns / 1ps

module sample_time_counter #(
    parameter integer DATA_MUX = 16,
    parameter integer FPGA_TIME_WIDTH = 16 // Counting FPGA clock cycles, DATA_MUX bit width is added to get width of sample time
) (
    input wire clk,
    input wire rst,
    input wire lhc_clk,
    output reg [FPGA_TIME_WIDTH+$clog2(DATA_MUX)-1:0] sample_time [DATA_MUX]
);
  reg [FPGA_TIME_WIDTH-1:0]fpga_time_counter;

  integer i;
  always @(posedge lhc_clk) begin
    // Assume synchronisation clock signal is asynchronous to the FPGA clock
    fpga_time_counter <= 0;
  end

  always @(posedge clk) begin
    if (rst) begin
      fpga_time_counter <= 0;
    end else begin
      for (i = 0; i < DATA_MUX; i = i + 1) begin
        sample_time[i] <= ((FPGA_TIME_WIDTH+$clog2(DATA_MUX))'(fpga_time_counter) << $clog2(DATA_MUX)) + (1)'(i);
      end
      fpga_time_counter <= fpga_time_counter + 1'b1;
    end
  end
endmodule

