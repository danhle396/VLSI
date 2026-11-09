v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {sky130_fd_pr/nfet_01v8.sym} 0 0 0 0 {name=MN
W=1
L=0.15
nf=1
mult=1
model=nfet_01v8
spiceprefix=X}
C {sky130_fd_pr/pfet_01v8.sym} 360 0 0 1 {name=MP
W=2.5
L=0.15
nf=1
mult=1
model=pfet_01v8
spiceprefix=X}
N 20 -60 20 -30 {lab=x}
N 340 -60 340 -30 {lab=x}
N 20 -60 180 -60 {lab=x}
N 180 -60 340 -60 {lab=x}
N 180 -100 180 -60 {lab=x}
N 20 30 20 60 {lab=y}
N 340 30 340 60 {lab=y}
N 20 60 180 60 {lab=y}
N 180 60 340 60 {lab=y}
N 180 60 180 100 {lab=y}
N -80 0 -20 0 {lab=en}
N 380 0 440 0 {lab=en_b}
N 20 0 130 0 {lab=vss}
C {lab_pin.sym} 130 0 0 1 {name=l1
lab=vss}
N 340 0 230 0 {lab=vdd}
C {lab_pin.sym} 230 0 0 0 {name=l2
lab=vdd}
C {iopin.sym} 180 -100 0 0 {name=p1
lab=x}
C {iopin.sym} 180 100 0 0 {name=p2
lab=y}
C {ipin.sym} -80 0 0 0 {name=p3
lab=en}
C {ipin.sym} 440 0 0 1 {name=p4
lab=en_b}
C {iopin.sym} -80 -140 0 1 {name=p5
lab=vdd}
C {iopin.sym} -80 140 0 1 {name=p6
lab=vss}
T {Transmission gate: conducts when en=1, en_b=0} -80 -200 0 0 0.4 0.4 {}
