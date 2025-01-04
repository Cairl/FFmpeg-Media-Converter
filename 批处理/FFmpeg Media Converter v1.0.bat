@echo off

set /p "format=format: "
set /p "orders=orders: "

for %%i in (%*) do (
    if "%format%" == "" (
        ffmpeg -y -i "%%~i" -hide_banner -map_metadata 0 -metadata handler_name=@Cairl %orders% "[FF] %%~nxi"
    ) else (
        ffmpeg -y -i "%%~i" -hide_banner -map_metadata 0 -metadata handler_name=@Cairl %orders% "[FF] %%~ni.%format%"
    )
)