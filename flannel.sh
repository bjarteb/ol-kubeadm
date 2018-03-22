#!/bin/sh
export KUBECONFIG=$(pwd)/admin.conf
# delete all flannel resources
kubectl delete configmap kube-flannel-cfg -n kube-system
kubectl delete serviceaccount flannel -n kube-system
kubectl delete clusterrolebinding flannel -n kube-system
kubectl delete clusterrole flannel -n kube-system
kubectl delete daemonset kube-flannel-ds -n kube-system
# deploy flannel
curl -sL https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml |awk '1;/kube-subnet-mgr/{ print "        - --iface=eth1";}' | kubectl create -f -
