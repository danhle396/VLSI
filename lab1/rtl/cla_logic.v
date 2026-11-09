//=============================================================================
// Lab 1 : Carry Lookahead Logic (Generate, Propagate, Carry)
//
// Day la khoi mau xam trong so do khoi CLA 4-bit. No nhan TAT CA cac bit
// dau vao Ai, Bi cung voi carry ban dau C0, roi sinh ra cac tin hieu carry
// C1, C2, C3, C4 cap cho 4 Full Adder tuong ung.
//
// Voi moi bit i:
//   Gi = AiBi           (Generate - tu sinh carry)
//   Pi = Ai XOR Bi      (Propagate - truyen carry tu duoi len)
//
// Cong thuc carry tong quat:
//   Ci+1 = Gi + PiCi
//
// Khai trien cho CLA 4-bit (loai bo phu thuoc tuan tu):
//   C1 = G0 + P0C0
//   C2 = G1 + P1G0 + P1P0C0
//   C3 = G2 + P2G1 + P2P1G0 + P2P1P0C0
//   C4 = G3 + P3G2 + P3P2G1 + P3P2P1G0 + P3P2P1P0C0
//
// Moi carry chi la ham 2 muc AND-OR cua dau vao -> tinh SONG SONG,
// do tre khong phu thuoc so bit.
//=============================================================================
`timescale 1ns/1ns

module cla_logic (
    input  wire [3:0] A,        // toan hang A3A2A1A0
    input  wire [3:0] B,        // toan hang B3B2B1B0
    input  wire       C0,       // carry ban dau
    output wire [3:0] G,        // Generate G3..G0
    output wire [3:0] P,        // Propagate P3..P0
    output wire [4:1] C,        // carry sinh ra C4..C1
    output wire       PG,       // group propagate - de ghep tang
    output wire       GG        // group generate  - de ghep tang
);

    // --- Generate va Propagate cho tung bit ---
    assign G = A & B;           // Gi = AiBi
    assign P = A ^ B;           // Pi = Ai XOR Bi

    // --- Mang look-ahead: tinh C1..C4 song song ---
    assign C[1] = G[0] | (P[0] & C0);

    assign C[2] = G[1] | (P[1] & G[0])
                       | (P[1] & P[0] & C0);

    assign C[3] = G[2] | (P[2] & G[1])
                       | (P[2] & P[1] & G[0])
                       | (P[2] & P[1] & P[0] & C0);

    assign C[4] = G[3] | (P[3] & G[2])
                       | (P[3] & P[2] & G[1])
                       | (P[3] & P[2] & P[1] & G[0])
                       | (P[3] & P[2] & P[1] & P[0] & C0);

    // --- Tin hieu nhom, dung khi ghep nhieu khoi CLA (xem cla_16bit.v) ---
    assign PG = &P;                             // P3P2P1P0
    assign GG = G[3] | (P[3] & G[2])
                     | (P[3] & P[2] & G[1])
                     | (P[3] & P[2] & P[1] & G[0]);

endmodule
