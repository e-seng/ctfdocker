FROM ubuntu:latest

# just helps with scripts
ENV DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y gdb python3 python3-pip git openssh-client netcat man-db vim neovim file tree python3-ropgadget zsh

VOLUME /localmnt

WORKDIR ~/.local

# install pwndbg for reversing stuff
RUN git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg && \
    ./setup.sh

# install additional tools
RUN pip3 install pwntools

# customization :p
COPY bashrc /tmp/bashrc
COPY zshrc /tmp/zshrc

RUN cat /tmp/bashrc >> ~/.bashrc && \
    cat /tmp/zshrc >> ~/.zshrc && \
    rm /tmp/bashrc && \
    rm /tmp/zshrc

WORKDIR /localmnt

CMD ["/usr/bin/bash"]
