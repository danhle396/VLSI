# ============================================================
#  Lab 5 - Layout D flip-flop (SKY130), dung bang script Magic.
#  Phan cap giong schematic: cell inv (tu Lab 3) + cell tgate,
#  12 instance xep thanh 1 hang, dung chung ray vdd/vss.
#
#  Thu tu:  Xc1 Xc2 Xtg1 Xi1 Xi2 Xtg2 Xtg3 Xi3 Xi4 Xtg4 Xo1 Xo2
#  Day noi giua cell: metal2 ngang theo "track", metal1 doc (stub),
#  mcon (li->met1) + via1 (met1->met2).
#    Track duoi: L1 clkn | L2 clkp | L3 m3 , s2
#    Track tren: H1 clkn | H2 clkp | H3 m1 , s3 | H4 m2 , s1
#  (en cua TG chi xuong duoc, en_b chi len duoc -> clock can ca 2 phia;
#   2 track cua cung 1 clock noi qua cot li ngo ra cua inverter clock.)
# ============================================================
source [file join [file dirname [info script]] layout_lib.tcl]
# xoa layout cu de moi lan chay deu dung lai tu dau
foreach c {inv tgate dff} { file delete -force $c.mag $c.ext }

# ------------------------------------------------------------------
# Cell inv: giong het Lab 3 (rong 1.56 um, ray y=0 va y=6.14)
# ------------------------------------------------------------------
proc draw_inv {} {
    rect metal1  0.00 -0.24 1.56  0.24
    rect metal1  0.00  5.90 1.56  6.38
    rect psubdiff     0.40 -0.21 1.15 0.21
    rect psubdiffcont 0.46 -0.085 0.63 0.085
    rect nwell       -0.10  2.40 1.66 6.60
    rect nsubdiff     0.40  5.93 1.15 6.35
    rect nsubdiffcont 0.46  6.055 0.63 6.225
    rect ndiff  0.40 0.60 1.15 1.60
    rect ndiffc 0.46 0.66 0.63 1.54
    rect ndiffc 0.92 0.66 1.09 1.54
    rect pdiff  0.40 3.00 1.15 5.50
    rect pdiffc 0.46 3.06 0.63 5.44
    rect pdiffc 0.92 3.06 1.09 5.44
    rect poly     0.70 0.47 0.85 5.63
    rect poly     0.42 2.10 0.85 2.44
    rect polycont 0.50 2.185 0.67 2.355
    rect locali 0.46 -0.165 0.63 1.62
    rect locali 0.46 2.98 0.63 6.305
    rect viali  0.46 -0.085 0.63 0.085
    rect viali  0.46 6.055 0.63 6.225
    rect locali 0.92 0.58 1.09 5.52
    rect locali 0.42 2.105 0.75 2.435
    pin in   locali 0.42 2.105 0.75 2.435 input
    pin out  locali 0.92 2.60 1.09 2.90 output
    pin vdd  metal1 0.00 5.90 1.56 6.38
    pin vss  metal1 0.00 -0.24 1.56 0.24
}

# ------------------------------------------------------------------
# Cell tgate (rong 2.09 um): NMOS W=1 // PMOS W=2.5 giua x va y.
# Gate NMOS (en) va gate PMOS (en_b) la 2 doan poly RIENG.
#   cot li trai = x, cot li phai = y, pad en (duoi) va en_b (tren) o giua
# ------------------------------------------------------------------
proc draw_tgate {} {
    set W 2.09
    rect metal1  0.00 -0.24 $W  0.24
    rect metal1  0.00  5.90 $W  6.38
    # tap than: NMOS -> vss, PMOS -> vdd
    rect psubdiff     0.40 -0.21 1.69 0.21
    rect psubdiffcont 0.46 -0.085 0.63 0.085
    rect locali       0.46 -0.20 0.63 0.20
    rect viali        0.46 -0.085 0.63 0.085
    rect nwell       -0.10  2.40 [expr {$W + 0.10}] 6.60
    rect nsubdiff     0.40  5.93 1.69 6.35
    rect nsubdiffcont 0.46  6.055 0.63 6.225
    rect locali       0.46  5.94 0.63 6.34
    rect viali        0.46  6.055 0.63 6.225
    # NMOS
    rect ndiff  0.40 0.60 1.69 1.60
    rect ndiffc 0.46 0.66 0.63 1.54
    rect ndiffc 1.46 0.66 1.63 1.54
    # PMOS
    rect pdiff  0.40 3.00 1.69 5.50
    rect pdiffc 0.46 3.06 0.63 5.44
    rect pdiffc 1.46 3.06 1.63 5.44
    # gate NMOS (en) + pad
    rect poly     0.97 0.47 1.12 2.10
    rect poly     0.88 1.77 1.21 2.10
    rect polycont 0.96 1.85 1.13 2.02
    rect locali   0.88 1.80 1.21 2.07
    # gate PMOS (en_b) + pad
    rect poly     0.97 2.47 1.12 5.63
    rect poly     0.88 2.47 1.21 2.80
    rect polycont 0.96 2.55 1.13 2.72
    rect locali   0.88 2.50 1.21 2.77
    # cot li x (trai) va y (phai), noi NMOS voi PMOS
    rect locali 0.46 0.58 0.63 5.52
    rect locali 1.46 0.58 1.63 5.52
    pin x    locali 0.46 2.60 0.63 2.90
    pin y    locali 1.46 2.60 1.63 2.90
    pin en   locali 0.88 1.80 1.21 2.07 input
    pin en_b locali 0.88 2.50 1.21 2.77 input
    pin vdd  metal1 0.00 5.90 $W 6.38
    pin vss  metal1 0.00 -0.24 $W 0.24
}

