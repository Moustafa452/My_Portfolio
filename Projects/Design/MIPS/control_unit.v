module control_unit(
    input            rst_n,
    input     [31:0] flag_reg,
    input     [31:0] ins,
    output reg       memwrite,
    output reg       memread,
    output reg       memtoreg,
    output reg       regdst,
    output reg       PCSRC,
    output reg [2:0] ALUop,
    output reg       ALUSrc,
    output reg       reg_write_c
);

reg [5:0] opcode;
reg [5:0] funct; 

always @(*) begin
    opcode = ins[31:26];
    funct  = ins[5:0];
    memwrite    = 0;
    memread     = 0;
    memtoreg    = 0;
    regdst      = 0;
    PCSRC       = 0;
    ALUop       = 3'b000;
    ALUSrc      = 0;
    reg_write_c = 0;
    case(opcode)
        6'b000000: begin // R-type
            memwrite    = 0;
            memread     = 0;
            memtoreg    = 0;
            regdst      = 1;
            PCSRC       = 0;
            ALUSrc      = 0;
            reg_write_c = 1;
            case(funct)
                6'b000000: ALUop = 3'b000; // ADD
                6'b000001: ALUop = 3'b001; // SUB
                6'b000010: ALUop = 3'b100; // AND
                6'b000011: ALUop = 3'b101; // OR
                6'b000100: ALUop = 3'b110; // SLT
                default:   ALUop = 3'b000; // Default to ADD
            endcase
        end
        // Additional cases for other instruction types can be added here
        6'b100011: begin //lw
            reg_write_c = 1;
            memwrite    = 0;
            memread     = 1;
            ALUop       = 3'b000;
            ALUSrc      = 1;
            regdst      = 0;
            memtoreg    = 1;
            PCSRC       = 0;
        end
        6'b101011: begin //sw
            reg_write_c = 0;
            memwrite    = 1;
            memread     = 0;
            ALUop       = 3'b000;
            ALUSrc      = 1;
            regdst      = 1'b0;
            memtoreg    = 1'b0;
            PCSRC       = 0;
        end
        6'b000100: begin //beq
            reg_write_c     = 0;
            memwrite        = 0;
            memread         = 0;
            ALUop           = 3'b001;
            ALUSrc          = 0;
            regdst          = 1'b0;
            memtoreg        = 1'b0;
            if(flag_reg[0] == 1)
                PCSRC = 1;
            else
                PCSRC = 0;
        end
        6'b001000: begin // addi
            reg_write_c     = 1;     
            memwrite        = 0;
            memread         = 0;
            ALUop           = 3'b000; 
            ALUSrc          = 1;      
            regdst          = 0;      
            memtoreg        = 0;
            PCSRC           = 0;
        end
        6'b000010: begin //j
            reg_write_c     = 0;
            memwrite        = 0;
            memread         = 0;
            ALUop           = 3'b000;
            ALUSrc          = 1'b0;
            regdst          = 1'b0;
            memtoreg        = 1'b0;
            PCSRC           = 1;
        end
        default: begin
        memwrite            = 0;
        memread             = 0;
        memtoreg            = 0;
        regdst              = 0;
        PCSRC               = 0;
        ALUop               = 3'b000;
        ALUSrc              = 0;
        reg_write_c         = 0;
        end
    endcase
end
endmodule
