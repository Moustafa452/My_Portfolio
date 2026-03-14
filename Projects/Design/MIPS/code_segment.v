module code_segment(
    input  [31:0] adr,
    input         en,
    output reg [31:0] ins
);

wire [10:0] address;
assign address = adr [10:0];

reg [7:0] registers [0:2047];

initial begin
    $readmemh("INSTRUCTIONS.hex", registers);
end

always @(*) begin
    if(en && adr[1:0] == 2'b00 && address <= 2044) begin    
        ins = {registers[address + 3], registers[address + 2], registers[address + 1], registers[address]};
    end else begin
        ins = 32'h00000000;
    end
end

endmodule
