-- Underground Hub 2.0 - Versão Simplificada e Funcional
print("=== UNDERGROUND HUB 2.0 INICIANDO ===")

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

print("Serviços carregados!")

-- Variáveis globais
_G.UndergroundHubUser = true
_G.UndergroundHubVersion = "2.0"

-- Variáveis de estado
local FlyEnabled = false
local FlySpeed = 50
local AimBotEnabled = false
local ESPEnabled = false
local AutoKillEnabled = false
local TrollTabUnlocked = false
local TrollProtectionEnabled = true

local BodyVelocity, BodyGyro
local Connections = {}
local ESPObjects = {}
local ExecutorUsers = {}
local HubUsers = {}
local KamuiDimension = nil
local KamuiPlayers = {}

print("Variáveis inicializadas!")

-- Auto-executa bypass
spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Underground-War-2.0-NUKE-AntiCheat-Byp*er-34893"))()
        print("Bypass executado!")
    end)
end)

-- Carrega Rayfield
print("Carregando Rayfield...")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
print("Rayfield carregado!")

-- Funções auxiliares
local function GetCharacter()
    return LocalPlayer.Character
end

local function GetRootPart()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

print("Funções auxiliares criadas!")

-- Sistema de detecção de comando no chat
LocalPlayer.Chatted:Connect(function(message)
    if message == ";give me trolls;" then
        TrollTabUnlocked = true
        print("ABA TROLL DESBLOQUEADA!")
    end
end)

print("Sistema de chat configurado!")

-- Cria janela COM key system
print("Criando janela...")
local Window = Rayfield:CreateWindow({
   Name = "Underground Hub 2.0",
   LoadingTitle = "Underground Hub",
   LoadingSubtitle = "by Underground Team",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = true,
   KeySettings = {
      Title = "Underground Hub 2.0",
      Subtitle = "Key System",
      Note = "Pegue sua key em: https://vex-key-sistem.netlify.app/",
      FileName = "UndergroundKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"underground2024"}
   }
})

print("Janela criada!")

Rayfield:Notify({
   Title = "Underground Hub 2.0",
   Content = "Hub carregada! Digite ;give me trolls; no chat",
   Duration = 5
})

-- ==================== FUNÇÕES ====================

-- FLY (INVERTIDO)
local function StartFly()
    local rootPart = GetRootPart()
    local humanoid = GetHumanoid()
    if not rootPart or not humanoid then return end
    
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = rootPart
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.P = 9e4
    BodyGyro.Parent = rootPart
    
    Connections.Fly = RunService.Heartbeat:Connect(function()
        if not FlyEnabled or not rootPart.Parent then
            if Connections.Fly then Connections.Fly:Disconnect() end
            if BodyVelocity then BodyVelocity:Destroy() end
            if BodyGyro then BodyGyro:Destroy() end
            return
        end
        
        local moveDirection = humanoid.MoveDirection
        local direction = Vector3.new(0, 0, 0)
        
        if moveDirection.Magnitude > 0 then
            local forward = Camera.CFrame.LookVector
            local right = Camera.CFrame.RightVector
            direction = (forward * -moveDirection.Z + right * -moveDirection.X) * FlySpeed
        end
        
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, FlySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - Vector3.new(0, FlySpeed, 0)
        end
        
        BodyVelocity.Velocity = direction
        BodyGyro.CFrame = Camera.CFrame
    end)
end

local function StopFly()
    FlyEnabled = false
    if Connections.Fly then Connections.Fly:Disconnect() end
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
end

-- AUTO KILL (TÚNEIS)
local function StartAutoKill()
    Connections.AutoKill = RunService.Heartbeat:Connect(function()
        if not AutoKillEnabled then return end
        
        local rootPart = GetRootPart()
        if not rootPart then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if enemyRoot and (not player.Team or player.Team ~= LocalPlayer.Team) then
                    rootPart.CFrame = enemyRoot.CFrame * CFrame.new(0, -5, 0)
                    wait(0.3)
                    break
                end
            end
        end
    end)
end

