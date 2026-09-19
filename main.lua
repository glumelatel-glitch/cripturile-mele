-- [[ HITBOX BALL EXPERT INTERFACE ]] --
local HitboxActivat = false
local MarimeCurenta = 25

-- Creare Instanțe GUI Principale
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")
local SliderContainer = Instance.new("Frame")
local SliderCorner = Instance.new("UICorner")
local SliderLabel = Instance.new("TextLabel")
local SliderBar = Instance.new("Frame")
local SliderBtn = Instance.new("TextButton")
local SliderBtnCorner = Instance.new("UICorner")

-- Proprietăți de bază ScreenGui
ScreenGui.Name = "ProHitboxGUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fereastra Principală (Design Modern Dark)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 230, 0, 170)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(0, 255, 170) -- Margine Cyan/Neon
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Titlu Fereastră
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 10)
Title.Size = UDim2.new(1, -30, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚽ BALL HITBOX"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Buton Principal de Comutare (Touch to Toggle)
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(230, 60, 60) -- Roșu când e dezactivat
ToggleBtn.Position = UDim2.new(0, 15, 0, 45)
ToggleBtn.Size = UDim2.new(0, 200, 0, 40)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "TOUCH TO ACTIVATE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12

ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

-- Panou Slider pentru Schimbarea Mărimii
SliderContainer.Name = "SliderContainer"
SliderContainer.Parent = MainFrame
SliderContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
SliderContainer.Position = UDim2.new(0, 15, 0, 98)
SliderContainer.Size = UDim2.new(0, 200, 0, 55)

SliderCorner.CornerRadius = UDim.new(0, 6)
SliderCorner.Parent = SliderContainer

SliderLabel.Name = "SliderLabel"
SliderLabel.Parent = SliderContainer
SliderLabel.BackgroundTransparency = 1
SliderLabel.Position = UDim2.new(0, 10, 0, 6)
SliderLabel.Size = UDim2.new(1, -20, 0, 20)
SliderLabel.Font = Enum.Font.GothamMedium
SliderLabel.Text = "Hitbox Size: " .. MarimeCurenta
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.TextSize = 11
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

SliderBar.Name = "SliderBar"
SliderBar.Parent = SliderContainer
SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
SliderBar.Position = UDim2.new(0, 10, 0, 34)
SliderBar.Size = UDim2.new(0, 180, 0, 5)

SliderBtn.Name = "SliderBtn"
SliderBtn.Parent = SliderBar
SliderBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
SliderBtn.Position = UDim2.new(0.46, 0, -1.2, 0) -- Începe de la 25
SliderBtn.Size = UDim2.new(0, 14, 0, 14)
SliderBtn.Text = ""

SliderBtnCorner.CornerRadius = UDim.new(1, 0)
SliderBtnCorner.Parent = SliderBtn

-- Funcția Core care extinde fizic mingea
local function aplicaHitbox(obiect)
    if not HitboxActivat then return end
    if obiect:IsA("Part") and (obiect.Shape == Enum.PartType.Ball or obiect.ClassName == "MeshPart") then
        if not obiect:IsDescendantOf(game.Players.LocalPlayer.Character) then
            obiect.Size = Vector3.new(MarimeCurenta, MarimeCurenta, MarimeCurenta)
            obiect.Transparency = 0.5 -- Vizibilitatea hitbox-ului pe teren
            obiect.CanCollide = true
        end
    end
end

-- Scanare continuă în Workspace
task.spawn(function()
    while true do
        if HitboxActivat then
            for _, obiect in pairs(game.Workspace:GetDescendants()) do
                aplicaHitbox(obiect)
            end
        end
        task.wait(0.5) -- Reglat pentru performanță maximă pe telefon
    end
end)

-- Interacțiune Activare / Dezactivare
ToggleBtn.MouseButton1Click:Connect(function()
    HitboxActivat = not HitboxActivat
    if HitboxActivat then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 200, 115) -- Se face Verde
        ToggleBtn.Text = "HITBOX ACTIVE"
        for _, obiect in pairs(game.Workspace:GetDescendants()) do aplicaHitbox(obiect) end
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(230, 60, 60) -- Înapoi la Roșu
        ToggleBtn.Text = "TOUCH TO ACTIVATE"
    end
end)

-- Sistemul Atingere / Drag pentru Slider
local UserInputService = game:GetService("UserInputService")
local seTrage = false

SliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        seTrage = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        seTrage = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if seTrage and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position.X
        local barLeftPos = SliderBar.AbsolutePosition.X
        local barWidth = SliderBar.AbsoluteSize.X
        local procentaj = math.clamp((mousePos - barLeftPos) / barWidth, 0, 1)
        
        SliderBtn.Position = UDim2.new(procentaj, -7, -1.2, 0)
        
        -- Mărimea variază între 2 și 60
        MarimeCurenta = math.floor(2 + (procentaj * 58))
        SliderLabel.Text = "Hitbox Size: " .. MarimeCurenta
        
        if HitboxActivat then
            for _, obiect in pairs(game.Workspace:GetDescendants()) do aplicaHitbox(obiect) end
        end
    end
end)
