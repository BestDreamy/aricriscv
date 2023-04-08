`include "./define.v"
`include "./ram.v"

module memory_access (
    input wire clk_i,
    input wire[6:0] M_opcode_i,
    input wire[2:0] M_func3_i,
    input wire[`CPU_WIDTH - 1:0] M_valE_i,
    input wire[`CPU_WIDTH - 1:0] M_valB_i, // rs2 中的值
    
    output wire[`CPU_WIDTH - 1:0] m_valM_o
);    

    wire r_enable, w_enable;
    assign r_enable = (M_opcode_i == `IIL);
    assign w_enable = (M_opcode_i == `IS);

    ram ram_ins (
        .clk_i(clk_i),
        .r_enable_i(r_enable),
        .w_enable_i(w_enable),
        .M_func3_i(M_func3_i),
        .address_i(M_valE_i), // 读写内存的地址
        .write_data_i(M_valB_i), // 写入的数据
        .read_data_o(m_valM_o) // 读出的数据
    );    

endmodule
