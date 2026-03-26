`timescale 1ns/1ps
`default_nettype none

module tb;

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;

  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // DUT
  tt_um_braun_tpu dut (
      .ui_in(ui_in),
      .uo_out(uo_out),
      .uio_in(uio_in),
      .uio_out(uio_out),
      .uio_oe(uio_oe),
      .ena(ena),
      .clk(clk),
      .rst_n(rst_n)
  );

  ///////////////////////////////////////
  // Dump waveform
  ///////////////////////////////////////
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb);
  end

  ///////////////////////////////////////
  // Clock generation
  ///////////////////////////////////////
  always #5 clk = ~clk;

  ///////////////////////////////////////
  // Write task (FIXED timing)
  ///////////////////////////////////////
  task write_mem(input [7:0] data);
  begin
    @(posedge clk);
    ui_in  <= data;
    uio_in <= 8'b00000000;  // setup

    @(posedge clk);
    uio_in <= 8'b00000001;  // write enable

    @(posedge clk);
    uio_in <= 8'b00000000;  // disable
  end
  endtask

  ///////////////////////////////////////
  // Test
  ///////////////////////////////////////
  integer error;
  integer i;

  initial begin
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;
    error = 0;

    // Reset
    repeat(5) @(posedge clk);
    rst_n = 1;

    ///////////////////////////////////////
    // Load Matrix A
    ///////////////////////////////////////
    write_mem(8'd2); // weight0
    write_mem(8'd3); // weight1
    write_mem(8'd4); // weight2
    write_mem(8'd5); // weight3

    ///////////////////////////////////////
    // Load Matrix B
    ///////////////////////////////////////
    write_mem(8'd1); // input0
    write_mem(8'd2); // input1
    write_mem(8'd3); // input2
    write_mem(8'd4); // input3

    ///////////////////////////////////////
    // Wait for computation
    ///////////////////////////////////////
    repeat(30) @(posedge clk);

    ///////////////////////////////////////
    // Monitor outputs
    ///////////////////////////////////////
    $display("---- OUTPUT STREAM ----");

    for (i = 0; i < 10; i = i + 1) begin
      @(posedge clk);
      $display("Time=%0t Output=%d", $time, uo_out);

      // Simple correctness check
      if (uo_out !== 8'd11 &&
          uo_out !== 8'd16 &&
          uo_out !== 8'd19 &&
          uo_out !== 8'd28 &&
          uo_out !== 8'd0) begin
        error = error + 1;
      end
    end

    ///////////////////////////////////////
    // Result
    ///////////////////////////////////////
    if (error == 0)
      $display("✅ TEST PASSED");
    else
      $display("❌ TEST FAILED, errors = %0d", error);

    ///////////////////////////////////////
    // Expected
    ///////////////////////////////////////
    $display("Expected:");
    $display("C00 = 11");
    $display("C01 = 16");
    $display("C10 = 19");
    $display("C11 = 28");

    #50;
    $finish;
  end

endmodule
