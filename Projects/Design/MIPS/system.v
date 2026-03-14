module system(
    input         clk,
    input         rst_n,
    output [31:0] alu_result
);

    wire memread, memwrite, memtoreg;
    wire [31:0] instruction, write_data, read_data, adr_c;
    reg  [31:0] read_data_reg;
    
    reg en_d, en_c;
    reg [31:0] adr_d;
    reg memread_d, memwrite_d;
    
    // NEW: Cycle counter and gated clock
    reg cycle_count;  // 0 = first cycle, 1 = second cycle
    reg mips_clk;     // Gated clock for MIPS - only ticks on second cycle

    mips mips_inst (
        .clk(mips_clk),  // Use gated clock instead of system clock
        .rst_n(rst_n),
        .instr(instruction),
        .data_in(read_data_reg),
        .memread(memread),
        .memwrite(memwrite),
        .memtoreg(memtoreg),
        .data_out(write_data),
        .alu_result(alu_result),
        .current_PC(adr_c)
    );

    data_segment DS_inst(
        .rst_n(rst_n),
        .en(en_d),
        .adr(adr_d),
        .wdata(write_data),
        .memwrite(memwrite_d),
        .memread(memread_d),
        .rdata(read_data)
    );

    code_segment CS_inst(
        .adr(adr_c),
        .en(en_c),
        .ins(instruction)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_c <= 1'b0;
            en_d <= 1'b0;
            adr_d <= 32'b0;
            memread_d  <= 1'b0;
            memwrite_d <= 1'b0;
            read_data_reg <= 32'b0;
            cycle_count <= 1'b0;
            mips_clk <= 1'b0;
        end else begin
            // Toggle cycle counter
            cycle_count <= ~cycle_count;
            
            // Generate clock pulse for MIPS only on second cycle (when cycle_count = 1)
            if (cycle_count == 1'b1) begin
                mips_clk <= ~mips_clk;  // Toggle MIPS clock
            end
            
            en_c <= 1'b1;

            // Register memory controls and address
            if(instruction[31:26] == 6'b000000 || instruction[31:26] == 6'b001000) begin
                en_d <= 0;
                memread_d  <= 0;
                memwrite_d <= 0;
            end else begin
                en_d <= 1;
                adr_d <= alu_result;
                memread_d  <= memread;
                memwrite_d <= memwrite;
                read_data_reg <= read_data;
            end
        end
    end

endmodule