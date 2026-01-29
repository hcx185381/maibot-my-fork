# 📖 本项目定制说明

> 这是基于 [MaiM-with-u/maibot](https://github.com/MaiM-with-u/maibot) 的个人定制版本

## 🎯 定制版本特性

### ✨ 已实现的优化

1. **Windows Docker 环境修复**
   - ✅ 修复了 NapCat 在 Windows Docker 下的 GPU 初始化问题
   - ✅ 添加了自定义启动脚本 (`docker-config/napcat/entrypoint.sh`)
   - ✅ 修复了 WebUI 无法从外部访问的问题

2. **便捷管理工具**
   - ✅ 一键启动/停止脚本
   - ✅ 扫码登录辅助工具
   - ✅ 状态检查工具
   - ✅ 模型快速切换工具

3. **数据管理工具**
   - ✅ SQLite 数据库查看工具
   - ✅ Git 历史查看工具
   - ✅ Git 版本回退工具

4. **完善配置文件**
   - ✅ GLM-4 模型配置
   - ✅ DeepSeek 模型配置
   - ✅ 完整的机器人人设配置
   - ✅ 群聊活跃度配置

---

## 🚀 快速开始（本版本）

### 前置要求
- Windows 10/11
- Docker Desktop（已安装并运行）
- QQ 账号

### 三步启动

#### 步骤 1：启动 Docker Desktop
```bash
docker --version
```

#### 步骤 2：启动服务
```bash
# 首次启动（需要扫码）
双击运行：扫码登录.bat

# 日常启动（已登录）
双击运行：启动服务.bat
```

#### 步骤 3：访问 WebUI
```
http://localhost:8001
Token: Hcx185381!Admin@2026
```

---

## 🛠️ 可用工具列表

### 启动和管理
| 工具 | 功能 |
|------|------|
| `启动服务.bat` | 快速启动所有服务 |
| `停止服务.bat` | 停止所有服务 |
| `扫码登录.bat` | 首次登录或重新登录 |
| `检查状态.bat` | 查看运行状态和二维码 |

### 模型切换
| 工具 | 功能 |
|------|------|
| `切换到DeepSeek模型.bat` | 切换到 DeepSeek API |
| `切换到GLM模型.bat` | 切换到 GLM-4 API |

### 数据工具
| 工具 | 功能 |
|------|------|
| `查看数据库.bat` | 查看 SQLite 数据库 |
| `查看Git历史.bat` | 查看 Git 提交历史 |
| `Git版本回退工具.bat` | 版本回退操作 |

---

## ⚙️ 关键配置说明

### 1. WebUI 访问配置
**问题：** 默认配置下 WebUI 只能从容器内部访问

**解决：** 在 `docker-compose.yml` 中添加：
```yaml
environment:
  - WEBUI_HOST=0.0.0.0
  - WEBUI_PORT=8001
```

### 2. NapCat GPU 问题修复
**问题：** Windows Docker 下 NapCat GPU 初始化失败

**解决：** 创建自定义启动脚本：
```bash
docker-config/napcat/entrypoint.sh
```
添加参数：
```bash
--disable-gpu --disable-software-rasterizer
```

### 3. 固定 Token 配置
**文件：** `data/MaiMBot/webui.json`

```json
{
  "access_token": "Hcx185381!Admin@2026",
  "created_at": "2026-01-29T23:05:00.000000",
  "updated_at": "2026-01-29T23:05:00.000000",
  "first_setup_completed": true
}
```

---

## 📂 项目结构（定制版）

```
MaiBot/
├── *.bat                      # Windows 批处理工具（新增）
│   ├── 启动服务.bat
│   ├── 停止服务.bat
│   ├── 扫码登录.bat
│   ├── 检查状态.bat
│   ├── 切换到DeepSeek模型.bat
│   ├── 切换到GLM模型.bat
│   ├── 查看数据库.bat
│   ├── 查看Git历史.bat
│   └── Git版本回退工具.bat
├── *.txt                      # 说明文档（新增）
│   ├── 完整启动指南.txt
│   ├── MaiBot配置教程.txt
│   └── MaiBot配置对话记录.txt
├── docker-config/             # Docker 配置（修改）
│   ├── mmc/                   # MaiBot 配置
│   │   ├── bot_config.toml
│   │   ├── model_config.toml
│   │   └── model_config_*.toml
│   └── napcat/                # NapCat 配置
│       ├── entrypoint.sh      # 自定义启动脚本（新增）
│       └── *.json
├── data/                      # 数据目录（修改）
│   └── MaiMBot/
│       ├── MaiBot.db          # SQLite 数据库
│       ├── hippo_memorizer/   # 记忆文件
│       ├── logs/              # 日志
│       └── webui.json         # WebUI 配置
├── docker-compose.yml         # Docker 编排（修改）
├── .env.production            # 环境变量（修改）
└── README.md                  # 原始 README
```

---

## 🔧 配置文件详解

### bot_config.toml - 机器人配置

**关键配置项：**

```toml
[nickname]
nickname = "AI助手"                    # 机器人昵称

[personality]
personality = "一个可爱的女大学生..."  # 人设描述（100字内）
reply_style = "每句话结尾加上..."     # 说话风格
plan_style = """1. 平等对待所有用户...""" # 行为规则

[talk_value_rules]
# 群聊活跃度配置
{ target = "qq:群号:group", time = "00:00-23:59", value = 0.8 }
```

**活跃度参考：**
- `1.0` - 非常活跃（几乎每条都回）
- `0.8` - 很活跃（经常主动聊天）
- `0.5` - 中等活跃（偶尔主动说话）
- `0.3` - 比较沉默（很少主动说话）
- `0.1` - 非常沉默（几乎不主动）
- `0.05` - 几乎静默（极少主动）
- `0.0001` - 完全静默（只回复@）

### model_config.toml - 模型配置

**当前使用：** GLM-4 模型

**配置内容：**
```toml
[[api_providers]]
name = "GLM"
base_url = "https://open.bigmodel.cn/api/paas/v4"
api_key = "您的API密钥"

[[models]]
model_identifier = "glm-4"
name = "glm-4"
api_provider = "GLM"
```

**切换模型：** 使用 `切换到DeepSeek模型.bat` 或 `切换到GLM模型.bat`

---

## 📊 数据存储位置

### 主要数据库
**文件：** `data/MaiMBot/MaiBot.db` (460KB)

**主要表：**
- `messages` - 消息记录
- `chat_history` - 聊天历史
- `chat_streams` - 聊天流
- `thinking_back` - 思考回溯
- `person_info` - 用户信息
- `expression` - 表达方式学习
- `emoji` - 表情包
- `images` - 图片
- `llm_usage` - LLM 使用统计

### 日志文件
**目录：** `data/MaiMBot/logs/`

**内容：**
- `plan/` - 思考过程日志
- `reply/` - 回复日志
- `app_*.log.jsonl` - 应用日志

### 记忆文件
**目录：** `data/MaiMBot/hippo_memorizer/`

**内容：**
- 话题总结
- 对话历史
- 参与者信息

---

## 🌐 访问地址

| 服务 | 地址 | 用途 |
|------|------|------|
| **WebUI** | http://localhost:8001 | 机器人管理界面 |
| **NapCat WebUI** | http://localhost:6099 | QQ 协议端管理 |
| **SQLite Web** | http://localhost:8120 | 数据库管理 |

**Token：** `Hcx185381!Admin@2026`

---

## 📝 更新记录

### 2026-01-29
- ✅ 修复 NapCat GPU 初始化问题
- ✅ 修复 WebUI 外部访问问题
- ✅ 添加数据库查看工具
- ✅ 添加 Git 管理工具
- ✅ 创建完整配置文档

### 2026-01-28
- ✅ 添加 Docker 部署配置
- ✅ 添加辅助管理脚本
- ✅ 配置 GLM 和 DeepSeek 模型

---

## ❓ 常见问题

### Q1: WebUI 打不开？
**A:** 检查容器状态和端口配置：
```bash
docker ps
docker logs maim-bot-core
docker-compose restart core
```

### Q2: QQ 登录失败？
**A:** 重启 NapCat 容器获取新二维码：
```bash
docker restart maim-bot-napcat
# 或使用：扫码登录.bat
```

### Q3: Bot 不回复消息？
**A:** 检查：
1. API Key 是否正确
2. QQ 是否已登录
3. 活跃度配置是否过低
4. 是否设置了 `mentioned_bot_reply = true`

### Q4: 如何查看聊天记录？
**A:** 使用数据库查看工具：
```bash
双击运行：查看数据库.bat
```

### Q5: 如何备份数据？
**A:** 备份以下文件：
- `data/MaiMBot/MaiBot.db`
- `data/MaiMBot/hippo_memorizer/`
- `data/MaiMBot/logs/`
- `docker-config/`

---

## 🤝 与原版的主要区别

| 特性 | 原版 | 本定制版 |
|------|------|---------|
| **部署方式** | 多平台 | 专注 Windows Docker |
| **管理工具** | 命令行为主 | 批处理工具 + 命令行 |
| **文档** | 在线 Wiki | 本地文档 + 在线 Wiki |
| **配置** | 基础配置 | 完整预设配置 |
| **调试** | 需要了解 Docker | 图形化 + 简化命令 |
| **GPU 支持** | 需要配置 | 自动禁用（Windows） |

---

## 📚 相关资源

- **原项目：** https://github.com/MaiM-with-u/maibot
- **官方文档：** https://docs.mai-mai.org
- **技术交流群：** 查看 README.md
- **本仓库：** https://github.com/hcx185381/maibot-my-fork

---

## 💡 使用建议

### 日常使用
1. 使用 `启动服务.bat` 快速启动
2. 通过 WebUI 管理机器人
3. 使用 `查看数据库.bat` 查看记录
4. 定期备份数据目录

### 开发调试
1. 查看容器日志：`docker logs maim-bot-core`
2. 检查连接状态：`docker logs maim-bot-core | findstr "WebSocket"`
3. 使用 Git 工具管理版本
4. 修改配置后重启容器

### 数据维护
1. 定期清理日志（自动清理30天前）
2. 定期备份数据库
3. 监控 API 使用量
4. 查看统计数据调整活跃度

---

## ⚠️ 重要提示

1. **数据安全**
   - 定期备份 `data/MaiMBot/` 目录
   - 不要将 `data/` 目录提交到 Git
   - API Key 已在 `.gitignore` 中排除

2. **Docker 使用**
   - 确保 Docker Desktop 已启动
   - 容器异常时使用 `docker-compose down` 后重新启动
   - 不要手动删除容器

3. **QQ 使用**
   - 遵守 QQ 使用规范
   - 注意账号安全
   - 避免频繁操作

---

## 📮 联系方式

- **GitHub:** https://github.com/hcx185381
- **QQ:** 3622889793 (海澜)
- **Issues:** https://github.com/hcx185381/maibot-my-fork/issues

---

<div align="center">

**定制版本维护者：** [hcx185381](https://github.com/hcx185381)

**基于：** [MaiM-with-u/maibot](https://github.com/MaiM-with-u/maibot)

**最后更新：** 2026-01-29

Made with ❤️ by hcx185381

</div>
