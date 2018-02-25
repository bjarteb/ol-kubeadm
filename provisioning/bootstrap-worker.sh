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

USERNAME=$(cat /vagrant/my_username)
cat /vagrant/my_password | docker login --username ${USERNAME} --password-stdin container-registry.oracle.com
# join cluster
TOKEN=$(cat /vagrant/token)
CA_CERT_HASH=$(cat /vagrant/ca-cert-hash)
export KUBE_REPO_PREFIX=container-registry.oracle.com/kubernetes& kubeadm-setup.sh join --token $TOKEN 10.0.18.10:6443 --discovery-token-ca-cert-hash sha256:${CA_CERT_HASH}
