
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

  // Dump waveform
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb);
  end

  // Clock
  always #5 clk = ~clk;

  // Task: write memory
  task write_mem(input [7:0] data);
  begin
    @(posedge clk);
    ui_in  <= data;
    uio_in <= 8'b00000001; // WE = 1
  end
  endtask

  // Stop writing
  task stop_write;
  begin
    @(posedge clk);
    uio_in <= 8'b00000000;
  end
  endtask

  initial begin
    // Init
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;

    // Reset
    repeat(5) @(posedge clk);
    rst_n = 1;

    ///////////////////////////////////////
    // Write Matrix A (weights)
    ///////////////////////////////////////
    write_mem(8'd2); // weight0
    write_mem(8'd3); // weight1
    write_mem(8'd4); // weight2
    write_mem(8'd5); // weight3

    ///////////////////////////////////////
    // Write Matrix B (inputs)
    ///////////////////////////////////////
    write_mem(8'd1); // input0
    write_mem(8'd2); // input1
    write_mem(8'd3); // input2
    write_mem(8'd4); // input3

    stop_write();

    ///////////////////////////////////////
    // Wait for computation
    ///////////////////////////////////////
    repeat(20) @(posedge clk);

    ///////////////////////////////////////
    // Monitor output stream
    ///////////////////////////////////////
    $display("---- OUTPUT STREAM ----");
    repeat(10) begin
      @(posedge clk);
      $display("Time=%0t Output=%d", $time, uo_out);
    end

    ///////////////////////////////////////
    // Expected Results (for verification)
    ///////////////////////////////////////
    $display("Expected:");
    $display("C00 = 2*1 + 3*3 = 11");
    $display("C01 = 2*2 + 3*4 = 16");
    $display("C10 = 4*1 + 5*3 = 19");
    $display("C11 = 4*2 + 5*4 = 28");

    #50;
    $finish;
  end

endmodule
