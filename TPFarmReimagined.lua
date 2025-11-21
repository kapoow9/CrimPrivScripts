--////////////////////////////////////////////////////////
--           LOCAL SCRIPT: "Black Hub (Optimized)"
--////////////////////////////////////////////////////////

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-------------------------------------------------------------------------------
--    1. Glassy visual with ocean gradient and soft accents
-------------------------------------------------------------------------------
local theme = {
    background = Color3.fromRGB(12, 14, 22),
    panel = Color3.fromRGB(20, 24, 32),
    card = Color3.fromRGB(26, 30, 40),
    accent = Color3.fromRGB(0, 185, 206),
    accent2 = Color3.fromRGB(0, 125, 255),
    text = Color3.fromRGB(236, 240, 245),
    muted = Color3.fromRGB(155, 166, 178),
    stroke = Color3.fromRGB(58, 68, 86),
    buttonOff = Color3.fromRGB(36, 42, 54)
}

local quickTween = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VenomHubScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local blurEffect
pcall(function()
    blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "VenomHubBlur"
    blurEffect.Size = 0
    blurEffect.Parent = workspace.CurrentCamera
end)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "VenomHubMainFrame"
mainFrame.Size = UDim2.new(0, 440, 0, 500)
mainFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
mainFrame.BackgroundColor3 = theme.panel
mainFrame.BackgroundTransparency = 0.05
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Selectable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = theme.stroke
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.35
mainStroke.Parent = mainFrame

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, theme.accent),
    ColorSequenceKeypoint.new(1, theme.panel)
})
mainGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(0.5, 0.6),
    NumberSequenceKeypoint.new(1, 0.9)
})
mainGradient.Rotation = 90
mainGradient.Parent = mainFrame

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, -32, 0, 88)
header.Position = UDim2.new(0, 16, 0, 14)
header.BackgroundColor3 = theme.card
header.BackgroundTransparency = 0.05
header.Active = true
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local headerStroke = Instance.new("UIStroke")
headerStroke.Color = theme.stroke
headerStroke.Transparency = 0.35
headerStroke.Parent = header

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 160, 220)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 210, 190)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 255))
})
headerGradient.Rotation = 45
headerGradient.Parent = header
TweenService:Create(headerGradient, TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(1, 0)}):Play()

local headerPadding = Instance.new("UIPadding")
headerPadding.PaddingLeft = UDim.new(0, 16)
headerPadding.PaddingRight = UDim.new(0, 16)
headerPadding.PaddingTop = UDim.new(0, 12)
headerPadding.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -120, 0, 26)
title.BackgroundTransparency = 1
title.Text = "StandFarm Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = theme.text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Position = UDim2.new(0, 0, 0, 32)
subtitle.Size = UDim2.new(1, -120, 0, 22)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Press K to show/hide - drag the top bar"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.TextColor3 = theme.muted
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -32, 1, -170)
contentFrame.Position = UDim2.new(0, 16, 0, 116)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
contentFrame.ScrollBarThickness = 5
contentFrame.ScrollBarImageColor3 = theme.accent
contentFrame.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.Parent = contentFrame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingLeft = UDim.new(0, 4)
contentPadding.PaddingRight = UDim.new(0, 4)
contentPadding.Parent = contentFrame

--    2. Dragging window by header
-------------------------------------------------------------------------------
do
    local dragging = false
    local dragOffset = Vector2.new()
    local dragAreaHeight = 90

    local function inDragArea(pos)
        local topLeft = mainFrame.AbsolutePosition
        local relY = pos.Y - topLeft.Y
        return relY >= 0 and relY <= dragAreaHeight
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and inDragArea(input.Position) then
            dragging = true
            dragOffset = input.Position - mainFrame.AbsolutePosition
        end
    end)

    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local newPosition = input.Position - dragOffset
            mainFrame.Position = UDim2.fromOffset(newPosition.X, newPosition.Y)
        end
    end)
end

