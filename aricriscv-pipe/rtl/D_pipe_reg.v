`include "./define.v"

module D_pipe_reg (
    input wire clk_i,
    input wire rst_i,

    input wire D_bubble_i,
    input wire D_stall_i,
    
    input wire[6:0] f_opcode_i,
    input wire[`REG_WIDTH - 1:0] f_rd_i,
    input wire[`REG_WIDTH - 1:0] f_rs1_i,
    input wire[`REG_WIDTH - 1:0] f_rs2_i,
    input wire[2:0] f_func3_i,
    input wire[6:0] f_func7_i,
    input wire[11:0] f_imm_i,
    input wire[`PC_WIDTH - 1:0] f_pc_i,
    input wire[`CPU_WIDTH - 1:0] f_valC_i,
    input wire[`PC_WIDTH - 1:0] f_delayPC_i,

    output reg[6:0] D_opcode_o,
    output reg[`REG_WIDTH - 1:0] D_rd_o,
    output reg[`REG_WIDTH - 1:0] D_rs1_o,
    output reg[`REG_WIDTH - 1:0] D_rs2_o,
    output reg[2:0] D_func3_o,
    output reg[6:0] D_func7_o,
    output reg[11:0] D_imm_o,
    output reg[`PC_WIDTH - 1:0] D_pc_o,
    output reg[`CPU_WIDTH - 1:0] D_valC_o,
    output reg[`PC_WIDTH - 1:0] D_delayPC_o
);

    always @(posedge clk_i, rst_i) begin
        if(D_bubble_i || rst_i) begin
            D_opcode_o    <= 7'h0;
            D_rd_o        <= `RNONE;
            D_rs1_o       <= `RNONE;
            D_rs2_o       <= `RNONE;
            D_func3_o     <= 3'h0;
            D_func7_o     <= 7'h0;
            D_imm_o       <= 12'h0;
            D_pc_o        <= `PC_WIDTH'h0;
            D_valC_o      <= `CPU_WIDTH'h0;
            D_delayPC_o   <= `PC_WIDTH'h0;
        end
        else if(~D_stall_i) begin
            D_opcode_o    <= f_opcode_i;
            D_rd_o        <= f_rd_i;
            D_rs1_o       <= f_rs1_i;
            D_rs2_o       <= f_rs2_i;
            D_func3_o     <= f_func3_i;
            D_func7_o     <= f_func7_i;
            D_imm_o       <= f_imm_i;
            D_pc_o        <= f_pc_i;
            D_valC_o      <= f_valC_i;
            D_delayPC_o   <= f_delayPC_i;
        end
    end
endmodule