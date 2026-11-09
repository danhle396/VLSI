v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {vsource.sym} -900 0 0 0 {name=Vdd
value="1.8"
savecurrent=true}
N -900 -60 -900 -30 {lab=vdd}
C {lab_pin.sym} -900 -60 3 0 {name=l1
lab=vdd}
N -900 30 -900 60 {lab=0}
C {gnd.sym} -900 60 0 0 {name=g1
lab=0}
C {vsource.sym} -760 0 0 0 {name=Vclk
value="pulse(0 1.8 1n 20p 20p 0.98n 2n)"
savecurrent=true}
N -760 -60 -760 -30 {lab=clk}
C {lab_pin.sym} -760 -60 3 0 {name=l2
lab=clk}
N -760 30 -760 60 {lab=0}
C {gnd.sym} -760 60 0 0 {name=g2
lab=0}
C {vsource.sym} -460 0 0 0 {name=Vd
value="pwl(0 0 0.5n 0 0.52n 1.8 2.5n 1.8 2.52n 0
+ 4.5n 0 4.52n 1.8 5.4n 1.8 5.42n 0 5.8n 0 5.82n 1.8
+ 8.5n 1.8 8.52n 0 9.3n 0 9.32n 1.8 9.6n 1.8 9.62n 0
+ 10.1n 0 10.12n 1.8 10.3n 1.8 10.32n 0
+ 12.5n 0 12.52n 1.8 14.5n 1.8 14.52n 0)"
savecurrent=true}
N -460 -60 -460 -30 {lab=d}
C {lab_pin.sym} -460 -60 3 0 {name=l3
lab=d}
N -460 30 -460 60 {lab=0}
C {gnd.sym} -460 60 0 0 {name=g3
lab=0}
C {dff.sym} 0 0 0 0 {name=x1}
N -100 -20 -60 -20 {lab=d}
C {lab_pin.sym} -100 -20 0 0 {name=l4
lab=d}
N -100 20 -60 20 {lab=clk}
C {lab_pin.sym} -100 20 0 0 {name=l5
lab=clk}
N 0 -70 0 -50 {lab=vdd}
C {lab_pin.sym} 0 -70 3 0 {name=l6
lab=vdd}
N 0 50 0 80 {lab=0}
C {gnd.sym} 0 80 0 0 {name=g7
lab=0}
N 60 -20 160 -20 {lab=q}
N 160 -20 160 10 {lab=q}
C {lab_pin.sym} 110 -20 3 0 {name=l8
lab=q}
C {capa.sym} 160 40 0 0 {name=CLq
m=1
value=5f}
N 160 70 160 100 {lab=0}
C {gnd.sym} 160 100 0 0 {name=g9
lab=0}
N 60 20 260 20 {lab=qb}
N 260 20 260 30 {lab=qb}
C {lab_pin.sym} 210 20 3 0 {name=l10
lab=qb}
C {capa.sym} 260 60 0 0 {name=CLqb
m=1
value=5f}
N 260 90 260 120 {lab=0}
C {gnd.sym} 260 120 0 0 {name=g11
lab=0}
C {sky130_fd_pr/corner.sym} -900 -400 0 0 {name=CORNER
only_toplevel=true
corner=tt}
C {code_shown.sym} -680 -420 0 0 {name=SIM
only_toplevel=false
value=".nodeset v(x1.s1)=1.8 v(x1.s2)=0
.control
save all
tran 1p 17n
meas tran tcq_LH trig v(clk) val=0.9 rise=1 targ v(q) val=0.9 rise=1
meas tran tcq_HL trig v(clk) val=0.9 rise=2 targ v(q) val=0.9 fall=1
plot v(clk)+4 v(d)+2 v(q)
.endc"}
T {Testbench D flip-flop: clk 500 MHz, with glitches} -900 -200 0 0 0.4 0.4 {}
