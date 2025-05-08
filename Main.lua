-- Dead Rails Script Hub v1.0
-- Функции: Аимбот, Автосбор, Телепорт, ESP

local Settings = {
    AimBot = {
        Enabled = true,
        FOV = 30,
        Smoothing = 0.2,
        Key = "RightAlt",
        TeamCheck = true
    },
    AutoLoot = {
        Enabled = true,
        Range = 50,
        Delay = 0.5
    },
    Teleport = {
        Enabled = true,
        Key = "F5"
    },
    ESP = {
        Enabled = false,
        Boxes = true,
        Names = true,
        Health = true
    }
}

-- UI библиотека (пример)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Dead Rails Script", "DarkTheme")

-- Основные табы
local AimTab = Window:NewTab("Аимбот")
local LootTab = Window:NewTab("Автосбор")
local TeleportTab = Window:NewTab("Телепорт")
local PlayerTab = Window:NewTab("Игрок")
local ESPTab = Window:NewTab("ESP")

-- Аимбот секция
local AimSection = AimTab:NewSection("Настройки аимбота")
AimSection:NewToggle("Включить аимбот", "Автонаведение на врагов", function(state)
    Settings.AimBot.Enabled = state
end)

AimSection:NewSlider("FOV", "Угол захвата", 180, 5, function(value)
    Settings.AimBot.FOV = value
end)

-- Автосбор секция
local LootSection = LootTab:NewSection("Настройки автосбора")
LootSection:NewToggle("Включить автосбор", "Автоматически собирает лут", function(state)
    Settings.AutoLoot.Enabled = state
end)

-- Телепорт секция
local TeleportSection = TeleportTab:NewSection("Телепорт")
TeleportSection:NewKeybind("Клавиша телепорта", "Наведите курсор и нажмите", Enum.KeyCode.F5, function()
    if Settings.Teleport.Enabled then
        TeleportToCursor()
    end
end)

-- Игрок секция
local PlayerSection = PlayerTab:NewSection("Настройки игрока")
PlayerSection:NewSlider("Скорость", "Увеличивает скорость передвижения", 100, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- Функция аимбота
function AimBot()
    if not Settings.AimBot.Enabled then return end
    
    local closestPlayer, closestDistance = nil, math.huge
    local localPlayer = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if Settings.AimBot.TeamCheck and player.Team == localPlayer.Team then continue end
            
            local screenPoint =
