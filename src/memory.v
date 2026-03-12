`default_nettype none

module memory(
input wire clk,
input wire [7:0] data_in,
input wire [2:0] addr,
input wire we,

output wire [7:0] a0,
output wire [7:0] a1,
output wire [7:0] b0,
output wire [7:0] b1
);

reg [7:0] mem[0:7];

always @(posedge clk)
begin
 if(we)
   mem[addr] <= data_in;
end

assign a0 = mem[0];
assign a1 = mem[1];
assign b0 = mem[4];
assign b1 = mem[5];

endmodule
