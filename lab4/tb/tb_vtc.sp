* ============================================================
*  Lab 4 - Testbench 1: dac tuyen truyen dat DC (VTC) cua NAND
*  Ba truong hop duoc mo phong cung luc:
*    X1 : quet a, b = VDD   (a noi transistor NMOS tren, gan ngo ra)
*    X2 : quet b, a = VDD   (b noi transistor NMOS duoi, gan GND)
*    X3 : quet a = b        (hai ngo vao chuyen mach dong thoi)
* ============================================================
.include ../netlist/sky130_models.spice
.include ../netlist/nand.spice

Vdd vdd 0 1.8
Vin in  0 0
X1  in  vdd y1 vdd 0 nand
X2  vdd in  y2 vdd 0 nand
X3  in  in  y3 vdd 0 nand

.control
dc Vin 0 1.8 1m
let g1 = deriv(v(y1))
let g2 = deriv(v(y2))
let g3 = deriv(v(y3))
meas dc VM_A  find v(in) when v(y1)=v(in)
meas dc VM_B  find v(in) when v(y2)=v(in)
meas dc VM_AB find v(in) when v(y3)=v(in)
meas dc VIL_A find v(in) when g1=-1 cross=1
meas dc VIH_A find v(in) when g1=-1 cross=2
meas dc VOH_A find v(y1) when g1=-1 cross=1
meas dc VOL_A find v(y1) when g1=-1 cross=2
meas dc VIL_B find v(in) when g2=-1 cross=1
meas dc VIH_B find v(in) when g2=-1 cross=2
meas dc VOH_B find v(y2) when g2=-1 cross=1
meas dc VOL_B find v(y2) when g2=-1 cross=2
meas dc VIL_AB find v(in) when g3=-1 cross=1
meas dc VIH_AB find v(in) when g3=-1 cross=2
meas dc VOH_AB find v(y3) when g3=-1 cross=1
meas dc VOL_AB find v(y3) when g3=-1 cross=2
let NML_A  = VIL_A  - VOL_A
let NMH_A  = VOH_A  - VIH_A
let NML_B  = VIL_B  - VOL_B
let NMH_B  = VOH_B  - VIH_B
let NML_AB = VIL_AB - VOL_AB
let NMH_AB = VOH_AB - VIH_AB
echo
echo "================ KET QUA VTC NAND ================"
print VM_A  VIL_A  VIH_A  NML_A  NMH_A
print VM_B  VIL_B  VIH_B  NML_B  NMH_B
print VM_AB VIL_AB VIH_AB NML_AB NMH_AB
echo "==================================================="
wrdata vtc.dat v(y1) v(y2) v(y3)
.endc
.end
