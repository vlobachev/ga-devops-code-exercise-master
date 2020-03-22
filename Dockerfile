FROM amazonlinux:2.0.20200207.1
RUN yum update -y
RUN yum install -y \
    git \
    mc  \
    zip \
    make \
    which \
    python37 \
    python \
    python3-pip \
    wget && \
    yum -y clean all

RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install pipenv

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

WORKDIR /src

# -- Adding Pipfiles
COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

# -- Install dependencies:
RUN set -ex && pipenv sync --dev --python 3.7




