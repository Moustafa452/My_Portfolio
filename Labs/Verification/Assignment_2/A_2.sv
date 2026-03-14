module A_2;

logic [7:0] data_in, data_out;
logic [1:0] op_sel;
multi_op_processor dut(.*);

typedef struct packed {
  logic [7:0] data_in;
  logic [1:0] op_sel;  
} dyn;

dyn stim [];                                        // choose a packed structt for better space and time complexities
logic [7:0] outQ [$];
logic [7:0] exp_out [int];

function automatic void size_confg (int s, ref dyn stim [], ref logic [7:0] outQ[$], ref logic [7:0] exp_out[int]);
    stim = new[s](stim);
    outQ = {};
    exp_out.delete();
endfunction

function automatic void gen_stim (ref dyn stim []);    
    foreach(stim[i]) begin
        stim[i].data_in = $urandom();
        stim[i].op_sel = $urandom();
    end
endfunction

task automatic drive_stim (dyn stim [], ref logic [7:0] outQ [$], data_out);
    foreach(stim[i]) begin
        data_in = stim[i].data_in;
        op_sel = stim[i].op_sel;
        #1ns
        collect_out(outQ, data_out, i);
    end
endtask

task automatic golden_model (ref logic [7:0] exp_out [int], dyn stim[]);
    for(int i = 0; i < $size(stim); i++) begin
         case (stim[i].op_sel)
            2'b00: exp_out[i] = stim[i].data_in + 1;       
            2'b01: exp_out[i] = stim[i].data_in - 1;       
            2'b10: exp_out[i] = ~stim[i].data_in;          
            2'b11: exp_out[i] = stim[i].data_in << 1;      
            default: exp_out[i] = stim[i].data_in;
        endcase
    end
endtask

function automatic void collect_out (ref logic [7:0] outQ [$], data_out, int i);
        outQ [i] = data_out;
endfunction

function automatic void check_resulte (const ref logic [7:0] outQ [$], exp_out [int], dyn stim []);
    foreach(outQ[i]) begin
        if(outQ[i] == exp_out[i]) begin
            $display("[Pass]: data_in = %0d, op_sel = %0d, data_out = %0d\n",stim[i].data_in, stim[i].op_sel, outQ[i]);
        end else begin
            $error("[Error]data_in = %0d, op_sel = %0d, data_out = %0d\n",stim[i].data_in, stim[i].op_sel, exp_out[i]);
        end
    end
endfunction

function automatic void stim_reconfig (ref dyn stim[]);
    stim.shuffle();
endfunction

initial begin
    size_confg(100, stim, outQ, exp_out);
    gen_stim(stim);
    $display("stimulus size = %0d", $size(stim));
    drive_stim(stim, outQ, data_out);
    golden_model(exp_out, stim);
    check_resulte(outQ, exp_out, stim);

    size_confg(200, stim, outQ, exp_out);
    gen_stim(stim);
    $display("stimulus size = %0d", $size(stim));
    drive_stim(stim, outQ, data_out);
    golden_model(exp_out, stim);
    check_resulte(outQ, exp_out, stim);

    stim_reconfig(stim);
    $display("stimulus size = %0d", $size(stim));
    drive_stim(stim, outQ, data_out);
    golden_model(exp_out, stim);
    check_resulte(outQ, exp_out, stim);
end

endmodule