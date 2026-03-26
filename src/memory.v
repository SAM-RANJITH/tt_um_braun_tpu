module memory(
    input wire clk,
    input wire [7:0] data_in,
    input wire [2:0] addr,
    input wire we,

    output wire [7:0] weight0,
    output wire [7:0] weight1,
    output wire [7:0] weight2,
    output wire [7:0] weight3,

    output wire [7:0] input0,
    output wire [7:0] input1,
    output wire [7:0] input2,
    output wire [7:0] input3
);

reg [7:0] mem [0:7];

always @(posedge clk)
    if (we)
        mem[addr] <= data_in;

assign weight0 = mem[0];
assign weight1 = mem[1];
assign weight2 = mem[2];
assign weight3 = mem[3];

assign input0 = mem[4];
assign input1 = mem[5];
assign input2 = mem[6];
assign input3 = mem[7];

endmodule
