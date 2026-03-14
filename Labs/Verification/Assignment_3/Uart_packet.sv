package stim;

class transaction;
    rand bit [7:0] data_in[];
    rand bit parity_en[], even_parity[];

    function new (int size = 300);
        data_in = new[size];
        parity_en = new[size];
        even_parity = new[size];
        $display("the stim size is %0d", size);
    endfunction

    constraint corner_case {
        data_in dist {8'h00:/1, 8'hff:/1};
    } 
    constraint parity {
        parity_en dist {1'b0:/50, 1'b1:/50};
    }
    constraint parity_type {
        even_parity dist {1'b0:/50, 1'b1:/50};
    }

endclass
endpackage 