`include "./define.v"

module alu (
    input wire[8:0] op_info_i,
    input wire[9:0] alu_info_i,
    input wire[5:0] branch_info_i,
    input wire[11:0] E_imm_i,
    input wire[`PC_WIDTH - 1:0] E_pc_i,
    input wire[`CPU_WIDTH - 1:0] E_valA_i,
    input wire[`CPU_WIDTH - 1:0] E_valB_i,
    input wire[`CPU_WIDTH - 1:0] E_valC_i,

    output wire e_cnd_o,
    output wire[`CPU_WIDTH - 1:0] e_valE_o
);
    // 1. alu
    // rs1 op rs2
    // 2. alu_imm
    // rs1 op imm
    // 3. load
    // rs1 + imm
    // 4. store
    // rs1 + imm
    // 5. branch
    // rs1 op(比较) rs2
    // 6. jal jalr
    // pc + 4
    // 7.lui
    // imm << 12
    // 8.auipc
    // pc + (imm << 12)

    // opcode
    wire op_alu     = op_info_i[0];
    wire op_alu_imm = op_info_i[1];
    wire op_load    = op_info_i[2];
    wire op_store   = op_info_i[3];
    wire op_branch  = op_info_i[4];
    wire op_jal     = op_info_i[5];
    wire op_jalr    = op_info_i[6];
    wire op_lui     = op_info_i[7];
    wire op_auipc   = op_info_i[8];

    // alu select
    wire alu_sel_add  = alu_info_i[0];
    wire alu_sel_sub  = alu_info_i[1];
    wire alu_sel_xor  = alu_info_i[2];
    wire alu_sel_or   = alu_info_i[3];
    wire alu_sel_and  = alu_info_i[4];
    wire alu_sel_sll  = alu_info_i[5];
    wire alu_sel_srl  = alu_info_i[6];
    wire alu_sel_sra  = alu_info_i[7];
    wire alu_sel_slt  = alu_info_i[8];
    wire alu_sel_sltu = alu_info_i[9];

    // 1. op1
    // rs1 in {alu, alu_imm, load, store, branch}
    // pc  in {jal, jalr, auipc}
    // 0   in {lui}
    // 2. op2
    // rs2       in {alu, branch}
    // imm       in {alu_imm, load, store}
    // imm[4:0]  in {alu}
    // imm << 12 in {lui, auipc}
    // 4         in {jal, jalr}

    wire[`CPU_WIDTH - 1:0] alu_op1 = (op_alu || op_alu_imm || op_load || op_store || op_branch)? E_valA_i:
                   (op_jal || op_jalr || op_auipc)? E_pc_i: 0;
    wire[`CPU_WIDTH - 1:0] alu_op2 = (op_alu || op_branch)? E_valB_i:
                   ((op_alu_imm && ~alu_sel_sll && ~alu_sel_srl && ~alu_sel_sra) || op_load || op_store)? E_valC_i:
                   (op_alu_imm && (alu_sel_sll || alu_sel_srl || alu_sel_sra))? {{(`CPU_WIDTH - 5){1'b0}} ,E_imm_i[4:0]}:
                   (op_lui || op_auipc)? (E_valC_i << 12): 4;


// 算术运算
    wire[`CPU_WIDTH - 1:0] res_add  = alu_op1 + alu_op2;
    wire[`CPU_WIDTH - 1:0] res_sub  = alu_op1 - alu_op2;
    wire[`CPU_WIDTH - 1:0] res_xor  = alu_op1 ^ alu_op2;
    wire[`CPU_WIDTH - 1:0] res_or   = alu_op1 | alu_op2;
    wire[`CPU_WIDTH - 1:0] res_and  = alu_op1 & alu_op2;
    wire[`CPU_WIDTH - 1:0] res_sll  = alu_op1 << alu_op2;
    wire[`CPU_WIDTH - 1:0] res_srl  = alu_op1 >> alu_op2;
    wire[`CPU_WIDTH - 1:0] res_sra  = $signed(alu_op1) >>> alu_op2;
    wire[`CPU_WIDTH - 1:0] res_slt  = $signed(alu_op1) < $signed(alu_op2);
    wire[`CPU_WIDTH - 1:0] res_sltu = alu_op1 < alu_op2;


    assign e_valE_o = ({`CPU_WIDTH{alu_sel_add }} & res_add) |
                      ({`CPU_WIDTH{alu_sel_sub }} & res_sub) |
                      ({`CPU_WIDTH{alu_sel_xor }} & res_xor) |
                      ({`CPU_WIDTH{alu_sel_or  }} & res_or)  |
                      ({`CPU_WIDTH{alu_sel_and }} & res_and) |
                      ({`CPU_WIDTH{alu_sel_sll }} & res_sll) |
                      ({`CPU_WIDTH{alu_sel_srl }} & res_srl) |
                      ({`CPU_WIDTH{alu_sel_sra }} & res_sra) |
                      ({`CPU_WIDTH{alu_sel_slt }} & res_slt) |
                      ({`CPU_WIDTH{alu_sel_sltu}} & res_sltu);
                      

// 分支判断
    wire beq  = branch_info_i[0];
    wire bne  = branch_info_i[1];
    wire blt  = branch_info_i[2];
    wire bge  = branch_info_i[3];
    wire bltu = branch_info_i[4];
    wire bgeu = branch_info_i[5];

    assign e_cnd_o = (beq  & (alu_op1 == alu_op2)) |
                     (bne  & (alu_op1 != alu_op2)) |
                     (blt  & ($signed(alu_op1) <  $signed(alu_op2))) |
                     (bge  & ($signed(alu_op1) >= $signed(alu_op2))) |
                     (bltu & (alu_op1 < alu_op2)) |
                     (bgeu & (alu_op1 >= alu_op2));
endmodule