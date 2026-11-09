# Lab 2 — Flip-Flops: SR, D, JK

Môn: VLSI Design Lab — VKU
Nội dung: Thiết kế và mô phỏng ba loại flip-flop SR, D, JK.

## I. Cơ sở lý thuyết

### SR Flip-Flop

```
              ┌───────────────┐
         ──── S      PR       │
              │               ├──── Q
              │      SR       │
         ──── CLK   FLIP      │
              │     FLOP      ├──── Q'
         ──── R               │
              │      CLR      │
              └───────────────┘
```

SR Flip-Flop (Set-Reset Flip-Flop) là mạch logic tuần tự cơ bản dùng để lưu trữ
một bit thông tin. Nó có hai ngõ vào điều khiển là Set (S) và Reset (R), cùng
hai ngõ ra bù nhau là Q và Q̅.

Ngõ vào S dùng để đặt ngõ ra Q lên mức logic 1, trong khi ngõ vào R đặt Q về mức
logic 0. Khi cả S và R đều không tích cực, mạch duy trì trạng thái trước đó.
Điều kiện mà cả S và R cùng tích cực đồng thời được coi là **trạng thái không
hợp lệ (invalid state)** trong SR Flip-Flop cơ bản.

**Biểu thức Boolean:** Q(next) = S + R̅Q

- S: Set input
- R: Reset input
- Q: Trạng thái trước đó (previous state)
- Q(next): Trạng thái kế tiếp sau cạnh clock tích cực

| S | R | Q (Next State) | Description |
|---|---|---|---|
| 0 | 0 | Q | Hold / No change |
| 0 | 1 | 0 | Reset |
| 1 | 0 | 1 | Set |
| 1 | 1 | X | Invalid state |

### D Flip-Flop

```
              ┌───────────────┐
         ──── D      PR       │
              │               ├──── Q
              │      D        │
              │     FLIP      │
         ──── CLK   FLOP      ├──── Q'
              │      CLR      │
              └───────────────┘
```

D Flip-Flop (Data Flip-Flop) là mạch logic tuần tự dùng để lưu trữ một bit dữ
liệu. Nó có một ngõ vào dữ liệu D, một ngõ vào Clock (CLK), và hai ngõ ra bù
nhau Q và Q̅. Giá trị của D được chuyển sang Q tại cạnh tích cực của tín hiệu
clock. Khi không có cạnh clock tích cực, Flip-Flop duy trì trạng thái trước đó.

**Biểu thức Boolean:** Q(next) = D

- D: Data input
- Q: Trạng thái trước đó
- Q(next): Trạng thái kế tiếp sau cạnh clock tích cực

| CLK | D | Q(next) | Q̅(next) |
|---|---|---|---|
| ↑ | 0 | 0 | 1 |
| ↑ | 1 | 1 | 0 |
| Không có cạnh tích cực | X | Q | Q̅ |

### JK Flip-Flop

```
              ┌───────────────┐
         ──── J      PR       │
              │               ├──── Q
              │      JK       │
         ──── CLK   FLIP      │
              │     FLOP      ├──── Q'
         ──── K               │
              │      CLR      │
              └───────────────┘
```

JK Flip-Flop là mạch logic tuần tự dùng để lưu trữ một bit dữ liệu. Nó có hai
ngõ vào điều khiển J (Set) và K (Reset), một ngõ vào Clock (CLK), và hai ngõ ra
bù nhau Q và Q̅.

JK Flip-Flop hoạt động dựa trên giá trị của J và K tại cạnh clock tích cực. Khi
J = 0 và K = 0, ngõ ra giữ nguyên trạng thái trước đó. Khi J = 1 và K = 0, ngõ ra
được đặt lên 1. Khi J = 0 và K = 1, ngõ ra được đặt về 0. Khi J = 1 và K = 1, ngõ
ra đảo sang trạng thái ngược lại (toggle).

**Biểu thức Boolean:** Q(next) = JQ̅ + K̅Q

- J: Set input
- K: Reset input
- Q: Trạng thái trước đó
- Q(next): Trạng thái kế tiếp sau cạnh clock tích cực

| J | K | Q(next) | Operation |
|---|---|---|---|
| 0 | 0 | Q | No change |
| 0 | 1 | 0 | Reset |
| 1 | 0 | 1 | Set |
| 1 | 1 | Q̅ | Toggle |

JK khắc phục nhược điểm của SR: tổ hợp `J=K=1` không còn là trạng thái cấm mà
được định nghĩa lại thành **toggle**. So sánh ba hàng đầu của hai bảng sẽ thấy
chúng giống hệt nhau — JK chỉ khác SR ở hàng cuối.

