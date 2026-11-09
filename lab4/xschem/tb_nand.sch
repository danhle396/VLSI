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
C {vsource.sym} -760 0 0 0 {name=Va
value="pwl(0 0 2n 0 2.02n 1.8 5n 1.8
+ 5.02n 0 7n 0 7.02n 1.8 8n 1.8 8.02n 0)"
savecurrent=true}
N -760 -60 -760 -30 {lab=a}
C {lab_pin.sym} -760 -60 3 0 {name=l2
lab=a}
N -760 30 -760 60 {lab=0}
C {gnd.sym} -760 60 0 0 {name=g2
lab=0}
C {vsource.sym} -480 0 0 0 {name=Vb
value="pwl(0 0 1n 0 1.02n 1.8 3n 1.8 3.02n 0
+ 4n 0 4.02n 1.8 6n 1.8 6.02n 0
+ 7n 0 7.02n 1.8 8n 1.8 8.02n 0)"
savecurrent=true}
N -480 -60 -480 -30 {lab=b}
C {lab_pin.sym} -480 -60 3 0 {name=l3
lab=b}
N -480 30 -480 60 {lab=0}
C {gnd.sym} -480 60 0 0 {name=g3
lab=0}
C {nand.sym} 0 0 0 0 {name=x1}
N -100 -20 -60 -20 {lab=a}
C {lab_pin.sym} -100 -20 0 0 {name=l4
lab=a}
N -100 20 -60 20 {lab=b}
C {lab_pin.sym} -100 20 0 0 {name=l5
lab=b}
N 0 -70 0 -50 {lab=vdd}
C {lab_pin.sym} 0 -70 3 0 {name=l6
lab=vdd}
N 0 50 0 80 {lab=0}
C {gnd.sym} 0 80 0 0 {name=g7
lab=0}
N 60 0 160 0 {lab=y}
N 160 0 160 10 {lab=y}
C {lab_pin.sym} 110 0 3 0 {name=l8
lab=y}
C {capa.sym} 160 40 0 0 {name=CL
m=1
value=10f}
N 160 70 160 100 {lab=0}
C {gnd.sym} 160 100 0 0 {name=g9
lab=0}
C {sky130_fd_pr/corner.sym} -1000 -400 0 0 {name=CORNER
only_toplevel=true
corner=tt}
C {code_shown.sym} -780 -420 0 0 {name=SIM
only_toplevel=false
value=".control
save all
tran 1p 10n
meas tran tpHL_a trig v(a) val=0.9 rise=1 targ v(y) val=0.9 fall=1
meas tran tpLH_b trig v(b) val=0.9 fall=1 targ v(y) val=0.9 rise=1
plot v(a)+4 v(b)+2 v(y)
.endc"}
T {Testbench NAND: truth table + delay, CL = 10 fF} -940 -200 0 0 0.4 0.4 {}
