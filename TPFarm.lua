--////////////////////////////////////////////////////////
--             ЛОКАЛЬНЫЙ СКРИПТ: "Чёрно хаб (Optimized)"
--////////////////////////////////////////////////////////

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-------------------------------------------------------------------------------
--    1. Создаём ScreenGui и основное окно (mainFrame)
-------------------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VenomHubScreenGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "VenomHubMainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 390)
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BorderSizePixel = 2
mainFrame.Visible = false  -- по умолчанию скрыто, открывать клавишей [K]
mainFrame.Active = true
mainFrame.Selectable = true
mainFrame.Parent = screenGui

-- Заголовок
local titleBar = Instance.new("TextLabel")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.Text = "Чёрно хаб (Drag / Press K to show/hide)"
titleBar.Parent = mainFrame

-- Подпись внизу
local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, 0, 0, 20)
footerLabel.Position = UDim2.new(0, 0, 1, -20)
footerLabel.BackgroundTransparency = 1
footerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
footerLabel.Font = Enum.Font.SourceSansSemibold
footerLabel.TextSize = 16
footerLabel.Text = "By bestik_"
footerLabel.Parent = mainFrame

-- Прокручиваемая область для кнопок
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -10, 1, -60)
contentFrame.Position = UDim2.new(0, 5, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
contentFrame.ScrollBarThickness = 4
contentFrame.Parent = mainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0,5)
UIListLayout.Parent = contentFrame

-------------------------------------------------------------------------------
--    2. Перетаскивание окна (mainFrame) при удержании ЛКМ
-------------------------------------------------------------------------------
do
    local dragging = false
    local dragOffset = Vector2.new()

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local newPosition = input.Position - dragOffset
            mainFrame.Position = UDim2.fromOffset(newPosition.X, newPosition.Y)
        end
    end)
end

-------------------------------------------------------------------------------
--    3. Клавиша [K] для показа/скрытия
-------------------------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.K then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-------------------------------------------------------------------------------
--    4. Объявляем все переменные и функции скриптов
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

--========================== Admin Check ========================--
local AdminCheck_Enabled = false
local AdminCheck_Connection
local AdminCheck_Coroutine

local AdminList = {
    -- Имена возможных админов
    ["tabootvcat"] = true,
    ["Revenantic"] = true,
    ["Saabor"] = true,
    ["MoIitor"] = true,
    ["IAmUnderAMask"] = true,
    ["SheriffGorji"] = true,
    ["xXFireyScorpionXx"] = true,
    ["LoChips"] = true,
    ["DeliverCreations"] = true,
    ["TDXiswinning"] = true,
    ["TZZV"] = true,
    ["FelixVenue"] = true,
    ["SIEGFRlED"] = true,
    ["ARRYvvv"] = true,
    ["z_papermoon"] = true,
    ["Malpheasance"] = true,
    ["ModHandIer"] = true,
    ["valphex"] = true,
    ["J_anday"] = true,
    ["tvdisko"] = true,
    ["yIlehs"] = true,
    ["COLOSSUSBUILTOFSTEEL"] = true,
    ["SeizedHolder"] = true,
    ["r3shape"] = true,
    ["RVVZ"] = true,
    ["adurize"] = true,
    ["codedcosmetics"] = true,
    ["QuantumCaterpillar"] = true,
    ["FractalHarmonics"] = true,
    ["GalacticSculptor"] = true,
    ["oTheSilver"] = true,
    ["Kretacaous"] = true,
    ["icarus_xs1goliath"] = true,
    ["GlamorousDradon"] = true,
    ["rainjeremy"] = true,
    ["parachuter2000"] = true,
    ["faintermercury"] = true,
    ["harht"] = true,
    ["Sansek1252"] = true,
    ["Snorpuwu"] = true,
    ["BenAzoten"] = true,
    ["Cand1ebox"] = true,
    ["KeenlyAware"] = true,
    ["mrzued"] = true,
    ["BruhmanVIII"] = true,
    ["Nystesia"] = true,
    ["fausties"] = true,
    ["zateopp"] = true,
    ["Iordnabi"] = true,
    ["ReviveTheDevil"] = true,
    ["jake_jpeg"] = true,
    ["UncrossedMeat3888"] = true,
    ["realpenyy"] = true,
    ["karateeeh"] = true,
    ["JayyMlg"] = true,
    ["Lo_Chips"] = true,
    ["Avelosky"] = true,
    ["king_ab09"] = true,
    ["TigerLe123"] = true,
    ["Dalvanuis"] = true,
    ["iSonMillions"] = true,

    -- Новые имена:
    ["DieYouOder"] = true,
    ["whosframed"] = true
}

