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
`include "./select_pc.v"
`include "./if.v"
`include "./id.v"
`include "./exe.v"
`include "./mem.v"
`include "./F_pipe_reg.v"
`include "./D_pipe_reg.v"
`include "./E_pipe_reg.v"
`include "./M_pipe_reg.v"
`include "./W_pipe_reg.v"
`include "./ctrl.v"

module tb;

    reg clk;
    reg rst;
    wire F_bubble;
    wire F_stall;
    wire D_bubble;
    wire D_stall;
    wire E_bubble;
    wire E_stall;
    wire M_bubble;
    wire M_stall;
    wire W_bubble;
    wire W_stall;
    wire[`PC_WIDTH - 1:0] pc;

/*********************************************************************************************************
*                                                     F reg
    * **************************************************************************************************/
    wire[`PC_WIDTH - 1:0] F_predPC;
/*********************************************************************************************************
*                                              fetch stage
    * **************************************************************************************************/
    wire[6:0] f_opcode;
    wire[`REG_WIDTH - 1:0] f_rd;
    wire[`REG_WIDTH - 1:0] f_rs1;
    wire[`REG_WIDTH - 1:0] f_rs2;
    wire[2:0] f_func3;
    wire[6:0] f_func7;
    wire[11:0] f_imm; // 立即数操作码从立即数中获得
    wire[`CPU_WIDTH - 1:0] f_valC;
    wire[`PC_WIDTH - 1:0] f_predPC;
    wire[`PC_WIDTH - 1:0] f_delayPC;
/*********************************************************************************************************
*                                                 D reg
    * **************************************************************************************************/
    wire[6:0] D_opcode;
    wire[`REG_WIDTH - 1:0] D_rd;
    wire[`REG_WIDTH - 1:0] D_rs1;
    wire[`REG_WIDTH - 1:0] D_rs2;
    wire[2:0] D_func3;
    wire[6:0] D_func7;
    wire[11:0] D_imm;
    wire[`PC_WIDTH - 1:0] D_pc;
    wire[`CPU_WIDTH - 1:0] D_valC;
    wire[`PC_WIDTH - 1:0]  D_delayPC;
/*********************************************************************************************************
*                                                 decode stage
    * **************************************************************************************************/
    wire[`CPU_WIDTH - 1:0] d_valA;
    wire[`CPU_WIDTH - 1:0] d_valB;
    wire[`REG_WIDTH - 1:0] d_dstE;
    wire[`REG_WIDTH - 1:0] d_dstM;
/*********************************************************************************************************
*                                                     E reg
    * **************************************************************************************************/
    wire[6:0] E_opcode;
    wire[2:0] E_func3;
    wire[6:0] E_func7;
    wire[11:0] E_imm;
    wire[`PC_WIDTH - 1:0] E_pc;
    wire[`CPU_WIDTH - 1:0] E_valA;
    wire[`CPU_WIDTH - 1:0] E_valB;
    wire[`REG_WIDTH - 1:0] E_dstE;
    wire[`REG_WIDTH - 1:0] E_dstM;
    wire[`CPU_WIDTH - 1:0] E_valC;
    wire[`REG_WIDTH - 1:0] E_rd;
    wire[`PC_WIDTH - 1:0]  E_delayPC;
/*********************************************************************************************************
*                                                 execute stage
    * **************************************************************************************************/
    wire[`CPU_WIDTH - 1: 0] e_valE;
    wire e_cnd; // pc 跳转条件码
    wire[`PC_WIDTH - 1:0] e_jumpPC;
/*********************************************************************************************************
*                                                     M reg
    * **************************************************************************************************/
    wire[6:0] M_opcode;
    wire[2:0] M_func3;
    wire[`CPU_WIDTH - 1:0] M_valE;
    wire[`CPU_WIDTH - 1:0] M_valB;
    wire M_cnd;
    wire[`REG_WIDTH - 1:0] M_rd;
    wire[`REG_WIDTH - 1:0] M_dstE;
    wire[`REG_WIDTH - 1:0] M_dstM;
