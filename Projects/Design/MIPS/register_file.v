module register_file(
    input         clk,
    input         rst_n,
    input [4:0]   a1,
    input [4:0]   a2,
    input [4:0]   a3,
    input [31:0]  write_data,
    input         reg_write,
    input         reg_dst,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2
);

reg [31:0] [0:31] registers;
integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'b0;
        end
        read_data1 <= 32'b0;
        read_data2 <= 32'b0;
    end else begin
        if (reg_write)begin
            if (reg_dst) begin
                registers[a3] <= write_data;
            end else begin
                registers[a2] <= write_data;
            end
        end else begin
            read_data1 <= registers[a1];
            read_data2 <= registers[a2];
        end
        registers[0] = 32'h00000000; //Register 0 is always 0
    end
end
endmodule
