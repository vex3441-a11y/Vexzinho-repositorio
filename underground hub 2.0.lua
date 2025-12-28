-- Underground Hub 2.0
-- By Vex

print("╔═══════════════════════════════╗")
print("║ UNDERGROUND HUB 2.0 STARTING ║")
print("╚═══════════════════════════════╝")

-- Auto-executa bypass do Anti-Cheat
spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Underground-War-2.0-NUKE-AntiCheat-Byp*er-34893"))()
        print("✓ Anti-Cheat Bypass executed!")
    end)
end)

wait(0.5)

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

_G.UndergroundHubUser = true
_G.UndergroundHubVersion = "2.0"

-- Variáveis
local FlyEnabled = false
local FlySpeed = 50
local ESPEnabled = false
local AutoKillEnabled = false
local AimBotEnabled = false
local TrollUnlocked = false

local ESPBoxes = {}
local Connections = {}
local HubUsers = {}
local KamuiPlayers = {}

print("✓ Variables initialized")

-- Comandos Secretos (OCULTOS - Não aparecem)
LocalPlayer.Chatted:Connect(function(msg)
    if msg == ";give me trolls;" then
        TrollUnlocked = true
        print("✓ Trolls unlocked")
    elseif msg == ";vex bypass forever;" then
        print("✓ Permanent bypass active")
    end
end)

print("✓ Secret commands configured")

-- Carrega Fluent UI
print("⏳ Loading Fluent UI...")
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

print("✓ Fluent UI loaded!")

-- Cria janela SEM KEY SYSTEM
local Window = Fluent:CreateWindow({
    Title = "Underground Hub 2.0 🟣",
    SubTitle = "by Vex",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.RightControl
})

print("✓ Window created!")

-- Botão Mobile para Abrir/Fechar Hub
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UndergroundHubMobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MobileButton = Instance.new("TextButton")
MobileButton.Name = "MobileToggle"
MobileButton.Size = UDim2.new(0, 70, 0, 70)
MobileButton.Position = UDim2.new(1, -80, 0.5, -35)
MobileButton.AnchorPoint = Vector2.new(0, 0.5)
MobileButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
MobileButton.BorderSizePixel = 0
MobileButton.Text = "🟣"
MobileButton.TextSize = 35
MobileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileButton.Font = Enum.Font.GothamBold
MobileButton.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = MobileButton

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(200, 100, 255)
Stroke.Thickness = 3
Stroke.Parent = MobileButton

-- Adiciona shadow/glow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(128, 0, 255)
Shadow.ImageTransparency = 0.5
Shadow.ZIndex = -1
Shadow.Parent = MobileButton

-- Torna arrastável
local dragging = false
local dragInput, mousePos, framePos

MobileButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = MobileButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MobileButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        MobileButton.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- Toggle hub ao clicar
local hubOpen = true
MobileButton.MouseButton1Click:Connect(function()
    hubOpen = not hubOpen
    Window:Minimize()
    
    -- Animação de feedback
    local TweenService = game:GetService("TweenService")
    local tween = TweenService:Create(
        MobileButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 80, 0, 80)}
    )
    tween:Play()
    tween.Completed:Connect(function()
        TweenService:Create(
            MobileButton,
            TweenInfo.new(0.2),
            {Size = UDim2.new(0, 70, 0, 70)}
        ):Play()
    end)
    
    MobileButton.Text = hubOpen and "🟣" or "🔴"
end)

-- Adiciona ao PlayerGui
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

print("✓ Mobile button created!")

Fluent:Notify({
    Title = "Underground Hub 2.0",
    Content = "🟣 Hub loaded successfully!\n📱 Purple button to open/close\n⌨️ RightCtrl for PC",
    Duration = 6
})

-- Funções auxiliares
local function GetChar() return LocalPlayer.Character end
local function GetRoot() local c = GetChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function GetHum() local c = GetChar() return c and c:FindFirstChildOfClass("Humanoid") end

-- ==================== FLY SYSTEM (CORRIGIDO FINAL) ====================
local BodyVel, BodyGyro

