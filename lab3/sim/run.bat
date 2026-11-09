@echo off
REM ============================================================
REM  Lab 3 - CMOS Inverter (SKY130)
REM  Mo phong bang ngspice + PDK SKY130, ve do thi bang Python
REM
REM  run.bat          : chay tat ca testbench roi ve do thi
REM  run.bat sizing   : chi chay quet Wp
REM  run.bat vtc      : chi chay VTC
REM  run.bat tran     : chi chay transient
REM  run.bat plot     : chi ve lai do thi
REM  run.bat clean    : xoa file sinh ra
REM ============================================================
setlocal
set NGSPICE=C:\Spice64\bin\ngspice_con.exe
set TB=..\tb

if "%1"=="clean"  goto clean
if "%1"=="plot"   goto plot
if "%1"=="sizing" goto sizing
if "%1"=="vtc"    goto vtc
if "%1"=="tran"   goto tran

:all
call :sizing
call :vtc
call :tran
goto plot

:sizing
echo --- tb_sizing : quet Wp ---
%NGSPICE% -b %TB%\tb_sizing.sp > sizing.log 2>&1
type sizing.dat
if not "%1"=="" goto end
exit /b

:vtc
echo --- tb_vtc : dac tuyen DC ---
%NGSPICE% -b %TB%\tb_vtc.sp > vtc.log 2>&1
findstr /R /C:"^[a-z_]* = " vtc.log
if not "%1"=="" goto end
exit /b

:tran
echo --- tb_tran : qua do ---
%NGSPICE% -b %TB%\tb_tran.sp > tran.log 2>&1
findstr /R /C:"^[a-z_]* = " tran.log
type load.dat
if not "%1"=="" goto end
exit /b

:plot
echo --- Ve do thi ---
python plot.py
goto end

:clean
del /Q *.dat *.log 2>nul
del /Q ..\results\*.png 2>nul
echo Da don dep.
goto end

:end
endlocal
