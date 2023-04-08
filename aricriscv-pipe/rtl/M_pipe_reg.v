`include "./define.v"

module M_pipe_reg (
    input wire clk_i,
    input wire rst_i,

    input wire M_bubble_i,
    input wire M_stall_i,

    input wire[6:0] E_opcode_i,
    input wire[2:0] E_func3_i,
    input wire[`CPU_WIDTH - 1:0] e_valE_i,
    input wire[`CPU_WIDTH - 1:0] E_valB_i,
    input wire e_cnd_i,
    input wire[`REG_WIDTH - 1:0] E_rd_i,
    input wire[`REG_WIDTH - 1:0] E_dstE_i,
    input wire[`REG_WIDTH - 1:0] E_dstM_i,

    output reg[6:0] M_opcode_o,
    output reg[2:0] M_func3_o,
    output reg[`CPU_WIDTH - 1:0] M_valE_o,
    output reg[`CPU_WIDTH - 1:0] M_valB_o,
    output reg M_cnd_o,
    output reg[`REG_WIDTH - 1:0] M_rd_o,
    output reg[`REG_WIDTH - 1:0] M_dstE_o,
    output reg[`REG_WIDTH - 1:0] M_dstM_o
);

    always @(posedge clk_i, rst_i) begin
        if(M_bubble_i || rst_i) begin
            M_opcode_o <= 7'h0;
            M_func3_o  <= 3'h0;
            M_valE_o   <= `CPU_WIDTH'h0;
            M_valB_o   <= `CPU_WIDTH'h0;
            M_cnd_o    <= 1'h0;
            M_rd_o     <= `RNONE;
            M_dstE_o   <= `RNONE; 
            M_dstM_o   <= `RNONE; 
        end    
        else if(~M_stall_i) begin
            M_opcode_o <= E_opcode_i;
            M_func3_o  <= E_func3_i;
            M_valE_o   <= e_valE_i;
            M_valB_o   <= E_valB_i;
            M_cnd_o    <= e_cnd_i;
            M_rd_o     <= E_rd_i; 
            M_dstE_o   <= E_dstE_i; 
            M_dstM_o   <= E_dstM_i; 
        end
    end

endmodule