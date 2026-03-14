module testbench;

import pkg::*;

    logic clk;
    logic rst_n;

    initial begin
        clk = 0;
        forever begin
            #5ns;
            clk = ~clk;
        end
    end
/*
    logic  [11:0] adr;
    logic         en;
    logic  [31:0] ins;
    logic  [31:0] ins_Q[$];
    logic  [31:0] exp_Q[$];
*/

    //code_segment dut (.*);

/*
    logic   [31:0]  flag_reg;
    logic   [31:0]  ins;
    logic           memwrite;
    logic           memread;
    logic           memtoreg;
    logic           regdst;
    logic           PCSRC;
    logic   [2:0]   ALUop;
    logic           ALUSrc;
    logic           reg_write_c;
*/
    //control_unit dut(.*);

/*
    //actual queues
    logic           act_memwrite[$];
    logic           act_memread[$];
    logic           act_memtoreg[$];
    logic           act_regdst[$];
    logic           act_PCSRC[$];
    logic   [2:0]   act_ALUop[$];
    logic           act_ALUSrc[$];
    logic           act_reg_write_c[$];
    //expected queues
    logic           exp_memwrite    [$];
    logic           exp_memread     [$];
    logic           exp_memtoreg    [$];
    logic           exp_regdst      [$];
    logic           exp_PCSRC       [$];
    logic   [2:0]   exp_ALUop       [$];
    logic           exp_ALUSrc      [$];
    logic           exp_reg_write_c [$];
    CU_transaction tr;
*/

/*   
    task automatic CU_golden_model (ref logic [31:0] ins, flag_reg, ref logic  exp_memwrite    [$],
                                                                            exp_memread     [$],
                                                                            exp_memtoreg    [$],
                                                                            exp_regdst      [$],
                                                                            exp_PCSRC       [$],
                                                                            exp_ALUSrc      [$],
                                                                            exp_reg_write_c [$],
                                                                       [2:0]exp_ALUop       [$]);
        case(ins[31:26])
            6'b000000: begin // R-type
                exp_memwrite.push_back(0);
                exp_memread.push_back(0);
                exp_memtoreg.push_back(0);
                exp_regdst.push_back(1);
                exp_PCSRC.push_back(0);
                exp_ALUSrc.push_back(0);
                exp_reg_write_c.push_back(1);
                case(ins[5:0])
                    6'b000000: exp_ALUop.push_back(3'b000); // ADD
                    6'b000001: exp_ALUop.push_back(3'b001); // SUB
                    6'b000010: exp_ALUop.push_back(3'b100); // AND
                    6'b000011: exp_ALUop.push_back(3'b101); // OR
                    6'b000100: exp_ALUop.push_back(3'b110); // SLT
                    default:   exp_ALUop.push_back(3'b000); // Default to ADD
                endcase
            end
            // Additional cases for other instruction types can be added here
            6'b100011: begin //lw
                exp_reg_write_c.push_back(1);
                exp_memwrite.push_back(0);
                exp_memread.push_back(1);
                exp_ALUop.push_back(3'b000);
                exp_ALUSrc.push_back(1);
                exp_regdst.push_back(0);
                exp_memtoreg.push_back(1);
                exp_PCSRC.push_back(0);
            end
            6'b101011: begin //sw
                exp_reg_write_c.push_back(0);
                exp_memwrite.push_back(1);
                exp_memread.push_back(0);
                exp_ALUop.push_back(3'b000);
                exp_ALUSrc.push_back(1);
                exp_regdst.push_back(1'b0);
                exp_memtoreg.push_back(1'b0);
                exp_PCSRC.push_back(0);
            end
            6'b000100: begin //beq
                exp_reg_write_c.push_back(0);
                exp_memwrite.push_back(0);
                exp_memread.push_back(0);
                exp_ALUop.push_back(3'b001);
                exp_ALUSrc.push_back(0);
                exp_regdst.push_back(1'b0);
                exp_memtoreg.push_back(1'b0);
                if(flag_reg[0] == 1)
                    exp_PCSRC.push_back(1);
                else
                    exp_PCSRC.push_back(0);
            end
            6'b001000: begin //bne
                exp_reg_write_c.push_back(0);
                exp_memwrite   .push_back(0);
                exp_memread    .push_back(0);
                exp_ALUop      .push_back(3'b001);
                exp_ALUSrc     .push_back(0);
                exp_regdst     .push_back(1'b0);
                exp_memtoreg   .push_back(1'b0);
                if(flag_reg[0] == 1)
                    exp_PCSRC.push_back(0);
                else
                    exp_PCSRC.push_back(1);
            end
            6'b000010: begin //j
                exp_reg_write_c.push_back(0);
                exp_memwrite.push_back(0);
                exp_memread.push_back(0);
                exp_ALUop.push_back(3'b000);
                exp_ALUSrc.push_back(1'b0);
                exp_regdst.push_back(1'b0);
                exp_memtoreg.push_back(1'b0);
                exp_PCSRC.push_back(1);
            end
            default: begin
            exp_memwrite.push_back(0);
            exp_memread.push_back(0);
            exp_memtoreg.push_back(0);
            exp_regdst.push_back(0);
            exp_PCSRC.push_back(0);
            exp_ALUop.push_back(3'b000);
            exp_ALUSrc.push_back(0);
            exp_reg_write_c.push_back(0);
            end
        endcase
    endtask
*/

