# 🖥️ MaiBot 本地运行完整指南

本指南将帮助你在自己的电脑上运行 MaiBot，完全免费，适合测试和学习。

---

## 📋 前置准备

### 硬件要求
- **操作系统**：Windows 10/11、macOS、或 Linux
- **内存**：建议 4GB 以上
- **硬盘**：至少 10GB 可用空间
- **网络**：稳定的互联网连接

### 软件要求
- Python 3.10 或更高版本
- Docker（推荐，更简单）
- QQ 小号（用于机器人登录）
- 大模型 API Key

---

## 🚀 方法一：使用 Docker 运行（推荐）

### 为什么推荐 Docker？
- ✅ 安装简单，一键启动
- ✅ 环境隔离，不影响系统
- ✅ 易于管理和卸载
- ✅ 和云端部署配置一致

### 步骤 1：安装 Docker

#### Windows
1. 访问 https://www.docker.com/products/docker-desktop/
2. 下载 Docker Desktop for Windows
3. 双击安装包，按提示安装
4. 重启电脑
5. 打开 PowerShell，输入 `docker --version` 验证安装

#### macOS
1. 访问 https://www.docker.com/products/docker-desktop/
2. 下载 Docker Desktop for Mac
3. 拖拽到 Applications 文件夹
4. 打开 Docker Desktop
5. 打开终端，输入 `docker --version` 验证安装

#### Linux (Ubuntu/Debian)
```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
# 重新登录后生效
docker --version
```

### 步骤 2：准备 MaiBot 代码

#### 如果已有代码
```bash
cd E:\github ai xiangmu\MaiBot
```

#### 如果需要下载
```bash
# 克隆你的仓库
git clone https://github.com/hcx185381/maibot-my-fork.git
cd maibot-my-fork
```

### 步骤 3：配置环境变量

创建 `.env` 文件：

```bash
# Windows (PowerShell)
Copy-Item .env.production .env

# Linux/macOS
cp .env.production .env
```

编辑 `.env` 文件，添加以下内容：

```env
# 必填：大模型 API 配置
API_KEY=sk-你的DeepSeek密钥
MODEL_NAME=deepseek-chat

# 必填：超级用户（你的QQ号）
SUPERUSERS=你的QQ号

# 可选：机器人昵称
NICKNAME=麦麦

# 必填：协议确认（已有，不用改）
EULA_AGREE=1b662741904d7155d1ce1c00b3530d0d
PRIVACY_AGREE=9943b855e72199d0f5016ea39052f1b6

# 其他配置
TZ=Asia/Shanghai
HOST=0.0.0.0
PORT=22400
```

**如何获取 DeepSeek API Key：**
1. 访问 https://platform.deepseek.com/
2. 注册账号（送免费额度）
3. 进入 "API Keys" 页面
4. 点击 "Create API Key"
5. 复制密钥（格式：`sk-xxxxx`）

### 步骤 4：创建必要的目录

```bash
# Windows
mkdir docker-config\mmc
mkdir docker-config\adapters
mkdir docker-config\napcat
mkdir data\MaiMBot

# Linux/macOS
mkdir -p docker-config/mmc docker-config/adapters docker-config/napcat
mkdir -p data/MaiMBot
```

### 步骤 5：复制配置文件

```bash
# Windows
Copy-Item .env docker-config\mmc\.env

# Linux/macOS
cp .env docker-config/mmc/.env
```

### 步骤 6：启动服务

**完整启动（包含所有服务）：**

```bash
docker-compose up -d
```

**只启动核心服务（推荐）：**

如果只想运行 Core 服务（不需要 NapCat），先创建简化版的 docker-compose 文件：

```bash
# 创建 docker-compose-simple.yml
```

或者直接运行 Core 容器：

```bash
docker run -d \
  --name maibot-core \
  --env-file .env \
  -v $(pwd)/data:/MaiMBot/data \
  -p 8001:8001 \
  sengokucola/maibot:latest
```

### 步骤 7：查看日志和二维码

```bash
# 查看实时日志
docker-compose logs -f core

# 或者
docker logs -f maibot-core
```

在日志中找到二维码信息，通常是这样的：

```
请使用手机QQ扫描以下二维码登录：
[大量的 ASCII 字符组成的二维码]
```

### 步骤 8：扫码登录

1. 用手机 QQ 扫描二维码
2. 确认登录
3. 看到日志显示 "登录成功" 即可

