FROM ubuntu:latest

ARG uid=0
ARG gid=0

# just helps with scripts
ENV DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
      sudo \
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
      elfutils \
      patchelf \
      python3-ropgadget \
      python3-pwntools \
      apktool

# create a user, with provided uid/gids. remove any conflicts
RUN groupdel -f `id -gn $gid` && \
    userdel -f `id -un $uid` && \
    groupadd -g $gid \
             -o \
             ctf && \
    useradd -u $uid \
            -o \
            -m \
            -s /bin/bash \
            -g $gid \
            -G sudo \
            user

WORKDIR /home/user/tools

# install pwndbg for reversing stuff
RUN git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg && \
    ./setup.sh && \
    cd ..

# install jadx for android reversing

RUN wget https://nightly.link/skylot/jadx/workflows/build-artifacts/master/jadx-r2412.61f5386.zip && \
    unzip jadx*.zip -d jadx

# install rust tools for user
USER user
RUN cargo install --locked pwninit

USER root

# get CTF command list for reference
RUN git clone https://github.com/infosec-ucalgary/CTFCommands.git

# enable sudo access
RUN echo "%ctf    ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# customization :p
COPY bashrc /tmp/bashrc
COPY tmux.conf /tmp/tmux.conf

RUN cat /tmp/bashrc >> /home/user/.bashrc && \
    cat /tmp/tmux.conf >> /home/user/.tmux.conf && \
    chown user:ctf -R /home/user/ && \
    rm /tmp/bashrc && \
    rm /tmp/tmux.conf

USER user

# make sure we own everything, also properly init pwndbg
RUN echo 'source /home/user/tools/pwndbg/gdbinit.py' > /home/user/.gdbinit

VOLUME /home/user/files
WORKDIR /home/user/files

CMD ["/bin/bash"]
