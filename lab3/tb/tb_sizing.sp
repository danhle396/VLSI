* ============================================================
*  Lab 3 - Testbench 1: chon ti le Wp/Wn
*  Wn = 1 um co dinh, quet Wp. Moi diem do:
*    - VM   : nguong chuyen mach (DC, v(out) = v(in))
*    - tpHL : tre ngo ra xuong, tpLH : tre ngo ra len (tai CL = 10 fF)
*  Muc tieu: VM ~ VDD/2 = 0.9 V va tpHL ~ tpLH.
* ============================================================
.include ../netlist/sky130_models.spice
.include ../netlist/inv.spice

.param WP=1
Vdd vdd 0 1.8
Vin in  0 dc 0 pulse(0 1.8 0.2n 20p 20p 1n 2n)
X1  in out vdd 0 inv wn=1 wp={WP}
CL  out 0 10f

.control
echo "# Wp(um)  VM(V)  tpHL(ps)  tpLH(ps)" > sizing.dat
foreach wp 1 1.5 2 2.5 3 3.5 4 5 6
  alterparam WP = $wp
  reset
  dc Vin 0 1.8 1m
  meas dc vm find v(in) when v(out)=v(in)
  set vm_s = $&vm
  tran 1p 2.5n
  meas tran tphl trig v(in) val=0.9 rise=1 targ v(out) val=0.9 fall=1
  meas tran tplh trig v(in) val=0.9 fall=1 targ v(out) val=0.9 rise=1
  let hl = tphl*1e12
  let lh = tplh*1e12
  echo "$wp $vm_s $&hl $&lh" >> sizing.dat
end
shell cat sizing.dat
.endc
.end
