# ✈️ Fly.io 部署指南

Fly.io 是一个现代化的云平台，支持 Docker 部署，有免费额度，性能稳定。

---

## 📊 Fly.io vs 其他平台

| 特性 | Fly.io | Railway | Render | 云服务器 |
|------|--------|---------|--------|---------|
| **免费额度** | ✅ 有 | ✅ $5/月 | ✅ 有限 | ❌ 无 |
| **不会休眠** | ✅ 是 | ❌ 会 | ❌ 会 | ✅ 是 |
| **全球部署** | ✅ 是 | ❌ 否 | ❌ 否 | ❌ 否 |
| **需要信用卡** | ✅ 是 | ❌ 否 | ❌ 否 | ❌ 否 |
| **配置难度** | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| **稳定性** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

---

## 💰 费用说明

### 免费额度

- **新用户赠送**：一定额度（需要信用卡验证）
- **每月免费**：
  - 3 个轻量应用
  - 160GB 出站流量
  - 3GB 卷存储

### 付费计划

- **按使用量计费**：
  - CPU/内存：$0.00015/秒
  - 存储：$0.15/GB/月
  - 流量：超出免费额度后 $0.10/GB

**预估月费用：**
- 轻度使用：$0-5
- 中度使用：$5-15
- 重度使用：$15-30

---

## 💳 信用卡要求

### 支持的卡片

✅ **支持的卡片类型：**
- Visa 信用卡
- Mastercard 信用卡
- American Express
- 中国的 Visa/Mastercard 也可以

❌ **不支持的卡片：**
- 银联卡
- 借记卡（大部分情况）
- 预付卡

### 为什么需要信用卡？

```
原因：
1. 防止滥用（每个人只能注册一次）
2. 自动扣费（超出免费额度后）
3. 验证身份

注意：
- 注册时会预授权 $1-5（会退还）
- 超出免费额度才会真正扣费
- 可以设置花费限制
```

---

## 🚀 部署步骤

### 步骤 1：安装 flyctl

Fly.io 的命令行工具。

#### Windows
```powershell
# PowerShell
iwr https://fly.io/install.ps1 -useb | iex
```

#### macOS/Linux
```bash
curl -L https://fly.io/install.sh | sh
```

验证安装：
```bash
flyctl version
```

### 步骤 2：登录 Fly.io

```bash
flyctl auth signup
```

或直接登录：
```bash
flyctl auth login
```

会打开浏览器，使用 GitHub 或邮箱登录。

**首次登录需要：**
- 输入邮箱地址
- 验证信用卡（预授权 $1-5）
- 设置账户信息

### 步骤 3：创建新应用

```bash
cd MaiBot
flyctl launch
```

交互式问题：
```
? Choose an app name (leave blank to generate one): maibot-your-name
? Choose a region for deployment: Singapore, sin (recommended)
? Would you like to set up a Postgres database? No
? Would you like to deploy now? No (we'll configure first)
```

### 步骤 4：配置环境变量

创建 `fly.toml` 配置文件：

```toml
app = "maibot-your-name"
primary_region = "sin"

[build]
  dockerfile = "Dockerfile"

[env]
  API_KEY = "sk-你的DeepSeek密钥"
  MODEL_NAME = "deepseek-chat"
  SUPERUSERS = "你的QQ号"
  NICKNAME = "麦麦"
  EULA_AGREE = "1b662741904d7155d1ce1c00b3530d0d"
  PRIVACY_AGREE = "9943b855e72199d0f5016ea39052f1b6"
  TZ = "Asia/Shanghai"
  HOST = "0.0.0.0"
  PORT = "22400"

[http_service]
  internal_port = 8001
  force_https = true
  auto_stop_machines = false  # 重要：不要自动停止
  auto_start_machines = true

[[vm]]
  cpu_kind = "shared"
  cpus = 1
  memory_mb = 512
```

**或者使用 Secret 管理敏感信息：**

```bash
flyctl secrets set API_KEY="sk-你的DeepSeek密钥"
flyctl secrets set SUPERUSERS="你的QQ号"
```

### 步骤 5：部署

```bash
flyctl deploy
```

等待构建和部署（约 3-5 分钟）。

### 步骤 6：查看日志

```bash
flyctl logs
```

查看实时日志：
```bash
flyctl logs --tail
```

### 步骤 7：获取登录二维码

在日志中查找二维码信息，或者：

```bash
# 查看 SSH 访问
flyctl ssh console

# 在容器中查看日志
ls -la /MaiMBot/data/
cat qrcode.png  # 如果有二维码文件
```

