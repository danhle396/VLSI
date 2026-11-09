# ============================================================
#  Lab 3 - Layout CMOS inverter (SKY130), dung bang script Magic.
#  NMOS W=1 L=0.15, PMOS W=2.5 L=0.15 (giong schematic inv.sch)
#
#   y (um)
#   6.14  ======== vdd (metal1) + ntap =========
#          nwell  [ pdiff 3.00..5.50 ]  PMOS
#   2.27          [poly pad + in]
#          psub   [ ndiff 0.60..1.60 ]  NMOS
#   0.00  ======== vss (metal1) + ptap =========
#         x: S contact 0.46..0.63 | gate 0.70..0.85 | D contact 0.92..1.09
# ============================================================
source [file join [file dirname [info script]] layout_lib.tcl]
# xoa layout cu de moi lan chay deu dung lai tu dau
foreach c {inv} { file delete -force $c.mag $c.ext }

proc draw_inv {} {
    # ---- ray nguon metal1 ----
    rect metal1  0.00 -0.24 1.56  0.24
    rect metal1  0.00  5.90 1.56  6.38
    # ---- tap than: ptap duoi (noi vss), ntap tren trong nwell (noi vdd) ----
    rect psubdiff     0.40 -0.21 1.15 0.21
    rect psubdiffcont 0.46 -0.085 0.63 0.085
    rect nwell       -0.10  2.40 1.66 6.60
    rect nsubdiff     0.40  5.93 1.15 6.35
    rect nsubdiffcont 0.46  6.055 0.63 6.225
    # ---- NMOS: ndiff + tiep diem S/D ----
    rect ndiff  0.40 0.60 1.15 1.60
    rect ndiffc 0.46 0.66 0.63 1.54
    rect ndiffc 0.92 0.66 1.09 1.54
    # ---- PMOS ----
    rect pdiff  0.40 3.00 1.15 5.50
    rect pdiffc 0.46 3.06 0.63 5.44
    rect pdiffc 0.92 3.06 1.09 5.44
    # ---- gate poly chung + pad tiep diem ngo vao ----
    rect poly     0.70 0.47 0.85 5.63
    rect poly     0.42 2.10 0.85 2.44
    rect polycont 0.50 2.185 0.67 2.355
    # ---- li: source NMOS xuong vss, source PMOS len vdd ----
    rect locali 0.46 -0.165 0.63 1.62
    rect locali 0.46 2.98 0.63 6.305
    rect viali  0.46 -0.085 0.63 0.085
    rect viali  0.46 6.055 0.63 6.225
    # ---- li: drain NMOS + drain PMOS = out ----
    rect locali 0.92 0.58 1.09 5.52
    # ---- li: pad ngo vao ----
    rect locali 0.42 2.105 0.75 2.435
    # ---- chan (port) ----
    pin in   locali 0.42 2.105 0.75 2.435 input
    pin out  locali 0.92 2.60 1.09 2.90 output
    pin vdd  metal1 0.00 5.90 1.56 6.38
    pin vss  metal1 0.00 -0.24 1.56 0.24
}

load inv -force
draw_inv
report_drc
save_and_extract inv
