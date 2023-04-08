// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2023 
//                 ALL RIGHTS aric's RISC-V
// ---------------------------------------------------------------------------------
// Filename      : topcpu.v
// Author        : aric
// Created On    : 2023-03-26 02:09
// Last Modified : 2023-03-26 02:41
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
`timescale 1ns / 1ps
`include "./define.v"
`include "./if.v"
`include "./id.v"
`include "./exe.v"
// `include "./mem.v"
// `include "./IF.v"
`include "./D_pipe_reg.v"
`include "./E_pipe_reg.v"
`include "./M_pipe_reg.v"

module testbench;

    reg clk;
    reg rst;
    reg D_bubble;
    reg D_stall;
    reg E_bubble;
    reg E_stall;
    reg M_bubble;
    reg M_stall;
    wire[9:0] pc;

/*********************************************************************************************************
*                                              fetch stage
    * **************************************************************************************************/
    wire[6:0] f_opcode;
    wire[`REG_WIDTH - 1:0] f_rd;
    wire[`REG_WIDTH - 1:0] f_rs1;
    wire[`REG_WIDTH - 1:0] f_rs2;
    wire[2:0] f_func3;
    wire[6:0] f_func7;
    wire[6:0] f_func7_imm; // 立即数操作码从立即数中获得
    wire[`CPU_WIDTH - 1:0] f_valC;

    fetch fetch_stage (
        .pc_i(pc),

        .opcode_o(f_opcode),
        .rd_o(f_rd),
        .rs1_o(f_rs1),
        .rs2_o(f_rs2),
        .func3_o(f_func3),
        .func7_o(f_func7),
        .func7_imm_o(f_func7_imm),
        .valC_o(f_valC)
    );
/*********************************************************************************************************
*                                                 D reg
    * **************************************************************************************************/
    wire[6:0] D_opcode;
    wire[`REG_WIDTH - 1:0] D_rd;
    wire[`REG_WIDTH - 1:0] D_rs1;
    wire[`REG_WIDTH - 1:0] D_rs2;
    wire[2:0] D_func3;
    wire[6:0] D_func7;
    wire[6:0] D_func7_imm;
    wire[`CPU_WIDTH - 1:0] D_valC;

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
        .f_func7_imm_i(f_func7_imm),
        .f_valC_i(f_valC),

        .D_opcode_o(D_opcode),
        .D_rd_o(D_rd),
        .D_rs1_o(D_rs1),
        .D_rs2_o(D_rs2),
        .D_func3_o(D_func3),
        .D_func7_o(D_func7),
        .D_func7_imm_o(D_func7_imm),
        .D_valC_o(D_valC)
    );
/*********************************************************************************************************
*                                                 decode stage
    * **************************************************************************************************/
    wire[6:0] d_opcode;
    wire[`REG_WIDTH - 1:0] d_rs1;
    wire[`REG_WIDTH - 1:0] d_rs2;
    wire[`REG_WIDTH - 1:0] d_rd;
    wire[`CPU_WIDTH - 1:0] d_valC;
    wire[`CPU_WIDTH - 1:0] d_valE;
    wire[`CPU_WIDTH - 1:0] d_valM;
    wire d_cnd;
    wire[`CPU_WIDTH - 1:0] d_valA;
    wire[`CPU_WIDTH - 1:0] d_valB;

    decode decode_stage (
        .clk_i(clk),
        .pc_o(pc),
        .opcode_i(D_opcode),
        .rs1_i(D_rs1),
        .rs2_i(D_rs2),
        .rd_i(D_rd),
        // .valE_i(D_valE),
        // .valM_i(d_valM),
        // .cnd_i(d_cnd),

        .valA_o(d_valA),
        .valB_o(d_valB)
    );
/*********************************************************************************************************
*                                                     E reg
    * **************************************************************************************************/
    wire[6:0] E_opcode;
    wire[2:0] E_func3;
    wire[6:0] E_func7;
    wire[6:0] E_func7_imm;
    wire[`CPU_WIDTH - 1:0] E_valA;
    wire[`CPU_WIDTH - 1:0] E_valB;
    wire[`CPU_WIDTH - 1:0] E_valC;
    wire[`REG_WIDTH - 1:0] E_rd;

    E_pipe_reg Ereg(
        .clk_i(clk),
        .rst_i(rst),
        .E_bubble_i(E_bubble),
        .E_stall_i(E_stall),

        .D_opcode_i(D_opcode),
        .D_func3_i(D_func3),
        .D_func7_i(D_func7),
        .D_func7_imm_i(D_func7_imm),
        .d_valA_i(d_valA),
        .d_valB_i(d_valB),
        .D_valC_i(D_valC),
        .D_rd_i(D_rd),
        .E_opcode_o(E_opcode),
        .E_func3_o(E_func3),
        .E_func7_o(E_func7),
        .E_func7_imm_o(E_func7_imm),
        .E_valA_o(E_valA),
        .E_valB_o(E_valB),
        .E_valC_o(E_valC),
        .E_rd_o(E_rd)
    );
/*********************************************************************************************************
*                                                 execute stage
    * **************************************************************************************************/
    wire[6:0] e_opcode;
    wire[2:0] e_func3;
    wire[6:0] e_func7;
    wire[6:0] e_func7_imm;
    wire[`CPU_WIDTH - 1: 0] e_valA;
    wire[`CPU_WIDTH - 1: 0] e_valB;
    wire[`CPU_WIDTH - 1: 0] e_valC;
    wire[`CPU_WIDTH - 1: 0] e_valE;
    wire e_cnd; // pc 跳转条件码

    execute execute_stage (
        .opcode_i(E_opcode),
        .func3_i(E_func3),
        .func7_i(E_func7),
        .func7_imm_i(E_func7_imm), 
        .valA_i(E_valA),
        .valB_i(E_valB),
        .valC_i(E_valC),

        .valE_o(e_valE),
        .cnd_o(e_cnd)
    );
/*********************************************************************************************************
*                                                     M reg
    * **************************************************************************************************/
    wire[6:0] M_opcode;
    wire[2:0] M_func3;
    wire[`CPU_WIDTH - 1:0] M_valE;
    wire[`CPU_WIDTH - 1:0] M_valB;
    wire M_cnd;
    wire[`REG_WIDTH - 1:0] M_rd;

    M_pipe_reg Mreg(
        .clk_i(clk),
		.rst_i(rst),
		.M_bubble_i(M_bubble),
		.M_stall_i(M_stall),

		.E_opcode_i(E_opcode),
		.E_func3_i(E_func3),
		.e_valE_i(e_valE),
		.E_valB_i(E_valB),
		.e_cnd_i(e_cnd),
		.E_rd_i(E_rd),
		.M_opcode_o(M_opcode),
		.M_func3_o(M_func3),
		.M_valE_o(M_valE),
		.M_valB_o(M_valB),
		.M_cnd_o(M_cnd),
		.M_rd_o(M_rd)
    );
/*********************************************************************************************************
*                                                 memory stage
    * **************************************************************************************************/
    wire[6:0] m_opcode;
    wire[2:0] m_func3;
    wire[`CPU_WIDTH - 1:0] m_valE;
    wire[`CPU_WIDTH - 1:0] m_valB;
    wire[`CPU_WIDTH - 1:0] m_valM;

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
        D_bubble = 0;
        D_stall = 0;
        E_bubble = 0;
        E_stall = 0;
        M_bubble = 0;
        M_stall = 0;
        #1000 $finish;
    end
    initial begin
        rst = 1;
        #15 rst = 0;
    end

    always #(3) clk = ~clk;

	initial begin
    	$dumpfile("wave.vcd");        
    	$dumpvars;    
	end

endmodule
