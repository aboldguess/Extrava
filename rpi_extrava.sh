#!/usr/bin/env bash

# Helper script to run the Extrava project on a Raspberry Pi.
# Supports launching the development server or a Gunicorn-based production
# server. Pass -p or --prod to enable production mode. Optionally provide a port
# number as the last argument (default: 8000).

set -e  # Exit immediately if a command exits with a non-zero status.

PORT=8000
MODE="dev"

# Parse command line arguments. We support an optional --prod flag and an
# optional port number. Any unknown option will trigger a usage message.
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--prod)
            MODE="prod"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--prod] [port]"
            exit 0
            ;;
        *)
            PORT="$1"
            shift
            ;;
    esac
done

# Determine the directory where this script resides so commands run relative to
# the project root regardless of where the script is called from.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to the Python virtual environment. It will be created on first run.
VENV_PATH="$ROOT_DIR/venv"

# Create the virtual environment if necessary and install required packages.
if [ ! -d "$VENV_PATH" ]; then
    python3 -m venv "$VENV_PATH"
    source "$VENV_PATH/bin/activate"
    pip install -r "$ROOT_DIR/reqs.txt"
else
    source "$VENV_PATH/bin/activate"
fi

# Gunicorn is required for production mode. Install it if missing.
if [ "$MODE" = "prod" ] && ! pip show gunicorn > /dev/null 2>&1; then
    pip install gunicorn
fi

# Apply any outstanding database migrations and ensure the default admin exists.
python "$ROOT_DIR/extrava/manage.py" migrate
python "$ROOT_DIR/extrava/manage.py" create_default_admin

# Launch the appropriate server based on the selected mode.
if [ "$MODE" = "prod" ]; then
    # Gunicorn is more suitable for production deployments than Django's built-in
    # development server. Bind to 0.0.0.0 so the app is accessible over the LAN.
    gunicorn --bind 0.0.0.0:"$PORT" extrava.wsgi:application
else
    # Development mode uses Django's built-in server for convenience.

    python "$ROOT_DIR/extrava/manage.py" runserver 0.0.0.0:"$PORT"
fi
