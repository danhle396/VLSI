@echo off
REM ============================================================
REM  Lab 2 - Flip-Flops: SR, D, JK
REM  Chay mo phong bang Icarus Verilog
REM
REM  run.bat        : bien dich va chay mo phong
REM  run.bat wave   : chay mo phong roi mo GTKWave
REM  run.bat clean  : xoa file sinh ra
REM ============================================================
setlocal
set PATH=C:\iverilog\bin;%PATH%
set RTL=..\rtl
set TB=..\tb

if "%1"=="clean" goto clean
if "%1"=="wave"  goto wave

:run
echo --- Bien dich ---
iverilog -g2005 -Wall -s testbench -o sim.vvp %RTL%\sr_ff.v %RTL%\d_ff.v %RTL%\jk_ff.v %TB%\testbench.v
if errorlevel 1 exit /b 1
echo --- Chay mo phong ---
vvp sim.vvp
goto end

:wave
call :run
gtkwave wave.vcd
goto end

:clean
del /Q *.vvp *.vcd 2>nul
echo Da don dep.
goto end

:end
endlocal
