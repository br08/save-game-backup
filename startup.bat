@echo off
set rootdir=%~dp0

:: Read the game path from config.ini
for /f "tokens=2 delims==" %%A in ('findstr /i "game" "%rootdir%config.ini"') do set game=%%A

:: Start the game
cd %game%
start "" "%game%"
exit
