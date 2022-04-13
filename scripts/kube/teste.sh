#!/bin/bash
echo "Script De Provionamento"

sudo apt update 
sudo apt upgrade -y
sudo apt -y install curl apt-transport-https ca-certificates gnupg2

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
apt-get install -y vim git curl kubelet=1.23.5-00 kubeadm=1.23.5-00 kubectl=1.23.5-00 

apt install -y iptables libiptc0/stable libxtables12/stable 


sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

cat << EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF 

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo apt install -y chrony

sudo apt install nfs-common -y

sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add
#sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 

sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" >> /etc/apt/sources.list

sudo apt update 

sudo apt install -y containerd.io

mkdir -p /etc/containerd

containerd config default > /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

sudo apt-mark hold kubelet kubeadm kubectl containerd.io 