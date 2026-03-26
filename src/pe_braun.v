module pe_braun(
    input wire clk,
    input wire rst,

    input wire [7:0] a_in,
    input wire [7:0] b_in,

    output reg [7:0] a_out,
    output reg [7:0] b_out,

    output reg [15:0] c_out
);

wire [15:0] mult;
assign mult = a_in * b_in;

always @(posedge clk) begin
    if (rst) begin
        c_out <= 0;
    end else begin
        if (^a_in !== 1'bx && ^b_in !== 1'bx)
            c_out <= c_out + mult;
    end

    a_out <= a_in;
    b_out <= b_in;
end

endmodule
