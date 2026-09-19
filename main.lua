-- [[ BALL HITBOX EXPERT V3 - FIX TOUCH & VISUAL HITBOX ]] --
local HitboxActivat = false
local MarimeCurenta = 25

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

if PlayerGui:FindFirstChild("ProHitboxGUI") then
    PlayerGui.ProHitboxGUI:Destroy()
end

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

ScreenGui.Name = "ProHitboxGUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
-- Forțăm interfața să fie deasupra oricărui element din joc ca să meargă touch-ul
ScreenGui.DisplayOrder = 999999 
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 230, 0, 170)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(0, 255, 170)
UIStroke.Thickness = 2.5
UIStroke.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 10)
Title.Size = UDim2.new(1, -30, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚽ BALL HITBOX V3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Buton optimizat pentru ecran tactil (ZIndex mare)
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.ZIndex = 10
ToggleBtn.BackgroundColor3 = Color3.fromRGB(230, 60, 60)
ToggleBtn.Position = UDim2.new(0, 15, 0, 45)
ToggleBtn.Size = UDim2.new(0, 200, 0, 40)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "TOUCH TO ACTIVATE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12

ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

SliderContainer.Name = "SliderContainer"
SliderContainer.Parent = MainFrame
SliderContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
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
SliderBtn.ZIndex = 10
SliderBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
SliderBtn.Position = UDim2.new(0.46, 0, -1.2, 0)
SliderBtn.Size = UDim2.new(0, 14, 0, 14)
SliderBtn.Text = ""

SliderBtnCorner.CornerRadius = UDim.new(1, 0)
SliderBtnCorner.Parent = SliderBtn

-- Setează vizibilitatea hitbox-ului pe minge
local function creeazaVizualizareHitbox(minge)
    if not minge:FindFirstChild("VizualizareHitbox") then
        local boxEfect = Instance.new("SelectionSphere")
        boxEfect.Name = "VizualizareHitbox"
        boxEfect.Adornee = minge
        boxEfect.Color3 = Color3.fromRGB(0, 255, 255) -- Cyan/Neon strălucitor pe minge
        boxEfect.Transparency = 0.2 -- Destul de vizibil pe teren
        boxEfect.Parent = minge
    end
end

local function aplicaHitbox(obiect)
    if obiect:IsA("Part") and (obiect.Shape == Enum.PartType.Ball or obiect.ClassName == "MeshPart") then
        if not obiect:IsDescendantOf(Player.Character or workspace) then
            if not game.Players:GetPlayerFromCharacter(obiect.Parent) then
                if HitboxActivat then
                    obiect.Size = Vector3.new(MarimeCurenta, MarimeCurenta, MarimeCurenta)
                    obiect.CanCollide = true
                    creeazaVizualizareHitbox(obiect)
                else
                    -- Readuce mingea la normal când oprești scriptul
                    if obiect:FindFirstChild("VizualizareHitbox") then
                        obiect.VizualizareHitbox:Destroy()
                    end
                    obiect.Size = Vector3.new(2, 2, 2) -- Mărime standard Roblox
                end
            end
        end
    end
end

-- Scanare rapidă
task.spawn(function()
    while true do
        for _, obiect in pairs(workspace:GetDescendants()) do
            aplicaHitbox(obiect)
        end
        task.wait(0.3)
    end
end)

-- Funcție unică care schimbă starea butonului
local function schimbaStareHitbox()
    HitboxActivat = not HitboxActivat
    if HitboxActivat then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 200, 115)
        ToggleBtn.Text = "HITBOX ACTIVE"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(230, 60, 60)
        ToggleBtn.Text = "TOUCH TO ACTIVATE"
        for _, obiect in pairs(workspace:GetDescendants()) do aplicaHitbox(obiect) end
    end
end

-- FIX DE TOUCH DUAL: Reacționează instant și la click și la atingere mobilă brută
ToggleBtn.MouseButton1Click:Connect(schimbaStareHitbox)
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        schimbaStareHitbox()
    end
end)

-- Sistemul Atingere / Drag pentru Slider
local seTrage = false

local function activeazaTragere() seTrage = true end
SliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        activeazaTragere()
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
        MarimeCurenta = math.floor(2 + (procentaj * 58))
        SliderLabel.Text = "Hitbox Size: " .. MarimeCurenta
    end
end)
