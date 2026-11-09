* ============================================================
*  Lab 4 - Testbench 2: kiem tra bang su that + do tre (transient)
*  Moi o thoi gian dai 1 ns, canh 20 ps, tai CL = 10 fF.
*
*   o (ns)  0-1  1-2  2-3  3-4  4-5  5-6  6-7  7-8  8-10
*   a        0    0    1    1    1    0    0    1    0
*   b        0    1    1    0    1    1    0    1    0
*   y        1    1    0    1    0    1    1    0    1
*
*   Canh do tre:  2 ns a len  -> tpHL(a)     3 ns b xuong -> tpLH(b)
*                 4 ns b len  -> tpHL(b)     5 ns a xuong -> tpLH(a)
*                 7 ns a,b len-> tpHL(ab)    8 ns a,b xuong-> tpLH(ab)
* ============================================================
.include ../netlist/sky130_models.spice
.include ../netlist/nand.spice

Vdd vdd 0 1.8
Va  a 0 pwl(0 0 2n 0 2.02n 1.8 5n 1.8 5.02n 0 7n 0 7.02n 1.8 8n 1.8 8.02n 0)
Vb  b 0 pwl(0 0 1n 0 1.02n 1.8 3n 1.8 3.02n 0 4n 0 4.02n 1.8 6n 1.8 6.02n 0
+           7n 0 7.02n 1.8 8n 1.8 8.02n 0)
X1  a b y vdd 0 nand
CL  y 0 10f

.control
tran 1p 10n

* ---- Bang su that: lay mau cuoi moi o thoi gian ----
echo "# t(ns)  A(V)  B(V)  Y(V)" > truth.dat
foreach ts 0.8 1.8 2.8 3.8 4.8 5.8 6.8 7.8 9.8
  let tsv = $ts*1e-9
  meas tran va find v(a) at=$&tsv
  meas tran vb find v(b) at=$&tsv
  meas tran vy find v(y) at=$&tsv
  echo "$ts $&va $&vb $&vy" >> truth.dat
end

* ---- Tre truyen ----
meas tran tpHL_a  trig v(a) val=0.9 rise=1 targ v(y) val=0.9 fall=1
meas tran tpLH_b  trig v(b) val=0.9 fall=1 targ v(y) val=0.9 rise=1
meas tran tpHL_b  trig v(b) val=0.9 rise=2 targ v(y) val=0.9 fall=2
meas tran tpLH_a  trig v(a) val=0.9 fall=1 targ v(y) val=0.9 rise=2
meas tran tpHL_ab trig v(a) val=0.9 rise=2 targ v(y) val=0.9 fall=3
meas tran tpLH_ab trig v(a) val=0.9 fall=2 targ v(y) val=0.9 rise=3
meas tran IAVG avg i(Vdd) from=0 to=10n
let PAVG = -IAVG*1.8
echo
echo "============= KET QUA TRANSIENT NAND (CL = 10 fF) ============="
print tpHL_a tpHL_b tpHL_ab
print tpLH_a tpLH_b tpLH_ab
print PAVG
echo "================================================================"
shell cat truth.dat
wrdata tran.dat v(a) v(b) v(y) i(Vdd)
.endc
.end
