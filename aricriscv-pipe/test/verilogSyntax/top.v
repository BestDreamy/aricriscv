`timescale 1ns / 1ps
`include "./low.v"

module top;

    reg clk;
    reg[3:0] out1 = 1;
    wire[3:0] out2;
    always @(posedge clk) begin
        out1 <= 0;
    end

    low low_ins (
        .clk(clk),
        .out1(out1),
        .out2(out2)
    );

    initial begin
        clk = 0;
        $dumpfile("./wave.vcd");
        $dumpvars;
        #100 $finish;
    end

    always #3 clk = ~clk;

endmodule