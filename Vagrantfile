# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.define "kubemaster" do |kubemaster|
      kubemaster.vm.hostname = "kubemaster"
      kubemaster.vm.box = "ubuntu/focal64"
      kubemaster.vm.network "private_network", ip: "192.168.56.1"
      kubemaster.vm.provision "shell", path: "provision.sh"
      kubemaster.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
      end
      kubemaster.trigger.after :up do |trigger|
        trigger.warn = "ping to worker nodes"
        trigger.run = {path:"./ping.sh"}
      end
    end
  
    (1..2).each do |i|
      config.vm.define "worker#{i}" do |worker|
        worker.vm.hostname = "worker#{i}"
        worker.vm.box = "ubuntu/focal64"
        worker.vm.network "private_network", ip: "192.168.56.#{i+1}"
        worker.vm.provision "shell", path: "provision.sh"
        worker.vm.provider "virtualbox" do |vb|
          vb.memory = "2048"
          vb.cpus = 2
        end
      end
    end
  
  end