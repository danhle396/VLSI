* ============================================================
*  Lab 3 - Testbench 3: transient response
*  Input pulse 0/1.8 V, tr = tf = 20 ps, period 2 ns.
*  Load CL = 10 fF (~ fan-out of a few gates).
*  Measures: tpHL, tpLH, tp, tr (10-90 %), tf (90-10 %), average power.
*  Then sweeps CL to show that delay grows linearly with load.
* ============================================================
.include ../netlist/sky130_models.spice
.include ../netlist/inv.spice

Vdd vdd 0 1.8
Vin in  0 pulse(0 1.8 0.5n 20p 20p 1n 2n)
X1  in out vdd 0 inv wn=1 wp=2.5
CL  out 0 10f

.control
tran 1p 4.5n
meas tran tpHL trig v(in) val=0.9 rise=1 targ v(out) val=0.9 fall=1
meas tran tpLH trig v(in) val=0.9 fall=1 targ v(out) val=0.9 rise=1
meas tran tf   trig v(out) val=1.62 fall=1 targ v(out) val=0.18 fall=1
meas tran tr   trig v(out) val=0.18 rise=1 targ v(out) val=1.62 rise=1
meas tran IAVG avg i(Vdd) from=0.5n to=4.5n
let tp   = (tpHL + tpLH)/2
let PAVG = -IAVG*1.8
let EDYN = 10f*1.8*1.8
let PDYN = EDYN*500e6
echo
echo "============= TRANSIENT RESULTS - INVERTER (CL = 10 fF) ============="
print tpHL tpLH tp tr tf PAVG PDYN
echo "===================================================================="
wrdata tran.dat v(in) v(out) i(Vdd)

* ---- Load (CL) sweep ----
echo "# CL(fF)  tpHL(ps)  tpLH(ps)" > load.dat
foreach cl 2 5 10 20 50 100
  let cval = $cl*1e-15
  alter CL = $&cval
  tran 1p 4.5n
  meas tran a trig v(in) val=0.9 rise=1 targ v(out) val=0.9 fall=1
  meas tran b trig v(in) val=0.9 fall=1 targ v(out) val=0.9 rise=1
  let hl = a*1e12
  let lh = b*1e12
  echo "$cl $&hl $&lh" >> load.dat
end
shell cat load.dat
.endc
.end
