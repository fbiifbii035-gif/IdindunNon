local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

local _G = _G or {}
_G.AutoFarmToggled = false 
_G.ESPToggled = false 
_G.AutoSkipDialogue = true 

local IsFleeingToSky = false
local LOW_HEALTH_PCT = 40 
local RECOVERY_HEALTH_PCT = 50 

local ExcludedKeys = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.E] = true
}

local SkillKeys = {}
for _, keyCode in pairs(Enum.KeyCode:GetEnumItems()) do
    if string.len(keyCode.Name) == 1 and string.match(keyCode.Name, "%a") then
        if not ExcludedKeys[keyCode] then
            table.insert(SkillKeys, keyCode)
        end
    end
end

-- GUI SYSTEM
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedHubX_Mobile"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local ToggleMenuButton = Instance.new("ImageButton")
ToggleMenuButton.Size = UDim2.new(0, 55, 0, 55)
ToggleMenuButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleMenuButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleMenuButton.Image = "rbxassetid://13217274040" 
ToggleMenuButton.Parent = ScreenGui
ToggleMenuButton.Draggable = true 

local RoundCorner = Instance.new("UICorner")
RoundCorner.CornerRadius = UDim.new(1, 0)
RoundCorner.Parent = ToggleMenuButton

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 260)
MainFrame.Position = UDim2.new(0.5, -140, 0.4, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Parent = ScreenGui
MainFrame.Draggable = true 

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(220, 20, 20)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 38)
TitleLabel.BackgroundColor3 = Color3.fromRGB(28, 8, 8)
TitleLabel.Text = "  ⚡ SPEED HUB X - MOBILE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local FarmButton = Instance.new("TextButton")
FarmButton.Size = UDim2.new(0, 240, 0, 40)
FarmButton.Position = UDim2.new(0.5, -120, 0, 52)
FarmButton.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
FarmButton.Text = "Auto Farm: OFF"
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.Font = Enum.Font.GothamBold
FarmButton.Parent = MainFrame

local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0, 240, 0, 40)
ESPButton.Position = UDim2.new(0.5, -120, 0, 102)
ESPButton.BackgroundColor3 = Color3.fromRGB(140, 25, 25)
ESPButton.Text = "Monster ESP: OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Font = Enum.Font.GothamBold
ESPButton.Parent = MainFrame

local SkipButton = Instance.new("TextButton")
SkipButton.Size = UDim2.new(0, 240, 0, 40)
SkipButton.Position = UDim2.new(0.5, -120, 0, 152)
SkipButton.BackgroundColor3 = Color3.fromRGB(25, 140, 25)
SkipButton.Text = "Force Touch Skip: ON"
SkipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SkipButton.Font = Enum.Font.GothamBold
SkipButton.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 1, -35)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Script Ready"
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- FORCE TOUCH SKIP SYSTEM
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoSkipDialogue then
            local pGui = player:FindFirstChild("PlayerGui")
            if pGui then
                local foundQuestion = false
                for _, obj in pairs(pGui:GetDescendants()) do
                    if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible then
                        if string.find(obj.Text, "ข้าม") or string.find(obj.Text:lower(), "skip") then
                            foundQuestion = true
                            break
                        end
                    end
                end
                if foundQuestion then
                    local cam = workspace.CurrentCamera
                    local screenSize = cam.ViewportSize
                    local clickX = screenSize.X * 0.43 
                    local clickY = screenSize.Y * 0.31 
                    VirtualInputManager:SendTouchEvent(1, Enum.UserInputState.Begin, Vector2.new(clickX, clickY))
                    task.wait(0.03)
                    VirtualInputManager:SendTouchEvent(1, Enum.UserInputState.End, Vector2.new(clickX, clickY))
                end
            end
        end
    end
end)

-- MONSTER ESP SYSTEM
local function createMonsterESP(monster)
    if monster:FindFirstChild("MonsterESP") then return end
    local bgui = Instance.new("BillboardGui")
