`timescale 1ns/1ns

module axi4_assertions #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 16,
    parameter int MEMORY_DEPTH = 1024,
    parameter int MAX_BURST_LENGTH = 16
)(
    input logic ACLK,
    input logic ARESETn,
    
    input logic [ADDR_WIDTH-1:0] AWADDR,
    input logic [7:0] AWLEN,
    input logic [2:0] AWSIZE,
    input logic AWVALID,
    input logic AWREADY,
    
    input logic [DATA_WIDTH-1:0] WDATA,
    input logic WLAST,
    input logic WVALID,
    input logic WREADY,
    
    input logic [1:0] BRESP,
    input logic BVALID,
    input logic BREADY,

    input logic [ADDR_WIDTH-1:0] ARADDR,
    input logic [7:0] ARLEN,
    input logic [2:0] ARSIZE,
    input logic ARVALID,
    input logic ARREADY,

    input logic [DATA_WIDTH-1:0] RDATA,
    input logic [1:0] RRESP,
    input logic RLAST,
    input logic RVALID,
    input logic RREADY
);

logic write_op_active;
logic read_op_active;
logic write_data_pre_handshake;
logic read_data_pre_handshake;
logic write_address_pre_handshake;
logic read_address_pre_handshake;

assign write_op_active = AWVALID && AWREADY;
assign read_op_active = ARVALID && ARREADY;
assign write_data_pre_handshake = WVALID && !WREADY;
assign read_data_pre_handshake = RVALID && !RREADY;
assign write_address_pre_handshake = AWVALID && !AWREADY;
assign read_address_pre_handshake = ARVALID && !ARREADY;

property write_data_stable;
    @(posedge ACLK) disable iff (!ARESETn) write_data_pre_handshake |=> $stable(WDATA)
endproperty

property read_data_stable;
    @(posedge ACLK) disable iff (!ARESETn) read_data_pre_handshake |=> $stable(RDATA)
endproperty

property write_address_stable;
    @(posedge ACLK) disable iff (!ARESETn) write_address_pre_handshake |=> $stable(AWADDR)
endproperty

property read_address_stable;
    @(posedge ACLK) disable iff (!ARESETn) read_address_pre_handshake |=> $stable(ARADDR) 
endproperty


assert property(read_data_stable) else
$error("read data unstable before handshake");

assert property(write_data_stable) else
$error("write data unstable before handshake");

assert property(read_address_stable) else
$error("read address unstable before handshake");

assert property(write_address_stable) else
$error("write address unstable before handshake");


endmodule


