`timescale 1ns / 1ps
`include "./define.v"
`include "./if.v"
`include "./id.v"
`include "./exe.v"
`include "./mem.v"
// `include "./IF.v"
`include "./ID.v"
// `include "./EXE.v"
// `include "./MEM.v"

module testbench;

    reg clk;
    reg rst;
    wire[9: 0] pc;

/*********************************************************************************************************
*                                              fetch stage
    * **************************************************************************************************/
    wire[6: 0] opcode;
    wire[4: 0] rd;
    wire[2: 0] func3;
    wire[4: 0] rs1;
    wire[4: 0] rs2;
    wire[6: 0] func7;
    wire[6: 0] func7_imm; // 立即数操作码从立即数中获得
    wire[`CPU_WIDTH - 1: 0] valC;

    wire[`CPU_WIDTH - 1: 0] valA;
    wire[`CPU_WIDTH - 1: 0] valB;

    wire[`CPU_WIDTH - 1: 0] valE;
    wire cnd; // pc 跳转条件码

    wire[`CPU_WIDTH - 1: 0] valM;

    fetch fetch_stage (
        .pc_i(pc),

        .opcode_o(opcode),
        .rd_o(rd),
        .func3_o(func3),
        .rs1_o(rs1),
        .rs2_o(rs2),
        .func7_o(func7),
        .func7_imm_o(func7_imm),
        .valC_o(valC)
    );

    D_pipe_reg Dreg(
        .clk_i(clk),
        .rst_i(rst),
        .D_bubble_i(D_bubble),
        .D_stall_i(D_stall),
        .f_opcode_i(f_opcode),
        .f_rd_i(f_rd),
        .f_rs1_i(f_rs1),
        .f_rs2_i(f_rs2),
        .f_func3_i(f_func3),
        .f_func7_i(f_func7),
        .f_func3_imm_i(f_func3_imm),
        .f_valC_i(f_valC),

        .D_opcode_o(D_opcode),
        .D_rd_o(D_rd),
        .D_rs1_o(D_rs1),
        .D_rs2_o(D_rs2),
        .D_func3_o(D_func3),
        .D_func7_o(D_func7),
        .D_func3_imm_o(D_func3_imm),
        .D_valC_o(D_valC)
    );

    decode decode_stage (
        .clk_i(clk),
        .pc_o(pc),
        .opcode_i(opcode),
        // .func3_i(func3),
        // .func7_i(func7),
        .rs1_i(rs1),
        .rs2_i(rs2),
        .rd_i(rd),
        .valE_i(valE),
        .valM_i(valM),
        .cnd_i(cnd),

        .valA_o(valA),
        .valB_o(valB)
    );

    execute execute_stage (
        .opcode_i(opcode),
        .func3_i(func3),
        .func7_i(func7),
        .func7_imm_i(func7_imm), 
        .valA_i(valA),
        .valB_i(valB),
        .valC_i(valC),

        .valE_o(valE),
        .cnd_o(cnd)
    );

    memory_access memory_stage (
        .clk_i(clk),
        .opcode_i(opcode),
        .func3_i(func3),
        .valE_i(valE),
        .valB_i(valB),
        .valM_o(valM)
    );

    initial begin
        clk = 0;
        #1000 $finish;
    end

    always #(3) clk = ~clk;

	initial begin
    	$dumpfile("wave.vcd");        
    	$dumpvars;    
	end

endmodule
