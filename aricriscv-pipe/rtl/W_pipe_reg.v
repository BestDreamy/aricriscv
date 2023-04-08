`include "./define.v"

module W_pipe_reg (
    input wire clk_i,
    input wire rst_i,
    
    input wire W_bubble_i,
    input wire W_stall_i,

    input wire[6:0] M_opcode_i,
    input wire[`CPU_WIDTH - 1:0] M_valE_i,
    input wire M_cnd_i,
    input wire[`CPU_WIDTH - 1:0] m_valM_i,
    input wire[`REG_WIDTH - 1:0] M_rd_i,
    input wire[`REG_WIDTH - 1:0] M_dstE_i,
    input wire[`REG_WIDTH - 1:0] M_dstM_i,

    output reg[6:0] W_opcode_o,
    output reg[`CPU_WIDTH - 1:0] W_valE_o,
    output reg W_cnd_o,
    output reg[`CPU_WIDTH - 1:0] W_valM_o,
    output reg[`REG_WIDTH - 1:0] W_rd_o,
    output reg[`REG_WIDTH - 1:0] W_dstE_o,
    output reg[`REG_WIDTH - 1:0] W_dstM_o
);

    always @(posedge clk_i, rst_i) begin
        if(W_bubble_i || rst_i) begin
            W_opcode_o <= 7'h0;
            W_valE_o   <= `CPU_WIDTH'h0;
            W_cnd_o    <= 1'h0;
            W_valM_o   <= `CPU_WIDTH'h0;
            W_rd_o     <= `RNONE;
            W_dstE_o   <= `RNONE;
            W_dstM_o   <= `RNONE;
        end
        else if(~W_stall_i) begin
            W_opcode_o <= M_opcode_i;
            W_valE_o   <= M_valE_i;
            W_cnd_o    <= M_cnd_i;
            W_valM_o   <= m_valM_i;
            W_rd_o     <= M_rd_i;
            W_dstE_o   <= M_dstE_i;
            W_dstM_o   <= M_dstM_i;
        end
    end
endmodule