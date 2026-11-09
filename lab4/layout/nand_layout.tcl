# ============================================================
#  Lab 4 - Layout CMOS NAND (SKY130), dung bang script Magic.
#  PMOS W=2.5 (song song), NMOS W=2 (noi tiep), L=0.15
#
#  Hai duong poly doc dung chung cho PMOS va NMOS:
#     line1 x 0.70..0.85 = ngo vao b ,  line2 x 1.16..1.31 = ngo vao a
#  PMOS (song song):  vdd | b | y | a | vdd      (drain y dung chung o giua)
#  NMOS (noi tiep)  :  vss | b | n1 | a | y       (n1 = diff chung, khong tiep diem)
#  => MNA (gate a) nam sat ngo ra y, MNB (gate b) sat vss, dung nhu schematic.
# ============================================================
source [file join [file dirname [info script]] layout_lib.tcl]
# xoa layout cu de moi lan chay deu dung lai tu dau
foreach c {nand} { file delete -force $c.mag $c.ext }

proc draw_nand {} {
    set W 2.01
    # ---- ray nguon + tap than ----
    rect metal1  0.00 -0.24 $W  0.24
    rect metal1  0.00  7.20 $W  7.68
    rect psubdiff     0.40 -0.21 1.61 0.21
    rect psubdiffcont 0.46 -0.085 0.63 0.085
    rect nwell       -0.10  3.50 2.11 7.90
    rect nsubdiff     0.40  7.23 1.61 7.65
    rect nsubdiffcont 0.46  7.355 0.63 7.525
    rect nsubdiffcont 1.38  7.355 1.55 7.525
    # ---- NMOS noi tiep: ndiff W=2 ----
    rect ndiff  0.40 0.60 1.61 2.60
    rect ndiffc 0.46 0.66 0.63 2.54
    rect ndiffc 1.38 0.66 1.55 2.54
    # ---- PMOS song song: pdiff W=2.5 ----
    rect pdiff  0.40 4.30 1.61 6.80
    rect pdiffc 0.46 4.36 0.63 6.74
    rect pdiffc 0.92 4.36 1.09 6.74
    rect pdiffc 1.38 4.36 1.55 6.74
    # ---- 2 duong gate poly ----
    rect poly 0.70 0.47 0.85 6.93
    rect poly 1.16 0.47 1.31 6.93
    # ---- pad ngo vao b (ben trai, duoi) ----
    rect poly     0.25 2.83 0.85 3.10
    rect polycont 0.33 2.88 0.50 3.05
    rect locali   0.25 2.80 0.58 3.13
    # ---- pad ngo vao a (ben phai, tren) ----
    rect poly     1.16 3.675 1.59 3.945
    rect polycont 1.34 3.725 1.51 3.895
    rect locali   1.26 3.64 1.59 3.97
    # ---- li: source NMOS -> vss ----
    rect locali 0.46 -0.165 0.63 2.62
    rect viali  0.46 -0.085 0.63 0.085
    # ---- li: 2 source PMOS -> vdd ----
    rect locali 0.46 4.28 0.63 7.605
    rect locali 1.38 4.28 1.55 7.605
    rect viali  0.46 7.355 0.63 7.525
    rect viali  1.38 7.355 1.55 7.525
    # ---- li: ngo ra y = drain NMOS (phai) + drain PMOS (giua) ----
    rect locali 1.38 0.58 1.55 3.47
    rect locali 0.92 3.30 1.55 3.47
    rect locali 0.92 3.30 1.09 6.82
    # ---- chan (port) ----
    pin a    locali 1.26 3.64 1.59 3.97 input
    pin b    locali 0.25 2.80 0.58 3.13 input
    pin y    locali 0.92 3.30 1.55 3.47 output
    pin vdd  metal1 0.00 7.20 $W 7.68
    pin vss  metal1 0.00 -0.24 $W 0.24
}

load nand -force
draw_nand
report_drc
save_and_extract nand
