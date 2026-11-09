# Ôn tập trắc nghiệm VLSI (tiếng Anh)

Nguồn: giáo trình **CMOS VLSI Design – Weste & Harris, 4th ed.** (`CMOS-VLSI.pdf`,
ghi số mục trong ngoặc, ví dụ *§2.4*) và project Lab 1–5 của bạn.

Cách dùng:
1. Đọc lần lượt 16 mảng, chú ý **thuật ngữ in đậm** (đề sẽ dùng đúng các từ này).
2. Học kỹ phần **Bẫy thường gặp** ở cuối mỗi mảng và mục 17.
3. Làm 50 câu ở mục 19, rồi so đáp án ở mục 20.

Mức ưu tiên: ★★★ gần như chắc chắn có · ★★ nên học · ★ đọc qua.

---

## 1. Lịch sử và khái niệm chung ★★ (§1.1)

| Sự kiện | Chi tiết |
|---|---|
| 1947 | **Transistor** tiếp điểm đầu tiên – Bardeen & Brattain, Bell Labs (Nobel 1956 cùng Shockley) |
| 1958 | **Integrated circuit (IC)** đầu tiên – Jack Kilby, Texas Instruments (Nobel 2000) |
| 1963 | Frank Wanlass (Fairchild) – cổng logic dùng cả nMOS và pMOS → **CMOS** |
| 1965 | **Moore's Law**: số transistor trên chip tăng gấp đôi định kỳ (lúc đầu ~18 tháng; CPU Intel thực tế ~26 tháng) |
| 1974 | **Dennard scaling**: transistor nhỏ đi thì nhanh hơn, ít tốn điện hơn, rẻ hơn |
| ~2004 | **Power wall**: tần số dừng quanh ~3 GHz, chuyển sang **multicore** |

- Cấp độ tích hợp: **SSI** < 10 cổng · **MSI** ≤ 1 000 · **LSI** ≤ 10 000 · **VLSI** từ thập niên 1980.
- **Feature size** = chiều dài kênh nhỏ nhất làm được. Mỗi **technology node** (2–3 năm) nhỏ hơn
  ~30 % → mật độ gấp đôi (ví dụ 180 → 130 → 90 → 65 → 45 nm).
- MOSFET thắng bipolar vì cổng **gần như không lấy dòng khi đứng yên**; CMOS thắng nMOS vì
  **không tiêu thụ công suất tĩnh**.
- Ở node nhỏ (< 180 nm), transistor **rò (leak)** đáng kể khi OFF → có công suất tĩnh.

---

## 2. Bán dẫn và MOSFET ★★★ (§1.3, §2.1–2.2)

**Pha tạp (doping):**
- Nhóm V (**As, P**) = **donor** → dư electron → **n-type**.
- Nhóm III (**B**) = **acceptor** → dư lỗ trống (hole) → **p-type**.
- Tiếp giáp p–n = **diode**: anode (p) cao hơn cathode (n) → **forward bias**, dẫn.

**Cấu tạo MOSFET:** gate (poly/kim loại) – **gate oxide** (SiO₂) – body (substrate). 4 cực:
**gate, source, drain, body**.

| | nMOS | pMOS |
|---|---|---|
| Body | p-type (substrate), nối **GND** | n-type (**n-well**), nối **VDD** |
| Source/drain | n⁺ | p⁺ |
| Hạt dẫn đa số | electron | hole |
| ON khi | gate = 1 (Vgs > Vt) | gate = 0 (Vgs < −\|Vtp\|) |
| Truyền tốt | **strong 0** | **strong 1** |
| Ký hiệu | không bong bóng | **có bong bóng** ở gate |

- Source và drain đối xứng vật lý. Quy ước: **source là cực gần ray nguồn hơn**.
- Trạng thái của cấu trúc MOS (body p): **accumulation** (gate âm) → **depletion** (gate dương nhỏ)
  → **inversion** (gate > Vt, tạo **channel**).

**Ba vùng hoạt động (nMOS)** ★★★

| Vùng | Điều kiện | Dòng Ids |
|---|---|---|
| **Cutoff** | Vgs < Vt | ≈ 0 |
| **Linear** (triode, resistive) | Vgs > Vt, Vds < Vdsat | β(Vgs − Vt − Vds/2)·Vds – như điện trở |
| **Saturation** | Vgs > Vt, Vds > Vdsat | (β/2)(Vgs − Vt)² – như nguồn dòng |

- β = μ·Cox·W/L, **Cox = εox/tox**, **Vdsat = Vgs − Vt** (mô hình Shockley, "square law").
- **Ion** = Ids khi Vgs = Vds = VDD. **Ioff** = Ids khi Vgs = 0, Vds = VDD.
- μn/μp ≈ **2–3** → pMOS cho dòng ≈ ½ nMOS cùng kích thước → **pMOS phải rộng hơn**.

**Bẫy:** nMOS body p-type (không phải n); pMOS nằm trong **n-well**; "pinch-off" xảy ra ở
**saturation**, không phải cutoff.

---

## 3. Hiệu ứng không lý tưởng ★★ (§2.4)

| Hiệu ứng | Nguyên nhân | Hệ quả |
|---|---|---|
| **Velocity saturation** | Trường ngang (Vds/L) lớn | Dòng tăng **chậm hơn bình phương** |
| **Mobility degradation** | Trường dọc (Vgs/tox) lớn | Dòng giảm |
| **Channel length modulation** | Vds tăng → kênh ngắn lại | Ids tăng nhẹ theo Vds trong saturation |
| **Body effect** | Vsb > 0 | **Vt tăng** (làm pass transistor còn tệ hơn) |
| **DIBL** | Vds lớn | **Vt giảm**, rò tăng |
| **Short channel effect** (Vt roll-off) | L rất ngắn | Vt thay đổi theo L |

