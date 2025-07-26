# Extrava

This project provides a simple web platform to upload and analyse Strava export files. Users analyse the large ZIP files locally in their browser, select which data to upload and the server stores the chosen activities for further analysis.

## Features

- User authentication with Django.
- Admin backend available at `/admin` (default admin user `philadmin` / `Admin12345`).
- Upload Strava bulk export ZIP files, analyse them client side and choose which activities to send to the server.
- Supply your own Strava export ZIP when uploading.

## Quick start

1. Install dependencies (preferably in a virtualenv):

```bash
pip install django
```

2. Run database migrations and create the default admin:

```bash
python extrava/manage.py migrate
python extrava/manage.py create_default_admin
```

3. Start the development server:

```bash
python extrava/manage.py runserver
```

4. Visit `http://localhost:8000` to log in and start uploading data.

### Running on Raspberry Pi

Use the included `run_rpi.sh` script to spin up the development server on a
Raspberry Pi. The script creates a virtual environment, installs dependencies
and runs migrations automatically. You can optionally pass a port number:

```bash
./run_rpi.sh 8080  # serve on port 8080
```

Omitting the argument will default to port `8000`.

### Running on Windows

Windows users can take advantage of the `run_windows.bat` script. It
creates a virtual environment, installs dependencies, runs migrations
and finally launches the development server. Pass a port number as the
first argument to change the port:

```cmd
run_windows.bat 8080  && REM serves on port 8080
```

If omitted the server will listen on port `8000`.

### Uploading your export

On the home page click **Select ZIP file** and choose the Strava export `*.zip`
you downloaded from Strava. After selecting the file press **Analyze Locally**
to review the activities contained inside. Tick or untick each entry and finally
click **Upload Selected** to save them on the server.

## Notes

- Static files including `jszip.min.js` are served locally when `DEBUG` is true.
- This setup is for development/demo purposes only. For production deployment you should configure a proper database, static file hosting and secure secret keys.
