* ============================================================
*  Lab 5 - Testbench 2: do thoi gian setup / hold
*
*  clk canh len tai 1 ns (canh chuan bi) va 3 ns (canh do);
*  clk qua 50 % tai 3.01 ns. d la PWL: V0 -> V1 tai T1, V1 -> V0 tai T2.
*  d qua 50 % tai T + 10 ps.
*
*  "bat 1" : V0 = 0,   V1 = 1.8  -> canh 1 nap q = 0, canh do phai ra q = 1
*  "bat 0" : V0 = 1.8, V1 = 0    -> canh 1 nap q = 1, canh do phai ra q = 0
*
*  SETUP: d doi sang V1 truoc canh do mot khoang ts (T1 = 3n - ts).
*  HOLD : d doi sang V1 tu 2 ns, doi nguoc ve V0 sau canh do th (T2 = 3n + th).
*  Diem dat: q cuoi = V1 va tcq <= 1.1 x tcq danh nghia (tieu chuan 10 %).
*  File ra: "# ts|th(ps)  tcq(ps)  Q_cuoi(V)", tcq = -1 neu bat sai.
* ============================================================
.include ../netlist/sky130_models.spice
.include ../netlist/dff.spice

.param V0=0 V1=1.8 T1=2.5n T2=10n
Vdd  vdd 0 1.8
Vclk clk 0 pulse(0 1.8 1n 20p 20p 0.98n 2n)
Vd   d   0 pwl(0 {V0} {T1} {V0} {T1+20p} {V1} {T2} {V1} {T2+20p} {V0})
X1   d clk q qb vdd 0 dff
CLq  q  0 5f
CLqb qb 0 5f
.nodeset v(X1.s1)=1.8 v(X1.s2)=0

.control
set sweep = ( 150 100 60 40 30 25 20 15 10 5 0 -5 -10 -15 -20 -25 -30 -40 -60 )

* ================= SETUP, bat 1 =================
echo "# ts(ps)  tcq(ps)  Q_cuoi(V)" > setup_r.dat
alterparam V0 = 0
alterparam V1 = 1.8
foreach x $sweep
  let tt = 3e-9 - $x*1e-12
  alterparam T1 = $&tt
  alterparam T2 = 10e-9
  reset
  tran 1p 4.8n
  meas tran qend find v(q) at=4.7n
  let tcq = -1
  if qend > 0.9
    meas tran tm trig v(clk) val=0.9 rise=2 targ v(q) val=0.9 rise=1
    let tcq = tm*1e12
  end
  echo "$x $&tcq $&qend" >> setup_r.dat
end

* ================= SETUP, bat 0 =================
echo "# ts(ps)  tcq(ps)  Q_cuoi(V)" > setup_f.dat
alterparam V0 = 1.8
alterparam V1 = 0
foreach x $sweep
  let tt = 3e-9 - $x*1e-12
  alterparam T1 = $&tt
  alterparam T2 = 10e-9
  reset
  tran 1p 4.8n
  meas tran qend find v(q) at=4.7n
  let tcq = -1
  if qend < 0.9
    meas tran tm trig v(clk) val=0.9 rise=2 targ v(q) val=0.9 fall=1
    let tcq = tm*1e12
  end
  echo "$x $&tcq $&qend" >> setup_f.dat
end

* ================= HOLD, bat 1 =================
echo "# th(ps)  tcq(ps)  Q_cuoi(V)" > hold_r.dat
alterparam V0 = 0
alterparam V1 = 1.8
foreach x $sweep
  let tt = 3e-9 + $x*1e-12
  alterparam T1 = 2e-9
  alterparam T2 = $&tt
  reset
  tran 1p 4.8n
  meas tran qend find v(q) at=4.7n
  let tcq = -1
  if qend > 0.9
    meas tran tm trig v(clk) val=0.9 rise=2 targ v(q) val=0.9 rise=1
    let tcq = tm*1e12
  end
  echo "$x $&tcq $&qend" >> hold_r.dat
end

* ================= HOLD, bat 0 =================
echo "# th(ps)  tcq(ps)  Q_cuoi(V)" > hold_f.dat
alterparam V0 = 1.8
alterparam V1 = 0
foreach x $sweep
  let tt = 3e-9 + $x*1e-12
  alterparam T1 = 2e-9
  alterparam T2 = $&tt
  reset
  tran 1p 4.8n
  meas tran qend find v(q) at=4.7n
  let tcq = -1
  if qend < 0.9
    meas tran tm trig v(clk) val=0.9 rise=2 targ v(q) val=0.9 fall=1
    let tcq = tm*1e12
  end
  echo "$x $&tcq $&qend" >> hold_f.dat
end
.endc
.end
