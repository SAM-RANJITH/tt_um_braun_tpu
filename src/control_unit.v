module control_unit(
    input wire clk,
    input wire rst,
    input wire ena,
    input wire load_en,

    output reg [2:0] mem_addr,
    output reg mmu_en,
    output reg [2:0] mmu_cycle
);

reg [3:0] load_count;

always @(posedge clk) begin
    if (rst) begin
        mem_addr <= 0;
        mmu_cycle <= 0;
        mmu_en <= 0;
        load_count <= 0;
    end else if (ena) begin

        if (load_en) begin
            mem_addr <= mem_addr + 1;
            load_count <= load_count + 1;
        end

        if (load_count == 8) begin
            mmu_en <= 1;
            mmu_cycle <= mmu_cycle + 1;
        end
    end
end

endmodule
