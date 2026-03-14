`ifndef AXI4_ERROR_SEQUENCE_SVH
`define AXI4_ERROR_SEQUENCE_SVH

`include "axi4_base_sequence.sv"

class axi4_error_sequence extends axi4_base_sequence;
    `uvm_object_utils(axi4_error_sequence)

    function new(string name = "axi4_error_sequence");
        super.new(name);
    endfunction

    task setup(axi4_transaction tr);
        tr.memory_alignment_c.constraint_mode(0);
        tr.boundry_cross_c.constraint_mode(0);
        tr.address_cov.constraint_mode(0);
        tr.memory_range_c.constraint_mode(0);
        tr.burst_cov.constraint_mode(0);
        tr.data_cov.constraint_mode(0);
        tr.error_addr_inj.constraint_mode(1);
    endtask

    task body();
        super.body();
    endtask

endclass

`endif