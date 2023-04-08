`include "./define.v"
`include "./test_reg.v"
`include "./fwd.v"

module decode (
    input wire clk_i,
    input wire[6:0] D_opcode_i,
    input wire[`REG_WIDTH - 1:0] D_rs1_i, // source
    input wire[`REG_WIDTH - 1:0] D_rs2_i,
    input wire[`REG_WIDTH - 1:0] D_rd_i,  // destination
    // input wire[`PC_WIDTH - 1:0] D_pc_i,

    input wire[`REG_WIDTH - 1:0] E_dstE_i,
    input wire[`CPU_WIDTH - 1:0] e_valE_i,
    input wire[`REG_WIDTH - 1:0] M_dstM_i,
    input wire[`CPU_WIDTH - 1:0] m_valM_i,
    input wire[`REG_WIDTH - 1:0] M_dstE_i,
    input wire[`CPU_WIDTH - 1:0] M_valE_i,
    input wire[`REG_WIDTH - 1:0] W_dstE_i,
    input wire[`CPU_WIDTH - 1:0] W_valE_i,
    input wire[`REG_WIDTH - 1:0] W_dstM_i,
    input wire[`CPU_WIDTH - 1:0] W_valM_i,

    output wire[`CPU_WIDTH - 1:0] d_valA_o, // 寄存器 rs1 中的值
    output wire[`CPU_WIDTH - 1:0] d_valB_o, // 寄存器 rs2 中的值
    output wire[`REG_WIDTH - 1:0] d_srcA_o,
    output wire[`REG_WIDTH - 1:0] d_srcB_o,
    output wire[`REG_WIDTH - 1:0] d_dstE_o,
    output wire[`REG_WIDTH - 1:0] d_dstM_o
);
    
    integer i;
    reg[`CPU_WIDTH - 1:0] regfile [31:0]; // 31 个寄存器
    initial begin
        //$readmemh("./input_regfile.txt", regfile);
        //$dumpvars(0, regfile[10]);
        //for(i = 0; i < 32; i ++) begin
            //$dumpvars(0, regfile[i]);
        //end
        regfile[0] = 0;
        for(i = 1; i < 32; i ++) begin
            regfile[i] = 0;
        end
        // regfile[2] = `CPU_WIDTH'd16380;
        // regfile[3] = `CPU_WIDTH'd6144;
    end

/*
    wire[1:0] valA_sel;
    assign valA_sel[0] = ~valA_sel[1];
    assign valA_sel[1] = (D_opcode_i == `IR    || D_opcode_i == `II ||
                          D_opcode_i == `IIL   || D_opcode_i == `IS || 
                          D_opcode_i == `IJALR || D_opcode_i == `IB);
    assign d_valA_o = ({`CPU_WIDTH{valA_sel[1]}} & regfile[D_rs1_i]) |
                      ({`CPU_WIDTH{valA_sel[0]}} & `CPU_WIDTH'b0);


    wire[1:0] valB_sel;
    assign valB_sel[0] = ~valB_sel[1];
    assign valB_sel[1] = (D_opcode_i == `IR  || D_opcode_i == `IS || 
                          D_opcode_i == `IB);
    assign d_valB_o = ({`CPU_WIDTH{valB_sel[1]}} & regfile[D_rs2_i]) |
                      ({`CPU_WIDTH{valB_sel[0]}} & `CPU_WIDTH'b0);
*/

    assign d_srcA_o = (D_opcode_i == `IR    || D_opcode_i == `II ||
                       D_opcode_i == `IIL   || D_opcode_i == `IS || 
                       D_opcode_i == `IJALR || D_opcode_i == `IB)? D_rs1_i: `RNONE;
    assign d_srcB_o = (D_opcode_i == `IR  || D_opcode_i == `IS || 
                       D_opcode_i == `IB)? D_rs2_i: `RNONE;

    wire[`CPU_WIDTH - 1:0] d_rvalA = regfile[d_srcA_o];
    wire[`CPU_WIDTH - 1:0] d_rvalB = regfile[d_srcB_o];

    fwd fwd_ins(
       	.d_srcA_i(d_srcA_o),
		.d_srcB_i(d_srcB_o),
		.d_rvalA_i(d_rvalA),
		.d_rvalB_i(d_rvalB),

		.E_dstE_i(E_dstE_i),
		.e_valE_i(e_valE_i),

		.M_dstE_i(M_dstE_i),
		.M_valE_i(M_valE_i),
		.M_dstM_i(M_dstM_i),
		.m_valM_i(m_valM_i),

		.W_dstE_i(W_dstE_i),
		.W_valE_i(W_valE_i),
		.W_dstM_i(W_dstM_i),
		.W_valM_i(W_valM_i),

		.d_valA_o(d_valA_o),
		.d_valB_o(d_valB_o)
    );

    assign d_dstE_o = (D_opcode_i == `IR   || D_opcode_i == `II ||
                       D_opcode_i == `IJ   || D_opcode_i == `IJALR ||
                       D_opcode_i == `ILUI || D_opcode_i == `IAUIPC)? D_rd_i: `RNONE;
    assign d_dstM_o = (D_opcode_i == `IIL)? D_rd_i: `RNONE;

    // write back
    always @(posedge clk_i) begin
        if(W_dstE_i != `RZERO) 
            regfile[W_dstE_i] <= W_valE_i;

        if(W_dstM_i != `RZERO)
            regfile[W_dstM_i] <= W_valM_i;
    end
    /*
    always @(posedge clk_i) begin
        if(D_rd_i == 0) begin
            regfile[0] = 0;
        end
        else if(D_opcode_i == `IR || D_opcode_i == `II || D_opcode_i == `ILUI) begin
            regfile[D_rd_i] <= valE_i;
        end
        else if(D_opcode_i == `IIL) begin
            regfile[D_rd_i] <= valM_i;
        end
        else if (D_opcode_i == `IJALR || D_opcode_i == `IJ) begin
            regfile[D_rd_i] <= pc_o + 4;
        end
        else if (D_opcode_i == `IAUIPC) begin
            regfile[D_rd_i] <= valE_i + pc_o;
        end 
    end
    */
/*
    always @(posedge clk_i) begin
        // cnd_i control the B-type, jal and jalr instruction
        if(cnd_i && (D_opcode_i == `IB || D_opcode_i == `IJ)) pc_o <= pc_o + valE_i;
        else if(cnd_i && D_opcode_i == `IJALR) pc_o <= valE_i;
        else pc_o <= pc_o + 4;
    end
*/
    //assign temp_o = regfile[D_rd_i];
    test_reg test_reg_ins(
        .x0(regfile[0]),
        .x1(regfile[1]),
        .x2(regfile[2]),
        .x3(regfile[3]),
        .x4(regfile[4]),
        .x5(regfile[5]),
        .x6(regfile[6]),
        .x7(regfile[7]),
        .x8(regfile[8]),
        .x9(regfile[9]),
        .x10(regfile[10]),
        .x11(regfile[11]),
        .x12(regfile[12]),
        .x13(regfile[13]),
        .x14(regfile[14]),
        .x15(regfile[15]),
        .x16(regfile[16]),
        .x17(regfile[17]),
        .x18(regfile[18]),
        .x19(regfile[19]),
        .x20(regfile[20]),
        .x21(regfile[21]),
        .x22(regfile[22]),
        .x23(regfile[23]),
        .x24(regfile[24]),
        .x25(regfile[25]),
        .x26(regfile[26]),
        .x27(regfile[27]),
        .x28(regfile[28]),
        .x29(regfile[29]),
        .x30(regfile[30]),
        .x31(regfile[31])
    );

endmodule
