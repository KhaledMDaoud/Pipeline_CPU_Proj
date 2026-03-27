module ALU_mux(
    reset,
    read_data2_wire,
    aluSrc_wire,
    immediate_wire,
    alu_val2_wire
); 

input wire reset,aluSrc_wire;
input wire [31:0] read_data2_wire;
input wire [31:0] immediate_wire;

output wire [31:0] alu_val2_wire;

reg [31:0] alu_val2;
assign alu_val2_wire = alu_val2;

always @(*) begin 
    if(~reset) begin 
        alu_val2 = 32'd0;
    end
    else if(aluSrc_wire) begin 
        alu_val2 = immediate_wire;
    end
    else begin 
        alu_val2 = read_data2_wire;
    end
end
endmodule

module ALU(
    reset,
    aluOp_wire,
    read_data1_wire,
    alu_val2_wire,
    alu_result_wire,
    ZF_wire
); 

input wire reset;
input wire [3:0] aluOp_wire;
input wire [31:0] read_data1_wire;
input wire [31:0] alu_val2_wire;

output wire [31:0] alu_result_wire;
output wire ZF_wire;

reg [31:0] alu_result;
reg ZF;

assign alu_result_wire = alu_result;
assign ZF_wire = ZF;

parameter Add_op = 4'b0000;
parameter Xor_op = 4'b0001;
parameter Or_op = 4'b0010;
parameter Sub_op = 4'b0011;
parameter And_op = 4'b0100;
parameter Sl_op = 4'b0101;
parameter Sr_op = 4'b0110;
parameter Sltu_op = 4'b0111;
parameter Lui_op = 4'b1000;
parameter Bge_op = 4'b1001;
parameter Bne_op = 4'b1010;
parameter Sra_op = 4'b1011;

