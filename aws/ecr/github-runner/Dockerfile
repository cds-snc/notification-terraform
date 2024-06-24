FROM ghcr.io/actions/actions-runner:2.316.1@sha256:6db7a9e04f4b568b843c5ab40952319294807a2165a9a268fe36c71630415265
USER root

RUN apt update
RUN apt install -y git curl unzip build-essential jq openvpn
WORKDIR /var/tmp
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

WORKDIR /home/runner
USER runner