@echo off
REM ============================================================
REM  Lab 5 - CMOS D Flip-Flop (SKY130)
REM  Mo phong bang ngspice + PDK SKY130, ve do thi bang Python
REM
REM  run.bat          : chay tat ca testbench roi ve do thi
REM  run.bat func     : chi chay kiem tra chuc nang
REM  run.bat sh       : chi chay do setup / hold (~1 phut)
REM  run.bat plot     : chi kiem tra + ve lai do thi
REM  run.bat clean    : xoa file sinh ra
REM ============================================================
setlocal
set NGSPICE=C:\Spice64\bin\ngspice_con.exe
set TB=..\tb

if "%1"=="clean"  goto clean
if "%1"=="plot"   goto plot
if "%1"=="func"   goto func
if "%1"=="sh"     goto sh

:all
call :func
call :sh
goto plot

:func
echo --- tb_func : kiem tra chuc nang ---
%NGSPICE% -b %TB%\tb_func.sp > func.log 2>&1
findstr /R /C:"^[a-z_]* = " func.log
type func.dat
if not "%1"=="" goto end
exit /b

:sh
echo --- tb_setup_hold : do setup / hold ---
%NGSPICE% -b %TB%\tb_setup_hold.sp > setup_hold.log 2>&1
if not "%1"=="" goto end
exit /b

:plot
echo --- Kiem tra + ve do thi ---
python plot.py
goto end

:clean
del /Q *.dat *.log 2>nul
del /Q ..\results\*.png 2>nul
echo Da don dep.
goto end

:end
endlocal
