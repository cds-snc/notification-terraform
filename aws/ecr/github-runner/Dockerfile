FROM ghcr.io/actions/actions-runner:2.317.0@sha256:95db6fbb020b9f734e8a00389291dae766f0e6ad3d1171ae2d68e9ad8ac4a985
USER root

RUN apt update
RUN apt install -y git curl unzip build-essential jq openvpn
WORKDIR /var/tmp
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

WORKDIR /home/runner
USER runner