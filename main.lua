-- MM2 Cyberpunk God-Mode UI - FĂRĂ CHAT & ESP REPARAT
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Curățare interfețe vechi
if game.CoreGui:FindFirstChild("MM2_CyberpunkGod") then
    game.CoreGui.MM2_CyberpunkGod:Destroy()
end

-- 1. STRUCTURA DE BAZĂ A INTERFEȚEI (RGB GLOW & GLASS DESIGN)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_CyberpunkGod"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Animație entry de la 0
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- Margine Neon RGB Animata
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 0, 100)
UIStroke.Parent = MainFrame

task.spawn(function()
    while task.wait(0.05) do
        local hue = tick() % 5 / 5
        UIStroke.Color = Color3.fromHSV(hue, 1, 1)
    end
end)

-- 2. BARĂ LATERALĂ (SIDEBAR BANNER)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 14)
SideCorner.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "CYBERPUNK v2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.BackgroundTransparency = 1
Title.Parent = Sidebar

-- 3. MANAGER PAGINI MULTIPLE
local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, -160, 1, -20)
PagesContainer.Position = UDim2.new(0, 150, 0, 10)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

local PageLayout = Instance.new("UIPageLayout")
PageLayout.TweenTime = 0.3
PageLayout.EasingStyle = Enum.EasingStyle.Quart
PageLayout.ScrollWheelInput = false
PageLayout.Parent = PagesContainer

-- Creare pagini dedicate
local function CreatePage()
    local Page = Instance.new("ScrollingFrame")
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 400)
    Page.ScrollBarThickness = 2
    Page.Parent = PagesContainer
    
    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 8)
    List.Parent = Page
    return Page
end

local PageVisuals = CreatePage()
local PageCombat = CreatePage()
local PageExploits = CreatePage()

-- Butoane Navigare Sidebar
local function AddTab(name, posY, page)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -16, 0, 35)
    Btn.Position = UDim2.new(0, 8, 0, posY)
    Btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.Parent = Sidebar
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        PageLayout:JumpTo(page)
    end)
end

AddTab("👁️ Visuals ESP", 60, PageVisuals)
AddTab("⚔️ Combat / Aim", 105, PageCombat)
AddTab("💰 Exploits / Farm", 150, PageExploits)

-- 4. VARIABILE DE CONFIGURARE COMPLETĂ
_G.ESP_Active = false
_G.GunESP_Active = false
_G.Speed_Active = false
_G.Jump_Active = false
_G.CoinFarm_Active = false
_G.KillAura_Active = false

-- 5. CREARE OPȚIUNI (TOGGLES MODERNE LUX)
local function AddToggle(page, name, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame
    
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 42, 0, 20)
    Switch.Position = UDim2.new(1, -52, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Switch.Text = ""
    Switch.Parent = Frame
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 10)
    
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = UDim2.new(0, 3, 0.5, -7)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.Parent = Switch
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(0, 7)
    
    local state = false
    Switch.MouseButton1Click:Connect(function()
        state = not state
        local tPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        local tColor = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(45, 45, 55)
        
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = tPos}):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = tColor}):Play()
        callback(state)
    end)
end

-- 6. LOGICA COLOZALĂ JOC (FUNCTII EXCLUSIVE MM2)
local function RefreshESP(player, color, enable)
    if player.Character then
        local old = player.Character:FindFirstChild("CyberGodESP")
        if old then old:Destroy() end
        
        if enable and player.Character:FindFirstChild("HumanoidRootPart") then
            local hl = Instance.new("Highlight")
            hl.Name = "CyberGodESP"
            hl.FillColor = color
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.4
            hl.Parent = player.Character
        end
    end
end

RunService.Heartbeat:Connect(function()
    -- Scanare Jucători (Roluri & ESP)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if _G.ESP_Active then
                local isMerd = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                local isSher = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                
                if isMerd then
                    RefreshESP(p, Color3.fromRGB(255, 0, 50), true)  -- ROȘU: Murderer
                elseif isSher then
                    RefreshESP(p, Color3.fromRGB(0, 100, 255), true) -- ALBASTRU: Sheriff
                else
                    RefreshESP(p, Color3.fromRGB(0, 255, 100), true) -- VERDE: Innocent
                end
            else
                RefreshESP(p, nil, false) -- OPRIRE IMEDIATĂ ESP
            end
            
            -- KillAura automată (Te apără dacă ești Sheriff sau atacă automat)
            if _G.KillAura_Active and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < 15 and LocalPlayer.Character:FindFirstChild("Knife") then
                    LocalPlayer.Character.Knife:Activate()
                end
            end
        end
    end
    
    -- Gun ESP (Evidențiere pistol căzut pe jos)
    local gunDrop = game.Workspace:FindFirstChild("GunDrop")
    if gunDrop then
        local gHl = gunDrop:FindFirstChild("GunGlow")
        if _G.GunESP_Active then
            if not gHl then
                gHl = Instance.new("Highlight", gunDrop)
                gHl.Name = "GunGlow"
                gHl.FillColor = Color3.fromRGB(255, 255, 0) -- GALBEN
                gHl.FillTransparency = 0.2
            end
        else
            if gHl then gHl:Destroy() end
        end
    end
    
    -- Auto Coin Farm (Teleportare fină la bănuți)
    if _G.CoinFarm_Active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, obj in pairs(game.Workspace:GetChildren()) do
            if obj.Name == "Coin_Sub" or obj:FindFirstChild("Coin") or obj.Name == "NormalCoin" then
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                task.wait(0.1)
                break
            end
        end
    end
    
    -- Modificatori fizici jucător
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.Speed_Active and 25 or 16
        LocalPlayer.Character.Humanoid.JumpPower = _G.Jump_Active and 75 or 50
    end
end)

-- POPULARE PAGINI CU OPȚIUNI NOI
AddToggle(PageVisuals, "Player Wallhack (Chams RGB)", function(v) _G.ESP_Active = v end)
AddToggle(PageVisuals, "Dropped Gun ESP (Yellow)", function(v) _G.GunESP_Active = v end)

AddToggle(PageCombat, "Silent Legit Speed (x25)", function(v) _G.Speed_Active = v end)
AddToggle(PageCombat, "Infinite High Jump", function(v) _G.Jump_Active = v end)
AddToggle(PageCombat, "Auto Attack KillAura", function(v) _G.KillAura_Active = v end)

AddToggle(PageExploits, "Auto Farm Coins (Teleport)", function(v) _G.CoinFarm_Active = v end)

-- 7. ANIMAȚIE DE INTRARE ULTRA FINĂ
MainFrame:TweenSize(UDim2.new(0, 480, 0, 300), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)

-- 8. BUTON PLUTITOR DE ASCUNDERE (FAL MAI FAIN)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 46, 0, 46)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
