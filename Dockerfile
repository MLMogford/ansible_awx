FROM ubuntu:22.04

WORKDIR /app
ADD . /app

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    python3 -y \
    python3-pip \
    curl \
    git-core \
    wget \
    zsh \
    nano

RUN pip3 install --upgrade pip && \
    pip3 install -r requirements.txt

# RUN curl -sfL https://get.k3s.io | sh -
RUN    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    mkdir -p ~/.local/bin && \
    mv ./kubectl ~/.local/bin/kubectl && \
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash


EXPOSE 6443