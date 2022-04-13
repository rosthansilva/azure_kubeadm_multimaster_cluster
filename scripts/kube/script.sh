#!/bin/bash
echo "Script De Provionamento"
#!/bin/bash 

echo "1" > /proc/sys/net/ipv4/ip_forward
sudo tee /etc/modules-load.d/containerd.conf<<EOF 
overlay
br_netfilter
EOF 

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter
sudo sysctl --system 

sudo apt install -y chrony

apt install nfs-common -y

apt install -y curl gpg lsb-release apparmor apparmor-utils -y 

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list 


sudo apt update 

sudo apt install -y containerd.io

sudo mkdir -p /etc/containerd

containerd config default | tee /etc/containerd/config.toml

systemctl restart containerd

apt install y iptables libiptc0/stable libxtables12/stable 

apt-get install -y kubelet=1.23.5-00 kubeadm=1.23.5-00 kubectl=1.23.5-00 

