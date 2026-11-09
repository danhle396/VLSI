# Lab 1 — Carry Lookahead Adder (CLA)

Môn: VLSI Design Lab — VKU
Nội dung: Thiết kế và mô phỏng bộ cộng Carry Lookahead 4-bit.

## 1. Cơ sở lý thuyết

Carry Lookahead Adder (CLA) là bộ cộng nhị phân tốc độ cao, được thiết kế để
giảm độ trễ gây ra bởi sự lan truyền carry. Khác với Ripple Carry Adder — nơi
tín hiệu carry lan truyền tuần tự từ Full Adder này sang Full Adder kế tiếp —
CLA tính toán các tín hiệu carry **trước**.

### Sơ đồ khối CLA 4-bit

```
     A3 B3        A2 B2        A1 B1        A0 B0
      |  |         |  |         |  |         |  |
      v  v         v  v         v  v         v  v
   +------+ C3  +------+ C2  +------+ C1  +------+ C0
   | Full |<--  | Full |<--  | Full |<--  | Full |<--+
   |Adder |     |Adder |     |Adder |     |Adder |   |
   +------+     +------+     +------+     +------+   |
      |            |            |            |       |
      v            v            v            v       |
      S3           S2           S1           S0      |
                                                     |
  C4  +-------------------------------------------+  |
  <---|         Carry Lookahead Logic             |<-+
      |       (Generate, Propagate, Carry)        |
      +-------------------------------------------+
        ^  ^     ^  ^     ^  ^     ^  ^
        A3 B3    A2 B2    A1 B1    A0 B0
```

Mạch gồm **4 Full Adder** và **1 khối Carry Lookahead Logic**.

Hai toán hạng 4-bit đầu vào là A₃A₂A₁A₀ và B₃B₂B₁B₀, với C₀ là carry ban đầu.

Mỗi Full Adder chịu trách nhiệm tính một bit của tổng cuối cùng. Bốn Full Adder
tạo ra các ngõ ra S₀, S₁, S₂ và S₃.

Khối Carry Lookahead Logic nhận tất cả các bit đầu vào Aᵢ và Bᵢ, cùng với carry
ban đầu C₀. Nó sinh ra các tín hiệu carry C₁, C₂, C₃ và C₄, được cấp cho các
Full Adder tương ứng.

Ngõ ra cuối cùng gồm bốn bit tổng S₃S₂S₁S₀ và carry ra cuối cùng C₄.

Ưu điểm chính của kiến trúc này là các tín hiệu carry được **tính toán trước**
thay vì lan truyền tuần tự qua các Full Adder. Do đó, Carry Lookahead Adder đạt
được tốc độ hoạt động cao hơn Ripple Carry Adder thông thường.

### Biểu thức Boolean

Với mỗi bit i, tín hiệu Generate và Propagate được định nghĩa:

```
Gᵢ = AᵢBᵢ
Pᵢ = Aᵢ ⊕ Bᵢ
```

Tín hiệu carry được tính bằng:

```
Cᵢ₊₁ = Gᵢ + PᵢCᵢ
```

Với CLA 4-bit, các tín hiệu carry được khai triển như sau:

```
C₁ = G₀ + P₀C₀
C₂ = G₁ + P₁G₀ + P₁P₀C₀
C₃ = G₂ + P₂G₁ + P₂P₁G₀ + P₂P₁P₀C₀
C₄ = G₃ + P₃G₂ + P₃P₂G₁ + P₃P₂P₁G₀ + P₃P₂P₁P₀C₀
```

Ngõ ra tổng của mỗi bit:

```
Sᵢ = Aᵢ ⊕ Bᵢ ⊕ Cᵢ
```

Do đó:

```
S₀ = A₀ ⊕ B₀ ⊕ C₀
S₁ = A₁ ⊕ B₁ ⊕ C₁
S₂ = A₂ ⊕ B₂ ⊕ C₂
S₃ = A₃ ⊕ B₃ ⊕ C₃
```

Các biểu thức Boolean này cho phép khối Carry Lookahead Logic tính toán các tín
hiệu carry trước, giảm độ trễ lan truyền carry và cải thiện tốc độ của bộ cộng
4-bit.

### Bảng sự thật Full Adder

| Aᵢ | Bᵢ | Cᵢ | Sᵢ | Cᵢ₊₁ |
|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 0 |
| 0 | 1 | 0 | 1 | 0 |
| 0 | 1 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 1 | 0 | 1 |
| 1 | 1 | 0 | 0 | 1 |
| 1 | 1 | 1 | 1 | 1 |

