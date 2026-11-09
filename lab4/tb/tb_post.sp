* ============================================================
*  Lab 4 - Testbench 3: mo phong post-layout
*  3 phien ban NAND, cung ngo vao (PWL nhu tb_tran.sp), cung tai 10 fF:
*    X1 pre  : netlist schematic
*    X2 dev  : transistor trich tu layout, khong tu ky sinh
*    X3 post : transistor + tu ky sinh cua layout
* ============================================================
.include ../netlist/sky130_models.spice
.include ../netlist/nand.spice
.include ../layout/nand_dev.spice
.include ../layout/nand_post.spice

Vdd vdd 0 1.8
Va  a 0 pwl(0 0 2n 0 2.02n 1.8 5n 1.8 5.02n 0 7n 0 7.02n 1.8 8n 1.8 8.02n 0)
Vb  b 0 pwl(0 0 1n 0 1.02n 1.8 3n 1.8 3.02n 0 4n 0 4.02n 1.8 6n 1.8 6.02n 0
+           7n 0 7.02n 1.8 8n 1.8 8.02n 0)
X1  a b y_pre  vdd 0 nand
X2  a b y_dev  vdd 0 nand_dev
X3  a b y_post vdd 0 nand_post
C1  y_pre  0 10f
C2  y_dev  0 10f
C3  y_post 0 10f

.control
tran 1p 10n
echo "# ver tpHL_a tpHL_b tpHL_ab tpLH_a tpLH_b tpLH_ab (ps)" > post.dat
foreach o pre dev post
  meas tran d1 trig v(a) val=0.9 rise=1 targ v(y_$o) val=0.9 fall=1
  meas tran d2 trig v(b) val=0.9 rise=2 targ v(y_$o) val=0.9 fall=2
  meas tran d3 trig v(a) val=0.9 rise=2 targ v(y_$o) val=0.9 fall=3
  meas tran d4 trig v(a) val=0.9 fall=1 targ v(y_$o) val=0.9 rise=2
  meas tran d5 trig v(b) val=0.9 fall=1 targ v(y_$o) val=0.9 rise=1
  meas tran d6 trig v(a) val=0.9 fall=2 targ v(y_$o) val=0.9 rise=3
  let e1 = d1*1e12
  let e2 = d2*1e12
  let e3 = d3*1e12
  let e4 = d4*1e12
  let e5 = d5*1e12
  let e6 = d6*1e12
  echo "$o $&e1 $&e2 $&e3 $&e4 $&e5 $&e6" >> post.dat
end
* ---- bang su that tren ban post-layout ----
echo "# t(ns) A(V) B(V) Y_post(V)" > post_truth.dat
foreach ts 0.8 1.8 2.8 3.8 4.8 5.8 6.8 7.8 9.8
  let tsv = $ts*1e-9
  meas tran va find v(a) at=$&tsv
  meas tran vb find v(b) at=$&tsv
  meas tran vy find v(y_post) at=$&tsv
  echo "$ts $&va $&vb $&vy" >> post_truth.dat
end
echo
echo "============ PRE- vs POST-LAYOUT - NAND (CL = 10 fF) ============"
shell cat post.dat
shell cat post_truth.dat
wrdata post_wave.dat v(a) v(b) v(y_pre) v(y_post)
.endc
.end
