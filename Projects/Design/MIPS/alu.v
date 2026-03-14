module alu (
  input  [31:0] a, b,
  input  [2:0]  sel,
  output reg [31:0] flag_reg,
  output reg [31:0] res
);

always @(*) begin
  case(sel)
    3'b000: res = a + b;
    3'b001: res = a - b;
    3'b010: res = a * b; // sim only
    3'b011: res = a / b; // sim only
    3'b100: res = a & b;
    3'b101: res = a | b;
    3'b110: res = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // signed SLT
    3'b111: res = ~a;   //sim only
    default: res = 0;
  endcase

  flag_reg = 32'b0;
  if (res == 32'b0) flag_reg[0] = 1'b1;
end
endmodule