# ------------------------------------------------------------------
# Cac ham di day o cell top
# ------------------------------------------------------------------
proc mcon_pad {x y} {                  ;# li -> met1
    rect viali  [expr {$x-0.085}] [expr {$y-0.085}] [expr {$x+0.085}] [expr {$y+0.085}]
    rect metal1 [expr {$x-0.16}]  [expr {$y-0.16}]  [expr {$x+0.16}]  [expr {$y+0.16}]
}
proc via12 {x y} {                     ;# met1 -> met2
    rect metal1 [expr {$x-0.16}] [expr {$y-0.16}] [expr {$x+0.16}] [expr {$y+0.16}]
    rect via1   [expr {$x-0.13}] [expr {$y-0.13}] [expr {$x+0.13}] [expr {$y+0.13}]
    rect metal2 [expr {$x-0.16}] [expr {$y-0.16}] [expr {$x+0.16}] [expr {$y+0.16}]
}
proc stub {x y1 y2} {                  ;# met1 doc
    set lo [expr {min($y1,$y2)}]; set hi [expr {max($y1,$y2)}]
    rect metal1 [expr {$x-0.07}] $lo [expr {$x+0.07}] $hi
}
proc track {y x1 x2} {                 ;# met2 ngang
    rect metal2 [expr {$x1-0.16}] [expr {$y-0.10}] [expr {$x2+0.16}] [expr {$y+0.10}]
}
# chan dang cot li (inv.out, tg.x, tg.y): mcon + via ngay tai track
proc col_to {x y} { mcon_pad $x $y; via12 $x $y }
# chan dang pad (inv.in, tg.en, tg.en_b): mcon tai pad, stub den track, via
proc pad_to {x ypad y} { mcon_pad $x $ypad; stub $x $ypad $y; via12 $x $y }

# ------------------------------------------------------------------
load inv -force
draw_inv
save inv
load tgate -force
draw_tgate
save tgate

load dff -force
# vi tri (x) cua 12 instance
set cells {Xc1 inv Xc2 inv Xtg1 tgate Xi1 inv Xi2 inv Xtg2 tgate
           Xtg3 tgate Xi3 inv Xi4 inv Xtg4 tgate Xo1 inv Xo2 inv}
set x 0.0
foreach {name type} $cells {
    set X($name) $x
    box ${x}um 0um ${x}um 0um
    getcell $type child 0 0
    identify $name
    set x [expr {$x + ($type eq "inv" ? 1.56 : 2.09)}]
}
set XEND $x

# toa do chan (trong cell) -> toa do toan cuc
proc IN  {c} { return [expr {$::X($c) + 0.585}] }   ;# inv.in  (pad y 2.27)
proc OUT {c} { return [expr {$::X($c) + 1.005}] }   ;# inv.out (cot li)
proc TX  {c} { return [expr {$::X($c) + 0.545}] }   ;# tg.x    (cot li)
proc TY  {c} { return [expr {$::X($c) + 1.545}] }   ;# tg.y    (cot li)
proc TEN {c} { return [expr {$::X($c) + 1.045}] }   ;# tg.en (pad y 1.935) / en_b (pad y 2.635)

set L1 0.55; set L2 1.00; set L3 1.45
set H1 3.20; set H2 3.65; set H3 4.10; set H4 4.55
set YIN 2.27; set YEN 1.935; set YENB 2.635

