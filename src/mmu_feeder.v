module mmu_feeder (
    input wire clk,
    input wire rst,
    input wire ena,
    input wire en,
    input wire [2:0] mmu_cycle,

    input wire [7:0] weight0, weight1, weight2, weight3,
    input wire [7:0] input0, input1, input2, input3,

    input wire [15:0] c00, c01, c10, c11,

    output reg [7:0] a_data0, a_data1,
    output reg [7:0] b_data0, b_data1,

    output reg [7:0] host_outdata,
    output reg done
);

// Avoid unused warning
wire _unused_c11 = &c11;

always @(posedge clk) begin
    if (rst) begin
        a_data0 <= 0;
        a_data1 <= 0;
        b_data0 <= 0;
        b_data1 <= 0;
        host_outdata <= 0;
        done <= 0;
    end else if (ena && en) begin
        done <= 0;

        case (mmu_cycle)
        0: begin a_data0 <= weight0; b_data0 <= input0; end
        1: begin a_data0 <= weight1; a_data1 <= weight2;
                 b_data0 <= input2;  b_data1 <= input1; end
        2: begin a_data1 <= weight3; b_data1 <= input3;
                 host_outdata <= c00[15:8]; done <= 1; end
        3: host_outdata <= c00[7:0];
        4: host_outdata <= c01[15:8];
        5: host_outdata <= c01[7:0];
        6: host_outdata <= c10[15:8];
        7: host_outdata <= c10[7:0];
        endcase
    end
end

endmodule
