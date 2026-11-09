* ============================================================
*  Lab 3 - Testbench 2: dac tuyen truyen dat DC (VTC)
*  Quet Vin 0 -> 1.8 V, do:
*    VM            nguong chuyen mach, v(out) = v(in)
*    VIL, VIH      diem co do loi dVout/dVin = -1
*    VOH, VOL      ngo ra tai VIL, VIH
*    NMH, NML      le nhieu muc cao / thap
*    Gmax          do loi lon nhat tai VM
*    Isc peak      dong ngan mach dinh tu VDD
* ============================================================
.include ../netlist/sky130_models.spice
.include ../netlist/inv.spice

Vdd vdd 0 1.8
Vin in  0 0
X1  in out vdd 0 inv wn=1 wp=2.5

.control
dc Vin 0 1.8 1m
let gain = deriv(v(out))
let isc  = -i(Vdd)
meas dc VM   find v(in)  when v(out)=v(in)
meas dc VIL  find v(in)  when gain=-1 cross=1
meas dc VIH  find v(in)  when gain=-1 cross=2
meas dc VOH  find v(out) when gain=-1 cross=1
meas dc VOL  find v(out) when gain=-1 cross=2
meas dc GMIN min gain
meas dc ISC_PEAK max isc
let NMH = VOH - VIH
let NML = VIL - VOL
echo
echo "================ KET QUA VTC INVERTER ================"
print VM VIL VIH VOL VOH NML NMH GMIN ISC_PEAK
echo "======================================================"
wrdata vtc.dat v(out) gain isc
.endc
.end
