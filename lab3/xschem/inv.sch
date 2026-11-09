v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
C {sky130_fd_pr/pfet_01v8.sym} 0 -60 0 0 {name=MP
W=2.5
L=0.15
nf=1
mult=1
model=pfet_01v8
spiceprefix=X}
C {sky130_fd_pr/nfet_01v8.sym} 0 60 0 0 {name=MN
W=1
L=0.15
nf=1
mult=1
model=nfet_01v8
spiceprefix=X}
N -120 0 -20 0 {lab=in}
N -20 -60 -20 0 {lab=in}
N -20 0 -20 60 {lab=in}
N 20 -30 20 0 {lab=out}
N 20 0 20 30 {lab=out}
N 20 0 120 0 {lab=out}
N 20 -120 20 -90 {lab=vdd}
N 20 -60 60 -60 {lab=vdd}
N 60 -60 60 -120 {lab=vdd}
N -120 -120 20 -120 {lab=vdd}
N 20 -120 60 -120 {lab=vdd}
N 20 90 20 120 {lab=vss}
N 20 60 60 60 {lab=vss}
N 60 60 60 120 {lab=vss}
N -120 120 20 120 {lab=vss}
N 20 120 60 120 {lab=vss}
C {ipin.sym} -120 0 0 0 {name=p1
lab=in}
C {opin.sym} 120 0 0 0 {name=p2
lab=out}
C {iopin.sym} -120 -120 0 1 {name=p3
lab=vdd}
C {iopin.sym} -120 120 0 1 {name=p4
lab=vss}
T {CMOS Inverter - SKY130} -120 -200 0 0 0.4 0.4 {}