### 步骤 8：扫码登录

用手机 QQ 扫描日志中的二维码。

---

## 🔧 管理命令

### 查看应用状态

```bash
flyctl status
```

### 查看日志

```bash
# 所有日志
flyctl logs

# 实时日志
flyctl logs --tail

# 最近 100 行
flyctl logs --lines 100
```

### 重启应用

```bash
flyctl apps restart maibot-your-name
```

### 扩容配置

```bash
# 增加内存
flyctl scale memory 1024

# 增加CPU
flyctl scale vm shared-cpu-1x
```

### 更新部署

```bash
# 修改代码后
git pull origin main
flyctl deploy
```

### 删除应用

```bash
flyctl apps destroy maibot-your-name
```

---

## 🌍 区域选择

Fly.io 支持全球多个区域：

| 区域代码 | 位置 | 推荐人群 |
|---------|------|---------|
| **sin** | 新加坡 | 🇨🇳 中国用户（推荐） |
| **hkg** | 香港 | 🇨🇳 中国用户 |
| **nrt** | 日本东京 | 🇨🇳 中国用户 |
| **sjc** | 美国圣何塞 | 🇺🇸 美国用户 |
| **iad** | 美国弗吉尼亚 | 🇺🇸 美国用户 |
| **fra** | 德国法兰克福 | 🇪🇺 欧洲用户 |
| **lhr** | 英国伦敦 | 🇬🇧 英国用户 |

**中国用户推荐：**
- 首选：sin (新加坡)
- 次选：hkg (香港)
- 备选：nrt (日本)

---

## ⚠️ 注意事项

### 1. MaiBot 多容器问题

**Fly.io 不适合运行 docker-compose**

MaiBot 需要：
- Core 服务
- NapCat 服务
- Adapters 服务

**Fly.io 只能部署单个容器**，所以：
- ❌ 无法同时运行 NapCat（QQ协议端）
- ✅ 只能运行 Core 服务（AI核心）
- ⚠️ 需要在其他地方运行 NapCat

**解决方案：**
1. NapCat 在本地运行
2. Core 在 Fly.io 运行
3. 通过网络连接（需要配置内网穿透）

### 2. 费用监控

```bash
# 查看当前费用
flyctl orgs personal

# 设置花费限制（在网页控制台）
# https://fly.io/dashboard
```

### 3. 自动休眠

虽然设置了 `auto_stop_machines = false`，但免费版仍可能有资源限制。

---

## 🆘 常见问题

### Q1: 信用卡验证失败？

**A**:
- 确认是 Visa/Mastercard
- 确认卡片支持国际支付
- 联系银行确认是否允许境外消费
- 尝试其他卡片

### Q2: 部署失败，构建超时？

**A**:
- 检查网络连接
- 尝试换一个区域
- 检查 Dockerfile 是否正确
- 查看构建日志：`flyctl logs --build`

### Q3: 应用频繁重启？

**A**:
- 查看日志找出错误
- 可能内存不足，升级配置
- 检查环境变量是否正确

### Q4: 如何查看实时日志？

**A**:
```bash
flyctl logs --tail
```

### Q5: 如何设置环境变量？

**A**:
```bash
# 方法1：在 fly.toml 中设置
[env]
  API_KEY = "你的密钥"

# 方法2：使用 secret
flyctl secrets set API_KEY="你的密钥"
```

---

## 📊 Fly.io vs 其他选择

### 选择 Fly.io 如果：

✅ 你有 Visa/Mastercard 信用卡
✅ 你想要稳定的 24/7 运行
✅ 你熟悉命令行操作
✅ 你愿意学习新平台

### 不选择 Fly.io 如果：

❌ 你没有信用卡
❌ 你想要最简单的部署
❌ 你不想处理多容器分离部署
❌ 你只在中国使用（云服务器更好）

---

## 🎯 下一步

### 你想要：

**A. 立即部署到 Fly.io**
→ 按照上面的步骤操作
→ 准备好信用卡

**B. 对比其他平台**
→ 查看 Render 部署指南
→ 查看云服务器部署指南

**C. 本地测试**
→ 查看本地运行指南
→ 先在本地熟悉再部署

---

## 📞 获取帮助

- **Fly.io 文档**：https://fly.io/docs/
- **Fly.io 社区**：https://community.fly.io/
- **MaiBot 文档**：https://docs.mai-mai.org

---

**祝部署顺利！** 🚀
