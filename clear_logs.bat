@echo off
setlocal
cd /d "%~dp0"

echo ========================================
echo Clean Gitshowbot logs
echo ========================================
echo.
echo Make sure github_bot.py is stopped first.
echo This will delete bot.log and all rotated log files.
echo.
pause

set "DELETE_FAILED=0"
if exist "bot.log" del /q "bot.log"
if exist "bot.log.*" del /q "bot.log.*"

if exist "bot.log" set "DELETE_FAILED=1"
if exist "bot.log.*" set "DELETE_FAILED=1"

if "%DELETE_FAILED%"=="1" (
    echo [FAILED] Some log files could not be deleted. Make sure the bot is stopped.
) else (
    echo [DONE] bot.log and rotated log files have been deleted.
)

echo.
pause
endlocal