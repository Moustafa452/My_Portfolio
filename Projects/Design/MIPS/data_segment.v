module data_segment(
    input       rst_n,
    input       en,
    input [31:0] adr,
    input [31:0] wdata,
    input        memwrite,
    input        memread,
    output reg [31:0] rdata
);

wire [10:0] address;
assign address = adr [10:0];
reg [7:0] registers [0:2047];
integer i;

always @(*) begin
    if(!rst_n) begin
        for (i = 0; i < 2048; i = i+1) begin
            registers[i] = 8'b0;
        end
        rdata = 32'b0;
    end else if (en && address[1:0] == 2'b00 && address <= 2044) begin
        if(memwrite) begin
            registers[address]     = wdata[7:0];
            registers[address + 1] = wdata[15:8];
            registers[address + 2] = wdata[23:16];
            registers[address + 3] = wdata[31:24];
        end else if(memread) begin
            rdata [7:0]     = registers[address];
            rdata [15:8]    = registers[address + 1];
            rdata [23:16]   = registers[address + 2]; 
            rdata [31:24]   = registers[address + 3];
             
        end 
    end else begin
        rdata <= 32'b0;
    end
end

endmodule
