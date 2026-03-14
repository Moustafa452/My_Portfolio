`ifndef COMMON_CFG_SVH
`define COMMON_CFG_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

class common_cfg extends uvm_object;

    `uvm_object_utils(common_cfg);

    event write_addr_info_sent_e;
    event write_data_sent_e;
    event read_addr_info_sent_e;
    event read_data_sent_e;

    function new(string name = "common_cfg");
        super.new(name);
    endfunction

endclass

`endif