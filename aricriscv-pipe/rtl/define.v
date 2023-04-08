`define CPU_WIDTH       32
`define CPU_BYTE        8

`define PC_WIDTH        10

`define OPCODE_WIDTH    7
`define IR              `OPCODE_WIDTH'b0110011
`define II              `OPCODE_WIDTH'b0010011
`define IIL             `OPCODE_WIDTH'b0000011
`define IS              `OPCODE_WIDTH'b0100011
`define IB              `OPCODE_WIDTH'b1100011
`define IJAL            `OPCODE_WIDTH'b1101111
`define IJ              `OPCODE_WIDTH'b1101111
`define IJALR           `OPCODE_WIDTH'b1100111
`define ILUI            `OPCODE_WIDTH'b0110111
`define IAUIPC          `OPCODE_WIDTH'b0010111

`define REG_WIDTH       5
`define RNONE           `REG_WIDTH'd0
`define RZERO           `REG_WIDTH'd0
`define RSP             `REG_WIDTH'd2

`define F3NONE          3'b111
`define F7NONE          7'b1111111 
`define FADD            3'h0
`define FSUB            3'h0
`define FXOR            3'h4
`define FOR             3'h6
`define FAND            3'h7
`define FSLL            3'h1
`define FSRL            3'h5
`define FSRA            3'h5
`define FSLT            3'h2
`define FSLTU           3'h3