--    3. Key [K] toggles visibility with blur
-------------------------------------------------------------------------------
local hubVisible = false

local function setHubVisible(state)
    hubVisible = state
    mainFrame.Visible = state
    contentFrame.CanvasPosition = Vector2.new(0, 0)
    if blurEffect then
        TweenService:Create(blurEffect, quickTween, {Size = state and 14 or 0}):Play()
    end
end

setHubVisible(false)

task.spawn(function()
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "StandFarm Hub",
            Text = "Press K to toggle the menu",
            Duration = 6
        })
    end)
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.K then
        setHubVisible(not hubVisible)
    end
end)

screenGui.AncestryChanged:Connect(function(_, parent)
    if not parent and blurEffect then
        blurEffect:Destroy()
    end
end)

-------------------------------------------------------------------------------
--    4. Script variables and actions
-------------------------------------------------------------------------------
--============================ Fly ============================--
local Fly_Enabled = false
local Fly_Bind = nil
local Fly_Connection
local Fly_Speed = 50

local function Fly_Enable()
    if Fly_Enabled then return end
    Fly_Enabled = true

    Fly_Connection = RunService.RenderStepped:Connect(function(dt)
        if not Fly_Enabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local cam = workspace.CurrentCamera
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir += cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir -= cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir -= cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir += cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir += Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir -= Vector3.new(0,1,0)
            end

            if moveDir.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (moveDir.Unit * Fly_Speed * dt)
            end
        end
    end)
end

local function Fly_Disable()
    if not Fly_Enabled then return end
    Fly_Enabled = false
    if Fly_Connection then
        Fly_Connection:Disconnect()
        Fly_Connection = nil
    end
end

--========================== Anti AFK ===========================--
local AntiAFK_Enabled = false
local AntiAFK_IdledConnection
local AntiAFK_Coroutine

local function AntiAFK_DoAction()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:SetKeyDown('0x20')  -- space
        task.wait(0.1)
        VirtualUser:SetKeyUp('0x20')
    end)
    pcall(function()
        local camera = workspace.CurrentCamera
        camera.CFrame = camera.CFrame * CFrame.Angles(math.rad(0.5), 0, 0)
        task.wait(0.1)
        camera.CFrame = camera.CFrame * CFrame.Angles(math.rad(-0.5), 0, 0)
    end)
end

local function AntiAFK_Enable()
    if AntiAFK_Enabled then return end
    AntiAFK_Enabled = true

    local player = LocalPlayer
    AntiAFK_IdledConnection = player.Idled:Connect(function()
        if AntiAFK_Enabled then
            AntiAFK_DoAction()
        end
    end)

    AntiAFK_Coroutine = coroutine.create(function()
        while AntiAFK_Enabled do
            AntiAFK_DoAction()
            task.wait(30)
        end
    end)
    coroutine.resume(AntiAFK_Coroutine)
end

local function AntiAFK_Disable()
    if not AntiAFK_Enabled then return end
    AntiAFK_Enabled = false

    if AntiAFK_IdledConnection then
        AntiAFK_IdledConnection:Disconnect()
        AntiAFK_IdledConnection = nil
    end
    AntiAFK_Coroutine = nil
end

--=================== Melee Aura 4 Alt MAX! =====================--
local MeleeAura_Enabled = false
local MeleeAura_Connection

