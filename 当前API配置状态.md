# MaiBot API 配置状态

**更新时间**: 2026-02-02 20:16

---

## 📌 当前使用状态

### ✅ 主用：DeepSeek 官方 API

**API Key**: `sk-d38850098a9540b7a88ded9e311f2a46`

**可用模型**:
- `deepseek-chat` - 日常对话、工具任务
- `deepseek-reasoner` - 复杂推理、规划任务
- `deepseek-vl` - 视觉理解

**任务分配**:
- 所有任务都使用 DeepSeek 官方 API
- 简单任务用 `deepseek-chat`
- 复杂推理用 `deepseek-reasoner`

---

## 🔧 备用配置（已配置但未启用）

### 💾 硅基流动 SiliconFlow

**API Key**: `sk-idjdrtdithcxuozmairymdebbovithfcidkvnavnchwnxavh`

**状态**: API Key已验证可用，但未配置到任务

**优势**:
- 新用户赠送14元（约2000万Tokens）
- 有永久免费模型
- 备用平台，当DeepSeek出问题时可快速切换

**如何启用**: 需要时修改 `docker-config/mmc/model_config.toml` 中的任务配置即可

---

## 📊 配置文件结构

```
docker-config/mmc/model_config.toml
├── API提供商配置
│   ├── GLM (智谱AI)
│   ├── SiliconFlow (硅基流动) ⭐ 备用
│   └── DeepSeek (官方) ⭐ 当前使用
│
├── 模型列表
│   ├── glm-4, glm-4-plus, glm-4v-plus, glm-4-air (GLM模型)
│   ├── deepseek-chat, deepseek-reasoner, deepseek-vl (DeepSeek模型)
│
└── 任务配置
    └── 所有任务 → DeepSeek官方模型
```

---

## 🚀 快速切换指南

### 切换到硅基流动

当需要使用硅基流动时，修改 `model_config.toml`：

```toml
# 修改任务配置中的 model_list
[model_task_config.replyer]
model_list = ["deepseek-ai/DeepSeek-V3"]  # 改为硅基流动的模型

# 先添加硅基流动的模型到 [[models]] 部分
[[models]]
model_identifier = "deepseek-ai/DeepSeek-V3"
name = "deepseek-ai/DeepSeek-V3"
api_provider = "SiliconFlow"
price_in = 2
price_out = 8
force_stream_mode = false
```

然后重启：`docker-compose restart core`

---

## 💡 建议使用场景

### 使用 DeepSeek 官方
- ✅ 追求最佳性能
- ✅ 不在意费用
- ✅ 需要最新模型功能

### 使用硅基流动
- ✅ 想节省费用（有免费额度）
- ✅ DeepSeek 服务不稳定
- ✅ 需要备用方案

---

## 📝 备注

- 硅基流动的 API 配置已保留在 `model_config.toml` 第15-22行
- 随时可以快速切换
- 配置文档参考：`硅基流动配置完成总结.md`

---

**创建时间**: 2026-02-02
**配置状态**: DeepSeek 官方 API 运行中 ✅
