module pe(
    input clk,rst,ena,
    input [7:0] a,b,
    output reg [7:0] ao,bo,
    output reg [15:0] c
);

wire [15:0] mult = a*b;

always @(posedge clk) begin
    if (rst) begin
        c<=0; ao<=0; bo<=0;
    end else if (ena) begin
        if (^a!==1'bx && ^b!==1'bx)
            c <= c + mult;
        ao <= a;
        bo <= b;
    end
end
endmodule
