local TDS_API = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
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
return TDS_API