**Rò rỉ (leakage)** – 3 cơ chế:
1. **Subthreshold leakage** (thường lớn nhất): dòng giảm theo hàm mũ khi Vgs < Vt; giảm
   **10 lần mỗi 60–100 mV** Vgs dưới Vt. Tăng mạnh khi Vt thấp và khi nóng.
2. **Gate leakage**: **tunneling** qua oxide rất mỏng → dùng **high-k dielectric**.
3. **Junction leakage**: qua tiếp giáp p–n phân cực ngược (có BTBT).

**Nhiệt độ:** μ giảm và Vt giảm khi nóng → **Ion giảm (mạch chậm hơn khi nóng)**, **Ioff tăng
theo hàm mũ**. Mạch chạy nhanh nhất ở **điện áp cao, nhiệt độ thấp**.

**Transistor nối tiếp:** 2 nMOS nối tiếp cho **hơn một nửa** dòng của 1 transistor (vì mỗi cái ít
bão hòa vận tốc hơn) → NAND nhanh hơn ước lượng đơn giản.

---

## 4. Logic CMOS tĩnh ★★★ (§1.4)

- **Static CMOS gate** = **pull-down network (PDN)** toàn nMOS + **pull-up network (PUN)** toàn pMOS.
  Với mọi tổ hợp ngõ vào, **đúng một mạng ON**.
- Nối **tiếp (series)** = AND (ON khi tất cả ON). Nối **song song (parallel)** = OR.
- **Conduction complements**: nối tiếp ở PDN ↔ song song ở PUN và ngược lại (De Morgan).
- CMOS tĩnh **luôn đảo (inverting)**. Muốn AND/OR phải thêm inverter hoặc dùng nhiều tầng.

| Cổng | PDN (nMOS) | PUN (pMOS) | Số transistor |
|---|---|---|---|
| INV | 1 | 1 | 2 |
| **k-input NAND** | k **nối tiếp** | k **song song** | 2k |
| **k-input NOR** | k **song song** | k **nối tiếp** | 2k |
| AOI22: Y = (AB + CD)' | (A nt B) // (C nt D) | (A // B) nt (C // D) | 8 |
| OAI31: Y = ((A+B+C)·D)' | D nt (A//B//C) | D // (A nt B nt C) | 8 |

**4 trạng thái ngõ ra** (Bảng 1.3): PUN OFF + PDN OFF = **Z (floating, high impedance)** ·
PUN ON = 1 · PDN ON = 0 · cả hai ON = **X (crowbarred / contention)** – tốn công suất tĩnh.

**Pass transistor & transmission gate (TG)** ★★★
- nMOS truyền **strong 0, weak (degraded) 1** (chỉ lên tới VDD − Vtn).
- pMOS truyền **strong 1, weak 0** (chỉ xuống tới |Vtp|).
- **Transmission gate** = nMOS **song song** pMOS, gate điều khiển bằng g và g̅ (**double rail**)
  → truyền tốt cả 0 và 1. Là mạch **nonrestoring** (nhiễu ở ngõ vào đi thẳng ra ngõ ra).
- **Fully restored logic**: nMOS chỉ kéo xuống, pMOS chỉ kéo lên → mức ra luôn đầy đủ,
  **không phụ thuộc kích thước** (ratioless).
- **Tristate buffer/inverter**: EN = 0 → ngõ ra Z. **Multiplexer** 2:1 bằng 2 TG.
  Ngày nay dùng **mux thay cho tristate bus** (tránh contention/floating).

**Mạch tuần tự** (§1.4.9)
- **D latch**: **level-sensitive** – **transparent** khi CLK = 1 (Q theo D), **opaque** khi CLK = 0.
- **Positive-edge flip-flop** = latch **master** nhạy mức thấp + latch **slave** nhạy mức cao.
  Chép D sang Q ở **cạnh lên**. Còn gọi D flip-flop, master–slave FF, **register** (nhiều bit).
- **Two-phase nonoverlapping clocks** tránh được lỗi hold time.

**Bẫy:** NOR có **pMOS nối tiếp** (chậm) → NAND được ưa dùng hơn. Đếm transistor của cổng
k ngõ vào = **2k**. Đảo ngược nMOS/pMOS để làm cổng không đảo là **sai** (ngõ ra bị suy giảm).

---

## 5. Đặc tuyến DC và noise margin ★★★ (§2.5)

- **VTC** (voltage transfer characteristic): Vout theo Vin. Inverter có 5 vùng A–E; vùng C
  cả 2 transistor bão hòa, độ lợi lớn nhất.
- **Vinv (VM)** = điểm Vin = Vout. Nếu **βp = βn** (và Vtn = |Vtp|) → **VM = VDD/2**.
- **Skewed inverter**: **HI-skew** (pMOS mạnh hơn, β-ratio r > 1) → VM **cao hơn** VDD/2;
  **LO-skew** → VM thấp hơn.
- **VIL, VIH** định nghĩa tại điểm **độ dốc = −1 (unity gain)**. VOL, VOH là ngõ ra tương ứng.
- **NML = VIL − VOL**, **NMH = VOH − VIH**. Vùng giữa VIL và VIH là **forbidden zone**.
- Noise margin nên tính theo **tỉ lệ VDD** (0.4 V tốt ở 1.8 V nhưng kém ở 5 V).
- Khi Vin ở giữa, cả 2 transistor cùng dẫn → **xung dòng từ nguồn** (short-circuit current).

