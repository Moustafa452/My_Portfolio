module A_4 (uart_if.test uart_bus);

import stim::*;
bit rst_n, tx_start, parity_en, even_parity, tx, tx_busy;
bit [7:0] data_in;
bit clk;
bit act_out [$];
bit exp_out [$]; 
transaction tr;

assign clk = uart_bus.clk;
assign uart_bus.rst_n = rst_n;
assign uart_bus.tx_start = tx_start;
assign uart_bus.parity_en = parity_en;
assign uart_bus.even_parity = even_parity;
assign uart_bus.data_in = data_in;
assign tx = uart_bus.tx;
assign tx_busy = uart_bus.tx_busy;

task automatic reset (ref bit rst_n);
    rst_n = 1;
    #5ns
    rst_n = 0;
    #5ns
    rst_n = 1;
endtask
function automatic void data_rst (bit act_out [$], exp_out [$]);
    exp_out = {};
    act_out = {};
endfunction

function automatic void gen_stim (ref transaction tr);
        assert (tr.randomize()) 
        else   $display("couldn't randomize stim\n");
endfunction

task automatic drive_stim (ref transaction tr, ref bit tx_start, tx_busy, parity_en, even_parity, clk, act_out [$],ref bit [7:0] data_in);
    wait (tx_busy == 0)
    @(negedge clk)
    data_in = tr.data_in;
    parity_en = tr.parity_en;
    even_parity =tr.even_parity;
    tx_start    = 1'b1;
    @(negedge clk);
    tx_start = 1'b0;
    if(tr.parity_en) begin    
        repeat (11)
            collect_out(clk, act_out);
        end else begin
            repeat (10)
            collect_out(clk ,act_out);
        end
endtask

task automatic golden_model (ref transaction tr, ref bit tx_start, clk, exp_out [$]);
    bit parity;
    exp_out.push_back(0);
    for(int j=0; j<8; j++) begin
        exp_out.push_back(tr.data_in[j]);
    end
    if(tr.parity_en) begin
        parity = tr.even_parity ? ~(^tr.data_in) : ^tr.data_in;
        exp_out.push_back(parity);
    end
    exp_out.push_back(1);
endtask

task automatic collect_out (ref bit clk, act_out [$]);  
    @(negedge clk)
    act_out.push_back(tx);
endtask

task automatic check_res (ref bit act_out [$], ref bit exp_out [$], ref transaction tr);
    int act_idx = 0, exp_idx = 0;
    bit [7:0] act_byte, exp_byte;
    bit act_parity, exp_parity;
    bit parity_check;

    act_idx++;
    exp_idx++;

    for (int j=0; j<8; j++) begin
        act_byte[j] = act_out[act_idx];
        exp_byte[j] = exp_out[exp_idx];
        act_idx++;
        exp_idx++;
    end

    if (tr.parity_en) begin
        act_parity = act_out[act_idx];
        exp_parity = exp_out[exp_idx];
        act_idx++;
        exp_idx++;
        parity_check = act_parity == exp_parity;
        act_idx++;
        exp_idx++;
        if (act_byte == exp_byte && parity_check) begin
            $display("[PASS] Transmitted Byte : %b, Parity= %b Expected Byte : %b Expected parity: %b \n", act_byte, act_parity, exp_byte, exp_parity);
        end else begin
            $display("[ERROR] Transmitted Byte : %b, Parity= %b Expected Byte : %b Expected parity: %b \n", act_byte, act_parity, exp_byte, exp_parity);
        end
    end else begin
        if (act_byte == exp_byte) begin
            $display("[PASS] Transmitted Byte : %b, Expected Byte : %b \n", act_byte, exp_byte);
        end else begin
            $display("[ERROR] Transmitted Byte : %b, Expected Byte : %b \n", act_byte, exp_byte);
        end
    end
endtask

initial begin
    reset (rst_n);
    
    tr = new();
    tr.corner_case.constraint_mode(0);
    repeat(700) begin
        data_rst(act_out, exp_out);
        gen_stim (tr);
        tr.cg.sample();
        drive_stim (tr,tx_start, tx_busy, parity_en, even_parity, clk, act_out, data_in);
        golden_model (tr, tx_start, clk, exp_out);
        check_res (act_out, exp_out, tr);
    end

    tr.corner_case.constraint_mode(1);
    repeat(10) begin
        data_rst(act_out, exp_out);
        gen_stim (tr);
        tr.cg.sample();
        drive_stim (tr,tx_start, tx_busy, parity_en, even_parity, clk, act_out, data_in);
        golden_model (tr, tx_start, clk, exp_out);
        check_res (act_out, exp_out, tr);
    end
    $stop;
end

endmodule 




