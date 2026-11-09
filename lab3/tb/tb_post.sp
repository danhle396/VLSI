* ============================================================
*  Lab 3 - Testbench 4: mo phong post-layout
*  Mo phong CUNG LUC 3 phien ban inverter, cung ngo vao, cung tai 10 fF:
*    X1 pre  : netlist schematic (netlist/inv.spice)
*    X2 dev  : transistor trich tu layout, KHONG tu ky sinh (layout/inv_dev.spice)
*    X3 post : transistor + tu ky sinh cua layout (layout/inv_post.spice)
*  So sanh X2-X3 cho thay anh huong cua ky sinh layout.
* ============================================================
.include ../netlist/sky130_models.spice
.include ../netlist/inv.spice
.include ../layout/inv_dev.spice
.include ../layout/inv_post.spice

Vdd vdd 0 1.8
Vin in  0 pulse(0 1.8 0.5n 20p 20p 1n 2n)
X1  in out_pre  vdd 0 inv wn=1 wp=2.5
X2  in out_dev  vdd 0 inv_dev
X3  in out_post vdd 0 inv_post
C1  out_pre  0 10f
C2  out_dev  0 10f
C3  out_post 0 10f

.control
tran 1p 4.5n
echo "# ver  tpHL(ps)  tpLH(ps)  tr(ps)  tf(ps)" > post.dat
foreach o pre dev post
  meas tran hl trig v(in) val=0.9 rise=1 targ v(out_$o) val=0.9 fall=1
  meas tran lh trig v(in) val=0.9 fall=1 targ v(out_$o) val=0.9 rise=1
  meas tran r  trig v(out_$o) val=0.18 rise=1 targ v(out_$o) val=1.62 rise=1
  meas tran f  trig v(out_$o) val=1.62 fall=1 targ v(out_$o) val=0.18 fall=1
  let a = hl*1e12
  let b = lh*1e12
  let c = r*1e12
  let d = f*1e12
  echo "$o $&a $&b $&c $&d" >> post.dat
end
echo
echo "============ PRE- vs POST-LAYOUT - INVERTER (CL = 10 fF) ============"
shell cat post.dat
echo "====================================================================="
wrdata post_wave.dat v(in) v(out_pre) v(out_post)
.endc
.end
