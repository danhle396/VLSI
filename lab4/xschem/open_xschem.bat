@echo off
REM ============================================================
REM  Mo xschem (ban build tren Cygwin) voi schematic cua lab nay
REM
REM  open_xschem.bat               : mo tb_nand.sch
REM  open_xschem.bat ten_file.sch  : mo file khac trong thu muc nay
REM ============================================================
setlocal
set CYG=C:\Users\ADMIN\cygwin64\bin
set F=%~1
if "%F%"=="" set F=tb_nand.sch

REM Khoi dong X server cua Cygwin neu chua chay
tasklist /FI "IMAGENAME eq XWin.exe" | find /I "XWin.exe" >nul
if errorlevel 1 (
  start "" "%CYG%\XWin.exe" :0 -multiwindow -nolisten tcp
  timeout /t 3 >nul
)

cd /d "%~dp0"
"%CYG%\bash.exe" -lc "cd \"$(cygpath -u '%~dp0')\" && DISPLAY=:0 xschem '%F%'"
endlocal
