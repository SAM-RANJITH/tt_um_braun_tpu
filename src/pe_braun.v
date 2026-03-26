module pe_braun(
    input wire clk,
    input wire rst,
    input wire ena,

    input wire [7:0] a_in,
    input wire [7:0] b_in,

    output reg [7:0] a_out,
    output reg [7:0] b_out,

    output reg [15:0] c_out
);

wire [15:0] mult = a_in * b_in;

always @(posedge clk) begin
    if (rst) begin
        c_out <= 0;
    end else if (ena) begin
        c_out <= c_out + mult;
        a_out <= a_in;
        b_out <= b_in;
    end
end

endmodule
