`default_nettype none

module control_unit(

input wire clk,
input wire rst,
input wire start,
output reg done

);

reg [3:0] state;

always @(posedge clk) begin

if(rst)
state <= 0;
else
state <= state + 1;

if(state == 10)
done <= 1;
else
done <= 0;

end

endmodule
