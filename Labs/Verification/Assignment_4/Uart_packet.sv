package stim;
class transaction;
    randc logic [7:0] data_in;
    randc logic rst_n, tx_start,parity_en, even_parity;

    constraint default_data {
    data_in inside {[8'h00:8'hFF]};
    }
    constraint corner_case {
        data_in dist {8'h00:/25, 8'hff:/25, 8'haa:/25, 8'h55:/25};
    } 
    constraint parity {
        parity_en dist {1'b0:/50, 1'b1:/50};
    }
    constraint parity_type {
        even_parity dist {1'b0:/50, 1'b1:/50};
    }
    
    covergroup cg;
        coverpoint data_in{
            bins d_0 = {8'h00};
            bins d_255 = {8'hff};
            bins others = default;
        }
        coverpoint rst_n{
            bins r_0 = {1'b0};
            bins r_1 = {1'b1};
        }
        coverpoint tx_start{
            bins t_0 = {1'b0};
            bins t_1 = {1'b1};
        }
        
        pn: coverpoint parity_en;
        ep: coverpoint even_parity;
        
        cross pn, ep{
            bins no_p = binsof(pn) intersect {0} &&
                        binsof(ep);
                        
            bins even_p = binsof(pn) intersect {1} &&
                          binsof(ep) intersect {1};

            bins odd_p =  binsof(pn) intersect {1} &&
                          binsof(ep) intersect {0};
        }

    endgroup
endclass
endpackage 