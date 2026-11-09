//=============================================================================
// Lab 2 : JK Flip-Flop, kich canh len clk
//
// JK Flip-Flop la mach logic tuan tu dung de luu tru 1 bit du lieu. No co
// 2 ngo vao dieu khien J (Set) va K (Reset), 1 ngo vao Clock (CLK), va
// 2 ngo ra bu nhau Q va Q_bar.
//
// JK Flip-Flop hoat dong dua tren gia tri cua J va K tai canh clock tich cuc.
// Khi J=0 va K=0, ngo ra giu nguyen trang thai truoc do. Khi J=1 va K=0,
// ngo ra duoc dat len 1. Khi J=0 va K=1, ngo ra duoc dat ve 0. Khi J=1 va
// K=1, ngo ra dao sang trang thai nguoc lai (toggle).
//
// Bieu thuc Boolean:  Q(next) = J.Q_bar + K_bar.Q
//
// Bang su that:
//   J K | Q(next) | Operation
//   0 0 |    Q    | No change (giu nguyen)
//   0 1 |    0    | Reset
//   1 0 |    1    | Set
//   1 1 |  Q_bar  | Toggle (dao trang thai)
//
// JK khac phuc nhuoc diem cua SR: to hop J=K=1 khong con la trang thai cam
// ma duoc dinh nghia lai thanh toggle. Nho vay JK dung duoc lam bo dem.
//=============================================================================
`timescale 1ns/1ns

module jk_ff (
    input  wire clk,        // Clock
    input  wire rst,        // Reset bat dong bo, tich cuc muc cao
    input  wire j,          // Set input
    input  wire k,          // Reset input
    output reg  q,          // Ngo ra Q
    output wire q_bar       // Ngo ra bu Q_bar
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else begin
            case ({j, k})
                2'b00: q <= q;      // No change
                2'b01: q <= 1'b0;   // Reset
                2'b10: q <= 1'b1;   // Set
                2'b11: q <= ~q;     // Toggle
            endcase
        end
    end

    assign q_bar = ~q;

endmodule
