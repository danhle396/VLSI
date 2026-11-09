//=============================================================================
// Lab 1 : Full Adder (bo cong day du 1 bit)
//
// Day la khoi co so trong so do khoi CLA 4-bit: mach gom
// 4 Full Adder + 1 khoi Carry Lookahead Logic.
//
// Bang su that:
//   Ai Bi Ci | Si  Ci+1
//    0  0  0 |  0    0
//    0  0  1 |  1    0
//    0  1  0 |  1    0
//    0  1  1 |  0    1
//    1  0  0 |  1    0
//    1  0  1 |  0    1
//    1  1  0 |  0    1
//    1  1  1 |  1    1
//
// Bieu thuc Boolean:
//   Si   = Ai XOR Bi XOR Ci
//   Ci+1 = AiBi + Ci(Ai XOR Bi)
//
// Luu y: trong kien truc CLA, carry Ci KHONG lay tu Full Adder tang truoc
// ma lay truc tiep tu khoi Carry Lookahead Logic. Vi vay ngo ra cout cua
// Full Adder o day khong duoc su dung - carry da duoc tinh truoc.
//=============================================================================
`timescale 1ns/1ns

module full_adder (
    input  wire A,      // bit thu i cua toan hang A
    input  wire B,      // bit thu i cua toan hang B
    input  wire C,      // carry vao Ci (tu Carry Lookahead Logic)
    output wire S,      // bit tong Si
    output wire Cout    // carry ra Ci+1 (khong dung trong CLA)
);

    // Si = Ai XOR Bi XOR Ci
    assign S    = A ^ B ^ C;

    // Ci+1 = AiBi + Ci(Ai XOR Bi)
    assign Cout = (A & B) | (C & (A ^ B));

endmodule
