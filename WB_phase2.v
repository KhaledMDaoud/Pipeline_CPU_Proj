module WB_mux(
    reset,
    alu_result_wire,
    mem_result_wire,
    memToReg_wire,
    writeback_wire
);

input wire reset;
input wire [31:0] alu_result_wire;
input wire [31:0] mem_result_wire;
input wire memToReg_wire;

output wire [31:0] writeback_wire;
reg [31:0] writeback;

assign writeback_wire = writeback;

always @(*) begin 
    if(~reset) begin 
        writeback = 32'd0;
    end
    else begin
        if(memToReg_wire) begin 
            writeback = mem_result_wire;
        end
        else begin 
            writeback = alu_result_wire;
        end
    end
end
endmodule

module WB(
    reset,
    alu_result_wire,
    mem_result_wire,
    memToReg_wire,
    regWrite_in,
    RD_in,
    writeback_wire,
    regWrite_out,
    RD_out
); 

input wire reset,memToReg_wire,regWrite_in;
input wire [4:0] RD_in;
input wire [31:0] alu_result_wire;
input wire [31:0] mem_result_wire;

output wire [31:0] writeback_wire;
output wire regWrite_out;
output wire [4:0] RD_out;

assign RD_out = RD_in;
assign regWrite_out = regWrite_in;

WB_mux WM(reset,alu_result_wire,mem_result_wire,memToReg_wire,writeback_wire);
endmodule