--[[ 
    IRUIN HUB - FIXED TAB LAYOUT
    4 TABS + WALL CHECK TOGGLE + FOV FIX
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    P_Lock = false,
    N_Lock = false,
    WallCheck = true,  -- Wall Check Toggle State
    TeamCheck = false,
    FOV = 150,
    ShowFOV = true,
    Speed = 16,
    Bone = "Head"
}

-- FIXED FOV CIRCLE (Ring fix for Delta)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.4 -- 0.4 prevents the "solid white plate" bug
FOVCircle.Filled = false
FOVCircle.Visible = false

local Window = Rayfield:CreateWindow({
    Name = "Iruin Hub | Delta v3",
    LoadingTitle = "Applying Tab Fixes...",
    ConfigurationSaving = { Enabled = false }
})

-- WALL CHECK FUNCTION
local function RayCheck(target, character)
    if not Config.WallCheck then return true end -- Skip if Wall Check is OFF
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera, character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(Camera.CFrame.Position, (target.Position - Camera.CFrame.Position), params)
    return result == nil
end

-- TARGET LOGIC
local function GetBest(mode)
    local best = nil
    local dist = Config.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    local function checkModel(m)
        if m and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then
            local part = m:FindFirstChild(Config.Bone)
            if part then
                local sPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mDist = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude
                    if mDist < dist and RayCheck(part, m) then
                        dist = mDist
                        best = m
                    end
                end
            end
        end
    end

    if mode == "P" then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                if Config.TeamCheck and v.Team == LocalPlayer.Team then continue end
                checkModel(v.Character)
            end
        end
    elseif mode == "N" then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and not Players:GetPlayerFromCharacter(v) then checkModel(v) end
        end
    end
    return best
end

-- 4 TABS LAYOUT
local Tab1 = Window:CreateTab("Player Tab", "user")
local Tab2 = Window:CreateTab("NPC Tab", "bot")
local Tab3 = Window:CreateTab("FOV Tab", "eye")
local Tab4 = Window:CreateTab("Misc Tab", "settings")

-- TAB 1: PLAYERS
Tab1:CreateToggle({Name = "Player Aimbot", CurrentValue = false, Callback = function(v) Config.P_Lock = v end})
Tab1:CreateToggle({Name = "Wall Check", CurrentValue = true, Callback = function(v) Config.WallCheck = v end})
Tab1:CreateToggle({Name = "Team Check", CurrentValue = false, Callback = function(v) Config.TeamCheck = v end})

-- TAB 2: NPCs
Tab2:CreateToggle({Name = "NPC Aimbot", CurrentValue = false, Callback = function(v) Config.N_Lock = v end})

-- TAB 3: FOV CONFIG
Tab3:CreateSlider({Name = "FOV Radius", Range = {10, 600}, Increment = 5, CurrentValue = 150, Callback = function(v) Config.FOV = v end})
Tab3:CreateToggle({Name = "Show FOV Circle", CurrentValue = true, Callback = function(v) Config.ShowFOV = v end})

-- TAB 4: MISC & DESTROY
Tab4:CreateSlider({Name = "Speed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) Config.Speed = v end})
Tab4:CreateSection("GUI Management")
Tab4:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        FOVCircle:Remove()
        Rayfield:Destroy()
    end,
})

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Config.ShowFOV
    FOVCircle.Radius = Config.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    local target = nil
    if Config.P_Lock then target = GetBest("P")
    elseif Config.N_Lock then target = GetBest("N") end

    if target then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target[Config.Bone].Position), 0.25)
    end
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Speed
    end
end)
