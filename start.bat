@echo off
title JPCS Email Editor

:: Always work in the directory where this batch file is located
cd /d "%~dp0"

echo ===================================================
echo             JPCS Email Editor Launcher
echo ===================================================
echo.

:: 1. Check if running from inside an unextracted ZIP file
echo %CD% | findstr /i "AppData\Local\Temp" >nul
if %errorlevel%==0 goto IN_ZIP

:: 2. Detect Python or py launcher
python -c "import sys; exit(0)" >nul 2>&1
if %errorlevel%==0 (
    set PY_CMD=python
    goto START_SERVER
)

py -c "import sys; exit(0)" >nul 2>&1
if %errorlevel%==0 (
    set PY_CMD=py
    goto START_SERVER
)

:: 3. Python is not installed -> Standalone mode fallback
echo [NOTE] Python is not installed on this computer.
echo.
echo Opening JPCS Email Editor in Standalone Mode...
echo Opening index.html directly in your default browser.
echo.
start "" "index.html"
timeout /t 3 >nul
exit /b

:START_SERVER
echo [OK] Detected %PY_CMD%. Starting local server on http://localhost:8000...
start http://localhost:8000
%PY_CMD% -m http.server 8000
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Server stopped or port 8000 was in use.
    echo Opening editor in standalone mode as fallback...
    start "" "index.html"
    pause
)
exit /b

:IN_ZIP
echo [WARNING] You are running this from inside a ZIP file!
echo Please extract/unzip all files to a normal folder first,
echo then double-click start.bat again.
echo.
pause
exit /b

