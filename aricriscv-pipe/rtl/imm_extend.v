`include "./define.v"

module imm_extend (
    input   wire[`CPU_WIDTH - 1:0] instr_i,
    input   wire[6:0]              opcode_i,
    output  wire[`CPU_WIDTH - 1:0] valC_o
);

    assign valC_o = (opcode_i == `II || opcode_i == `IIL || 
                     opcode_i == `IJALR)? {{20{instr_i[31]}}, instr_i[31:20]}:
                    (opcode_i == `IS)? {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]}:
                    (opcode_i == `IB)? {{20{instr_i[31]}}, instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0}:
                    (opcode_i == `IJAL)? {{12{instr_i[31]}}, instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0}:
                    (opcode_i == `ILUI || opcode_i == `IAUIPC)? {instr_i[31:12], 12'b0}: `CPU_WIDTH'h0;
    
endmodule
