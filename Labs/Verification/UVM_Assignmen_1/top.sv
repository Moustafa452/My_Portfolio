`include "interface.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;
import router_pkg::*;

module top;
    router_if router_vif();
    router DUT (
                .clk(router_vif.clk),
                .rst_n(router_vif.rst_n),
                .data_in0(router_vif.data_in0),
                .data_in1(router_vif.data_in1),
                .data_in2(router_vif.data_in2),
                .data_in3(router_vif.data_in3),
                .valid_in0(router_vif.valid_in0),
                .valid_in1(router_vif.valid_in1),
                .valid_in2(router_vif.valid_in2),
                .valid_in3(router_vif.valid_in3),
                .data_out0(router_vif.data_out0),
                .data_out1(router_vif.data_out1),
                .valid_out0(router_vif.valid_out0),
                .valid_out1(router_vif.valid_out1));

    initial begin
       router_vif.clk = 0;
       forever begin
           #2ns
           router_vif.clk = ~router_vif.clk;
       end
    end

    initial begin
        uvm_top.set_report_verbosity_level(UVM_FULL);
        run_test("router_test");
    end
endmodule