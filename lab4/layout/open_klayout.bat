@echo off
REM ============================================================
REM  Mo layout GDS bang KLayout, kem bang mau lop chuan SKY130
REM  open_klayout.bat            : mo nand.gds
REM  open_klayout.bat ten_cell   : mo ten_cell.gds trong thu muc nay
REM ============================================================
setlocal
set C=%~1
if "%C%"=="" set C=nand
set LYP=C:\Users\ADMIN\.volare\volare\sky130\versions\c6d73a35f524070e85faff4a6a9eef49553ebc2b\sky130A\libs.tech\klayout\tech\sky130A.lyp

set KL=
for %%P in ("%ProgramFiles%\KLayout\klayout_app.exe" "%APPDATA%\KLayout\klayout_app.exe" "%LOCALAPPDATA%\KLayout\klayout_app.exe") do (
  if exist %%P if not defined KL set KL=%%~P
)
if not defined KL (
  echo Khong tim thay KLayout. Cai bang:  winget install KLayout.KLayout
  pause
  exit /b 1
)
cd /d "%~dp0"
if not exist "%C%.gds" (
  echo Chua co %C%.gds - hay chay run_layout.bat truoc.
  pause
  exit /b 1
)
start "" "%KL%" -l "%LYP%" "%CD%\%C%.gds"
endlocal
