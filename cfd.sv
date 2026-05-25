module cfd #(
    parameter integer BIT_WIDTH = 12,
    parameter integer DELAY = 10,
    parameter integer SCALE_SHIFT = 1,
    parameter integer DATA_MUX = 16
) (
    input  wire                       clk,
    input  wire                       rst,
    input  wire       [BIT_WIDTH-1:0] din [DATA_MUX],
    output reg signed [  BIT_WIDTH:0] dout[DATA_MUX]
);
  // Data from previous iteration used in delay computations
  reg [BIT_WIDTH-1:0] prev_iter_data[DELAY];
  // Data from current iteration with prepended delay samples
  reg [BIT_WIDTH-1:0] buff[DELAY+DATA_MUX];

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
        dout[j] <= $signed({1'b0, buff[j]}) -
            $signed({1'b0, buff[DELAY+j] >> SCALE_SHIFT});  // TODO: correct scaling
      end
    end
  end
endmodule
