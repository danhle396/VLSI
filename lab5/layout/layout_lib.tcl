# ============================================================
#  Thu vien ham ve layout cho Magic (SKY130), don vi micromet.
#  Dung chung cho lab3/4/5 (moi lab co 1 ban copy).
# ============================================================

# Ve hinh chu nhat lop $layer tu (x1,y1) den (x2,y2), don vi um
proc rect {layer x1 y1 x2 y2} {
    box ${x1}um ${y1}um ${x2}um ${y2}um
    paint $layer
}

# Dat nhan + tao port (de extract/LVS nhan ra chan cua cell)
set ::portidx 0
proc pin {name layer x1 y1 x2 y2 {dir inout}} {
    box ${x1}um ${y1}um ${x2}um ${y2}um
    label $name c $layer
    incr ::portidx
    port make $::portidx
    port $name class $dir
    port $name use signal
}

# In ket qua DRC: tong so loi + ly do tung loi
# Luu y: doi "drc style" se nap lai bo luat; lan check dau ngay sau do co the
# bo sot loi (da thu: met1 rong 0.10um khong bi bat). Vi vay check 2 lan.
proc report_drc {} {
    drc style drc(full)
    drc on
    select top cell
    drc check
    drc catchup
    select top cell
    drc check
    drc catchup
    set total 0
    foreach {why boxes} [drc listall why] { incr total [llength $boxes] }
    puts "DRC_COUNT $total"
    foreach {why boxes} [drc listall why] {
        puts "DRC_WHY $why : [llength $boxes] vi tri"
        foreach b [lrange $boxes 0 2] { puts "    tai $b" }
    }
}

# Luu layout, xuat GDS, trich netlist cho LVS va cho mo phong post-layout
proc save_and_extract {cell} {
    save $cell
    gds write $cell.gds
    extract all
    # netlist LVS: chi transistor + ket noi
    ext2spice lvs
    ext2spice -o ${cell}_lvs.spice
    # netlist post-layout: them tu ky sinh (moi tu > 0 fF)
    ext2spice default
    ext2spice cthresh 0
    ext2spice -o ${cell}_pex.spice
    puts "SAVED $cell.mag $cell.gds ${cell}_lvs.spice ${cell}_pex.spice"
}
