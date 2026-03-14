`ifndef AXI4_COVERAGE_SVH
`define AXI4_COVERAGE_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "sequence_item.sv"

class axi4_coverage extends uvm_component;

    `uvm_component_utils(axi4_coverage)

    uvm_analysis_export #(axi4_transaction) analysis_export;
    uvm_tlm_analysis_fifo #(axi4_transaction) fifo;
    axi4_transaction tr;
    
   covergroup burst_coverage_cg;
        write_len_cp: coverpoint tr.AWLEN {
            bins Wsingle = {0};
            bins Wshort_burst[] = {[1:3]};
            bins Wmedium_burst[] = {[4:7]};
            bins Wlong_burst[] = {[8:15]};
            bins Wmax_burst[] = {[16:255]};
        }
        read_len_cp: coverpoint tr.ARLEN {
            bins ARsingle = {0};
            bins Rshort_burst[] = {[1:3]};
            bins Rmedium_burst[] = {[4:7]};
            bins Rlong_burst[] = {[8:15]};
            bins Rmax_burst[] = {[16:255]};
        }
    endgroup

    covergroup memory_address_cg;
        write_mem_addr_cp: coverpoint tr.AWADDR {
            bins write_low_quarter [] = {[0:252]};
            bins write_mid_low [] = {[256:508]};
            bins write_mid_high [] = {[512:764]};
            bins write_high_quarter [] = {[768:1020]};
        }
        read_mem_addr_cp: coverpoint tr.ARADDR {
            bins read_low_quarter [] = {[0:252]};
            bins read_mid_low [] = {[256:508]};
            bins read_mid_high [] = {[512:764]};
            bins read_high_quarter [] = {[768:1020]};
        }
    endgroup

    covergroup W_data_cg;
        write_data_cp: coverpoint tr.current_op iff (tr.current_op == WRITE_op) {
            bins write_all_zero = {WRITE_op} iff ({32'h00000000} inside {tr.WDATA});
            bins write_all_ones = {WRITE_op} iff ({32'hFFFFFFFF} inside {tr.WDATA});
            bins write_corner_A = {WRITE_op} iff ({32'hAAAAAAAA} inside {tr.WDATA});
            bins write_corner_5 = {WRITE_op} iff ({32'h55555555} inside {tr.WDATA});
        }
    endgroup

    covergroup R_data_cg;
        read_data_cp: coverpoint tr.current_op iff (tr.current_op == READ_op) {
            bins read_all_zero = {READ_op} iff ({32'h00000000} inside {tr.RDATA});
            bins read_all_ones = {READ_op} iff ({32'hFFFFFFFF} inside {tr.RDATA});
            bins read_corner_A = {READ_op} iff ({32'hAAAAAAAA} inside {tr.RDATA});
            bins read_corner_5 = {READ_op} iff ({32'h55555555} inside {tr.RDATA});
        }
    endgroup

    function new(string name = "axi4_coverage", uvm_component parent);
        super.new(name, parent);
        burst_coverage_cg = new();
        memory_address_cg = new();
        W_data_cg = new();
        R_data_cg = new();
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
        forever begin
            fifo.get(tr);
            burst_coverage_cg.sample();
            memory_address_cg.sample();
            W_data_cg.sample();
            R_data_cg.sample();
        end
    endtask
    
endclass

`endif