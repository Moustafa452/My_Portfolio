`ifndef AXI4_AGENT_SVH
`define AXI4_AGENT_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "driver.sv"
`include "sequencer.sv" 
`include "monitor.sv"

class axi4_agent extends uvm_agent;

    axi4_driver driver;
    axi4_sequencer sequencer;
    axi4_monitor monitor;

    `uvm_component_utils(axi4_agent)

    function new(string name = "axi4_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = axi4_driver::type_id::create("driver", this);
        sequencer = axi4_sequencer::type_id::create("sequencer", this);
        monitor = axi4_monitor::type_id::create("monitor", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // CORRECTED: Fixed connection direction - driver pulls from sequencer
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
    
endclass
`endif