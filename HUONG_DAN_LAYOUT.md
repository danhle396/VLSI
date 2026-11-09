# Hướng dẫn phần Layout – DRC – LVS – Post-layout (Lab 3, 4, 5)

Tài liệu này mô tả ba bước tiếp theo sau schematic, theo đề mục "Semi custom
design" của file đề: **Layout design**, **Verification layout design**
(DRC + LVS) và **Simulation post layout**.

```
Schematic (xschem) ─► Layout (Magic) ─► DRC ─► LVS (Netgen) ─► Trích ký sinh ─► Mô phỏng post-layout
```

## 1. Công cụ

| Công cụ | Vai trò | Vị trí |
|---|---|---|
| **Magic 8.3.684** | Vẽ layout, DRC, trích netlist có ký sinh | Cygwin: `/usr/local/bin/magic` |
| **Netgen 1.5.323** | So sánh layout với schematic (LVS) | Cygwin: `/usr/local/bin/netgen` |
| xschem | Sinh netlist schematic cho LVS | Cygwin |
| Python `gdstk` | Vẽ ảnh layout từ file GDS | Python Windows |
| ngspice | Mô phỏng post-layout | `C:\Spice64` |

Magic và Netgen được biên dịch từ mã nguồn trên Cygwin (không cần quyền
admin). Luật thiết kế lấy từ PDK SKY130:
`libs.tech/magic/sky130A.tech` và `libs.tech/netgen/sky130A_setup.tcl`.

## 2. Chạy toàn bộ luồng

Mỗi lab có thư mục `labN/layout/`. Nhấp đúp hoặc chạy:

```
cd lab3\layout
run_layout.bat
```

Script chạy 5 bước:

| Bước | Công cụ | Làm gì | Kết quả |
|---|---|---|---|
| 1 | Magic | Dựng layout từ script `*_layout.tcl`, chạy DRC (bộ luật `drc(full)`), trích netlist | `*.mag`, `*.gds`, `*_lvs.spice`, `*_pex.spice`, `magic.log` |
| 2 | xschem | Sinh netlist schematic ở chế độ LVS | `*_sch.spice` |
| 3 | Netgen | So `*_lvs.spice` với `*_sch.spice` | `*_lvs_report.txt` |
| 4 | Python | Tạo netlist post-layout, vẽ ảnh layout | `*_post.spice`, `*_dev.spice`, `*_layout.png` |
| 5 | ngspice | Chạy `tb/tb_post.sp` | `sim/post.dat` |

Kết quả mong đợi: `DRC_COUNT 0` và `Final result: Circuits match uniquely.`

Mở layout trong giao diện Magic: nhấp đúp `open_magic.bat` (có thể truyền tên
cell, ví dụ `open_magic.bat tgate` trong Lab 5).

## 3. Cách dựng layout

Layout được **dựng bằng script Tcl của Magic** (`labN/layout/*_layout.tcl`),
mỗi dòng `rect <lớp> x1 y1 x2 y2` vẽ một hình chữ nhật (đơn vị µm). Cách này
giúp tọa độ chính xác, dễ kiểm tra và chạy lại được; kết quả vẫn là file layout
Magic chuẩn (`.mag`, `.gds`) mở và sửa được trong giao diện.

Các lớp SKY130 được dùng:

| Lớp (Magic) | Ý nghĩa |
|---|---|
| `nwell` | Giếng N chứa PMOS |
| `ndiff`, `pdiff` | Vùng khuếch tán N / P (source, drain). Poly cắt qua diff tạo transistor |
| `poly` | Cực cổng (gate). Bề rộng poly = L = 0.15 µm |
| `ndiffc`, `pdiffc`, `polycont` | Tiếp điểm (licon) từ diff / poly lên li |
| `psubdiff`, `nsubdiff` (+ `…cont`) | Tap nối thân: substrate → vss, nwell → vdd |
| `locali` (li1) | Lớp kim loại cục bộ, nối trong cell |
| `viali` (mcon) | Via từ li lên metal1 |
| `metal1` | Ray nguồn vdd/vss, dây dọc (stub) |
| `via1`, `metal2` | Dây ngang nối giữa các cell (Lab 5) |

