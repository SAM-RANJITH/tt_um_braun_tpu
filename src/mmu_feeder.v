module mmu_feeder(
    input clk,rst,ena,en,
    input [2:0] mmu_cycle,

    input [7:0] w0,w1,w2,w3,
    input [7:0] i0,i1,i2,i3,

    input [15:0] c00,c01,c10,c11,

    output reg [7:0] a0,a1,b0,b1,
    output reg [7:0] host_out,
    output reg done
);

wire _unused = &c11;

always @(posedge clk) begin
    if (rst) begin
        a0<=0;a1<=0;b0<=0;b1<=0;host_out<=0;done<=0;
    end else if (ena && en) begin
        done<=0;
        case(mmu_cycle)
        0: begin a0<=w0; b0<=i0; end
        1: begin a0<=w1; a1<=w2; b0<=i2; b1<=i1; end
        2: begin a1<=w3; b1<=i3; host_out<=c00[15:8]; done<=1; end
        3: host_out<=c00[7:0];
        4: host_out<=c01[15:8];
        5: host_out<=c01[7:0];
        6: host_out<=c10[15:8];
        7: host_out<=c10[7:0];
        endcase
    end
end
endmodule
