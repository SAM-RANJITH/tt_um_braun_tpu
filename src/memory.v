module memory(
    input clk, ena, we,
    input [7:0] data_in,
    input [2:0] addr,
    output [7:0] w0,w1,w2,w3,
    output [7:0] i0,i1,i2,i3
);

reg [7:0] mem_array [0:7];
integer k;

initial begin
    for (k=0;k<8;k=k+1)
        mem_array[k]=0;
end

always @(posedge clk)
    if (ena && we)
        mem_array[addr] <= data_in;

assign w0=mem_array[0];
assign w1=mem_array[1];
assign w2=mem_array[2];
assign w3=mem_array[3];

assign i0=mem_array[4];
assign i1=mem_array[5];
assign i2=mem_array[6];
assign i3=mem_array[7];

endmodule
