#!/bin/bash
if [ ! -h /usr/local/bin/ctfdocker ]; then
  # get permissions
  echo "[info] want to place the binary into /usr/local/bin, provide sudo access to create link:"
  sudo -v
  sudo ln -s $PWD/run.sh /usr/local/bin/ctfdocker
fi

docker build -t ctfdocker --build-arg uid=`id -u` --build-arg gid=`id -g` .
