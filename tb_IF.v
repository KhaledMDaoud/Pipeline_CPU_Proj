module tb_IF;
    reg clk;
    reg reset;
    wire [31:0] instruction;

IF fetch(
    .reset(reset),
    .clk(clk),
    .instruction_wire(instruction)
);

parameter CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk = ~clk;

initial begin 
    $dumpfile("tb_IF.vcd");
    $dumpvars(0,tb_IF);
end

initial begin 
    $readmemh("test.hex",fetch.ins_mem.ins_mem);
end

initial begin
    $monitor("Time: %0t | PC Address: %h | Instruction: %h",$time,fetch.new_pc_wire,instruction);

    clk=1;
    reset=1;

    #1 reset = 0;
    #3 reset = 1;

    #30;
    $finish;
end

endmodule