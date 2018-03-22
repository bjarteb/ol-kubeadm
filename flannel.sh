#!/bin/sh
export KUBECONFIG=/Users/BJBRA/vagrant/ol-kubeadm/admin.conf
curl -sL https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml |sed "/kube-subnet-mgr/a\        - --iface=eth1" | kubectl replace -f -
