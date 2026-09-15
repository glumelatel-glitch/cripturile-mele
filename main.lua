-- Meniu UI simplu pentru Jump Clicker în Delta Executor
local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()
local Window = OrionLib:MakeWindow({Name = "Jump Clicker Hub 🚀", HidePremium = false, SaveConfig = false})

local Tab = Window:MakeTab({
	Name = "Main Features",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Toggles (Variabile de stare)
_G.AutoClick = false
_G.AutoJump = false

-- Funcția de Auto Clicker
function DoClick()
	while _G.AutoClick == true do
		-- Simulează apăsarea pe ecran (Click/Tap) pentru a adăuga Jump
		game:GetService("VirtualUser"):CaptureController()
		game:GetService("VirtualUser"):ClickButton1(Vector2.new(0, 0))
		task.wait(0.01) -- Viteză ultra-rapidă (Ajustează dacă primești lag)
	end
end

-- Funcția de Auto Jump
function DoJump()
	while _G.AutoJump == true do
		local plyr = game.Players.LocalPlayer
		if plyr.Character and plyr.Character:FindFirstChild("Humanoid") then
			-- Pune personajul să sară automat când atinge pământul
			plyr.Character.Humanoid.Jump = true
		end
		task.wait(0.1)
	end
end

-- Butoanele din interfață
Tab:AddToggle({
	Name = "Auto Click (Adaugă Jump)",
	Default = false,
	Callback = function(Value)
		_G.AutoClick = Value
		if Value then DoClick() end
	end
})

Tab:AddToggle({
	Name = "Auto Jump (Sari Singur)",
	Default = false,
	Callback = function(Value)
		_G.AutoJump = Value
		if Value then DoJump() end
	end
})

Tab:AddButton({
	Name = "Teleport la Spawn (Reset)",
	Callback = function()
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(0, 5, 0)) -- Teleportare de siguranță în caz că rămâi blocat
	end    
})

OrionLib:Init()
