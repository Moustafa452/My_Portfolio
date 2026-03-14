`ifndef AGENT_svh
`define AGENT_SVH

`include "uvm_macros.svh"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
import uvm_pkg::*;

class router_agent extends uvm_agent;
    
    router_sequencer sequencer;
    router_driver driver;
    router_monitor monitor;

    
    `uvm_component_utils(router_agent)
    
    function new(string name = "router_agent", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("Agent_Constructor", "Low verbosity(L)", UVM_LOW)
        `uvm_info("Agent_Constructor", "Medium verbosity(M)", UVM_MEDIUM)
        `uvm_info("Agent_Constructor", "High verbosity(H)", UVM_HIGH)
        `uvm_info("Agent_Constructor", "Full verbosity(F)", UVM_FULL)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("Agent_Build_Phase", "Low verbosity(L)", UVM_LOW)
        `uvm_info("Agent_Build_Phase", "Medium verbosity(M)", UVM_MEDIUM)
        `uvm_info("Agent_Build_Phase", "High verbosity(H)", UVM_HIGH)
        `uvm_info("Agent_Build_Phase", "Full verbosity(F)", UVM_FULL)
        sequencer = router_sequencer::type_id::create ("sequencer", this);
        driver = router_driver::type_id::create ("driver", this);
        monitor = router_monitor::type_id::create ("monitor", this);
    endfunction
endclass
`endif 