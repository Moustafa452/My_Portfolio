`ifndef AXI4_ENV_SVH
`define AXI4_ENV_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "agent.sv"
`include "scoreboard.sv"
`include "coverage.sv"

class axi4_env extends uvm_env;

    axi4_agent agent;
    axi4_coverage coverage;
    axi4_scoreboard scoreboard;

    `uvm_component_utils(axi4_env)

    function new(string name = "axi4_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = axi4_agent::type_id::create("agent", this);
        scoreboard = axi4_scoreboard::type_id::create("scoreboard", this);
        coverage = axi4_coverage::type_id::create("coverage", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.ap.connect(scoreboard.analysis_export);
        agent.monitor.ap.connect(coverage.analysis_export);
    endfunction

endclass

`endif