local runAttackLoop do
    local plrs = game:GetService("Players")
    local me = plrs.LocalPlayer
    local run = game:GetService("RunService")

    local remote1 = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("XMHH.2")
    local remote2 = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("XMHH2.2")

    local maxdist = 20

    local function Attack(target)
        if not (target and target:FindFirstChild("Head")) then return end
        local arg1 = {
            [1] = "🍞",
            [2] = tick(),
            [3] = me.Character and me.Character:FindFirstChildOfClass("Tool"),
            [4] = "43TRFWX",
            [5] = "Normal",
            [6] = tick(),
            [7] = true
        }
        local result = remote1:InvokeServer(unpack(arg1))
        task.wait(0.5)

        local tool = me.Character and me.Character:FindFirstChildOfClass("Tool")
        if tool then
            local Handle = tool:FindFirstChild("WeaponHandle") or tool:FindFirstChild("Handle")
                          or me.Character:FindFirstChild("Right Arm")
            if Handle and target:FindFirstChild("Head") then
                local arg2 = {
                    [1] = "🍞",
                    [2] = tick(),
                    [3] = tool,
                    [4] = "2389ZFX34",
                    [5] = result,
                    [6] = false,
                    [7] = Handle,
                    [8] = target:FindFirstChild("Head"),
                    [9] = target,
                    [10] = me.Character:FindFirstChild("HumanoidRootPart").Position,
                    [11] = target:FindFirstChild("Head").Position
                }
                remote2:FireServer(unpack(arg2))
            end
        end
    end

    runAttackLoop = function()
        return run.RenderStepped:Connect(function()
            if not MeleeAura_Enabled then return end
            local char = me.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, plr in ipairs(plrs:GetPlayers()) do
                    if plr ~= me then
                        local c = plr.Character
                        local hrp2 = c and c:FindFirstChild("HumanoidRootPart")
                        local hum = c and c:FindFirstChildOfClass("Humanoid")
                        if hrp2 and hum then
                            local dist = (hrp.Position - hrp2.Position).Magnitude
                            if dist < maxdist and hum.Health > 15 and not c:FindFirstChildOfClass("ForceField") then
                                Attack(c)
                            end
                        end
                    end
                end
            end
        end)
    end
end

local function MeleeAura_Enable()
    if MeleeAura_Enabled then return end
    MeleeAura_Enabled = true
    MeleeAura_Connection = runAttackLoop()
end

local function MeleeAura_Disable()
    if not MeleeAura_Enabled then return end
    MeleeAura_Enabled = false

    if MeleeAura_Connection then
        MeleeAura_Connection:Disconnect()
        MeleeAura_Connection = nil
    end
end

--======================= Teleport Farm =========================--
local TPFarm_Enabled = false
local TPFarm_TargetName = "selimkarakutuk296"

-- Keep connections to cleanly disconnect on Disable
local TPFarm_SteppedConnection = nil
local TPFarm_RenderConnection = nil
local TPFarm_CharConnection = nil
local DeathRespawn_Event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DeathRespawn")

-- Runs whenever the character spawns (CharacterAdded)
local function TPFarm_OnCharacterAdded(char)
    -- Safety: disconnect stale stepped connection if present
    if TPFarm_SteppedConnection then
        TPFarm_SteppedConnection:Disconnect()
        TPFarm_SteppedConnection = nil
    end

    -- Tiny delay so HumanoidRootPart exists
    task.wait(0.4)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum) then return end

    -- Follow the main target each Stepped
    TPFarm_SteppedConnection = RunService.Stepped:Connect(function()
        if not TPFarm_Enabled then return end
        local mainPlayer = Players:FindFirstChild(TPFarm_TargetName)
        local mainChar = mainPlayer and mainPlayer.Character
        local mainHRP = mainChar and mainChar:FindFirstChild("HumanoidRootPart")
        if mainHRP then
            -- Stay 3 studs ahead of the target
            hrp.CFrame = mainHRP.CFrame + (mainHRP.CFrame.LookVector * 3)

            -- Connect once to force respawn when health changes
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                hum.Health = 0
            end)
        end
    end)
end

local function TPFarm_Enable()
    if TPFarm_Enabled then return end
    TPFarm_Enabled = true

    local me = LocalPlayer

    -- If character already exists
    if me.Character then
        TPFarm_OnCharacterAdded(me.Character)
    end

    -- Track respawns
    TPFarm_CharConnection = me.CharacterAdded:Connect(function(newChar)
        if not TPFarm_Enabled then return end
        TPFarm_OnCharacterAdded(newChar)

        -- Auto equip first tool
        local tool = me.Backpack:FindFirstChildOfClass("Tool")
        if tool and newChar then
            tool.Parent = newChar
        end
    end)

    -- Auto respawn if dead
    TPFarm_RenderConnection = RunService.RenderStepped:Connect(function()
        if not TPFarm_Enabled then return end
        local char = me.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then
                DeathRespawn_Event:InvokeServer("KMG4R904")
            end
        end
    end)