/*********************************************************************************************************
*                                                 memory stage
    * **************************************************************************************************/
    wire[`CPU_WIDTH - 1:0] m_valM;
/*********************************************************************************************************
*                                                     W reg
    * **************************************************************************************************/
    wire[6:0] W_opcode;
    wire[`CPU_WIDTH - 1:0] W_valE;
    wire W_cnd;
    wire[`CPU_WIDTH - 1:0] W_valM;
    wire[`REG_WIDTH - 1:0] W_rd;
    wire[`REG_WIDTH - 1:0] W_dstE;
    wire[`REG_WIDTH - 1:0] W_dstM;

    F_pipe_reg Freg (
        .clk_i(clk),
		.rst_i(rst),
		.F_bubble_i(F_bubble),
		.F_stall_i(F_stall),
		.f_predPC_i(f_predPC),
		.F_predPC_o(F_predPC)
    );

    select_pc sel_pc (
       	.clk_i(clk),
		.f_predPC_i(f_predPC),
        .F_predPC_i(F_predPC),
		.E_opcode_i(E_opcode),
		.e_cnd_i(e_cnd),
		.E_delayPC_i(E_delayPC),
		.e_jumpPC_i(e_jumpPC),
		.pc_o(pc)
    );

    fetch fetch_stage (
        .pc_i(pc),

        .f_opcode_o(f_opcode),
        .f_rd_o(f_rd),
        .f_rs1_o(f_rs1),
        .f_rs2_o(f_rs2),
        .f_func3_o(f_func3),
        .f_func7_o(f_func7),
        .f_imm_o(f_imm),
        .f_valC_o(f_valC),
        .f_predPC_o(f_predPC),
        .f_delayPC_o(f_delayPC)
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
        .f_imm_i(f_imm),
        .f_pc_i(pc),
        .f_valC_i(f_valC),
        .f_delayPC_i(f_delayPC),

        .D_opcode_o(D_opcode),
        .D_rd_o(D_rd),
        .D_rs1_o(D_rs1),
        .D_rs2_o(D_rs2),
        .D_func3_o(D_func3),
        .D_func7_o(D_func7),
        .D_imm_o(D_imm),
        .D_pc_o(D_pc),
        .D_valC_o(D_valC),
        .D_delayPC_o(D_delayPC)
    );

    decode decode_stage (
        .clk_i(clk),
		.D_opcode_i(D_opcode),
		.D_rs1_i(D_rs1),
		.D_rs2_i(D_rs2),
		.D_rd_i(D_rd),
        // .D_pc_i(D_pc),

		.E_dstE_i(E_dstE),
		.e_valE_i(e_valE),
		.M_dstM_i(M_dstM),
		.m_valM_i(m_valM),
		.M_dstE_i(M_dstE),
		.M_valE_i(M_valE),
		.W_dstE_i(W_dstE),
		.W_valE_i(W_valE),
		.W_dstM_i(W_dstM),
		.W_valM_i(W_valM),

		.d_valA_o(d_valA),
		.d_valB_o(d_valB),
		.d_dstE_o(d_dstE),
		.d_dstM_o(d_dstM)
    );

    E_pipe_reg Ereg(
        .clk_i(clk),
        .rst_i(rst),
        .E_bubble_i(E_bubble),
        .E_stall_i(E_stall),

        .D_opcode_i(D_opcode),
        .D_func3_i(D_func3),
        .D_func7_i(D_func7),
        .D_imm_i(D_imm),
        .D_pc_i(D_pc),
        .d_valA_i(d_valA),
        .d_valB_i(d_valB),
        .d_dstE_i(d_dstE),
        .d_dstM_i(d_dstM),
        .D_valC_i(D_valC),
        .D_rd_i(D_rd),
        .D_delayPC_i(D_delayPC),

        .E_opcode_o(E_opcode),
        .E_func3_o(E_func3),
        .E_func7_o(E_func7),
        .E_imm_o(E_imm),
        .E_pc_o(E_pc),
        .E_valA_o(E_valA),
        .E_valB_o(E_valB),
        .E_dstE_o(E_dstE),
        .E_dstM_o(E_dstM),
        .E_valC_o(E_valC),
        .E_rd_o(E_rd),
        .E_delayPC_o(E_delayPC)
    );

    execute execute_stage (
        .E_opcode_i(E_opcode),
        .E_func3_i(E_func3),
        .E_func7_i(E_func7),
        .E_imm_i(E_imm), 
        .E_valA_i(E_valA),
        .E_valB_i(E_valB),
        .E_valC_i(E_valC),
        .E_pc_i(E_pc),

        .e_valE_o(e_valE),
        .e_cnd_o(e_cnd),
        .e_jumpPC_o(e_jumpPC)
    );

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
        .E_dstE_i(E_dstE),
        .E_dstM_i(E_dstM),

		.M_opcode_o(M_opcode),
		.M_func3_o(M_func3),
		.M_valE_o(M_valE),
		.M_valB_o(M_valB),
		.M_cnd_o(M_cnd),
		.M_rd_o(M_rd),
        .M_dstE_o(M_dstE),
        .M_dstM_o(M_dstM)
    );

    memory_access memory_stage (
        .clk_i(clk),
        .M_opcode_i(M_opcode),
        .M_func3_i(M_func3),
        .M_valE_i(M_valE),
        .M_valB_i(M_valB),
        .m_valM_o(m_valM)
    );

    W_pipe_reg Wreg (
        .clk_i(clk),
		.rst_i(rst),
		.W_bubble_i(W_bubble),
		.W_stall_i(W_stall),

		.M_opcode_i(M_opcode),
		.M_valE_i(M_valE),
		.M_cnd_i(M_cnd),
		.m_valM_i(m_valM),
		.M_rd_i(M_rd),
		.M_dstE_i(M_dstE),
		.M_dstM_i(M_dstM),

		.W_opcode_o(W_opcode),
		.W_valE_o(W_valE),
		.W_cnd_o(W_cnd),
		.W_valM_o(W_valM),
		.W_rd_o(W_rd),
		.W_dstE_o(W_dstE),
		.W_dstM_o(W_dstM)
    );

    ctrl ctrl_ins (
        .E_opcode_i(E_opcode),
        .e_cnd_i(e_cnd),
        
        .F_bubble_o(F_bubble),
        .F_stall_o(F_stall),
        .D_bubble_o(D_bubble),
        .D_stall_o(D_stall),
        .E_bubble_o(E_bubble),
        .E_stall_o(E_stall),
        .M_bubble_o(M_bubble),
        .M_stall_o(M_stall),
        .W_bubble_o(W_bubble),
        .W_stall_o(W_stall) 
    );

    initial begin
        clk = 0;
        #1000 $finish;
    end
    initial begin
        rst = 1;
        // rst = 1;
        // pc = 0;
        #19 rst = 0;
        // #10 pc = 4;
        // #10 pc = 8;
        // #10 pc = 12;
        // #10 pc = 16;
        // #10 pc = 20;
    end

    always #(3) begin
        clk = ~clk;
    end

	initial begin
    	$dumpfile("wave.vcd");        
    	$dumpvars;    
	end

endmodule
