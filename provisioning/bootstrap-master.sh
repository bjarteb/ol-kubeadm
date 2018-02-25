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
