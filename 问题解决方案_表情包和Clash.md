# MaiBot 问题解决方案

## 问题 1：Clash Verge 无法打开

### 原因分析
- Clash Verge 进程可能已崩溃或关闭
- 配置文件可能损坏
- 端口可能被占用

### 解决方案

#### 方案 1：重新启动 Clash Verge
1. 在开始菜单搜索 "Clash Verge"
2. 点击启动应用程序
3. 确认系统托盘出现 Clash 图标

#### 方案 2：如果启动失败，重置配置
```bash
# 1. 备份当前配置
cd "C:\Users\admin\AppData\Roaming\io.github.clash-verge-rev.clash-verge-rev"
mkdir backup
copy clash-verge.yaml backup\
copy verge.yaml backup\

# 2. 删除或重命名配置文件
ren clash-verge.yaml clash-verge.yaml.bak
ren verge.yaml verge.yaml.bak

# 3. 重新启动 Clash Verge（会自动生成默认配置）
```

#### 方案 3：检查端口占用
```bash
# 查看 7897 端口是否被占用
netstat -ano | findstr ":7897"

# 如果被占用，终止进程（PID 为最后一列数字）
taskkill /F /PID <进程ID>
```

#### 方案 4：重新安装 Clash Verge
如果以上方案都不行：
1. 卸载 Clash Verge
2. 下载最新版本：https://github.com/clash-verge-rev/clash-verge-rev/releases
3. 重新安装并配置订阅

### 重要提示
**MaiBot 必须依赖 Clash Verge 才能访问 AI API**：
- 不运行 Clash → 机器人无法回复消息
- 必须开启"允许局域网连接"
- HTTP 代理端口必须是 7897

---

## 问题 2：MaiBot 表情包无法识别和添加

### 原因分析

**核心问题**：NapCat 将 QQ 表情包转换成了**文本描述**，而不是提供图片文件。

**证据**：
```
# NapCat 日志
01-30 21:35:29 [info] 海澜 | 接收 <- 群聊 [...] [九尾梵星] [表情 ]

# MaiBot 日志
01-30 21:35:29 [所见] [黄哥最强]九尾梵星:[表情：斜眼笑]
```

**技术原因**：
- QQ 表情包使用特殊协议，不是普通图片
- NapCat 无法获取表情包的图片 URL 或文件路径
- 只能转发表情包的文字描述（如"[表情：斜眼笑]"）
- MaiBot 收到的是文本消息，没有图片可下载

### 当前状态

| 目录 | 状态 | 说明 |
|------|------|------|
| `data/MaiMBot/emoji/` | 空 | 用于存放新表情包（待下载） |
| `data/MaiMBot/emoji_registed/` | 2 个文件 | 已注册到数据库的表情包 |
| `data/MaiMBot/emoji_thumbnails/` | 存在 | 表情包缩略图 |
| `data/MaiMBot/images/` | 多个文件 | 其他图片文件 |

### 解决方案

#### 方案 1：手动添加表情包（推荐）

如果想让 MaiBot 使用表情包，可以手动添加：

1. **准备表情包图片**
   - 收集你想要的表情包图片（jpg/png/gif）
   - 确保文件名有意义（可选）

2. **将图片放到待扫描目录**
   ```bash
   # 复制表情包到 emoji 目录
   copy "你的表情包.jpg" "E:\github ai xiangmu\MaiBot\data\MaiMBot\emoji\"
   ```

3. **等待自动扫描**
   - MaiBot 每 10 分钟自动扫描一次 `data/emoji` 目录
   - 扫描到新图片会自动注册到数据库
   - 注册成功后移动到 `emoji_registed/` 目录

4. **手动触发扫描（可选）**
   ```bash
   # 重启 MaiBot 容器触发立即扫描
   docker-compose restart core
   ```

#### 方案 2：发送普通图片（可行）

发送普通图片消息时，MaiBot 可以自动保存：
- 在群里发送普通图片（不是表情包）
- MaiBot 会自动下载并保存
- 配置 `steal_emoji = true` 时会自动保存

#### 方案 3：等待 NapCat 更新（未来方案）

目前 NapCat 不支持获取 QQ 表情包的图片文件。
- 关注 NapCat 官方更新
- 可能在未来版本中支持表情包图片获取
- GitHub: https://github.com/NapNeko/NapCatQQ

#### 方案 4：使用其他适配器（高级）

如果表情包功能很重要，可以考虑：
1. 使用官方 QQ Bot SDK（需要企业认证）
2. 使用其他支持表情包的第三方协议
3. 等待社区开发支持表情包的适配器

### 配置说明

当前表情包配置（`docker-config/mmc/bot_config.toml`）：

```toml
[emoji]
emoji_chance = 0.8          # 80% 概率激活表情包动作
max_reg_num = 100           # 最多保存 100 个表情包
do_replace = true           # 达到最大数量时替换旧表情包
check_interval = 10         # 每 10 分钟检查一次
steal_emoji = true          # 自动保存群聊中的图片
content_filtration = false  # 不启用内容过滤
filtration_prompt = "符合公序良俗"
```

### 验证方法

检查表情包功能是否正常：
```bash
# 1. 查看日志
docker logs maim-bot-core 2>&1 | grep "表情包"

# 2. 查看已注册表情包数量
ls "E:\github ai xiangmu\MaiBot\data\MaiMBot\emoji_registed\" | find /c /v ""

# 3. 查看数据库中的表情包记录
# （使用"查看数据库.bat"工具）
```

### 常见问题

**Q1: 为什么 MaiBot 能看到表情包但无法保存？**
A: NapCat 只发送了表情包的文字描述，没有图片文件。这是 NapCat 的限制，不是 MaiBot 的问题。

**Q2: 已注册的 2 个表情包是从哪来的？**
A: 可能是你之前手动添加的，或者通过普通图片消息保存的。

**Q3: 如何让 MaiBot 使用更多表情包？**
A: 手动复制表情包图片到 `data/MaiMBot/emoji/` 目录，或发送普通图片让 MaiBot 自动保存。

**Q4: steal_emoji 配置无效吗？**
A: 不是无效，它对普通图片消息有效。只是对 QQ 表情包无效，因为 NapCat 不提供表情包图片。

**Q5: 有没有办法让 NapCat 发送表情包图片？**
A: 目前没有。这是 QQ 协议的限制，需要等待 NapCat 或其他适配器的更新。

---

## 总结

### Clash Verge 问题
- **优先级**：高（影响 AI 回复）
- **解决难度**：低
- **解决方案**：重新启动或重置配置

### 表情包问题
- **优先级**：中（不影响基本功能）
- **解决难度**：高（技术限制）
- **解决方案**：手动添加表情包或使用普通图片

### 建议
1. **优先解决 Clash Verge 问题**，否则机器人无法正常工作
2. 表情包功能是**可选的**，不影响基本的 AI 对话功能
3. 如果真的很需要表情包功能，可以考虑手动添加一些常用表情包
4. 持续关注 NapCat 和 MaiBot 的更新，可能在未来版本中支持

---

## 相关工具

项目中的诊断工具：
- `diagnose_emoji.bat` - 表情包问题诊断工具
- `诊断并修复网络问题.bat` - 网络/代理问题诊断
- `完整故障诊断流程.bat` - 全面故障诊断

文档：
- `网络故障排查指南.txt`
- `非网络故障排查指南.txt`
- `快速故障排除卡片.txt`

---

创建时间：2026-01-30
创建工具：Claude Code
版本：v1.0
