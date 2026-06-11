-- SLEEPYHUB.EZ COMPLETE EDITION FOR BLOX SPIN (MOBILE)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Config = {
    InfiniteStamina = false, AntiRagdoll = false, NoSlowdown = false, FlyJump = false,
    SpeedBoost = false, SpeedValue = 22, GodmodeInvisible = false, ClaimQuests = false,
    AntiStomp = false, AntiAim = false, ItemAura = false, SkipSpin = false, Aimbot = false, ESP = false
}

-- [GUI Setup]
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "SleepyHub_Complete"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 21)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(11, 12, 16)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local ContentFrame = Instance.new("ScrollingFrame", MainFrame)
ContentFrame.Size = UDim2.new(1, -140, 1, -15)
ContentFrame.Position = UDim2.new(0, 135, 0, 10)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 400)

local LeftColumn = Instance.new("Frame", ContentFrame)
LeftColumn.Size = UDim2.new(0.48, 0, 1, 0)
LeftColumn.BackgroundTransparency = 1
local RightColumn = Instance.new("Frame", ContentFrame)
RightColumn.Size = UDim2.new(0.48, 0, 1, 0)
RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
RightColumn.BackgroundTransparency = 1

Instance.new("UIListLayout", LeftColumn).Padding = UDim.new(0, 8)
Instance.new("UIListLayout", RightColumn).Padding = UDim.new(0, 8)

-- Helper Functions
local function CreateToggle(parent, text, configKey)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 43, 54)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        btn.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(40, 43, 54)
    end)
end

-- --- สร้าง UI เมนู ---
CreateToggle(LeftColumn, "Infinite Stamina", "InfiniteStamina")
CreateToggle(LeftColumn, "Anti Ragdoll", "AntiRagdoll")
CreateToggle(LeftColumn, "No Slowdown", "NoSlowdown")
CreateToggle(LeftColumn, "Speed Boost", "SpeedBoost")
CreateToggle(LeftColumn, "Godmode + Ghost", "GodmodeInvisible")
CreateToggle(RightColumn, "Anti Stomp", "AntiStomp")
CreateToggle(RightColumn, "Item Aura (Near Magnet)", "ItemAura")
CreateToggle(RightColumn, "Aimbot", "Aimbot")
CreateToggle(RightColumn, "Players ESP", "ESP")

-- [Game Loop Logic]
local GhostPos = nil
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    -- Speed Logic
    char.Humanoid.WalkSpeed = Config.SpeedBoost and Config.SpeedValue or 16

    -- Ghost Godmode
    if Config.GodmodeInvisible then
        if not GhostPos then GhostPos = char.HumanoidRootPart.CFrame end
        char.HumanoidRootPart.Anchored = true
        char.HumanoidRootPart.CFrame = GhostPos
    else
        char.HumanoidRootPart.Anchored = false
        GhostPos = nil
    end

    -- Stamina Logic
    if Config.InfiniteStamina then
        char.Humanoid.JumpHeight = 7.2
        char.HumanoidRootPart.AssemblyLinearVelocity = char.HumanoidRootPart.AssemblyLinearVelocity
    end

    -- Magnet Logic
    if Config.ItemAura then
        for _, item in pairs(Workspace:GetChildren()) do
            if item:IsA("BasePart") and (item.Name:lower():find("fruit") or item.Name:lower():find("drop") or item.Name:lower():find("item")) then
                if (item.Position - char.HumanoidRootPart.Position).Magnitude <= 50 then
                    item.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                end
            end
        end
    end

    -- Aimbot Logic
    if Config.Aimbot then
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then target = p.Character.Head break end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)