end

local function TPFarm_Disable()
    if not TPFarm_Enabled then return end
    TPFarm_Enabled = false

    if TPFarm_SteppedConnection then
        TPFarm_SteppedConnection:Disconnect()
        TPFarm_SteppedConnection = nil
    end
    if TPFarm_RenderConnection then
        TPFarm_RenderConnection:Disconnect()
        TPFarm_RenderConnection = nil
    end
    if TPFarm_CharConnection then
        TPFarm_CharConnection:Disconnect()
        TPFarm_CharConnection = nil
    end
end

--================= 3 Save buttons (Cube/Vibecheck/Mountain) =======
local event = DeathRespawn_Event  -- shorter alias

-- 1) Save Cube
local SaveCube_Enabled = false
local SaveCube_Connection
local SaveCube_Position = Vector3.new(-4184.4, 102.7, 276.9)

local function SaveCube_Enable()
    if SaveCube_Enabled then return end
    SaveCube_Enabled = true

    SaveCube_Connection = RunService.RenderStepped:Connect(function()
        if not SaveCube_Enabled then return end
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp then
                hrp.CFrame = CFrame.new(SaveCube_Position)
            end
            if hum and hum.Health <= 0 then
                event:InvokeServer("KMG4R904") -- auto respawn
            end
        end
    end)
end

local function SaveCube_Disable()
    if not SaveCube_Enabled then return end
    SaveCube_Enabled = false
    if SaveCube_Connection then
        SaveCube_Connection:Disconnect()
        SaveCube_Connection = nil
    end
end

-- 2) Save Vibecheck
local SaveVibe_Enabled = false
local SaveVibe_Connection
local SaveVibe_Position = Vector3.new(-4857.5, -161.5, -918.3)

local function SaveVibe_Enable()
    if SaveVibe_Enabled then return end
    SaveVibe_Enabled = true

    SaveVibe_Connection = RunService.RenderStepped:Connect(function()
        if not SaveVibe_Enabled then return end
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp then
                hrp.CFrame = CFrame.new(SaveVibe_Position)
            end
            if hum and hum.Health <= 0 then
                event:InvokeServer("KMG4R904")
            end
        end
    end)
end

local function SaveVibe_Disable()
    if not SaveVibe_Enabled then return end
    SaveVibe_Enabled = false
    if SaveVibe_Connection then
        SaveVibe_Connection:Disconnect()
        SaveVibe_Connection = nil
    end
end

-- 3) Save Mountain
local SaveMount_Enabled = false
local SaveMount_Connection
local SaveMount_Position = Vector3.new(-5169.8, 102.6, -515.5)

local function SaveMount_Enable()
    if SaveMount_Enabled then return end
    SaveMount_Enabled = true

    SaveMount_Connection = RunService.RenderStepped:Connect(function()
        if not SaveMount_Enabled then return end
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp then
                hrp.CFrame = CFrame.new(SaveMount_Position)
            end
            if hum and hum.Health <= 0 then
                event:InvokeServer("KMG4R904")
            end
        end
    end)
end

local function SaveMount_Disable()
    if not SaveMount_Enabled then return end
    SaveMount_Enabled = false
    if SaveMount_Connection then
        SaveMount_Connection:Disconnect()
        SaveMount_Connection = nil
    end
end

-------------------------------------------------------------------------------
--    5. Control cards (toggle + bind + input)
-------------------------------------------------------------------------------
local function createSectionLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 26)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextColor3 = theme.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 52, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = theme.accent
    line.Parent = label

    return label
