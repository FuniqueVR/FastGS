@echo off
docker run --gpus all -it --rm --shm-size=8g -v "%cd%":/workspace fastgs-image-fast-pgsr /bin/bash