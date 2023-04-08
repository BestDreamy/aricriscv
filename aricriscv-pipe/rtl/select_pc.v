`include "./define.v"

module select_pc (
    input wire clk_i,
    input wire[`PC_WIDTH - 1:0] f_predPC_i,
    input wire[`PC_WIDTH - 1:0] F_predPC_i,
    // input wire[6:0] f_opcode_i,
    input wire[6:0] E_opcode_i,
    input wire e_cnd_i,
    input wire[`PC_WIDTH - 1:0] E_delayPC_i, // pc + 4
    input wire[`PC_WIDTH - 1:0] e_jumpPC_i,

    output reg[`PC_WIDTH - 1:0] pc_o
);

// 1. 普通指令, jal指令 (f)
// npc = predPC
// 2. branch 指令 (e)
// npc = cnd? predPC: pc + 4
// 3. jalr 指令 (e)
// npc = jumpPC
/*
    // 优先选择器
    always @(posedge clk_i) begin
        if(E_opcode_i == `IB && !e_cnd_i) 
            pc_o <= E_delayPC_i;
        else if(E_opcode_i == `IJALR) 
            pc_o <= e_jumpPC_i;
        else 
            pc_o <= f_predPC_i;
    end
*/
    always @(*) begin
        if(E_opcode_i == `IB && !e_cnd_i) 
            pc_o = E_delayPC_i;
        else if(E_opcode_i == `IJALR) 
            pc_o = e_jumpPC_i;
        else 
            pc_o = F_predPC_i;
    end
    initial begin
        pc_o <= 0;
    end

endmodule