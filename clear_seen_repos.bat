@echo off
setlocal
cd /d "%~dp0"

echo ========================================
echo Clear pushed repository history
echo ========================================
echo.
echo Make sure github_bot.py is stopped first.
echo The bot may push previously sent repositories again after this reset.
echo.
pause

>"seen_repo_ids.json" echo []
if errorlevel 1 (
    echo [FAILED] Could not write seen_repo_ids.json. Make sure the file is not in use.
) else (
    echo [DONE] seen_repo_ids.json has been cleared.
)

echo.
pause
endlocal