#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

rm -rf build/readme_frames
flutter test tool/render_readme_assets.dart

scaled="build/readme_frames/header_960"
mkdir -p "$scaled"
ffmpeg -y -loglevel error -i "build/readme_frames/header/frame_%04d.png" -vf "scale=960:-1:flags=lanczos" -pix_fmt rgba "$scaled/frame_%04d.png"
img2webp -kmin 3 -kmax 4 -loop 0 -d 33 -lossy -q 88 -m 6 "$scaled"/frame_*.png -o "assets/header.webp"

rm -rf build/readme_frames
ls -lh assets/header.png assets/header.webp
