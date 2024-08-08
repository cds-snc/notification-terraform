FROM ghcr.io/actions/actions-runner:2.319.0@sha256:3bee2ec62f586beb76013d462df84d3dafc7dff94fe4ac731bcf3157c3a324f3
USER root

RUN apt update
RUN apt install -y git curl unzip build-essential jq openvpn
WORKDIR /var/tmp
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

WORKDIR /home/runner
USER runner