**Project:** inverter SKY130 Wp/Wn = 2.5/1 µm → VM = 0.884 V (VDD/2 = 0.9 V), NML = 0.68 V,
NMH = 0.74 V, độ lợi lớn nhất ≈ 11.5.

---

## 6. Chế tạo (fabrication) ★★ (§1.5, §3.2)

**Wafer:** Si đơn tinh thể kéo bằng **Czochralski method**, đường kính 75–300 mm, dày < 1 mm.

**Các bước (inverter, n-well process):**
1. **Oxidation**: nung 900–1200 °C tạo SiO₂.
2. **Photolithography**: phủ **photoresist** → chiếu UV qua **mask** → **develop** → **etch** oxide
   bằng **HF** → bóc photoresist (**piranha etch**).
3. **Doping**: **diffusion** (lò nung có khí dopant) hoặc **ion implantation** (bắn ion).
4. Tạo **n-well**, rồi **thin gate oxide**, **polysilicon** bằng **CVD** từ khí silane (SiH₄).
5. **n⁺ / p⁺ diffusion**: gate poly che kênh → S/D **tự căn chỉnh (self-aligned process)**.
6. **Field oxide** dày, mở **contact cut**, **sputter** nhôm, **plasma etch** tạo dây kim loại.

- **Positive resist**: vùng bị chiếu sáng **tan** được (độ phân giải cao hơn).
  **Negative resist**: vùng bị chiếu **không tan**.
- **FEOL** (front-end of line) = tạo transistor. **BEOL** (back-end of line) = tạo dây nối.
- Cách ly: **STI** (shallow trench isolation) hiện đại; **LOCOS** cũ (có "bird's beak").
- **Taps**: **substrate tap** (p⁺ nối GND) và **well tap** (n⁺ nối VDD) để tiếp giáp luôn phân
  cực ngược.
- Bộ mask tối thiểu (6): **n-well, polysilicon, n⁺ diffusion, p⁺ diffusion, contact, metal**.
- **Tapeout**: gửi mask cho nhà máy, định dạng **GDSII** (công nghiệp) hoặc **CIF** (học thuật).
- **Foundry** (TSMC, UMC…) sản xuất cho công ty **fabless**. **MOSIS** gom nhiều thiết kế nhỏ lên
  một bộ mask (**multi-project wafer**).
- Chi phí chip tỉ lệ với **diện tích**, không phải số transistor.

---

## 7. Layout và design rules ★★★ (§1.5.3–1.5.5, §3.3)

- **Design rules**: độ rộng tối thiểu, khoảng cách tối thiểu, độ chồng/bao tối thiểu giữa các lớp.
  Là thỏa hiệp giữa **hiệu năng và yield**.
- **λ (lambda) rules** (Mead & Conway, MOSIS): **λ = ½ feature size** (180 nm → λ = 0.09 µm).
  Scalable nhưng bảo thủ; công nghiệp dùng luật tính bằng µm.

| Luật MOSIS (λ) | Giá trị |
|---|---|
| Metal, diffusion: width / spacing | **4λ** |
| Contact | **2λ × 2λ**, bao quanh 1λ |
| Poly width | **2λ** |
| Poly vượt qua diffusion (tạo transistor) | 2λ; cách diff 1λ nếu không tạo transistor |
| Poly/contact spacing | 3λ |
| n-well bao pMOS / cách nMOS | 6λ / 6λ |

- **Transistor = nơi poly cắt ngang active (diffusion)**. Poly phải **vượt qua hẳn** active
  (gate extension), nếu không S và D bị nối tắt.
- **W/L**: unit transistor **4λ/2λ**. pMOS thường rộng gấp ~2 lần.
- **Standard cell style**: ray GND (metal) dưới, n-diff, p-diff, ray VDD trên; **poly chạy dọc**;
  tap nằm dưới ray. Các cell ghép sát nhau (**abutment**).
- **Stick diagram**: sơ đồ layout không theo tỉ lệ để ước lượng diện tích. **Track pitch = 8λ**
  (dây 4λ + khoảng cách 4λ); giữa nMOS và pMOS cần 12λ.
- **Latchup** (§7.3.6): **SCR ký sinh** (npn + pnp) tạo đường ngắn mạch VDD–GND. Chống bằng
  **tap gần transistor**, **guard ring**, lớp epitaxial. **SOI** và VDD < ~1.4–2 V gần như miễn nhiễm.

**Project:** SKY130 dùng luật tính theo µm: poly 0.15 µm, licon 0.17 µm, nwell bao pdiff 0.18 µm…
Layout inverter 1.56 × 6.14 µm, DRC 0 lỗi.

---

## 8. Delay ★★★ (§4)

**Định nghĩa** (Hình 4.1):
- **Propagation delay tpd**: thời gian **lớn nhất** từ ngõ vào qua 50 % tới ngõ ra qua 50 %.
- **Contamination delay tcd**: thời gian **nhỏ nhất** như trên.
- **Rise time tr**: **20 % → 80 %** · **Fall time tf**: **80 % → 20 %** (định nghĩa của sách này!).
- **Slack** = required time − arrival time. Slack âm → không đạt timing. **Critical path** =
  đường chậm nhất.

