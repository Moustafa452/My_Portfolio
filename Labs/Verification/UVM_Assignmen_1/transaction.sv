`include "uvm_macros.svh"
import uvm_pkg::*;

class router_transaction extends uvm_sequence_item;
    
    rand logic [7:0] data_in0;
    rand logic [7:0] data_in1;
    rand logic [7:0] data_in2;
    rand logic [7:0] data_in3;
    rand logic valid_in0;
    rand logic valid_in1;
    rand logic valid_in2;
    rand logic valid_in3;
    rand logic [7:0] data_out0;
    rand logic [7:0] data_out1;
    rand logic valid_out0;
    rand logic valid_out1;

    `uvm_object_utils_begin(router_transaction)
        `uvm_field_int(data_in0, UVM_DEFAULT)
        `uvm_field_int(data_in1, UVM_DEFAULT)
        `uvm_field_int(data_in2, UVM_DEFAULT)
        `uvm_field_int(data_in3, UVM_DEFAULT)
        `uvm_field_int(valid_in0, UVM_DEFAULT)
        `uvm_field_int(valid_in1, UVM_DEFAULT)
        `uvm_field_int(valid_in2, UVM_DEFAULT)
        `uvm_field_int(valid_in3, UVM_DEFAULT)
        `uvm_field_int(data_out0, UVM_DEFAULT)
        `uvm_field_int(data_out1, UVM_DEFAULT)
        `uvm_field_int(valid_out0, UVM_DEFAULT)
        `uvm_field_int(valid_out1, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "router_transaction");
        super.new(name);
        `uvm_info("Transaction_Constructor", "Low verbosity(L)", UVM_LOW)
        `uvm_info("Transaction_Constructor", "Medium verbosity(M)", UVM_MEDIUM)
        `uvm_info("Transaction_Constructor", "High verbosity(H)", UVM_HIGH)
        `uvm_info("Transaction_Constructor", "Full verbosity(F)", UVM_FULL)
    endfunction 
endclass