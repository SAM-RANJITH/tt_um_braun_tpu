`default_nettype none

module braun_multiplier(

input wire [7:0] A,
input wire [7:0] B,
output wire [15:0] P

);

wire [7:0] pp [7:0];

genvar i,j;

generate
for(i=0;i<8;i=i+1) begin
    for(j=0;j<8;j=j+1) begin
        assign pp[i][j] = A[j] & B[i];
    end
end
endgenerate

assign P = A * B;

endmodule
