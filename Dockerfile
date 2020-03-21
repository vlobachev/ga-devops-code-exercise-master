FROM amazonlinux:2.0.20200207.1
RUN yum update -y
RUN yum install -y \
    git \
    mc  \
    aws-cli \
    zip \
    gcc \
    make \
    libffi-devel \
    openssl-devel \
    zlib-devel \
    libffi-devel \
    which \
    wget && \
    yum -y clean all

RUN yum -y install python37 \
    python \
    python3-devel \
    python-devel \
    python3-pip \
    && yum clean all

RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install pipenv

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

WORKDIR /src

# -- Adding Pipfiles
COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

# -- Install dependencies:
RUN set -ex && pipenv install --dev --python 3.7

#RUN yum -y install make
#
#RUN echo -n $(git ls-files -s lambdas/requirements.txt | git hash-object --stdin)


