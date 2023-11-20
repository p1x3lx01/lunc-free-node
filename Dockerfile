# استخدام صورة الأساس الخفيفة من Python
FROM python:3.7-slim-buster

# تحديث pip وتثبيت Jupyter Notebook
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook

# تثبيت الحزم الأساسية و curl
RUN apt-get update && apt-get install -y \
        git \
        less \
        nano \
        curl && \ # تأكد من عدم وجود خطأ في تنسيق هذا السطر
    apt-get clean && rm -rf /var/lib/apt/lists/*

# تثبيت Bash kernel لـ Jupyter
RUN pip install bash_kernel && \
    python -m bash_kernel.install

# تحديد إصدار Go
ARG GOVERS=1.21.4

# تنزيل وتثبيت Go
RUN curl -O -L https://golang.org/dl/go${GOVERS}.linux-amd64.tar.gz && \
    mkdir -p /usr/local/go/$GOVERS && \
    tar -C /usr/local/go/$GOVERS -zxf go${GOVERS}.linux-amd64.tar.gz && \
    rm go${GOVERS}.linux-amd64.tar.gz

# تحديد متغيرات البيئة لـ Go
ENV GOROOT=/usr/local/go/$GOVERS/go \
    GOPATH=/home/go \
    PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# حدد مسار عمل الحاوية
WORKDIR /home/jovyan

# نقطة الدخول لـ Jupyter Notebook
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--NotebookApp.token=''", "--NotebookApp.password=''"]