**Mô hình RC:**
- Unit nMOS: điện trở **R** (~10 kΩ); unit pMOS ≈ **2R** (sách dùng 2R). Rộng k lần → R/k.
- Tụ gate unit **C** (~1 fF/µm); tụ diffusion ≈ C mỗi cực có tiếp điểm.
- **Elmore delay**: tpd ≈ Σ (điện trở từ nguồn tới nút i) × Ci.
- tp ≈ 0.69·R·C. Delay **tăng tuyến tính theo tải** và giảm khi tăng dòng.

**Linear delay model & Logical Effort:** d = f + p = **g·h + p** (đơn vị τ = 3RC)
- **g (logical effort)**: gate kém inverter bao nhiêu khi cho dòng ra với cùng tụ ngõ vào.
- **h (electrical effort, fanout)** = Cout / Cin.
- **p (parasitic delay)**: delay khi không tải.

| Cổng | g (n ngõ vào) | g (n = 2) | p |
|---|---|---|---|
| Inverter | 1 | – | 1 |
| NAND | (n + 2)/3 | **4/3** | n (NAND2 = 2) |
| NOR | (2n + 1)/3 | **5/3** | n (NOR2 = 2) |
| Mux / tristate | 2 | 2 | 2n |
| XOR2 | 4 | 4 | – |

- **FO4 inverter delay** = 4 + 1 = **5τ**; hay dùng làm đơn vị so sánh giữa các công nghệ.
- Đường nhiều tầng: **G = Πg, B = branching effort, H = Cout/Cin, F = G·B·H**,
  D = N·F^(1/N) + P. Delay nhỏ nhất khi mỗi tầng có effort **≈ 4**.
- Tối ưu timing có tác động lớn nhất ở **microarchitecture** → logic → circuit → layout.

**Project:** tp inverter ≈ 36 ps @ 10 fF, delay tăng tuyến tính ≈ 2.2 ps/fF. Lab đo tr/tf 10–90 %
(khác sách 20–80 %).

---

## 9. Power ★★★ (§5)

- **P = α·C·VDD²·f** (dynamic switching power). α = **activity factor** (clock α = 1, logic
  ngẫu nhiên ~0.1). Năng lượng mỗi lần nạp/xả: E = C·VDD².
- **VDD là số hạng bình phương** → giảm VDD hiệu quả nhất (giảm ½ VDD → dynamic power còn **¼**).
- **Short-circuit power**: khi PUN và PDN cùng dẫn lúc chuyển mạch; thường **< 10 %**.
- **Static power** = (Isub + Igate + Ijunct + Icontention)·VDD. CMOS tĩnh lý tưởng không có
  contention; **pseudo-nMOS** thì có.
- **Stack effect**: 2 transistor OFF nối tiếp rò ít hơn **~10 lần**.

**Kỹ thuật giảm công suất:**
| Kỹ thuật | Giảm cái gì |
|---|---|
| **Clock gating** | Tắt clock khối rảnh → giảm α (dynamic) |
| **Power gating** (sleep transistor) | Cắt nguồn khối ngủ → giảm leakage |
| **Multiple Vt** (high-Vt cho đường không găng) | Leakage |
| **Body bias** (reverse) | Tăng Vt → giảm leakage |
| **DVFS**, giảm VDD, giảm f | Dynamic |
| **Parallelism / pipelining** + hạ VDD | Năng lượng |

- Tối ưu công suất phải đi **từ trên xuống** (kiến trúc trước, mạch sau).

**Project:** inverter đo 21.7 µW so với C·V²·f = 16.2 µW (phần dư là short-circuit và tụ ký sinh);
DFF 76 µW vì clock buffer và 4 TG chuyển mạch **mỗi chu kỳ** → lý do cần clock gating.

---

## 10. Interconnect (dây nối) ★ (§6)

- Transistor nhỏ đi thì nhanh hơn, **dây thì không** → delay dây ngày càng quan trọng.
- Delay dây dài tỉ lệ **bình phương chiều dài** → chia dây bằng **repeaters**.
- Nhiều lớp kim loại; lớp trên **dày, rộng** (điện trở thấp) cho dây dài. Hướng dây các lớp
  **xen kẽ ngang/dọc**.
- **Coupling capacitance** giữa dây sát nhau gây nhiễu (crosstalk).

**Project:** DFF post-layout chậm hơn 26 % vì tụ ký sinh dồn vào dây clock dài ~15 µm.

---

## 11. Độ bền, độ tin cậy, scaling ★★ (§7)

**Process corners:** 5 chữ cái = nMOS, pMOS, interconnect, VDD, nhiệt độ; mỗi chữ **F/T/S**.
- **TT** = typical, **FF** = nhanh nhất (VDD cao, lạnh), **SS** = chậm nhất.
- **SF / FS** kiểm tra lỗi tỉ lệ (ratio). Mạch phải chạy được ở **SSSSS**.
- **Binning**: chip nhanh bán giá cao hơn.

**Reliability:**
- **MTBF** (mean time between failures); **FIT** = số lỗi trên **10⁹ giờ-thiết bị**.
- **Bathtub curve**: infant mortality → useful life → wearout. **Burn-in** (điện áp, nhiệt cao)
  loại chip yếu sớm.
- **Electromigration**: dòng **DC** mật độ cao đẩy nguyên tử kim loại → đứt dây. Nhôm kém,
  **đồng (Cu) tốt hơn**. MTTF theo **Black's equation**.
- **Soft errors**: hạt **alpha** (tạp chất trong vỏ) và **neutron vũ trụ** → **SEU** khi điện tích
  thu được > **Qcrit**. Không làm hỏng vĩnh viễn.
