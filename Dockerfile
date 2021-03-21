FROM ubuntu:20.04

LABEL maintainer="const4ntine"

ENV DEBIAN_FRONTEND="noninteractive"

# Install some required tools and docker
RUN apt update && apt install -y dnsutils nmap curl tcpdump nano jq git python3-pip openssh-server sudo docker.io

# Kubectl 1.12
RUN curl -O https://storage.googleapis.com/kubernetes-release/release/v1.12.8/bin/linux/amd64/kubectl && \
chmod +x kubectl && mv kubectl /usr/local/bin/kubectl112

# Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# Download etcdctl
RUN curl -OL https://github.com/etcd-io/etcd/releases/download/v3.4.0/etcd-v3.4.0-linux-amd64.tar.gz && \
tar -xzvf etcd-v3.4.0-linux-amd64.tar.gz && \
cp etcd-v3.4.0-linux-amd64/etcdctl /usr/local/bin && \
chmod +x /usr/local/bin/etcdctl && \
rm -rf etcd-v3.4.0-linux-amd64 && \
rm -f etcd-v3.4.0-linux-amd64.tar.gz

# Download Rakkess
RUN curl -Lo rakkess.gz https://github.com/corneliusweig/rakkess/releases/download/v0.4.1/rakkess-linux-amd64.gz && \
gunzip rakkess.gz && \
chmod +x rakkess && \
mv rakkess /usr/local/bin/ && rm -f rakkess.gz

# kubectl-who-can
RUN curl -OL https://github.com/aquasecurity/kubectl-who-can/releases/download/v0.1.0/kubectl-who-can_linux_x86_64.tar.gz && \
tar -xzvf kubectl-who-can_linux_x86_64.tar.gz && cp kubectl-who-can /usr/local/bin && rm -f kubectl-who-can_linux_x86_64.tar.gz

#Get Kube-Hunter
RUN pip3 install kube-hunter

# Set the ETCD API to 3
ENV ETCDCTL_API 3

# Add a new non-root sudo user (tester) and start an SSH server on port 6666
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
