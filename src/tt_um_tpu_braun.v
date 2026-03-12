`default_nettype none

module tt_um_tpu_braun (
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

wire [7:0] a0,a1,b0,b1;
wire [15:0] c00,c01,c10,c11;

memory mem(
    .clk(clk),
    .data_in(ui_in),
    .addr(uio_in[2:0]),
    .we(uio_in[3]),
    .a0(a0),
    .a1(a1),
    .b0(b0),
    .b1(b1)
);

systolic_array_2x2 array(
    .clk(clk),
    .rst(rst),
    .a0(a0),
    .a1(a1),
    .b0(b0),
    .b1(b1),
    .c00(c00),
    .c01(c01),
    .c10(c10),
    .c11(c11)
);

assign uo_out = c00[7:0];
assign uio_out = c01[7:0];
assign uio_oe = 8'hFF;

endmodule
