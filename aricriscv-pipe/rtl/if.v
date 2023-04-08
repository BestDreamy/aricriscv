`include "./define.v"
`include "./imm_extend.v"

module fetch (
    input  wire[`PC_WIDTH - 1:0]  pc_i, // 2^ 10 可将指令内存全部访问
    output wire[6:0]              f_opcode_o,
    output wire[4:0]              f_rd_o,
    output wire[2:0]              f_func3_o,
    output wire[4:0]              f_rs1_o,
    output wire[4:0]              f_rs2_o,
    output wire[6:0]              f_func7_o,
    output wire[11:0]             f_imm_o, // I 指令独有
    output wire[`CPU_WIDTH - 1:0] f_valC_o,
    output wire[`PC_WIDTH - 1:0]  f_predPC_o,
    output wire[`PC_WIDTH - 1:0]  f_delayPC_o
);

    reg [`CPU_BYTE - 1: 0] instr_mem[1023: 0];
    wire[`CPU_WIDTH - 1: 0] instr;

    initial begin
        $readmemh("./input_compute.txt", instr_mem);
    end

// ************************** //
// 预译码
// ************************** // 

    assign instr = {instr_mem[pc_i], instr_mem[pc_i + 1], instr_mem[pc_i + 2], instr_mem[pc_i + 3]};

    assign f_opcode_o = instr[6:0];

    // 二选一多路选择器，1表示选中，0表示为空
    wire[1:0] rd_sel;
    assign rd_sel[0] = ~rd_sel[1];
    assign rd_sel[1] = (f_opcode_o == `IR   || f_opcode_o == `II    ||
                        f_opcode_o == `IIL  || f_opcode_o == `IJAL  ||
                        f_opcode_o == `ILUI || f_opcode_o == `IJALR ||
                        f_opcode_o == `IAUIPC);
    assign f_rd_o = ({5{rd_sel[1]}} & instr[11:7]) | 
                  ({5{rd_sel[0]}} & `RNONE);


    wire[1:0] func3_sel;
    assign func3_sel[0] = ~func3_sel[1];
    assign func3_sel[1] = (f_opcode_o == `IR  || f_opcode_o == `II ||
                           f_opcode_o == `IIL || f_opcode_o == `IS || 
                           f_opcode_o == `IB  || f_opcode_o == `IJALR);
    assign f_func3_o = ({3{func3_sel[1]}} & instr[14: 12]) |
                     ({3{func3_sel[0]}} & `F3NONE);


    wire[1:0] rs1_sel;
    assign rs1_sel[0] = ~rs1_sel[1];
    assign rs1_sel[1] = (f_opcode_o == `IR  || f_opcode_o == `II ||
                         f_opcode_o == `IIL || f_opcode_o == `IS || 
                         f_opcode_o == `IB  || f_opcode_o == `IJALR);
    assign f_rs1_o = ({5{rs1_sel[1]}} & instr[19: 15]) |
                   ({5{rs1_sel[0]}} & `RNONE);


    wire[1:0] rs2_sel;
    assign rs2_sel[0] = ~rs2_sel[1];
    assign rs2_sel[1] = (f_opcode_o == `IR  || f_opcode_o == `IS || 
                         f_opcode_o == `IB);
    assign f_rs2_o = ({5{rs2_sel[1]}} & instr[24: 20]) | 
                     ({5{rs2_sel[0]}} & `RNONE);


    wire[1:0] func7_sel;
    assign func7_sel[0] = ~func7_sel[1];
    assign func7_sel[1] = (f_opcode_o == `IR);
    assign f_func7_o = ({7{func7_sel[1]}} & instr[31: 25]) |
                       ({7{func7_sel[0]}} & `F7NONE);


    // 立即数操作码
    assign f_imm_o = (f_opcode_o == `II)? instr[31: 20]: 12'h0;

    imm_extend imm_extend_ins(
        .instr_i(instr), 
        .opcode_i(f_opcode_o), 
        .valC_o(f_valC_o)
    ); // instance

// ************************** //
// pc 静态预测
// ************************** // 

    assign f_predPC_o = (f_opcode_o == `IJ || f_opcode_o == `IB)? pc_i + f_valC_o:
                         pc_i + 4;

    assign f_delayPC_o = pc_i + 4;

endmodule
