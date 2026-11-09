#!/bin/bash
# ============================================================
#  Luong layout (chay trong Cygwin): Magic -> DRC -> extract
#  -> netlist schematic (xschem) -> LVS (Netgen)
#  Dung: bash flow.sh <cell>       : ve lai layout tu <cell>_layout.tcl
#        bash flow.sh <cell> mag   : giu nguyen <cell>.mag (da sua tay trong Magic)
#  (cu): bash flow.sh nand     (run_layout.bat goi file nay)
# ============================================================
CELL=${1:-nand}
HERE=$(cd "$(dirname "$0")" && pwd)
export PDK_ROOT=/cygdrive/c/Users/ADMIN/.volare/volare/sky130/versions/c6d73a35f524070e85faff4a6a9eef49553ebc2b
export PDK=sky130A
export DISPLAY=:0
cd "$HERE"

MODE=${2:-tcl}
if [ "$MODE" = "mag" ]; then
    echo "--- [1] Magic: dung ${CELL}.mag co san (sua tay), DRC, trich netlist"
    MAGCMD="source layout_lib.tcl; load ${CELL}; report_drc; save_and_extract ${CELL}"
else
    echo "--- [1] Magic: ve layout tu ${CELL}_layout.tcl, DRC, trich netlist"
    MAGCMD="source ${CELL}_layout.tcl"
fi
magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc > magic.log 2>&1 <<TCL
$MAGCMD
quit -noprompt
TCL
grep -E "DRC_COUNT|DRC_WHY|SAVED" magic.log

echo "--- [2] xschem: netlist schematic cho LVS"
(cd ../xschem && xschem -n -s -q -x --tcl 'set lvs_netlist 1; set top_is_subckt 1; set spiceprefix 1' -o ../layout ${CELL}.sch > /dev/null 2>&1)
mv -f ${CELL}.spice ${CELL}_sch.spice

echo "--- [3] Netgen: LVS"
netgen -batch lvs "${CELL}_lvs.spice ${CELL}" "${CELL}_sch.spice ${CELL}"     $PDK_ROOT/sky130A/libs.tech/netgen/sky130A_setup.tcl ${CELL}_lvs_report.txt > netgen.log 2>&1
grep "Final result" ${CELL}_lvs_report.txt | tail -1
# "Final result: Circuits match" van co the di kem sai W/L -> phai xem them dong nay
if grep -q "Property errors were found" ${CELL}_lvs_report.txt; then
    echo "!!! LVS: co property errors (W/L lech) - xem ${CELL}_lvs_report.txt"
    grep -A1 " vs. " ${CELL}_lvs_report.txt
else
    echo "LVS properties (W/L): khop"
fi
