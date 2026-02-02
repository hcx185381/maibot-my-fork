"""
测试硅基流动API连接
"""
import requests
import json
import sys
import io

# 设置输出编码为UTF-8
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

# 硅基流动API配置
API_KEY = "sk-idjdrtdithcxuozmairymdebbovithfcidkvnavnchwnxavh"
BASE_URL = "https://api.siliconflow.cn/v1"

# 测试模型列表
test_models = [
    {
        "name": "DeepSeek-R1-Distill-Qwen-8B (免费)",
        "model": "Pro/deepseek-ai/DeepSeek-R1-Distill-Qwen-8B",
        "test_prompt": "你好，请用一句话介绍你自己"
    },
    {
        "name": "DeepSeek-V3 (付费)",
        "model": "deepseek-ai/DeepSeek-V3",
        "test_prompt": "1+1等于几？"
    },
    {
        "name": "PaddleOCR-VL (视觉免费)",
        "model": "PaddlePaddle/PaddleOCR-VL",
        "test_prompt": "你好"
    }
]

def test_model(model_info):
    """测试单个模型"""
    print(f"\n{'='*60}")
    print(f"测试模型: {model_info['name']}")
    print(f"{'='*60}")

    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    }

    # 简单文本测试（所有模型都支持）
    data = {
        "model": model_info["model"],
        "messages": [
            {"role": "user", "content": model_info["test_prompt"]}
        ],
        "max_tokens": 100,
        "stream": False
    }

    try:
        print(f"发送测试请求...")
        response = requests.post(
            f"{BASE_URL}/chat/completions",
            headers=headers,
            json=data,
            timeout=30
        )

        if response.status_code == 200:
            result = response.json()
            content = result["choices"][0]["message"]["content"]
            usage = result.get("usage", {})

            print(f"✅ 成功！")
            print(f"回复: {content}")
            print(f"Token使用: 输入={usage.get('prompt_tokens', 0)}, 输出={usage.get('completion_tokens', 0)}")
            return True
        else:
            print(f"❌ 失败！HTTP {response.status_code}")
            print(f"错误信息: {response.text}")
            return False

    except Exception as e:
        print(f"❌ 异常！{str(e)}")
        return False

def main():
    print("="*60)
    print("硅基流动 API 测试工具")
    print("="*60)

    success_count = 0
    total_count = len(test_models)

    for model_info in test_models:
        if test_model(model_info):
            success_count += 1

    print(f"\n{'='*60}")
    print(f"测试总结: {success_count}/{total_count} 个模型测试通过")
    print(f"{'='*60}")

    if success_count == total_count:
        print("🎉 所有模型测试通过！API配置正常！")
    elif success_count > 0:
        print(f"⚠️  部分模型可用，请检查失败的模型")
    else:
        print("❌ 所有模型测试失败，请检查API Key和网络连接")

if __name__ == "__main__":
    main()
