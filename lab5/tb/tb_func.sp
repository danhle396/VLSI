* ============================================================
*  Lab 5 - Testbench 1: kiem tra chuc nang D flip-flop
*  clk: chu ky 2 ns (500 MHz), canh len tai 1, 3, 5, ..., 15 ns
*  d  : bit lay mau tai cac canh = 1 0 1 1 0 0 1 0
*       + xung nhieu (glitch) de chung minh chi lay mau tai canh:
*         5.4-5.8 ns  d=0 khi clk=1      -> q khong doi (giu 1)
*         9.3-9.6 ns  d=1 khi clk=1      -> q khong doi (giu 0)
*        10.1-10.3 ns d=1 khi clk=0 nhung het truoc canh 11 ns -> q giu 0
*  Do: tcq (clk -> q) canh len/xuong, cong suat trung binh.
* ============================================================
.include ../netlist/sky130_models.spice
.include ../netlist/dff.spice

Vdd vdd 0 1.8
Vclk clk 0 pulse(0 1.8 1n 20p 20p 0.98n 2n)
Vd   d   0 pwl(0 0  0.5n 0  0.52n 1.8  2.5n 1.8  2.52n 0  4.5n 0  4.52n 1.8
+              5.4n 1.8  5.42n 0  5.8n 0  5.82n 1.8  8.5n 1.8  8.52n 0
+              9.3n 0  9.32n 1.8  9.6n 1.8  9.62n 0  10.1n 0  10.12n 1.8
+              10.3n 1.8  10.32n 0  12.5n 0  12.52n 1.8  14.5n 1.8  14.52n 0)
X1  d clk q qb vdd 0 dff
CLq  q  0 5f
CLqb qb 0 5f
* tranh diem can bang metastable cua slave o DC ban dau
.nodeset v(X1.s1)=1.8 v(X1.s2)=0

.control
tran 1p 17n

* ---- lay mau d ngay truoc canh va q sau canh ----
echo "# edge(ns)  D_truoc_canh(V)  Q_sau_canh(V)" > func.dat
foreach e 1 3 5 7 9 11 13 15
  let tdv = ($e - 0.1)*1e-9
  let tqv = ($e + 0.9)*1e-9
  meas tran vd find v(d) at=$&tdv
  meas tran vq find v(q) at=$&tqv
  echo "$e $&vd $&vq" >> func.dat
end

meas tran tcq_LH trig v(clk) val=0.9 rise=1 targ v(q) val=0.9 rise=1
meas tran tcq_HL trig v(clk) val=0.9 rise=2 targ v(q) val=0.9 fall=1
meas tran IAVG avg i(Vdd) from=1n to=17n
let PAVG = -IAVG*1.8
echo
echo "============= KET QUA D FLIP-FLOP (clk 500 MHz) ============="
print tcq_LH tcq_HL PAVG
echo "============================================================="
shell cat func.dat
wrdata func_tran.dat v(clk) v(d) v(q) v(qb) v(X1.m1) v(X1.s1)
.endc
.end
