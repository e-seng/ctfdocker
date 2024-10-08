FROM ubuntu:latest

# just helps with scripts
ENV DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
      gdb \
      python3 \
      python3-pip \
      git \
      openssh-client \
      netcat-traditional \
      man-db \
      vim \
      neovim \
      file \
      tree \
      python3-ropgadget \
      python3-pwntools

VOLUME /localmnt

WORKDIR ~/.local

# install pwndbg for reversing stuff
RUN git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg && \
    ./setup.sh

# customization :p
COPY bashrc /tmp/bashrc

RUN cat /tmp/bashrc >> ~/.bashrc && \
    rm /tmp/bashrc

WORKDIR /localmnt

CMD ["/bin/bash"]
