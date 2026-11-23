# GesturePilot for Linux

Linux entry point for GesturePilot. System volume is controlled through ALSA
`amixer` (the `Master` control); brightness uses `screen-brightness-control`.

## Requirements

```bash
sudo apt install alsa-utils
```

## Setup

From this folder:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

If `python3-venv` is unavailable, install the packages into the repo-root
`.deps` folder instead:

```bash
pip3 install --target ../.deps -r requirements.txt
```

## Run

```bash
./run.sh
```

`run.sh` uses the local `.venv` when present, otherwise `python3`, and adds the
repo-root `.deps` folder to `PYTHONPATH` if it exists.

The app looks for `hand_landmarker.task` in the repository root (one folder up),
so keep the folder structure intact after cloning.

Press `Q` in the app window to quit.

See the [main README](../README.md) for gestures, configuration and
troubleshooting.