- **ESD**, **oxide breakdown**, **punchthrough**, **hot carriers**, **latchup** → quy định Vmax.

**Scaling** (Bảng 7.4, hệ số S > 1) ★★

| Thông số | **Dennard (constant field)** | Constant voltage |
|---|---|---|
| L, W, tox | 1/S | 1/S |
| VDD, Vt | **1/S** | 1 |
| Gate delay | **1/S** | 1/S² |
| Tần số | S | S² |
| Năng lượng chuyển mạch / cổng | **1/S³** | 1/S |
| Công suất / cổng | **1/S²** | S |
| Diện tích / cổng | 1/S² | 1/S² |
| Mật độ công suất | **1 (không đổi)** | S³ |

- Một node "30 % shrink": S = √2 → diện tích ½, tần số +40 %, công suất/cổng ½.
- Từ 90 nm, **leakage** làm VDD và Vt khó giảm tiếp → Dennard scaling chậm lại.

---

## 12. Các họ mạch tổ hợp ★★ (§9)

| Họ mạch | Đặc điểm |
|---|---|
| **Static CMOS** | Dùng nhiều nhất: noise margin tốt, bền, ít công suất, dễ thiết kế, CAD hỗ trợ tốt |
| **Pseudo-nMOS** (ratioed) | 1 pMOS luôn ON thay PUN → ít tụ ngõ vào nhưng **tốn công suất tĩnh**, **VOL ≠ 0**, phải chọn tỉ lệ kích thước |
| **Dynamic / domino** | **Precharge** (clk = 0, ngõ ra lên 1) rồi **evaluate** (clk = 1). Nhanh nhất, không có contention; nhưng cần clock, nhạy nhiễu, **charge sharing**, tốn dynamic power. **Foot** transistor tránh contention lúc precharge |
| **Pass-transistor logic** | Ngõ vào vào cả cực S/D; hiệu quả cho XOR, mux, **SRAM 6T**; nhưng sụt Vt, khó phân tích timing |
| **CVSL** (DCVSL) | Logic vi sai, cần cả tín hiệu và bù |

- **Bubble pushing** (De Morgan): NAND = OR với ngõ vào đảo; NOR = AND với ngõ vào đảo.
- **Input ordering**: tín hiệu đến **muộn nhất** nối transistor **gần ngõ ra nhất**.
  *(Project Lab 4: tpHL khi a – gần ngõ ra – chuyển = 33 ps < khi b chuyển = 37 ps.)*
- **SOI** (silicon-on-insulator): tụ ký sinh nhỏ, rò ít, không latchup.
- **Subthreshold circuits** (VDD 300–500 mV): tiết kiệm năng lượng ~10 lần khi không cần tốc độ.

---

## 13. Mạch tuần tự và timing ★★★ (§10)

- **Sequencing element** (latch/flip-flop) giữ các "token" không đuổi kịp nhau.
- **Latch** transparent khi CLK = 1; **flip-flop** lấy mẫu ở cạnh lên.

**Ràng buộc timing (flip-flop):**
- **Max-delay (setup)**: Tc ≥ **tpcq + tpd + tsetup** (+ tskew). Vi phạm → **setup-time failure**.
  **Sửa bằng cách chậm clock** hoặc làm logic nhanh hơn.
- **Min-delay (hold)**: **tcd ≥ thold − tccq** (+ tskew). Vi phạm → **hold-time / race failure**.
  **Không sửa được bằng cách chậm clock** – phải sửa logic.
- **Sequencing overhead** của flip-flop = tpcq + tsetup (+ skew).
- **Clock skew**: làm giảm thời gian cho max-delay và tăng yêu cầu hold.
- **Two-phase transparent latches**: **skew-tolerant**, cho phép **time borrowing**.
  Flip-flop tạo "hard edge", không mượn thời gian được.
- **Pulsed latch**: overhead thấp nhất nhưng dễ lỗi min-delay.
- **Metastability**: latch kẹt ở mức trung gian khi dữ liệu đổi sát cạnh clock. Dùng
  **synchronizer** (2 flip-flop nối tiếp) cho tín hiệu **bất đồng bộ**.
- Latch tĩnh có **feedback** giữ dữ liệu; latch động giữ trên tụ, sẽ **rò mất** theo thời gian.

**Project Lab 5:** DFF master–slave dùng TG, 24 transistor; tcq ≈ 231 ps, setup ≈ 20 ps,
hold ≈ 40 ps; xung nhiễu trên D khi CLK = 1 không lọt qua.

---

## 14. Luồng và phương pháp thiết kế ★★★ (§1.6–1.12, §14)

**5 mức trừu tượng:** **architecture** → **microarchitecture** → **logic** → **circuit** → **physical**.

**Y-chart** (Gajski): 3 domain **behavioral / structural / physical (geometrical)**.

**Structured design:** **hierarchy**, **regularity**, **modularity**, **locality**.

**HDL:**
- **Verilog** (Gateway Design Automation, 1984; gần C) và **VHDL** (VHSIC, Bộ Quốc phòng Mỹ; dài dòng hơn).
- Code HDL gọi là **RTL**. **Structural** = mô tả kết nối cell; **behavioral** = mô tả chức năng.
- **Logic synthesis**: HDL → netlist **standard cells**. **Place & route** tự động tạo layout.
- Netlist mức transistor: **Verilog** (chức năng; `tranif1` = nMOS, `tranif0` = pMOS) hoặc **SPICE**
  (delay/power): `Mname drain gate source body type W= L= AD= AS=`.