### 步骤 9：测试机器人

1. 用另一个 QQ 号添加机器人为好友
2. 发送消息："你好"
3. 机器人应该会回复

---

## 🐍 方法二：直接运行 Python（无需 Docker）

### 步骤 1：安装 Python

访问 https://www.python.org/downloads/ 下载并安装 Python 3.10+

### 步骤 2：安装依赖

```bash
cd MaiBot
pip install -r requirements.txt
```

### 步骤 3：配置环境变量

编辑 `.env` 文件（和方法一相同）

### 步骤 4：运行程序

```bash
python bot.py
```

### 步骤 5：扫码登录

在终端中查看二维码，用手机 QQ 扫码

---

## 🔧 常用命令

### Docker 方式

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看日志
docker-compose logs -f core

# 进入容器
docker exec -it maim-bot-core bash

# 更新代码
git pull origin main
docker-compose down
docker-compose up -d --build
```

### Python 方式

```bash
# 运行
python bot.py

# 停止
Ctrl + C

# 重新运行
python bot.py
```

---

## ⚠️ 注意事项

### 1. 电脑必须保持开机

```
本地运行的限制：
❌ 关机 = 机器人离线
❌ 断网 = 机器人无法回复
❌ 休眠 = 机器人停止工作
```

**解决方法：**
- 设置电脑永不休眠
- 或者部署到云端（见其他指南）

### 2. 端口占用

如果遇到端口占用错误：

```bash
# Windows - 查看端口占用
netstat -ano | findstr :22400

# Linux/macOS - 查看端口占用
lsof -i :22400
```

修改 `.env` 中的端口号：

```env
PORT=22401  # 换个端口
```

### 3. API Key 安全

```
⚠️ 重要安全提示：
✅ 不要把 .env 文件分享给别人
✅ 不要把 API_KEY 发到网上
✅ 定期检查 API 使用量
✅ 设置预算提醒
```

### 4. QQ 账号安全

```
⚠️ QQ 安全提示：
✅ 使用 QQ 小号（不要用主号）
✅ 不要分享二维码
✅ 立即自己扫码登录
✅ 监控登录状态
```

---

## 📊 费用说明

### 完全免费的部分

- ✅ MaiBot 软件（开源免费）
- ✅ 你的电脑资源
- ✅ Docker（个人使用免费）
- ✅ DeepSeek 新用户赠送的额度

### 需要付费的部分

| 项目 | 费用 | 说明 |
|------|------|------|
| **DeepSeek API** | ¥1/百万 tokens | 约 3000 条消息 |
| **OpenAI API** | $5/百万 tokens | 约 1500 条消息 |
| **智谱 GLM** | ¥10/百万 tokens | 约 2000 条消息 |

**预估月费用：**
- 轻度使用（每天 < 50 消息）：¥0-5
- 中度使用（每天 < 200 消息）：¥5-20
- 重度使用（每天 > 500 消息）：¥20-50

---

## 🆘 常见问题

### Q1: Docker 启动失败？

**A**: 检查 Docker 是否运行：
```bash
docker --version
docker ps
```

如果 Docker 未运行，打开 Docker Desktop。

### Q2: 找不到二维码？

**A**:
1. 检查日志：`docker-compose logs -f core`
2. 确认 .env 配置正确
3. 重启服务：`docker-compose restart`

### Q3: 机器人不回复？

**A**:
1. 检查 API_KEY 是否正确
2. 检查网络连接
3. 查看日志是否有错误
4. 确认 QQ 已登录

### Q4: 如何更新代码？

**A**:
```bash
git pull origin main
docker-compose down
docker-compose up -d --build
```

### Q5: 可以在多个电脑上运行吗？

**A**: 不建议。一个 QQ 号只能在一处登录。如果需要，让朋友自己部署。

---

## 🎯 下一步

### 你想要：

**A. 分享给朋友**
→ 告诉朋友自己部署（10分钟）
→ 或者部署到云端（24小时在线）

**B. 学习更多**
→ 查看配置文件
→ 尝试不同模型
→ 开发自定义插件

**C. 监控使用**
→ 查看 API 使用量
→ 检查日志
→ 优化配置

---

## 📞 获取帮助

- **官方文档**：https://docs.mai-mai.org
- **GitHub Issues**：https://github.com/MaiM-with-u/MaiBot/issues
- **技术交流群**：查看 README.md

---

**祝你使用愉快！** 🎊
