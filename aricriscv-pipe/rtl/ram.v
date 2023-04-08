`include "./define.v"
`include "./test_mem.v"

module ram (
    input wire clk_i,
    input wire r_enable_i,
    input wire w_enable_i,
    input wire[2:0] M_func3_i,
    input wire[`CPU_WIDTH - 1: 0] address_i,
    input wire[`CPU_WIDTH - 1: 0] write_data_i,
    
    //output wire[`CPU_WIDTH - 1: 0] temp_o,
    output wire[`CPU_WIDTH - 1: 0] read_data_o
);

    integer i;
    reg[`CPU_BYTE - 1: 0] data_mem[20000: 0];
    initial begin
        //$readmemh("./input_data_mem.txt", data_mem);
        for(i = 0; i <= 20000; i ++) begin
            data_mem[i] = 0;
        end
    end

    assign read_data_o = (r_enable_i && M_func3_i == 3'h0)? {{24{data_mem[address_i][7]}}, data_mem[address_i]}:
                         (r_enable_i && M_func3_i == 3'h1)? {{16{data_mem[address_i + 1][7]}}, data_mem[address_i + 1], 
                                                            data_mem[address_i]}:
                         (r_enable_i && M_func3_i == 3'h2)? {data_mem[address_i + 3], data_mem[address_i + 2],
                                                           data_mem[address_i + 1], data_mem[address_i]}:
                         (r_enable_i && M_func3_i == 3'h4)? {24'b0, data_mem[address_i]}:
                         (r_enable_i && M_func3_i == 3'h5)? {16'b0, data_mem[address_i + 1], data_mem[address_i]}: `CPU_WIDTH'h0;

    //assign temp_o = {data_mem[address_i + 3], data_mem[address_i + 2],
                          //data_mem[address_i + 1], data_mem[address_i]};
                          
    always @(posedge clk_i) begin
        if(w_enable_i && M_func3_i == 3'h0) 
            data_mem[address_i] <= write_data_i[7:0];
        else if(w_enable_i && M_func3_i == 3'h1)
            {data_mem[address_i + 1], data_mem[address_i]} <= write_data_i[15:0];
        else if(w_enable_i)
            {data_mem[address_i + 3], data_mem[address_i + 2],
             data_mem[address_i + 1], data_mem[address_i]} <= write_data_i[31:0];
    end
    
    test_mem test_mem_ins(
        .mem0(data_mem[0]),
        .mem1(data_mem[1]),
        .mem2(data_mem[2]),
        .mem3(data_mem[3]),
        .mem4(data_mem[4]),
        .mem5(data_mem[5]),
        .mem6(data_mem[6]),
        .mem7(data_mem[7]),
        .mem8(data_mem[8]),
        .mem9(data_mem[9]),
        .mem10(data_mem[10]),
        .mem11(data_mem[11]),
        .mem12(data_mem[12]),
        .mem13(data_mem[13]),
        .mem14(data_mem[14]),
        .mem15(data_mem[15]),
        .mem16(data_mem[16]),
        .mem17(data_mem[17]),
        .mem18(data_mem[18]),
        .mem19(data_mem[19]),
        .mem20(data_mem[20]),
        .mem21(data_mem[21]),
        .mem22(data_mem[22]),
        .mem23(data_mem[23]),
        .mem24(data_mem[24]),
        .mem25(data_mem[25]),
        .mem26(data_mem[26]),
        .mem27(data_mem[27]),
        .mem28(data_mem[28]),
        .mem29(data_mem[29]),
        .mem30(data_mem[30]),
        .mem31(data_mem[31]),
        .mem32(data_mem[32]),
        .mem33(data_mem[33]),
        .mem34(data_mem[34]),
        .mem35(data_mem[35])
    );

endmodule
