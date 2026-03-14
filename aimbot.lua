local _0x4c = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local _0x50 = game:GetService("Players")
local _0x52 = game:GetService("RunService")
local _0x4c50 = _0x50.LocalPlayer
local _0x4361 = workspace.CurrentCamera

local _0x4461 = {
    _0x4c31 = false, _0x5443 = false, _0x464f = 150, 
    _0x5669 = true, _0x5370 = 16, _0x426f = "Head"
}

-- FOV Circle with Wall-Transparency Fix
local _0x4369 = Drawing.new("Circle")
_0x4369.Thickness = 1
_0x4369.Color = Color3.fromRGB(255, 255, 255)
_0x4369.Transparency = 0.6
_0x4369.Visible = false

local _0x57 = _0x4c:CreateWindow({
    Name = "Iruin Hub | WallCheck Active",
    ConfigurationSaving = { Enabled = false }
})

-- THE WALL CHECK LOGIC
local function _0x5743(_0x70, _0x6d)
    local _0x72 = RaycastParams.new()
    _0x72.FilterDescendantsInstances = {_0x4c50.Character, _0x4361, _0x6d}
    _0x72.FilterType = Enum.RaycastFilterType.Exclude
    -- Casts a line to see if a wall is in between
    local _0x727 = workspace:Raycast(_0x4361.CFrame.Position, (_0x70.Position - _0x4361.CFrame.Position), _0x72)
    return _0x727 == nil
end

local function _0x4765()
    local _0x74 = nil
    local _0x73 = _0x4461._0x464f
    local _0x63 = Vector2.new(_0x4361.ViewportSize.X / 2, _0x4361.ViewportSize.Y / 2)

    for _, v in pairs(_0x50:GetPlayers()) do
        if v ~= _0x4c50 and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if _0x4461._0x5443 and v.Team == _0x4c50.Team then continue end
            
            local _0x70 = v.Character:FindFirstChild(_0x4461._0x426f)
            if _0x70 then
                local _0x737, _0x6f7 = _0x4361:WorldToViewportPoint(_0x70.Position)
                if _0x6f7 then
                    local _0x6d2 = (Vector2.new(_0x737.X, _0x737.Y) - _0x63).Magnitude
                    if _0x6d2 < _0x73 then
                        -- CALLING WALL CHECK HERE
                        if _0x5743(_0x70, v.Character) then
                            _0x73 = _0x6d2
                            _0x74 = v.Character
                        end
                    end
                end
            end
        end
    end
    return _0x74
end

-- TABS
local _0x541 = _0x57:CreateTab("Players", "user")
local _0x543 = _0x57:CreateTab("Misc", "settings")

_0x541:CreateToggle({Name = "Aimbot + WallCheck", CurrentValue = false, Callback = function(v) _0x4461._0x4c31 = v end})
_0x541:CreateToggle({Name = "Team Check", CurrentValue = false, Callback = function(v) _0x4461._0x5443 = v end})
_0x541:CreateSlider({Name = "FOV Radius", Range = {10, 600}, Increment = 5, CurrentValue = 150, Callback = function(v) _0x4461._0x464f = v end})
_0x541:CreateToggle({Name = "Show FOV", CurrentValue = true, Callback = function(v) _0x4461._0x5669 = v end})

_0x543:CreateSlider({Name = "Speed", Range = {16, 200}, Increment = 1, CurrentValue = 16, Callback = function(v) _0x4461._0x5370 = v end})

_0x52.RenderStepped:Connect(function()
    _0x4369.Visible = _0x4461._0x5669
    _0x4369.Radius = _0x4461._0x464f
    _0x4369.Position = Vector2.new(_0x4361.ViewportSize.X / 2, _0x4361.ViewportSize.Y / 2)

    if _0x4461._0x4c31 then
        local _0x74 = _0x4765()
        if _0x74 then
            _0x4361.CFrame = _0x4361.CFrame:Lerp(CFrame.new(_0x4361.CFrame.Position, _0x74[_0x4461._0x426f].Position), 0.2)
        end
    end
    
    if _0x4c50.Character and _0x4c50.Character:FindFirstChild("Humanoid") then
        _0x4c50.Character.Humanoid.WalkSpeed = _0x4461._0x5370
    end
end)