## 2. Cấu trúc thư mục

```
lab1/
├── rtl/
│   ├── full_adder.v      Full Adder 1 bit
│   ├── cla_logic.v       Carry Lookahead Logic (Generate, Propagate, Carry)
│   └── cla_4bit.v        CLA 4-bit = 4 Full Adder + 1 CLA Logic
├── tb/
│   └── cla_4bit_tb.v     testbench, 5 test case
├── sim/
│   └── run.bat           script chạy
└── README.md
```

Cấu trúc RTL ánh xạ 1-1 với sơ đồ khối: `full_adder.v` là bốn khối Full Adder,
`cla_logic.v` là khối Carry Lookahead Logic, `cla_4bit.v` nối chúng lại.

Trong `cla_4bit.v`, các Full Adder nhận carry **trực tiếp từ khối Carry Lookahead
Logic**, không lấy từ Full Adder tầng trước. Vì vậy ngõ ra `Cout` của Full Adder
không được sử dụng — carry đã được tính trước.

## 3. Cách chạy

```
cd sim
run.bat            REM biên dịch và chạy mô phỏng
run.bat wave       REM chạy rồi mở GTKWave
run.bat clean      REM dọn dẹp
```

Hoặc gõ tay:

```
iverilog -g2005 -Wall -s cla_4bit_tb -o sim.vvp ..\rtl\full_adder.v ..\rtl\cla_logic.v ..\rtl\cla_4bit.v ..\tb\cla_4bit_tb.v
vvp sim.vvp
gtkwave wave.vcd
```

## 4. Kết quả mô phỏng

```
==========================================================================
| # | C0 |  A (bin|dec)  |  B (bin|dec)  | C4 | S(dec) | Exp | Status |
==========================================================================
| 1 |  0 | 0000 ( 0) | 0000 ( 0) |  0 |   0    |   0 | PASS |
| 2 |  1 | 0011 ( 3) | 0100 ( 4) |  0 |   8    |   8 | PASS |
| 3 |  0 | 0101 ( 5) | 0110 ( 6) |  0 |  11    |  11 | PASS |
| 4 |  0 | 0111 ( 7) | 1000 ( 8) |  0 |  15    |  15 | PASS |
| 5 |  1 | 1111 (15) | 1111 (15) |  1 |  15    |  31 | PASS |
==========================================================================
```

Kết quả mô phỏng của CLA 4-bit. Cả năm test case đều PASS, xác nhận rằng các ngõ
ra tổng và carry-out là chính xác.

**Test Case 1–4 (Phép toán chuẩn):** Các trường hợp này đánh giá phép cộng thông
thường không có tràn carry-out (C₄ = 0). Mạch tính chính xác các tổng từ 0 đến
giá trị lớn nhất của 4 bit là 15 (7 + 8 + 0), xác nhận hoạt động bình thường của
bộ cộng qua nhiều tổ hợp đầu vào khác nhau.

**Test Case 5 (Tràn và biên lớn nhất):** Trường hợp này kiểm tra tình huống cộng
lớn nhất (15 + 15 + 1 = 31). Logic CLA khẳng định thành công tín hiệu carry-out
(C₄ = 1) đồng thời đặt ngõ ra tổng S = 15 (1111 nhị phân), chứng minh khả năng
phát hiện tràn và lan truyền carry lookahead chính xác.

### Quan sát dạng sóng

Mở `run.bat wave`, các tín hiệu nên đưa vào khung sóng: `A[3:0]`, `B[3:0]`,
`C0`, `C4`, `C[4:1]`, `G[3:0]`, `P[3:0]`, `S[3:0]`.

Các tín hiệu `G`, `P`, `C` được đưa ra cổng của `cla_4bit` chính là để quan sát
được trên waveform — nhờ đó thấy rõ cơ chế Generate/Propagate sinh carry.

Chuột phải lên tín hiệu → `Data Format` → `Hex` hoặc `Decimal` để đổi hệ cơ số.

## 5. Ghi chú về công cụ

Slide lab yêu cầu Xilinx Vivado. Ở đây dùng **Icarus Verilog 0.9.7 + GTKWave** vì
nhẹ và chạy dòng lệnh; RTL viết bằng Verilog-2001 thuần nên nạp thẳng vào Vivado
được, không cần sửa.

Lưu ý bản Icarus 0.9.7 khá cũ: chỉ hỗ trợ tới `-g2005`, không dùng được `.*`
trong khai báo instance và không lồng được `-f` file list.
