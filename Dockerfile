FROM python:3.7.9-stretch

# Install notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook

# Install system packages
RUN set -x && \
    apt-get update && \
    apt install -y \
        bash-completion \
        dictionaries-common \
        emacs-nox \
        git \
        htop \
        less \
        man-db manpages \
        nano \
        psmisc \
        screen \
        sudo \
        tmux \
        vim-tiny \
    && \
    apt-get clean  &&  rm -r /var/lib/apt/lists/*

# Install Bash kernel for Jupyter
RUN pip install bash_kernel

# Set Bash as the default shell
RUN \
    sudo ln -sf /bin/bash /bin/sh && \
    mkdir .jupyter && \
    echo 'c.NotebookApp.terminado_settings = {"shell_command":"/bin/bash"}' > .jupyter/jupyter_notebook_config.py

# Download and install the latest version of Go
RUN wget https://golang.org/dl/go1.18.1.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz && \
    rm go1.18.1.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

# Create user 'lunc' with a home directory
ARG NB_USER=lunc
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

WORKDIR ${HOME}
USER ${USER}
