//=============================================================================
// Lab 2 : D Flip-Flop (Data Flip-Flop), kich canh len clk
//
// D Flip-Flop la mach logic tuan tu dung de luu tru 1 bit du lieu. No co
// 1 ngo vao du lieu D, 1 ngo vao Clock (CLK), va 2 ngo ra bu nhau Q, Q_bar.
// Gia tri cua D duoc chuyen sang Q tai canh tich cuc cua tin hieu clock.
// Khi khong co canh clock tich cuc, Flip-Flop giu nguyen trang thai truoc do.
//
// Bieu thuc Boolean:  Q(next) = D
//
// Bang su that:
//   CLK            | D | Q(next) | Q_bar(next)
//   canh len       | 0 |    0    |      1
//   canh len       | 1 |    1    |      0
//   khong co canh  | X |    Q    |    Q_bar
//
// Day la flip-flop duoc dung nhieu nhat trong thiet ke so thuc te: khong co
// trang thai cam, va anh xa thang 1-1 sang phan tu thu vien khi tong hop.
// Moi thanh ghi, bo dem, FSM deu xay tu D-FF.
//=============================================================================
`timescale 1ns/1ns

module d_ff (
    input  wire clk,        // Clock
    input  wire rst,        // Reset bat dong bo, tich cuc muc cao
    input  wire d,          // Data input
    output reg  q,          // Ngo ra Q
    output wire q_bar       // Ngo ra bu Q_bar
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;         // Q(next) = D
    end

    assign q_bar = ~q;

endmodule
