`include "interface.sv"
`include "uart_tx.sv"
`include "A_4.sv"

module top;
    logic clk = 0;
    
    always #5ns clk = ~clk;

    uart_if uart_bus(clk);
    A_4 a4_inst(uart_bus.test);
    uart_tx tx_inst(uart_bus.dut);
endmodule