#install Docker
sudo apt-get update
sudo apt-get install containerd=1.3.3-0ubuntu2
sudo apt-get install -y docker.io

#add vagrant user to docker group
sudo usermod -aG docker $user
#configure docker to start on boot
sudo systemctl enable docker


#install kubeadm,kubectl,kubelet
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet=1.20.2-00 kubeadm=1.20.2-00 kubectl=1.20.2-00
sudo apt-mark hold kubelet kubeadm kubectl

#to join cluster ew must get the full join command by running the following command on the kubeaster
kubeadm token create --print-join-command
kubeadm join --token <token> <master-ip>:<master-port> --discovery-token-ca-cert-hash sha256:<hash>
#for exp:kubeadm join 192.168.56.1:6443 --token ruqfzn.5m8lm0x5h2i5fc4u     --discovery-token-ca-cert-hash sha256:23f6fb98464c45c5f4da6463b6c8d8df942b8c9cf728f000b95b4a355c40bd3b 
#we run this command in all worker nodes
