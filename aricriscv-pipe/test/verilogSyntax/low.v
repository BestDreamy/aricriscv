module low (
    input wire clk,
    input wire[3:0] out1,
    output reg[3:0] out2
);

    always @(posedge clk) begin
        out2 <= out1;
    end

endmodule