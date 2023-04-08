`include "./define.v"

module E_pipe_reg (
    input wire clk_i,
    input wire rst_i,

    input wire E_bubble_i,
    input wire E_stall_i,

    input wire[6:0] D_opcode_i,
    input wire[2:0] D_func3_i,
    input wire[6:0] D_func7_i,
    input wire[11:0] D_imm_i,
    input wire[`PC_WIDTH - 1:0] D_pc_i,
    input wire[`CPU_WIDTH - 1:0] d_valA_i,
    input wire[`CPU_WIDTH - 1:0] d_valB_i,
    input wire[`REG_WIDTH - 1:0] d_dstE_i,
    input wire[`REG_WIDTH - 1:0] d_dstM_i,
    input wire[`CPU_WIDTH - 1:0] D_valC_i,
    input wire[`REG_WIDTH - 1:0] D_rd_i,
    input wire[`PC_WIDTH - 1:0]  D_delayPC_i,

    output reg[6:0] E_opcode_o,
    output reg[2:0] E_func3_o,
    output reg[6:0] E_func7_o,
    output reg[11:0] E_imm_o,
    output reg[`PC_WIDTH - 1:0] E_pc_o,
    output reg[`CPU_WIDTH - 1:0] E_valA_o,
    output reg[`CPU_WIDTH - 1:0] E_valB_o,
    output reg[`REG_WIDTH - 1:0] E_dstE_o,
    output reg[`REG_WIDTH - 1:0] E_dstM_o,
    output reg[`CPU_WIDTH - 1:0] E_valC_o,
    output reg[`REG_WIDTH - 1:0] E_rd_o,
    output reg[`PC_WIDTH - 1:0]  E_delayPC_o
);

    always @(posedge clk_i, rst_i) begin
        if(E_bubble_i || rst_i) begin
            E_opcode_o    <= 7'h0;
            E_func3_o     <= 3'h0;
            E_func7_o     <= 7'h0;
            E_imm_o       <= 12'h0;
            E_pc_o        <= `PC_WIDTH'h0;
            E_valA_o      <= `CPU_WIDTH'h0;
            E_valB_o      <= `CPU_WIDTH'h0;
            E_dstE_o      <= `RNONE;
            E_dstM_o      <= `RNONE;
            E_valC_o      <= `CPU_WIDTH'h0;
            E_rd_o        <= `RNONE;
            E_delayPC_o   <= `PC_WIDTH'h0;
        end
        else if(~E_stall_i) begin
            E_opcode_o    <= D_opcode_i;
            E_func3_o     <= D_func3_i;
            E_func7_o     <= D_func7_i;
            E_imm_o       <= D_imm_i;
            E_pc_o        <= D_pc_i;
            E_valA_o      <= d_valA_i;
            E_valB_o      <= d_valB_i;
            E_dstE_o      <= d_dstE_i;
            E_dstM_o      <= d_dstM_i;
            E_valC_o      <= D_valC_i;
            E_rd_o        <= D_rd_i;
            E_delayPC_o   <= D_delayPC_i;
        end
    end

endmodule