/*
    logic   [11:0] adr;
    logic   [31:0] wdata;
    logic          memwrite;
    logic          memread;
    logic   [31:0] ins;
    logic   [31:0] rdata;
    logic   [31:0] exp_data [$];
    logic   [31:0] exp_code [$];
    logic   [31:0] act_data [$];
    logic   [31:0] act_code [$];
    int j = 0;

    memory dut(.*);
*/
/*
    logic [31:0] instr;
    logic [31:0] data_in;
    logic        memread, memwrite, memtoreg;
    logic [31:0] data_out;
    logic [31:0] alu_result;
    MIPS_transaction tr;
*/
/*
    task automatic MIPS_golden_model (
        input  logic [31:0] ins,
        ref logic        exp_memreadQ[$],
        ref logic        exp_memwriteQ[$],
        ref logic        exp_memtoregQ[$],
        ref logic [31:0] exp_data_outQ[$],
        ref logic [31:0] exp_alu_resultQ[$]
    );

        // -----------------------------
        // ALL DECLARATIONS FIRST
        // -----------------------------
        logic [5:0] opcode;
        logic [5:0] funct;
        logic       memread;
        logic       memwrite;
        logic       memtoreg;
        logic [31:0] data_out;
        logic [31:0] alu_result;

        // -----------------------------
        // INITIALIZE DEFAULTS
        // -----------------------------
        memread    = 0;
        memwrite   = 0;
        memtoreg   = 0;
        data_out   = 32'b0;
        alu_result = 32'b0;

        opcode = ins[31:26];
        funct  = ins[5:0];

        case (opcode)

            // ---------------- R-TYPE ----------------
            6'b000000: begin
                memread    = 0;
                memwrite   = 0;
                memtoreg   = 0;

                case (funct)
                    6'b000000: alu_result = 32'hDEAD0001; // ADD
                    6'b000001: alu_result = 32'hDEAD0002; // SUB
                    6'b000010: alu_result = 32'hDEAD0003; // AND
                    6'b000011: alu_result = 32'hDEAD0004; // OR
                    6'b000100: alu_result = 32'hDEAD0005; // SLT
                    default:   alu_result = 32'h0;
                endcase
            end

            // ---------------- LW ----------------
            6'b100011: begin
                memread    = 1;
                memwrite   = 0;
                memtoreg   = 1;
                alu_result = 32'b0 + {{16{ins[15]}}, ins[15:0]};
            end

            // ---------------- SW ----------------
            6'b101011: begin
                memread    = 0;
                memwrite   = 1;
                memtoreg   = 0;
                data_out   = 32'hDEAD2000;
                alu_result = 32'hDEAD2000;
            end

            // ---------------- BEQ ----------------
            6'b000100: begin
                memread    = 0;
                memwrite   = 0;
                memtoreg   = 0;
                alu_result = 32'b0;
            end

            // ---------------- BNE ----------------
            6'b001000: begin
                memread    = 0;
                memwrite   = 0;
                memtoreg   = 0;
                alu_result = 32'b0;
            end

            // ---------------- J ----------------
            6'b000010: begin
                memread    = 0;
                memwrite   = 0;
                memtoreg   = 0;
                alu_result = 32'b0;
            end

            default: begin
                // keep defaults
            end
        endcase

        // -----------------------------
        // push into queues
        // -----------------------------
        exp_memreadQ.push_back(memread);
        exp_memwriteQ.push_back(memwrite);
        exp_memtoregQ.push_back(memtoreg);
        exp_data_outQ.push_back(data_out);
        exp_alu_resultQ.push_back(alu_result);

        endtask
*/
/*
    logic        act_memreadQ[$], act_memwriteQ[$], act_memtoregQ[$];
    logic [31:0] act_data_outQ[$];
    logic [31:0] act_alu_resultQ[$];
    logic        exp_memreadQ[$], exp_memwriteQ[$], exp_memtoregQ[$];
    logic [31:0] exp_data_outQ[$];
    logic [31:0] exp_alu_resultQ[$];

    mips dut(.*);
*/

    logic [31:0] alu_result;
    system dut(.*);


    initial begin
        
        rst_n = 1'b0;
        #10ns
        rst_n = 1'b1;

        for(int i = 0; i < 100; i++) begin
            @(posedge clk)
            $display("resultes: %h", alu_result);
        end

     
     
     
     
     
     
     
     
     
     /*    
        act_memreadQ    = {};
        act_memwriteQ   = {}; 
        act_memtoregQ   = {};
        act_data_outQ   = {}; 
        act_alu_resultQ = {};
        exp_memreadQ    = {}; 
        exp_memwriteQ   = {}; 
        exp_memtoregQ   = {};
        exp_data_outQ   = {}; 
        exp_alu_resultQ = {};
        instr           = 32'h00000000;
        data_in         = 32'h00000000;

        rst_n = 0;
        #10ns
        rst_n = 1;

        tr = new();
        assert(tr.randomize()) else begin
            $display("randoization failed\n");
        end

        foreach(tr.instr[i]) begin
            @(negedge clk)
            instr = tr.instr[i];
            data_in = tr.data_in[i];
            @(negedge clk)
            act_memreadQ.push_back(memread);
            act_memwriteQ.push_back(memwrite);
            act_memtoregQ.push_back(memtoreg);
            act_data_outQ.push_back(data_out);
            act_alu_resultQ.push_back(alu_result);
        end

        foreach(tr.instr[i]) begin
            MIPS_golden_model(tr.instr[i],  exp_memreadQ,   
                                            exp_memwriteQ,  
                                            exp_memtoregQ,  
                                            exp_data_outQ,    
                                            exp_alu_resultQ);
        end

        for(int i = 0; i < 256; i++) begin
            //memread
            if(act_memreadQ[i] == exp_memreadQ[i]) begin
                $display("[memread]PASS\n");
            end else begin
                $display("[memread]FAIL actual memread signal: %h, expected memread signal: %h, instruction: %h\n", act_memreadQ[i], exp_memreadQ[i], tr.instr[255-i]);
            end
            //memwrite
            if(act_memwriteQ[i] == exp_memwriteQ[i]) begin
                $display("[memwrite]PASS\n");
            end else begin
                $display("[memwrite]FAIL actual memwrite signal: %h, expected memwrite signal: %h, instruction: %h\n", act_memwriteQ[i], exp_memwriteQ[i], tr.instr[255-i]);
            end
            //memtoreg
            if(act_memtoregQ[i] == exp_memtoregQ[i]) begin
                $display("[memtoreg]PASS\n");
            end else begin
                $display("[memtoreg]FAIL actual memtoreg signal: %h, expected memtoreg signal: %h, instruction: %h\n", act_memtoregQ[i], exp_memtoregQ[i], tr.instr[255-i]);
            end
            //data_out
            if(act_data_outQ[i] == exp_data_outQ[i]) begin
                $display("[data_out]PASS\n");
            end else begin
                $display("[data_out]FAIL actual data_out: %h, expected data_out: %h, instruction: %h\n", act_data_outQ[i], exp_data_outQ[i], tr.instr[255-i]);
            end
            //ALU_resulte
            if(act_alu_resultQ[i] == exp_alu_resultQ[i]) begin
                $display("[alu_result]PASS\n");
            end else begin
                $display("[alu_result]FAIL actual alu_result: %h, expected alu_result: %h, instruction: %h\n", act_alu_resultQ[i], exp_alu_resultQ[i], tr.instr[255-i]);
            end
        end
        */
     /*
        en = 1;
        adr = 12'h000;
        ins_Q = {};
        exp_Q = {};

        for(int i = 0; i <= 2044; i = i+4) begin
            exp_Q.push_back(i);
        end

        for(int i = 0; i <= 2044; i = i+4) begin
            @(negedge clk)
            adr = i;
            @(negedge clk)
            ins_Q.push_back(ins);
        end

        for(int i = 0; i <= 2044; i = i+4) begin
            if(ins_Q[i] == exp_Q[i]) begin
                $display("PASS \n");
            end else begin
                $display("FAILD actual data : %h, expected data: %h \n", ins_Q[i], exp_Q[i]);
            end
        end
        */
        /*
        rst_n = 0;
        #10ns
        rst_n = 1;
        tr = new();
        assert(tr.randomize()) else begin
            $error("Randomization failed!");
        end
        for(int i = 0; i < 100; i++) begin
            @(negedge clk)
            ins = tr.stim[i];
            golden_model(ins, flag_reg, exp_memwrite,   
                                    exp_memread,    
                                    exp_memtoreg,   
                                    exp_regdst,     
                                    exp_PCSRC,            
                                    exp_ALUSrc,     
                                    exp_reg_write_c,
                                    exp_ALUop);
            @(negedge clk)
            act_memwrite.push_back(memwrite);
            act_memread.push_back(memread);
            act_memtoreg.push_back(memtoreg);
            act_regdst.push_back(regdst);
            act_PCSRC.push_back(PCSRC);
            act_ALUop.push_back(ALUop);
            act_ALUSrc.push_back(ALUSrc);
            act_reg_write_c.push_back(reg_write_c);
        end

        for(int i = 0; i < 100; i++) begin

            if(act_memwrite[i] == exp_memwrite[i]) begin
                $display("[memwrite]PASS\n");
            end else begin
                $display("[memwrite]FAILED actual out: %h, expected out: %h \n", act_memwrite[i], exp_memwrite[i]);
            end

            if(act_memread[i] == exp_memread[i]) begin
                $display("[memread]PASS\n");
            end else begin
                $display("[memread]FAILED actual out: %h, expected out: %h \n", act_memread[i], exp_memread[i]);
            end

            if(act_memtoreg[i] == exp_memtoreg[i]) begin
                $display("[memwtoreg]PASS\n");
            end else begin
                $display("[memtoreg]FAILED actual out: %h, expected out: %h \n", act_memtoreg[i], exp_memtoreg[i]);
            end

            if(act_regdst[i] == exp_regdst[i]) begin
                $display("[regdst]PASS\n");
            end else begin
                $display("[regdst]FAILED actual out: %h, expected out: %h \n", act_regdst[i], exp_regdst[i]);
            end

            if(act_PCSRC[i] == exp_PCSRC[i]) begin
                $display("[PCSRC]PASS\n");
            end else begin
                $display("[PCSRC]FAILED actual out: %h, expected out: %h \n", act_PCSRC[i], exp_PCSRC[i]);
            end

            if(act_ALUop[i] == exp_ALUop[i]) begin
                $display("[ALUop]PASS\n");
            end else begin
                $display("[ALUop]FAILED actual out: %h, expected out: %h \n", act_ALUop[i], exp_ALUop[i]);
            end

            if(act_ALUSrc[i] == exp_ALUSrc[i]) begin
                $display("[ALUSrc]PASS\n");
            end else begin
                $display("[ALUSrc]FAILED actual out: %h, expected out: %h \n", act_ALUSrc[i], exp_ALUSrc[i]);
            end

            if(act_reg_write_c[i] == exp_reg_write_c[i]) begin
                $display("[reg_write_c]PASS\n");
            end else begin
                $display("[reg_write_c]FAILED actual out: %h, expected out: %h \n", act_reg_write_c[i], exp_reg_write_c[i]);
            end
        end
        */

        /*
        adr = 0;
        wdata = 0;
        memwrite = 0;
        memread = 0;
        exp_data = {};
        exp_code = {};
        act_data = {};
        act_code = {};            


        rst_n = 0;
        #10ns
        rst_n = 1;

        for(int i = 0; i < 512; i++) begin
            exp_data.push_back(i);
        end
        for(int i = 0; i < 512; i++) begin
            exp_code.push_back(i);
        end

        memwrite = 1;

        for(int i = 0; i < 2045; i = i+4) begin
            @(negedge clk)
            adr = i;
            wdata = j;
            j++;
        end

        memwrite = 0;
        memread = 1;

        for(int i = 0; i < 2045; i = i+4) begin
            @(negedge clk)
            adr = i;
            @(negedge clk)
            act_data.push_back(rdata);
        end
        for(int i = 2048; i < 4093; i = i+4) begin
            @(negedge clk)
            adr = i;
            @(negedge clk)
            act_code.push_back(ins);
        end

        for(int i = 0; i < 512; i = i+4) begin
           if(act_data[i] == exp_data[i]) begin
                $display("DATA PASS %0d \n", i);
           end else begin
                $display("DATA FAILED actual data: %h, expected data: %h \n", act_data[i], exp_data[i]);
           end
        end
        for(int i = 0; i < 512; i = i+4) begin
            if(act_code[i] == exp_code[i]) begin
                $display("CODE PASS %0d \n", i);
           end else begin
                $display("CODE FAILED actual data: %h, expected data: %h \n", act_code[i], exp_code[i]);
           end
        end
        */
    $stop;
    end


endmodule