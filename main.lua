-- MM2 Cyber-Troll God - FĂRĂ CHAT, FUNCȚII NOI & OPRIRE INSTANT
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Curățare GUI vechi
if game.CoreGui:FindFirstChild("MM2_TrollGod") then game.CoreGui.MM2_TrollGod:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_TrollGod"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Fereastra Principală
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 460, 0, 310)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(255, 165, 0) -- Neon Amber

-- Sidebar și Pagini
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -145, 1, -20)
Container.Position = UDim2.new(0, 140, 0, 10)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local Layout = Instance.new("UIPageLayout", Container)
Layout.TweenTime = 0.3
Layout.ScrollWheelInput = false

local function CreatePage()
    local Page = Instance.new("ScrollingFrame", Container)
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 450)
    Page.ScrollBarThickness = 2
    local L = Instance.new("UIListLayout", Page)
    L.Padding = UDim.new(0, 8)
    return Page
end

local PageMovement = CreatePage()
local PageExploits = CreatePage()

local function AddTab(name, posY, page)
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(1, -16, 0, 36)
    B.Position = UDim2.new(0, 8, 0, posY)
    B.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    B.Text = name
    B.TextColor3 = Color3.fromRGB(230, 230, 230)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 11
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    B.MouseButton1Click:Connect(function() Layout:JumpTo(page) end)
end

AddTab("🚀 Abilități", 50, PageMovement)
AddTab("👾 Map Troll", 95, PageExploits)

-- Configurații Stări
_G.Fly_State = false
_G.Xray_State = false
_G.Invis_State = false
local flySpeed = 45

-- Implementare Butoane Toggle
local function AddOption(page, name, callback)
    local F = Instance.new("Frame", page)
    F.Size = UDim2.new(1, -5, 0, 45)
    F.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(0.7, 0, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = name
    L.TextColor3 = Color3.fromRGB(240, 240, 240)
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    
    local S = Instance.new("TextButton", F)
    S.Size = UDim2.new(0, 42, 0, 20)
    S.Position = UDim2.new(1, -52, 0.5, -10)
    S.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    S.Text = ""
    Instance.new("UICorner", S).CornerRadius = UDim.new(0, 10)
    
    local D = Instance.new("Frame", S)
    D.Size = UDim2.new(0, 14, 0, 14)
    D.Position = UDim2.new(0, 3, 0.5, -7)
    D.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", D).CornerRadius = UDim.new(0, 7)
    
    local activated = false
    S.MouseButton1Click:Connect(function()
        activated = not activated
        D.Position = activated and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        S.BackgroundColor3 = activated and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(50, 50, 60)
        callback(activated)
    end)
end

-- Funcție separată pentru butoane de execuție instantă
local function AddActionClick(page, name, callback)
    local B = Instance.new("TextButton", page)
    B.Size = UDim2.new(1, -5, 0, 40)
    B.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    B.Text = name
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 12
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    B.MouseButton1Click:Connect(callback)
end

-- LOGICA SISTEMELOR NOI (Fly & Xray Mechanics)
local bodyVelocity, bodyGyro
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        -- Sistem de Zbor Adaptat pe Mobil (Folosește camera pentru direcție)
        if _G.Fly_State then
            char.Humanoid.PlatformStand = true
            if not bodyVelocity then
                bodyVelocity = Instance.new("BodyVelocity", char.HumanoidRootPart)
                bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bodyGyro = Instance.new("BodyGyro", char.HumanoidRootPart)
                bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            end
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            local moveDir = char.Humanoid.MoveDirection
            bodyVelocity.Velocity = moveDir * flySpeed + (UserInputService:IsKeyDown(Enum.KeyCode.Space) and Vector3.new(0, flySpeed, 0) or Vector3.new(0, 0, 0))
        else
            if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
            if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
            char.Humanoid.PlatformStand = false
        end
        
        -- Glitch invizibilitate parțială
        if _G.Invis_State then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0.7
                end
            end
        end
    end
end)

-- LOGICĂ X-RAY (Transparență pereți mapă)
local originalTransparencies = {}
local function SetXray(enable)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(Players) and not obj.Parent:FindFirstChild("Humanoid") then
            if enable then
                if not originalTransparencies[obj] then originalTransparencies[obj] = obj.Transparency end
                if obj.Name ~= "Terrain" then obj.Transparency = 0.65 end
            else
                if originalTransparencies[obj] then
                    obj.Transparency = originalTransparencies[obj]
                end
            end
        end
    end
    if not enable then originalTransparencies = {} end
end

-- POPULARE TABURI
AddOption(PageMovement, "Activează Zbor (Fly Hack)", function(v) _G.Fly_State = v end)
AddOption(PageMovement, "Glitch Invizibilitate Corp", function(v) 
    _G.Invis_State = v 
    if not v and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.Transparency = 0 end
        end
    end
end)

AddOption(PageExploits, "X-Ray Vision (Pereți Sticlă)", function(v) SetXray(v) end)
AddActionClick(PageExploits, "📍 Teleportare în Lobby (Salvare)", function()
    local lobby = workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("LobbyZone")
    if lobby and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = lobby:GetModelCFrame()
    else
        -- Teleportare de siguranță la coordonatele de spawn ale hărții principale
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end
end)

-- Buton Minimizar Mini-Circle
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 44, 0, 44)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
ToggleBtn.Text = "🛠️"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 165, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 22)
local tS = Instance.new("UIStroke", ToggleBtn)
tS.Thickness = 1.5
tS.Color = Color3.fromRGB(255, 165, 0)

local open = true
ToggleBtn.MouseButton1Click:Connect(function()
    open = not open
    MainFrame.Visible = open
end)
