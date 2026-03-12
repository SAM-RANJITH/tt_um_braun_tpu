`default_nettype none

module braun_multiplier(

input wire [7:0] A,
input wire [7:0] B,
output wire [15:0] P

);

assign P = A * B;

endmodule