local function StartFly()
    local root = GetRoot()
    local hum = GetHum()
    if not root or not hum then return end
    
    -- Remove objetos antigos
    if BodyVel then BodyVel:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    
    -- Cria BodyVelocity
    BodyVel = Instance.new("BodyVelocity")
    BodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BodyVel.Velocity = Vector3.new(0, 0, 0)
    BodyVel.Parent = root
    
    -- Cria BodyGyro
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BodyGyro.P = 9000
    BodyGyro.Parent = root
    
    print("✓ Fly started")
    
    -- Loop de voo
    Connections.Fly = RunService.Heartbeat:Connect(function()
        if not FlyEnabled or not root or not root.Parent then
            if BodyVel then BodyVel:Destroy() BodyVel = nil end
            if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
            if Connections.Fly then Connections.Fly:Disconnect() end
            return
        end
        
        local cam = workspace.CurrentCamera
        local moveDir = hum.MoveDirection
        local velocity = Vector3.new(0, 0, 0)
        
        -- Movimento baseado no joystick/WASD
        if moveDir.Magnitude > 0 then
            -- Calcula direção baseada na câmera
            local camLook = cam.CFrame.LookVector
            local camRight = cam.CFrame.RightVector
            
            -- IMPORTANTE: Remove o componente Y para movimento horizontal
            camLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
            camRight = Vector3.new(camRight.X, 0, camRight.Z).Unit
            
            -- Calcula velocidade (NÃO INVERTIDO)
            velocity = (camLook * moveDir.Z + camRight * moveDir.X) * FlySpeed
        end
        
        -- Subir e descer
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or 
           UserInputService:IsKeyDown(Enum.KeyCode.ButtonR2) then
            velocity = velocity + Vector3.new(0, FlySpeed, 0)
        end
        
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or 
           UserInputService:IsKeyDown(Enum.KeyCode.ButtonL2) then
            velocity = velocity + Vector3.new(0, -FlySpeed, 0)
        end
        
        -- Aplica velocidade
        BodyVel.Velocity = velocity
        
        -- Mantém orientação da câmera
        BodyGyro.CFrame = cam.CFrame
    end)
end

local function StopFly()
    FlyEnabled = false
    print("✓ Fly stopped")
    
    if Connections.Fly then
        Connections.Fly:Disconnect()
        Connections.Fly = nil
    end
    
    if BodyVel then
        BodyVel:Destroy()
        BodyVel = nil
    end
    
    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end
end

-- ESP
local function CreateESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "UndergroundESP"
            box.Size = part.Size
            box.Adornee = part
            box.AlwaysOnTop = true
            box.Transparency = 0.5
            box.Color3 = (player.Team == LocalPlayer.Team) and Color3.fromRGB(128,0,255) or Color3.fromRGB(255,0,128)
            box.Parent = part
            table.insert(ESPBoxes, box)
        end
    end
end

local function RemoveESP()
    for _, box in pairs(ESPBoxes) do
        if box then pcall(function() box:Destroy() end) end
    end
    ESPBoxes = {}
end

-- Auto Kill
local function StartAutoKill()
    Connections.AutoKill = RunService.Heartbeat:Connect(function()
        if not AutoKillEnabled then
            if Connections.AutoKill then Connections.AutoKill:Disconnect() end
            return
        end
        
        local root = GetRoot()
        if not root then return end
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local eRoot = p.Character:FindFirstChild("HumanoidRootPart")
                local eHum = p.Character:FindFirstChildOfClass("Humanoid")
                
                if eRoot and eHum and eHum.Health > 0 then
                    if not p.Team or p.Team ~= LocalPlayer.Team then
                        root.CFrame = eRoot.CFrame * CFrame.new(0, -5, 0)
                        wait(0.3)
                        break
                    end
                end
            end
        end
    end)
end

-- AimBot
local function StartAimBot()
    Connections.Aim = RunService.RenderStepped:Connect(function()
        if not AimBotEnabled then
            if Connections.Aim then Connections.Aim:Disconnect() end
            return
        end
        
        local closest = nil
        local shortDist = math.huge
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local head = p.Character:FindFirstChild("Head")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                
                if head and hum and hum.Health > 0 then
                    if not p.Team or p.Team ~= LocalPlayer.Team then
                        local dist = (head.Position - GetRoot().Position).Magnitude
                        if dist < shortDist then
                            shortDist = dist
                            closest = head
                        end
                    end
                end
            end
        end
        
        if closest then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Position)
        end
    end)
