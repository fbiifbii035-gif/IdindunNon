-- SLEEPYHUB.EZ ALL-IN-ONE (WALKSPEED & MOTION FIX)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Config = {
    InfiniteStamina = false, AntiRagdoll = false, NoSlowdown = false, FlyJump = false,
    SpeedBoost = false, SpeedValue = 28, GodmodeInvisible = false, ClaimQuests = false,
    AntiStomp = false, AntiAim = false, ItemAura = false, SkipSpin = false, Aimbot = false, ESP = false,
    FOVSize = 100
}

-- [GUI Setup]
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "SleepyHub_SpeedFix_v6"
ScreenGui.ResetOnSpawn = false

-- วงกลม FOV สีแดงแท้ของ Aimbot
local FOVCircle = Instance.new("Frame", ScreenGui)
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
FOVCircle.BackgroundTransparency = 0.92
FOVCircle.Visible = false
local UICorner = Instance.new("UICorner", FOVCircle)
UICorner.CornerRadius = UDim.new(1, 0)
local UIStroke = Instance.new("UIStroke", FOVCircle)
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Thickness = 1.5

-- หน้าต่างเมนูหลัก
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
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 450)
ContentFrame.ScrollBarThickness = 2

local LeftColumn = Instance.new("Frame", ContentFrame)
LeftColumn.Size = UDim2.new(0.48, 0, 1, 0)
LeftColumn.BackgroundTransparency = 1
local RightColumn = Instance.new("Frame", ContentFrame)
RightColumn.Size = UDim2.new(0.48, 0, 1, 0)
RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
RightColumn.BackgroundTransparency = 1

Instance.new("UIListLayout", LeftColumn).Padding = UDim.new(0, 8)
Instance.new("UIListLayout", RightColumn).Padding = UDim.new(0, 8)

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

local function CreateSlider(parent, text, min, max, default, configKey)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, 0, 0, 15)
    lbl.Text = text .. "  " .. default
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1

    local track = Instance.new("Frame", frame)
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 0, 22)
    track.BackgroundColor3 = Color3.fromRGB(40, 43, 54)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)

    local trigger = Instance.new("TextButton", track)
    trigger.Size = UDim2.new(1, 0, 1, 0)
    trigger.BackgroundTransparency = 1
    trigger.Text = ""

    local dragging = false
    trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local percentage = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(percentage, 0, 1, 0)
            local val = math.round(min + (percentage * (max - min)))
            lbl.Text = text .. "  " .. val
            Config[configKey] = val
        end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

-- สร้างปุ่มเมนู
CreateToggle(LeftColumn, "Infinite Stamina", "InfiniteStamina")
CreateToggle(LeftColumn, "Anti Ragdoll", "AntiRagdoll")
CreateToggle(LeftColumn, "No Slowdown", "NoSlowdown")
CreateToggle(LeftColumn, "Speed Boost", "SpeedBoost")
CreateToggle(LeftColumn, "Godmode + Ghost", "GodmodeInvisible")

CreateToggle(RightColumn, "Anti Stomp", "AntiStomp")
CreateToggle(RightColumn, "Item Aura (Near Magnet)", "ItemAura")
CreateToggle(RightColumn, "Aimbot", "Aimbot")
CreateToggle(RightColumn, "Players ESP", "ESP")
CreateSlider(RightColumn, "Aimbot FOV Radius", 30, 250, Config.FOVSize, "FOVSize")

