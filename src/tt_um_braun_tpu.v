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

// avoid unused warnings
wire _unused = &{uio_in[7:1], 1'b0};

//////////////// CONTROL //////////////////

wire [2:0] mem_addr;
wire mmu_en;
wire [2:0] mmu_cycle;

control_unit ctrl(
    .clk(clk),
    .rst(rst),
    .ena(ena),
    .load_en(uio_in[0]),
    .mem_addr(mem_addr),
    .mmu_en(mmu_en),
    .mmu_cycle(mmu_cycle)
);

//////////////// MEMORY //////////////////

wire [7:0] w0,w1,w2,w3;
wire [7:0] i0,i1,i2,i3;

memory mem_inst(
    .clk(clk),
    .ena(ena),
    .data_in(ui_in),
    .addr(mem_addr),
    .we(uio_in[0]),
    .w0(w0), .w1(w1), .w2(w2), .w3(w3),
    .i0(i0), .i1(i1), .i2(i2), .i3(i3)
);

//////////////// SYSTOLIC //////////////////

wire [7:0] a0,a1,b0,b1;
wire [15:0] c00,c01,c10,c11;

systolic_array_2x2 sa(
    .clk(clk),
    .rst(rst),
    .ena(ena),
    .a0(a0), .a1(a1),
    .b0(b0), .b1(b1),
    .c00(c00), .c01(c01),
    .c10(c10), .c11(c11)
);

//////////////// MMU //////////////////

wire [7:0] host_out;
wire done;

mmu_feeder mmu(
    .clk(clk),
    .rst(rst),
    .ena(ena),
    .en(mmu_en),
    .mmu_cycle(mmu_cycle),

    .w0(w0), .w1(w1), .w2(w2), .w3(w3),
    .i0(i0), .i1(i1), .i2(i2), .i3(i3),

    .c00(c00), .c01(c01), .c10(c10), .c11(c11),

    .a0(a0), .a1(a1),
    .b0(b0), .b1(b1),

    .host_out(host_out),
    .done(done)
);

//////////////// OUTPUT //////////////////

reg [7:0] out_reg;

always @(posedge clk) begin
    if (rst)
        out_reg <= 0;
    else if (ena && done)
        out_reg <= host_out;
end

assign uo_out  = (done) ? out_reg : 8'd0; // X-safe
assign uio_out = 0;
assign uio_oe  = 8'hFF;

endmodule
