@echo off
setlocal

cd /D "%~dp0"

if not exist "odoo-bin" (
    echo ERROR: odoo-bin not found in %CD%
    pause
    exit /b 1
)

if not exist "venv\Scripts\activate.bat" (
    echo ERROR: Virtual environment not found.
    pause
    exit /b 1
)

call "venv\Scripts\activate.bat"

echo.
echo Python version:
python --version

echo.
echo Installing requirements...
python -m pip install -r requirements.txt
if errorlevel 1 (
    echo ERROR: Failed to install requirements.
    pause
    exit /b 1
)

echo.
echo Checking PostgreSQL port 5432...
powershell -NoProfile -Command ^
  "if (Test-NetConnection 127.0.0.1 -Port 5432 -InformationLevel Quiet) { exit 0 } else { exit 1 }"

if errorlevel 1 (
    echo ERROR: PostgreSQL is not accepting connections on port 5432.
    echo Start the PostgreSQL Windows service and try again.
    pause
    exit /b 1
)

echo.
echo Starting Odoo...
@REM python odoo-bin -c odoo.conf
@REM python odoo-bin --addons-path=addons,odoo/addons --db_user=odoo
python odoo-bin -d odoo --db_port 5432 -i base
@REM python odoo-bin --config="odoo.conf" -d odoo --http-port=8069

if errorlevel 1 (
    echo.
    echo ERROR: Odoo stopped with an error.
    pause
    exit /b 1
)

pause
endlocal
