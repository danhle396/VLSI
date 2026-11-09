* ============================================================
*  Lab 5 - Testbench 3: mo phong post-layout D flip-flop
*  3 phien ban, cung clk/d nhu tb_func.sp, tai 5 fF tren q va qb:
*    X1 pre  : netlist schematic          (chan: d clk q qb vdd vss)
*    X2 dev  : transistor trich tu layout (chan: clk d q qb vdd vss)
*    X3 post : transistor + 92 tu ky sinh (chan: clk d q qb vdd vss)
*  Do tcq va kiem tra chuc nang (Q = D tai 8 canh len) cho ca 3.
* ============================================================
.include ../netlist/sky130_models.spice
.include ../netlist/dff.spice
.include ../layout/dff_dev.spice
.include ../layout/dff_post.spice

Vdd vdd 0 1.8
Vclk clk 0 pulse(0 1.8 1n 20p 20p 0.98n 2n)
Vd   d   0 pwl(0 0  0.5n 0  0.52n 1.8  2.5n 1.8  2.52n 0  4.5n 0  4.52n 1.8
+              5.4n 1.8  5.42n 0  5.8n 0  5.82n 1.8  8.5n 1.8  8.52n 0
+              9.3n 0  9.32n 1.8  9.6n 1.8  9.62n 0  10.1n 0  10.12n 1.8
+              10.3n 1.8  10.32n 0  12.5n 0  12.52n 1.8  14.5n 1.8  14.52n 0)
X1  d clk q_pre  qb_pre  vdd 0 dff
X2  clk d q_dev  qb_dev  vdd 0 dff_dev
X3  clk d q_post qb_post vdd 0 dff_post
Cq1 q_pre  0 5f
Cb1 qb_pre 0 5f
Cq2 q_dev  0 5f
Cb2 qb_dev 0 5f
Cq3 q_post 0 5f
Cb3 qb_post 0 5f
.nodeset v(x1.s1)=1.8 v(x1.s2)=0 v(x2.s1)=1.8 v(x2.s2)=0 v(x3.s1)=1.8 v(x3.s2)=0

.control
tran 1p 17n
echo "# ver  tcq_LH(ps)  tcq_HL(ps)  so_canh_dung/8" > post.dat
foreach o pre dev post
  meas tran t1 trig v(clk) val=0.9 rise=1 targ v(q_$o) val=0.9 rise=1
  meas tran t2 trig v(clk) val=0.9 rise=2 targ v(q_$o) val=0.9 fall=1
  let a = t1*1e12
  let b = t2*1e12
  * kiem tra chuc nang: Q (0.9 ns sau canh) phai bang D (0.1 ns truoc canh)
  let ok = 0
  foreach e 1 3 5 7 9 11 13 15
    let tdv = ($e - 0.1)*1e-9
    let tqv = ($e + 0.9)*1e-9
    meas tran vd find v(d) at=$&tdv
    meas tran vq find v(q_$o) at=$&tqv
    if (vd > 0.9) eq (vq > 0.9)
      let ok = ok + 1
    end
  end
  echo "$o $&a $&b $&ok" >> post.dat
end
echo
echo "============ PRE- vs POST-LAYOUT - D FLIP-FLOP ============"
shell cat post.dat
wrdata post_wave.dat v(clk) v(d) v(q_pre) v(q_post)
.endc
.end
