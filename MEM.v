module DM(
    clk,
    reset,
    alu_result_in,
    store_data_wire,
    memRead_wire,
    memWrite_wire,
    F3,
    mem_result_wire
); 

input wire clk,reset;
input wire [31:0] alu_result_in;
input wire [31:0] store_data_wire;
input wire [2:0] F3;
input wire memRead_wire, memWrite_wire;

output wire [31:0] mem_result_wire;

reg [7:0] Data_mem [0:(2**13)-1];
reg [31:0] read_data;
wire [12:0] addr;

assign addr = alu_result_in[12:0];
assign mem_result_wire = read_data;

integer i;
always @(posedge clk or negedge reset) begin 
    if(~reset) begin 
        for(i=0;i<(2**13);i=i+1) begin 
            Data_mem[i] <= 8'd0;
        end
    end
    else if(memWrite_wire && F3 == 3'b001) begin 
        Data_mem [addr] <= store_data_wire [7:0];
    end
    else if(memWrite_wire && F3 == 3'b011) begin 
        Data_mem [addr] <= store_data_wire [7:0];
        Data_mem [addr+1] <= store_data_wire [15:8];
        Data_mem [addr+2] <= store_data_wire [23:16];
        Data_mem [addr+3] <= store_data_wire [31:24];
    end
end

always @(*) begin 
    if(~reset) begin 
        read_data <= 32'd0;
    end
    else if(memRead_wire && F3 == 3'b100) begin 
        read_data [7:0] <= Data_mem [addr];
        read_data [15:8] <= Data_mem [addr+1];
        read_data[31:16] <= {16{Data_mem[addr+1][7]}};
    end
    else if(memRead_wire && F3 == 3'b011) begin 
        read_data [7:0] <= Data_mem [addr];
        read_data [15:8] <=Data_mem [addr+1];
        read_data [23:16] <= Data_mem [addr+2];
        read_data [31:24] <=Data_mem [addr+3];
    end
    else begin 
        read_data = 32'd0;
    end
end
endmodule



module MEM(
    clk,
    reset,
    alu_result_in,
    store_data_wire,
    memRead_wire,
    memWrite_wire,
    memToReg_in,
    regWrite_in,
    F3,
    RD_in,
    mem_result_wire,
    alu_result_out,
    memToReg_out,
    regWrite_out,
    RD_out
); 

input wire clk,reset;
input wire memRead_wire,memWrite_wire,memToReg_in,regWrite_in;
input wire [2:0] F3;
input wire [31:0] store_data_wire;
input wire [31:0] alu_result_in;
input wire [4:0] RD_in;

output wire memToReg_out,regWrite_out;
output wire [31:0] mem_result_wire;
output wire [31:0] alu_result_out;
output wire [4:0] RD_out;

assign regWrite_out = regWrite_in;
assign memToReg_out = memToReg_in;
assign alu_result_out = alu_result_in;
assign RD_out = RD_in;

DM data_mem(clk,reset,alu_result_in,store_data_wire,memRead_wire,memWrite_wire,F3,mem_result_wire);
endmodule