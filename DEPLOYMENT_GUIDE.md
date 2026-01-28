# MaiBot 部署指南

本指南帮助你将 MaiBot 部署到云端服务器，让其他人也可以访问你的机器人。

## 📋 前置要求

- 一台云服务器（推荐配置：2核4G，系统：Ubuntu 20.04+ 或 CentOS 7+）
- 已安装 Docker 和 Docker Compose
- 一个 QQ 小号（用于机器人登录）
- 大模型 API Key（推荐：OpenAI / DeepSeek / GLM 等）

---

## 🚀 方案一：云服务器部署（推荐）

### 1.1 购买云服务器

推荐平台：
- **阿里云**：https://www.aliyun.com/
- **腾讯云**：https://cloud.tencent.com/
- **华为云**：https://www.huaweicloud.com/

**推荐配置**：
- CPU：2核或以上
- 内存：4GB 或以上
- 硬盘：40GB+
- 带宽：5Mbps（按量付费即可）

**价格参考**：约 ¥30-100/月（新用户通常有优惠）

### 1.2 服务器环境配置

连接到服务器后，执行以下命令：

```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装 Docker
curl -fsSL https://get.docker.com | sh

# 安装 Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 验证安装
docker --version
docker-compose --version
```

### 1.3 部署 MaiBot

```bash
# 1. 克隆你的仓库
git clone https://github.com/hcx185381/maibot-my-fork.git
cd maibot-my-fork

# 2. 创建必要的配置文件
mkdir -p docker-config/mmc docker-config/adapters docker-config/napcat
mkdir -p data/MaiMBot data/adapters data/qq

# 3. 复制环境配置文件
cp .env.production docker-config/mmc/.env

# 4. 编辑环境变量（重要！）
nano docker-config/mmc/.env
```

在 `.env` 文件中添加以下配置：

```env
# 必填项
API_KEY=你的大模型API密钥
MODEL_NAME=模型名称（如：gpt-4o/deepseek-chat/glm-4）

# 可选项
SUPERUSERS=你的QQ号  # 超级用户，多个用逗号分隔
NICKNAME=麦麦  # 机器人昵称

# 已有的配置
EULA_AGREE=1b662741904d7155d1ce1c00b3530d0d
PRIVACY_AGREE=9943b855e72199d0f5016ea39052f1b6
TZ=Asia/Shanghai
HOST=0.0.0.0
PORT=22400
```

### 1.4 启动服务

```bash
# 构建并启动所有服务
docker-compose up -d

# 查看运行状态
docker-compose ps

# 查看日志（首次启动需要扫码登录QQ）
docker-compose logs -f core
```

### 1.5 登录 QQ

首次启动后，需要在日志中找到二维码：

```bash
# 方法1：实时查看日志
docker-compose logs -f core

# 方法2：查看 qrcode.png 文件
# 文件会保存在项目根目录
```

用手机 QQ 扫码登录即可。

### 1.6 管理服务

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看日志
docker-compose logs -f core

# 进入 WebUI 管理界面
# 浏览器访问：http://你的服务器IP:8001
```

---

## ☁️ 方案二：免费云平台部署

### 2.1 Railway（推荐新手）

**优点**：易用、自动部署、免费额度
**缺点**：免费额度有限（$5/月）、会休眠

部署步骤：

1. 访问 https://railway.app/
2. 使用 GitHub 账号登录
3. 点击 "New Project" → "Deploy from GitHub repo"
4. 选择你的 `maibot-my-fork` 仓库
5. Railway 会自动检测 `docker-compose.yml` 并部署
6. 在环境变量中配置 API_KEY 等信息
7. 部署完成后会获得公网 URL

### 2.2 Render

**优点**：免费额度、Docker 支持
**缺点**：配置复杂、免费版会休眠（15分钟无活动）

部署步骤：

1. 访问 https://render.com/
2. 连接 GitHub 账号
3. 点击 "New" → "Web Service"
4. 选择你的仓库
5. 配置环境变量
6. 部署

### 2.3 Fly.io

**优点**：全球部署、性能好
**缺点**：需要信用卡、学习成本较高

部署步骤：

```bash
# 安装 flyctl
curl -L https://fly.io/install.sh | sh

