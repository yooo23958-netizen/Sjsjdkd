--[[ 
    IRUIN HUB | DELTA EDITION v4.3
    Aimbot | iruin hub
]]

local _0x4c = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local _0x50 = game:GetService("Players")
local _0x52 = game:GetService("RunService")
local _0x4c50 = _0x50.LocalPlayer
local _0x4361 = workspace.CurrentCamera

local _0x4461 = {
    _0x4c31 = false, _0x4c32 = false, _0x5743 = true, _0x5443 = false, 
    _0x464f = 150, _0x5669 = true, _0x5370 = 16, _0x426f = "Head"
}

-- FOV RING PROTECTION
local _0x4369 = Drawing.new("Circle")
_0x4369.Thickness = 1
_0x4369.Color = Color3.fromRGB(255, 255, 255)
_0x4369.Transparency = 0.5
_0x4369.Filled = false
_0x4369.Visible = false

local _0x57 = _0x4c:CreateWindow({
    Name = "Aimbot | iruin hub", -- Clean Title
    LoadingTitle = "Iruin Hub",
    ConfigurationSaving = { Enabled = false }
})

local function _0x5243(_0x70, _0x6d)
    if not _0x4461._0x5743 then return true end
    local _0x72 = RaycastParams.new()
    _0x72.FilterDescendantsInstances = {_0x4c50.Character, _0x4361, _0x6d}
    _0x72.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(_0x4361.CFrame.Position, (_0x70.Position - _0x4361.CFrame.Position), _0x72)
    return result == nil
end

local function _0x4765(_0x6d6f)
    local _0x74 = nil
    local _0x73 = _0x4461._0x464f
    local _0x63 = Vector2.new(_0x4361.ViewportSize.X / 2, _0x4361.ViewportSize.Y / 2)

    local function _0x76(_0x6f)
        if _0x6f and _0x6f:FindFirstChild("Humanoid") and _0x6f.Humanoid.Health > 0 then
            local _0x70 = _0x6f:FindFirstChild(_0x4461._0x426f)
            if _0x70 then
                local _0x737, _0x6f7 = _0x4361:WorldToViewportPoint(_0x70.Position)
                if _0x6f7 then
                    local _0x6d2 = (Vector2.new(_0x737.X, _0x737.Y) - _0x63).Magnitude
                    if _0x6d2 < _0x73 and _0x5243(_0x70, _0x6f) then
                        _0x73 = _0x6d2
                        _0x74 = _0x6f
                    end
                end
            end
        end
    end

    if _0x6d6f == "P" then
        for _, v in pairs(_0x50:GetPlayers()) do
            if v ~= _0x4c50 and v.Character then
                if _0x4461._0x5443 and v.Team == _0x4c50.Team then continue end
                _0x76(v.Character)
            end
        end
    elseif _0x6d6f == "N" then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and not _0x50:GetPlayerFromCharacter(v) then _0x76(v) end
        end
    end
    return _0x74
end

-- TABS
local _0x541 = _0x57:CreateTab("Player Tab", "user")
local _0x542 = _0x57:CreateTab("NPC Tab", "bot")
local _0x543 = _0x57:CreateTab("FOV Tab", "eye")
local _0x544 = _0x57:CreateTab("Misc Tab", "settings")
local _0x545 = _0x57:CreateTab("Credits", "info")

-- PLAYER TAB
_0x541:CreateToggle({Name = "Player Aimbot", CurrentValue = false, Callback = function(v) _0x4461._0x4c31 = v end})
_0x541:CreateToggle({Name = "Wall Check", CurrentValue = true, Callback = function(v) _0x4461._0x5743 = v end})
_0x541:CreateToggle({Name = "Team Check", CurrentValue = false, Callback = function(v) _0x4461._0x5443 = v end})

-- NPC TAB
_0x542:CreateToggle({Name = "NPC Aimbot", CurrentValue = false, Callback = function(v) _0x4461._0x4c32 = v end})

-- FOV TAB
_0x543:CreateSlider({Name = "FOV Radius", Range = {10, 600}, Increment = 5, CurrentValue = 150, Callback = function(v) _0x4461._0x464f = v end})
_0x543:CreateToggle({Name = "Show FOV Circle", CurrentValue = true, Callback = function(v) _0x4461._0x5669 = v end})

-- MISC TAB
_0x544:CreateSlider({Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) _0x4461._0x5370 = v end})
_0x544:CreateButton({Name = "Destroy GUI", Callback = function() _0x4369:Remove() _0x4c:Destroy() end})

-- CREDITS TAB
_0x545:CreateSection("Script Owner")
_0x545:CreateLabel("yooo23958@gmail.com") -- Email moved here
_0x545:CreateParagraph({Title = "Support", Content = "Contact the email above for bugs or suggestions."})

_0x52.RenderStepped:Connect(function()
    _0x4369.Visible = _0x4461._0x5669
    _0x4369.Radius = _0x4461._0x464f
    _0x4369.Position = Vector2.new(_0x4361.ViewportSize.X / 2, _0x4361.ViewportSize.Y / 2)

    local target = nil
    if _0x4461._0x4c31 then target = _0x4765("P") elseif _0x4461._0x4c32 then target = _0x4765("N") end

    if target then
        _0x4361.CFrame = _0x4361.CFrame:Lerp(CFrame.new(_0x4361.CFrame.Position, target[_0x4461._0x426f].Position), 0.25)
    end
    
    if _0x4c50.Character and _0x4c50.Character:FindFirstChild("Humanoid") then
        _0x4c50.Character.Humanoid.WalkSpeed = _0x4461._0x5370
    end
end)
