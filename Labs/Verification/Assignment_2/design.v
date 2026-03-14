module multi_op_processor (
    input  [7:0] data_in,
    input  [1:0] op_sel,
    output reg [7:0] data_out
);

    always @(*) begin
        case (op_sel)
            2'b00: data_out = data_in + 1;       // Increment
            2'b01: data_out = data_in - 1;       // Decrement
            2'b10: data_out = ~data_in;          // Bitwise NOT
            2'b11: data_out = data_in << 1;      // Left shift by 1
            default: data_out = data_in;
        endcase
    end

endmodule
