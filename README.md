# TG_HOT_GIT

> 以 Google Gemini 產生繁體中文摘要，並將 GitHub 熱門開源專案自動推播到 Telegram 的 Python Bot。

[![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![GitHub API](https://img.shields.io/badge/API-GitHub-181717?logo=github&logoColor=white)](https://docs.github.com/en/rest)
[![Telegram](https://img.shields.io/badge/通知-Telegram-26A5E4?logo=telegram&logoColor=white)](https://core.telegram.org/bots/api)

## 專案簡介

TG_HOT_GIT 會定期查詢 GitHub Search API，從 AI、前端與 Python 自動化三個主題找出熱門專案，再使用 Google Gemini 將英文描述整理成 50 字以內的繁體中文摘要，最後發送到指定的 Telegram 頻道或群組。

程式預設每 6 小時檢查一次，每個分類最多推播 1 個尚未發送的專案。已發送的 GitHub repository ID 會保存於 `seen_repo_ids.json`，避免重複通知。

## 功能特色

- **AI 摘要**：使用 Gemini 產生簡短、易讀的繁體中文重點。
- **主題分類**：支援 AI 工具、前端工具與 Python 自動化專案。
- **去重推播**：成功發送後才寫入已推播紀錄，避免失敗時遺失專案。
- **容錯設計**：Gemini 失敗時回退到 GitHub 原始描述，API 暫時失敗時會記錄錯誤並繼續執行。
- **可長時間運行**：包含輪詢、網路錯誤重試、每日輪替 Log 與雲端 Worker 部署方式。

## 技術架構

| 類別 | 技術 |
| --- | --- |
| Runtime | Python 3.10+ |
| Data source | GitHub Search API |
| AI | Google Gemini API (`google-genai`) |
| Notification | Telegram Bot API (`python-telegram-bot`) |
| HTTP client | `requests` |
| Configuration | `.env` / `python-dotenv` |
| Recommended deployment | Render Background Worker |

## 專案結構

```text
TG_HOT_GIT/
├── github_bot.py              # 主要 Bot 邏輯與背景輪詢
├── bot.py                     # 相容舊啟動方式的入口
├── seen_repo_ids.json         # 已推播 repository ID（不納入 Git）
├── clear_logs.bat             # Windows：清除 Bot Log
├── clear_seen_repos.bat       # Windows：重設已推播紀錄
├── Gitshowbot簡介.txt          # 專案簡介
└── 直接推播指令用法.txt        # 手動推播相關說明
```

## 快速開始

### 1. 建立虛擬環境

Windows PowerShell：

```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

若 PowerShell 阻擋啟用腳本，也可以直接使用虛擬環境內的 Python 執行後續指令。

### 2. 安裝依賴

```powershell
python -m pip install --upgrade pip
python -m pip install python-telegram-bot google-genai requests python-dotenv
```

### 3. 設定環境變數

在專案根目錄建立 `.env`：

```env
TELEGRAM_BOT_TOKEN=your_telegram_bot_token
TELEGRAM_CHAT_ID=your_telegram_chat_id
GEMINI_API_KEY=your_google_gemini_api_key
GITHUB_TOKEN=your_github_token
GEMINI_MODEL=gemini-3.6-flash
```

必要設定是 `TELEGRAM_BOT_TOKEN` 與 `TELEGRAM_CHAT_ID`。`GEMINI_API_KEY` 與 `GITHUB_TOKEN` 可選，但建議設定：前者提供更好的中文摘要，後者可提高 GitHub API 額度。`GEMINI_MODEL` 未設定時會使用程式預設模型。

### 4. 啟動 Bot

```powershell
python github_bot.py
```

也可以使用相容入口：

```powershell
python bot.py
```

啟動後，Bot 會持續執行並將 Log 寫入 `bot.log`。按 `Ctrl+C` 可停止程式。

## 部署至 Render

建立 **Background Worker**，設定如下：

| 設定 | 值 |
| --- | --- |
| Runtime | Python |
| Build Command | `pip install python-telegram-bot google-genai requests python-dotenv` |
| Start Command | `python github_bot.py` |

在 Render 的 Environment Variables 設定 `.env` 中的環境變數。請勿將任何 Token 或 API Key 寫入 Git，也不要把 `.env` 上傳到公開 repository。

## 維運工具

Windows 使用者可以執行以下腳本：

- `clear_logs.bat`：停止 Bot 後清除目前與輪替後的 Log。
- `clear_seen_repos.bat`：停止 Bot 後清空已推播紀錄；清空後，舊專案可能再次被推播。

## 常見問題

**Bot 啟動時提示缺少設定？**

確認 `.env` 位於 `github_bot.py` 同一個專案資料夾，且至少包含 `TELEGRAM_BOT_TOKEN` 與 `TELEGRAM_CHAT_ID`。

**為什麼沒有收到通知？**

確認 Bot 已被加入目標頻道或群組並具備發送訊息權限，接著查看 `bot.log`。也可能是專案已存在於 `seen_repo_ids.json`，或 GitHub API 暫時受到 Rate Limit 限制。

**Gemini 無法使用會停止 Bot 嗎？**

不會。若沒有設定 Gemini Key、摘要請求失敗或回應為空，程式會使用 GitHub 原始描述作為 fallback。

## 安全提醒

- 不要提交 `.env`、Bot Token、API Key 或私人聊天 ID。
- `GITHUB_TOKEN` 建議使用權限最小化的 Token；本專案只需要查詢公開 repository。
- 公開專案部署前，請確認 Log 不會輸出任何敏感憑證。

## License

目前未指定開源授權。若要公開提供他人使用，建議依需求補上 LICENSE 檔案。