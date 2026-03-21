# ElevenLabs MCP + Claude Code 使用指南

## 安装步骤

### 1. 安装 uv（Python 包管理器）
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. 获取 ElevenLabs API Key
1. 登录 [elevenlabs.io](https://elevenlabs.io)
2. 左下角点头像 → **API Keys**
3. 复制 key（格式：`sk_xxxx...`）

### 3. 添加 MCP 到 Claude Code
```bash
claude mcp add-json "ElevenLabs" '{"command":"uvx","args":["elevenlabs-mcp"],"env":{"ELEVENLABS_API_KEY":"你的API_KEY"}}'
```

成功后会显示：
```
Added stdio MCP server ElevenLabs to local config
```

---

## 模型选择

| 模型 | 特点 |
|------|------|
| `eleven_multilingual_v2` | **最拟人**，支持中文，推荐！|
| `eleven_turbo_v2_5` | 快速 + 自然 |
| `eleven_flash_v2_5` | 最快，稍差一点 |

---

## 参数说明

| 参数 | 说明 |
|------|------|
| `stability` | 越高越稳定，越低越有感情变化 |
| `similarity_boost` | 声音相似度 |
| `style` | 风格夸张程度，超过 50% 可能不稳定 |
| `output_format` | 输出格式，如 `mp3_44100_128` |

---

## 我的声音配置

- **Voice Name:** Shanny - Kids American Storyteller
- **Voice ID:** `qlnUbSLa6XkXV9pK52QP`
- **Model:** `eleven_multilingual_v2`
- **Stability:** 0.9
- **Similarity Boost:** 0.5
- **Style:** 0.3
- **Output Format:** `mp3_44100_128`

---

## 在 Claude Code 里使用

### 中文示例
```
使用 ElevenLabs 生成语音：
- Voice ID: qlnUbSLa6XkXV9pK52QP
- Model: eleven_multilingual_v2
- Stability: 0.9
- Similarity Boost: 0.5
- Style: 0.3
- Output Format: mp3_44100_128

文本："你好，这是一个测试，看看这个声音是否自然"
```

### 英文示例
```
Use ElevenLabs to generate speech:
- Voice ID: qlnUbSLa6XkXV9pK52QP
- Model: eleven_multilingual_v2
- Stability: 0.9
- Similarity Boost: 0.5
- Style: 0.3
- Output Format: mp3_44100_128

Text: "Hello! My name is Shanny, and I love telling stories to kids. 
Once upon a time, in a land far away, there lived a friendly dragon 
who loved to make people smile."
```

---

## 调音技巧

- **声音太平淡** → 把 Stability 调低（如 0.5），Style 调高
- **声音不稳定** → 把 Stability 调高（如 0.9）
- **Style 不要超过 0.5** → 容易出现不稳定

---

## 输出文件

默认保存到桌面 `~/Desktop`，可以通过环境变量修改路径：
```bash
"ELEVENLABS_MCP_BASE_PATH": "/Users/你的用户名/Documents/audio"
```

---

## 找更多声音

去 [elevenlabs.io/voice-library](https://elevenlabs.io/voice-library) 搜索想要的声音风格，复制 Voice ID 即可使用。

## 常见问题

### API Key 权限不足（401错误）
去 ElevenLabs → API Keys → 编辑，确保勾选：
- ✅ Voices (Read)
- ✅ Text to Speech

### MCP 已存在，更新 API Key
```bash
claude mcp remove "ElevenLabs" && claude mcp add-json "ElevenLabs" '{"command":"uvx","args":["elevenlabs-mcp"],"env":{"ELEVENLABS_API_KEY":"新的API_KEY"}}'
```

### 恢复上次对话
```bash
claude -c
```
