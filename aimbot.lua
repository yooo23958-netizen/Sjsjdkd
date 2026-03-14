--[[ 
    PROTECTED BY IRUIN OBFUSCATOR 
    OPTIMIZED FOR DELTA EXECUTOR 
]]

local _0x4c6f6164 = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local _0x506c = game:GetService("Players")
local _0x52756e = game:GetService("RunService")
local _0x4c50 = _0x506c.LocalPlayer
local _0x43616d = workspace.CurrentCamera

local _0x44617461 = {
    _0x4c31 = false, _0x4c32 = false, _0x5443 = false, 
    _0x464f56 = 150, _0x566973 = true, _0x537064 = 16, _0x426f6e65 = "Head"
}

local _0x436972 = Drawing.new("Circle")
_0x436972.Thickness = 2
_0x436972.Color = Color3.fromRGB(255, 255, 255)
_0x436972.Visible = false

local _0x57696e = _0x4c6f6164:CreateWindow({
    Name = "Iruin Hub | Delta",
    LoadingTitle = "Decrypting Assets...",
    ConfigurationSaving = { Enabled = false }
})

local function _0x476574(_0x6d)
    local _0x74 = nil
    local _0x7364 = _0x44617461._0x464f56
    local _0x63656e = Vector2.new(_0x43616d.ViewportSize.X / 2, _0x43616d.ViewportSize.Y / 2)

    local function _0x76616c(_0x6f)
        if _0x6f and _0x6f:FindFirstChild("Humanoid") and _0x6f.Humanoid.Health > 0 then
            local _0x70 = _0x6f:FindFirstChild(_0x44617461._0x426f6e65)
            if not _0x70 then return end
            local _0x7370, _0x6f73 = _0x43616d:WorldToViewportPoint(_0x70.Position)
            if _0x6f73 then
                local _0x6d = (Vector2.new(_0x7370.X, _0x7370.Y) - _0x63656e).Magnitude
                if _0x6d < _0x7364 then
                    _0x7364 = _0x6d
                    _0x74 = _0x6f
                end
            end
        end
    end

    if _0x6d == "P" then
        for _, v in pairs(_0x506c:GetPlayers()) do
            if v ~= _0x4c50 and v.Character then
                if _0x44617461._0x5443 and v.Team == _0x4c50.Team then continue end
                _0x76616c(v.Character)
            end
        end
    elseif _0x6d == "N" then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and not _0x506c:GetPlayerFromCharacter(v) then _0x76616c(v) end
        end
    end
    return _0x74
end

local _0x5431 = _0x57696e:CreateTab("Players", "user")
local _0x5432 = _0x57696e:CreateTab("NPCs", "bot")
local _0x5433 = _0x57696e:CreateTab("Misc", "settings")

_0x5431:CreateToggle({Name = "Player Aimbot", CurrentValue = false, Callback = function(v) _0x44617461._0x4c31 = v end})
_0x5431:CreateToggle({Name = "Team Check", CurrentValue = false, Callback = function(v) _0x44617461._0x5443 = v end})

_0x5432:CreateToggle({Name = "NPC Aimbot", CurrentValue = false, Callback = function(v) _0x44617461._0x4c32 = v end})

_0x5433:CreateSlider({Name = "WalkSpeed", Range = {16, 200}, Increment = 1, CurrentValue = 16, Callback = function(v) _0x44617461._0x537064 = v end})
_0x5433:CreateSlider({Name = "FOV Radius", Range = {10, 600}, Increment = 5, CurrentValue = 150, Callback = function(v) _0x44617461._0x464f56 = v end})
_0x5433:CreateToggle({Name = "Show FOV", CurrentValue = true, Callback = function(v) _0x44617461._0x566973 = v end})

_0x52756e.RenderStepped:Connect(function()
    _0x436972.Visible = _0x44617461._0x566973
    _0x436972.Radius = _0x44617461._0x464f56
    _0x436972.Position = Vector2.new(_0x43616d.ViewportSize.X / 2, _0x43616d.ViewportSize.Y / 2)

    local _0x74 = nil
    if _0x44617461._0x4c31 then _0x74 = _0x476574("P") elseif _0x44617461._0x4c32 then _0x74 = _0x476574("N") end

    if _0x74 then
        _0x43616d.CFrame = _0x43616d.CFrame:Lerp(CFrame.new(_0x43616d.CFrame.Position, _0x74[_0x44617461._0x426f6e65].Position), 0.3)
    end
    
    if _0x4c50.Character and _0x4c50.Character:FindFirstChild("Humanoid") then
        _0x4c50.Character.Humanoid.WalkSpeed = _0x44617461._0x537064
    end
end)
