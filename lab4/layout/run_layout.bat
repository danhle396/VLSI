@echo off
REM ============================================================
REM  Lab 4 - Luong layout: Magic (layout, DRC, extract) -> Netgen (LVS)
REM  -> netlist post-layout -> anh layout -> mo phong post-layout
REM  run_layout.bat      : ve lai tu *_layout.tcl (xoa .mag cu)
REM  run_layout.bat mag  : giu .mag da sua tay trong Magic, chi kiem tra
REM  Can: Cygwin (magic, netgen, xschem), Python (gdstk), ngspice
REM ============================================================
setlocal
set CYG=C:\Users\ADMIN\cygwin64\bin
cd /d "%~dp0"
set HERE=%CD%
"%CYG%\bash.exe" -l -c "cd \"$(cygpath -u '%HERE%')\" && bash flow.sh nand %1"
echo --- [4] Netlist post-layout + anh layout
python make_post_netlists.py nand
python plot_gds.py nand 2.6
echo --- [5] Mo phong post-layout
cd ..\sim
C:\Spice64\bin\ngspice_con.exe -b ..\tb\tb_post.sp > post.log 2>&1
python plot_post.py
type post.dat
type post_truth.dat
endlocal
