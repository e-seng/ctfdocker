#!/bin/bash

# check if docker image exists
docker inspect --type=image ctfdocker > /dev/null

if [[ $? -ne 0 ]]; then
  echo "[err] container does not exist, build it first with:"
  echo "docker build -t ctfdocker /path/to/repository"
  exit 1
fi

echo "[info] mounting working directory to the container and starting"
docker run -it --rm -v "$PWD:/localmnt" --name gdb ctfdocker
