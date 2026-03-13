`default_nettype none

module control_unit(

input wire clk,
input wire rst,
input wire load_en,

output reg [2:0] mem_addr,
output reg mmu_en,
output reg [2:0] mmu_cycle

);

always @(posedge clk)
begin

if (rst)
begin
    mem_addr <= 3'b000;
    mmu_cycle <= 3'b000;
    mmu_en <= 1'b0;
end

else
begin
    if(load_en)
        mem_addr <= mem_addr + 1;

    mmu_cycle <= mmu_cycle + 1;
    mmu_en <= 1'b1;
end

end

endmodule