# 登录
flyctl auth login

# 初始化项目
flyctl launch

# 部署
flyctl deploy
```

---

## 🔧 配置说明

### 端口说明

MaiBot 默认使用以下端口：

| 端口 | 用途 | 说明 |
|------|------|------|
| 22400 | QQ 网关 | WebSocket 反向连接 |
| 8001 | WebUI | 管理界面 |
| 6099 | NapCat | QQ 协议端 |
| 8120 | SQLite Web | 数据库管理 |

### 防火墙配置

```bash
# Ubuntu/Debian
sudo ufw allow 22400
sudo ufw allow 8001
sudo ufw allow 6099
sudo ufw allow 8120
sudo ufw reload

# CentOS/RHEL
sudo firewall-cmd --permanent --add-port=22400/tcp
sudo firewall-cmd --permanent --add-port=8001/tcp
sudo firewall-cmd --permanent --add-port=6099/tcp
sudo firewall-cmd --permanent --add-port=8120/tcp
sudo firewall-cmd --reload
```

---

## 📊 监控和管理

### WebUI 管理界面

访问 `http://你的服务器IP:8001` 可以：
- 查看机器人状态
- 管理插件
- 查看聊天记录
- 配置参数

### 数据库管理

访问 `http://你的服务器IP:8120` 可以：
- 查看 SQLite 数据库
- 执行 SQL 查询
- 导出数据

---

## ⚠️ 注意事项

1. **QQ 账号安全**：
   - 使用小号，避免主号被封
   - 不要频繁操作，避免触发风控
   - 建议使用新注册的 QQ 号

2. **API Key 安全**：
   - 不要将 `.env` 文件提交到 GitHub
   - 定期更换 API Key
   - 设置 API 调用限额

3. **服务器安全**：
   - 修改 SSH 默认端口
   - 启用防火墙
   - 定期更新系统
   - 备份重要数据

4. **成本控制**：
   - 监控 API 调用量
   - 设置告警
   - 定期检查账单

---

## 🔄 更新和备份

### 更新代码

```bash
cd ~/maibot-my-fork
git pull origin main
docker-compose down
docker-compose up -d --build
```

### 备份数据

```bash
# 备份整个 data 目录
tar -czf maiBot-backup-$(date +%Y%m%d).tar.gz data/

# 备份到本地（在你的电脑上执行）
scp user@你的服务器IP:~/maibot-my-fork/maiBot-backup-*.tar.gz ./
```

---

## 🆘 常见问题

### Q1: 机器人登录失败？
**A**: 检查是否被风控，尝试换个 QQ 号或等一段时间再试。

### Q2: 机器人不回复消息？
**A**:
- 检查 API Key 是否正确
- 查看 `docker-compose logs core` 日志
- 确认有足够的 API 额度

### Q3: Docker 容器启动失败？
**A**:
- 检查端口是否被占用：`netstat -tlnp`
- 查看容器日志：`docker-compose logs`
- 重新构建：`docker-compose up -d --build`

### Q4: 如何让机器人 24/7 运行？
**A**: Docker Compose 已配置 `restart: always`，会自动重启。

### Q5: 内存不足怎么办？
**A**:
- 增加服务器内存
- 或者使用 SQLite Web 替代 Chat2DB（节省内存）

---

## 📞 获取帮助

- **官方文档**：https://docs.mai-mai.org
- **GitHub Issues**：https://github.com/MaiM-with-u/MaiBot/issues
- **技术交流群**：查看 README.md 中的群号

---

## 🎉 完成！

部署完成后，你的 MaiBot 就可以 24/7 在线了！

分享给你的朋友：
- 让他们加你的机器人的 QQ
- 或者邀请机器人群聊

**祝你使用愉快！** 🎊
