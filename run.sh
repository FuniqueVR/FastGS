#!/bin/bash
sudo docker run --gpus all -it --rm --shm-size=8g -v "$(pwd)":/workspace fastgs-image /bin/bash