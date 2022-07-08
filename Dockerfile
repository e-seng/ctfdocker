FROM archlinux:latest

# install dependencies
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm gdb python3 python-pip git openssh netcat man-db vim neovim file tree zsh base-devel go

RUN useradd --system --create-home yay-install && \
    echo "yay-install ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/yay-install

USER yay-install
WORKDIR /home/yay-install

# install yay
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    echo "Y" | makepkg -si && \
    cd /home/yay-install && \
    rm -rf .cache yay

USER root

RUN pip3 install ROPgadget

VOLUME /localmnt

WORKDIR ~/.local

# install pwndbg for reversing stuff
RUN pip3 install pwndbg
    # git clone https://github.com/pwndbg/pwndbg && \
    # cd pwndbg && \
    # ./setup.sh

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

CMD ["/usr/bin/zsh"]