end

local function createToggleRow(parent, scriptName, canToggle, isEnabledFn, onEnable, onDisable, getKeyBindFn, setKeyBindFn)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = theme.card
    frame.BackgroundTransparency = 0.08
    frame.ClipsDescendants = true
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.stroke
    stroke.Transparency = 0.35
    stroke.Parent = frame

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 5, 1, 0)
    accent.Position = UDim2.new(0, -2, 0, 0)
    accent.BackgroundColor3 = theme.accent
    accent.Parent = frame

    local accentGradient = Instance.new("UIGradient")
    accentGradient.Color = ColorSequence.new(theme.accent, theme.accent2)
    accentGradient.Rotation = 90
    accentGradient.Parent = accent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -210, 0, 24)
    label.Position = UDim2.new(0, 14, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = scriptName
    label.TextColor3 = theme.text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 94, 0, 32)
    button.Position = UDim2.new(1, -102, 0, 14)
    button.BackgroundColor3 = theme.buttonOff
    button.AutoButtonColor = false
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Text = canToggle and "OFF" or "RUN"
    button.TextColor3 = theme.text
    button.Parent = frame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 9)
    buttonCorner.Parent = button

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = theme.stroke
    buttonStroke.Transparency = 0.35
    buttonStroke.Parent = button

    local bindButton = Instance.new("TextButton")
    bindButton.Size = UDim2.new(0, 94, 0, 32)
    bindButton.Position = UDim2.new(1, -206, 0, 14)
    bindButton.BackgroundColor3 = theme.buttonOff
    bindButton.AutoButtonColor = false
    bindButton.Font = Enum.Font.Gotham
    bindButton.TextSize = 13
    bindButton.Text = "Bind"
    bindButton.TextColor3 = theme.muted
    bindButton.Parent = frame

    local bindCorner = Instance.new("UICorner")
    bindCorner.CornerRadius = UDim.new(0, 9)
    bindCorner.Parent = bindButton

    local bindStroke = Instance.new("UIStroke")
    bindStroke.Color = theme.stroke
    bindStroke.Transparency = 0.35
    bindStroke.Parent = bindButton

    local capturingKey = false

    local function updateBindButtonText()
        if not (getKeyBindFn and setKeyBindFn) then
            bindButton.Visible = false
            return
        end
        local kb = getKeyBindFn()
        if kb then
            bindButton.Text = "Key: [" .. kb.Name .. "]"
            bindButton.TextColor3 = theme.text
        else
            bindButton.Text = "Bind"
            bindButton.TextColor3 = theme.muted
        end
    end

    local function updateToggleButton()
        local onState = isEnabledFn and isEnabledFn() or false
        if not canToggle then
            button.Text = onState and "DONE" or "RUN"
        else
            button.Text = onState and "ON" or "OFF"
        end
        local goalColor = onState and theme.accent or theme.buttonOff
        button.TextColor3 = onState and Color3.fromRGB(10, 12, 18) or theme.text
        TweenService:Create(button, quickTween, {BackgroundColor3 = goalColor}):Play()
    end

    updateToggleButton()
    updateBindButtonText()

    button.MouseButton1Click:Connect(function()
        if not canToggle then
            onEnable()
            updateToggleButton()
            button.Active = false
            bindButton.Active = false
            return
        end
        if isEnabledFn() then
            onDisable()
        else
            onEnable()
        end
        updateToggleButton()
    end)

    if getKeyBindFn and setKeyBindFn then
        bindButton.MouseButton1Click:Connect(function()
            capturingKey = not capturingKey
            if capturingKey then
                bindButton.Text = "Press key..."
                bindButton.TextColor3 = theme.text
            else
                updateBindButtonText()
            end
        end)

        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if capturingKey then
                if input.KeyCode ~= Enum.KeyCode.Unknown then
                    setKeyBindFn(input.KeyCode)
                    capturingKey = false
                    updateBindButtonText()
                end
                return
            end

            local kb = getKeyBindFn()
            if kb and input.KeyCode == kb then
                if canToggle then
                    if isEnabledFn() then
                        onDisable()
                    else
                        onEnable()
                    end
                    updateToggleButton()
                else
                    if not isEnabledFn() then
                        onEnable()
                        updateToggleButton()
                        button.Active = false
                        bindButton.Active = false
                    end
                end
            end
        end)
    else
        bindButton.Visible = false
    end

    return frame
