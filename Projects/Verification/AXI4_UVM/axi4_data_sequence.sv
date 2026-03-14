`ifndef AXI4_DATA_SEQUENCE_SVH
`define AXI4_DATA_SEQUENCE_SVH

`include "axi4_base_sequence.sv"

class axi4_data_sequence extends axi4_base_sequence;
    `uvm_object_utils(axi4_data_sequence)

    function new(string name = "axi4_data_sequence");
        super.new(name);
    endfunction

    task setup(axi4_transaction tr);
        //req.memory_alignment_c.constraint_mode(0);
        tr.address_cov.constraint_mode(0);
        tr.memory_range_c.constraint_mode(1);
        tr.burst_cov.constraint_mode(0);
        tr.data_cov.constraint_mode(1);
        tr.error_addr_inj.constraint_mode(0);
    endtask


    task body();
        super.body();
    endtask
endclass

`endif