`include "./define.v"

module F_pipe_reg (
    input wire clk_i,
    input wire rst_i,

    input wire F_bubble_i,
    input wire F_stall_i,

    input wire[`PC_WIDTH - 1:0] f_predPC_i,
    output reg[`PC_WIDTH - 1:0] F_predPC_o
);

    always @(posedge clk_i, rst_i) begin
        if(F_bubble_i || rst_i) 
            F_predPC_o <= `PC_WIDTH'h0;
        else if(~F_stall_i)
            F_predPC_o <= f_predPC_i;
    end

endmodule