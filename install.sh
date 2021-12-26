#!/usr/bin/env bash
# change time zone
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
timedatectl set-timezone Asia/Shanghai
rm /etc/yum.repos.d/CentOS-Base.repo
cp /vagrant/yum/*.* /etc/yum.repos.d/
mv /etc/yum.repos.d/CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
# using socat to port forward in helm tiller
# install  kmod and ceph-common for rook
yum install -y wget curl conntrack-tools vim net-tools telnet tcpdump bind-utils socat ntp kmod ceph-common dos2unix

# enable ntp to sync time
echo 'sync time'
systemctl start ntpd
systemctl enable ntpd
echo 'disable selinux'
setenforce 0
sed -i 's/=enforcing/=disabled/g' /etc/selinux/config

echo 'enable iptable kernel parameter'
cat >> /etc/sysctl.conf <<EOF
net.ipv4.ip_forward=1
EOF
sysctl -p

echo 'set host name resolution'
cat >> /etc/hosts <<EOF
192.168.56.101 node1
192.168.56.102 node2
192.168.56.103 node3
EOF

cat /etc/hosts

echo 'set nameserver'
echo "nameserver 8.8.8.8">/etc/resolv.conf
cat /etc/resolv.conf

echo 'disable swap'
swapoff -a
sed -i '/swap/s/^/#/' /etc/fstab

#create group if not exists
egrep "^docker" /etc/group >& /dev/null
if [ $? -ne 0 ]
then
  groupadd docker
fi

usermod -aG docker vagrant
rm -rf ~/.docker/
yum install -y docker.x86_64
# To fix docker exec error, downgrade docker version, see https://github.com/openshift/origin/issues/21590
yum downgrade -y docker-1.13.1-75.git8633870.el7.centos.x86_64 docker-client-1.13.1-75.git8633870.el7.centos.x86_64 docker-common-1.13.1-75.git8633870.el7.centos.x86_64

cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors" : ["http://2595fda0.m.daocloud.io"]
}
EOF

echo 'enable docker'
systemctl daemon-reload
systemctl enable docker
systemctl start docker

#dos2unix -q /vagrant/systemd/*.service
#cp /vagrant/systemd/*.service /usr/lib/systemd/system/

if [[ $1 -eq 1 ]]
then
    echo "configure master and node1"

fi

if [[ $1 -eq 2 ]]
then
    echo "configure node2"
fi

if [[ $1 -eq 3 ]]
then
    echo "configure node3"
fi

echo "Configure Kubectl to autocomplete"
#source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
#echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

