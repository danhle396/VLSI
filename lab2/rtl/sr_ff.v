//=============================================================================
// Lab 2 : SR Flip-Flop (Set-Reset), kich canh len clk
//
// SR Flip-Flop la mach logic tuan tu co ban dung de luu tru 1 bit thong tin.
// No co 2 ngo vao dieu khien Set (S) va Reset (R), cung 2 ngo ra bu nhau
// Q va Q_bar.
//
// Ngo vao S dung de dat ngo ra Q len muc logic 1, con ngo vao R dat Q ve
// muc logic 0. Khi ca S va R deu khong tich cuc, mach giu nguyen trang thai
// truoc do. Truong hop ca S va R cung tich cuc duoc coi la trang thai khong
// hop le (invalid state) trong SR Flip-Flop co ban.
//
// Bieu thuc Boolean:  Q(next) = S + R_bar.Q
//
// Bang su that:
//   S R | Q(next) | Mo ta
//   0 0 |    Q    | Hold / No change (giu nguyen)
//   0 1 |    0    | Reset
//   1 0 |    1    | Set
//   1 1 |    X    | Invalid state (trang thai khong hop le)
//
// Luu y ve mo hinh hoa: to hop S=R=1 duoc gan 1'bx thay vi gan bua mot gia
// tri cu the. Day la cach lam dung trong verification - neu thiet ke cap tren
// vo tinh tao ra to hop nay, gia tri x se lan truyen va lam lo loi ngay trong
// mo phong. Neu gan bua 1'b1 thi loi bi che giau.
//=============================================================================
`timescale 1ns/1ns

module sr_ff (
    input  wire clk,        // Clock
    input  wire rst,        // Reset bat dong bo, tich cuc muc cao
    input  wire s,          // Set input
    input  wire r,          // Reset input
    output reg  q,          // Ngo ra Q
    output wire q_bar       // Ngo ra bu Q_bar
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else begin
            case ({s, r})
                2'b00: q <= q;      // Hold / No change
                2'b01: q <= 1'b0;   // Reset
                2'b10: q <= 1'b1;   // Set
                2'b11: q <= 1'bx;   // Invalid state
            endcase
        end
    end

    assign q_bar = ~q;

endmodule
