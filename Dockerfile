FROM ubuntu:20.04

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y curl wget jq gnupg

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' >/etc/apt/sources.list.d/kubernetes.list

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y kubectl=1.24.6-00 \
    && curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v1.2.2/clusterctl-linux-amd64 -o clusterctl \
    && chmod +x ./clusterctl \
    && mv ./clusterctl /usr/local/bin/clusterctl \
    && curl -L https://github.com/argoproj/argo-cd/releases/download/v2.4.14/argocd-linux-amd64 -o argocd \
    && chmod +x ./argocd \
    && mv ./argocd /usr/local/bin/argocd

# docker build -t mtougeron/hundreds-of-clusters-demo .
# docker push mtougeron/hundreds-of-clusters-demo
