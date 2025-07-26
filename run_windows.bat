@echo off
rem Helper script to run the Extrava project on Windows.
rem Optionally specify a port number as the first argument. Defaults to 8000.

setlocal enableextensions

rem Use the first command line argument as the port number
set "PORT=%1"
if "%PORT%"=="" set "PORT=8000"

rem Determine the directory of this script so relative paths work from anywhere
set "ROOT_DIR=%~dp0"

rem Virtual environment directory
set "VENV_PATH=%ROOT_DIR%venv"

rem Create the virtual environment if it doesn't exist
if not exist "%VENV_PATH%" (
    python -m venv "%VENV_PATH%"
)

rem Activate the environment
call "%VENV_PATH%\Scripts\activate.bat"

rem Install required Python packages
pip install -r "%ROOT_DIR%reqs.txt"

rem Run migrations to update the database
python "%ROOT_DIR%extrava\manage.py" migrate

rem Create default admin user if necessary
python "%ROOT_DIR%extrava\manage.py" create_default_admin

rem Launch Django's development server on the chosen port
python "%ROOT_DIR%extrava\manage.py" runserver 0.0.0.0:%PORT%

endlocal
