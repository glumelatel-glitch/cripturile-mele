-- [[ STEAL AN EGG - AUTOMATIC HITBOX & AUTO-COLLECT ]] --
print("Scriptul special pentru Steal an Egg a pornit!")

-- Configurații
local RazaColectare = 18   -- Distanța de la care culegi oul automat
local MarimeHitbox = 20    -- Cât de mare să se facă oul ca să îl atingi ușor
local CuloareNeon = Color3.fromRGB(255, 100, 0) -- Portocaliu neon strălucitor pentru ouă

local Player = game:GetService("Players").LocalPlayer

-- Funcție care modifică ouăle și le colectează
local function proceseazaOu(obiect)
    -- Caută obiecte care conțin numele "Egg" sau sunt sfere/mesh-uri pe hartă
    if obiect:IsA("Part") or obiect:IsA("MeshPart") then
        if string.find(string.lower(obiect.Name), "egg") or string.find(string.lower(obiect.Name), "ou") then
            -- Ne asigurăm că nu aparține corpului tău
            if not obiect:IsDescendantOf(Player.Character) then
                
                -- 1. Extindere Hitbox fizic
                obiect.Size = Vector3.new(MarimeHitbox, MarimeHitbox, MarimeHitbox)
                obiect.CanCollide = false -- Dezactivat ca să nu te împiedici de ele
                
                -- 2. Adăugare efect vizual prin pereți (ESP)
                if not obiect:FindFirstChild("EggVisualEffect") then
                    local efect = Instance.new("SelectionSphere")
                    efect.Name = "EggVisualEffect"
                    efect.Adornee = obiect
                    efect.Color3 = CuloareNeon
                    efect.Transparency = 0.3
                    efect.Parent = obiect
                end
                
                -- 3. Logica de Auto-Steal (Colectare automată la apropiere)
                local character = Player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local distanta = (character.HumanoidRootPart.Position - obiect.Position).Magnitude
                    
                    if distanta <= RazaColectare then
                        -- Forțează jocul să creadă că ai călcat pe ou ca să îl furi
                        firetouchinterest(character.HumanoidRootPart, obiect, 0)
                        task.wait()
                        firetouchinterest(character.HumanoidRootPart, obiect, 1)
                    end
                end
                
            end
        end
    end
end

-- Scanare ultra-rapidă în fundal
task.spawn(function()
    while true do
        for _, obiect in pairs(workspace:GetDescendants()) do
            proceseazaOu(obiect)
        end
        task.wait(0.2) -- Rulează rapid de 5 ori pe secundă ca să prindă ouăle noi spawnate
    end
end)
