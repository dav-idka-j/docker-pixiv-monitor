#!/bin/sh

set -e

# --basic is used to disable the curses UI, which is not suitable for Docker logs.
echo "Starting main.py monitor in the background..."
python3 main.py --basic &

echo "Starting rssmain.py in the background..."
python3 rssmain.py &

while [ ! -f pixiv.atom ]; do
  echo "Waiting for pixiv.atom to be created..."
  sleep 5
done

echo "Starting HTTP server on port 8000. RSS feed will be at http://localhost:8000/pixiv.atom"
python3 -m http.server 8000
