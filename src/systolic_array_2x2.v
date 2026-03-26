module systolic_array_2x2(
    input clk,rst,ena,
    input [7:0] a0,a1,b0,b1,
    output [15:0] c00,c01,c10,c11
);

wire [7:0] a00,a01,a10,a11;
wire [7:0] b00,b01,b10,b11;

pe p0(clk,rst,ena,a0,b0,a00,b00,c00);
pe p1(clk,rst,ena,a00,b1,a01,b01,c01);
pe p2(clk,rst,ena,a1,b00,a10,b10,c10);
pe p3(clk,rst,ena,a10,b01,a11,b11,c11);

endmodule
