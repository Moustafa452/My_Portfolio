`ifndef DRIVER_SVH
`define DRIVER_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

class router_driver extends uvm_driver;
    
    `uvm_component_utils(router_driver)
    
    function new(string name = "router_driver", uvm_component parent = null);
        super.new(name, parent);
         `uvm_info("driver_Constructor", "Low verbosity(L)", UVM_LOW)
         `uvm_info("driver_Constructor", "Medium verbosity(M)", UVM_MEDIUM)
         `uvm_info("driver_Constructor", "High verbosity(H)", UVM_HIGH)
         `uvm_info("driver_Constructor", "Full verbosity(F)", UVM_FULL)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("driver_Build_Phase", "Low verbosity(L)", UVM_LOW)
        `uvm_info("driver_Build_Phase", "Medium verbosity(M)", UVM_MEDIUM)
        `uvm_info("driver_Build_Phase", "High verbosity(H)", UVM_HIGH)
        `uvm_info("driver_Build_Phase", "Full verbosity(F)", UVM_FULL)
    endfunction
endclass
`endif 