-- MM2 Cyber Premium UI - No Chat, Ultra Clean
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Șterge meniurile vechi ca să nu se suprapună
if game.CoreGui:FindFirstChild("MM2_CyberPremium") then
    game.CoreGui.MM2_CyberPremium:Destroy()
end

-- 1. STRUCTURA PRINCIPALĂ A INTERFEȚEI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_CyberPremium"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Începe de la 0 pentru animația de entry
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Border Glow (Efect de neon pe margine)
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(115, 60, 255) -- Violet Neon
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

-- 2. SIDEBAR (Meniu Lateral)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 12)
SideCorner.Parent = Sidebar

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(1, 0, 0, 45)
HubTitle.Text = "CYBER MM2 ⚡"
HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextSize = 14
HubTitle.BackgroundTransparency = 1
HubTitle.Parent = Sidebar

-- 3. CONTAINER PAGINI (Main Content)
local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, -140, 1, -20)
PagesContainer.Position = UDim2.new(0, 140, 0, 10)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

local PageLayout = Instance.new("UIPageLayout")
PageLayout.TweenTime = 0.4
PageLayout.EasingStyle = Enum.EasingStyle.Quart
PageLayout.EasingDirection = Enum.EasingDirection.Out
PageLayout.ScrollWheelInput = false
PageLayout.Parent = PagesContainer

-- Pagina 1: Visuals (ESP)
local PageVisuals = Instance.new("ScrollingFrame")
PageVisuals.BackgroundTransparency = 1
PageVisuals.Size = UDim2.new(1, 0, 1, 0)
PageVisuals.CanvasSize = UDim2.new(0, 0, 0, 300)
PageVisuals.ScrollBarThickness = 2
PageVisuals.Parent = PagesContainer

local List1 = Instance.new("UIListLayout")
List1.Padding = UDim.new(0, 10)
List1.Parent = PageVisuals

-- Pagina 2: Movement (Viteză)
local PageMovement = Instance.new("ScrollingFrame")
PageMovement.BackgroundTransparency = 1
PageMovement.Size = UDim2.new(1, 0, 1, 0)
PageMovement.CanvasSize = UDim2.new(0, 0, 0, 300)
PageMovement.ScrollBarThickness = 2
PageMovement.Parent = PagesContainer

local List2 = Instance.new("UIListLayout")
List2.Padding = UDim.new(0, 10)
List2.Parent = PageMovement

-- 4. VARIABILE GLOBALE PENTRU FUNCȚII
_G.ESP_Chams = false
_G.Speed_Hack = false

-- 5. CREARE BUTOANE TIP "TOGGLE" MODERNE
local function AddToggle(parentPage, name, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = parentPage
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 8)
    fCorner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame
    
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 45, 0, 22)
    Switch.Position = UDim2.new(1, -55, 0.5, -11)
    Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Switch.Text = ""
    Switch.Parent = Frame
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 11)
    sCorner.Parent = Switch
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 3, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch
    
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 8)
    cCorner.Parent = Circle
    
    local toggled = false
    Switch.MouseButton1Click:Connect(function()
        toggled = not toggled
        local targetPos = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        local targetColor = toggled and Color3.fromRGB(115, 60, 255) or Color3.fromRGB(40, 40, 50)
        
        TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        
        callback(toggled)
    end)
end

-- Butoane de navigare în Sidebar
local function AddTabButton(name, positionY, pageIndex)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -16, 0, 35)
    TabBtn.Position = UDim2.new(0, 8, 0, positionY)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize = 12
    TabBtn.Parent = Sidebar
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 6)
    tCorner.Parent = TabBtn
    
    TabBtn.MouseButton1Click:Connect(function()
        PageLayout:JumpTo(PagesContainer:GetChildren()[pageIndex + 1])
    end)
end

AddTabButton("Visuals ESP", 55, 1)
AddTabButton("Movement", 95, 2)

-- 6. LOGICA LOGICĂ MM2 (ESP & SPEED HACK)
local function ApplyChams(player, color)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hl = player.Character:FindFirstChild("CyberESP")
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "CyberESP"
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineTransparency = 0.1
            hl.FillTransparency = 0.35
            hl.Parent = player.Character
        end
        hl.FillColor = color
    end
end

RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if _G.ESP_Chams then
                local hasKnife = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                local hasGun = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                
                if hasKnife then
                    ApplyChams(p, Color3.fromRGB(255, 30, 30)) -- ROȘU: Murderer
                elseif hasGun then
                    ApplyChams(p, Color3.fromRGB(30, 100, 255)) -- ALBASTRU: Sheriff
                else
                    ApplyChams(p, Color3.fromRGB(30, 255, 100)) -- VERDE: Innocent
                end
            else
                if p.Character:FindFirstChild("CyberESP") then
                    p.Character.CyberESP:Destroy()
                end
            end
        end
    end
    
    -- Speed Hack activat/dezactivat constant
    if _G.Speed_Hack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 24
    end
end)

-- Populare opțiuni în pagini
AddToggle(PageVisuals, "Player Chams Wallhack", function(v) _G.ESP_Chams = v end)
AddToggle(PageMovement, "Cyber Speed Bypass (x24)", function(v) 
    _G.Speed_Hack = v 
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- 7. ANIMAȚIE DE DESCHIDERE (Smooth Size & Position)
MainFrame:TweenSize(UDim2.new(0, 450, 0, 280), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.6, true)

-- 8. BUTON PLUTITOR DISCRET (Pentru Ascuns / Afișat GUI pe Telefon)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0.02, 0, 0.15, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.fromRGB(115, 60, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 22.5)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 1
ToggleStroke.Color = Color3.fromRGB(115, 60, 255)
ToggleStroke.Parent = ToggleButton

local menuVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    if menuVisible then
        MainFrame:TweenSize(UDim2.new(0, 450, 0, 280), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.4, true)
    else
        MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.4, true)
    end
end)
