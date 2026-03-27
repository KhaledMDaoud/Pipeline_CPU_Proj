module topsys_tb;

    reg clk;
    reg reset;

    CPU uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin 
        $readmemh("test.hex",uut.FETCH.ins_mem.ins_mem);
    end

    initial begin 
    $dumpfile("topsys_tb.vcd");
    $dumpvars(0,topsys_tb);
    end

    integer i;
    initial begin
        clk = 1;
        reset = 1;

        $display("|Time\t|PC_IF\t|Instr_ID\t|ALU_Res_EXE\t|ALU_Res_MEM\t|WB_Data|");
        $display("--------------------------------------------------------------------------------");

        #1 reset = 0;
        #3 reset = 1;

        $monitor("|%0t\t|%h\t|%h\t|%h\t|%h\t|%h|", 
                 $time, 
                 uut.new_pc_wire_IF,    
                 uut.instruction_ID,      
                 uut.alu_result_EXE,       
                 uut.alu_result_MEM,       
                 uut.writeback_wire_RF     
        );

        #200;

        for(i=0;i<32;i=i+1) begin 
            $display("X%d = %h",i,uut.REGFILE.Reg_file[i]);
        end

        $display("--------------------------------------------------------------------------------");
        $display("Simulation finished.");
        $finish;
    end

endmodule