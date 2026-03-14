module mips (
    input              clk,
    input              rst_n,
    input       [31:0] instr,
    input       [31:0] data_in,

    output              memread,
    output              memwrite,
    output              memtoreg,
    output reg  [31:0]  data_out,
    output reg  [31:0]  alu_result,
    output reg  [31:0]  current_PC
);

    // =========================
    // Internal signals
    // =========================
    reg  [31:0] PC;
    wire [31:0] pc_next;

    wire [31:0] rdata1, rdata2;
    wire [31:0] alu_b;
    wire [31:0] alu_res;
    wire [31:0] sign_ext_imm;

    wire        regdst;
    wire        PCSRC;
    wire        reg_write_c;
    wire        ALUSrc;
    wire [2:0]  ALUop;
    wire [31:0] FR;

    // =========================
    // Instruction fields
    // =========================
    wire [5:0] opcode = instr[31:26];
    wire [4:0] rs     = instr[25:21];
    wire [4:0] rt     = instr[20:16];
    wire [4:0] rd     = instr[15:11];
    wire [15:0] imm   = instr[15:0];

    // =========================
    // Sign extension
    // =========================
    assign sign_ext_imm = {{16{imm[15]}}, imm};

    // =========================
    // Register File
    // =========================
    register_file RF (
        .clk(clk),
        .rst_n(rst_n),
        .a1(rs),
        .a2(rt),
        .a3(regdst ? rd : rt),
        .write_data(memtoreg ? data_in : alu_res),
        .reg_write(reg_write_c),
        .reg_dst(regdst),
        .read_data1(rdata1),
        .read_data2(rdata2)
    );

    // =========================
    // ALU
    // =========================
    assign alu_b = ALUSrc ? sign_ext_imm : rdata2;

    alu ALU (
        .a(rdata1),
        .b(alu_b),
        .sel(ALUop),
        .flag_reg(FR),
        .res(alu_res)
    );

    // =========================
    // Control Unit (combinational)
    // =========================
    control_unit CU (
        .rst_n(rst_n),
        .flag_reg(FR),
        .ins(instr),
        .memwrite(memwrite),
        .memread(memread),
        .memtoreg(memtoreg),
        .regdst(regdst),
        .PCSRC(PCSRC),
        .ALUop(ALUop),
        .ALUSrc(ALUSrc),
        .reg_write_c(reg_write_c)
    );

    // =========================
    // PC logic (single-cycle)
    // =========================
    assign pc_next = PCSRC
                   ? (PC + 4 + (sign_ext_imm << 2))
                   : (PC + 4);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            PC <= 32'b0;
        else
            PC <= pc_next;
            
        current_PC <= PC;
    end

    // =========================
    // Outputs (combinational)
    // =========================
    always @(*) begin
        alu_result = alu_res;
        data_out   = rdata2;   // store data for SW
    end

endmodule
