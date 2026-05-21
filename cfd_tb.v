`timescale 1ns / 1ps

module tb_cfd;
    parameter BIT_WIDTH = 12;
    parameter DELAY = 10;
    parameter SCALE_SHIFT = 1;

    reg clk;
    reg rst;
    reg  [BIT_WIDTH-1:0] din;
    wire [BIT_WIDTH:0]   dout;

    integer fd_in;
    integer fd_out;
    integer status;
    integer val_read;

    cfd #(
        .BIT_WIDTH(BIT_WIDTH),
        .DELAY(DELAY),
        .SCALE_SHIFT(SCALE_SHIFT)
    ) uut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .dout(dout)
    );

    // Clock (2GHz)
    initial begin
        clk = 0;
        forever #0.25 clk = ~clk; 
    end

    initial begin
        // Input
        fd_in = $fopen("input.csv", "r");
        if (fd_in == 0) begin
            $display("Error: Could not open input.csv");
            $finish;
        end

        // Output
        fd_out = $fopen("output.csv", "w");
        if (fd_out == 0) begin
            $display("Error: Could not create output.csv");
            $finish;
        end
        $fdisplay(fd_out, "time_ns,din,dout");

        rst = 1;
        din = 0;
        #2; 
        rst = 0;
        while (!$feof(fd_in)) begin
            @(negedge clk);
            status = $fscanf(fd_in, "%d", val_read);
            if (status == 1) begin
                din = val_read;
                $fdisplay(fd_out, "%0f,%d,%d", $realtime, din, $signed(dout));
            end
        end

        // Flush out the delay pipeline
        repeat (DELAY + 2) begin
            @(negedge clk);
            din = 0;
            $fdisplay(fd_out, "%0f,%d,%d", $realtime, din, $signed(dout));
        end

        $fclose(fd_in);
        $fclose(fd_out);
        $display("DONE (see output.csv)");
        $finish;
    end
endmodule
