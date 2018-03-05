# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ol74"

MASTER_IP="10.0.18.10"
NUM_NODES="1".to_i()

post_up_msg = <<-MSG
    ------------------------------------------------------
    DOC: https://docs.oracle.com/cd/E52668_01/E88884/html/index.html

    Oracle cluster: master #{MASTER_IP}, #{NUM_NODES} nodes
    master (m): vagrant ssh m
    workers (w): vagrant ssh w1, vagrant ssh w2, etc... 

    Connect to cluster

    $ export KUBECONFIG=$(pwd)/admin.conf
    $ kubectl get nodes

    On Oracle Container Services flannel is default installed. 
    Replace flannel daemonset.
    $ ./flannel.sh
    ------------------------------------------------------
MSG


  config.hostmanager.enabled = true
  config.hostmanager.manage_guest = true

  # create k8s master node
  config.vm.define :m do |node|
    node.vm.box = "ol74"
    node.vm.hostname = "m"
    node.vm.network :private_network, ip: "10.0.18.10"
    node.vm.network "forwarded_port", guest: 8001, host: 8001
    node.vm.network "forwarded_port", guest: 6443, host: 6443
    node.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", 1024]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
    node.vm.provision :shell, path: "provisioning/bootstrap-master.sh"
    node.vm.provision :shell, path: "provisioning/configure-vagrant-user.sh", privileged: false
  end

  # create k8s worker nodes
  (1..1).each do |i|
    config.vm.define "w#{i}" do |node|
      node.vm.box = "ol74"
      node.vm.hostname = "w#{i}"
      node.vm.network :private_network, ip: "10.0.18.2#{i}"
      node.vm.network "forwarded_port", guest: 80, host: "908#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", 512]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
      node.vm.provision :shell, path: "provisioning/bootstrap-worker.sh"
    end
  end
  config.vm.post_up_message = post_up_msg
end
