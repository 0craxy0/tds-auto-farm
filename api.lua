local TDS_API = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

TDS_API.Config = {
    Mode = 1,
    Difficulty = "Insane",
    RoundSkip = true,
    SoloPlay = true,
    AutoChat = true,
    AutoWalk = true,
    HumanDelayMin = 0.7,
    HumanDelayMax = 2.4,
    MovementJitter = true,
    RandomCamera = true,
    AutoRejoin = true
}

local isFarming = false
local messageQueue = {
    "farming xp rn", "this is taking forever lol", 
    "anyone got tips?", "brb", "insane mode is wild",
    "ggs", "just chilling"
}

function TDS_API:Init()
    math.randomseed(tick())
    self:ApplyAntiDetect()
end

function TDS_API:ApplyAntiDetect()
    if self.Config.MovementJitter then
        task.spawn(function()
            while task.wait(math.random(12, 28)) do
                if Character and Character:FindFirstChild("HumanoidRootPart") then
                    local root = Character.HumanoidRootPart
                    root.CFrame = root.CFrame * CFrame.new(math.random(-3,3)/2, 0, math.random(-3,3)/2)
                end
            end
        end)
    end

    if self.Config.RandomCamera then
        task.spawn(function()
            while task.wait(math.random(7, 19)) do
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(math.random(-250,250), math.random(-180,180)))
            end
        end)
    end

    if self.Config.AutoRejoin then
        LocalPlayer.OnTeleport:Connect(function()
            task.wait(3)
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end
end

function TDS_API:SetMode(mode) self.Config.Mode = mode end
function TDS_API:SetDifficulty(diff) self.Config.Difficulty = diff end

function TDS_API:StartAutoFarm()
    if isFarming then return end
    isFarming = true
    
    task.spawn(function()
        while isFarming do
            if self.Config.SoloPlay and #Players:GetPlayers() > 1 then
                TeleportService:Teleport(game.PlaceId)
                task.wait(5)
            end
            
            if self.Config.AutoChat then
                task.spawn(function()
                    while isFarming do
                        local msg = messageQueue[math.random(1, #messageQueue)]
                        ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(msg, "All")
                        task.wait(math.random(13, 22))
                    end
                end)
            end
            
            if self.Config.RoundSkip then
                task.wait(math.random(8, 15))
            end
            
            task.wait(math.random(self.Config.HumanDelayMin * 10, self.Config.HumanDelayMax * 10) / 10)
        end
    end)
end

function TDS_API:StopAutoFarm()
    isFarming = false
end

function TDS_API:PlaceTower(towerName, position)
    local towerRemote = ReplicatedStorage:FindFirstChild("PlaceTower", true) or ReplicatedStorage:FindFirstChild("Events", true)
    if towerRemote then
        towerRemote:FireServer(towerName, position)
    end
end

function TDS_API:UpgradeTower(towerId)
end

TDS_API:Init()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TDSAutoFarmUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Title.Text = "TDS AutoFarm UI"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Parent = MainFrame

local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0.9, 0, 0, 40)
StartBtn.Position = UDim2.new(0.05, 0, 0, 70)
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
StartBtn.Text = "Start AutoFarm"
StartBtn.TextColor3 = Color3.new(1,1,1)
StartBtn.TextScaled = true
StartBtn.Parent = MainFrame
StartBtn.MouseButton1Click:Connect(function()
    TDS_API:StartAutoFarm()
end)

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0.9, 0, 0, 40)
StopBtn.Position = UDim2.new(0.05, 0, 0, 120)
StopBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
StopBtn.Text = "Stop AutoFarm"
StopBtn.TextColor3 = Color3.new(1,1,1)
StopBtn.TextScaled = true
StopBtn.Parent = MainFrame
StopBtn.MouseButton1Click:Connect(function()
    TDS_API:StopAutoFarm()
end)

local DifficultyLabel = Instance.new("TextLabel")
DifficultyLabel.Size = UDim2.new(0.9, 0, 0, 30)
DifficultyLabel.Position = UDim2.new(0.05, 0, 0, 180)
DifficultyLabel.BackgroundTransparency = 1
DifficultyLabel.Text = "Difficulty: Insane"
DifficultyLabel.TextColor3 = Color3.new(1,1,1)
DifficultyLabel.TextScaled = true
DifficultyLabel.Parent = MainFrame

local SoloToggle = Instance.new("TextButton")
SoloToggle.Size = UDim2.new(0.9, 0, 0, 40)
SoloToggle.Position = UDim2.new(0.05, 0, 0, 220)
SoloToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SoloToggle.Text = "Solo Play: ON"
SoloToggle.TextColor3 = Color3.new(1,1,1)
SoloToggle.TextScaled = true
SoloToggle.Parent = MainFrame
SoloToggle.MouseButton1Click:Connect(function()
    TDS_API.Config.SoloPlay = not TDS_API.Config.SoloPlay
    SoloToggle.Text = "Solo Play: " .. (TDS_API.Config.SoloPlay and "ON" or "OFF")
end)

local SkipToggle = Instance.new("TextButton")
SkipToggle.Size = UDim2.new(0.9, 0, 0, 40)
SkipToggle.Position = UDim2.new(0.05, 0, 0, 270)
SkipToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SkipToggle.Text = "Round Skip: ON"
SkipToggle.TextColor3 = Color3.new(1,1,1)
SkipToggle.TextScaled = true
SkipToggle.Parent = MainFrame
SkipToggle.MouseButton1Click:Connect(function()
    TDS_API.Config.RoundSkip = not TDS_API.Config.RoundSkip
    SkipToggle.Text = "Round Skip: " .. (TDS_API.Config.RoundSkip and "ON" or "OFF")
end)

local ChatToggle = Instance.new("TextButton")
ChatToggle.Size = UDim2.new(0.9, 0, 0, 40)
ChatToggle.Position = UDim2.new(0.05, 0, 0, 320)
ChatToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ChatToggle.Text = "Auto Chat: ON"
ChatToggle.TextColor3 = Color3.new(1,1,1)
ChatToggle.TextScaled = true
ChatToggle.Parent = MainFrame
ChatToggle.MouseButton1Click:Connect(function()
    TDS_API.Config.AutoChat = not TDS_API.Config.AutoChat
    ChatToggle.Text = "Auto Chat: " .. (TDS_API.Config.AutoChat and "ON" or "OFF")
end)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0.9, 0, 0, 30)
Status.Position = UDim2.new(0.05, 0, 0, 370)
Status.BackgroundTransparency = 1
Status.Text = "Status: Ready"
Status.TextColor3 = Color3.fromRGB(0, 255, 0)
Status.TextScaled = true
Status.Parent = MainFrame

print("TDS Full UI Loaded - Execute and control from screen")