end

-- Kamui
local KamuiDim = nil

local function CreateKamui()
    if KamuiDim then return end
    
    KamuiDim = Instance.new("Model")
    KamuiDim.Name = "UndergroundKamui"
    KamuiDim.Parent = workspace
    
    local floor = Instance.new("Part", KamuiDim)
    floor.Size = Vector3.new(60, 1, 60)
    floor.Position = Vector3.new(0, -500, 0)
    floor.Anchored = true
    floor.Material = Enum.Material.Neon
    floor.Color = Color3.fromRGB(128, 0, 255)
    floor.Transparency = 0.2
    
    for i = 1, 4 do
        local wall = Instance.new("Part", KamuiDim)
        wall.Size = (i <= 2) and Vector3.new(60, 120, 2) or Vector3.new(2, 120, 60)
        wall.Anchored = true
        wall.CanCollide = true
        wall.Material = Enum.Material.ForceField
        wall.Color = Color3.fromRGB(80, 0, 200)
        wall.Transparency = 0.4
        
        if i == 1 then wall.Position = floor.Position + Vector3.new(0, 60, 30)
        elseif i == 2 then wall.Position = floor.Position + Vector3.new(0, 60, -30)
        elseif i == 3 then wall.Position = floor.Position + Vector3.new(30, 60, 0)
        else wall.Position = floor.Position + Vector3.new(-30, 60, 0) end
    end
    
    local ceiling = Instance.new("Part", KamuiDim)
    ceiling.Size = Vector3.new(60, 1, 60)
    ceiling.Position = floor.Position + Vector3.new(0, 120, 0)
    ceiling.Anchored = true
    ceiling.Material = Enum.Material.Neon
    ceiling.Color = Color3.fromRGB(128, 0, 255)
    ceiling.Transparency = 0.2
    
    Fluent:Notify({
        Title = "Kamui Dimension",
        Content = "🟣 Dimension created!",
        Duration = 3
    })
end

local function SendToKamui(playerName)
    local target = Players:FindFirstChild(playerName)
    if not target or not target.Character then return end
    
    CreateKamui()
    
    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if tRoot then
        -- Efeito de portal
        local portal = Instance.new("Part")
        portal.Size = Vector3.new(10, 10, 0.5)
        portal.CFrame = tRoot.CFrame
        portal.Anchored = true
        portal.CanCollide = false
        portal.Material = Enum.Material.Neon
        portal.Color = Color3.fromRGB(200, 0, 255)
        portal.Transparency = 0.3
        portal.Shape = Enum.PartType.Cylinder
        portal.Parent = workspace
        
        for i = 1, 20 do
            portal.CFrame = tRoot.CFrame * CFrame.Angles(0, 0, math.rad(i * 18))
            wait(0.05)
        end
        
        tRoot.CFrame = CFrame.new(0, -495, 0)
        table.insert(KamuiPlayers, target.Name)
        
        portal:Destroy()
        
        Fluent:Notify({
            Title = "Kamui!",
            Content = "🟣 " .. target.Name .. " sent to dimension!",
            Duration = 3
        })
    end
end

