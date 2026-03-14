`include "axi4.v"
`include "intf.sv"
`include "test.sv"

`include "uvm_macros.svh"
import uvm_pkg::*;


module top;
    
    axi_if #(32, 16) axi_vif();

    axi4 #(.DATA_WIDTH(32),.ADDR_WIDTH(16), .MEMORY_DEPTH(1024)) dut (
        .ACLK     (axi_vif.ACLK),
        .ARESETn  (axi_vif.ARESETn), 
        .AWADDR   (axi_vif.AWADDR),
        .AWLEN    (axi_vif.AWLEN),
        .AWSIZE   (axi_vif.AWSIZE),
        .AWVALID  (axi_vif.AWVALID),
        .AWREADY  (axi_vif.AWREADY),
        .WDATA    (axi_vif.WDATA),
        .WLAST    (axi_vif.WLAST),
        .WVALID   (axi_vif.WVALID),
        .WREADY   (axi_vif.WREADY),
        .BRESP    (axi_vif.BRESP),
        .BVALID   (axi_vif.BVALID),
        .BREADY   (axi_vif.BREADY),
        .ARADDR   (axi_vif.ARADDR),
        .ARLEN    (axi_vif.ARLEN),
        .ARSIZE   (axi_vif.ARSIZE),
        .ARVALID  (axi_vif.ARVALID),
        .ARREADY  (axi_vif.ARREADY),
        .RDATA    (axi_vif.RDATA),
        .RRESP    (axi_vif.RRESP),
        .RLAST    (axi_vif.RLAST),
        .RVALID   (axi_vif.RVALID),
        .RREADY   (axi_vif.RREADY)
    );

    initial begin
        axi_vif.ACLK = 0;
        forever begin
            #5ns
            axi_vif.ACLK = ~ axi_vif.ACLK;
        end
    end

    initial begin
        axi_vif.ARESETn = 1;
        #5ns
        axi_vif.ARESETn = 0;
        #5ns 
        axi_vif.ARESETn = 1;
    end

    initial begin
        uvm_config_db #(virtual axi_if)::set(null, "*", "vif", axi_vif);
        run_test("axi4_test");
    end

endmodule