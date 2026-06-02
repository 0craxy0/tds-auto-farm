local TDS_API = loadstring(game:HttpGet("https://raw.githubusercontent.com/0craxy0/tds-auto-farm/refs/heads/main/api.lua"))()

TDS_API:SetDifficulty("Insane")
TDS_API.Config.RoundSkip = true
TDS_API.Config.SoloPlay = true
TDS_API.Config.AutoChat = true

TDS_API:StartAutoFarm()
