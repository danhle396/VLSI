@echo off
REM ============================================================
REM  Mo layout trong giao dien Magic (ban build tren Cygwin)
REM  open_magic.bat            : mo inv.mag
REM  open_magic.bat ten_cell   : mo cell khac trong thu muc nay
REM ============================================================
setlocal
set CYG=C:\Users\ADMIN\cygwin64\bin
set C=%~1
if "%C%"=="" set C=inv
tasklist /FI "IMAGENAME eq XWin.exe" | find /I "XWin.exe" >nul
if errorlevel 1 (
  start "" "%CYG%\XWin.exe" :0 -multiwindow -nolisten tcp
  timeout /t 3 >nul
)
cd /d "%~dp0"
set HERE=%CD%
"%CYG%\bash.exe" -l -c "export DISPLAY=:0 PDK_ROOT=/cygdrive/c/Users/ADMIN/.volare/volare/sky130/versions/c6d73a35f524070e85faff4a6a9eef49553ebc2b; cd \"$(cygpath -u '%HERE%')\" && magic -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc %C%"
endlocal
