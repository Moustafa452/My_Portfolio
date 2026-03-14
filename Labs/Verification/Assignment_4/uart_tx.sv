module uart_tx (uart_if.dut bus_if);

    // State machine states
    localparam IDLE   = 3'd0,
               START  = 3'd1,
               DATA   = 3'd2,
               PARITY = 3'd3,
               STOP   = 3'd4;

    reg [2:0] state;
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    reg       parity_bit;

    always @(posedge bus_if.clk or negedge bus_if.rst_n) begin
        if (!bus_if.rst_n) begin
            state     <= IDLE;
            bus_if.tx        <= 1'b1;  // idle is high
            bus_if.tx_busy   <= 1'b0;
            shift_reg <= 8'd0;
            bit_cnt   <= 4'd0;
            parity_bit <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    bus_if.tx <= 1'b1;
                    bus_if.tx_busy <= 1'b0;
                    if (bus_if.tx_start) begin
                        shift_reg <= bus_if.data_in;
                        bit_cnt <= 4'd0;
                        parity_bit <= (bus_if.even_parity) ? ~(^bus_if.data_in) : (^bus_if.data_in);
                        bus_if.tx_busy <= 1'b1;
                        state <= START;
                    end
                end

                START: begin
                    bus_if.tx <= 1'b0; // start bit
                    state <= DATA;
                end

                DATA: begin
                    bus_if.tx <= shift_reg[0];             
                    shift_reg <= shift_reg >> 1;      
                    bit_cnt <= bit_cnt + 1;  
                    if (bit_cnt == 4'd7) begin
                        if (bus_if.parity_en)
                            state <= PARITY;
                        else
                            state <= STOP;
                    end
                end

                PARITY: begin
                    bus_if.tx <= parity_bit;
                    state <= STOP;
                end

                STOP: begin
                    bus_if.tx <= 1'b1; // stop bit (always 1)
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule