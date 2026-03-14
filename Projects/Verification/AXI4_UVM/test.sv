`ifndef AXI4_TEST_SVH
`define AXI4_TEST_SVH

`include "uvm_macros.svh"

import uvm_pkg::*;

`include "env.sv"
`include "axi4_base_sequence.sv"
`include "axi4_burst_sequence.sv"
`include "axi4_data_sequence.sv"
`include "axi4_error_injection_sequence.sv"
`include "common.sv"

class axi4_test extends uvm_test;
    
    common_cfg m_cfg;
    axi4_env env;
    axi4_base_sequence seq;

    `uvm_component_utils(axi4_test)

    function new(string name = "axi4_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = axi4_env::type_id::create("env", this);
        m_cfg = common_cfg::type_id::create("m_cfg");
        uvm_config_db #(common_cfg)::set(this, "*", "m_cfg", m_cfg);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        forever begin
            // Check current coverage levels
            real addr_cov = env.coverage.memory_address_cg.get_inst_coverage();
            real W_data_cov = env.coverage.W_data_cg.get_inst_coverage();
            real R_data_cov = env.coverage.R_data_cg.get_inst_coverage();
            real burst_cov = env.coverage.burst_coverage_cg.get_inst_coverage();

            // ADAPTIVE OVERRIDE LOGIC
            if (addr_cov < 100.0) begin
                // If address coverage is low, use the base sequence (it has good address dist)
                uvm_factory::get().set_type_override_by_type(axi4_base_sequence::get_type(), 
                                                            axi4_base_sequence::get_type());
            end 
            else if (W_data_cov < 100.0 || R_data_cov < 100.0) begin
                // Override base sequence with Data Targeted sequence
                set_type_override_by_type(axi4_base_sequence::get_type(), 
                                          axi4_data_sequence::get_type());
            end 
            else if (burst_cov < 100.0) begin
                // Override with Burst Targeted sequence
                set_type_override_by_type(axi4_base_sequence::get_type(), 
                                          axi4_burst_sequence::get_type());
            end 
            else begin
                // Everything hit? Start Error Injection!
                set_type_override_by_type(axi4_base_sequence::get_type(), 
                                          axi4_error_sequence::get_type());
            end
            
            seq = axi4_base_sequence::type_id::create("base_seq");
            seq.start(env.agent.sequencer);
            // Exit loop if total coverage reaches goal
            if (addr_cov >= 100.0 && W_data_cov >= 100.0 && R_data_cov >= 100.0 && burst_cov >= 100.0) break;
        end
        
        phase.drop_objection(this);

    endtask

endclass

`endif