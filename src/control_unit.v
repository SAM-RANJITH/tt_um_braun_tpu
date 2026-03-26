module control_unit(
    input clk, rst, ena, load_en,
    output reg [2:0] mem_addr,
    output reg mmu_en,
    output reg [2:0] mmu_cycle
);

reg [3:0] count;

always @(posedge clk) begin
    if (rst) begin
        mem_addr<=0; mmu_cycle<=0; mmu_en<=0; count<=0;
    end else if (ena) begin
        if (load_en) begin
            mem_addr <= mem_addr + 1;
            count <= count + 1;
        end
        if (count==8) begin
            mmu_en <= 1;
            mmu_cycle <= mmu_cycle + 1;
        end
    end
end
endmodule
