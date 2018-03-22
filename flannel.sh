#!/bin/sh
export KUBECONFIG=$(pwd)/admin.conf
curl -sL https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml |awk '1;/kube-subnet-mgr/{ print "        - --iface=eth1";}' | kubectl replace -f -
