FROM archlinux:latest

# install dependencies
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm gdb python3 python-pip git openssh netcat man-db vim neovim file tree zsh rust base-devel go lib32-glibc neovim vim

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

VOLUME /localmnt

WORKDIR ~/.local

# install additional tools

## install pwndbg for reversing stuff
RUN pacman -S --noconfirm pwndbg && \
    echo 'source /usr/share/pwndbg/gdbinit.py' >> ~/.gdbinit

## install tools from pip3
RUN pip3 install \
  pycryptodome \
  numpy \
  pwntools \
  ROPgadget

# customization :p
COPY bashrc /tmp/bashrc
COPY zshrc /tmp/zshrc

RUN cat /tmp/bashrc >> ~/.bashrc && \
    cat /tmp/zshrc >> ~/.zshrc && \
    rm /tmp/bashrc && \
    rm /tmp/zshrc

WORKDIR /localmnt

CMD ["/usr/bin/zsh"]
