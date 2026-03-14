`ifndef AXI4_DRIVER_SVH 
`define AXI4_DRIVER_SVH 

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "sequence_item.sv"
`include "intf.sv"
`include "common.sv"

class axi4_driver extends uvm_driver #(axi4_transaction);

    common_cfg m_cfg;
    virtual axi_if axi_vif;

   `uvm_component_utils(axi4_driver)

    function new(string name = "axi4_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual axi_if)::get(this, "", "vif", axi_vif)) begin
            `uvm_fatal("DRIVER", "Failed to get interface")
        end
        if(!uvm_config_db #(common_cfg)::get(this, "", "m_cfg", m_cfg)) begin
            `uvm_fatal("DRIVER", "Failed to get common_cfg")
        end
    endfunction

    task reset_signals();
        axi_vif.AWADDR = 0;
        axi_vif.AWLEN = 0;
        axi_vif.AWSIZE = 0;
        axi_vif.AWVALID = 0;
        axi_vif.WDATA = 0;
        axi_vif.WLAST = 0;
        axi_vif.WVALID = 0;
        axi_vif.BREADY = 0;
        axi_vif.ARADDR = 0;
        axi_vif.ARLEN = 0;
        axi_vif.ARSIZE = 0;
        axi_vif.ARVALID = 0;
        axi_vif.RREADY = 0;
    endtask

    task drive(axi4_transaction req);
        `uvm_info("DRIVER", "Starting to drive transaction", UVM_MEDIUM)
        req.print();
        
        wait(axi_vif.ARESETn);
        @(posedge axi_vif.ACLK);
        
        if(req.current_op == WRITE_op) begin
            `uvm_info("DRIVER", $sformatf("Driving WRITE: ADDR=0x%08h, LEN=%0d", req.AWADDR, req.AWLEN), UVM_LOW)
            
            axi_vif.AWADDR <= req.AWADDR;
            axi_vif.AWLEN <= req.AWLEN;
            axi_vif.AWSIZE <= req.AWSIZE;
            axi_vif.AWVALID <= 1'b1;
            
            do @(posedge axi_vif.ACLK);
            while(!axi_vif.AWREADY);
            
            axi_vif.AWVALID <= 1'b0;
            `uvm_info("DRIVER", "Address accepted", UVM_LOW)
            
            for(int i = 0; i <= req.AWLEN; i++) begin
                axi_vif.WDATA <= req.WDATA[i];
                axi_vif.WVALID <= 1'b1;
                axi_vif.WLAST <= (i == req.AWLEN) ? 1'b1 : 1'b0;
                
                do @(posedge axi_vif.ACLK);
                while(!axi_vif.WREADY);
                
                `uvm_info("DRIVER", $sformatf("Wrote data[%0d] = 0x%08h", i, req.WDATA[i]), UVM_LOW)
            end
            
            axi_vif.WVALID <= 1'b0;
            axi_vif.WLAST <= 1'b0;
            
            axi_vif.BREADY <= 1'b1;
            do @(posedge axi_vif.ACLK);
            while(!axi_vif.BVALID);
            
            req.BRESP = axi_vif.BRESP;
            axi_vif.BREADY <= 1'b0;
            `uvm_info("DRIVER", $sformatf("Write response: BRESP=0x%0h", req.BRESP), UVM_MEDIUM)
            
        end else if(req.current_op == READ_op) begin
            `uvm_info("DRIVER", $sformatf("Driving READ: ADDR=0x%08h, LEN=%0d", req.ARADDR, req.ARLEN), UVM_MEDIUM)
            
            axi_vif.ARADDR <= req.ARADDR;
            axi_vif.ARLEN <= req.ARLEN;
            axi_vif.ARSIZE <= req.ARSIZE;
            axi_vif.ARVALID <= 1'b1;
            
            do @(posedge axi_vif.ACLK);
            while(!axi_vif.ARREADY);
            
            axi_vif.ARVALID <= 1'b0;
            `uvm_info("DRIVER", "Read address phase completed", UVM_HIGH)
            
            for(int i = 0; i <= req.ARLEN; i++) begin
                do @(posedge axi_vif.ACLK);
                while(!axi_vif.RVALID);
                
                axi_vif.RREADY <= 1'b1;
                @(posedge axi_vif.ACLK);
                req.RDATA[i] = axi_vif.RDATA;
                axi_vif.RREADY <= 1'b0;
                
                `uvm_info("DRIVER", $sformatf("Read data[%0d] = 0x%08h", i, req.RDATA[i]), UVM_HIGH)
            end
            
            `uvm_info("DRIVER", "Read transaction completed", UVM_MEDIUM)
        end
    endtask

    task run_phase(uvm_phase phase);
        `uvm_info("DRIVER", "Driver run_phase started", UVM_LOW)
        
        reset_signals();
        
        forever begin
            axi4_transaction req;
            seq_item_port.get_next_item(req);
            drive(req);
            seq_item_port.item_done();
        end
    endtask

endclass

`endif