@echo off
set rootdir=%~dp0

:: Read the game path from config.ini
for /f "tokens=2 delims==" %%A in ('findstr /i "gamepath" "%rootdir%config.ini"') do set gamepath=%%A
for /f "tokens=2 delims==" %%A in ('findstr /i "gamename" "%rootdir%config.ini"') do set gamename=%%A

:: Start the game
cd %gamepath%
start "" "%gamepath%\%gamename%"
exit
