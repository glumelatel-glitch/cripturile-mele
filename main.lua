local OrionLib = loadstring(game:HttpGet('https://githubusercontent.com'))()
local Window = OrionLib:MakeWindow({Name = "MM2 Wallhack & Shout 🔪", HidePremium = false, SaveConfig = false})

local Tab = Window:MakeTab({
	Name = "MM2 Features",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Variabile globale pentru stări
_G.ESP_Enabled = false
_G.AutoShout = false

-- Funcție pentru a crea conturul colorat (ESP) în jurul unui jucător
local function CreateESP(player, color)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Șterge ESP-ul vechi dacă există ca să nu se cumuleze
        if player.Character:FindFirstChild("MM2_ESP") then
            player.Character.MM2_ESP:Destroy()
        end
        
        -- Creează un Highlight (Efect de contur prin pereți disponibil în Roblox)
        local highlight = Instance.new("Highlight")
        highlight.Name = "MM2_ESP"
        highlight.FillColor = color
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
    end
end

-- Funcție principală care scanează rolurile din meci
task.spawn(function()
    while true do
        if _G.ESP_Enabled or _G.AutoShout then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    
                    local isMurderer = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                    local isSheriff = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                    
                    -- 1. Sistemul ESP cu culori personalizate
                    if _G.ESP_Enabled then
                        if isMurderer then
                            CreateESP(p, Color3.fromRGB(255, 0, 0)) -- ROȘU pentru Murderer
                        elseif isSheriff then
                            CreateESP(p, Color3.fromRGB(0, 0, 255)) -- ALBASTRU pentru Sheriff
                        else
                            CreateESP(p, Color3.fromRGB(0, 255, 0)) -- VERDE pentru Innocents
                        end
                    end
                    
                    -- 2. Sistemul Auto Shout în Chat
                    if _G.AutoShout and isMurderer then
                        -- Trimite mesaj în chat doar o singură dată pe rundă când îl vede
                        if not p:GetAttribute("Shouted") then
                            p:SetAttribute("Shouted", true)
                            local chatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") and game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
                            if chatRemote then
                                chatRemote:FireServer(p.Name .. " ESTE MURDERER! A SCOȘ CUTITUL! 🔪", "All")
                            end
                        end
                    end
                    
                end
            end
            
            -- Verificare dacă arma este pe jos (Sheriff-ul a murit)
            if _G.AutoShout then
                local gunDrop = game.Workspace:FindFirstChild("GunDrop")
                if gunDrop and not game.Workspace:GetAttribute("GunShouted") then
                    game.Workspace:SetAttribute("GunShouted", true)
                    local chatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") and game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
                    if chatRemote then
                        chatRemote:FireServer("ARMA ESTE PE JOS! Luați arma repede! 🔫", "All")
                    end
                end
            end
        end
        task.wait(1) -- Scanează la fiecare secundă pentru a nu face lag
    end
end)

-- Resetare atribute când începe o rundă nouă (Când moare sau se schimbă harta)
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    game.Workspace:SetAttribute("GunShouted", false)
    for _, p in pairs(game.Players:GetPlayers()) do
        p:SetAttribute("Shouted", false)
    end
end)

-- Butoanele din Interfață
Tab:AddToggle({
	Name = "Activează ESP (Roșu/Albastru/Verde)",
	Default = false,
	Callback = function(Value)
		_G.ESP_Enabled = Value
        if not Value then
            -- Curăță tot ESP-ul de pe ecran dacă oprești funcția
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("MM2_ESP") then
                    p.Character.MM2_ESP:Destroy()
                end
            end
        end
	end
})

Tab:AddToggle({
	Name = "Auto Shout în Chat (Spune cine e Murderer)",
	Default = false,
	Callback = function(Value)
		_G.AutoShout = Value
	end
})

OrionLib:Init()
