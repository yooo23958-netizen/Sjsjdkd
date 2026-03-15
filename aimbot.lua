--[[ 
    IRUIN HUB | v5.5.7
    Aimbot | NPC | Combat | ESP | Fixed FOV Visuals
]]

local _0x4c = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local _0x50 = game:GetService("Players")
local _0x52 = game:GetService("RunService")
local _0x4c50 = _0x50.LocalPlayer
local _0x4361 = workspace.CurrentCamera
local VU = game:GetService("VirtualUser")

local _0x4461 = {
    _0x4c31 = false, _0x4c32 = false, _0x5743 = true,
    _0x464f = 150, _0x5669 = true, _0x5370 = 16, _0x426f = "Head",
    _SnapSpeed = 0.2, _TPDelay = 0.5,
    _ESP_Enabled = false, _AutoKill = false, _AutoClick = false,
    _FOV_Color = Color3.fromRGB(255, 255, 255)
}

-- FOV FIX: Explicitly set Filled to false and Transparency to 0.5
local _0x4369 = Drawing.new("Circle")
_0x4369.Thickness = 1
_0x4369.Transparency = 0.5
_0x4369.Filled = false -- THIS STOPS THE SOLID WHITE BUG
_0x4369.Visible = false

local _0x57 = _0x4c:CreateWindow({
    Name = "Aimbot | iruin hub",
    LoadingTitle = "Iruin Hub v5.5.7",
    ConfigurationSaving = { Enabled = false }
})

-- TABS
local tabAim = _0x57:CreateTab("Aimbot", "crosshair")
local tabNpc = _0x57:CreateTab("NPCs", "bot")
local tabCombat = _0x57:CreateTab("Combat", "zap")
local tabEsp = _0x57:CreateTab("ESP", "eye")
local tabFov = _0x57:CreateTab("FOV", "maximize")
local tabMisc = _0x57:CreateTab("Misc", "settings")

-- UI SETUP
tabAim:CreateSection("Targeting")
tabAim:CreateToggle({Name = "Player Aimbot", CurrentValue = false, Callback = function(v) _0x4461._0x4c31 = v end})
tabAim:CreateToggle({Name = "Wall Check", CurrentValue = true, Callback = function(v) _0x4461._0x5743 = v end})
tabAim:CreateSlider({Name = "Snap Speed", Range = {0.1, 1}, Increment = 0.1, CurrentValue = 0.2, Callback = function(v) _0x4461._SnapSpeed = v end})
tabAim:CreateDropdown({Name = "Target Bone", Options = {"Head", "UpperTorso", "HumanoidRootPart"}, CurrentOption = "Head", Callback = function(v) _0x4461._0x426f = v end})

tabNpc:CreateToggle({Name = "NPC Aimbot", CurrentValue = false, Callback = function(v) _0x4461._0x4c32 = v end})

tabCombat:CreateToggle({Name = "Auto TP Kill", CurrentValue = false, Callback = function(v) _0x4461._AutoKill = v end})
tabCombat:CreateSlider({Name = "TP Wait Time", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) _0x4461._TPDelay = v end})
tabCombat:CreateToggle({Name = "Auto Clicker", CurrentValue = false, Callback = function(v) _0x4461._AutoClick = v end})

tabEsp:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(v) _0x4461._ESP_Enabled = v end})

tabFov:CreateToggle({Name = "Show FOV Circle", CurrentValue = true, Callback = function(v) _0x4461._0x5669 = v end})
tabFov:CreateSlider({Name = "FOV Size", Range = {10, 600}, Increment = 5, CurrentValue = 150, Callback = function(v) _0x4461._0x464f = v end})
tabFov:CreateColorPicker({Name = "FOV Color", Color = Color3.fromRGB(255, 255, 255), Callback = function(v) _0x4461._FOV_Color = v end})

tabMisc:CreateSlider({Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) _0x4461._0x5370 = v end})

-- LOGIC
local function IsVisible(part, character)
    if not _0x4461._0x5743 then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {_0x4c50.Character, _0x4361}
    local res = workspace:Raycast(_0x4361.CFrame.Position, (part.Position - _0x4361.CFrame.Position).Unit * 1000, params)
    return (res and res.Instance:IsDescendantOf(character)) or res == nil
end

local function GetTarget(_type)
    local _target, _dist = nil, _0x4461._0x464f
    local _center = Vector2.new(_0x4361.ViewportSize.X/2, _0x4361.ViewportSize.Y/2)
    local list = (_type == "P") and _0x50:GetPlayers() or workspace:GetChildren()
    for _, v in pairs(list) do
        local char = (_type == "P" and v ~= _0x4c50 and v.Character) or (not _0x50:GetPlayerFromCharacter(v) and v:IsA("Model") and v)
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local part = char:FindFirstChild(_0x4461._0x426f) or char:FindFirstChild("HumanoidRootPart")
            if part then
                local pos, vis = _0x4361:WorldToViewportPoint(part.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - _center).Magnitude
                    if mag < _dist and IsVisible(part, char) then _dist = mag; _target = char end
                end
            end
        end
    end
    return _target
end

local lastTP = tick()
local currentTargetIndex = 1
local function GetNextPlayer()
    local targets = {}
    for _, p in pairs(_0x50:GetPlayers()) do
        if p ~= _0x4c50 and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            table.insert(targets, p.Character)
        end
    end
    if #targets == 0 then return nil end
    if tick() - lastTP >= _0x4461._TPDelay then
        currentTargetIndex = (currentTargetIndex % #targets) + 1
        lastTP = tick()
    end
    return targets[currentTargetIndex]
end

-- LOOP
_0x52.RenderStepped:Connect(function()
    -- FOV VISUAL UPDATE
    _0x4369.Visible = _0x4461._0x5669
    _0x4369.Radius = _0x4461._0x464f
    _0x4369.Position = Vector2.new(_0x4361.ViewportSize.X / 2, _0x4361.ViewportSize.Y / 2)
    _0x4369.Color = _0x4461._FOV_Color

    local target = (_0x4461._0x4c31 and GetTarget("P")) or (_0x4461._0x4c32 and GetTarget("N"))
    if target then
        local b = target:FindFirstChild(_0x4461._0x426f) or target:FindFirstChild("HumanoidRootPart")
        if b then _0x4361.CFrame = _0x4361.CFrame:Lerp(CFrame.new(_0x4361.CFrame.Position, b.Position), _0x4461._SnapSpeed) end
    end
    
    if _0x4461._AutoKill and _0x4c50.Character then
        local t = GetNextPlayer()
        if t then _0x4c50.Character:PivotTo(t.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)) end
    end

    if _0x4461._AutoClick then
        VU:CaptureController()
        VU:Button1Down(Vector2.new(1,1), _0x4361.CFrame)
        task.wait(0.01)
        VU:Button1Up(Vector2.new(1,1), _0x4361.CFrame)
    end

    -- ESP & WALKSPEED UPDATE
    for _, v in pairs(_0x50:GetPlayers()) do
        if v ~= _0x4c50 and v.Character then
            local h = v.Character:FindFirstChild("IruinESP")
            if _0x4461._ESP_Enabled then
                if not h then h = Instance.new("Highlight", v.Character) h.Name = "IruinESP" h.FillColor = Color3.fromRGB(255, 0, 0) end
            elseif h then h:Destroy() end
        end
    end
    if _0x4c50.Character and _0x4c50.Character:FindFirstChild("Humanoid") then
        _0x4c50.Character.Humanoid.WalkSpeed = _0x4461._0x5370
    end
end)
