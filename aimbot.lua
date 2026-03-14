--[[ 
    IRUIN HUB | v5.5
    Aimbot | NPC | Combat | ESP | Color FOV
]]

local _0x4c = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local _0x50 = game:GetService("Players")
local _0x52 = game:GetService("RunService")
local _0x4c50 = _0x50.LocalPlayer
local _0x4361 = workspace.CurrentCamera
local VU = game:GetService("VirtualUser")

local _0x4461 = {
    _0x4c31 = false, _0x4c32 = false, _0x5743 = true, _0x5443 = false, 
    _0x464f = 150, _0x5669 = true, _0x5370 = 16, _0x426f = "Head",
    _ESP_Enabled = false, _AutoKill = false, _AutoClick = false,
    _FOV_Color = Color3.fromRGB(255, 255, 255) -- Default Color
}

-- FOV Drawing Setup
local _0x4369 = Drawing.new("Circle")
_0x4369.Thickness = 1
_0x4369.Color = _0x4461._FOV_Color
_0x4369.Transparency = 0.7
_0x4369.Filled = false -- FORCES IT TO NOT BE SOLID WHITE
_0x4369.Visible = false

local _0x57 = _0x4c:CreateWindow({
    Name = "Aimbot | iruin hub",
    LoadingTitle = "Iruin Hub v5.5",
    ConfigurationSaving = { Enabled = false }
})

-- TABS
local _0x541 = _0x57:CreateTab("Aimbot", "crosshair")
local _0x542 = _0x57:CreateTab("NPCs", "bot")
local _0x546 = _0x57:CreateTab("Combat", "zap")
local _0x547 = _0x57:CreateTab("ESP", "eye")
local _0x543 = _0x57:CreateTab("FOV", "maximize")
local _0x544 = _0x57:CreateTab("Misc", "settings")

-- FOV TAB (With Color Picker)
_0x543:CreateSection("FOV Appearance")
_0x543:CreateToggle({Name = "Show FOV Circle", CurrentValue = true, Callback = function(v) _0x4461._0x5669 = v end})
_0x543:CreateSlider({Name = "FOV Size", Range = {10, 600}, Increment = 5, CurrentValue = 150, Callback = function(v) _0x4461._0x464f = v end})

_0x543:CreateColorPicker({
    Name = "FOV Circle Color",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(v) 
        _0x4461._FOV_Color = v 
        _0x4369.Color = v
    end
})

-- AIMBOT TAB
_0x541:CreateSection("Targeting")
_0x541:CreateToggle({Name = "Player Aimbot", CurrentValue = false, Callback = function(v) _0x4461._0x4c31 = v end})
_0x541:CreateToggle({Name = "Wall Check", CurrentValue = true, Callback = function(v) _0x4461._0x5743 = v end})

-- NPC TAB
_0x542:CreateSection("NPC Targeting")
_0x542:CreateToggle({Name = "NPC Aimbot", CurrentValue = false, Callback = function(v) _0x4461._0x4c32 = v end})

-- COMBAT TAB
_0x546:CreateSection("Farming")
_0x546:CreateToggle({Name = "Auto TP Kill", CurrentValue = false, Callback = function(v) _0x4461._AutoKill = v end})
_0x546:CreateToggle({Name = "Auto Clicker", CurrentValue = false, Callback = function(v) _0x4461._AutoClick = v end})

-- ESP TAB
_0x547:CreateSection("Visuals")
_0x547:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(v) _0x4461._ESP_Enabled = v end})

-- MISC TAB
_0x544:CreateSection("Character")
_0x544:CreateSlider({Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) _0x4461._0x5370 = v end})

-- TARGET FUNCTION
local function GetTarget(_type)
    local _target = nil
    local _dist = _0x4461._0x464f
    local _center = Vector2.new(_0x4361.ViewportSize.X/2, _0x4361.ViewportSize.Y/2)

    local function Check(_obj)
        if _obj and _obj:FindFirstChild("Humanoid") and _obj.Humanoid.Health > 0 then
            local part = _obj:FindFirstChild(_0x4461._0x426f)
            if part then
                local pos, onScreen = _0x4361:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - _center).Magnitude
                    if mag < _dist then _dist = mag; _target = _obj end
                end
            end
        end
    end

    if _type == "P" then
        for _, p in pairs(_0x50:GetPlayers()) do
            if p ~= _0x4c50 and p.Character then Check(p.Character) end
        end
    elseif _type == "N" then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and not _0x50:GetPlayerFromCharacter(v) then Check(v) end
        end
    end
    return _target
end

-- MAIN LOOP
_0x52.RenderStepped:Connect(function()
    -- FOV Update
    _0x4369.Visible = _0x4461._0x5669
    _0x4369.Radius = _0x4461._0x464f
    _0x4369.Position = Vector2.new(_0x4361.ViewportSize.X / 2, _0x4361.ViewportSize.Y / 2)
    _0x4369.Color = _0x4461._FOV_Color

    -- Aimbot
    local target = nil
    if _0x4461._0x4c31 then target = GetTarget("P") end
    if not target and _0x4461._0x4c32 then target = GetTarget("N") end
    if target then
        _0x4361.CFrame = _0x4361.CFrame:Lerp(CFrame.new(_0x4361.CFrame.Position, target[_0x4461._0x426f].Position), 0.2)
    end
    
    -- Auto TP
    if _0x4461._AutoKill and _0x4c50.Character then
        local t = GetTarget("P")
        if t and t:FindFirstChild("HumanoidRootPart") then
            _0x4c50.Character.HumanoidRootPart.CFrame = t.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end

    -- Auto Click Fix
    if _0x4461._AutoClick then
        VU:CaptureController()
        VU:Button1Down(Vector2.new(1,1), _0x4361.CFrame)
        task.wait(0.01)
        VU:Button1Up(Vector2.new(1,1), _0x4361.CFrame)
    end

    -- ESP Visuals
    for _, v in pairs(_0x50:GetPlayers()) do
        if v ~= _0x4c50 and v.Character then
            local h = v.Character:FindFirstChild("IruinESP")
            if _0x4461._ESP_Enabled then
                if not h then
                    h = Instance.new("Highlight", v.Character)
                    h.Name = "IruinESP"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            else
                if h then h:Destroy() end
            end
        end
    end

    -- WalkSpeed
    if _0x4c50.Character and _0x4c50.Character:FindFirstChild("Humanoid") then
        _0x4c50.Character.Humanoid.WalkSpeed = _0x4461._0x5370
    end
end)
