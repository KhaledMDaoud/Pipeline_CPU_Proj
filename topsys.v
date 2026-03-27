module CPU(
    clk,
    reset
); 
input wire clk,reset;
//IF WIRES
wire [15:0] br_mux_res_wire;
wire [15:0] new_pc_wire_IF;
wire [31:0] instruction_IF;

//IF_ID WIRES
wire [31:0] instruction_ID;
wire [15:0] pc_wire_ID;

//ID WIRES
wire branch_wire_ID,memRead_wire_ID,memWrite_wire_ID,memToReg_wire_ID,regWrite_wire_ID,aluSrc_wire_ID;
wire [3:0] aluOp_wire_ID;
wire [31:0] immediate_wire_ID;
wire [4:0] rs1_wire_ID,rs2_wire_ID,rd_wire_ID;
wire [15:0] old_pc_wire_ID;
wire [2:0] Funct3_ID;

//RF WIRES
wire [31:0] read_data1_RF;
wire [31:0] read_data2_RF;

//ID_EXE WIRES
wire [31:0] immediate_wire_EXE;
wire [4:0] rd_wire_EXE;
wire [31:0] rs1_wire_EXE;
wire [31:0] rs2_wire_EXE;
wire [15:0] pc_EXE;
wire regWrite_wire_EXE,aluSrc_wire_EXE,branch_wire_EXE,memRead_wire_EXE,memWrite_wire_EXE,memToReg_wire_EXE;
wire [3:0] aluOp_wire_EXE;
wire [2:0] F3_EXE;

//EXE WIRES
wire [31:0] alu_result_EXE;
wire memRead_EXMREG,memWrite_EXMREG,memToReg_EXMREG,regWrite_EXMREG;
wire [31:0] store_data_EXMREG;
wire [4:0] RD_EXMREG;
wire [2:0] F3_EXMREG;

//EXE_MEM WIRES
wire [31:0] alu_result_MEM;
wire [31:0] store_data_MEM;
wire [4:0] RD_MEM;
wire memWrite_MEM,memRead_MEM,memToReg_MEM,regWrite_MEM;
wire [2:0] F3_MEM;
wire branch_taken_EXE;

//MEM WIRES
wire [31:0] LD_Data_MWBREG;
wire [31:0] alu_result_MWBREG;
wire memToReg_MWBREG,regWrite_MWBREG;
wire [4:0] RD_MWBREG;

//MEM_WB WIRES
wire [31:0] mem_result_WB;
wire [31:0] alu_result_WB;
wire memToReg_WB,regWrite_WB;
wire [4:0] RD_WB;

//WB WIRES
wire regWrite_RF;
wire [4:0] rd_wire_RF;
wire [31:0] writeback_wire_RF;

//BRANCH FLUSH WIRE
wire flush_pipe;

IF FETCH(
    .clk(clk),
    .reset(reset),
    .br_mux_res_wire(br_mux_res_wire),
    .branch_taken(branch_taken_EXE),
    .new_pc_wire(new_pc_wire_IF),
    .instruction_wire(instruction_IF)
    );

IF_ID FDREG(
    .clk(clk),
    .reset(reset),
    .flush(flush_pipe),
    .instruction_in(instruction_IF),
    .pc_in(new_pc_wire_IF),
    .instruction_out(instruction_ID),
    .pc_out(pc_wire_ID)
    );

ID DECODE(
    .clk(clk),
    .reset(reset),
    .instruction_wire(instruction_ID),
    .pc_wire(pc_wire_ID),
    .branch_wire(branch_wire_ID),
    .memRead_wire(memRead_wire_ID),
    .memWrite_wire(memWrite_wire_ID),
    .memToReg_wire(memToReg_wire_ID),
    .regWrite_wire(regWrite_wire_ID),
    .aluSrc_wire(aluSrc_wire_ID),
    .aluOp_wire(aluOp_wire_ID),
    .immediate_wire(immediate_wire_ID),
    .rs1_wire(rs1_wire_ID),
    .rs2_wire(rs2_wire_ID),
    .rd_wire(rd_wire_ID),
    .old_pc_wire(old_pc_wire_ID),
    .Funct3(Funct3_ID)
    );

RF REGFILE(
    .clk(clk),
    .reset(reset),
    .regWrite_wire(regWrite_RF),
    .rd_wire(rd_wire_RF),
    .writeback_wire(writeback_wire_RF),
    .rs1_wire(rs1_wire_ID),
    .rs2_wire(rs2_wire_ID),
    .Read_data1_wire(read_data1_RF),
    .Read_data2_wire(read_data2_RF)
    );

