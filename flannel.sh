#!/bin/sh
export KUBECONFIG=$(pwd)/admin.conf
kubectl delete configmap kube-flannel-cfg -n kube-system
kubectl delete serviceaccount flannel -n kube-system
kubectl delete clusterrolebinding flannel -n kube-system
kubectl delete clusterrole flannel -n kube-system
kubectl delete daemonset kube-flannel-ds -n kube-system

curl -sL https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml |sed "/kube-subnet-mgr/a\        - --iface=eth1" | kubectl create -f -
