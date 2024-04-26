#!/bin/bash

# 更新apt软件包索引
sudo apt update

# 安装socks5代理软件和依赖
sudo apt install -y dante-server

# 配置socks5代理
echo "logoutput: /var/log/socks.log
internal: eth0 port = 7777
external: eth0
socksmethod: username" | sudo tee /etc/danted.conf

# 添加socks5代理用户admin，密码为admin
sudo useradd --shell /usr/sbin/nologin admin
echo "admin:admin" | sudo chpasswd

# 启动socks5代理服务
sudo systemctl start danted

# 设置socks5代理服务开机自启动
sudo systemctl enable danted

echo "socks5代理已启动，用户名: admin, 密码: admin, 端口: 7777"
