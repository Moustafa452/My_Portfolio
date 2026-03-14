`ifndef AXI4_TRANSACTION_SVH
`define AXI4_TRANSACTION_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum {WRITE_op, READ_op} op_type;


class axi4_transaction extends uvm_sequence_item;

    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 16;

    rand op_type                current_op;
    logic                       ARESETn;
    rand logic [ADDR_WIDTH-1:0] AWADDR;
    rand logic [7:0]            AWLEN;
    rand logic [2:0]            AWSIZE;
    logic                       AWVALID;
    logic                       AWREADY;
    rand logic [DATA_WIDTH-1:0] WDATA [];
    logic                       WLAST;
    logic                       WVALID;
    logic                       WREADY;
    logic       [1:0]           BRESP;
    logic                       BVALID;
    logic                       BREADY;
    rand logic [ADDR_WIDTH-1:0] ARADDR;
    rand logic [7:0]            ARLEN;
    rand logic [2:0]            ARSIZE;
    logic                       ARVALID;
    logic                       ARREADY;
    logic      [DATA_WIDTH-1:0] RDATA [];
    logic      [1:0]            RRESP;
    logic                       RLAST;
    logic                       RVALID;
    logic                       RREADY;


    `uvm_object_utils_begin(axi4_transaction)
    `uvm_field_enum(op_type, current_op, UVM_DEFAULT)
    `uvm_field_int(AWADDR, UVM_DEFAULT)
    `uvm_field_int(AWLEN, UVM_DEFAULT)
    `uvm_field_int(AWSIZE, UVM_DEFAULT)
    `uvm_field_int(AWVALID, UVM_DEFAULT)
    `uvm_field_int(AWREADY, UVM_DEFAULT)
    `uvm_field_array_int(WDATA, UVM_DEFAULT)
    `uvm_field_int(WLAST, UVM_DEFAULT)
    `uvm_field_int(WVALID, UVM_DEFAULT)
    `uvm_field_int(WREADY, UVM_DEFAULT)
    `uvm_field_int(BRESP, UVM_DEFAULT)
    `uvm_field_int(BVALID, UVM_DEFAULT)
    `uvm_field_int(BREADY, UVM_DEFAULT)
    `uvm_field_int(ARADDR, UVM_DEFAULT)
    `uvm_field_int(ARLEN, UVM_DEFAULT)
    `uvm_field_int(ARSIZE, UVM_DEFAULT)
    `uvm_field_int(ARVALID, UVM_DEFAULT)
    `uvm_field_int(ARREADY, UVM_DEFAULT)
    `uvm_field_array_int(RDATA, UVM_DEFAULT)
    `uvm_field_int(RRESP, UVM_DEFAULT)
    `uvm_field_int(RLAST, UVM_DEFAULT)
    `uvm_field_int(RVALID, UVM_DEFAULT)
    `uvm_field_int(RREADY, UVM_DEFAULT)
    `uvm_object_utils_end

    constraint fixed_size {
        AWSIZE == 3'b010;
        ARSIZE == 3'b010;
    }

    constraint memory_range_c {
        AWADDR inside {[16'h0000:16'h0FFC]};
        ARADDR inside {[16'h0000:16'h0FFC]};
    }

    constraint memory_alignment_c {
        AWADDR[1:0] == 2'b00;
        ARADDR[1:0] == 2'b00;
    }

    constraint boundry_cross_c {
        (AWADDR + ((AWLEN + 1) << AWSIZE)) <= ((1024 * 4) - 1);
        (ARADDR + ((ARLEN + 1) << ARSIZE)) <= ((1024 * 4) - 1);
    }

    constraint operation_type_c {
        current_op dist {
            WRITE_op:=50,
            READ_op:=50
        };
    }
    

    constraint burst_len_c {
        AWLEN inside {[0:255]};
        ARLEN inside {[0:255]};
    }

    constraint wdata_size_c { 
        WDATA.size() == AWLEN + 1; 
    }

    constraint address_cov {
        AWADDR dist {
            [16'h0000:16'h03FC] :/ 25,
            [16'h0400:16'h07FC] :/ 25,
            [16'h0800:16'h0BFC] :/ 25,
            [16'h0C00:16'h0FFC] :/ 25
        };
        ARADDR dist {
            [16'h0000:16'h03FC] :/ 25,
            [16'h0400:16'h07FC] :/ 25,
            [16'h0800:16'h0BFC] :/ 25,
            [16'h0C00:16'h0FFC] :/ 25
        };
    }

    constraint burst_cov {
        AWLEN dist {
            0:/10,
            AWLEN inside {[1:3]}:/20,
            AWLEN inside {[4:7]}:/20,
            AWLEN inside {[8:15]}:/20,
            AWLEN inside {[16:255]}:/30
        };

        ARLEN dist {
            0:/10,
            ARLEN inside {[1:3]}:/20,
            ARLEN inside {[4:7]}:/20,
            ARLEN inside {[8:15]}:/20,
            ARLEN inside {[16:255]}:/30
        };
    }

    constraint data_cov {
        foreach (WDATA[i]) {
                    WDATA[i] dist {32'h00000000 :/25, 
                                   32'hFFFFFFFF :/25,
                                   32'hAAAAAAAA :/25,
                                   32'h55555555 :/25
                                   };
            }
    }

    constraint error_addr_inj {
        AWADDR > 16'h0FFC; 
        ARADDR > 16'h0FFC;
    }

    function new(string name = "axi4_transaction");
        super.new(name);
    endfunction

    function void post_randomize();
        if (current_op == READ_op) begin
            RDATA = new[ARLEN + 1];
        end
    endfunction
    
endclass

`endif