**Phương pháp thực hiện chip:**

| Phương pháp | NRE | Hiệu năng | Ghi chú |
|---|---|---|---|
| Microprocessor/DSP | Thấp | Thấp | Đổi bằng phần mềm |
| **FPGA** | Rất thấp | Trung bình | Lập trình lại tại hiện trường; SRAM (**LUT**) hoặc **antifuse** (một lần) |
| **Gate array / sea-of-gates** | Trung bình | Trung bình | Mảng transistor có sẵn, chỉ cá nhân hóa **lớp kim loại** |
| **Cell-based (standard cell, ASIC)** | Cao | Cao | Năng suất cao hơn full custom |
| **Full custom** | Cao nhất | Cao nhất | Vẽ tay từng hình (**polygon pushing**); dùng cho datapath CPU, memory, analog, cell library |

- **Semi-custom** = dùng cell/khối có sẵn (standard cell, gate array). **Full custom** = thiết kế
  từng transistor và layout.
- Custom CPU > 2 GHz, ASIC tổng hợp ~200–350 MHz; ASIC tốn 3–7 lần công suất.
- **NRE** (non-recurring engineering): chi phí một lần (thiết kế, mask). **Recurring**: chi phí mỗi chip
  (wafer, đóng gói, test).
- **Floorplan**: ước lượng diện tích, vị trí khối, độ dài dây. **Pad-limited** (pad quyết định diện
  tích) vs **core-limited** (logic quyết định).
- **Verification** chiếm ≥ ½ công sức:
  - **LVS** (layout vs schematic) – layout nối đúng như schematic.
  - **DRC** (design rule check) – layout đúng luật chế tạo.
  - **ERC** (electrical rule check) – lỗi điện khác.

**Project:** Lab 3–5 là **full custom**; Lab 6–7 là **semi-custom** (luồng ASIC). Các lab đã chạy
DRC (Magic), LVS (Netgen: "Circuits match uniquely"), trích ký sinh và mô phỏng post-layout.

---

## 15. Kiểm thử (testing) ★★ (§15)

- 3 loại test: **functionality test / logic verification** (trước tapeout) · **silicon debug**
  (lô chip đầu) · **manufacturing test** (mọi chip trước khi giao).
- **Yield** = số die tốt / tổng số die. Phát hiện lỗi càng sớm (wafer) càng rẻ.
- **Fault model**: **stuck-at-0 / stuck-at-1** (phổ biến nhất); short/open (bridging).
- **Observability**: dễ quan sát một nút ở chân ra. **Controllability**: dễ đặt nút về 0/1.
- **Fault coverage** = % nút phát hiện được lỗi; chất lượng cao cần **> 98.5 %**.
  **ATPG** = tự động sinh vector test.
- **Scan design**: các thanh ghi nối thành **scan chain** (thanh ghi dịch) → quan sát và điều khiển
  mọi thanh ghi.
- **BIST** (built-in self-test): **PRSG/LFSR** sinh mẫu + **signature analysis**.
- **IDDQ test**: đo dòng nguồn tĩnh để tìm bridging fault (kém hiệu quả khi leakage lớn).
- **Boundary scan / JTAG** (IEEE **1149.1**): test kết nối giữa các chip trên board qua **TAP**.

---

## 16. Mạch số và Verilog (Lab 1–2) ★★

- **Full adder**: S = A ⊕ B ⊕ Cin; Cout = AB + ACin + BCin (hàm **majority**).
- **CLA**: **Gi = Ai·Bi** (generate), **Pi = Ai ⊕ Bi** (propagate), **Ci+1 = Gi + Pi·Ci**.
  Tính trước mọi carry → nhanh hơn **ripple-carry** (carry lan tuần tự).
- Flip-flop: **SR** (S = R = 1 là **invalid**), **D** (Q⁺ = D), **JK** (J = K = 1 → **toggle**),
  **T** (T = 1 → đảo).
- Verilog: `always @(posedge clk)` cho mạch tuần tự; **non-blocking `<=`** cho flip-flop,
  **blocking `=`** cho logic tổ hợp; `assign` cho logic liên tục; module = cell.

---

## 17. Bẫy thường gặp (tổng hợp)

1. **"Open switch"** = công tắc **hở (không dẫn)**.
2. nMOS truyền **strong 0**, pMOS truyền **strong 1** – đừng đảo.
3. NAND: nMOS **nối tiếp**, pMOS **song song**. NOR ngược lại.
4. Rise time trong sách này là **20–80 %** (nhiều nơi khác dùng 10–90 %).
5. Dynamic power ∝ **VDD²** (không phải VDD); ∝ f và α tuyến tính.
6. Hold violation **không** sửa được bằng giảm tần số clock.
7. λ = **½** feature size (không phải bằng feature size).
8. Nhiệt độ tăng → mạch **chậm hơn** (ở VDD bình thường) và rò **tăng**.
9. Body effect làm Vt **tăng**; DIBL làm Vt **giảm**.
10. Constant-field scaling giữ **mật độ công suất không đổi**.
11. Static CMOS **luôn đảo**; muốn AND cần NAND + inverter.
12. "By a factor of 4" = **gấp/chia 4 lần**, không phải cộng/trừ 4.
13. Đọc kỹ **NOT / EXCEPT / INCORRECT / FALSE** trong câu hỏi.

---

## 18. Bảng tra nhanh số liệu project (SKY130, 1.8 V)

