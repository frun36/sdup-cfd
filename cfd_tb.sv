`timescale 1ns / 1ps

module cfd_tb;
  parameter integer BIT_WIDTH = 12;
  parameter integer DELAY = 10;
  parameter integer SCALE_SHIFT = 1;
  parameter integer CFD_THR = 100;
  parameter integer DATA_MUX = 16;

  reg                     clk;
  reg                     rst;

  // SystemVerilog Unpacked Arrays for ports
  reg     [BIT_WIDTH-1:0] din      [DATA_MUX];
  wire                    pulse;

  integer                 fd_in;
  integer                 fd_out;
  integer                 status;
  integer                 val_read;
  integer                 i;
  reg                     eof_flag;

  top #(
      .BIT_WIDTH(BIT_WIDTH),
      .DELAY(DELAY),
      .SCALE_SHIFT(SCALE_SHIFT),
      .CFD_THR(CFD_THR),
      .DATA_MUX(DATA_MUX)
  ) uut (
      .clk  (clk),
      .rst  (rst),
      .din  (din),
      .pulse(pulse)
  );

  // Clock (2GHz / DATA_MUX = 125MHz)
  initial begin
    clk = 0;
    forever #4 clk = ~clk;
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
    $fdisplay(fd_out, "time_ns,din,dout,pulse");

    rst = 1;
    eof_flag = 0;

    // Clear the array initially
    for (i = 0; i < DATA_MUX; i = i + 1) begin
      din[i] = 0;
    end

    #16;
    rst = 0;

    while (!eof_flag) begin
      // 1. Read a block of DATA_MUX samples directly into the array
      for (i = 0; i < DATA_MUX; i = i + 1) begin
        if (!$feof(fd_in)) begin
          status = $fscanf(fd_in, "%d", val_read);
          if (status == 1) begin
            din[i] = val_read[11:0];
          end else begin
            din[i]   = 0;
            eof_flag = 1;
          end
        end else begin
          din[i]   = 0;
          eof_flag = 1;
        end
      end

      @(negedge clk);

      // 2. Write output sequentially to remain compatible with old CSV format
      for (i = 0; i < DATA_MUX; i = i + 1) begin
        // Zero-crossing detection is commented out for now.
        // Writing '0' for dout and pulse to maintain 4-column structure.
        $fdisplay(fd_out, "%0f,%d,%d,0", $realtime + 0.5 * i, din[i], $signed(uut.dout[i]));
      end
    end

    // Flush out the delay pipeline
    repeat (DELAY + 2) begin
      for (i = 0; i < DATA_MUX; i = i + 1) begin
        din[i] = 0;
      end

      @(negedge clk);

      for (i = 0; i < DATA_MUX; i = i + 1) begin
        $fdisplay(fd_out, "%0f,0,0,0", $realtime);
      end
    end

    $fclose(fd_in);
    $fclose(fd_out);
    $display("DONE (see output.csv)");
    $finish;
  end
endmodule
