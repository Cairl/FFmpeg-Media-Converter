@echo off
setlocal enabledelayedexpansion

if exist "%~1\" goto folder
if exist "%~1" goto files

:folder
set "title=folder" & title *!title!*

echo Type of format in folder:
for %%f in ("%~1\*") do (
    set "ext=%%~xf"
    if not defined extensions[!ext!] (
        set /a index+=1
        set "extensions[!ext!]=!index!"
        echo !index! - !ext:.=!
        set "file[!index!]=!ext:.=!"
    )
)
echo.

:folder_config
set /p "selected_ext=Select type of format (Serial number only): "
if not defined selected_ext (goto folder_config) else (set "selected_ext=!file[%selected_ext%]!")

set /p "encoding_ext=Select type of encoding (Default: !selected_ext!): "
if not defined encoding_ext (set "encoding_ext=!selected_ext!")

for %%i in ("%~1\*.!selected_ext!") do (
    cls
    ffmpeg -y -i "%%~i" -hide_banner -map_metadata 0 -metadata handler_name=@Cairl "%~1\[FF] %%~ni.!encoding_ext:.=!"
    cls
)

if %errorlevel% == 0 (echo [%time:~0,8%] SUCCESS.) else (echo [%time:~0,8%] ERROR.)

goto rename

:files
set "title=files" & title *!title!*

echo Input files list:
for %%i in (%*) do echo "%%~nxi"

echo.
set /p "format=Format: "
set /p "orders=Orders: "

for %%i in (%*) do (
    cls
    if "%format%" == "" set "format=%%~xi"
    ffmpeg -y -i "%%~i" -hide_banner -map_metadata 0 -metadata handler_name=@Cairl %orders% "[FF] %%~ni.!format:.=!"
    cls
)

if %errorlevel% == 0 (echo [%time:~0,8%] SUCCESS.) else (echo [%time:~0,8%] ERROR.)

:rename
echo Press any key to rename (same name will overwrite) . . . & pause >nul

if "!title!"=="folder" set "path=%~1\*"
if "!title!"=="files" set "path=%~dp1\*"

for %%i in ("!path!") do (
    set "file=%%i"
    move /y "!file!" "!file:[FF] =!"
)