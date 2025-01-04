@echo off
setlocal enabledelayedexpansion

set /p "format=format: "
set /p "orders=orders: "
set /p "hwaccel=hwaccel[0/1]: "

if "%hwaccel%" == "1" (
    set "cuvid=-hwaccel cuvid -c:v h264_cuvid"
    set "nvenc=-c:v h264_nvenc"
)

for %%i in (%*) do (
    if "%format%" == "" set "format=%%~xi"
    set "output=[FF] %%~ni.!format:.=!"
    ffmpeg -y !cuvid! -i "%%~i" !nvenc! -hide_banner -map_metadata 0 -metadata handler_name=@Cairl %orders% "!output!"
)
if %errorlevel% == 0 (msg * "[!time!] SUCCESS.") else (msg * "[!time!] ERROR.")

echo Press any key to delete source and rename . . . & pause >nul

for %%i in ([FF]*) do (
    set "input=%%~i"
    move /y "%%~i" "!input:[FF] =!"
)