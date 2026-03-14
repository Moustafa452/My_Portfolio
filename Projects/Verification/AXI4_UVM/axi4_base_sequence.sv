`ifndef AXI4_BASE_SEQUENCE_SVH
`define AXI4_BASE_SEQUENCE_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "sequence_item.sv"

class axi4_base_sequence extends uvm_sequence #(axi4_transaction);

    `uvm_object_utils(axi4_base_sequence)

    axi4_transaction req;
    
    function new(string name = "axi4_base_sequence");
        super.new(name);
        `uvm_info(name, {"Starting ", name}, UVM_LOW)
    endfunction

    virtual task setup(axi4_transaction tr);
        req.memory_alignment_c.constraint_mode(0);
        tr.address_cov.constraint_mode(1);
        tr.memory_range_c.constraint_mode(1);
        tr.burst_cov.constraint_mode(0);
        tr.data_cov.constraint_mode(0);
        tr.error_addr_inj.constraint_mode(0);
    endtask


    virtual task body();
        repeat(200) begin
            req = axi4_transaction::type_id::create("req");
            start_item(req);
            setup(req);
            assert(req.randomize()) else `uvm_info("RANDOMIZATION", "Failed Randomization", UVM_LOW);
            finish_item(req);
        end
    endtask

endclass

`endif