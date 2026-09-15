-- Înlocuiește complet codul vechi de pe GitHub cu acesta:
local OrionLib = loadstring(game:HttpGet('https://githubusercontent.com'))()
local Window = OrionLib:MakeWindow({Name = "Jump Clicker INSTANT WIN 🏆", HidePremium = false, SaveConfig = false})

local Tab = Window:MakeTab({
	Name = "Exploits",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

_G.InstantWin = false
_G.AutoRebirth = false

-- Funcția care caută zona de Win și te teleportează acolo instant
function DoInstantWin()
    while _G.InstantWin == true do
        local plyr = game.Players.LocalPlayer
        if plyr.Character and plyr.Character:FindFirstChild("HumanoidRootPart") then
            -- Caută platforma de final sau trofeele din joc
            -- Majoritatea simulatoarelor folosesc "Wins", "WinZone" sau platforme la înălțime mare
            local winPad = game.Workspace:FindFirstChild("Wins") or game.Workspace:FindFirstChild("WinZone") or game.Workspace:FindFirstChild("EndZone")
            
            if winPad then
                plyr.Character.HumanoidRootPart.CFrame = winPad.CFrame + Vector3.new(0, 3, 0)
            else
                -- Dacă numele obiectului e ascuns, te ridică direct în aer la 50.000 de stud-uri (unde e finalul de obicei)
                plyr.Character.HumanoidRootPart.CFrame = plyr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5000, 0)
            end
        end
        task.wait(0.1) -- Timp de așteptare mic ca să nu primești crash de la joc
    end
end

-- Funcția pentru Rebirth Automat
function DoAutoRebirth()
    while _G.AutoRebirth == true do
        -- Trimite semnal către server pentru rebirth gratuit
        local args = { [1] = 1 }
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Rebirth") or game:GetService("ReplicatedStorage"):FindFirstChild("RebirthRemote")
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(args))
        end
        task.wait(1)
    end
end

-- Interfața Grafică (Butoanele din meniu)
Tab:AddToggle({
	Name = "Instant Win Loop (Teleport la Final)",
	Default = false,
	Callback = function(Value)
		_G.InstantWin = Value
		if Value then DoInstantWin() end
	end
})

Tab:AddToggle({
	Name = "Auto Rebirth (Când ai destule Win-uri)",
	Default = false,
	Callback = function(Value)
		_G.AutoRebirth = Value
		if Value then DoAutoRebirth() end
	end
})

OrionLib:Init()
