//=============================================================================
// Lab 1 : Carry Lookahead Adder (CLA) 4-bit
//
// Kien truc theo dung so do khoi trong bao cao:
//
//     A3 B3        A2 B2        A1 B1        A0 B0
//      |  |         |  |         |  |         |  |
//   +------+ C3  +------+ C2  +------+ C1  +------+ C0
//   | Full |<--  | Full |<--  | Full |<--  | Full |<--+
//   |Adder |     |Adder |     |Adder |     |Adder |   |
//   +------+     +------+     +------+     +------+   |
//      |            |            |            |       |
//      S3           S2           S1           S0      |
//                                                     |
//  C4  +-------------------------------------------+  |
//  <---|        Carry Lookahead Logic              |<-+
//      |      (Generate, Propagate, Carry)         |
//      +-------------------------------------------+
//        ^  ^     ^  ^     ^  ^     ^  ^
//       A3 B3    A2 B2    A1 B1    A0 B0
//
// Mach gom 4 Full Adder va 1 khoi Carry Lookahead Logic.
// Khoi Carry Lookahead Logic nhan tat ca Ai, Bi va C0, sinh ra C1..C4
// cap cho cac Full Adder tuong ung.
//
// Uu diem: carry duoc tinh TRUOC thay vi lan truyen tuan tu qua tung
// Full Adder, nen CLA dat toc do cao hon Ripple Carry Adder.
//=============================================================================
`timescale 1ns/1ns

module cla_4bit (
    input  wire [3:0] A,        // toan hang A3A2A1A0
    input  wire [3:0] B,        // toan hang B3B2B1B0
    input  wire       C0,       // carry ban dau
    output wire [3:0] S,        // tong S3S2S1S0
    output wire       C4,       // carry ra cuoi cung
    // --- cac tin hieu noi bo dua ra ngoai de quan sat tren waveform ---
    output wire [3:0] G,        // Generate
    output wire [3:0] P,        // Propagate
    output wire [4:1] C,        // carry C4..C1
    output wire       PG,       // group propagate (ghep tang)
    output wire       GG        // group generate  (ghep tang)
);

    wire [3:0] fa_cout;         // carry ra cua tung Full Adder (khong dung)

    //-------------------------------------------------------------------------
    // Khoi Carry Lookahead Logic: sinh C1, C2, C3, C4 tu tat ca Ai, Bi va C0
    //-------------------------------------------------------------------------
    cla_logic u_cla_logic (
        .A  (A),
        .B  (B),
        .C0 (C0),
        .G  (G),
        .P  (P),
        .C  (C),
        .PG (PG),
        .GG (GG)
    );

    //-------------------------------------------------------------------------
    // 4 Full Adder: moi bo tinh 1 bit tong Si
    // Carry vao lay TRUC TIEP tu Carry Lookahead Logic, khong lay tu FA truoc
    //-------------------------------------------------------------------------
    full_adder FA0 (.A(A[0]), .B(B[0]), .C(C0),   .S(S[0]), .Cout(fa_cout[0]));
    full_adder FA1 (.A(A[1]), .B(B[1]), .C(C[1]), .S(S[1]), .Cout(fa_cout[1]));
    full_adder FA2 (.A(A[2]), .B(B[2]), .C(C[2]), .S(S[2]), .Cout(fa_cout[2]));
    full_adder FA3 (.A(A[3]), .B(B[3]), .C(C[3]), .S(S[3]), .Cout(fa_cout[3]));

    // Carry ra cuoi cung lay tu Carry Lookahead Logic
    assign C4 = C[4];

endmodule
