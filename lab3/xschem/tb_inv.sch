v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {vsource.sym} -400 0 0 0 {name=Vdd
value="1.8"
savecurrent=true}
N -400 -60 -400 -30 {lab=vdd}
C {lab_pin.sym} -400 -60 3 0 {name=l1
lab=vdd}
N -400 30 -400 60 {lab=0}
C {gnd.sym} -400 60 0 0 {name=g1
lab=0}
C {vsource.sym} -260 0 0 0 {name=Vin
value="pulse(0 1.8 0.5n 20p 20p 1n 2n)"
savecurrent=true}
N -260 -60 -260 -30 {lab=in}
C {lab_pin.sym} -260 -60 3 0 {name=l2
lab=in}
N -260 30 -260 60 {lab=0}
C {gnd.sym} -260 60 0 0 {name=g2
lab=0}
C {inv.sym} 0 0 0 0 {name=x1}
N -80 0 -40 0 {lab=in}
C {lab_pin.sym} -80 0 0 0 {name=l3
lab=in}
N 0 -60 0 -40 {lab=vdd}
C {lab_pin.sym} 0 -60 3 0 {name=l4
lab=vdd}
N 0 40 0 70 {lab=0}
C {gnd.sym} 0 70 0 0 {name=g5
lab=0}
N 40 0 160 0 {lab=out}
N 160 0 160 10 {lab=out}
C {lab_pin.sym} 100 0 3 0 {name=l6
lab=out}
C {capa.sym} 160 40 0 0 {name=CL
m=1
value=10f}
N 160 70 160 100 {lab=0}
C {gnd.sym} 160 100 0 0 {name=g7
lab=0}
C {sky130_fd_pr/corner.sym} -500 -400 0 0 {name=CORNER
only_toplevel=true
corner=tt}
C {code_shown.sym} -280 -420 0 0 {name=SIM
only_toplevel=false
value=".control
save all
tran 1p 4.5n
meas tran tpHL trig v(in) val=0.9 rise=1 targ v(out) val=0.9 fall=1
meas tran tpLH trig v(in) val=0.9 fall=1 targ v(out) val=0.9 rise=1
plot v(in) v(out)
.endc"}
T {Testbench inverter: transient, CL = 10 fF} -440 -200 0 0 0.4 0.4 {}
