-- BLOX SPIN ULTIMATE BYPASS (ALL-IN-ONE)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- สร้าง GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 300)
Main.Position = UDim2.new(0.05, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, #Main:GetChildren() * 40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Settings
local S = {Aimbot = false, ESP = false, Magnet = false, Stamina = false}

CreateButton("Aimbot: OFF", function(b) S.Aimbot = not S.Aimbot b.Text = S.Aimbot and "Aimbot: ON" or "Aimbot: OFF" end)
CreateButton("ESP: OFF", function(b) S.ESP = not S.ESP b.Text = S.ESP and "ESP: ON" or "ESP: OFF" end)
CreateButton("Magnet: OFF", function(b) S.Magnet = not S.Magnet b.Text = S.Magnet and "Magnet: ON" or "Magnet: OFF" end)
CreateButton("Inf Stamina: OFF", function(b) 
    S.Stamina = not S.Stamina 
    b.Text = S.Stamina and "Inf Stamina: ON" or "Inf Stamina: OFF"
end)

-- โครงสร้างระบบเจาะข้าม Stamina สำหรับ Blox Spin 
task.spawn(function()
    while task.wait(0.1) do
        if S.Stamina and LocalPlayer.Character then
            -- แฮกเข้าตัวแปรใน LocalScript ของเกม (ดึงค่าทุกอย่างที่สคริปต์สปินและสคริปต์วิ่งเรียกใช้)
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" then
                    -- ดักจับตารางตัวแปรที่เก็บค่าสตามิน่าในตัวเกม Blox Spin
                    if rawget(v, "Stamina") or rawget(v, "stamina") or rawget(v, "Energy") then
                        v.Stamina = 100
                        v.stamina = 100
                        v.Energy = 100
                        if v.MaxStamina then v.Stamina = v.MaxStamina end
                    end
                    -- ดักจับระบบลดสตามิน่าจากการกดแดช (Dash) หรือใช้ท่าสปิน
                    if rawget(v, "DashCost") or rawget(v, "StaminaCost") then
                        v.DashCost = 0
                        v.StaminaCost = 0
                        v.UseStamina = false
                    end
                end
            end
            
            -- วิธีสำรอง: ล็อกค่าอนิเมชั่นเหนื่อย/ค่าหลอด Stamina บนหน้าจอไม่ให้ลดลง
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, descendant in pairs(playerGui:GetDescendants()) do
                    if descendant:IsA("NumberValue") or descendant:IsA("IntValue") then
                        if descendant.Name:lower():find("stamina") or descendant.Name:lower():find("energy") then
                            descendant.Value = 100
                        end
                    end
                end
            end
        end
    end
end)

-- Loop หลักสำหรับฟังก์ชันอื่นๆ
RunService.RenderStepped:Connect(function()
    -- 1. Aimbot (Lock Camera)
    if S.Aimbot then
        local target = nil local d = 999
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local dist = (Vector2.new(pos.X, pos.Y) - Camera.ViewportSize/2).Magnitude
                    if dist < d then target = p.Character.Head d = dist end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end

    -- 2. ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local hi = p.Character:FindFirstChild("ESP_Highlight")
            if S.ESP and not hi then
                local h = Instance.new("Highlight", p.Character) h.Name = "ESP_Highlight" h.FillColor = Color3.new(1,0,0)
            elseif not S.ESP and hi then hi:Destroy() end
        end
    end

    -- 3. Magnet
    if S.Magnet then
        for _, item in pairs(Workspace:GetDescendants()) do
            if item:IsA("BasePart") and (item.Name:lower():find("fruit") or item.Name:lower():find("drop") or item.Name:lower():find("item")) then
                item.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)
