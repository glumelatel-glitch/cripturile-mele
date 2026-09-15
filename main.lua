-- MM2 ULTRA-VISIBLE REPAIRED SCRIPT (NO BLACK SCREEN)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if game.CoreGui:FindFirstChild("MM2_TrollGodFixed") then 
    game.CoreGui.MM2_TrollGodFixed:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_TrollGodFixed"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Fereastra Principală cu Fundal Gri-Închis solid (să se vadă tot)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 440, 0, 280)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30) -- Fundal mai deschis pentru contrast
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 2.5
Stroke.Color = Color3.fromRGB(255, 140, 0) -- Margine Portocalie Neon

-- Container Conținut (Butoane)
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -20)
Container.Position = UDim2.new(0, 10, 0, 10)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 400)
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 8)
List.Parent = Container

-- Stări
_G.Fly_State = false
_G.Xray_State = false
_G.Invis_State = false
local flySpeed = 45

-- Funcție Butoane ULTRA VIZIBILE
local function AddOption(name, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -10, 0, 45)
    F.BackgroundColor3 = Color3.fromRGB(40, 40, 50) -- Fundal buton vizibil
    F.Parent = Container
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)
    
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(0.7, 0, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = name
    L.TextColor3 = Color3.fromRGB(255, 255, 255) -- Text Alb complet
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    L.Parent = F
    
    local S = Instance.new("TextButton")
    S.Size = UDim2.new(0, 70, 0, 26)
    S.Position = UDim2.new(1, -80, 0.5, -13)
    S.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Roșu implicit (Oprit)
    S.Text = "OPRIT"
    S.TextColor3 = Color3.fromRGB(255, 255, 255)
    S.Font = Enum.Font.GothamBold
    S.TextSize = 11
    S.Parent = F
    Instance.new("UICorner", S).CornerRadius = UDim.new(0, 6)
    
    local activated = false
    S.MouseButton1Click:Connect(function()
        activated = not activated
        if activated then
            S.BackgroundColor3 = Color3.fromRGB(50, 180, 50) -- Verde (Pornit)
            S.Text = "ACTIV"
        else
            S.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            S.Text = "OPRIT"
        end
        callback(activated)
    end)
end

-- Funcție Buton Click Simplu
local function AddActionClick(name, callback)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -10, 0, 40)
    B.BackgroundColor3 = Color3.fromRGB(255, 140, 0) -- Portocaliu
    B.Text = name
    B.TextColor3 = Color3.fromRGB(0, 0, 0) -- Text negru pentru contrast maxim
    B.Font = Enum.Font.GothamBold
    B.TextSize = 13
    B.Parent = Container
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    B.MouseButton1Click:Connect(callback)
end

-- LOGICA MODURILOR (Fly, Invisibility, Xray)
local bodyVelocity, bodyGyro
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        if _G.Fly_State then
            char.Humanoid.PlatformStand = true
            if not bodyVelocity then
                bodyVelocity = Instance.new("BodyVelocity", char.HumanoidRootPart)
                bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bodyGyro = Instance.new("BodyGyro", char.HumanoidRootPart)
                bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            end
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            bodyVelocity.Velocity = char.Humanoid.MoveDirection * flySpeed
        else
            if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
            if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
            char.Humanoid.PlatformStand = false
        end
        
        if _G.Invis_State then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = 0.7 end
            end
        end
    end
end)

local originalTransparencies = {}
local function SetXray(enable)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(Players) then
            if enable then
                if not originalTransparencies[obj] then originalTransparencies[obj] = obj.Transparency end
                if obj.Name ~= "Terrain" then obj.Transparency = 0.65 end
            else
                if originalTransparencies[obj] then obj.Transparency = originalTransparencies[obj] end
            end
        end
    end
    if not enable then originalTransparencies = {} end
end

-- POPULARE BUTOANE
AddOption("Zbor Liber (Fly Hack)", function(v) _G.Fly_State = v end)
AddOption("X-Ray Vision (Pereți Transparenți)", function(v) SetXray(v) end)
AddOption("Glitch Corp Semitransparent", function(v) 
    _G.Invis_State = v 
    if not v and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.Transparency = 0 end
        end
    end
end)
AddActionClick("📍 Teleportare la Lobby", function()
    local lobby = workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("LobbyZone")
    if lobby and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = lobby:GetModelCFrame()
    else
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end
end)

-- Buton de Ascundere
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ToggleBtn.Text = "M"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 20)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(255, 140, 0)

local open = true
ToggleBtn.MouseButton1Click:Connect(function()
    open = not open
    MainFrame.Visible = open
end)
