`ifndef MONITOR_SVH
`define MONITOR_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

class router_monitor extends uvm_monitor;
    
    `uvm_component_utils(router_monitor)
    
    function new(string name = "router_monitor", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("Monitor_Constructor", "Low verbosity(L)", UVM_LOW)
        `uvm_info("Monitor_Constructor", "Medium verbosity(M)", UVM_MEDIUM)
        `uvm_info("Monitor_Constructor", "High verbosity(H)", UVM_HIGH)
        `uvm_info("Monitor_Constructor", "Full verbosity(F)", UVM_FULL)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("Monitor_Build_Phase", "Low verbosity(L)", UVM_LOW)
        `uvm_info("Monitor_Build_Phase", "Medium verbosity(M)", UVM_MEDIUM)
        `uvm_info("Monitor_Build_Phase", "High verbosity(H)", UVM_HIGH)
        `uvm_info("Monitor_Build_Phase", "Full verbosity(F)", UVM_FULL)
    endfunction
endclass
`endif 