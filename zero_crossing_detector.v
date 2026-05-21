`timescale 1ns / 1ps

module zero_crossing_detector #(
    parameter BIT_WIDTH = 12,
    parameter THRESHOLD = 0 // hysteresis for noise immunity
)(
    input  wire                         clk,
    input  wire                         rst,
    input  wire signed [BIT_WIDTH:0]    data_in,    // BIT_WIDTH + 1 for sign
    output reg                          zc_pulse,   // Pulses high for 1 clock cycle on crossing
    output reg                          state_pos   // 1 - positive, 0 - negative
);
    always @(posedge clk) begin
        if (rst) begin
            zc_pulse  <= 1'b0;
            state_pos <= 1'b0;
        end else begin
            zc_pulse <= 1'b0;

            if ((data_in > THRESHOLD) && !state_pos) begin
                state_pos <= 1'b1;
                zc_pulse  <= 1'b1; 
            end else if ((data_in < -THRESHOLD) && state_pos) begin
                state_pos <= 1'b0;
                zc_pulse  <= 1'b1; 
            end
        end
    end
endmodule