always @(*) begin 
    if(~reset) begin 
        alu_result = 32'd0;
    end
    else begin 
        case(aluOp_wire) 
            Add_op: alu_result = read_data1_wire + alu_val2_wire;
            Xor_op: alu_result = read_data1_wire ^ alu_val2_wire;
            Or_op: alu_result = read_data1_wire | alu_val2_wire;
            Sub_op: alu_result = read_data1_wire - alu_val2_wire;
            And_op: alu_result = read_data1_wire & alu_val2_wire;
            Sl_op: alu_result = read_data1_wire << alu_val2_wire;
            Sr_op: alu_result = read_data1_wire >> alu_val2_wire;
            Sltu_op: begin 
                if(read_data1_wire<alu_val2_wire) begin
                    alu_result = 32'd1;
                 end
                 else begin 
                    alu_result = 32'd0;
                 end
            end
            Lui_op: alu_result = alu_val2_wire; 
            Bge_op: begin 
                if(read_data1_wire >= alu_val2_wire) begin 
                    alu_result = 32'd0;
                end
                else begin 
                    alu_result = 32'd1;
                end
            end
            Bne_op: begin 
                if(read_data1_wire != alu_val2_wire) begin 
                    alu_result = 32'd0;
                end
                else begin 
                    alu_result = 32'd1;
                end
            end
            Sra_op: begin 
                if(read_data1_wire[31] == 1'b1) begin 
                    alu_result = (read_data1_wire >> alu_val2_wire) | (~(32'hFFFF_FFFF >> alu_val2_wire));
                end
                else begin 
                    alu_result = read_data1_wire >> alu_val2_wire;
                end
            end
            default: alu_result = 32'd0;
        endcase
    end
    ZF = (alu_result == 32'd0);
end
endmodule

module Branch_adder(
    reset,
    new_pc_wire,
    immediate_wire,
    branch_pc_wire
); 

input wire reset;
input wire [15:0] new_pc_wire;
input wire [31:0] immediate_wire;

output wire [15:0] branch_pc_wire;

reg [15:0] branch_pc;

assign branch_pc_wire = branch_pc;

always @(*) begin 
    if(~reset) begin 
        branch_pc = 16'b0;
    end
    else begin 
        branch_pc = new_pc_wire + immediate_wire [15:0];
    end
end
endmodule

module branch_mux(
    reset,
    new_pc_wire,
    branch_pc_wire,
    branch_wire,
    ZF_wire,
    br_mux_res_wire,
    branch_taken
); 

input wire reset;
input wire [15:0] new_pc_wire;
input wire [15:0] branch_pc_wire;
input wire branch_wire;
input wire ZF_wire;

output wire [15:0] br_mux_res_wire;
output wire branch_taken;

reg branch_taken_reg;
reg [15:0] br_mux_res;

assign branch_taken = branch_taken_reg;
assign br_mux_res_wire = br_mux_res;

always @(*) begin 
    if(~reset) begin 
        br_mux_res = 16'd0;
        branch_taken_reg = 1'b0;
    end
    else if (ZF_wire && branch_wire) begin 
        br_mux_res = branch_pc_wire;
        branch_taken_reg = 1'b1;
    end
    else begin 
        br_mux_res = new_pc_wire;
        branch_taken_reg = 1'b0;
    end
end
endmodule

module EXE(
    reset,
    read_data1_wire,
    read_data2_wire,
    RD_in,
    immediate_wire,
    aluSrc_wire,
    aluOp_wire,
    branch_wire,
    memRead_wire_in,
    memWrite_wire_in,
    memToReg_wire_in,
    regWrite_wire_in,
    new_pc_wire,
    F3_in,
    alu_result_wire,
    br_mux_res_wire,
    flush_wire,
    store_data,
    memRead_wire_out,
    memWrite_wire_out,
    memToReg_wire_out,
    regWrite_wire_out,
    RD_out,
    F3_out,
    branch_taken
); 

input wire reset,aluSrc_wire,branch_wire,memRead_wire_in,memWrite_wire_in,memToReg_wire_in,regWrite_wire_in;
input wire [3:0] aluOp_wire;
input wire [31:0] read_data1_wire;
input wire [31:0] read_data2_wire;
input wire [4:0] RD_in;
input wire [31:0] immediate_wire;
input wire [15:0] new_pc_wire;
input wire [2:0] F3_in;

output wire [15:0] br_mux_res_wire;
output wire [31:0] alu_result_wire;
output wire [31:0] store_data;
output wire memRead_wire_out,memWrite_wire_out,memToReg_wire_out,regWrite_wire_out;
output wire [4:0] RD_out;
output wire [2:0] F3_out;
output wire flush_wire;
output wire branch_taken;

wire [31:0] alu_val2_wire;
wire ZF_wire;
wire [15:0] branch_pc_wire;

assign store_data = read_data2_wire;
assign memRead_wire_out = memRead_wire_in;
assign memWrite_wire_out = memWrite_wire_in;
assign memToReg_wire_out = memToReg_wire_in;
assign regWrite_wire_out = regWrite_wire_in;
assign RD_out = RD_in;
assign F3_out = F3_in;
assign flush_wire = ZF_wire && branch_wire;

ALU_mux AM(.reset(reset),.read_data2_wire(read_data2_wire),.aluSrc_wire(aluSrc_wire),.immediate_wire(immediate_wire),.alu_val2_wire(alu_val2_wire));
ALU alu(.reset(reset),.aluOp_wire(aluOp_wire),.read_data1_wire(read_data1_wire),.alu_val2_wire(alu_val2_wire),.alu_result_wire(alu_result_wire),.ZF_wire(ZF_wire));
Branch_adder BR_add(.reset(reset),.new_pc_wire(new_pc_wire),.immediate_wire(immediate_wire),.branch_pc_wire(branch_pc_wire));
branch_mux BM(.reset(reset),.new_pc_wire(new_pc_wire),.branch_pc_wire(branch_pc_wire),.branch_wire(branch_wire),.ZF_wire(ZF_wire),.br_mux_res_wire(br_mux_res_wire),.branch_taken(branch_taken));

endmodule