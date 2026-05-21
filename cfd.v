module cfd #(
    parameter BIT_WIDTH = 12,
    parameter DELAY = 10,
    parameter SCALE_SHIFT = 1
)(
    input  wire                 clk,
    input  wire                 rst,
    input  wire [BIT_WIDTH-1:0] din,
    output reg  [BIT_WIDTH:0] dout
);
    wire [BIT_WIDTH-1:0] delayed;
    wire [BIT_WIDTH-1:0] scaled;

    // Delayed path
    reg [BIT_WIDTH-1:0] shift_reg [0:DELAY-1];
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < DELAY; i = i + 1) begin
                shift_reg[i] <= {BIT_WIDTH{1'b0}};
            end
        end else begin
            shift_reg[0] <= din;
            for (i = 1; i < DELAY; i = i + 1) begin
                shift_reg[i] <= shift_reg[i-1];
            end
        end
    end
    assign delayed = shift_reg[DELAY-1];

    // Scaled path
    assign scaled = (din >> SCALE_SHIFT);

    // Summation
    always @(posedge clk) begin
        if (rst) begin
            dout <= 0;
        end else begin
            dout <= $signed({1'b0, delayed}) - $signed({1'b0, scaled});
        end
    end
endmodule
