-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Global Settings (ตั้งค่าล็อกไวที่สุดตั้งแต่เริ่ม)
local Settings = {
    AimbotEnabled = false,
    ESPEnabled = false,
    InfiniteStamina = false,
    FOV = 120, -- เพิ่มขนาดวงกลม FOV ให้กว้างขึ้นเล็กน้อยเพื่อตรวจจับเป้าหมายได้ไวขึ้น
    Smoothness = 1, -- ค่า 1 คือเร็วที่สุด (Instant Lock)
    WalkSpeed = 20,
    Collapsed = false
}

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KHAN_GUI_MAX_SPEED"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-------------------------------------------------------------------------------
-- VISUAL FOV CIRCLE
-------------------------------------------------------------------------------
local FOVOuter = Instance.new("Frame")
FOVOuter.Name = "FOVCircle"
FOVOuter.AnchorPoint = Vector2.new(0.5, 0.5)
FOVOuter.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVOuter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FOVOuter.BackgroundTransparency = 1
FOVOuter.Visible = false
FOVOuter.Parent = ScreenGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(255, 0, 0)
FOVStroke.Thickness = 1.5
FOVStroke.Parent = FOVOuter

-------------------------------------------------------------------------------
-- MAIN GUI WINDOW
-------------------------------------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 430)
MainFrame.Position = UDim2.new(0.65, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "KHAN NONT IDIN DUN"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinButton = Instance.new("TextButton", Header)
MinButton.Size = UDim2.new(0, 40, 1, 0)
MinButton.Position = UDim2.new(1, -40, 0, 0)
MinButton.BackgroundTransparency = 1
MinButton.Text = "-"
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 16

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, 0, 1, -40)
Container.Position = UDim2.new(0, 0, 0, 40)
Container.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", Container)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 8)

MinButton.MouseButton1Click:Connect(function()
    Settings.Collapsed = not Settings.Collapsed
    local targetSize = Settings.Collapsed and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 430)
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
    MinButton.Text = Settings.Collapsed and "+" or "-"
    Container.Visible = not Settings.Collapsed
end)

-------------------------------------------------------------------------------
-- UI CREATION FUNCTIONS
-------------------------------------------------------------------------------
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
    
    btn.Activated:Connect(callback)
    return btn
end

local function CreateSlider(text, min, max, default, order, callback)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(0, 220, 0, 42)
    Frame.BackgroundTransparency = 1
    Frame.LayoutOrder = order

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 16)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Track = o = Instance.new("Frame", Frame)
    Track.Size = UDim2.new(1, 0, 0, 6)
    Track.Position = UDim2.new(0, 0, 0, 22)
    Track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Track.BorderSizePixel = 0
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)
    
    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    Fill.BorderSizePixel = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Trigger = Instance.new("TextButton", Track)
    Trigger.Size = UDim2.new(1, 0, 1, 0)
    Trigger.BackgroundTransparency = 1
    Trigger.Text = ""

    local isDragging = false

    local function updateSliderPosition(inputPosition)
        local trackPosition = Track.AbsolutePosition.X
        local trackSize = Track.AbsoluteSize.X
        local percentage = math.clamp((inputPosition.X - trackPosition) / trackSize, 0, 1)
        
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        local val = math.round(min + (percentage * (max - min)))
        Label.Text = text .. ": " .. val
        callback(val)
    end

    Trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            updateSliderPosition(input.Position)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSliderPosition(input.Position)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
end

-------------------------------------------------------------------------------
-- GENERATE CONTROLS
-------------------------------------------------------------------------------
local AimBtn = CreateButton("Aimbot: OFF", 1, function()
    Settings.AimbotEnabled = not Settings.AimbotEnabled
    AimBtn.Text = Settings.AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    AimBtn.BackgroundColor3 = Settings.AimbotEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(45, 45, 45)
end)

