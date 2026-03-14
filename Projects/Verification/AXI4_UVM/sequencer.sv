`ifndef AXI4_SEQUENCER_SVH
`define AXI4_SEQUENCER_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "sequence_item.sv"

class axi4_sequencer extends uvm_sequencer #(axi4_transaction);

    `uvm_component_utils(axi4_sequencer)

    function new(string name = "axi4_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
endclass

`endif