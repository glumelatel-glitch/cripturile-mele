-- Configurații de bază
local MarimeHitbox = 25
local HitboxActivat = false

-- Creare Interfață Grafică (GUI)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local UICornerBtn = Instance.new("UICorner")
local StatusLabel = Instance.new("TextLabel")

-- Setări proprietăți GUI
ScreenGui.Name = "HitboxBallGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fereastra Principală
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30) -- Dark Theme
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0) -- Poziționat în stânga ecranului
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- Poți să muți fereastra trăgând de ea pe ecran

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(0, 255, 150) -- Margine Neon Green
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Titlul
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "BALL HITBOX GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- Butonul de Activare (Toggle)
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40) -- Roșu când e oprit
ToggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "TOUCH TO ACTIVATE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13

UICornerBtn.CornerRadius = UDim.new(0, 8)
UICornerBtn.Parent = ToggleBtn

-- Indicator Status
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Status: DEACTIVATED"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 12

-- Logică extindere hitbox minge
local function extindeSfera(obiect)
    if not HitboxActivat then return end
    if obiect:IsA("Part") and (obiect.Shape == Enum.PartType.Ball or obiect.ClassName == "MeshPart") then
        if not obiect:IsDescendantOf(game.Players.LocalPlayer.Character) then
            obiect.Size = Vector3.new(MarimeHitbox, MarimeHitbox, MarimeHitbox)
            obiect.Transparency = 0.6 -- O face semi-transparentă
            obiect.CanCollide = true
        end
    end
end

-- Scanare continuă în fundal
task.spawn(function()
    while true do
        if HitboxActivat then
            for _, obiect in pairs(game.Workspace:GetDescendants()) do
                extindeSfera(obiect)
            end
        end
        task.wait(1) -- Scanează o dată pe secundă pentru a nu provoca lag
    end
end)

-- Interacțiune buton (Touch / Click)
ToggleBtn.MouseButton1Click:Connect(function()
    HitboxActivat = not HitboxActivat
    if HitboxActivat then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100) -- Se face verde
        ToggleBtn.Text = "HITBOX ACTIVE"
        StatusLabel.Text = "Status: ENABLED"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40) -- Se face roșu înapoi
        ToggleBtn.Text = "TOUCH TO ACTIVATE"
        StatusLabel.Text = "Status: DEACTIVATED"
        StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)
