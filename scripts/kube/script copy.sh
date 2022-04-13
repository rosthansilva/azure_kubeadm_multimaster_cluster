#!/bin/bash
# Rosthan Silva 
# Objetivo : Esse Scrip Prepara um node para ser parte de um cluster kubernetes.
# Instala todas as dependenias, habilita Módulos do Karnel e deixa a máquina pronta para o init.
# Container runtime : Cri-io
# Versão do Kubeadm : Sempre a Ultima

echo "Script De Provionamento"

sudo apt update 
sudo apt upgrade -y
sudo apt -y install curl apt-transport-https ca-certificates gnupg2

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl containerd;

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

OS=Debian_10
VERSION=1.22

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | apt-key add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key add -

sudo apt update
sudo apt install cri-o cri-o-runc -y

sudo apt-cache policy cri-o ; sleep 3

sudo systemctl daemon-reload
sudo systemctl enable crio --now

sudo apt-mark hold kubelet kubeadm kubectl cri-o cri-o-runc 


