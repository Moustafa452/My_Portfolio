`ifndef AXI4_MONITOR_SVH
`define AXI4_MONITOR_SVH

`include "intf.sv"
`include "sequence_item.sv"
`include "common.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;

class axi4_monitor extends uvm_monitor;

    common_cfg m_cfg;
    virtual axi_if axi_vif;
    uvm_analysis_port #(axi4_transaction) ap;

    `uvm_component_utils(axi4_monitor)

    function new(string name = "axi4_monitor", uvm_component parent);  // Fixed constructor name
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);   
        if(!uvm_config_db #(virtual axi_if)::get(this, "", "vif", axi_vif)) begin
            `uvm_fatal("MONITOR", "Failed to get interface")
        end
        if(!uvm_config_db #(common_cfg)::get(this, "", "m_cfg", m_cfg)) begin
            `uvm_fatal("MONITOR", "Failed to get common_cfg")
        end
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            axi4_transaction obj = axi4_transaction::type_id::create("obj");

            @(posedge axi_vif.ACLK);

            if(axi_vif.AWREADY && axi_vif.AWVALID) begin
                `uvm_info("MONITOR", "Detected WRITE transaction", UVM_MEDIUM)
                obj.current_op = WRITE_op;

                obj.AWADDR = axi_vif.AWADDR;
                obj.AWLEN = axi_vif.AWLEN;
                obj.AWSIZE = axi_vif.AWSIZE;
                obj.AWVALID = axi_vif.AWVALID;
                obj.AWREADY = axi_vif.AWREADY;

                @(posedge axi_vif.ACLK);

                obj.WDATA = new[obj.AWLEN + 1];

                for(int i = 0; i <= obj.AWLEN; i++) begin
                    do @(posedge axi_vif.ACLK);
                    while(!(axi_vif.WVALID && axi_vif.WREADY));
                    obj.WDATA[i] = axi_vif.WDATA;
                end

                obj.WLAST = axi_vif.WLAST;
                obj.WVALID = axi_vif.WVALID;
                obj.WREADY = axi_vif.WREADY;

                do @(posedge axi_vif.ACLK);
                while(!(axi_vif.BVALID && axi_vif.BREADY));
                
                obj.BRESP = axi_vif.BRESP;
                obj.BVALID = axi_vif.BVALID;
                obj.BREADY = axi_vif.BREADY;
                
                `uvm_info("MONITOR", "Sending WRITE transaction to analysis port", UVM_MEDIUM)
                ap.write(obj);
                
            end else if(axi_vif.ARREADY && axi_vif.ARVALID) begin
                `uvm_info("MONITOR", "Detected READ transaction", UVM_MEDIUM)
                obj.current_op = READ_op;

                obj.ARADDR = axi_vif.ARADDR;
                obj.ARLEN = axi_vif.ARLEN;
                obj.ARSIZE = axi_vif.ARSIZE;
                obj.ARVALID = axi_vif.ARVALID;
                obj.ARREADY = axi_vif.ARREADY;

                @(posedge axi_vif.ACLK);

                obj.RDATA = new[obj.ARLEN + 1];

                for(int i = 0; i <= obj.ARLEN; i++) begin

                    do @(posedge axi_vif.ACLK);
                    while(!(axi_vif.RVALID && axi_vif.RREADY));
                    
                    obj.RDATA[i] = axi_vif.RDATA;
                    `uvm_info("MONITOR", $sformatf("Captured RDATA[%0d] = 0x%08h", i, obj.RDATA[i]), UVM_HIGH)
                end

                obj.RRESP = axi_vif.RRESP;
                obj.RLAST = axi_vif.RLAST;
                obj.RVALID = axi_vif.RVALID;
                obj.RREADY = axi_vif.RREADY;
                
                `uvm_info("MONITOR", "Sending READ transaction to analysis port", UVM_MEDIUM)
                ap.write(obj);
            end
        end
    endtask
endclass

`endif