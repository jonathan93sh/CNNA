@echo off

set VIVADO_BIN=D:\Xilinx\Vivado\2018.3\bin\

set PATH=%VIVADO_BIN%;%PATH%;%VIVADO_BIN%..\msys64\usr\bin;%VIVADO_BIN%..\msys64\mingw64\bin


set AUTOESL_HOME=%VIVADO_BIN%..
set VIVADO_HLS_HOME=%VIVADO_BIN%..

set PATH=%PATH%;%VIVADO_HLS_HOME%\win64\tools\fpo_v7_0
set PATH=%PATH%;%VIVADO_HLS_HOME%\win64\tools\opencv
set PATH=%PATH%;%VIVADO_HLS_HOME%\win64\tools\fft_v9_1
set PATH=%PATH%;%VIVADO_HLS_HOME%\win64\tools\fir_v7_0
set PATH=%PATH%;%VIVADO_HLS_HOME%\win64\tools\dds_v6_0

set PATH=%PATH%;%VIVADO_HLS_HOME%\win64\csim


echo ===============================
echo == Vivado HLS Command Prompt 
echo == Available commands:
echo == vivado_hls,apcc,gcc,g++,make
echo ===============================


set RDI_OS_ARCH=32
if [%PROCESSOR_ARCHITECTURE%] == [x86] (
  if defined PROCESSOR_ARCHITEW6432 (
    set RDI_OS_ARCH=64
  )
) else (
  if defined PROCESSOR_ARCHITECTURE (
    set RDI_OS_ARCH=64
  )
)

echo exec line %*

if not "%RDI_OS_ARCH%" == "64" goto _NotX64
set COMSPEC=%WINDIR%\SysWOW64\cmd.exe
%COMSPEC% %*
goto EOF

:_NotX64
set COMSPEC=%WINDIR%\System32\cmd.exe
rem %COMSPEC% /c %0 %1 %2 %3 %4 %5 %6 %7 %8 %9 
%COMSPEC% %*
 
:EOF

