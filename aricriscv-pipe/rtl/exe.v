`include "./define.v"
`include "./alu.v"

module execute (
    input wire[6:0] E_opcode_i,
    input wire[2:0] E_func3_i,
    input wire[6:0] E_func7_i,
    input wire[11:0] E_imm_i, 
    input wire[`CPU_WIDTH - 1:0] E_valA_i,
    input wire[`CPU_WIDTH - 1:0] E_valB_i,
    input wire[`CPU_WIDTH - 1:0] E_valC_i,
    input wire[`PC_WIDTH - 1:0] E_pc_i,

    output wire[`CPU_WIDTH - 1:0] e_valE_o,
    output wire e_cnd_o,
    output wire[`PC_WIDTH - 1:0] e_jumpPC_o
);

    wire op_alu     = E_opcode_i == 7'b011_0011;
    wire op_alu_imm = E_opcode_i == 7'b001_0011;
    wire op_load    = E_opcode_i == 7'b000_0011;
    wire op_store   = E_opcode_i == 7'b010_0011;
    wire op_branch  = E_opcode_i == 7'b110_0011;
    wire op_jal     = E_opcode_i == 7'b110_1111;
    wire op_jalr    = E_opcode_i == 7'b110_0111;
    wire op_lui     = E_opcode_i == 7'b011_0111;
    wire op_auipc   = E_opcode_i == 7'b001_0111;
    wire[8:0] op_info = {op_auipc, op_lui, op_jalr, op_jal, op_branch,
                         op_store, op_load, op_alu_imm, op_alu};


    wire alu_add  = (op_alu     && E_func3_i == 3'h0 && E_func7_i == 7'h00) ||
                    (op_alu_imm && E_func3_i == 3'h0) || (op_load) || (op_store) ||
                    (op_jal) || (op_jalr) || (op_lui) || (op_auipc);
    wire alu_sub  = (op_alu && E_func3_i == 3'h0 && E_func7_i == 7'h20);
    wire alu_xor  = (op_alu && E_func3_i == 3'h4) || (op_alu_imm && E_func3_i == 3'h4);
    wire alu_or   = (op_alu && E_func3_i == 3'h6) || (op_alu_imm && E_func3_i == 3'h6);
    wire alu_and  = (op_alu && E_func3_i == 3'h7) || (op_alu_imm && E_func3_i == 3'h7);
    wire alu_sll  = (op_alu     && E_func3_i == 3'h1 && E_func7_i == 7'h00) || 
                    (op_alu_imm && E_func3_i == 3'h1 && E_imm_i[11:5] == 7'h00);
    wire alu_srl  = (op_alu     && E_func3_i == 3'h5 && E_func7_i == 7'h00) || 
                    (op_alu_imm && E_func3_i == 3'h5 && E_imm_i[11:5] == 7'h00);
    wire alu_sra  = (op_alu     && E_func3_i == 3'h5 && E_func7_i == 7'h20) || 
                    (op_alu_imm && E_func3_i == 3'h5 && E_imm_i[11:5] == 7'h20);
    wire alu_slt  = (op_alu && E_func3_i == 3'h2) || (op_alu_imm && E_func3_i == 3'h2);
    wire alu_sltu = (op_alu && E_func3_i == 3'h3) || (op_alu_imm && E_func3_i == 3'h3);
    wire[9:0] alu_info = {alu_sltu, alu_slt, alu_sra, alu_srl, alu_sll, 
                         alu_and, alu_or, alu_xor, alu_sub, alu_add};


    wire beq  = (E_opcode_i) && (E_func3_i == 3'h0);
    wire bne  = (E_opcode_i) && (E_func3_i == 3'h1);
    wire blt  = (E_opcode_i) && (E_func3_i == 3'h4);
    wire bge  = (E_opcode_i) && (E_func3_i == 3'h5);
    wire bltu = (E_opcode_i) && (E_func3_i == 3'h6);
    wire bgeu = (E_opcode_i) && (E_func3_i == 3'h7);
    wire[5:0] branch_info = {bgeu, bltu, bge, blt, bne, beq};


    alu alu_ins(
		.op_info_i(op_info),
		.alu_info_i(alu_info),
		.branch_info_i(branch_info),
		.E_imm_i(E_imm_i),
		.E_pc_i(E_pc_i),
		.E_valA_i(E_valA_i),
		.E_valB_i(E_valB_i),
		.E_valC_i(E_valC_i),
		.e_cnd_o(e_cnd_o),
		.e_valE_o(e_valE_o)
    );

// ************************************
// jalr 指令跳转地址
// ************************************
    assign e_jumpPC_o = ({`PC_WIDTH{op_jalr}} & E_valA_i + E_valC_i);

/*
    wire[2:0] alu_fun;
    assign alu_fun = (E_opcode_i == `IR && E_func3_i == 3'h0 && E_func7_i == 7'h0) ||
                     (E_opcode_i == `II && E_func3_i == 3'h0)? `FADD:
                     (E_opcode_i == `IR && E_func3_i == 3'h0 && E_func7_i == 7'h20)? `FSUB:
                     (E_opcode_i == `IR && E_func3_i == 3'h4) ||
                     (E_opcode_i == `II && E_func3_i == 3'h4)? `FXOR:
                     (E_opcode_i == `IR && E_func3_i == 3'h6) ||
                     (E_opcode_i == `II && E_func3_i == 3'h6)? `FOR:
                     (E_opcode_i == `IR && E_func3_i == 3'h7) ||
                     (E_opcode_i == `II && E_func3_i == 3'h7)? `FAND:
                     (E_opcode_i == `IR && E_func3_i == 3'h1) ||
                     (E_opcode_i == `II && E_func3_i == 3'h1) ||
                     (E_opcode_i == `ILUI || E_opcode_i == `IAUIPC)? `FSLL:
                     (E_opcode_i == `IR && E_func3_i == 3'h5 && E_func7_i == 7'h0) ||
                     (E_opcode_i == `II && E_func3_i == 3'h5 && E_func7_imm_i == 7'h0)? `FSRL:
                     (E_opcode_i == `IR && E_func3_i == 3'h5 && E_func7_i == 7'h20) ||
                     (E_opcode_i == `II && E_func3_i == 3'h5 && E_func7_imm_i == 7'h20)? `FSRA:
                     (E_opcode_i == `IR && E_func3_i == 3'h2) ||
                     (E_opcode_i == `II && E_func3_i == 3'h2)? `FSLT:
                     (E_opcode_i == `IR && E_func3_i == 3'h3) ||
                     (E_opcode_i == `II && E_func3_i == 3'h3)? `FSLTU: `FADD;

    wire[`CPU_WIDTH - 1:0] aluA, aluB;
    wire aluA_0, aluA_valC, aluA_valA; // aluA select
    wire aluB_0, aluB_valC, aluB_valB, aluB_12; // aluB select

    assign aluA_0 = (E_opcode_i == `IB      || E_opcode_i == `IJ);
    assign aluA_valC = (E_opcode_i == `ILUI || E_opcode_i == `IAUIPC);
    assign aluA_valA = ~(aluA_0 || aluA_valC);
    assign aluA = ({`CPU_WIDTH{aluA_0}} & `CPU_WIDTH'h0) |
                  ({`CPU_WIDTH{aluA_valC}} & E_valC_i)     |
                  ({`CPU_WIDTH{aluA_valA}} & E_valA_i);
    // assign aluA = (E_opcode_i == `IB   || E_opcode_i == `IJ)? `CPU_WIDTH'h0:
    //               (E_opcode_i == `ILUI || E_opcode_i == `IAUIPC)? E_valC_i: E_valA_i;

    assign aluB = (E_opcode_i == `IR)? E_valB_i:
                  (E_opcode_i == `II   || E_opcode_i == `IIL ||
                   E_opcode_i == `IS   || E_opcode_i == `IB  ||
                   E_opcode_i == `IJAL || E_opcode_i == `IJALR)? E_valC_i: 
                  (E_opcode_i == `ILUI || E_opcode_i == `IAUIPC)? `CPU_WIDTH'd12:`CPU_WIDTH'h0;

    assign e_valE_o = (alu_fun == `FADD)? aluA + aluB:
                    (alu_fun == `FSUB)? aluA - aluB:
                    (alu_fun == `FXOR)? aluA ^ aluB:
                    (alu_fun == `FOR) ? aluA | aluB:
                    (alu_fun == `FAND)? aluA & aluB:
                    (alu_fun == `FSLL)? aluA >> aluB:
                    (alu_fun == `FSRL)? aluA << aluB:
                    (alu_fun == `FSRA)? $signed(aluA) >>> aluB:
                    (alu_fun == `FSLT)? $signed(aluA) < $signed(aluB):
                    (alu_fun == `FSLTU)? aluA < aluB: `CPU_WIDTH'h0;

    assign e_cnd_o = (E_opcode_i == `IB && E_func3_i == 3'h0)? ($signed(E_valA_i) == $signed(E_valB_i)):
                   (E_opcode_i == `IB && E_func3_i == 3'h1)? ($signed(E_valA_i) != $signed(E_valB_i)):
                   (E_opcode_i == `IB && E_func3_i == 3'h2)? ($signed(E_valA_i) <  $signed(E_valB_i)):
                   (E_opcode_i == `IB && E_func3_i == 3'h3)? ($signed(E_valA_i) >= $signed(E_valB_i)):
                   (E_opcode_i == `IB && E_func3_i == 3'h4)? (E_valA_i < E_valB_i):
                   (E_opcode_i == `IB && E_func3_i == 3'h5)? (E_valA_i >= E_valB_i):
                   (E_opcode_i == `IJAL || E_opcode_i == `IJALR)? 1'b1: 1'b0;
*/
endmodule
