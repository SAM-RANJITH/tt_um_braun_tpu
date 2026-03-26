module tt_um_braun_tpu (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,

    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,

    input  wire clk,
    input  wire rst_n,
    input  wire ena
);

wire rst = ~rst_n;

/////////////////////////////
// CONTROL UNIT (FIXED)
/////////////////////////////

wire [2:0] mem_addr;
wire mmu_en;
wire [2:0] mmu_cycle;

control_unit ctrl(
    .clk(clk),
    .rst(rst),
    .load_en(uio_in[0]),
    .mem_addr(mem_addr),
    .mmu_en(mmu_en),
    .mmu_cycle(mmu_cycle)
);

/////////////////////////////
// MEMORY
/////////////////////////////

wire [7:0] weight0, weight1, weight2, weight3;
wire [7:0] input0, input1, input2, input3;

memory mem(
    .clk(clk),
    .data_in(ui_in),
    .addr(mem_addr),
    .we(uio_in[0]),
    .weight0(weight0),
    .weight1(weight1),
    .weight2(weight2),
    .weight3(weight3),
    .input0(input0),
    .input1(input1),
    .input2(input2),
    .input3(input3)
);

/////////////////////////////
// SYSTOLIC ARRAY
/////////////////////////////

wire [7:0] a_data0, a_data1;
wire [7:0] b_data0, b_data1;

wire [15:0] c00, c01, c10, c11;

systolic_array_2x2 array(
    .clk(clk),
    .rst(rst),
    .a0(a_data0),
    .a1(a_data1),
    .b0(b_data0),
    .b1(b_data1),
    .c00(c00),
    .c01(c01),
    .c10(c10),
    .c11(c11)
);

/////////////////////////////
// MMU FEEDER (FIXED)
/////////////////////////////

wire [7:0] host_outdata;
wire done;

mmu_feeder feeder(
    .clk(clk),
    .rst(rst),
    .en(mmu_en),
    .mmu_cycle(mmu_cycle),

    .weight0(weight0),
    .weight1(weight1),
    .weight2(weight2),
    .weight3(weight3),

    .input0(input0),
    .input1(input1),
    .input2(input2),
    .input3(input3),

    .c00(c00),
    .c01(c01),
    .c10(c10),
    .c11(c11),

    .a_data0(a_data0),
    .a_data1(a_data1),
    .b_data0(b_data0),
    .b_data1(b_data1),

    .host_outdata(host_outdata),
    .done(done)
);

/////////////////////////////
// OUTPUT
/////////////////////////////

reg [7:0] out_reg;

always @(posedge clk) begin
    if (rst)
        out_reg <= 0;
    else if (done)
        out_reg <= host_outdata;
end

assign uo_out  = out_reg;
assign uio_out = 8'd0;
assign uio_oe  = 8'hFF;

endmodule
