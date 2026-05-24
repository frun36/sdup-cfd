module cfd #(
    parameter integer BIT_WIDTH = 12,
    parameter integer DELAY = 10,
    parameter integer SCALE_SHIFT = 1,
    parameter integer DATA_MUX = 16
) (
    input  wire                 clk,
    input  wire                 rst,
    input  wire [BIT_WIDTH-1:0] din [DATA_MUX],
    output reg  [  BIT_WIDTH:0] dout[DATA_MUX]
);
  wire [BIT_WIDTH-1:0] delayed[DATA_MUX];
  reg [BIT_WIDTH-1:0] scaled[DATA_MUX];

  // Delayed / scaled path
  reg [BIT_WIDTH-1:0] shift_reg[DATA_MUX+DELAY];
  integer i;
  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < DATA_MUX + DELAY; i = i + 1) begin
        shift_reg[i] <= {BIT_WIDTH{1'b0}};
      end
    end else begin
      for (i = 0; i < DATA_MUX; i = i + 1) begin
        shift_reg[i] <= din[i];
        scaled[i] <= din[i] >> SCALE_SHIFT;
      end
      for (i = DATA_MUX; i < DATA_MUX + DELAY; i = i + 1) begin
        shift_reg[i] <= shift_reg[i-DATA_MUX];
      end
    end
  end

  // genvar j;
  // generate
  //   for (j = 0; j < DATA_MUX; j = j + 1) assign delayed[j] = shift_reg[j];
  // endgenerate
  assign delayed = shift_reg[DELAY:DATA_MUX+DELAY-1];

  // Summation
  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < DATA_MUX; i = i + 1) dout[i] <= 0;
    end else begin
      for (i = 0; i < DATA_MUX; i = i + 1) begin
        dout[i] <= $signed({1'b0, delayed[i]}) - $signed({1'b0, scaled[i]});
      end
    end
  end
endmodule
