//=============================================================================
// Lab 1 : Testbench cho Carry Lookahead Adder 4-bit
//=============================================================================
`timescale 1ns/1ps

module cla_4bit_tb;

    reg  [3:0] A, B;
    reg        C0;
    wire [3:0] S;
    wire       C4;
    wire [3:0] G, P;
    wire [4:1] C;

    reg [4:0] exp;              // gia tri mong doi {C4, S}

    cla_4bit dut (
        .A(A), .B(B), .C0(C0),
        .S(S), .C4(C4),
        .G(G), .P(P), .C(C),
        .PG(), .GG()
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, cla_4bit_tb);
    end

    initial begin
        $display("==========================================================================");
        $display("| # | C0 |  A (bin|dec)  |  B (bin|dec)  | C4 | S(dec) | Exp | Status |");
        $display("==========================================================================");

        // Test 1 : 0 + 0 + 0 = 0
        A = 4'd0;  B = 4'd0;  C0 = 1'b0;  #10;
        exp = A + B + C0;
        $display("| %0d |  %b | %b (%2d) | %b (%2d) |  %b | %3d    | %3d | %s |",
                 1, C0, A, A, B, B, C4, S, exp, ({C4,S} === exp) ? "PASS" : "FAIL");

        // Test 2 : 3 + 4 + 1 = 8
        A = 4'd3;  B = 4'd4;  C0 = 1'b1;  #10;
        exp = A + B + C0;
        $display("| %0d |  %b | %b (%2d) | %b (%2d) |  %b | %3d    | %3d | %s |",
                 2, C0, A, A, B, B, C4, S, exp, ({C4,S} === exp) ? "PASS" : "FAIL");

        // Test 3 : 5 + 6 + 0 = 11
        A = 4'd5;  B = 4'd6;  C0 = 1'b0;  #10;
        exp = A + B + C0;
        $display("| %0d |  %b | %b (%2d) | %b (%2d) |  %b | %3d    | %3d | %s |",
                 3, C0, A, A, B, B, C4, S, exp, ({C4,S} === exp) ? "PASS" : "FAIL");

        // Test 4 : 7 + 8 + 0 = 15 (gia tri lon nhat cua 4 bit)
        A = 4'd7;  B = 4'd8;  C0 = 1'b0;  #10;
        exp = A + B + C0;
        $display("| %0d |  %b | %b (%2d) | %b (%2d) |  %b | %3d    | %3d | %s |",
                 4, C0, A, A, B, B, C4, S, exp, ({C4,S} === exp) ? "PASS" : "FAIL");

        // Test 5 : 15 + 15 + 1 = 31 (tran, C4 = 1)
        A = 4'd15; B = 4'd15; C0 = 1'b1;  #10;
        exp = A + B + C0;
        $display("| %0d |  %b | %b (%2d) | %b (%2d) |  %b | %3d    | %3d | %s |",
                 5, C0, A, A, B, B, C4, S, exp, ({C4,S} === exp) ? "PASS" : "FAIL");

        $display("==========================================================================");
        $finish;
    end

endmodule
