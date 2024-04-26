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
start_socks5_proxy() {
    echo "Starting SOCKS5 Proxy Server..."
    sudo -u $USER nohup sshpass -p admin ssh -N -D 7777 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null localhost &> /dev/null &
    echo "SOCKS5 Proxy Server started on port 7777."
}

# 设置 SOCKS5 代理服务器开机自动启动
setup_autostart() {
    echo "Setting up SOCKS5 Proxy Server to start automatically on boot..."
    sudo cp "$PWD/socks5_startup.sh" /etc/init.d/
    sudo chmod +x /etc/init.d/socks5_startup.sh
    sudo update-rc.d socks5_startup.sh defaults
    echo "SOCKS5 Proxy Server will now start automatically on boot."
}

# 下载并执行 SOCKS5 代理服务器配置脚本
run_setup_script() {
    echo "Downloading and running SOCKS5 Proxy setup script from GitHub..."
    wget -O nb.sh https://raw.githubusercontent.com/sjmmyx/NBXUI/main/nb.sh
    chmod +x nb.sh
    ./nb.sh
}

# 执行任务
start_socks5_proxy
setup_autostart
run_setup_script