local function CheckAdmins()
    for _, plr in ipairs(Players:GetPlayers()) do
        if AdminList[plr.Name] then
            LocalPlayer:Kick("Admin")
            task.wait(2)
            game:Shutdown()
            return
        end
    end
end

local function AdminCheck_Enable()
    if AdminCheck_Enabled then return end
    AdminCheck_Enabled = true

    -- Сразу проверяем текущих игроков
    CheckAdmins()

    AdminCheck_Connection = Players.PlayerAdded:Connect(function(plr)
        if not AdminCheck_Enabled then return end
        if AdminList[plr.Name] then
            LocalPlayer:Kick("Detected Nigger") -- Исходная формулировка автора
            task.wait(2)
            game:Shutdown()
        end
    end)

    AdminCheck_Coroutine = coroutine.create(function()
        while AdminCheck_Enabled do
            CheckAdmins()
            task.wait(4)
        end
    end)
    coroutine.resume(AdminCheck_Coroutine)
end

local function AdminCheck_Disable()
    if not AdminCheck_Enabled then return end
    AdminCheck_Enabled = false

    if AdminCheck_Connection then
        AdminCheck_Connection:Disconnect()
        AdminCheck_Connection = nil
    end
    AdminCheck_Coroutine = nil
end

--======================= Deleted Mob<3 =========================--
local DeletedMob_Ran = false
local function DeletedMob_RunOnce()
    if DeletedMob_Ran then return end
    DeletedMob_Ran = true

    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Mick-gordon/Hyper-Escape/main/DeleteMobV2.lua", true))()
    end)
    if not success then
        warn("[Deleted Mob<3] Ошибка: ", err)
    end
end

--========================== Anti AFK ===========================--
local AntiAFK_Enabled = false
local AntiAFK_IdledConnection
local AntiAFK_Coroutine

local function AntiAFK_DoAction()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:SetKeyDown('0x20')  -- пробел
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

-- Сохраняем все подключения, чтобы отключать при Disable
local TPFarm_SteppedConnection = nil
local TPFarm_RenderConnection = nil
local TPFarm_CharConnection = nil
local DeathRespawn_Event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DeathRespawn")