| Mạch | Kết quả tiêu biểu |
|---|---|
| Inverter (Wp/Wn = 2.5/1 µm) | VM 0.884 V; NML/NMH 0.68/0.74 V; tpHL/tpLH 35.5/37.6 ps @ 10 fF |
| NAND2 (Wn = 2, Wp = 2.5 µm) | Đúng bảng sự thật; trễ xấu nhất tpLH khi b chuyển 54.9 ps |
| DFF master–slave TG (24 T) | tcq 231/214 ps; setup ≈ 20 ps; hold ≈ 40 ps; 76 µW @ 500 MHz |
| Layout | DRC 0 lỗi; LVS khớp; post-layout chậm +4 % (INV), +5 % (NAND), +26 % (DFF) |

---

## 19. 50 câu trắc nghiệm mẫu (tiếng Anh)

**MOS transistor**

1. An nMOS transistor is ON when:
   A) its gate is at 0 B) its gate is at VDD C) its body is at VDD D) its source is at VDD
2. Which dopant creates an n-type semiconductor?
   A) Boron B) Arsenic C) Aluminum D) Gallium
3. In saturation, the long-channel nMOS current is approximately:
   A) β(Vgs − Vt)·Vds B) (β/2)(Vgs − Vt)² C) 0 D) β·Vds²
4. The body of a pMOS transistor in an n-well process is normally connected to:
   A) GND B) VDD C) the drain D) left floating
5. The main reason pMOS transistors are sized wider than nMOS transistors is:
   A) higher threshold voltage B) lower hole mobility C) larger gate oxide D) body effect
6. Increasing the source-to-body voltage Vsb of an nMOS transistor:
   A) decreases Vt B) increases Vt C) does not affect Vt D) makes Vt negative
7. The dominant leakage mechanism in most nanometer processes is:
   A) gate leakage B) junction leakage C) subthreshold leakage D) contention current
8. When temperature increases, the OFF current of a transistor:
   A) decreases B) increases exponentially C) stays constant D) becomes zero

**CMOS logic**

9. A 3-input static CMOS NAND gate uses:
   A) 3 series pMOS and 3 parallel nMOS B) 3 series nMOS and 3 parallel pMOS
   C) 3 parallel nMOS and 3 parallel pMOS D) 6 series transistors
10. How many transistors are needed for a 4-input static CMOS NOR gate?
    A) 4 B) 6 C) 8 D) 16
11. An nMOS pass transistor passes:
    A) a strong 1 and a weak 0 B) a strong 0 and a weak 1 C) strong 0 and strong 1 D) weak 0 and weak 1
12. A transmission gate consists of:
    A) two nMOS in series B) an nMOS and a pMOS in series C) an nMOS and a pMOS in parallel D) two pMOS in parallel
13. When both the pull-up and pull-down networks are OFF, the output is:
    A) 0 B) 1 C) floating (Z) D) crowbarred (X)
14. Static CMOS gates are inherently:
    A) non-inverting B) inverting C) ratioed D) dynamic
15. Why are NAND gates generally preferred over NOR gates?
    A) NOR has series nMOS B) NOR has series pMOS, which are slow C) NAND uses fewer transistors D) NAND has no parasitic delay
16. The function Y = NOT(A·B + C·D) is implemented by a(n):
    A) OAI22 B) AOI22 C) AOI21 D) NAND4
17. A D latch that is transparent when CLK = 1 is called:
    A) edge-triggered B) positive-level-sensitive C) negative-level-sensitive D) a register

**DC characteristics**

18. For a CMOS inverter with βp = βn and Vtn = |Vtp|, the switching threshold is:
    A) Vtn B) VDD/4 C) VDD/2 D) VDD − Vtn
19. VIL and VIH are defined at the points of the VTC where the slope is:
    A) 0 B) −1 C) +1 D) maximum
20. NMH is defined as:
    A) VIH − VOL B) VOH − VIH C) VIL − VOL D) VOH − VOL
21. A HI-skewed inverter (stronger pMOS) has a switching threshold that is:
    A) lower than VDD/2 B) equal to VDD/2 C) higher than VDD/2 D) equal to Vtn
22. An nMOS transistor trying to pass a 1 can only pull its output up to:
    A) VDD B) VDD − Vtn C) Vtn D) VDD/2

**Fabrication & layout**

23. In scalable design rules, λ is equal to:
    A) the feature size B) half the minimum drawn channel length C) the metal width D) the gate oxide thickness
24. A transistor is formed where:
    A) metal crosses poly B) poly crosses active (diffusion) C) metal crosses diffusion D) a contact is placed
25. The source and drain are formed after the gate so the gate masks the channel. This is called a:
    A) self-aligned process B) twin-well process C) damascene process D) lift-off process
26. Hydrofluoric acid (HF) is used in fabrication to:
    A) deposit polysilicon B) etch silicon dioxide C) implant dopants D) sputter aluminum
27. Which file format is commonly used to send mask data to a foundry?
    A) SPICE B) Verilog C) GDSII D) LEF
28. Latchup is caused by:
    A) electromigration B) a parasitic SCR formed by npn and pnp transistors C) gate oxide tunneling D) soft errors
29. The most effective way to prevent latchup is to:
    A) use longer transistors B) place substrate and well taps close to transistors C) raise VDD D) remove the n-well

**Delay**

30. Propagation delay tpd is measured from the input crossing ___ to the output crossing ___.
    A) 10 %, 90 % B) 20 %, 80 % C) 50 %, 50 % D) 0 %, 100 %
31. The logical effort of a 2-input NAND gate is:
    A) 1 B) 4/3 C) 5/3 D) 2
