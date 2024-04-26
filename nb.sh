#!/bin/bash

# 安装必需的软件包
packages=("openssh-server" "sshpass")

for pkg in "${packages[@]}"; do
    if ! dpkg -s "$pkg" &> /dev/null; then
        echo "Installing $pkg..."
        sudo apt-get update
        sudo apt-get install -y "$pkg"
        echo "$pkg installed successfully."
    fi
done

# 配置 SSH 服务
sudo sed -i '/^#PasswordAuthentication yes/c\PasswordAuthentication yes' /etc/ssh/sshd_config
sudo systemctl restart sshd

# 启动 SOCKS5 代理服务器
echo "Starting SOCKS5 Proxy Server..."
sudo -u $USER nohup sshpass -p admin ssh -N -D 7777 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null localhost &> /dev/null &
echo "SOCKS5 Proxy Server started on port 7777."

# 设置 SOCKS5 代理服务器开机自动启动
echo "Setting up SOCKS5 Proxy Server to start automatically on boot..."
sudo cp "$PWD/socks5_startup.sh" /etc/init.d/
sudo chmod +x /etc/init.d/socks5_startup.sh
sudo update-rc.d socks5_startup.sh defaults
echo "SOCKS5 Proxy Server will now start automatically on boot."
