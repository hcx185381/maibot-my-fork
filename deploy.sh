#!/bin/bash

# MaiBot 一键部署脚本
# 适用于 Ubuntu 20.04+ / Debian 11+

set -e

echo "=========================================="
echo "   MaiBot 快速部署脚本"
echo "=========================================="
echo ""

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
    echo "请使用 sudo 运行此脚本"
    exit 1
fi

# 1. 更新系统
echo "📦 [1/7] 更新系统..."
apt update && apt upgrade -y

# 2. 安装 Docker
echo "🐳 [2/7] 安装 Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
else
    echo "Docker 已安装"
fi

# 3. 安装 Docker Compose
echo "🔧 [3/7] 安装 Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
else
    echo "Docker Compose 已安装"
fi

# 4. 克隆仓库
echo "📥 [4/7] 克隆 MaiBot 仓库..."
if [ -d "maibot-my-fork" ]; then
    echo "仓库已存在，正在更新..."
    cd maibot-my-fork
    git pull origin main
else
    git clone https://github.com/hcx185381/maibot-my-fork.git
    cd maibot-my-fork
fi

# 5. 创建必要的目录
echo "📁 [5/7] 创建数据目录..."
mkdir -p docker-config/mmc docker-config/adapters docker-config/napcat
mkdir -p data/MaiMBot data/adapters data/qq
mkdir -p logs

# 6. 复制配置文件
echo "⚙️  [6/7] 配置环境变量..."
if [ ! -f "docker-config/mmc/.env" ]; then
    cp .env.production docker-config/mmc/.env
    echo ""
    echo "⚠️  重要：请编辑 docker-config/mmc/.env 文件，添加你的 API Key！"
    echo ""
    echo "运行以下命令编辑配置："
    echo "  nano docker-config/mmc/.env"
    echo ""
    echo "必须配置的项："
    echo "  - API_KEY=你的大模型API密钥"
    echo "  - MODEL_NAME=模型名称"
    echo "  - SUPERUSERS=你的QQ号"
    echo ""
    read -p "配置完成后按 Enter 继续..."
else
    echo "配置文件已存在"
fi

# 7. 启动服务
echo "🚀 [7/7] 启动 MaiBot..."
docker-compose up -d

# 等待容器启动
echo ""
echo "⏳ 等待服务启动..."
sleep 10

# 检查服务状态
echo ""
echo "✅ 部署完成！"
echo ""
echo "=========================================="
echo "   服务状态"
echo "=========================================="
docker-compose ps

echo ""
echo "=========================================="
echo "   访问地址"
echo "=========================================="
SERVER_IP=$(curl -s ifconfig.me)
echo "🌐 WebUI 管理界面: http://$SERVER_IP:8001"
echo "🗄️  数据库管理:     http://$SERVER_IP:8120"
echo ""
echo "=========================================="
echo "   常用命令"
echo "=========================================="
echo "查看日志: docker-compose logs -f core"
echo "重启服务: docker-compose restart"
echo "停止服务: docker-compose down"
echo "更新代码: git pull && docker-compose up -d --build"
echo ""
echo "=========================================="
echo "   下一步"
echo "=========================================="
echo "1. 查看日志获取登录二维码："
echo "   docker-compose logs -f core"
echo ""
echo "2. 或查看本地的 qrcode.png 文件"
echo ""
echo "3. 用手机 QQ 扫码登录"
echo ""
echo "🎉 部署成功！祝使用愉快！"
echo "=========================================="
