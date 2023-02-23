`include "data_memory.v"
`include "instruction_memory.v"
`include "io.v"

module CPU (
    input clk,
    input reset,
    input [7:0] X,
    output [7:0] Y,
    output reg error
);

    reg [7:0] PC; // program counter
    reg [7:0] nPC; // variable for next PC
    wire [11:0] IR; // instruction register
    
    reg [2:0] SP; // stack pointer (points to empty cell)
    reg [2:0] nSP; // variable for new SP
    reg [7:0] push; // variable to hold the value that must be pushed
    reg signed [7:0] stack [7:0];
    
    reg Z; // zero flag (for +/-)
    reg S; // sign flag (for +/-)
    
    // Assign address wires
    wire [7:0] i_address = PC;
    wire [7:0] d_address = IR[7:0];
    // Only write on POP instruction
    wire write = (IR[11:8] == 4'b0010);
    wire [7:0] d_data = (IR[11:8] == 4'b0010) ? stack[SP-1] : 8'bzzzzzzzz;
    
    InstructionMemory instruction_memory (i_address, IR);
    DataMemory data_memory (d_address, d_data, write);
    IO io (d_address, d_data, write, X, Y);
    
    always @(*)
    begin
        if (IR[11:8] == 4'b0000) begin // PUSHC : push constant
            nPC = PC+1;
            nSP = SP+1;
            push = IR[7:0];
        end else if (IR[11:8] == 4'b0001) begin // PUSH : push from memory
            nPC = PC+1;
            nSP = SP+1;
            push = d_data;
        end else if (IR[11:8] == 4'b0010) begin // POP : pop to memory
            nPC = PC+1;
            nSP = SP-1;
            push = 0;
        end else if (IR[11:8] == 4'b0011) begin // JUMP : pop from stack to PC
            nPC = stack[SP-1];
            nSP = SP-1;
            push = 0;
        end else if (IR[11:8] == 4'b0100) begin // JZ : jump on zero flag
            nPC = Z ? stack[SP-1] : PC+1;
            nSP = Z ? SP-1 : SP;
            push = 0;
        end else if (IR[11:8] == 4'b0101) begin // JS : jump on sign flag
            nPC = S ? stack[SP-1] : PC+1;
            nSP = S ? SP-1 : SP;
            push = 0;
        end else if (IR[11:8] == 4'b0110) begin // ADD : add two top elements
            nPC = PC+1;
            nSP = SP-1;
            push = stack[SP-2] + stack[SP-1];
        end else if (IR[11:8] == 4'b0111) begin // SUB : add two top elements
            nPC = PC+1;
            nSP = SP-1;
            push = stack[SP-2] - stack[SP-1];
        end else begin
            nPC = PC;
            nSP = SP;
            push = 0;
            $display("INVALID INSTRUCTION %b", IR);
        end
    end
    
    // At posedge clock go to next instruction
    always @(posedge reset, posedge clk)
    begin
        // On reset clear registers
        if (reset) begin
            PC <= 0;
            SP <= 0;
            error <= 0;
        end else begin // otherwise go to next instruction
            PC <= nPC;
            SP <= nSP;
            // If ADD/SUB, lets set the flags
            if (IR[11:8] == 4'b0111 || IR[11:8] == 4'b0110) begin
                stack[SP-2] <= push;
                Z = ~|push;
                S = push[7];
                // If two operands with same signs add up, or two
                // operands with opposie signs subtract, but result
                // has different sign with first one -> overflow
                if (stack[SP-2][7] == (stack[SP-1][7] ^ IR[8]) && stack[SP-2][7] != S)
                    error = 1;
            end
            // Otherwise, just push the value
            // on pop, it actually clears top of stack
            else
            begin
                stack[SP] <= push;
                // If negative number is pushed -> error
                if (IR[11:8] == 4'b0001 & push[7] == 1)
                    error = 1;
            end
        end
    end
endmodule