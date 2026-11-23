# GesturePilot

### Control your laptop brightness and volume with hand gestures

GesturePilot is a real-time computer vision application that lets you control
system brightness and volume using two hands in front of a webcam. Left hand
controls brightness, right hand controls volume, and a raised pinky locks the
corresponding control so you can move your hand without changing anything.

---

## Features

- Dual-hand tracking with MediaPipe hand landmarks
- Left hand → screen brightness, right hand → system volume
- Thumb–index distance maps continuously to a 0–100% level
- Raise pinky to lock a control; lower it to unlock
- Live dashboard with level bars, percentages and hand-detection status
- Smoothing and update throttling to avoid flicker
- Cross-platform audio backend: `pycaw` on Windows, ALSA `amixer` on Linux
- Works with the bundled `hand_landmarker.task` model — no download needed

---

## Gesture controls

| Hand | Gesture | Action |
| --- | --- | --- |
| Left | Pinch thumb + index | Lower brightness |
| Left | Spread thumb + index | Raise brightness |
| Left | Raise pinky | Lock brightness |
| Right | Pinch thumb + index | Lower volume |
| Right | Spread thumb + index | Raise volume |
| Right | Raise pinky | Lock volume |
| Any | Press `Q` | Quit the application |

> The webcam image is mirrored, so gestures feel natural. MediaPipe's raw
> handedness labels are corrected in `identify_hand()` for mirrored input.

---

## How it works

```text
Webcam frame
    ↓
Mirror + BGR → RGB
    ↓
MediaPipe HandLandmarker (VIDEO mode, 2 hands)
    ↓
Hand labelling (Left → brightness, Right → volume)
    ↓
Thumb/index distance ÷ palm size → normalized target
    ↓
Exponential smoothing → system brightness / volume
    ↓
OpenCV dashboard overlay → on-screen window
```

The thumb–index distance is normalized by palm size, which makes the gesture
independent of how close your hand is to the camera. The result is clipped to
`MIN_RATIO`–`MAX_RATIO` and interpolated to a percentage.

---

## Project structure

```text
GesturePilot/
├── combined_controller_clean.py   # Main application (all logic + UI)
├── hand_landmarker.task           # Bundled MediaPipe hand model
├── requirements.txt               # Python dependencies
├── run.sh                         # Linux launcher (sets PYTHONPATH)
├── README.md
└── .gitignore
```

---

## Requirements

- Python 3.9+
- A working webcam
- A graphical desktop session (the UI is an OpenCV window)

Python packages are listed in `requirements.txt`:

| Package | Purpose |
| --- | --- |
| `opencv-python` | Webcam capture and on-screen UI |
| `mediapipe` | Hand landmark detection |
| `numpy` | Distance math and smoothing |
| `screen-brightness-control` | Cross-platform brightness adjustment |
| `pycaw` + `comtypes` | Windows volume control |
| `amixer` (ALSA) | Linux volume control (system tool, not a Python package) |

The MediaPipe model `hand_landmarker.task` is already included in the repo.

---

## Quick start

### Windows

```powershell
git clone <repo-url>
cd GesturePilot

py -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt

python combined_controller_clean.py
```

### Linux

`pycaw` cannot be imported on Linux, so the app automatically uses ALSA
`amixer` for volume. The launcher installs dependencies into a local `.deps`
folder and sets `PYTHONPATH` for you.

```bash
git clone <repo-url>
cd GesturePilot

pip3 install --target .deps -r requirements.txt
./run.sh
```

If `python3-venv` is available, you can also use a normal virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python combined_controller_clean.py
```

> Run the app from the project directory so `hand_landmarker.task` is found.

To run it in the background and keep logs:

```bash
nohup ./run.sh > gesturesense.log 2>&1 &
```

---

## Configuration

Tune these constants near the top of `combined_controller_clean.py`:

| Constant | Default | Meaning |
| --- | --- | --- |
| `CAMERA_INDEX` | `0` | Webcam device index |
| `MIN_RATIO` | `0.20` | Pinch distance → 0% |
| `MAX_RATIO` | `1.00` | Spread distance → 100% |
| `SMOOTHING_FACTOR` | `0.15` | Lower = smoother, slower response |
| `LOCK_THRESHOLD` | `5` | Frames of raised pinky before locking |
| `BRIGHTNESS_UPDATE_DELAY` | `0.08` | Seconds between brightness writes |
| `VOLUME_UPDATE_THRESHOLD` | `0.005` | Minimum volume change before writing |

If gestures feel too sensitive, increase `MIN_RATIO` or `SMOOTHING_FACTOR`.

---

## Troubleshooting

| Problem | Fix |
| --- | --- |
| `Unable to access webcam` | Check camera permissions and `CAMERA_INDEX` (`0` or `1`) |
| `ImportError: pycaw` on Linux | Use `./run.sh` — Linux volume uses `amixer` instead |
| Brightness does not change | Some desktop/VM displays expose no brightness control; `screen-brightness-control` needs DRM/X11/DDC/CI support |
| Volume does not change | Check `amixer sget Master` on Linux or the default output device on Windows |
| Model file not found | Run from the project folder; keep `hand_landmarker.task` next to the script |
| Slow detection | Close other camera apps; reduce camera resolution in the script |

MediaPipe may print LiteRT/XNNPACK warnings at startup; these are informational
and do not affect the app.

---

## Roadmap

- [ ] Gesture-based media controls (play/pause, next/previous track)
- [ ] Configurable sensitivity presets
- [ ] Optional on-screen settings panel
- [ ] Dry-run mode to preview changes without touching system settings
- [ ] Separate Windows and Linux entry-point scripts
- [ ] Packaging into a single executable

---

## Contributing

Pull requests are welcome. Please open an issue first for larger changes, keep
the console banner and gesture table in sync with any new feature, and test
with a real webcam before submitting.

---

## Author

**Y. Gokul Raaj**

---

## License

Released under the [MIT License](LICENSE).

---

**GesturePilot — control your laptop with gestures.**
