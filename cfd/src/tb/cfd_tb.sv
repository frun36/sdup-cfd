`timescale 1ns / 1ps

module cfd_tb;
  parameter integer BIT_WIDTH_IN = 12;  // Input signal (ADC) bit width
  parameter integer DATA_MUX = 16;
  parameter integer DELAY = 3;
  parameter integer CFD_THRESHOLD = 50;  // hysteresis for noise immunity
  parameter integer CFD_ZERO = 0;  // detects cfd_zero crossing
  // Allow for fractional multiplication by having a divisor and multiplier
  parameter integer SCALE_DIV = 8;  // has to be a power of 2
  parameter integer SCALE_MULT = 11;  // has to be lower than 2*SCALE_DIV
  parameter integer BIT_WIDTH_OUT = BIT_WIDTH_IN + $clog2(
      SCALE_DIV
  ) + 1;  // Allow for maximum multiply of 2.0
  parameter integer FPGA_TIME_WIDTH = 16;  // DATA_MUX bit width is added to timestamp width

  parameter real ADC_PERIOD_NS = 0.5;

  reg                                          clk;
  reg                                          rst;
  reg                                          lhc_clk = 1'b0;

  // SystemVerilog Unpacked Arrays for ports
  reg                                          din_valid;
  reg        [               BIT_WIDTH_IN-1:0] din            [DATA_MUX];
  wire                                         pulse;
  wire       [uut.uut_tdc.TIMESTAMP_WIDTH-1:0] timestamp;

  reg signed [                BIT_WIDTH_OUT:0] cfd_threshold;
  reg signed [                BIT_WIDTH_OUT:0] cfd_zero;

  integer                                      fd_in;
  integer                                      fd_out;
  integer                                      status;
  integer                                      val_read;
  integer                                      i;
  reg                                          eof_flag;

  cfd_top #(
      .BIT_WIDTH_IN(BIT_WIDTH_IN),
      .DATA_MUX(DATA_MUX),
      .DELAY(DELAY),
      .SCALE_DIV(SCALE_DIV),
      .SCALE_MULT(SCALE_MULT),
      .BIT_WIDTH_OUT(BIT_WIDTH_OUT),
      .FPGA_TIME_WIDTH(FPGA_TIME_WIDTH)
  ) uut (
      .clk          (clk),
      .rst          (rst),
      .lhc_clk      (lhc_clk),
      .din_valid    (din_valid),
      .din          (din),
      .cfd_threshold(cfd_threshold),
      .cfd_zero     (cfd_zero),
      .pulse        (pulse),
      .timestamp    (timestamp)
  );

  // Clock (2GHz / DATA_MUX = 125MHz)
  initial begin
    clk = 0;
    cfd_threshold = (BIT_WIDTH_OUT + 1)'(CFD_THRESHOLD * SCALE_DIV);
    cfd_zero = (BIT_WIDTH_OUT + 1)'(CFD_ZERO * SCALE_DIV);

    forever #(0.5 * ADC_PERIOD_NS * DATA_MUX) clk = ~clk;
  end

  // File setup
  initial begin
    fd_in  = $fopen("input.csv", "r");
    fd_out = $fopen("output.csv", "w");
    if (fd_in == 0) begin
      $display("Error: Could not open input.csv");
      $finish;
    end
    if (fd_out == 0) begin
      $display("Error: Could not create output.csv");
      $finish;
    end
    $fdisplay(fd_out,
              "realtime,timestamp,din_valid,din,dout_valid,dout,zcd_out_valid,pulse,out_timestamp");
  end

  // Input and sim control
  initial begin
    rst = 1;
    eof_flag = 0;

    // Clear the array initially
    for (i = 0; i < DATA_MUX; i = i + 1) begin
      din[i] = 0;
    end

    #16;
    rst = 0;

    while (!eof_flag) begin
      if ($urandom_range(0, 99) < 20) begin  // 20% chance for break in data
        din_valid = 1'b0;
        repeat ($urandom_range(1, 2)) @(negedge clk);  // 1 to 4 cycles break
      end

      din_valid = 1'b1;

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
    end

    $fclose(fd_in);
    $fclose(fd_out);
    $display("DONE");
    $finish;
  end

  // Output
  always @(negedge clk) begin
    if (!rst)
      for (int k = 0; k < DATA_MUX; k = k + 1) begin
        $fdisplay(fd_out, "%0f,%d,%d,%d,%d,%d,%d,%d,%d", $realtime + ADC_PERIOD_NS * k,
                  uut.timestamps[k], uut.din_valid, uut.din[k], uut.cfd_dout_valid, (32)'($signed
                  (uut.dout[k])) / SCALE_DIV, uut.zcd_out_valid, pulse, timestamp);
      end
  end
endmodule
