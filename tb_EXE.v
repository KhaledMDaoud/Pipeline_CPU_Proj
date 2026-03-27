module tb_EXE;

reg clk, reset;
reg aluSrc_wire, branch_wire;
reg [3:0] aluOp_wire;
reg [31:0] read_data1_wire;
reg [31:0] read_data2_wire;
reg [31:0] immediate_wire;
reg [15:0] new_pc_wire;

wire [31:0] alu_result_wire;
wire [15:0] br_mux_res_wire;

EXE TEMP(
    .clk(clk),
    .reset(reset),
    .read_data1_wire(read_data1_wire),
    .read_data2_wire(read_data2_wire),
    .immediate_wire(immediate_wire),
    .aluSrc_wire(aluSrc_wire),
    .aluOp_wire(aluOp_wire),
    .branch_wire(branch_wire),
    .new_pc_wire(new_pc_wire),
    .alu_result_wire(alu_result_wire),
    .br_mux_res_wire(br_mux_res_wire)
);

parameter CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk = ~clk;

initial begin
    $monitor("Time %0t | A: %d | B: %d | IMM: %d | op: %b | Src: %b | br: %b | res: %d | br_res: %d",
        $time, read_data1_wire, read_data2_wire, immediate_wire,
        aluOp_wire, aluSrc_wire, branch_wire, alu_result_wire, br_mux_res_wire);

    clk = 1;
    reset = 0;
    aluSrc_wire = 0;
    branch_wire = 0;
    aluOp_wire = 0;
    read_data1_wire = 0;
    read_data2_wire = 0;
    immediate_wire = 0;
    new_pc_wire = 0;

    #5 reset = 1;

    #10 read_data1_wire <= 20; read_data2_wire <= 5; immediate_wire <= 100;
        aluOp_wire <= 4'b0000; aluSrc_wire <= 0; new_pc_wire <= 16'd200;

    #10 aluSrc_wire <= 1;

    #10 branch_wire <= 1; immediate_wire <= 32'd4;

    #10 $display("Simulation Finished.");
    $finish(2);
end

endmodule