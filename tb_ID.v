module tb_ID;

reg clk, reset;
reg [31:0] instruction_wire;

wire [31:0] Read_data1_wire;
wire [31:0] Read_data2_wire;
wire [31:0] immediate_wire;

ID TEMP(
    .clk(clk),
    .reset(reset),
    .instruction_wire(instruction_wire),
    .Read_data1_wire(Read_data1_wire),
    .Read_data2_wire(Read_data2_wire),
    .immediate_wire(immediate_wire)
);

parameter CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk = ~clk;

initial begin
    $monitor("Time %0t | instr: %h | RD1: %d | RD2: %d | imm: %d",
             $time, instruction_wire, Read_data1_wire, Read_data2_wire, immediate_wire);

    clk = 1;
    reset = 0;
    instruction_wire = 0;

    #5 reset = 1;

    #10 instruction_wire <= 32'h00C58533; // R-type
    #10 instruction_wire <= 32'h00560613; // I-type
    #10 instruction_wire <= 32'h00A62023; // S-type
    #10 instruction_wire <= 32'h000002B7; // U-type
    #10 instruction_wire <= 32'h004000EF; // UJ-type

    #10 $display("Simulation Finished.");
    $finish(2);
end

endmodule