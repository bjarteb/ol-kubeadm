yum install -y yum-utils
yum-config-manager --enable ol7_addons
yum-config-manager --enable ol7_preview

/usr/sbin/setenforce 0
yum install -y docker-engine
systemctl enable docker
systemctl start docker
yum install -y kubeadm
iptables -P FORWARD ACCEPT
/sbin/sysctl -p /etc/sysctl.d/k8s.conf

export KUBE_REPO_PREFIX=container-registry.oracle.com/kubernetes
USERNAME=$(cat /vagrant/my_username)
cat /vagrant/my_password | docker login --username ${USERNAME} --password-stdin container-registry.oracle.com

kubeadm-setup.sh up --apiserver-advertise-address 10.0.18.10

kubeadm token list | awk 'NR==2 { print $1; }' > /vagrant/token
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //' > /vagrant/ca-cert-hash

# We are going to replace the flannel network pods.
cat > flannel.sh <<EOF
#!/bin/sh
export KUBECONFIG=\$(pwd)/admin.conf
# delete flannel resources
kubectl delete configmap kube-flannel-cfg -n kube-system
kubectl delete serviceaccount flannel -n kube-system
kubectl delete clusterrolebinding flannel -n kube-system
kubectl delete clusterrole flannel -n kube-system
kubectl delete daemonset kube-flannel-ds -n kube-system
# deploy flannel
curl -sL https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml |awk '1;/kube-subnet-mgr/{ print "        - --iface=eth1";}' | kubectl create -f -
EOF
chmod +x flannel.sh
# make it available from host OS
cp -f flannel.sh /vagrant
