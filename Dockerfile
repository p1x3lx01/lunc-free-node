# استخدام صورة الأساس من Python
FROM python:3.7-buster

# تحديث pip وتثبيت Jupyter Notebook
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook

# تثبيت حزم النظام الأساسية
RUN apt-get update && apt-get install -y \
        bash-completion \
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
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# Install Bash kernel for Jupyter
RUN pip install bash_kernel

# Set Bash as the default shell
RUN \
    sudo ln -sf /bin/bash /bin/sh && \
    mkdir .jupyter && \
    echo 'c.NotebookApp.terminado_settings = {"shell_command":"/bin/bash"}' > .jupyter/jupyter_notebook_config.py

# Download and install the latest version of Go
RUN wget https://go.dev/dl/go1.21.4.src.tar.gz && \
    tar -C /usr/local -xzf go1.21.4.src.tar.gz && \
    rm go1.21.4.src.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

# Create user 'lunc' with a home directory
# حدد مسار عمل الحاوية
WORKDIR /home/jovyan

# نقطة الدخول لـ Jupyter Notebook
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0"]
