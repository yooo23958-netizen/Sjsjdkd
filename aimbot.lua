local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration
local Options = {
    Enabled = false,
    TargetNPCs = true,
    TargetPlayers = true,
    FOV = 150,
    ShowCircle = true,
    TargetPart = "Head",
    Smoothing = 0.4
}

-- FOV Circle Visual
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 150)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Visible = false

-- Window Setup
local Window = Rayfield:CreateWindow({
    Name = "Iruin Hub | Universal Aimbot",
    LoadingTitle = "Loading NPC & Player Logic...",
    LoadingSubtitle = "by Gemini",
    ConfigurationSaving = { Enabled = true, FolderName = "Iruin_Universal", FileName = "Config" }
})

-- Target Validation Logic
local function isValidTarget(model)
    if not model:FindFirstChild("Humanoid") or model.Humanoid.Health <= 0 then return false end
    if not model:FindFirstChild(Options.TargetPart) then return false end
    return true
end

-- Selection Logic
local function getClosestTarget()
    local closestTarget = nil
    local shortestMouseDistance = Options.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    local function checkModel(model)
        if isValidTarget(model) then
            local part = model[Options.TargetPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            
            if onScreen then
                local mouseDistance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if mouseDistance < shortestMouseDistance then
                    shortestMouseDistance = mouseDistance
                    closestTarget = model
                end
            end
        end
    end

    -- Scan Players
    if Options.TargetPlayers then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                checkModel(p.Character)
            end
        end
    end

    -- Scan NPCs (Workspace)
    if Options.TargetNPCs then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                checkModel(obj)
            end
        end
    end

    return closestTarget
end

-- Rayfield UI Tabs
local MainTab = Window:CreateTab("Combat", 4483362458)

MainTab:CreateSection("Main Toggles")

MainTab:CreateToggle({
    Name = "Master Lock-On",
    CurrentValue = false,
    Flag = "MasterToggle",
    Callback = function(Value) Options.Enabled = Value end,
})

MainTab:CreateToggle({
    Name = "Target NPCs",
    CurrentValue = true,
    Flag = "NPCToggle",
    Callback = function(Value) Options.TargetNPCs = Value end,
})

MainTab:CreateToggle({
    Name = "Target Players",
    CurrentValue = true,
    Flag = "PlayerToggle",
    Callback = function(Value) Options.TargetPlayers = Value end,
})

MainTab:CreateSection("Settings")

MainTab:CreateSlider({
    Name = "FOV Radius",
    Range = {10, 800},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "FOVRadius",
    Callback = function(Value) Options.FOV = Value end,
})

MainTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = true,
    Callback = function(Value) Options.ShowCircle = Value end,
})

-- Core Loop
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Options.ShowCircle
    FOVCircle.Radius = Options.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if Options.Enabled then
        local target = getClosestTarget()
        if target then
            local targetPos = target[Options.TargetPart].Position
            local currentCF = Camera.CFrame
            local targetCF = CFrame.new(currentCF.Position, targetPos)
            
            -- Smoothing helps prevent the "jitter" on moving NPCs
            Camera.CFrame = currentCF:Lerp(targetCF, 1 - Options.Smoothing)
        end
    end
end)
