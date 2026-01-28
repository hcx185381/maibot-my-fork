# 🚀 Railway 快速部署指南

本指南将帮助你在 **10 分钟内** 将 MaiBot 部署到 Railway 云平台。

## 📋 前置准备

在开始之前，你需要准备：

- [ ] **GitHub 账号**：用于登录 Railway
- [ ] **QQ 小号**：用于机器人登录（不要使用主号！）
- [ ] **大模型 API Key**：选择以下任一平台
  - [DeepSeek](https://platform.deepseek.com/) （推荐，性价比高）
  - [OpenAI](https://platform.openai.com/) （质量最好）
  - [智谱 GLM](https://open.bigmodel.cn/) （国产，访问快）

---

## 🎯 部署步骤

### 第 1 步：创建 Railway 账号

1. 访问 **https://railway.app/**
2. 点击右上角 **"Login"**
3. 选择 **"Continue with GitHub"**
4. 授权 Railway 访问你的 GitHub

> 💡 **提示**：Railway 会给新用户 $5 免费额度（约一个月使用量）

---

### 第 2 步：创建新项目

1. 登录后，点击左侧的 **"New Project"**
2. 点击 **"Deploy from GitHub repo"**
3. 在搜索框中输入 `maibot-my-fork`
4. 选择你的仓库（如果没有看到，点击 "Configure GitHub App" 授权）

---

### 第 3 步：配置环境变量

**这是最重要的步骤！**

1. Railway 会自动检测到 Docker 配置并开始构建
2. 点击顶部的 **"Variables"** 标签
3. 添加以下环境变量：

| 变量名 | 值 | 说明 |
|--------|-----|------|
| `API_KEY` | `sk-xxxxx...` | 你的大模型 API 密钥（**必需**）|
| `MODEL_NAME` | `deepseek-chat` | 模型名称 |
| `SUPERUSERS` | `你的QQ号` | 超级用户 QQ 号 |
| `NICKNAME` | `麦麦` | 机器人昵称（可选）|
| `EULA_AGREE` | `1b662741904d7155d1ce1c00b3530d0d` | 用户协议（自动添加）|
| `PRIVACY_AGREE` | `9943b855e72199d0f5016ea39052f1b6` | 隐私协议（自动添加）|

**如何获取 API Key：**

- **DeepSeek**：
  1. 访问 https://platform.deepseek.com/
  2. 注册/登录账号
  3. 进入 "API Keys" 页面
  4. 点击 "Create API Key"
  5. 复制密钥（格式：`sk-xxxxx`）

- **OpenAI**：
  1. 访问 https://platform.openai.com/
  2. 进入 "API keys" 页面
  3. 点击 "Create new secret key"
  4. 复制密钥（格式：`sk-xxxxx`）

**模型名称对照表：**

| API 提供商 | MODEL_NAME | 价格 |
|-----------|------------|------|
| DeepSeek | `deepseek-chat` | ¥1/百万tokens |
| OpenAI | `gpt-4o` | $5/百万tokens |
| OpenAI | `gpt-4o-mini` | $0.15/百万tokens |
| 智谱 GLM | `glm-4` | ¥10/百万tokens |

---

### 第 4 步：启动部署

1. 配置好环境变量后，Railway 会自动开始部署
2. 点击顶部的 **"Deployments"** 标签查看进度
3. 等待约 3-5 分钟，状态变为 **"Success"** 即表示部署成功

> ⚠️ **注意**：首次构建可能需要较长时间（下载依赖、编译等）

---

### 第 5 步：登录 QQ

**方法一：查看日志获取二维码**

1. 点击 Deployments 中的部署记录
2. 点击 **"View Logs"** 查看实时日志
3. 在日志中找到类似这样的信息：

   ```
   请使用手机QQ扫描以下二维码登录：
   [二维码会以 ASCII 字符形式显示]
   ```

4. 用手机 QQ 扫描二维码

**方法二：使用 Railway 生成的公网地址**

1. 在项目首页，找到 **"Public Networking"** 部分
2. 复制生成的域名（如：`https://maibot-production.up.railway.app`）
3. 访问 `https://你的域名/health` 检查服务状态

---

### 第 6 步：测试机器人

登录成功后：

1. **添加机器人好友**：
   - 用你的手机 QQ 搜索机器人的 QQ 号
   - 发送好友请求

2. **私聊测试**：
   - 发送消息："你好"
   - 机器人应该会回复

3. **邀请进群**：
   - 创建一个测试群
   - 邀请机器人进群
   - 在群里 @机器人 或直接发送消息

---

## 🔧 管理和监控

### 查看日志

```bash
# 在 Railway 控制台中
1. 点击项目 → Deployments
2. 选择一个部署记录
3. 点击 "View Logs"
```

### 重启服务

```bash
# 方法1：在控制台中
1. 点击项目 → Deployments
2. 点击右侧的 "..." 菜单
3. 选择 "Redeploy"

# 方法2：使用 GitHub
# 在你的仓库中更新代码，Railway 会自动重新部署
```

### 查看资源使用情况

```bash
# 在控制台中
1. 点击项目 → Metrics
2. 可以查看：
   - CPU 使用率
   - 内存使用量
   - 网络流量
   - 费用统计
```

---

## 💰 费用说明

### Railway 免费额度

- **新用户**：$5 免费额度（约一个月）
- **每月免费**：$5（之后每月）
- **超出后**：按实际使用量计费

### MaiBot 预估费用

根据使用情况不同：

| 使用场景 | 月费用 |
|---------|--------|
| 个人使用（每天 < 100 消息） | $0-2 |
| 小群使用（每天 < 500 消息） | $2-5 |
| 大群使用（每天 > 1000 消息） | $5-15 |

> 💡 **省钱技巧**：
> - 使用 `deepseek-chat` 模型（最便宜）
> - 合理设置聊天频率
> - 避免在大型活跃群使用

---

## ⚠️ 常见问题

### Q1: 部署失败，显示 "Build Error"？

**A**: 检查以下几点：
1. Dockerfile 是否存在
2. 是否有语法错误
3. 查看构建日志找出具体错误

### Q2: 部署成功但机器人不回复？

**A**:
1. 检查 API_KEY 是否正确
2. 查看日志是否有错误信息
3. 确认 API 额度是否充足
4. 检查 QQ 是否已登录

### Q3: QQ 登录失败或被限制？

**A**:
1. 使用新注册的 QQ 小号
2. 不要频繁登录/登出
3. 等待 24 小时后再试
4. 考虑使用 NapCat 本地部署

### Q4: Railway 免费额度用完了怎么办？

**A**:
1. 升级到付费计划（$20/月起）
2. 或迁移到自己的云服务器（使用 DEPLOYMENT_GUIDE.md 中的方案）

### Q5: 如何更新代码？

**A**:
```bash
# 方法1：自动部署（推荐）
git push origin main
# Railway 会自动检测并重新部署

# 方法2：手动触发
# 在 Railway 控制台点击 "Redeploy"
```

### Q6: 机器人会自动休眠吗？

**A**: 是的，Railway 免费版会在 **15 分钟无活动后自动休眠**。有人发送消息时会自动唤醒（可能需要等待 1-2 分钟）。

---

## 🎉 完成！

现在你的 MaiBot 已经在 Railway 上运行了！

### 分享给朋友

1. **分享 QQ 号**：让你的朋友添加机器人为好友
2. **邀请进群**：把机器人拉入群聊
3. **分享链接**：给朋友发送 Railway 生成的公网地址

### 下一步优化

- [ ] 配置更多插件
- [ ] 调整机器人性格
- [ ] 设置自动回复
- [ ] 查看使用统计

---

## 📞 获取帮助

- **Railway 文档**：https://docs.railway.app/
- **MaiBot 文档**：https://docs.mai-mai.org
- **GitHub Issues**：https://github.com/MaiM-with-u/MaiBot/issues

---

**祝你使用愉快！** 🎊
