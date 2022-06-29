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

#initilse kubemaster
#I used Calico as container network interface plugin

kubeadm init --apiserver-advertise-address=192.168.56.1 --pod-network-cidr=192.168.0.0/16
#to start using the cluster run the following commands
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#now deploy the pod network 
wget https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f calico.yaml
#to confirm that the pod network is installed
kubectl get pods --all-namespaces
#to confirm that our cluster is running perfectly 
#note : after joining cluster
watch kubectl get nodes

#we should see something like this
#NAME         STATUS   ROLES                  AGE     VERSION
#kubemaster   Ready    control-plane,master   7m2s    v1.20.2
#worker1      Ready    <none>                 6m33s   v1.20.2
#worker2      Ready    <none>                 6m33s   v1.20.2
