`ifndef AXI4_SCOREBOARD_SVH
`define AXI4_SCOREBOARD_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "sequence_item.sv"

class axi4_scoreboard extends uvm_scoreboard;

    uvm_analysis_export #(axi4_transaction) analysis_export;
    uvm_tlm_analysis_fifo #(axi4_transaction) fifo;
    axi4_transaction tr_act;
    int total_tests = 0;
    int passed_tests = 0;
    int failed_tests = 0;
    int read_tests = 0;
    int write_tests = 0;
    int slverr_count = 0;
    int okay_count = 0;

    logic [31:0] golden_mem [0:1023];

    `uvm_component_utils(axi4_scoreboard)

    function new(string name = "axi4_scoreboard", uvm_component parent);
        super.new(name, parent);
        for (int i = 0; i < 1024; i++) begin
            golden_mem[i] = 0;
        end
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        analysis_export = new("analysis_export", this);
        fifo = new("fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        analysis_export.connect(fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        int i;
        bit read_pass;
        
        forever begin
            fifo.get(tr_act);
            total_tests++;
            
            if(tr_act.current_op == WRITE_op) begin
                write_tests++;
                for(i = 0; i <= tr_act.AWLEN; i++) begin
                    golden_mem[(tr_act.AWADDR >> 2) + i] = tr_act.WDATA[i];
                end
                if(tr_act.WLAST == 1 && tr_act.BRESP == 2'b00) begin
                    passed_tests++;
                    okay_count++;
                    `uvm_info("SCOREBOARD", "WRITE TEST PASSED", UVM_LOW)
                end else begin
                    failed_tests++;
                    if(tr_act.BRESP != 2'b00) slverr_count++;
                    `uvm_info("SCOREBOARD", "WRITE TEST FAILED", UVM_LOW)
                    tr_act.print();
                end
            end else begin
                read_tests++;
                read_pass = 1;
                for (i = 0; i <= tr_act.ARLEN; i++) begin
                    if(golden_mem[(tr_act.ARADDR >> 2) + i] != tr_act.RDATA[i]) begin
                        read_pass = 0;
                        break;
                    end
                end
                if(read_pass) begin
                    passed_tests++;
                    `uvm_info("SCOREBOARD", "READ TEST PASSED", UVM_LOW)
                end else begin
                    failed_tests++;
                    `uvm_info("SCOREBOARD", "READ TEST FAILED", UVM_LOW)
                    tr_act.print();
                end
            end
        end
    endtask

    function void report_phase(uvm_phase phase);
        `uvm_info("SCOREBOARD", $sformatf("=== FINAL REPORT ==="), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Total Tests: %0d", total_tests), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Passed Tests: %0d", passed_tests), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Failed Tests: %0d", failed_tests), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Write Tests: %0d", write_tests), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Read Tests: %0d", read_tests), UVM_LOW)
    endfunction

endclass

`endif