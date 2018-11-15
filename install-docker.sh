#! /bin/sh
# 卸载存在版本
sudo yum remove docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-selinux \
                docker-engine-selinux \
                docker-engine;
# 安装依赖
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2;
# 添加源
sudo yum-config-manager \
--add-repo \
https://download.docker.com/linux/centos/docker-ce.repo;

# 安装
sudo yum install docker-ce;

# 添加docker组，并把该非root用户加入组中。
sudo usermod -aG docker $USER;

# start
sudo systemctl start docker;

# 添加内核参数
sudo tee -a /etc/sysctl.conf <<-EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF;

# 重载sysctl.conf
sudo sysctl -p;

# 安装compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose;

sudo chmod +x /usr/local/bin/docker-compose;