-- ESP
local function StartESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "ESPBox"
                    box.Size = part.Size
                    box.Adornee = part
                    box.AlwaysOnTop = true
                    box.Transparency = 0.7
                    box.Color3 = (player.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
                    box.Parent = part
                    table.insert(ESPObjects, box)
                end
            end
        end
    end
end

local function RemoveESP()
    for _, obj in pairs(ESPObjects) do
        if obj then obj:Destroy() end
    end
    ESPObjects = {}
end

-- AIMBOT
local function StartAimBot()
    Connections.AimBot = RunService.RenderStepped:Connect(function()
        if not AimBotEnabled then return end
        
        local closest = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if enemyRoot and (not player.Team or player.Team ~= LocalPlayer.Team) then
                    local distance = (enemyRoot.Position - GetRootPart().Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closest = enemyRoot
                    end
                end
            end
        end
        
        if closest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
        end
    end)
end

-- KAMUI
local function CreateKamuiDimension()
    if KamuiDimension then return end
    
    KamuiDimension = Instance.new("Model")
    KamuiDimension.Name = "KamuiDimension"
    
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(50, 1, 50)
    platform.Position = Vector3.new(0, -500, 0)
    platform.Anchored = true
    platform.Material = Enum.Material.Neon
    platform.Color = Color3.new(0.3, 0, 0.5)
    platform.Parent = KamuiDimension
    
    for i = 1, 4 do
        local wall = Instance.new("Part")
        wall.Size = (i <= 2) and Vector3.new(50, 100, 1) or Vector3.new(1, 100, 50)
        wall.Anchored = true
        wall.Material = Enum.Material.ForceField
        wall.Color = Color3.new(0.2, 0, 0.4)
        
        if i == 1 then wall.Position = platform.Position + Vector3.new(0, 50, 25)
        elseif i == 2 then wall.Position = platform.Position + Vector3.new(0, 50, -25)
        elseif i == 3 then wall.Position = platform.Position + Vector3.new(25, 50, 0)
        else wall.Position = platform.Position + Vector3.new(-25, 50, 0) end
        
        wall.Parent = KamuiDimension
    end
    
    KamuiDimension.Parent = Workspace
    Rayfield:Notify({Title = "Kamui", Content = "Dimensão criada!", Duration = 3})
end

local function KamuiPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if not target or not target.Character then return end
    
    CreateKamuiDimension()
    
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if targetRoot then
        targetRoot.CFrame = CFrame.new(0, -495, 0)
        table.insert(KamuiPlayers, target.Name)
        Rayfield:Notify({Title = "Kamui!", Content = target.Name .. " enviado!", Duration = 3})
    end
end

-- DETECÇÃO HUB USERS
local function DetectHubUsers()
    HubUsers = {LocalPlayer.Name}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart and (rootPart:FindFirstChildOfClass("BodyVelocity") or rootPart:FindFirstChildOfClass("BodyGyro")) then
                table.insert(HubUsers, player.Name)
            end
        end
    end
    return HubUsers
end

print("Funções criadas!")

-- ==================== CRIA ABAS ====================

local Tab1 = Window:CreateTab("🏠 Principal")
Tab1:CreateParagraph({
    Title = "Underground Hub 2.0",
    Content = "✅ Hub Carregada\n✅ Key System Ativo\n\n💬 Digite ;give me trolls; no chat\n🔍 Detecte hub users"
})

Tab1:CreateButton({
    Name = "Detectar Hub Users",
    Callback = function()
        local detected = DetectHubUsers()
        local list = "Hub Users:\n"
        for i, name in ipairs(detected) do
            list = list .. i .. ". " .. name .. "\n"
        end
        Rayfield:Notify({Title = "Hub Users", Content = list, Duration = 8})
    end
})

-- COMBATE
local Tab2 = Window:CreateTab("⚔️ Combate")

Tab2:CreateToggle({
    Name = "Sword Reach",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            pcall(function()
                loadstring(game:HttpGet('https://pastebin.com/raw/0dnNLQgG'))()
            end)
        end
    end
})

Tab2:CreateToggle({
    Name = "AimBot",
    CurrentValue = false,
    Callback = function(Value)
        AimBotEnabled = Value
        if Value then StartAimBot() 
        elseif Connections.AimBot then Connections.AimBot:Disconnect() end
    end
})

Tab2:CreateToggle({
    Name = "Auto Kill (Túneis)",
    CurrentValue = false,
    Callback = function(Value)
        AutoKillEnabled = Value
        if Value then StartAutoKill()
        elseif Connections.AutoKill then Connections.AutoKill:Disconnect() end
    end
})

-- MOVIMENTO
local Tab3 = Window:CreateTab("🚀 Movimento")

Tab3:CreateToggle({
    Name = "Fly Mobile",
    CurrentValue = false,
    Callback = function(Value)
        FlyEnabled = Value
        if Value then StartFly() else StopFly() end
    end
})

Tab3:CreateSlider({
    Name = "Velocidade Fly",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(Value) FlySpeed = Value end
})

Tab3:CreateButton({
    Name = "Super Speed",
    Callback = function()
        local h = GetHumanoid()
        if h then h.WalkSpeed = 100 end
    end
})

Tab3:CreateButton({
    Name = "Super Jump",
    Callback = function()
        local h = GetHumanoid()
        if h then h.JumpPower = 150 end
    end
})

-- VISUAIS
local Tab4 = Window:CreateTab("👁️ Visuais")

Tab4:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(Value)
        ESPEnabled = Value
        if Value then StartESP() else RemoveESP() end
    end
})

