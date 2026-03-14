`ifndef SEQUENCER_SVH
`define SEQUENCER_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

class router_sequencer extends uvm_sequencer;
    
    `uvm_component_utils(router_sequencer)
    
    function new(string name = "router_sequencer", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("Sequencer_Build_Phase", "Low verbosity(L)", UVM_LOW)
        `uvm_info("Sequencer_Build_Phase", "Medium verbosity(M)", UVM_MEDIUM)
        `uvm_info("Sequencer_Build_Phase", "High verbosity(H)", UVM_HIGH)
        `uvm_info("Sequencer_Build_Phase", "Full verbosity(F)", UVM_FULL)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("Sequencer_Build_Phase", "Low verbosity(L)", UVM_LOW)
        `uvm_info("Sequencer_Build_Phase", "Medium verbosity(M)", UVM_MEDIUM)
        `uvm_info("Sequencer_Build_Phase", "High verbosity(H)", UVM_HIGH)
        `uvm_info("Sequencer_Build_Phase", "Full verbosity(F)", UVM_FULL)
    endfunction
endclass
`endif 