-- ปุ่มไอคอนย่อหน้าจอรูปตัว M ดาร์กโหมด
local IconButton = Instance.new("TextButton", ScreenGui)
IconButton.Size = UDim2.new(0, 42, 0, 42)
IconButton.Position = UDim2.new(0.1, 0, 0.05, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(15, 16, 21)
IconButton.Text = ""
IconButton.Active = true
IconButton.Draggable = true 
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(0, 8)

local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(30, 32, 40)
IconStroke.Thickness = 1

local LogoM = Instance.new("TextLabel", IconButton)
LogoM.Size = UDim2.new(1, 0, 1, 0)
LogoM.BackgroundTransparency = 1
LogoM.Text = "M"
LogoM.Font = Enum.Font.GothamBold
LogoM.TextSize = 18
LogoM.TextColor3 = Color3.fromRGB(0, 162, 255)

local DiamondGlow = Instance.new("Frame", IconButton)
DiamondGlow.Size = UDim2.new(0, 24, 0, 24)
DiamondGlow.Position = UDim2.new(0.5, -12, 0.5, -12)
DiamondGlow.BackgroundTransparency = 1
DiamondGlow.Rotation = 45
local DiamondStroke = Instance.new("UIStroke", DiamondGlow)
DiamondStroke.Color = Color3.fromRGB(150, 150, 150)
DiamondStroke.Thickness = 0.8

IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- ==========================================================
--        ระบบ Bypass และควบคุมค่าสถานะ (METATABLE & ENVIRONMENT)
-- ==========================================================
local RawMetatable = getrawmetatable(game)
local OldIndex = RawMetatable.__index
local OldNewIndex = RawMetatable.__newindex
setreadonly(RawMetatable, false)

RawMetatable.__index = newcclosure(function(self, key)
    if not checkcaller() then
        -- ล็อกค่าสตามิน่าในหน่วยความจำ
        if Config.InfiniteStamina and (key == "Stamina" or key == "Energy" or key == "stamina" or (key == "Value" and (self.Name == "Stamina" or self.Name == "Energy"))) then 
            return 100 
        end
        -- ดักจับสคริปต์เกมที่พยายามอ่านค่า WalkSpeed จริงเพื่อเตะผู้เล่น ให้มันเห็นเป็น 16 ตลอดเวลา
        if Config.SpeedBoost and self:IsA("Humanoid") and key == "WalkSpeed" then
            return 16
        end
    end
    return OldIndex(self, key)
end)

RawMetatable.__newindex = newcclosure(function(self, key, value)
    if not checkcaller() then
        if Config.InfiniteStamina and (key == "Stamina" or key == "Energy" or key == "stamina" or (key == "Value" and (self.Name == "Stamina" or self.Name == "Energy"))) then 
            return OldNewIndex(self, key, 100) 
        end
        -- บล็อกคำสั่งของสคริปต์เกมหลักที่พยายามลด WalkSpeed ของเราลงขณะเดิน
        if Config.SpeedBoost and self:IsA("Humanoid") and key == "WalkSpeed" then
            return OldNewIndex(self, key, Config.SpeedValue)
        end
    end
    return OldNewIndex(self, key, value)
end)
setreadonly(RawMetatable, true)

-- ลูปความเร็วสูงพิเศษระดับเสี้ยววินาทีเพื่อล็อกค่า Object ทั้งหมด
task.spawn(function()
    while task.wait() do
        pcall(function()
            if Config.InfiniteStamina then
                local targetObjects = {char = LocalPlayer.Character, player = LocalPlayer}
                for _, obj in pairs(targetObjects) do
                    if obj then
                        for _, v in pairs(obj:GetDescendants()) do
                            if v:IsA("NumberValue") or v:IsA("IntValue") then
                                if v.Name:lower() == "stamina" or v.Name:lower() == "energy" then v.Value = 100 end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ==========================================
--          ระบบการทำงานหลัก (CORE LOGIC)
-- ==========================================
local FakeBody = nil
local OriginalCFrame = nil

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
    local hum = char.Humanoid
    local root = char.HumanoidRootPart

    -- **แก้ไขบัค WalkSpeed: บังคับเขียนทับค่าความเร็วในระบบฟิสิกส์ทุกเฟรม ไม่ว่าจะกดเดินหรือวิ่ง**
    if Config.SpeedBoost then
        hum.WalkSpeed = Config.SpeedValue
        -- เสริมแรงส่งทิศทางสำหรับระบบที่ถูกจำกัดค่า WalkSpeed อัตโนมัติจากฝั่งเซิร์ฟเวอร์
        if hum.MoveDirection.Magnitude > 0 then
            root.Velocity = Vector3.new(hum.MoveDirection.X * Config.SpeedValue, root.Velocity.Y, hum.MoveDirection.Z * Config.SpeedValue)
        end
    end

    -- Ghost Mode ร่างทิพย์เห็นตัวเองปกติ
    if Config.GodmodeInvisible then
        if not FakeBody then
            OriginalCFrame = root.CFrame
            FakeBody = Instance.new("Part", Workspace)
            FakeBody.Size = Vector3.new(2, 5, 2)
            FakeBody.CFrame = OriginalCFrame
            FakeBody.Anchored = true
            FakeBody.Transparency = 0.7 
            FakeBody.Color = Color3.fromRGB(0, 162, 255)
            FakeBody.CanCollide = false
            
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("Decal") then
                    if v.Name ~= "HumanoidRootPart" then v.Transparency = 0 end 
                end
            end
        end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Velocity = Vector3.new(0, 0, 0)
            end
        end
    else
        if FakeBody then
            FakeBody:Destroy()
            FakeBody = nil
            root.CFrame = OriginalCFrame 
        end
    end

    -- Item Aura
    if Config.ItemAura then
        for _, item in pairs(Workspace:GetChildren()) do
            if item:IsA("BasePart") and (item.Name:lower():find("fruit") or item.Name:lower():find("drop") or item.Name:lower():find("item")) then
                if (item.Position - root.Position).Magnitude <= 50 then item.CFrame = root.CFrame + Vector3.new(0, 2, 0) end
            end
        end
    end

    -- Aimbot + วงกลม FOV
    if Config.Aimbot then
        FOVCircle.Size = UDim2.new(0, Config.FOVSize * 2, 0, Config.FOVSize * 2)
        FOVCircle.Visible = true
        local target = nil
        local shortest = Config.FOVSize
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local p_hum = p.Character:FindFirstChildOfClass("Humanoid")
                if p_hum and p_hum.Health > 0 then
                    local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if vis then
                        local dist = (Vector2.new(pos.X, pos.Y) - Camera.ViewportSize/2).Magnitude
                        if dist < shortest then shortest = dist target = p.Character.Head end
                    end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    else
        FOVCircle.Visible = false
    end

    -- Players ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local hi = p.Character:FindFirstChild("SleepyESP_Final")
            if Config.ESP and not hi then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "SleepyESP_Final"
                h.FillColor = Color3.fromRGB(0, 162, 255)
                h.FillTransparency = 0.5
            elseif not Config.ESP and hi then
                hi:Destroy()
            end
        end
    end
end)