32. The delay of a fanout-of-4 inverter in units of τ is:
    A) 1 B) 4 C) 5 D) 8
33. In the linear delay model d = gh + p, h is the:
    A) logical effort B) parasitic delay C) electrical effort (fanout) D) path effort
34. The Elmore delay model estimates delay as:
    A) the product of total R and total C B) the sum over nodes of each capacitance times the resistance to the source
    C) the maximum RC of any branch D) the average of rise and fall delays
35. Positive slack means that the circuit:
    A) fails timing B) meets timing C) has a hold violation D) has metastability

**Power**

36. Dynamic power is given by:
    A) α·C·VDD·f B) α·C·VDD²·f C) C·VDD/f D) I_leak·VDD
37. If VDD is reduced by half (all else constant), dynamic power becomes:
    A) 1/2 B) 1/4 C) 1/8 D) unchanged
38. Clock gating primarily reduces:
    A) leakage power B) dynamic power by lowering the activity factor C) short-circuit current only D) wire resistance
39. Power gating primarily reduces:
    A) dynamic power during active mode B) leakage power in sleep mode C) clock skew D) noise margin
40. Two series OFF transistors leak less than one because of the:
    A) body effect only B) stack effect C) Miller effect D) latchup effect

**Robustness & scaling**

41. Under Dennard (constant-field) scaling by factor S, the power density:
    A) increases by S B) decreases by S C) stays constant D) increases by S³
42. The slowest process corner for both transistors is:
    A) TT B) FF C) SS D) FS
43. Electromigration is most severe for:
    A) wires carrying unidirectional (DC) current B) gate oxides C) polysilicon resistors D) substrate taps
44. Soft errors in memories are caused mainly by:
    A) electromigration B) alpha particles and cosmic neutrons C) latchup D) hot carriers

**Sequential circuits**

45. A hold-time violation can be fixed by:
    A) lowering the clock frequency B) raising the clock frequency C) adding delay to the short path D) increasing VDD
46. The sequencing overhead of a flip-flop-based system (ignoring skew) is:
    A) tpcq + tsetup B) thold − tccq C) 2·tpdq D) tcd
47. Which sequencing method is most tolerant of clock skew and allows time borrowing?
    A) flip-flops B) two-phase transparent latches C) pulsed latches D) dynamic registers

**Design flow & testing**

48. Checking that the transistors in a layout are connected the same way as in the schematic is called:
    A) DRC B) ERC C) LVS D) STA
49. A design style that customizes only the metal layers on top of a prefabricated transistor array is a:
    A) full-custom design B) gate array C) FPGA D) standard cell design
50. The IEEE 1149.1 standard (JTAG) is used for:
    A) power gating B) boundary-scan testing of chips on a board C) clock distribution D) logic synthesis

---

## 20. Đáp án và giải thích ngắn

| Câu | Đáp án | Giải thích |
|---|---|---|
| 1 | B | nMOS ON khi gate = 1 |
| 2 | B | As nhóm V → donor |
| 3 | B | Square law (§2.2) |
| 4 | B | n-well nối VDD để tiếp giáp phân cực ngược |
| 5 | B | μp < μn khoảng 2–3 lần |
| 6 | B | Body effect làm Vt tăng |
| 7 | C | Subthreshold leakage (§2.4.4, §5.3) |
| 8 | B | Vt giảm và độ dốc tăng khi nóng |
| 9 | B | NAND: nMOS nối tiếp, pMOS song song |
| 10 | C | 2k = 8 |
| 11 | B | nMOS: strong 0, weak 1 |
| 12 | C | nMOS // pMOS, gate bù nhau |
| 13 | C | Z – floating (Bảng 1.3) |
| 14 | B | PDN ON khi ngõ vào 1 → ngõ ra 0 |
| 15 | B | NOR có pMOS nối tiếp (chậm) |
| 16 | B | AND-OR-INVERT 2-2 |
| 17 | B | Positive-level-sensitive latch |
| 18 | C | VDD/2 |
| 19 | B | Unity-gain points |
| 20 | B | NMH = VOH − VIH |
| 21 | C | pMOS mạnh hơn kéo VM lên |
| 22 | B | Threshold drop |
| 23 | B | λ = ½ Lmin |
| 24 | B | Poly ∩ active = gate |
| 25 | A | Self-aligned |
| 26 | B | HF ăn mòn SiO₂ |
| 27 | C | GDSII |
| 28 | B | SCR ký sinh |
| 29 | B | Tap sát transistor, guard ring |
| 30 | C | 50 % – 50 % |
| 31 | B | (2 + 2)/3 = 4/3 |
| 32 | C | g·h + p = 1·4 + 1 = 5 |
| 33 | C | h = Cout/Cin |
| 34 | B | Σ Ri·Ci |
| 35 | B | Required − arrival > 0 |
| 36 | B | α·C·VDD²·f |
| 37 | B | (½)² = ¼ |
| 38 | B | Giảm α |
| 39 | B | Cắt nguồn khối ngủ |
| 40 | B | Stack effect (~10 lần) |
| 41 | C | P/gate ÷S², diện tích/gate ÷S² |
| 42 | C | SS |
| 43 | A | Dòng DC một chiều |
| 44 | B | Alpha và neutron |
| 45 | C | Thêm delay vào đường ngắn; chậm clock không giúp |
| 46 | A | tpcq + tsetup |
| 47 | B | Latch hai pha |
| 48 | C | LVS |
| 49 | B | Gate array (sea-of-gates) |
| 50 | B | Boundary scan (JTAG) |