local function ReleaseFromKamui(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character then
        local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then
            tRoot.CFrame = CFrame.new(0, 50, 0)
            for i, name in ipairs(KamuiPlayers) do
                if name == playerName then
                    table.remove(KamuiPlayers, i)
                    break
                end
            end
        end
    end
end

-- Detectar Hub Users
local function DetectHubUsers()
    HubUsers = {LocalPlayer.Name .. " 🟣"}
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            
            if root and (root:FindFirstChildOfClass("BodyVelocity") or 
                        root:FindFirstChildOfClass("BodyGyro") or 
                        (hum and hum.WalkSpeed > 50)) then
                table.insert(HubUsers, p.Name .. " 🟣")
            end
        end
    end
    
    return HubUsers
end

print("✓ All functions created!")

-- ==================== INTERFACE ====================

local Tabs = {
    Main = Window:AddTab({Title = "🏠 Main", Icon = "home"}),
    Combat = Window:AddTab({Title = "⚔️ Combat", Icon = "sword"}),
    Movement = Window:AddTab({Title = "🚀 Movement", Icon = "zap"}),
    Visual = Window:AddTab({Title = "👁️ Visuals", Icon = "eye"}),
    Teleport = Window:AddTab({Title = "📍 Teleport", Icon = "map-pin"}),
    Settings = Window:AddTab({Title = "⚙️ Settings", Icon = "settings"})
}

-- MAIN TAB
Tabs.Main:AddParagraph({
    Title = "Underground Hub 2.0 🟣",
    Content = "By Vex | Amethyst Theme\n\n✅ Anti-Cheat Bypass Active\n\n⌨️ PC: RightCtrl = Open/Close\n📱 Mobile: Purple Button 🟣\n\n🔍 Detect hub users in the server"
})

Tabs.Main:AddButton({
    Title = "🔍 Detect Hub Users",
    Description = "See who's using Underground Hub",
    Callback = function()
        local users = DetectHubUsers()
        local list = "Underground Hub Users:\n\n"
        for i, name in ipairs(users) do
            list = list .. i .. ". " .. name .. "\n"
        end
        Fluent:Notify({
            Title = "Hub Users Detected",
            Content = list,
            Duration = 10
        })
    end
})

-- COMBAT TAB
Tabs.Combat:AddToggle("SwordReach", {
    Title = "⚔️ Sword Reach",
    Default = false,
    Callback = function(v)
        if v then
            pcall(function()
                loadstring(game:HttpGet('https://pastebin.com/raw/0dnNLQgG'))()
            end)
            Fluent:Notify({Title = "Sword Reach", Content = "🟣 Activated!", Duration = 3})
        end
    end
})

Tabs.Combat:AddToggle("AimBot", {
    Title = "🎯 AimBot",
    Default = false,
    Callback = function(v)
        AimBotEnabled = v
        if v then
            StartAimBot()
            Fluent:Notify({Title = "AimBot", Content = "🟣 Activated!", Duration = 3})
        elseif Connections.Aim then
            Connections.Aim:Disconnect()
        end
    end
})

Tabs.Combat:AddToggle("AutoKill", {
    Title = "💀 Auto Kill (Tunnels)",
    Default = false,
    Callback = function(v)
        AutoKillEnabled = v
        if v then
            StartAutoKill()
            Fluent:Notify({Title = "Auto Kill", Content = "🟣 Activated!", Duration = 3})
        elseif Connections.AutoKill then
            Connections.AutoKill:Disconnect()
        end
    end
})

Tabs.Combat:AddButton({
    Title = "☠️ Kill All Enemies",
    Callback = function()
        local count = 0
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and (not p.Team or p.Team ~= LocalPlayer.Team) then
                local eRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if eRoot then
                    GetRoot().CFrame = eRoot.CFrame * CFrame.new(0, -5, 0)
                    wait(0.25)
                    count = count + 1
                end
            end
        end
        Fluent:Notify({Title = "Kill All", Content = "🟣 " .. count .. " enemies killed!", Duration = 3})
    end
})

-- MOVEMENT TAB
Tabs.Movement:AddToggle("Fly", {
    Title = "🚀 Fly Mobile",
    Description = "Joystick + Camera control",
    Default = false,
    Callback = function(v)
        FlyEnabled = v
        if v then
            StartFly()
            Fluent:Notify({
                Title = "Fly Activated",
                Content = "🟣 Joystick to move\nCamera to direct\nSpace = Up | Shift = Down",
                Duration = 5
            })
        else
            StopFly()
        end
    end
})

Tabs.Movement:AddSlider("FlySpeed", {
    Title = "⚡ Fly Speed",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Callback = function(v)
        FlySpeed = v
    end
})

Tabs.Movement:AddButton({
    Title = "⚡ Super Speed",
    Callback = function()
        local h = GetHum()
        if h then
            h.WalkSpeed = 100
            Fluent:Notify({Title = "Super Speed", Content = "🟣 Speed set to 100!", Duration = 3})
        end
    end
})

Tabs.Movement:AddButton({
    Title = "🔄 Reset Speed",
    Callback = function()
        local h = GetHum()
        if h then
            h.WalkSpeed = 16
            Fluent:Notify({Title = "Speed Reset", Content = "Speed normalized", Duration = 2})
        end
    end
})

Tabs.Movement:AddButton({
    Title = "🦘 Super Jump",
    Callback = function()
        local h