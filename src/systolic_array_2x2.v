module systolic_array_2x2(
    input wire clk,
    input wire rst,
    input wire ena,

    input wire [7:0] a0,
    input wire [7:0] a1,
    input wire [7:0] b0,
    input wire [7:0] b1,

    output wire [15:0] c00,
    output wire [15:0] c01,
    output wire [15:0] c10,
    output wire [15:0] c11
);

wire [7:0] a00,a01,a10,a11;
wire [7:0] b00,b01,b10,b11;

pe_braun pe00(clk,rst,ena,a0,b0,a00,b00,c00);
pe_braun pe01(clk,rst,ena,a00,b1,a01,b01,c01);
pe_braun pe10(clk,rst,ena,a1,b00,a10,b10,c10);
pe_braun pe11(clk,rst,ena,a10,b01,a11,b11,c11);

endmodule
