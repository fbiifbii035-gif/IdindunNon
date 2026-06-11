-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Global Settings
local Settings = {
    AimbotEnabled = false,
    ESPEnabled = false,
    InfiniteStamina = false,
    FOV = 120,
    Smoothness = 1,
    WalkSpeed = 20,
    Collapsed = false
}

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KHAN_GUI_FIXED"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- สร้างหน้าต่าง GUI (โครงสร้างเดิมที่ใช้งานได้ดี)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 430)
MainFrame.Position = UDim2.new(0.65, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, 0, 1, -40)
Container.Position = UDim2.new(0, 0, 0, 40)
Container.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", Container)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Padding = UDim.new(0, 8)

-- ระบบปุ่มที่แก้ไขให้สถานะ ON/OFF ตรงกับค่าจริงเสมอ
local function CreateButton(text, order, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(0, 220, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.LayoutOrder = order
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.Activated:Connect(function()
        callback(btn)
    end)
    return btn
end

-- สร้างปุ่ม Aimbot พร้อมระบบอัปเดตสถานะแบบ Real-time
local AimBtn = CreateButton("Aimbot: OFF", 1, function(btn)
    Settings.AimbotEnabled = not Settings.AimbotEnabled
    btn.Text = Settings.AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    btn.BackgroundColor3 = Settings.AimbotEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(45, 45, 45)
end)

-- โค้ดส่วนที่เหลือ (ESP/Stamina/Logic) ให้คงไว้เหมือนเดิม...
-- (ใส่โค้ดส่วน ESP, Stamina, FOV Logic ต่อท้ายตรงนี้ได้เลย)

-- ส่วน RunService เพื่อให้ Aimbot ทำงาน
RunService.RenderStepped:Connect(function()
    if not Settings.AimbotEnabled then return end
    
    -- โค้ดคำนวณเป้าหมายล็อกหัว (Instant Lock) ตามที่ต้องการ
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closest = nil
    local shortestDist = Settings.FOV
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = p
                end
            end
        end
    end
    
    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position)
    end
end)
