-- Configurații Inițiale
local HitboxActivat = false
local MarimeCurenta = 20

-- Creare Instanțe GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local ToggleContainer = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")
local SliderContainer = Instance.new("Frame")
local SliderCorner = Instance.new("UICorner")
local SliderLabel = Instance.new("TextLabel")
local SliderBar = Instance.new("Frame")
local SliderBtn = Instance.new("TextButton")
local SliderBtnCorner = Instance.new("UICorner")

-- Proprietăți de bază
ScreenGui.Name = "ProHitboxGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fereastra Principală (Design Dark premium)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.Position = UDim2.new(0.1, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(80, 80, 255) -- Margine albastră electric
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Titlu Elegant
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 12)
Title.Size = UDim2.new(1, -30, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "🔮 HITBOX EXPERT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Container pentru Toggle (Buton Activat/Deactivat)
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 75) -- Roșu inițial
ToggleBtn.Position = UDim2.new(0, 15, 0, 50)
ToggleBtn.Size = UDim2.new(0, 210, 0, 38)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "STATUS: DEACTIVATED"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12

ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

-- Container Slider
SliderContainer.Name = "SliderContainer"
SliderContainer.Parent = MainFrame
SliderContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SliderContainer.Position = UDim2.new(0, 15, 0, 103)
SliderContainer.Size = UDim2.new(0, 210, 0, 60)

SliderCorner.CornerRadius = UDim.new(0, 8)
SliderCorner.Parent = SliderContainer

SliderLabel.Name = "SliderLabel"
SliderLabel.Parent = SliderContainer
SliderLabel.BackgroundTransparency = 1
SliderLabel.Position = UDim2.new(0, 10, 0, 8)
SliderLabel.Size = UDim2.new(1, -20, 0, 20)
SliderLabel.Font = Enum.Font.GothamMedium
SliderLabel.Text = "Hitbox Size: " .. MarimeCurenta
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.TextSize = 12
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

SliderBar.Name = "SliderBar"
SliderBar.Parent = SliderContainer
SliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SliderBar.Position = UDim2.new(0, 10, 0, 36)
SliderBar.Size = UDim2.new(0, 190, 0, 6)

SliderBtn.Name = "SliderBtn"
SliderBtn.Parent = SliderBar
SliderBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
SliderBtn.Position = UDim2.new(0.36, 0, -1, 0) -- Poziția de start bazată pe valoarea 20
SliderBtn.Size = UDim2.new(0, 16, 0, 16)
SliderBtn.Text = ""

SliderBtnCorner.CornerRadius = UDim.new(1, 0)
SliderBtnCorner.Parent = SliderBtn

-- Logică pentru dimensionarea mingii
local function aplicaHitbox(obiect)
    if not HitboxActivat then return end
    if obiect:IsA("Part") and (obiect.Shape == Enum.PartType.Ball or obiect.ClassName == "MeshPart") then
        if not obiect:IsDescendantOf(game.Players.LocalPlayer.Character) then
            obiect.Size = Vector3.new(MarimeCurenta, MarimeCurenta, MarimeCurenta)
            obiect.Transparency = 0.5
            obiect.CanCollide = true
        end
    end
end

-- Scanare permanentă optimizată
task.spawn(function()
    while true do
        if HitboxActivat then
            for _, obiect in pairs(game.Workspace:GetDescendants()) do
                aplicaHitbox(obiect)
            end
        end
        task.wait(0.5)
    end
end)

-- Interacțiune Buton Principal (Toggle)
ToggleBtn.MouseButton1Click:Connect(function()
    HitboxActivat = not HitboxActivat
    if HitboxActivat then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 200, 115) -- Verde tactiv
        ToggleBtn.Text = "STATUS: ACTIVE"
        
        -- Trimite o animație rapidă la pornire pe obiectele curente
        for _, obiect in pairs(game.Workspace:GetDescendants()) do aplicaHitbox(obiect) end
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 75) -- Înapoi la roșu
        ToggleBtn.Text = "STATUS: DEACTIVATED"
    end
end)

-- Sistemul de control pentru Slider (Tragere cu degetul / Touch drag)
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
        
        SliderBtn.Position = UDim2.new(procentaj, -8, -1, 0)
        
        -- Mărimea variază între 2 și 50
        MarimeCurenta = math.floor(2 + (procentaj * 48))
        SliderLabel.Text = "Hitbox Size: " .. MarimeCurenta
        
        -- Aplică mărimea nouă imediat pe mingile existente
        if HitboxActivat then
            for _, obiect in pairs(game.Workspace:GetDescendants()) do aplicaHitbox(obiect) end
        end
    end
end)
