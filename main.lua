-- MM2 Cyber-God Edition - FĂRĂ CHAT, DESIGN TOP & OPRIRE INSTANTĂ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

if game.CoreGui:FindFirstChild("MM2_CyberGodV3") then 
    game.CoreGui.MM2_CyberGodV3:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_CyberGodV3"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- FEREASTRA PRINCIPALĂ PREMIUM
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- Efect de Margine RGB Neon Activă
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
task.spawn(function()
    while task.wait(0.02) do
        local hue = tick() % 4 / 4
        UIStroke.Color = Color3.fromHSV(hue, 1, 1)
    end
end)

-- BARĂ LATERALĂ (SIDEBAR)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 11, 16)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)

local HubTitle = Instance.new("TextLabel", Sidebar)
HubTitle.Size = UDim2.new(1, 0, 0, 50)
HubTitle.Text = "CYBER-GOD v3"
HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextSize = 14
HubTitle.BackgroundTransparency = 1

-- PAGINI CONTENT CONTAINER
local PagesContainer = Instance.new("Frame", MainFrame)
PagesContainer.Size = UDim2.new(1, -160, 1, -20)
PagesContainer.Position = UDim2.new(0, 150, 0, 10)
PagesContainer.BackgroundTransparency = 1

local PageLayout = Instance.new("UIPageLayout", PagesContainer)
PageLayout.TweenTime = 0.3
PageLayout.EasingStyle = Enum.EasingStyle.Quart
PageLayout.ScrollWheelInput = false

local function CreatePage()
    local Page = Instance.new("ScrollingFrame", PagesContainer)
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 550)
    Page.ScrollBarThickness = 3
    local L = Instance.new("UIListLayout", Page)
    L.Padding = UDim.new(0, 8)
    return Page
end

local PageMovement = CreatePage()
local PageExploits = CreatePage()
local PageTroll = CreatePage()

-- Navigare Sidebar Stilată
local function AddTabButton(name, posY, targetPage)
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(1, -16, 0, 38)
    B.Position = UDim2.new(0, 8, 0, posY)
    B.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    B.Text = name
    B.TextColor3 = Color3.fromRGB(220, 220, 220)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 11
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    B.MouseButton1Click:Connect(function() PageLayout:JumpTo(targetPage) end)
end

AddTabButton("⚡ Abilități & Fizică", 60, PageMovement)
AddTabButton("🔮 Map Exploits", 108, PageExploits)
AddTabButton("👺 Moduri Troll", 156, PageTroll)

-- VARIABILE GLOBALE PENTRU TOATE OPȚIUNILE NOI
_G.Fly_Mode = false
_G.Invis_Mode = false
_G.InfJump_Mode = false
_G.Speed_Mode = false
_G.Xray_Mode = false
_G.CoinFarm_Mode = false
_G.Noclip_Mode = false
_G.ClickTP_Mode = false
_G.AntiReset_Mode = false

local flySpeed = 45

