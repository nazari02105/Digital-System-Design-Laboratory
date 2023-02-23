`include "cpu.v"
module CPU_Test;
    reg clk;
    reg reset;
    reg signed [7:0] X;
    wire signed [7:0] Y;
    wire error;
    
    initial clk = 1;
    always #5 clk = ~clk;
    
    CPU cpu (clk, reset, X, Y, error);
    
    // put instructions in instruction memory
    initial begin
        cpu.instruction_memory.i_storage[00] = 12'h_1_F8;	// PUSH X
        cpu.instruction_memory.i_storage[01] = 12'h_0_17;	// PUSHC 23
        cpu.instruction_memory.i_storage[02] = 12'h_6_00;	// ADD
        cpu.instruction_memory.i_storage[03] = 12'h_2_AA;	// POP TMP
        cpu.instruction_memory.i_storage[04] = 12'h_1_AA;	// PUSH TMP
        cpu.instruction_memory.i_storage[05] = 12'h_1_AA;	// PUSH TMP
        cpu.instruction_memory.i_storage[06] = 12'h_6_00;	// ADD
        cpu.instruction_memory.i_storage[07] = 12'h_0_0C;	// PUSHC 12
        cpu.instruction_memory.i_storage[08] = 12'h_7_00;	// SUB
        cpu.instruction_memory.i_storage[09] = 12'h_2_FF;	// POP Y
        cpu.instruction_memory.i_storage[10] = 12'h_0_0A;	// PUSHC 10
        cpu.instruction_memory.i_storage[11] = 12'h_3_0A;	// JUMP 10
    end
    
    initial begin
        X = $random;
        reset = 1;
        #10;
        reset = 0;
        #150;
        $finish;
    end
    
    always @(Y)
        $display("for input X = %4d -> output Y = %4d (error = %b)", X, Y, error);
    
endmodule