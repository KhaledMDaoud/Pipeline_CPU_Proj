module CU(
    reset,
    instruction_wire,
    branch_wire,
    memRead_wire,
    memWrite_wire,
    memToReg_wire,
    regWrite_wire,
    aluSrc_wire,
    aluOp_wire,
    Funct3
);

input wire reset;
input wire [31:0] instruction_wire;

output wire branch_wire,memRead_wire,memWrite_wire;
output wire memToReg_wire,regWrite_wire,aluSrc_wire;
output wire [3:0] aluOp_wire;
output wire [2:0] Funct3;

wire [6:0] Opcode;
wire [6:0] Funct7;
reg branch,memRead,memWrite,memToReg,aluSrc,regWrite;
reg [3:0] aluOp;

assign branch_wire = branch;
assign memRead_wire = memRead;
assign memWrite_wire = memWrite;
assign memToReg_wire = memToReg;
assign regWrite_wire = regWrite;
assign aluSrc_wire = aluSrc;
assign aluOp_wire = aluOp;

assign Opcode = instruction_wire [6:0];
assign Funct7 = instruction_wire [31:25];
assign Funct3 = instruction_wire [14:12];
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
parameter R_type = 7'b0110100;
parameter I_type = 7'b0010100;
parameter U_type = 7'b0111000;
parameter S_type = 7'b0100100;
parameter UJ_type = 7'b1110000;
parameter SB_type = 7'b1100100;