-- Локальная функция, вызываемая при спавне персонажа (CharacterAdded)
local function TPFarm_OnCharacterAdded(char)
    -- На всякий случай отключим старый SteppedConnection, если ещё не отключён
    if TPFarm_SteppedConnection then
        TPFarm_SteppedConnection:Disconnect()
        TPFarm_SteppedConnection = nil
    end

    -- Немного ждём, чтобы HumanoidRootPart успел загрузиться
    task.wait(0.4)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum) then return end

    -- Подключаемся к RunService.Stepped для телепорта к главному игроку
    TPFarm_SteppedConnection = RunService.Stepped:Connect(function()
        if not TPFarm_Enabled then return end
        local mainPlayer = Players:FindFirstChild(TPFarm_TargetName)
        local mainChar = mainPlayer and mainPlayer.Character
        local mainHRP = mainChar and mainChar:FindFirstChild("HumanoidRootPart")
        if mainHRP then
            -- Держим персонажа на расстоянии 3 единиц перед таргетом
            hrp.CFrame = mainHRP.CFrame + (mainHRP.CFrame.LookVector * 3)

            -- Разово подключимся к HealthChanged, чтобы обнулять здоровье
            -- (Если это делать при каждом рендере, будет утечка)
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

    -- Если персонаж уже есть
    if me.Character then
        TPFarm_OnCharacterAdded(me.Character)
    end

    -- Отслеживаем респавны
    TPFarm_CharConnection = me.CharacterAdded:Connect(function(newChar)
        if not TPFarm_Enabled then return end
        TPFarm_OnCharacterAdded(newChar)

        -- Переносим оружие из рюкзака в руки
        local tool = me.Backpack:FindFirstChildOfClass("Tool")
        if tool and newChar then
            tool.Parent = newChar
        end
    end)

    -- Подключаемся к RenderStepped, чтобы авто-возрождаться при смерти
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

--================= 3 Save-кнопки (Cube/Vibecheck/Mountain) =======
local event = DeathRespawn_Event  -- Сократим название

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
                event:InvokeServer("KMG4R904") -- авто возрождение
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
--    5. Функция создания строки (createToggleRow) для кнопок
-------------------------------------------------------------------------------
local function createToggleRow(parent, scriptName, canToggle, isEnabledFn, onEnable, onDisable, getKeyBindFn, setKeyBindFn)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = scriptName
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSansSemibold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.2, 0, 1, 0)
    button.Position = UDim2.new(0.4, 5, 0, 0)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    button.Parent = frame

    local bindButton = Instance.new("TextButton")
    bindButton.Size = UDim2.new(0.2, 0, 1, 0)
    bindButton.Position = UDim2.new(0.6, 10, 0, 0)
    bindButton.Font = Enum.Font.SourceSans
    bindButton.TextSize = 16
    bindButton.Text = "Bind"
    bindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    bindButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    bindButton.Parent = frame

    local function updateToggleButton()
        if not canToggle then
            button.Text = "Run"
            button.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            return
        end
        if isEnabledFn() then
            button.Text = "ON"
            button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        else
            button.Text = "OFF"
            button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        end
    end
    updateToggleButton()

    button.MouseButton1Click:Connect(function()
        if not canToggle then
            -- одноразовый запуск
            onEnable()
            button.Text = "DONE"
            button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
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
        local capturingKey = false

        local function updateBindButtonText()
            local kb = getKeyBindFn()
            if kb then
                bindButton.Text = "[".. kb.Name .."]"
            else
                bindButton.Text = "Bind"
            end
        end
        updateBindButtonText()

        bindButton.MouseButton1Click:Connect(function()
            if capturingKey then
                capturingKey = false
                bindButton.Text = "Bind"
            else
                capturingKey = true
                bindButton.Text = "Press Key..."
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
            else
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
                        -- одноразовый
                        if not DeletedMob_Ran then
                            onEnable()
                            button.Text = "DONE"
                            button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                            button.Active = false
                            bindButton.Active = false
                        end
                    end
                end
            end
        end)
    else
        bindButton.Visible = false
    end

    return frame
end

-- Дополнительная строка ввода для Teleport Farm
local function createTPFarmTargetRow(parent)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "TP Target:"
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSansSemibold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.5, 0, 1, 0)
    input.Position = UDim2.new(0.4, 5, 0, 0)
    input.BackgroundColor3 = Color3.fromRGB(80,80,80)
    input.TextColor3 = Color3.new(1,1,1)
    input.Font = Enum.Font.SourceSans
    input.TextSize = 16
    input.Text = TPFarm_TargetName
    input.ClearTextOnFocus = false
    input.Parent = row

    input.FocusLost:Connect(function()
        TPFarm_TargetName = input.Text
    end)
end

-------------------------------------------------------------------------------
--   6. Создаём кнопки в нужном порядке
-------------------------------------------------------------------------------

-- 1) Fly
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

-- 2) Admin Check
do
    local adminCheckBind = nil
    createToggleRow(
        contentFrame,
        "Admin Check",
        true,
        function() return AdminCheck_Enabled end,
        AdminCheck_Enable,
        AdminCheck_Disable,
        function() return adminCheckBind end,
        function(k) adminCheckBind = k end
    )
end

-- 3) Deleted Mob<3 (одноразово)
createToggleRow(
    contentFrame,
    "Deleted Mob<3",
    false,
    function() return DeletedMob_Ran end,
    DeletedMob_RunOnce,
    function() end,
    (function()
        local onceBind = nil
        return function() return onceBind end,
               function(k) onceBind = k end
    end)()
)

-- 4) Anti AFK
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

-- 5) Melee Aura 4 Alt MAX!
do
    local meleeBind = nil
    createToggleRow(
        contentFrame,
        "Melee Aura 4 Alt MAX!",
        true,
        function() return MeleeAura_Enabled end,
        MeleeAura_Enable,
        MeleeAura_Disable,
        function() return meleeBind end,
        function(k) meleeBind = k end
    )
end

-- 6) Teleport Farm
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

-- 7) Save Cube
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

-- 8) Save Vibecheck
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

-- 9) Save Mountain
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