## II. Cấu trúc thư mục

```
lab2/
├── rtl/
│   ├── sr_ff.v          SR flip-flop
│   ├── d_ff.v           D  flip-flop
│   └── jk_ff.v          JK flip-flop
├── tb/
│   └── testbench.v      testbench chung cho cả ba flip-flop
├── sim/
│   └── run.bat          script chạy
└── README.md
```

Cả ba flip-flop dùng chung giao diện: `clk`, `rst` (reset bất đồng bộ, tích cực
mức cao), ngõ ra `q` và `q_bar`.

## III. Cách chạy

```
cd sim
run.bat            REM biên dịch và chạy mô phỏng
run.bat wave       REM chạy rồi mở GTKWave
run.bat clean      REM dọn dẹp
```

Hoặc gõ tay:

```
iverilog -g2005 -Wall -s testbench -o sim.vvp ..\rtl\sr_ff.v ..\rtl\d_ff.v ..\rtl\jk_ff.v ..\tb\testbench.v
vvp sim.vvp
gtkwave wave.vcd
```

## IV. Kết quả mô phỏng

```
=================== 1. SR FLIP-FLOP ===================
 Time  | RST | S | R |  Q  | Q_bar
-------------------------------------------------------
 16 ns |  0  | 1 | 0 |  1  |   0
 26 ns |  0  | 0 | 0 |  1  |   0
 36 ns |  0  | 0 | 1 |  0  |   1

=================== 2. D FLIP-FLOP ====================
 Time  | RST | D |  Q  | Q_bar
-------------------------------------------------------
 46 ns |  0  | 1 |  1  |   0
 56 ns |  0  | 0 |  0  |   1

=================== 3. JK FLIP-FLOP ===================
 Time  | RST | J | K |  Q  | Q_bar
-------------------------------------------------------
 66 ns |  0  | 1 | 0 |  1  |   0
 76 ns |  0  | 0 | 1 |  0  |   1
 86 ns |  0  | 1 | 1 |  1  |   0
 96 ns |  0  | 1 | 1 |  0  |   1
=======================================================
```

Kết quả mô phỏng chứng minh hoạt động đúng của ba mạch flip-flop SR, D và JK.

Với **SR Flip-Flop**, khi S = 1 và R = 0, ngõ ra được đặt lên Q = 1. Khi cả hai
ngõ vào không tích cực (S = 0, R = 0), trạng thái trước đó được duy trì. Khi
S = 0 và R = 1, ngõ ra được đặt về Q = 0.

Với **D Flip-Flop**, ngõ ra bám theo giá trị của ngõ vào dữ liệu tại cạnh clock
tích cực. Kết quả cho thấy Q = 1 khi D = 1 và Q = 0 khi D = 0, xác nhận biểu
thức đặc tính Q(next) = D.

Với **JK Flip-Flop**, mô phỏng xác nhận các thao tác Set, Reset và Toggle. Khi
J = 1 và K = 0, ngõ ra được đặt lên 1. Khi J = 0 và K = 1, nó được đặt về 0. Khi
J = K = 1, ngõ ra đảo giữa 1 và 0 tại các cạnh clock liên tiếp.

Như vậy, kết quả mô phỏng nhất quán với các bảng sự thật và biểu thức đặc tính
mong đợi của cả ba mạch flip-flop.

### Quan sát dạng sóng

Mở `run.bat wave`, các tín hiệu nên đưa vào khung sóng: `clk`, `rst`, các ngõ
vào (`s`/`r`, `d`, `j`/`k`), và các ngõ ra `q_sr`/`q_bar_sr`, `q_d`/`q_bar_d`,
`q_jk`/`q_bar_jk`.

## V. Ghi chú về công cụ

Slide lab yêu cầu Xilinx Vivado. Ở đây dùng **Icarus Verilog 0.9.7 + GTKWave**;
RTL viết bằng Verilog-2001 thuần nên nạp thẳng vào Vivado được, không cần sửa.

Trong `sr_ff.v`, tổ hợp invalid `S=R=1` được gán `1'bx` đúng theo bảng sự thật
(Q(next) = X). Nếu mở trong Vivado, synthesis sẽ coi `x` là "don't care" và tự
chọn 0 hoặc 1 tùy tối ưu — đó là hành vi đúng, vì tổ hợp invalid lẽ ra không bao
giờ được xuất hiện trong thiết kế thật.
