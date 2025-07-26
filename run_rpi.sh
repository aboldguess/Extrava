#!/usr/bin/env bash

# Helper script to run the Extrava project on a Raspberry Pi.
# Optionally specify a port number as the first argument. The default is 8000.
# Example: ./run_rpi.sh 8080

set -e  # Exit immediately if a command exits with a non-zero status.

# Use the first argument as the port or fall back to 8000
PORT="${1:-8000}"

# Determine the directory where the script lives so we can run commands
# relative to the project root no matter where the script is invoked from.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to the virtual environment we'll create if it doesn't already exist
VENV_PATH="$ROOT_DIR/venv"

# Create a Python virtual environment if one hasn't been set up yet.
if [ ! -d "$VENV_PATH" ]; then
    python3 -m venv "$VENV_PATH"
    # Activate the new environment and install required packages
    source "$VENV_PATH/bin/activate"
    pip install -r "$ROOT_DIR/reqs.txt"
else
    # Activate the existing virtual environment
    source "$VENV_PATH/bin/activate"
fi

# Run database migrations to ensure the SQLite database is up to date
python "$ROOT_DIR/extrava/manage.py" migrate

# Create the default admin user if it does not already exist
python "$ROOT_DIR/extrava/manage.py" create_default_admin

# Start Django's development server. Binding to 0.0.0.0 makes the server
# accessible on the local network which is helpful when running on a Pi.
python "$ROOT_DIR/extrava/manage.py" runserver 0.0.0.0:"$PORT"

