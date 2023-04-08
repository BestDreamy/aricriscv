`include "./define.v"

module ctrl (
    input wire[`OPCODE_WIDTH - 1:0] E_opcode_i,
    input wire e_cnd_i,

    output reg F_bubble_o,
    output reg F_stall_o,
    output reg D_bubble_o,
    output reg D_stall_o,
    output reg E_bubble_o,
    output reg E_stall_o,
    output reg M_bubble_o,
    output reg M_stall_o,
    output reg W_bubble_o,
    output reg W_stall_o
);

    always @(*) begin 
        E_bubble_o = (E_opcode_i == `IJALR) || (E_opcode_i == `IB && ~e_cnd_i);
    end

    initial begin 
        F_bubble_o = 0;
        F_stall_o = 0;
        D_bubble_o = 0;
        D_stall_o = 0;
        E_bubble_o = 0;
        E_stall_o = 0;
        M_bubble_o = 0;
        M_stall_o = 0;
        W_bubble_o = 0;
        W_stall_o = 0;
    end
endmodule