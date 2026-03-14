interface uart_if(input bit clk);
    logic rst_n, tx_start, parity_en, even_parity, tx, tx_busy;
    logic [7:0] data_in;

    modport test (
        input clk, tx, tx_busy,
        output rst_n, tx_start, data_in, parity_en, even_parity
    );
    modport dut (
        input clk, rst_n, tx_start, data_in, parity_en, even_parity,
        output tx, tx_busy 
    );
endinterface