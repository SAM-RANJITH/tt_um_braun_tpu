`default_nettype none

module mmu_feeder (

    input  wire        clk,
    input  wire        rst,
    input  wire        en,
    input  wire [2:0]  mmu_cycle,

    // matrices from memory
    input  wire [7:0] weight0,
    input  wire [7:0] weight1,
    input  wire [7:0] weight2,
    input  wire [7:0] weight3,

    input  wire [7:0] input0,
    input  wire [7:0] input1,
    input  wire [7:0] input2,
    input  wire [7:0] input3,

    // results from systolic array
    input  wire [15:0] c00,
    input  wire [15:0] c01,
    input  wire [15:0] c10,
    input  wire [15:0] c11,

    // data to systolic array
    output reg [7:0] a_data0,
    output reg [7:0] a_data1,
    output reg [7:0] b_data0,
    output reg [7:0] b_data1,

    // host interface
    output reg [7:0] host_outdata,
    output reg done
);

always @(posedge clk) begin

    if (rst) begin
        a_data0 <= 0;
        a_data1 <= 0;
        b_data0 <= 0;
        b_data1 <= 0;
        host_outdata <= 0;
        done <= 0;
    end

    else if (en) begin

        case (mmu_cycle)

        // Feed first elements
        3'd0: begin
            a_data0 <= weight0;
            b_data0 <= input0;
            done <= 0;
        end

        // Feed second stage
        3'd1: begin
            a_data0 <= weight1;
            a_data1 <= weight2;

            b_data0 <= input2;
            b_data1 <= input1;
        end

        // Feed last values and start output
        3'd2: begin
            a_data1 <= weight3;
            b_data1 <= input3;

            host_outdata <= c00[15:8];
            done <= 1;
        end

        // Output stream
        3'd3: host_outdata <= c00[7:0];
        3'd4: host_outdata <= c01[15:8];
        3'd5: host_outdata <= c01[7:0];
        3'd6: host_outdata <= c10[15:8];
        3'd7: host_outdata <= c10[7:0];

        default: begin
            a_data0 <= 0;
            a_data1 <= 0;
            b_data0 <= 0;
            b_data1 <= 0;
        end

        endcase

    end

end

endmodule
