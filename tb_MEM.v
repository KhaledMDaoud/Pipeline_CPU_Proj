module tb_MEM;

reg clk, reset;
reg [31:0] alu_result_wire;
reg [31:0] write_data_wire;
reg [31:0] instruction_wire;
reg memRead_wire, memWrite_wire;

wire [31:0] mem_result_wire;

MEM TEMP(
    .clk(clk),
    .reset(reset),
    .alu_result_wire(alu_result_wire),
    .write_data_wire(write_data_wire),
    .memRead_wire(memRead_wire),
    .memWrite_wire(memWrite_wire),
    .instruction_wire(instruction_wire),
    .mem_result_wire(mem_result_wire)
);

parameter CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk = ~clk;

initial begin
    $monitor("Time %0t | ALU addr: %h | Write: %h | Read: %h",
             $time, alu_result_wire, write_data_wire, mem_result_wire);

    clk = 1;
    reset = 0;
    alu_result_wire = 0;
    write_data_wire = 0;
    instruction_wire = 0;
    memRead_wire = 0;
    memWrite_wire = 0;

    #5 reset = 1;

    // ---------------------
    // WRITE BYTE (Funct3 = 001)
    // ---------------------
    instruction_wire <= 32'h00000000;
    instruction_wire[14:12] = 3'b001;  // store byte

    alu_result_wire <= 32'h00000010;   // address = 0x10
    write_data_wire <= 32'h000000AA;   // write AA

    memWrite_wire <= 1;
    #10 memWrite_wire <= 0;

    // ---------------------
    // WRITE WORD (Funct3 = 011)
    // ---------------------
    instruction_wire[14:12] = 3'b011;  // store word

    alu_result_wire <= 32'h00000020;   // address = 0x20
    write_data_wire <= 32'h11223344;

    memWrite_wire <= 1;
    #10 memWrite_wire <= 0;

    // ---------------------
    // READ HALFWORD SIGNED (Funct3 = 100)
    // ---------------------
    instruction_wire[14:12] = 3'b100;

    alu_result_wire <= 32'h00000010;   // read from 0x10
    memRead_wire <= 1;
    #10 memRead_wire <= 0;

    // ---------------------
    // READ WORD (Funct3 = 011)
    // ---------------------
    instruction_wire[14:12] = 3'b011;

    alu_result_wire <= 32'h00000020;
    memRead_wire <= 1;
    #10 memRead_wire <= 0;

    #20;
    $display("Simulation Finished.");
    $finish(2);
end

endmodule