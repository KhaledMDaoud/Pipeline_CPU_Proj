module PC(
    clk,
    reset,
    br_mux_res_wire,
    branch_taken,
    new_pc_wire
);

input wire clk,reset;
input wire [15:0] br_mux_res_wire;
input wire branch_taken;

output wire [15:0] new_pc_wire;

reg [15:0] new_pc_reg;

assign new_pc_wire = new_pc_reg;

always @(posedge clk or negedge reset) begin
    if(~reset) begin 
        new_pc_reg <= 16'd0;
    end
    else if(branch_taken) begin 
        new_pc_reg <= br_mux_res_wire;
    end
    else begin 
        new_pc_reg <= new_pc_reg + 16'd4;
    end
end

endmodule

module IM(
    clk,
    reset,
    new_pc_wire,
    instruction_wire
);

input wire clk,reset;
input wire [15:0] new_pc_wire;

output wire [31:0] instruction_wire;
reg [31:0] instruction_reg;

reg [7:0] ins_mem [0:2**16-1];

assign instruction_wire = instruction_reg;

always @(negedge clk or negedge reset) begin 
    if(~reset) begin 
        instruction_reg <= 32'b0;
    end
    else begin
        instruction_reg [7:0] <= ins_mem[new_pc_wire+3];
        instruction_reg [15:8] <= ins_mem[new_pc_wire+2];
        instruction_reg [23:16] <= ins_mem[new_pc_wire+1];
        instruction_reg [31:24] <= ins_mem[new_pc_wire];
    end
end

endmodule

module IF(
    clk,
    reset,
    br_mux_res_wire,
    branch_taken,
    new_pc_wire,
    instruction_wire
);

input wire clk,reset;
input wire branch_taken;
input wire [15:0] br_mux_res_wire;

output wire [15:0] new_pc_wire;
output wire [31:0] instruction_wire;

PC program_counter(clk,reset,br_mux_res_wire,branch_taken,new_pc_wire);

IM ins_mem(clk,reset,new_pc_wire,instruction_wire);

endmodule