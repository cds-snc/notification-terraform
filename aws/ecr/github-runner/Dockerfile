FROM ghcr.io/actions/actions-runner:2.315.0
USER root

RUN apt update
RUN apt install -y git curl unzip build-essential jq
WORKDIR /var/tmp
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

WORKDIR /home/runner
USER runner