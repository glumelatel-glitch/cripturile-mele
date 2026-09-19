local MarimeHitbox = 25 

local function extindeSfera(obiect)
    if obiect:IsA("Part") and (obiect.Shape == Enum.PartType.Ball or obiect.ClassName == "MeshPart") then
        if not obiect:IsDescendantOf(game.Players.LocalPlayer.Character) then
            obiect.Size = Vector3.new(MarimeHitbox, MarimeHitbox, MarimeHitbox)
            obiect.Transparency = 0.6
            obiect.CanCollide = true
        end
    end
end

for _, obiect in pairs(game.Workspace:GetDescendants()) do
    extindeSfera(obiect)
end

game.Workspace.DescendantAdded:Connect(function(obiect)
    task.wait(0.1)
    extindeSfera(obiect)
end)
