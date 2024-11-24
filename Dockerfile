FROM ubuntu:latest

# just helps with scripts
ENV DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
      nmap \
      tmux \
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
      cargo \
      liblzma-dev \
      openssl \
      libssl-dev \
      pkg-config \
      python3-ropgadget \
      python3-pwntools

VOLUME /localmnt

WORKDIR /root/tools

# install pwndbg for reversing stuff
RUN git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg && \
    ./setup.sh

# get CTF command list for reference
RUN git clone https://github.com/infosec-ucalgary/CTFCommands.git

# install rust tools
RUN cargo install pwninit

# customization :p
COPY bashrc /tmp/bashrc
COPY tmux.conf /tmp/tmux.conf

RUN cat /tmp/bashrc >> /root/.bashrc && \
    cat /tmp/tmux.conf >> /root/.tmux.conf && \
    rm /tmp/bashrc && \
    rm /tmp/tmux.conf

WORKDIR /localmnt

CMD ["/bin/bash"]
