module memory (
    input        clk,
    input        rst_n,
    input [31:0] adr,
    input [31:0] wdata,
    input        memwrite,
    input        memread,
    output [31:0] ins,
    output [31:0] rdata
);

reg [7:0] [0:4095] registers;
reg en_d, en_c;
 
data_segment data_segment_inst(
    .clk(clk),
    .rst_n(rst_n),
    .en(en_d),
    .adr(adr),
    .wdata(wdata),
    .memwrite(memwrite),
    .memread(memread),
    .rdata(rdata)
);
code_segment code_segment_inst(
    .adr(adr),
    .en(en_c),
    .ins(ins)
);

always @(posedge clk or negedge rst_n) begin
    if (adr[11]) begin
        en_c <= 1;
        en_d <= 0;
    end else begin
        en_d <= 1;
        en_c <= 0;
    end
    end
endmodule