-- CONFIGURATOR TOGGLES ULTRA-PREMIUM (VIZIBILITATE MAXIMĂ)
local function AddToggle(page, name, callback)
    local F = Instance.new("Frame", page)
    F.Size = UDim2.new(1, -5, 0, 48)
    F.BackgroundColor3 = Color3.fromRGB(25, 27, 38)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(0.65, 0, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.Text = name
    L.TextColor3 = Color3.fromRGB(255, 255, 255)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    
    local S = Instance.new("TextButton", F)
    S.Size = UDim2.new(0, 75, 0, 26)
    S.Position = UDim2.new(1, -85, 0.5, -13)
    S.BackgroundColor3 = Color3.fromRGB(230, 50, 50) -- Roșu aprins implicit
    S.Text = "DEZACTIVAT"
    S.TextColor3 = Color3.fromRGB(255, 255, 255)
    S.Font = Enum.Font.GothamBold
    S.TextSize = 10
    Instance.new("UICorner", S).CornerRadius = UDim.new(0, 6)
    
    local active = false
    S.MouseButton1Click:Connect(function()
        active = not active
        if active then
            S.BackgroundColor3 = Color3.fromRGB(40, 200, 100) -- Verde intens
            S.Text = "ACTIVAT"
        else
            S.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
            S.Text = "DEZACTIVAT"
        end
        callback(active)
    end)
end

-- CONFIGURATOR ACTION CLICKS (BUTOANE INSTANTE)
local function AddAction(page, name, callback)
    local B = Instance.new("TextButton", page)
    B.Size = UDim2.new(1, -5, 0, 42)
    B.BackgroundColor3 = Color3.fromRGB(115, 60, 255) -- Purpuriu Cyberpunk
    B.Text = name
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 12
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    B.MouseButton1Click:Connect(callback)
end

-- LOGICA INTERNĂ A FUNCȚIILOR (Zbor, Mișcare, Farm, Mecanici)
local bVel, bGyro
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        -- 1. Sistem de Zbor Liber (Fly)
        if _G.Fly_Mode then
            char.Humanoid.PlatformStand = true
            if not bVel then
                bVel = Instance.new("BodyVelocity", char.HumanoidRootPart)
                bVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bGyro = Instance.new("BodyGyro", char.HumanoidRootPart)
                bGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            end
            bGyro.CFrame = workspace.CurrentCamera.CFrame
            bVel.Velocity = char.Humanoid.MoveDirection * flySpeed
        else
            if bVel then bVel:Destroy() bVel = nil end
            if bGyro then bGyro:Destroy() bGyro = nil end
            char.Humanoid.PlatformStand = false
        end

        -- 2. Modificare Viteză Silențioasă (Speed Hack Bypass)
        if _G.Speed_Mode then char.Humanoid.WalkSpeed = 26 else char.Humanoid.WalkSpeed = 16 end
        
        -- 3. Glitch de Invizibilitate Corp (Semitransparent)
        if _G.Invis_Mode then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = 0.75 end
            end
        end

        -- 4. Trecere prin Pereți (Noclip)
        if _G.Noclip_Mode then
            for _, child in pairs(char:GetChildren()) do
                if child:IsA("BasePart") then child.CanCollide = false end
            end
        end
    end

    -- 5. Auto Coin Farm (Fără prindere de către server)
    if _G.CoinFarm_Mode and char and char:FindFirstChild("HumanoidRootPart") then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Coin_Sub" or obj.Name == "NormalCoin" or obj:FindFirstChild("Coin") then
                char.HumanoidRootPart.CFrame = obj.CFrame
                task.wait(0.12)
                break
            end
        end
    end
end)

-- 6. Sărituri Infinite (Infinite Jump)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump_Mode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- 7. Click to Teleport (Apasă pe ecran ținând apăsat pe ecran ca să te muți unde vrei)
local Mouse = LocalPlayer:GetMouse()
Mouse.Button1Down:Connect(function()
    if _G.ClickTP_Mode and Mouse.Target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.p) + Vector3.new(0, 3, 0)
    end
end)

-- 8. Logica X-Ray (Transparență totală structuri mapă)
local savedTransparencies = {}
local function ToggleXray(state)
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(Players) then
            if state then
                if not savedTransparencies[part] then savedTransparencies[part] = part.Transparency end
                if part.Name ~= "Terrain" then part.Transparency = 0.7 end
            else
                if savedTransparencies[part] then part.Transparency = savedTransparencies[part] end
            end
        end
    end
    if not state then savedTransparencies = {} end
end

-- POPULARE PAGINA 1: ABILITĂȚI & FIZICĂ
AddToggle(PageMovement, "Zbor Aerian (Fly Hack)", function(v) _G.Fly_Mode = v end)
AddToggle(PageMovement, "Viteză Superioară (Bypass Speed)", function(v) _G.Speed_Mode = v end)
AddToggle(PageMovement, "Sărituri Infinite în Aer", function(v) _G.InfJump_Mode = v end)

-- POPULARE PAGINA 2: MAP EXPLOITS
AddToggle(PageExploits, "X-Ray Vision (Pereți de Sticlă)", function(v) ToggleXray(v) end)
AddToggle(PageExploits, "Noclip Activ (Mergi prin obiecte)", function(v) _G.Noclip_Mode = v end)
AddToggle(PageExploits, "Click To Teleport (Unde apeși, te pui)", function(v) _G.ClickTP_Mode = v end)
AddToggle(PageExploits, "Colectare Automată Bănuți (Auto-Farm)", function(v) _G.CoinFarm_Mode = v end)

-- POPULARE PAGINA 3: MODURI TROLL
AddToggle(PageTroll, "Glitch Corp Invizibil (Invisibility)", function(v) 
    _G.Invis_Mode = v 
    if not v and LocalPlayer.Character then
