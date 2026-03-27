module tb_WB;

reg clk, reset;
reg memToReg_wire, regWrite_wire;
reg [4:0] rd_wire;
reg [31:0] alu_result_wire, mem_result_wire;

wire [31:0] writeback_wire;

WB TEMP(
    .clk(clk),
    .reset(reset),
    .alu_result_wire(alu_result_wire),
    .mem_result_wire(mem_result_wire),
    .memToReg_wire(memToReg_wire),
    .regWrite_wire(regWrite_wire),
    .rd_wire(rd_wire),
    .writeback_wire(writeback_wire)
);

parameter CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk = ~clk;

initial begin
    $monitor("Time %0t | rd: %d | m2r: %b | rW: %b | ALU: %d | MEM: %d | WB: %d",
             $time, rd_wire, memToReg_wire, regWrite_wire,
             alu_result_wire, mem_result_wire, writeback_wire);

    clk = 1;
    reset = 0;
    memToReg_wire = 0;
    regWrite_wire = 0;
    rd_wire = 0;
    alu_result_wire = 0;
    mem_result_wire = 0;

    #5 reset = 1;

    #10 rd_wire <= 5; regWrite_wire <= 1;
        alu_result_wire <= 32'd101; mem_result_wire <= 32'd202; memToReg_wire <= 0;

    #10 memToReg_wire <= 1;

    #10 rd_wire <= 10; alu_result_wire <= 32'd55; mem_result_wire <= 32'd777;

    #10 $display("Simulation Finished.");
    $finish(2);
end

endmodule