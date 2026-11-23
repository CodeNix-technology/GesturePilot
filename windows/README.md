# GesturePilot for Windows

Windows entry point for GesturePilot. System volume is controlled with
`pycaw`/`comtypes`; brightness uses `screen-brightness-control`.

## Setup

From this folder:

```powershell
py -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

## Run

Double-click `run.bat`, or run:

```powershell
python GesturePilot_Windows.py
```

The app looks for `hand_landmarker.task` in the repository root (one folder up),
so keep the folder structure intact after cloning.

Press `Q` in the app window to quit.

See the [main README](../README.md) for gestures, configuration and
troubleshooting.
