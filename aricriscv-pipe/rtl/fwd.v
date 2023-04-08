`include "./define.v"

module fwd (
    input wire[`REG_WIDTH - 1:0] d_srcA_i,
    input wire[`REG_WIDTH - 1:0] d_srcB_i,
    input wire[`CPU_WIDTH - 1:0] d_rvalA_i,
    input wire[`CPU_WIDTH - 1:0] d_rvalB_i,

    input wire[`REG_WIDTH - 1:0] E_dstE_i,
    input wire[`CPU_WIDTH - 1:0] e_valE_i,
    
    input wire[`REG_WIDTH - 1:0] M_dstE_i,
    input wire[`CPU_WIDTH - 1:0] M_valE_i,
    input wire[`REG_WIDTH - 1:0] M_dstM_i,
    input wire[`CPU_WIDTH - 1:0] m_valM_i,

    input wire[`REG_WIDTH - 1:0] W_dstE_i,
    input wire[`CPU_WIDTH - 1:0] W_valE_i,
    input wire[`REG_WIDTH - 1:0] W_dstM_i,
    input wire[`CPU_WIDTH - 1:0] W_valM_i,

    output wire[`CPU_WIDTH - 1:0] d_valA_o,
    output wire[`CPU_WIDTH - 1:0] d_valB_o
);

    // 优先级选择器
    assign d_valA_o = (d_srcA_i == E_dstE_i)? e_valE_i:
                      (d_srcA_i == M_dstE_i)? M_valE_i:
                      (d_srcA_i == M_dstM_i)? m_valM_i:
                      (d_srcA_i == W_dstE_i)? W_valE_i:
                      (d_srcA_i == W_dstM_i)? W_valM_i: d_rvalA_i;
                      
    assign d_valB_o = (d_srcB_i == E_dstE_i)? e_valE_i:
                      (d_srcB_i == M_dstE_i)? M_valE_i:
                      (d_srcB_i == M_dstM_i)? m_valM_i:
                      (d_srcB_i == W_dstE_i)? W_valE_i:
                      (d_srcB_i == W_dstM_i)? W_valM_i: d_rvalB_i;
endmodule 