ID_EX DXREG(
    .clk(clk),
    .reset(reset),
    .flush(flush_pipe),
    .immediate_wire(immediate_wire_ID),
    .read_data1_wire(read_data1_RF),
    .read_data2_wire(read_data2_RF),
    .pc_wire(old_pc_wire_ID),
    .regWrite_wire(regWrite_wire_ID),
    .aluSrc_wire(aluSrc_wire_ID),
    .aluOp_wire(aluOp_wire_ID),
    .RD_in(rd_wire_ID),
    .branch_wire(branch_wire_ID),
    .memRead_wire(memRead_wire_ID),
    .memWrite_wire(memWrite_wire_ID),
    .memToReg_wire(memToReg_wire_ID),
    .Funct3(Funct3_ID),
    .IMM(immediate_wire_EXE),
    .RD_out(rd_wire_EXE),
    .RS1(rs1_wire_EXE),
    .RS2(rs2_wire_EXE),
    .pc(pc_EXE),
    .RW(regWrite_wire_EXE),
    .AS(aluSrc_wire_EXE),
    .AO(aluOp_wire_EXE),
    .BR(branch_wire_EXE),
    .MR(memRead_wire_EXE),
    .MW(memWrite_wire_EXE),
    .MTR(memToReg_wire_EXE),
    .F3(F3_EXE)
    );

EXE EXECUTE(
    .reset(reset),
    .read_data1_wire(rs1_wire_EXE),
    .read_data2_wire(rs2_wire_EXE),
    .RD_in(rd_wire_EXE),
    .immediate_wire(immediate_wire_EXE),
    .aluSrc_wire(aluSrc_wire_EXE),
    .aluOp_wire(aluOp_wire_EXE),
    .branch_wire(branch_wire_EXE),
    .memRead_wire_in(memRead_wire_EXE),
    .memWrite_wire_in(memWrite_wire_EXE),
    .memToReg_wire_in(memToReg_wire_EXE),
    .regWrite_wire_in(regWrite_wire_EXE),
    .new_pc_wire(pc_EXE),
    .F3_in(F3_EXE),
    .alu_result_wire(alu_result_EXE),
    .br_mux_res_wire(br_mux_res_wire),
    .flush_wire(flush_pipe),
    .store_data(store_data_EXMREG),
    .memRead_wire_out(memRead_EXMREG),
    .memWrite_wire_out(memWrite_EXMREG),
    .memToReg_wire_out(memToReg_EXMREG),
    .regWrite_wire_out(regWrite_EXMREG),
    .RD_out(RD_EXMREG),
    .F3_out(F3_EXMREG),
    .branch_taken(branch_taken_EXE)
    );

EX_MEM EXMREG(
    .clk(clk),
    .reset(reset),
    .alu_result_in(alu_result_EXE),
    .store_data_in(store_data_EXMREG),
    .RD_in(RD_EXMREG),
    .MW_in(memWrite_EXMREG),
    .MR_in(memRead_EXMREG),
    .MTR_in(memToReg_EXMREG),
    .RW_in(regWrite_EXMREG),
    .F3_in(F3_EXMREG),
    .alu_result_out(alu_result_MEM),
    .store_data_out(store_data_MEM),
    .RD_out(RD_MEM),
    .MW_out(memWrite_MEM),
    .MR_out(memRead_MEM),
    .MTR_out(memToReg_MEM),
    .RW_out(regWrite_MEM),
    .F3_out(F3_MEM)
    );

MEM MEMORY(
    .clk(clk),
    .reset(reset),
    .alu_result_in(alu_result_MEM),
    .store_data_wire(store_data_MEM),
    .memRead_wire(memRead_MEM),
    .memWrite_wire(memWrite_MEM),
    .memToReg_in(memToReg_MEM),
    .regWrite_in(regWrite_MEM),
    .F3(F3_MEM),
    .RD_in(RD_MEM),
    .mem_result_wire(LD_Data_MWBREG),
    .alu_result_out(alu_result_MWBREG),
    .memToReg_out(memToReg_MWBREG),
    .regWrite_out(regWrite_MWBREG),
    .RD_out(RD_MWBREG)
);

MEM_WB MWBREG(
    .clk(clk),
    .reset(reset),
    .mem_result_in(LD_Data_MWBREG),
    .alu_result_in(alu_result_MWBREG),
    .memToReg_in(memToReg_MWBREG),
    .regWrite_in(regWrite_MWBREG),
    .RD_in(RD_MWBREG),
    .mem_result_out(mem_result_WB),
    .alu_result_out(alu_result_WB),
    .memToReg_out(memToReg_WB),
    .regWrite_out(regWrite_WB),
    .RD_out(RD_WB)
);

WB WRITEBACK(
    .reset(reset),
    .alu_result_wire(alu_result_WB),
    .mem_result_wire(mem_result_WB),
    .memToReg_wire(memToReg_WB),
    .regWrite_in(regWrite_WB),
    .RD_in(RD_WB),
    .writeback_wire(writeback_wire_RF),
    .regWrite_out(regWrite_RF),
    .RD_out(rd_wire_RF)
);

endmodule