`ifndef ENV_SVH
`define ENV_SVH

`include "uvm_macros.svh"
`include "agent.sv"
import uvm_pkg::*;

class router_env extends uvm_env;
    
    router_agent agent;
    
    `uvm_component_utils(router_env)
    
    function new(string name = "router_env", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("Env_Constructor", "Low verbosity(L)", UVM_LOW)
        `uvm_info("Env_Constructor", "Medium verbosity(M)", UVM_MEDIUM)
        `uvm_info("Env_Constructor", "High verbosity(H)", UVM_HIGH)
        `uvm_info("Env_Constructor", "Full verbosity(F)", UVM_FULL)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("Env_Build_Phase", "Low verbosity(L)", UVM_LOW)
        `uvm_info("Env_Build_Phase", "Medium verbosity(M)", UVM_MEDIUM)
        `uvm_info("Env_Build_Phase", "High verbosity(H)", UVM_HIGH)
        `uvm_info("Env_Build_Phase", "Full verbosity(F)", UVM_FULL)
        agent = router_agent::type_id::create ("agent", this);
    endfunction
endclass
`endif 