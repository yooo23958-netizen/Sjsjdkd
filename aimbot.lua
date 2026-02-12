local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- STATE MANAGEMENT
local state = {
    enabled = false,
    lockValue = 100,
    rangeValue = 1000,
    npcFolderName = "NPCs",
    espEnabled = false,
    visCheck = false -- New: Only aim if NPC is visible
}

local npcCache = {}
local lastNpcRefresh = 0
local NPC_REFRESH_INTERVAL = 1.0
local AIM_RATE = 20 

-- HELPER: Visibility Check
local function isVisible(targetPart)
    if not state.visCheck then return true end
    local char = player.Character
    if not char then return false end
    
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char, targetPart.Parent}
    params.FilterType = Enum.RaycastFilterType.Exclude
    
    local result = workspace:Raycast(camera.CFrame.Position, (targetPart.Position - camera.CFrame.Position).Unit * 500, params)
    return result == nil -- If nil, nothing hit between camera and target
end

-- HELPER: Cache NPCs
local function rebuildNpcCache()
    local newCache = {}
    local searchRoot = workspace:FindFirstChild(state.npcFolderName) or workspace
    
    for _, obj in ipairs(searchRoot:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(obj) and obj ~= player.Character then
                table.insert(newCache, obj)
            end
        end
    end
    npcCache = newCache
end

-- WINDOW SETUP
local Window = Rayfield:CreateWindow({
    Name = "Aimbot — NPC Edition",
    LoadingTitle = "Initializing...",
    LoadingSubtitle = "by Gemini",
    ConfigurationSaving = { Enabled = true, FolderName = "NPCAimbot", FileName = "Config" }
})

-- MAIN TAB
local MainTab = Window:CreateTab("Aimbot", 4483362458)

local Toggle = MainTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "AimToggle", 
    Callback = function(Value) state.enabled = Value end,
})

MainTab:CreateKeybind({
    Name = "Toggle Keybind",
    CurrentKeybind = "E",
    Flag = "AimBind",
    Callback = function() 
        state.enabled = not state.enabled
        Toggle:Set(state.enabled)
    end,
})

MainTab:CreateToggle({
    Name = "Visibility Check",
    CurrentValue = false,
    Flag = "VisCheck",
    Callback = function(Value) state.visCheck = Value end,
})

MainTab:CreateSlider({
    Name = "Aim Smoothness",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 50,
    Flag = "Smooth",
    Callback = function(Value) state.lockValue = Value end,
})

MainTab:CreateSlider({
    Name = "Max Range",
    Range = {0, 2000},
    Increment = 50,
    CurrentValue = 1000,
    Flag = "Range",
    Callback = function(Value) state.rangeValue = Value end,
})

-- VISUALS TAB
local VisTab = Window:CreateTab("Visuals", 4483362458)

VisTab:CreateToggle({
    Name = "NPC ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value) 
        state.espEnabled = Value 
        if not Value then
            for _, v in ipairs(game.CoreGui:GetChildren()) do
                if v.Name == "NPC_ESP" then v:Destroy() end
            end
        end
    end,
})

-- FUNCTION: Update ESP
local function updateESP(model)
    if not state.espEnabled then return end
    local head = model:FindFirstChild("Head")
    if not head or game.CoreGui:FindFirstChild(model.Name .. "_ESP") then return end

    local bgui = Instance.new("BillboardGui", game.CoreGui)
    bgui.Name = "NPC_ESP"
    bgui.Adornee = head
    bgui.AlwaysOnTop = true
    bgui.Size = UDim2.new(0, 100, 0, 50)
    bgui.StudsOffset = Vector3.new(0, 3, 0)

    local tl = Instance.new("TextLabel", bgui)
    tl.BackgroundTransparency = 1
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.Text = model.Name
    tl.TextColor3 = Color3.fromRGB(255, 50, 50)
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 12

    local high = Instance.new("Highlight", bgui)
    high.Adornee = model
    high.FillTransparency = 0.6
    high.FillColor = Color3.fromRGB(255, 50, 50)
end

-- MAIN LOOP
RunService.RenderStepped:Connect(function(dt)
    if tick() - lastNpcRefresh >= NPC_REFRESH_INTERVAL then
        rebuildNpcCache()
        lastNpcRefresh = tick()
    end

    local origin = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not origin then return end

    local nearest, dist = nil, state.rangeValue
    for _, npc in ipairs(npcCache) do
        if npc and npc.Parent and npc:FindFirstChild("HumanoidRootPart") and npc.Humanoid.Health > 0 then
            
            -- Update ESP if enabled
            if state.espEnabled then updateESP(npc) end

            -- Find Nearest for Aimbot
            local hrp = npc.HumanoidRootPart
            local d = (hrp.Position - origin.Position).Magnitude
            if d < dist and isVisible(hrp) then
                nearest = hrp
                dist = d
            end
        end
    end

    if state.enabled and nearest then
        local alpha = math.clamp(1 - (state.lockValue / 100), 0.01, 1)
        local goal = CFrame.new(camera.CFrame.Position, nearest.Position)
        camera.CFrame = camera.CFrame:Lerp(goal, alpha)
    end
end)

Rayfield:Notify({Title = "Gemini Aimbot", Content = "Script Loaded Successfully", Duration = 3})