Bố cục kiểu **standard cell**: ray `vss` (metal1) ở dưới, ray `vdd` ở trên,
NMOS ở nửa dưới, PMOS trong nwell ở nửa trên, gate là đường poly dọc.

Một số luật DRC chính được tuân thủ (µm):

| Luật | Giá trị |
|---|---|
| Poly rộng tối thiểu (L) | 0.15 |
| Poly nhô ra ngoài diff (endcap) | 0.13 |
| Tiếp điểm licon / mcon | 0.17 × 0.17 |
| Khoảng cách licon đến gate | ≥ 0.055 |
| li trùm tiếp điểm theo một phương | ≥ 0.08 (luật li.5) |
| nwell bao pdiff | ≥ 0.18 |
| nwell cách ndiff | ≥ 0.34 |
| via1 (vẽ trong Magic) | ≥ 0.26 × 0.26 |
| Diện tích tối thiểu metal1 / metal2 | 0.083 / 0.0676 µm² |

## 4. DRC – Design Rule Check

Kiểm tra layout có vi phạm luật chế tạo không (độ rộng, khoảng cách, độ bao
tối thiểu giữa các lớp). Script gọi `drc style drc(full)` rồi `drc check`, in ra
`DRC_COUNT` và lý do từng lỗi (`DRC_WHY`).

Ví dụ lỗi đã gặp khi dựng inverter: *"Local interconnect overlap of diffusion
contact < 0.08um in one direction (li.5)"* – dải li bằng khít đầu tiếp điểm.
Sửa bằng cách kéo dài li thêm 0.08 µm ở hai đầu.

## 5. LVS – Layout Versus Schematic

1. Magic **trích netlist từ layout** (`ext2spice lvs`): nhận ra transistor tại
   chỗ poly cắt diff, đo W/L từ hình, dò kết nối qua các lớp kim loại và via.
2. Netgen so netlist đó với netlist schematic theo **cấu trúc mạch** (đồ thị):
   số và loại linh kiện, kết nối, W/L, danh sách chân. Tên nút nội bộ không cần
   giống nhau (ví dụ nút n1 của NAND được Magic đặt tên `a_170_120#`).
3. Lab 5 là LVS **phân cấp**: Netgen so từng cell con (`inv`, `tgate`) rồi mới
   so cell `dff`.

Kết quả "Circuits match uniquely" nghĩa là layout đúng là mạch trong schematic.

## 6. Mô phỏng post-layout

`ext2spice cthresh 0` xuất netlist có **tụ ký sinh** giữa các net (tụ dây nối,
tụ giữa các lớp). Testbench `tb/tb_post.sp` mô phỏng **cùng lúc 3 phiên bản**
với cùng kích thích và tải:

| Phiên bản | Netlist | Ý nghĩa |
|---|---|---|
| `pre` | `netlist/*.spice` (schematic) | Kết quả trước layout |
| `dev` | `layout/*_dev.spice` | Chỉ transistor trích từ layout (diện tích S/D thật), bỏ tụ dây |
| `post` | `layout/*_post.spice` | Transistor + tụ ký sinh của layout |

- **dev so với pre**: khác do cách mô hình transistor. Netlist schematic có
  ước lượng điện trở vùng khuếch tán `nrd/nrs = 0.29/W` và diện tích S/D ước
  lượng; Magic không xuất `nrd/nrs` và đo diện tích S/D thật (có dùng chung
  diffusion, ví dụ drain chung của 2 PMOS trong NAND).
- **post so với dev**: phần chậm đi **thực sự do ký sinh của layout**.

Lưu ý: Magic chỉ trích tụ ký sinh; điện trở dây không được trích (các dây rất
ngắn, điện trở nhỏ).