local EspBtn = CreateButton("3D Player ESP: OFF", 2, function()
    Settings.ESPEnabled = not Settings.ESPEnabled
    EspBtn.Text = Settings.ESPEnabled and "3D Player ESP: ON" or "3D Player ESP: OFF"
    EspBtn.BackgroundColor3 = Settings.ESPEnabled and Color3.fromRGB(50, 50, 180) or Color3.fromRGB(45, 45, 45)
end)

local StaminaBtn = CreateButton("Infinite Stamina: OFF", 3, function()
    Settings.InfiniteStamina = not Settings.InfiniteStamina
    StaminaBtn.Text = Settings.InfiniteStamina and "Infinite Stamina: ON" or "Infinite Stamina: OFF"
    StaminaBtn.BackgroundColor3 = Settings.InfiniteStamina and Color3.fromRGB(180, 50, 50) or Color3.fromRGB(45, 45, 45)
end)

local IYBtn = CreateButton("⚡ Open Infinite Yield", 4, function()
    IYBtn.Text = "Loading IY..."
    IYBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source', true))()
        end)
        if success then
            IYBtn.Text = "⚡ Infinite Yield: Loaded"
            IYBtn.BackgroundColor3 = Color3.fromRGB(230, 150, 0)
        else
            IYBtn.Text = "❌ Load Failed (Retry)"
            IYBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        end
    end)
end)

CreateSlider("FOV Radius", 10, 300, Settings.FOV, 5, function(v) Settings.FOV = v end)
CreateSlider("Lock Speed (1=Fast)", 1, 10, Settings.Smoothness, 6, function(v) Settings.Smoothness = v end)
CreateSlider("WalkSpeed", 20, 24, Settings.WalkSpeed, 7, function(v) Settings.WalkSpeed = v end)

-------------------------------------------------------------------------------
-- CORE LOGIC (ปรับแต่งเพิ่มระดับการประมวลผลให้ดึงเป้าเร็วขึ้นแบบ Instant Lock)
-------------------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    if char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = Settings.WalkSpeed
    end

    if Settings.InfiniteStamina then
        local staminaVal = char:FindFirstChild("Stamina", true)
        if staminaVal and staminaVal:IsA("ValueBase") then
            staminaVal.Value = 100
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local targetChar = p.Character
            local highlight = targetChar:FindFirstChild("ESPHighlight")
            if Settings.ESPEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.FillTransparency = 0.6
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Adornee = targetChar
                    highlight.Parent = targetChar
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end

    -- ปรับปรุงอัลกอริทึมการคำนวณตำแหน่งเป้าหมายให้ประมวลผลทันทีในเฟรมปัจจุบัน (Zero Lag)
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if Settings.AimbotEnabled then
        FOVOuter.Size = UDim2.new(0, Settings.FOV * 2, 0, Settings.FOV * 2)
        FOVOuter.Visible = true

        local closest = nil
        local shortestDist = Settings.FOV
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
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
        end
        
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            local targetPosition = closest.Character.Head.Position
            local cameraPosition = Camera.CFrame.Position
            
            -- บังคับคัปปลิ้งทิศทางกล้องตรงเข้าหาพิกัดหัวโดยไม่หน่วงเฟรมเรต
            local lookAtCFrame = CFrame.new(cameraPosition, targetPosition)
            
            if Settings.Smoothness <= 1 then
                -- รันแบบความเร็วสูงสุด (Instant-Lock 0ms) ล็อกติดเป้าทันทีที่เข้าใกล้
                Camera.CFrame = lookAtCFrame
                
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local lookVector = (targetPosition - rootPart.Position).Unit
                    rootPart.CFrame = CFrame.new(rootPart.Position, Vector3.new(lookVector.X, 0, lookVector.Z))
                end
            else
                -- รันแบบเกาะติดชดเชยตามระยะสไลเดอร์
                local lockAmount = 1 / Settings.Smoothness
                Camera.CFrame = Camera.CFrame:Lerp(lookAtCFrame, lockAmount)
            end
        end
    else
        FOVOuter.Visible = false
    end
end)

