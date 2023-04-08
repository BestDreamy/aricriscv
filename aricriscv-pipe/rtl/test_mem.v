`include "define.v"

module test_mem(
    input wire[`CPU_BYTE - 1:0] mem0, 
    input wire[`CPU_BYTE - 1:0] mem1, 
    input wire[`CPU_BYTE - 1:0] mem2, 
    input wire[`CPU_BYTE - 1:0] mem3, 
    input wire[`CPU_BYTE - 1:0] mem4, 
    input wire[`CPU_BYTE - 1:0] mem5, 
    input wire[`CPU_BYTE - 1:0] mem6, 
    input wire[`CPU_BYTE - 1:0] mem7,
    input wire[`CPU_BYTE - 1:0] mem8, 
    input wire[`CPU_BYTE - 1:0] mem9, 
    input wire[`CPU_BYTE - 1:0] mem10, 
    input wire[`CPU_BYTE - 1:0] mem11, 
    input wire[`CPU_BYTE - 1:0] mem12, 
    input wire[`CPU_BYTE - 1:0] mem13, 
    input wire[`CPU_BYTE - 1:0] mem14, 
    input wire[`CPU_BYTE - 1:0] mem15,
    input wire[`CPU_BYTE - 1:0] mem16, 
    input wire[`CPU_BYTE - 1:0] mem17, 
    input wire[`CPU_BYTE - 1:0] mem18, 
    input wire[`CPU_BYTE - 1:0] mem19, 
    input wire[`CPU_BYTE - 1:0] mem20, 
    input wire[`CPU_BYTE - 1:0] mem21, 
    input wire[`CPU_BYTE - 1:0] mem22, 
    input wire[`CPU_BYTE - 1:0] mem23,
    input wire[`CPU_BYTE - 1:0] mem24, 
    input wire[`CPU_BYTE - 1:0] mem25, 
    input wire[`CPU_BYTE - 1:0] mem26, 
    input wire[`CPU_BYTE - 1:0] mem27, 
    input wire[`CPU_BYTE - 1:0] mem28, 
    input wire[`CPU_BYTE - 1:0] mem29, 
    input wire[`CPU_BYTE - 1:0] mem30, 
    input wire[`CPU_BYTE - 1:0] mem31,
    input wire[`CPU_BYTE - 1:0] mem32, 
    input wire[`CPU_BYTE - 1:0] mem33, 
    input wire[`CPU_BYTE - 1:0] mem34, 
    input wire[`CPU_BYTE - 1:0] mem35
    //output wire[`CPU_WIDTH - 1:0] val0,
    //output wire[`CPU_WIDTH - 1:0] val1
);
    wire[`CPU_WIDTH - 1:0] word0, word1, word2, word3, word4, word5, word6, word7, word8;
    assign word0 = {mem0, mem1, mem2, mem3};
    assign word1 = {mem4, mem5, mem6, mem7};
    assign word2 = {mem8, mem9, mem10, mem11};
    assign word3 = {mem12, mem13, mem14, mem15};
    assign word4 = {mem16, mem17, mem18, mem19};
    assign word5 = {mem20, mem21, mem22, mem23};
    assign word6 = {mem24, mem25, mem26, mem27};
    assign word7 = {mem28, mem29, mem30, mem31};
    assign word8 = {mem32, mem33, mem34, mem35};
endmodule