always @(*) begin 
    if(~reset) begin 
        branch <= 1'b0;
        memRead <= 1'b0;
        memWrite <= 1'b0;
        memToReg <= 1'b0;
        aluSrc <= 1'b0;
        regWrite <= 1'b0;
        aluOp <= 4'b0000;
    end
    else begin 
        case (Opcode) 
            R_type: begin 
                case (Funct3)
                    3'b000: begin
                    branch <= 1'b0;
                    memRead <= 1'b0;
                    memWrite <= 1'b0;
                    memToReg <= 1'b0;
                    aluSrc <= 1'b0;
                    regWrite <= 1'b1;
                    aluOp <= 4'b0100;
                    end
                    3'b001: begin 
                        if (Funct7 == 7'b0010000) begin 
                            branch <= 1'b0;
                            memRead <= 1'b0;
                            memWrite <= 1'b0;
                            memToReg <= 1'b0;
                            aluSrc <= 1'b0;
                            regWrite <= 1'b1;
                            aluOp <= 4'b0000;
                        end
                        else begin 
                            branch <= 1'b0;
                            memRead <= 1'b0;
                            memWrite <= 1'b0;
                            memToReg <= 1'b0;
                            aluSrc <= 1'b0;
                            regWrite <= 1'b1;
                            aluOp <= 4'b0011;
                        end
                    end
                    3'b100: begin
                    branch <= 1'b0;
                    memRead <= 1'b0;
                    memWrite <= 1'b0;
                    memToReg <= 1'b0;
                    aluSrc <= 1'b0;
                    regWrite <= 1'b1;
                    aluOp <= 4'b0111;
                    end
                    3'b101: begin
                    branch <= 1'b0;
                    memRead <= 1'b0;
                    memWrite <= 1'b0;
                    memToReg <= 1'b0;
                    aluSrc <= 1'b0;
                    regWrite <= 1'b1;
                    aluOp <= 4'b0001;
                    end
                    3'b110: begin
                    if(Funct7 == 7'b0010000) begin 
                        branch <= 1'b0;
                        memRead <= 1'b0;
                        memWrite <= 1'b0;
                        memToReg <= 1'b0;
                        aluSrc <= 1'b0;
                        regWrite <= 1'b1;
                        aluOp <= 4'b0110;
                    end
                    else begin 
                        branch <= 1'b0;
                        memRead <= 1'b0;
                        memWrite <= 1'b0;
                        memToReg <= 1'b0;
                        aluSrc <= 1'b0;
                        regWrite <= 1'b1;
                        aluOp <= 4'b1011;
                    end
                    end
                    3'b111: begin
                    branch <= 1'b0;
                    memRead <= 1'b0;
                    memWrite <= 1'b0;
                    memToReg <= 1'b0;
                    aluSrc <= 1'b0;
                    regWrite <= 1'b1;
                    aluOp <= 4'b0010;
                    end
                endcase
            end
            I_type: begin 
                if(Funct3 == 3'b011) begin 
                    regWrite <= 1'b1;
                    aluSrc <= 1'b1;
                    aluOp <= 4'b0000;
                    branch <= 1'b0;
                    memRead <= 1'b1;
                    memWrite <= 1'b0;
                    memToReg <= 1'b1;
                end
                else if(Funct3 == 3'b100) begin 
                    regWrite <= 1'b1;
                    aluSrc <= 1'b1;
                    aluOp <= 4'b0000;
                    branch <= 1'b0;
                    memRead <= 1'b1;
                    memWrite <= 1'b0;
                    memToReg <= 1'b1;
                end
                else begin 
                    case (Funct3) 
                        3'b000: begin 
                        regWrite <= 1'b1;
                        aluSrc <= 1'b1;
                        aluOp <= 4'b0100;
                        branch <= 1'b0;
                        memRead <= 1'b0;
                        memWrite <= 1'b0;
                        memToReg <= 1'b0;
                        end
                        3'b001: begin 
                        regWrite <= 1'b1;
                        aluSrc <= 1'b1;
                        aluOp <= 4'b0000;
                        branch <= 1'b0;
                        memRead <= 1'b0;
                        memWrite <= 1'b0;
                        memToReg <= 1'b0;
                        end
                        3'b010: begin 
                        regWrite <= 1'b1;
                        aluSrc <= 1'b1;
                        aluOp <= 4'b0101;
                        branch <= 1'b0;
                        memRead <= 1'b0;
                        memWrite <= 1'b0;
                        memToReg <= 1'b0;
                        end
                        3'b111: begin 
                        regWrite <= 1'b1;
                        aluSrc <= 1'b1;
                        aluOp <= 4'b0010;
                        branch <= 1'b0;
                        memRead <= 1'b0;
                        memWrite <= 1'b0;
                        memToReg <= 1'b0;
                        end
                    endcase
                end
            end
            SB_type: begin 
                if(Funct3 == 3'b110) begin 
                    branch <= 1'b1;
                    aluSrc <= 1'b0;
                    aluOp <= 4'b1001;
                    memRead <= 1'b0;
                    memWrite <= 1'b0;
                    memToReg <= 1'b0;
                    regWrite <= 1'b0;
                end
                else begin 
                    branch <= 1'b1;
                    aluSrc <= 1'b0;
                    aluOp <= 4'b1010;
                    memRead <= 1'b0;
                    memWrite <= 1'b0;
                    memToReg <= 1'b0;
                    regWrite <= 1'b0;
                end
            end
            U_type: begin 
                branch <= 1'b0;
                aluSrc <= 1'b1;
                aluOp <= 4'b1000;
                memRead <= 1'b0;
                memWrite <= 1'b0;
                memToReg <= 1'b0;
                regWrite <= 1'b1;
            end
            UJ_type: begin 
                branch <= 1'b0;
                memRead <= 1'b0;
                memWrite <= 1'b0;
                memToReg <= 1'b0;
                aluSrc <= 1'b1;
                regWrite <= 1'b1;
                aluOp <= 4'b0000;
        end
            S_type: begin
                branch <= 1'b0;
                aluSrc <= 1'b1;
                aluOp <= 4'b0000;
                memRead <= 1'b0;
                memWrite <= 1'b1;
                memToReg <= 1'b0;
                regWrite <= 1'b0;
        end
            default: begin
                branch   <= 1'b0;
                memRead  <= 1'b0;
                memWrite <= 1'b0;
                memToReg <= 1'b0;
                aluSrc   <= 1'b0;
                regWrite <= 1'b0;
                aluOp    <= 4'b0000;
        end
        endcase
    end
end

endmodule


module imm_gen(
    reset,
    instruction_wire,
    immediate_wire
); 

input wire reset;
input wire [31:0] instruction_wire;

output wire [31:0] immediate_wire;

reg [31:0] immediate;
wire [6:0] Opcode;

assign Opcode = instruction_wire [6:0];
assign immediate_wire = immediate;

parameter R_type = 7'b0110100;
parameter I_type = 7'b0010100;
parameter U_type = 7'b0111000;
parameter S_type = 7'b0100100;
parameter UJ_type = 7'b1110000;
parameter SB_type = 7'b1100100;

always @(*) begin 
    if(~reset) begin 
        immediate <= 32'd0;
    end
    else begin
        case(Opcode)
            default: begin 
                immediate <= 32'd0;
            end
            I_type: begin 
                immediate <= {{20{instruction_wire[31]}},instruction_wire[31:20]};
            end
            S_type: begin 
                immediate <= {{20{instruction_wire[31]}},instruction_wire[31:25],instruction_wire[11:7]};
            end
            SB_type: begin 
                immediate <= {{19{instruction_wire[31]}},instruction_wire[31],instruction_wire[7],instruction_wire[30:25],instruction_wire[11:8],1'b0};
            end
            U_type: begin 
                immediate <= {instruction_wire[31:12],12'b0};
            end
            UJ_type: begin 
                immediate <= {{12{instruction_wire[31]}},instruction_wire[19:12],instruction_wire[20],instruction_wire[30:21],1'b0};
            end
        endcase 
    end
end
endmodule

module ID(
    clk,
    reset,
    instruction_wire,
    pc_wire,
    branch_wire,
    memRead_wire,
    memWrite_wire,
    memToReg_wire,
    regWrite_wire,
    aluSrc_wire,
    aluOp_wire,
    immediate_wire,
    rs1_wire,
    rs2_wire,
    rd_wire,
    old_pc_wire,
    Funct3
);

input wire clk,reset;
input wire [31:0] instruction_wire;
input wire [15:0] pc_wire;

output wire branch_wire,memRead_wire,memWrite_wire,memToReg_wire,regWrite_wire,aluSrc_wire;
output wire [3:0] aluOp_wire;
output wire [31:0] immediate_wire;
output wire [4:0] rs1_wire,rs2_wire,rd_wire;
output wire [15:0] old_pc_wire;
output wire [2:0] Funct3;

assign rs1_wire = instruction_wire[19:15];
assign rs2_wire = instruction_wire[24:20];
assign rd_wire = instruction_wire[11:7];
assign old_pc_wire = pc_wire;

imm_gen immediate_generator(.reset(reset), .instruction_wire(instruction_wire), .immediate_wire(immediate_wire));
CU control_unit(.reset(reset), .instruction_wire(instruction_wire), .branch_wire(branch_wire), .memRead_wire(memRead_wire), .memWrite_wire(memWrite_wire), .memToReg_wire(memToReg_wire), .regWrite_wire(regWrite_wire), .aluSrc_wire(aluSrc_wire), .aluOp_wire(aluOp_wire),.Funct3(Funct3));

endmodule