# ---- clkn: Xc1.out, Xc2.in, Xtg1.en, Xtg4.en (duoi) ; Xtg2.en_b, Xtg3.en_b (tren)
col_to [OUT Xc1] $L1 ; col_to [OUT Xc1] $H1
pad_to [IN Xc2] $YIN $L1
pad_to [TEN Xtg1] $YEN $L1 ; pad_to [TEN Xtg4] $YEN $L1
pad_to [TEN Xtg2] $YENB $H1 ; pad_to [TEN Xtg3] $YENB $H1
track $L1 [OUT Xc1] [TEN Xtg4]
track $H1 [OUT Xc1] [TEN Xtg3]
# ---- clkp: Xc2.out, Xtg2.en, Xtg3.en (duoi) ; Xtg1.en_b, Xtg4.en_b (tren)
col_to [OUT Xc2] $L2 ; col_to [OUT Xc2] $H2
pad_to [TEN Xtg2] $YEN $L2 ; pad_to [TEN Xtg3] $YEN $L2
pad_to [TEN Xtg1] $YENB $H2 ; pad_to [TEN Xtg4] $YENB $H2
track $L2 [OUT Xc2] [TEN Xtg3]
track $H2 [OUT Xc2] [TEN Xtg4]
# ---- m1: Xtg1.y, Xi1.in, Xtg2.y   (H3)
col_to [TY Xtg1] $H3 ; pad_to [IN Xi1] $YIN $H3 ; col_to [TY Xtg2] $H3
track $H3 [TY Xtg1] [TY Xtg2]
# ---- m2: Xi1.out, Xi2.in, Xtg3.x  (H4)
col_to [OUT Xi1] $H4 ; pad_to [IN Xi2] $YIN $H4 ; col_to [TX Xtg3] $H4
track $H4 [OUT Xi1] [TX Xtg3]
# ---- m3: Xi2.out, Xtg2.x          (L3)
col_to [OUT Xi2] $L3 ; col_to [TX Xtg2] $L3
track $L3 [OUT Xi2] [TX Xtg2]
# ---- s1: Xtg3.y, Xi3.in, Xtg4.y   (H4)
col_to [TY Xtg3] $H4 ; pad_to [IN Xi3] $YIN $H4 ; col_to [TY Xtg4] $H4
track $H4 [TY Xtg3] [TY Xtg4]
# ---- s2: Xi3.out, Xi4.in, Xo2.in  (L3)
col_to [OUT Xi3] $L3 ; pad_to [IN Xi4] $YIN $L3 ; pad_to [IN Xo2] $YIN $L3
track $L3 [OUT Xi3] [IN Xo2]
# ---- s3: Xi4.out, Xtg4.x, Xo1.in  (H3)
col_to [OUT Xi4] $H3 ; col_to [TX Xtg4] $H3 ; pad_to [IN Xo1] $YIN $H3
track $H3 [OUT Xi4] [IN Xo1]

# ---- nhan ten net noi bo (khong phai chan) de netlist trich ra de doc ----
proc netlabel {name x y} {
    box ${x}um ${y}um ${x}um ${y}um
    label $name c metal2
}
netlabel clkn [OUT Xc1] $L1 ; netlabel clkp [OUT Xc2] $L2
netlabel m1 [TY Xtg1] $H3 ; netlabel m2 [OUT Xi1] $H4 ; netlabel m3 [OUT Xi2] $L3
netlabel s1 [TY Xtg3] $H4 ; netlabel s2 [OUT Xi3] $L3 ; netlabel s3 [OUT Xi4] $H3

# ---- chan cua dff (tren metal1) ----
mcon_pad [IN Xc1] $YIN
mcon_pad [TX Xtg1] 2.70
mcon_pad [OUT Xo1] 2.70
mcon_pad [OUT Xo2] 2.70
set p 0.16
pin clk metal1 [expr {[IN Xc1]-$p}]  [expr {$YIN-$p}] [expr {[IN Xc1]+$p}]  [expr {$YIN+$p}] input
pin d   metal1 [expr {[TX Xtg1]-$p}] [expr {2.70-$p}] [expr {[TX Xtg1]+$p}] [expr {2.70+$p}] input
pin q   metal1 [expr {[OUT Xo1]-$p}] [expr {2.70-$p}] [expr {[OUT Xo1]+$p}] [expr {2.70+$p}] output
pin qb  metal1 [expr {[OUT Xo2]-$p}] [expr {2.70-$p}] [expr {[OUT Xo2]+$p}] [expr {2.70+$p}] output
# ray nguon o cell top (de nhan vdd/vss gan vao kim loai that)
rect metal1 0.00 5.90 $XEND 6.38
rect metal1 0.00 -0.24 $XEND 0.24
pin vdd metal1 0.00 5.90 $XEND 6.38
pin vss metal1 0.00 -0.24 $XEND 0.24

report_drc
save_and_extract dff