Tab4:CreateButton({
    Name = "FullBright",
    Callback = function()
        local L = game:GetService("Lighting")
        L.Brightness = 2
        L.ClockTime = 14
        L.FogEnd = 100000
    end
})

-- TELEPORTE
local Tab5 = Window:CreateTab("📍 Teleporte")

Tab5:CreateButton({
    Name = "Spawn",
    Callback = function()
        local r = GetRootPart()
        if r then r.CFrame = CFrame.new(0, 50, 0) end
    end
})

Tab5:CreateButton({
    Name = "Torre Alta",
    Callback = function()
        local r = GetRootPart()
        if r then r.CFrame = CFrame.new(-300, 200, -300) end
    end
})

-- CONFIG
local Tab6 = Window:CreateTab("⚙️ Config")

Tab6:CreateToggle({
    Name = "Proteção Anti-Troll",
    CurrentValue = true,
    Callback = function(Value)
        TrollProtectionEnabled = Value
    end
})

Tab6:CreateButton({
    Name = "Destruir GUI",
    Callback = function()
        StopFly()
        RemoveESP()
        Rayfield:Destroy()
    end
})

print("Abas principais criadas!")

-- ABA TROLL (CARREGA APÓS COMANDO)
spawn(function()
    repeat wait(0.5) until TrollTabUnlocked
    
    local TabTroll = Window:CreateTab("😈 Troll")
    
    TabTroll:CreateButton({
        Name = "Criar Dimensão Kamui",
        Callback = function() CreateKamuiDimension() end
    })
    
    local playerList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(playerList, p.Name) end
    end
    
    local dropdown = TabTroll:CreateDropdown({
        Name = "Selecionar Player",
        Options = playerList,
        CurrentOption = {""},
        Callback = function() end
    })
    
    TabTroll:CreateButton({
        Name = "Enviar para Kamui",
        Callback = function()
            local selected = dropdown.CurrentOption[1]
            if selected ~= "" then KamuiPlayer(selected) end
        end
    })
    
    TabTroll:CreateButton({
        Name = "Fling All",
        Callback = function()
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character then
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    if r then r.Velocity = Vector3.new(math.random(-500,500), 1000, math.random(-500,500)) end
                end
            end
        end
    })
    
    TabTroll:CreateButton({
        Name = "Invisible",
        Callback = function()
            for _, p in pairs(GetCharacter():GetDescendants()) do
                if p:IsA("BasePart") then p.Transparency = 1 end
            end
        end
    })
    
    Rayfield:Notify({
        Title = "Aba Troll Desbloqueada!",
        Content = "Todas as funções disponíveis!",
        Duration = 5
    })
    
    print("ABA TROLL CRIADA!")
end)

-- Proteção Anti-Troll
RunService.Heartbeat:Connect(function()
    if TrollProtectionEnabled then
        local r = GetRootPart()
        if r then
            for _, obj in pairs(r:GetChildren()) do
                if obj:IsA("BodyAngularVelocity") then obj:Destroy() end
            end
            if r.Anchored and not FlyEnabled then r.Anchored = false end
        end
    end
end)

print("==========================================")
print("UNDERGROUND HUB 2.0 - CARREGADO COM SUCESSO!")
print("==========================================")

Rayfield:Notify({
    Title = "Sucesso!",
    Content = "Hub 100% carregada!\nKey: underground2024",
    Duration = 5
})