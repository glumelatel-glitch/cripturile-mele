-- MM2 Ultimate Hub - Smooth UI & Full ESP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer

-- Îndepărtează interfețele vechi pentru a evita suprapunerea
if game.CoreGui:FindFirstChild("MM2_UltimateHub") then
    game.CoreGui.MM2_UltimateHub:Destroy()
end

-- 1. CREARE INTERFAȚĂ DESIGN MODERN (SMOOTH ENTRY)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_UltimateHub"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Începe de la 0 pentru animație
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Colțuri rotunjite (UI Corner)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Bară de Titlu
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TitleBar.Text = "   MM2 ULTIMATE HUB 🔪"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 14
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- Container pentru butoane
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 300)
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Container

-- ANIMAȚIE INTRARE FINE (Smooth Entry)
MainFrame:TweenSize(UDim2.new(0, 320, 0, 240), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)

-- 2. STĂRI ȘI VARIABILE GLOBALE
_G.ESP_Active = false
_G.Shout_Active = false
_G.Speed_Active = false
local shoutedThisRound = {}

-- Funcție pentru crearea butoanelor cu aspect stilat
local function CreateToggle(name, default, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.BackgroundColor3 = default and Color3.fromRGB(45, 120, 85) or Color3.fromRGB(35, 35, 42)
    Button.Text = name .. (default and " [ACTIV]" or " [OPRIT]")
    Button.TextColor3 = Color3.fromRGB(240, 240, 240)
    Button.Font = Enum.Font.GothamSemibold
    Button.TextSize = 12
    Button.Parent = Container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = Button
    
    local state = default
    Button.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Button.BackgroundColor3 = Color3.fromRGB(45, 120, 85)
            Button.Text = name .. " [ACTIV]"
        else
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            Button.Text = name .. " [OPRIT]"
        end
        callback(state)
    end)
end

-- 3. INTERGRARE CHAT (Sistem universal 2026)
local function BroadcastMessage(text)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then channel:SendAsync(text) end
    else
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") and game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
        if remote then remote:FireServer(text, "All") end
    end
end

-- 4. LOGICA PENTRU COMPONENTELE DETECTIVE (ESP & SHOUT)
RunService.Heartbeat:Connect(function()
    if _G.ESP_Active or _G.Shout_Active then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                
                -- Detectarea uneltelor
                local isMurderer = player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")
                local isSheriff = player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun")
                
                -- Aplicarea corectă a ESP-ului
                local hl = player.Character:FindFirstChild("HubESP")
                if _G.ESP_Active then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "HubESP"
                        hl.FillTransparency = 0.4
                        hl.OutlineTransparency = 0
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.Parent = player.Character
                    end
                    
                    if isMurderer then
                        hl.FillColor = Color3.fromRGB(255, 0, 0) -- ROȘU pentru Murderer
                    elseif isSheriff then
                        hl.FillColor = Color3.fromRGB(0, 0, 255) -- ALBASTRU pentru Sheriff
                    else
                        hl.FillColor = Color3.fromRGB(0, 255, 0) -- VERDE pentru Innocents
                    end
                else
                    if hl then hl:Destroy() end
                end
                
                -- Strigăt automant (Auto-Shout)
                if _G.Shout_Active and isMurderer and not shoutedThisRound[player.Name] then
                    shoutedThisRound[player.Name] = true
                    BroadcastMessage("⚠️ " .. player.Name .. " ARE CUȚITUL! ESTE MURDERER! 🔪")
                end
            end
        end
        
        -- Detectare pistol scăpat pe jos
        if _G.Shout_Active then
            local gunDrop = game.Workspace:FindFirstChild("GunDrop")
            if gunDrop and not game.Workspace:GetAttribute("GunAlerted") then
                game.Workspace:SetAttribute("GunAlerted", true)
                BroadcastMessage("🚨 PISTOLUL ESTE PE JOS! Luați-l repede! 🔫")
            end
        end
    end
    
    -- Control viteză personaj (Speed Hack)
    if _G.Speed_Active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 23 -- Valoare sigură care nu dă kick din meci
    end
end)

-- Resetarea listei de avertizări la runde noi
LocalPlayer.CharacterAdded:Connect(function()
    shoutedThisRound = {}
    game.Workspace:SetAttribute("GunAlerted", false)
end)

-- 5. ADĂUGARE OPȚIUNI ÎN INTERFAȚĂ
CreateToggle("Master ESP Multi-Color", false, function(v) _G.ESP_Active = v end)
CreateToggle("Auto Shout Target", false, function(v) _G.Shout_Active = v end)
CreateToggle("Smooth Speed Bypass", false, function(v) 
    _G.Speed_Active = v 
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Buton pentru închidere curată a meniului
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 25)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