end

-- TP target text field
local function createTPFarmTargetRow(parent)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 82)
    row.BackgroundColor3 = theme.card
    row.BackgroundTransparency = 0.08
    row.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = row

    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.stroke
    stroke.Transparency = 0.35
    stroke.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = "Teleport target"
    label.TextColor3 = theme.text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -16, 0, 18)
    hint.Position = UDim2.new(0, 12, 0, 32)
    hint.BackgroundTransparency = 1
    hint.Text = "Nickname to follow in Teleport Farm."
    hint.TextColor3 = theme.muted
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 13
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.Parent = row

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -24, 0, 32)
    input.Position = UDim2.new(0, 12, 0, 52)
    input.BackgroundColor3 = theme.buttonOff
    input.TextColor3 = theme.text
    input.PlaceholderText = "player name"
    input.PlaceholderColor3 = theme.muted
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.Text = TPFarm_TargetName
    input.ClearTextOnFocus = false
    input.Parent = row

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = input

    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = theme.stroke
    inputStroke.Transparency = 0.35
    inputStroke.Parent = input

    input.FocusLost:Connect(function()
        TPFarm_TargetName = input.Text
    end)
end

-------------------------------------------------------------------------------
--   6. Buttons and binds
-------------------------------------------------------------------------------

createSectionLabel(contentFrame, "Movement & Combat")

createToggleRow(
    contentFrame,
    "Fly",
    true,
    function() return Fly_Enabled end,
    Fly_Enable,
    Fly_Disable,
    function() return Fly_Bind end,
    function(k) Fly_Bind = k end
)

do
    local antiAFKBind = nil
    createToggleRow(
        contentFrame,
        "Anti AFK",
        true,
        function() return AntiAFK_Enabled end,
        AntiAFK_Enable,
        AntiAFK_Disable,
        function() return antiAFKBind end,
        function(k) antiAFKBind = k end
    )
end

do
    local meleeBind = nil
    createToggleRow(
        contentFrame,
        "Melee Aura",
        true,
        function() return MeleeAura_Enabled end,
        MeleeAura_Enable,
        MeleeAura_Disable,
        function() return meleeBind end,
        function(k) meleeBind = k end
    )
end

do
    local tpBind = nil
    createToggleRow(
        contentFrame,
        "Teleport Farm",
        true,
        function() return TPFarm_Enabled end,
        TPFarm_Enable,
        TPFarm_Disable,
        function() return tpBind end,
        function(k) tpBind = k end
    )
    createTPFarmTargetRow(contentFrame)
end

createSectionLabel(contentFrame, "Safe Spots")

do
    local scBind = nil
    createToggleRow(
        contentFrame,
        "Save Cube",
        true,
        function() return SaveCube_Enabled end,
        SaveCube_Enable,
        SaveCube_Disable,
        function() return scBind end,
        function(k) scBind = k end
    )
end

do
    local svBind = nil
    createToggleRow(
        contentFrame,
        "Save Vibecheck",
        true,
        function() return SaveVibe_Enabled end,
        SaveVibe_Enable,
        SaveVibe_Disable,
        function() return svBind end,
        function(k) svBind = k end
    )
end

do
    local smBind = nil
    createToggleRow(
        contentFrame,
        "Save Mountain",
        true,
        function() return SaveMount_Enabled end,
        SaveMount_Enable,
        SaveMount_Disable,
        function() return smBind end,
        function(k) smBind = k end
    )
end

--//////////////////////////////////////////////////// end
