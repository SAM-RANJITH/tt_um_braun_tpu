`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump waveform
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
  end

  // Inputs
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;

  // Outputs
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate your TinyTapeout module
  tt_um_braun_tpu user_project (

`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,tb);

  // Clock generation
  always #5 clk = ~clk;

  // Test procedure
  initial begin

    clk = 0;
    rst_n = 0;
    ena = 1;

    ui_in = 0;
    uio_in = 0;

    #20;

    // Release reset
    rst_n = 1;

    // --------------------------
    // Load Matrix A
    // --------------------------

    ui_in = 8'd2;   // A00
    uio_in = 8'b00001000;  // addr=0 write
    #10;

    ui_in = 8'd3;   // A01
    uio_in = 8'b00001001;
    #10;

    ui_in = 8'd4;   // A10
    uio_in = 8'b00001010;
    #10;

    ui_in = 8'd5;   // A11
    uio_in = 8'b00001011;
    #10;

    // --------------------------
    // Load Matrix B
    // --------------------------

    ui_in = 8'd1;   // B00
    uio_in = 8'b00001100;
    #10;

    ui_in = 8'd2;   // B01
    uio_in = 8'b00001101;
    #10;

    ui_in = 8'd3;   // B10
    uio_in = 8'b00001110;
    #10;

    ui_in = 8'd4;   // B11
    uio_in = 8'b00001111;
    #10;

    // Wait for computation
    #200;

    $display("C00 = %d", uo_out);
    $display("C01 = %d", uio_out);

    #100;

    $finish;

  end

endmodule
