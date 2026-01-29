-- KILLER EXECUTOR V5.0
-- Executor com Backdoor Funcional

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tempo de sessão
local SessionStart = tick()
local foundBackdoors = {}
local createdBackdoor = nil

-- Ícone de caveira e som
local skullIcon = "rbxassetid://133397172105104"
local executeSound = "rbxassetid://72553925354843"

-- Criar ScreenGui
local KillerExecutor = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MainGradient = Instance.new("UIGradient")
local TopBar = Instance.new("Frame")
local TopGradient = Instance.new("UIGradient")
local Logo = Instance.new("TextLabel")
local SkullLogo = Instance.new("ImageLabel")
local CloseBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")

-- Painel de Perfil (Direita)
local ProfilePanel = Instance.new("Frame")
local ProfileGradient = Instance.new("UIGradient")
local ProfileImage = Instance.new("ImageLabel")
local PlayerNameLabel = Instance.new("TextLabel")
local PlayerIDLabel = Instance.new("TextLabel")
local SessionTimeLabel = Instance.new("TextLabel")
local ProfileTitle = Instance.new("TextLabel")
local ProfileSkull = Instance.new("ImageLabel")

-- Botão Toggle (Seta)
local ToggleButton = Instance.new("TextButton")

-- Script Box
local ScriptBox = Instance.new("TextBox")
local ScriptBoxGradient = Instance.new("UIGradient")

-- Botões
local ExecuteBtn = Instance.new("TextButton")
local ExecuteGradient = Instance.new("UIGradient")
local ExecuteSkull = Instance.new("ImageLabel")
local ClearBtn = Instance.new("TextButton")
local ClearGradient = Instance.new("UIGradient")
local ScanBtn = Instance.new("TextButton")
local ScanGradient = Instance.new("UIGradient")
local ScanSkull = Instance.new("ImageLabel")
local CreateBackdoorBtn = Instance.new("TextButton")
local CreateBackdoorGradient = Instance.new("UIGradient")
local CreateBackdoorSkull = Instance.new("ImageLabel")

-- Painel de Backdoors Encontrados
local BackdoorPanel = Instance.new("ScrollingFrame")
local BackdoorPanelGradient = Instance.new("UIGradient")
local BackdoorTitle = Instance.new("TextLabel")

-- Status
local BackdoorStatus = Instance.new("Frame")
local StatusGradient = Instance.new("UIGradient")
local StatusLabel = Instance.new("TextLabel")
local StatusIndicator = Instance.new("Frame")

-- Configurações do ScreenGui
KillerExecutor.Name = "KillerExecutor"
KillerExecutor.Parent = game.CoreGui
KillerExecutor.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KillerExecutor.ResetOnSpawn = false

-- Frame Principal (MENOR)
MainFrame.Name = "MainFrame"
MainFrame.Parent = KillerExecutor
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Gradiente animado principal
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))
}
MainGradient.Rotation = 0
MainGradient.Parent = MainFrame

-- Barra Superior
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 15)
TopCorner.Parent = TopBar

TopGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
TopGradient.Rotation = 90
TopGradient.Parent = TopBar

-- Caveira Logo
SkullLogo.Name = "SkullLogo"
SkullLogo.Parent = TopBar
SkullLogo.BackgroundTransparency = 1
SkullLogo.Position = UDim2.new(0, 10, 0, 5)
SkullLogo.Size = UDim2.new(0, 30, 0, 30)
SkullLogo.Image = skullIcon
SkullLogo.ImageColor3 = Color3.fromRGB(255, 50, 50)
SkullLogo.ScaleType = Enum.ScaleType.Fit

-- Logo
Logo.Name = "Logo"
Logo.Parent = TopBar
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0, 45, 0, 0)
Logo.Size = UDim2.new(0, 250, 1, 0)
Logo.Font = Enum.Font.GothamBold
Logo.Text = "KILLER EXECUTOR"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 18
Logo.TextXAlignment = Enum.TextXAlignment.Left

-- Botão Fechar
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(1, -35, 0, 7.5)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(1, 0)
CloseBtnCorner.Parent = CloseBtn

-- Botão Minimizar
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 40)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Position = UDim2.new(1, -65, 0, 7.5)
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16

local MinimizeBtnCorner = Instance.new("UICorner")
MinimizeBtnCorner.CornerRadius = UDim.new(1, 0)
MinimizeBtnCorner.Parent = MinimizeBtn

-- Painel de Perfil (Direita)
ProfilePanel.Name = "ProfilePanel"
ProfilePanel.Parent = MainFrame
ProfilePanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ProfilePanel.BorderSizePixel = 0
ProfilePanel.Position = UDim2.new(1, 0, 0, 40)
ProfilePanel.Size = UDim2.new(0, 200, 1, -40)

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, 15)
ProfileCorner.Parent = ProfilePanel

ProfileGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
}
ProfileGradient.Rotation = 180
ProfileGradient.Parent = ProfilePanel

-- Caveira no Perfil
ProfileSkull.Name = "ProfileSkull"
ProfileSkull.Parent = ProfilePanel
ProfileSkull.BackgroundTransparency = 1
ProfileSkull.Position = UDim2.new(0, 10, 0, 10)
ProfileSkull.Size = UDim2.new(0, 20, 0, 20)
ProfileSkull.Image = skullIcon
ProfileSkull.ImageColor3 = Color3.fromRGB(255, 50, 50)
ProfileSkull.ScaleType = Enum.ScaleType.Fit

-- Título do Perfil
ProfileTitle.Name = "ProfileTitle"
ProfileTitle.Parent = ProfilePanel
ProfileTitle.BackgroundTransparency = 1
ProfileTitle.Position = UDim2.new(0, 35, 0, 10)
ProfileTitle.Size = UDim2.new(1, -45, 0, 20)
ProfileTitle.Font = Enum.Font.GothamBold
ProfileTitle.Text = "PERFIL"
ProfileTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
ProfileTitle.TextSize = 14
ProfileTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Imagem de Perfil
ProfileImage.Name = "ProfileImage"
ProfileImage.Parent = ProfilePanel
ProfileImage.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ProfileImage.BorderSizePixel = 0
ProfileImage.Position = UDim2.new(0.5, -50, 0, 40)
ProfileImage.Size = UDim2.new(0, 100, 0, 100)
ProfileImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)

local ProfileImageCorner = Instance.new("UICorner")
ProfileImageCorner.CornerRadius = UDim.new(1, 0)
ProfileImageCorner.Parent = ProfileImage

local ImageBorder = Instance.new("UIStroke")
ImageBorder.Color = Color3.fromRGB(150, 150, 150)
ImageBorder.Thickness = 3
ImageBorder.Parent = ProfileImage

-- Nome do Player
PlayerNameLabel.Name = "PlayerNameLabel"
PlayerNameLabel.Parent = ProfilePanel
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.Position = UDim2.new(0, 10, 0, 150)
PlayerNameLabel.Size = UDim2.new(1, -20, 0, 20)
PlayerNameLabel.Font = Enum.Font.GothamBold
PlayerNameLabel.Text = "👤 " .. LocalPlayer.Name
PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameLabel.TextSize = 13
PlayerNameLabel.TextWrapped = true

-- ID do Player
PlayerIDLabel.Name = "PlayerIDLabel"
PlayerIDLabel.Parent = ProfilePanel
PlayerIDLabel.BackgroundTransparency = 1
PlayerIDLabel.Position = UDim2.new(0, 10, 0, 175)
PlayerIDLabel.Size = UDim2.new(1, -20, 0, 20)
PlayerIDLabel.Font = Enum.Font.Gotham
PlayerIDLabel.Text = "🆔 " .. LocalPlayer.UserId
PlayerIDLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
PlayerIDLabel.TextSize = 12

-- Tempo de Sessão
SessionTimeLabel.Name = "SessionTimeLabel"
SessionTimeLabel.Parent = ProfilePanel
SessionTimeLabel.BackgroundTransparency = 1
SessionTimeLabel.Position = UDim2.new(0, 10, 0, 200)
SessionTimeLabel.Size = UDim2.new(1, -20, 0, 20)
SessionTimeLabel.Font = Enum.Font.Gotham
SessionTimeLabel.Text = "⏱️ 00:00:00"
SessionTimeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
SessionTimeLabel.TextSize = 12

-- Botão Toggle (Seta)
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(1, -25, 0, 200)
ToggleButton.Size = UDim2.new(0, 25, 0, 50)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "◀"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

-- Painel de Backdoors Encontrados
BackdoorPanel.Name = "BackdoorPanel"
BackdoorPanel.Parent = MainFrame
BackdoorPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BackdoorPanel.BorderSizePixel = 0
BackdoorPanel.Position = UDim2.new(0, 15, 0, 55)
BackdoorPanel.Size = UDim2.new(0.35, -10, 0, 140)
BackdoorPanel.ScrollBarThickness = 5
BackdoorPanel.CanvasSize = UDim2.new(0, 0, 0, 0)

local BackdoorPanelCorner = Instance.new("UICorner")
BackdoorPanelCorner.CornerRadius = UDim.new(0, 10)
BackdoorPanelCorner.Parent = BackdoorPanel

BackdoorPanelGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
}
BackdoorPanelGradient.Rotation = 90
BackdoorPanelGradient.Parent = BackdoorPanel

BackdoorTitle.Name = "BackdoorTitle"
BackdoorTitle.Parent = BackdoorPanel
BackdoorTitle.BackgroundTransparency = 1
BackdoorTitle.Position = UDim2.new(0, 0, 0, 5)
BackdoorTitle.Size = UDim2.new(1, 0, 0, 25)
BackdoorTitle.Font = Enum.Font.GothamBold
BackdoorTitle.Text = "🔓 BACKDOORS"
BackdoorTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
BackdoorTitle.TextSize = 11

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = BackdoorPanel
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Caixa de Script
ScriptBox.Name = "ScriptBox"
ScriptBox.Parent = MainFrame
ScriptBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ScriptBox.BorderSizePixel = 0
ScriptBox.Position = UDim2.new(0.35, 5, 0, 55)
ScriptBox.Size = UDim2.new(0.65, -20, 0, 140)
ScriptBox.ClearTextOnFocus = false
ScriptBox.Font = Enum.Font.Code
ScriptBox.MultiLine = true
ScriptBox.PlaceholderText = "-- Cole seu script aqui..."
ScriptBox.Text = ""
ScriptBox.TextColor3 = Color3.fromRGB(200, 200, 200)
ScriptBox.TextSize = 13
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top

local ScriptBoxCorner = Instance.new("UICorner")
ScriptBoxCorner.CornerRadius = UDim.new(0, 10)
ScriptBoxCorner.Parent = ScriptBox

ScriptBoxGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
}
ScriptBoxGradient.Rotation = 90
ScriptBoxGradient.Parent = ScriptBox

-- Status de Backdoor
BackdoorStatus.Name = "BackdoorStatus"
BackdoorStatus.Parent = MainFrame
BackdoorStatus.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BackdoorStatus.BorderSizePixel = 0
BackdoorStatus.Position = UDim2.new(0, 15, 0, 205)
BackdoorStatus.Size = UDim2.new(1, -30, 0, 30)

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = BackdoorStatus

StatusGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
StatusGradient.Rotation = 90
StatusGradient.Parent = BackdoorStatus

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = BackdoorStatus
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 35, 0, 0)
StatusLabel.Size = UDim2.new(1, -40, 1, 0)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "Executor pronto para uso!"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

StatusIndicator.Name = "StatusIndicator"
StatusIndicator.Parent = BackdoorStatus
StatusIndicator.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
StatusIndicator.BorderSizePixel = 0
StatusIndicator.Position = UDim2.new(0, 10, 0.5, -7)
StatusIndicator.Size = UDim2.new(0, 14, 0, 14)

local IndicatorCorner = Instance.new("UICorner")
IndicatorCorner.CornerRadius = UDim.new(1, 0)
IndicatorCorner.Parent = StatusIndicator

-- Botão Criar Backdoor
CreateBackdoorBtn.Name = "CreateBackdoorBtn"
CreateBackdoorBtn.Parent = MainFrame
CreateBackdoorBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CreateBackdoorBtn.BorderSizePixel = 0
CreateBackdoorBtn.Position = UDim2.new(0, 15, 0, 245)
CreateBackdoorBtn.Size = UDim2.new(1, -30, 0, 35)
CreateBackdoorBtn.Font = Enum.Font.GothamBold
CreateBackdoorBtn.Text = "     CRIAR BACKDOOR"
CreateBackdoorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CreateBackdoorBtn.TextSize = 13
CreateBackdoorBtn.TextXAlignment = Enum.TextXAlignment.Center

local CreateBackdoorCorner = Instance.new("UICorner")
CreateBackdoorCorner.CornerRadius = UDim.new(0, 10)
CreateBackdoorCorner.Parent = CreateBackdoorBtn

CreateBackdoorGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 40, 40))
}
CreateBackdoorGradient.Rotation = 90
CreateBackdoorGradient.Parent = CreateBackdoorBtn

CreateBackdoorSkull.Name = "CreateBackdoorSkull"
CreateBackdoorSkull.Parent = CreateBackdoorBtn
CreateBackdoorSkull.BackgroundTransparency = 1
CreateBackdoorSkull.Position = UDim2.new(0, 10, 0.5, -12)
CreateBackdoorSkull.Size = UDim2.new(0, 24, 0, 24)
CreateBackdoorSkull.Image = skullIcon
CreateBackdoorSkull.ImageColor3 = Color3.fromRGB(255, 255, 255)
CreateBackdoorSkull.ScaleType = Enum.ScaleType.Fit

-- Botão Escanear
ScanBtn.Name = "ScanBtn"
ScanBtn.Parent = MainFrame
ScanBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ScanBtn.BorderSizePixel = 0
ScanBtn.Position = UDim2.new(0, 15, 0, 290)
ScanBtn.Size = UDim2.new(1, -30, 0, 30)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.Text = "     ESCANEAR BACKDOORS"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.TextSize = 12
ScanBtn.TextXAlignment = Enum.TextXAlignment.Center

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 10)
ScanCorner.Parent = ScanBtn

ScanGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 40, 200))
}
ScanGradient.Rotation = 90
ScanGradient.Parent = ScanBtn

ScanSkull.Name = "ScanSkull"
ScanSkull.Parent = ScanBtn
ScanSkull.BackgroundTransparency = 1
ScanSkull.Position = UDim2.new(0, 10, 0.5, -10)
ScanSkull.Size = UDim2.new(0, 20, 0, 20)
ScanSkull.Image = skullIcon
ScanSkull.ImageColor3 = Color3.fromRGB(255, 255, 255)
ScanSkull.ScaleType = Enum.ScaleType.Fit

-- Botão Executar
ExecuteBtn.Name = "ExecuteBtn"
ExecuteBtn.Parent = MainFrame
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ExecuteBtn.BorderSizePixel = 0
ExecuteBtn.Position = UDim2.new(0, 15, 1, -38)
ExecuteBtn.Size = UDim2.new(0.48, -10, 0, 30)
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.Text = "     EXECUTAR"
ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBtn.TextSize = 12

local ExecuteCorner = Instance.new("UICorner")
ExecuteCorner.CornerRadius = UDim.new(0, 10)
ExecuteCorner.Parent = ExecuteBtn

ExecuteGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 200, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 150, 40))
}
ExecuteGradient.Rotation = 90
ExecuteGradient.Parent = ExecuteBtn

ExecuteSkull.Name = "ExecuteSkull"
ExecuteSkull.Parent = ExecuteBtn
ExecuteSkull.BackgroundTransparency = 1
ExecuteSkull.Position = UDim2.new(0, 10, 0.5, -10)
ExecuteSkull.Size = UDim2.new(0, 20, 0, 20)
ExecuteSkull.Image = skullIcon
ExecuteSkull.ImageColor3 = Color3.fromRGB(255, 255, 255)
ExecuteSkull.ScaleType = Enum.ScaleType.Fit

-- Botão Limpar
ClearBtn.Name = "ClearBtn"
ClearBtn.Parent = MainFrame
ClearBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ClearBtn.BorderSizePixel = 0
ClearBtn.Position = UDim2.new(0.52, 5, 1, -38)
ClearBtn.Size = UDim2.new(0.48, -20, 0, 30)
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.Text = "🗑️ LIMPAR"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.TextSize = 12

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 10)
ClearCorner.Parent = ClearBtn

ClearGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 80, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 40, 40))
}
ClearGradient.Rotation = 90
ClearGradient.Parent = ClearBtn

-- FUNÇÕES

-- Função de notificação
local function notify(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 3;
    })
end

-- Função para tocar som de inicialização
local function playInitSound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = executeSound
        sound.Volume = 0.6
        sound.Parent = game.SoundService
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
end

-- Animação de gradiente rotativo
spawn(function()
    while wait(0.05) do
        MainGradient.Rotation = (MainGradient.Rotation + 1) % 360
    end
end)

-- Atualizar tempo de sessão
spawn(function()
    while wait(1) do
        local elapsed = tick() - SessionStart
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = math.floor(elapsed % 60)
        SessionTimeLabel.Text = string.format("⏱️ %02d:%02d:%02d", hours, minutes, seconds)
    end
end)

-- Função para animar botões
local function animateButton(button, scale)
    local tween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = button.Size + UDim2.new(0, scale, 0, scale)
    })
    tween:Play()
    wait(0.2)
    local tween2 = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = button.Size - UDim2.new(0, scale, 0, scale)
    })
    tween2:Play()
end

-- Função para atualizar status
local function updateStatus(text, color)
    StatusLabel.Text = text
    StatusIndicator.BackgroundColor3 = color
    
    local tween = TweenService:Create(StatusIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 18, 0, 18)
    })
    tween:Play()
    wait(0.5)
    local tween2 = TweenService:Create(StatusIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 14, 0, 14)
    })
    tween2:Play()
end

-- Função para executar código diretamente (SEM PROTEÇÃO)
local function executeCode(code)
    local success, err = pcall(function()
        local func = loadstring(code)
        if func then
            func()
        end
    end)
    return success, err
end

-- Função para criar backdoor funcional SEM PROTEÇÃO
local function createCustomBackdoor()
    updateStatus("🔧 Criando backdoor...", Color3.fromRGB(255, 200, 50))
    
    local success = pcall(function()
        -- Criar o backdoor
        local backdoorName = "KillerBackdoor_" .. math.random(1000, 9999)
        
        -- Criar LocalScript dentro do PlayerGui para executar localmente
        local localScript = Instance.new("LocalScript")
        localScript.Name = backdoorName
        
        -- Código do backdoor (executa localmente sem proteção)
        local backdoorCode = [[
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            
            -- Criar BindableEvent para comunicação
            local bindable = Instance.new("BindableEvent")
            bindable.Name = "]] .. backdoorName .. [[_Trigger"
            bindable.Parent = game.ReplicatedStorage
            
            -- Listener que executa qualquer código recebido
            bindable.Event:Connect(function(code)
                local success, err = pcall(function()
                    loadstring(code)()
                end)
            end)
            
            -- Manter ativo
            while wait(1) do
                if not bindable or not bindable.Parent then
                    break
                end
            end
        ]]
        
        localScript.Source = backdoorCode
        localScript.Parent = LocalPlayer.PlayerGui
        
        wait(0.5)
        
        -- Pegar referência ao BindableEvent criado
        local bindableEvent = ReplicatedStorage:WaitForChild(backdoorName .. "_Trigger", 5)
        
        if bindableEvent then
            createdBackdoor = {
                name = backdoorName,
                remote = bindableEvent,
                type = "bindable"
            }
            
            -- Adicionar à lista
            table.insert(foundBackdoors, createdBackdoor)
            addBackdoorToList(backdoorName .. " [ATIVO]", bindableEvent, "bindable")
            
            wait(1)
            updateStatus("✅ Backdoor ativo: " .. backdoorName, Color3.fromRGB(50, 200, 50))
            notify("✅ SUCESSO", "Backdoor criado e funcional!", 4)
        else
            updateStatus("⚠️ Backdoor criado mas aguardando...", Color3.fromRGB(255, 150, 50))
            notify("⚠️ AVISO", "Backdoor em processo...", 3)
        end
    end)
    
    if not success then
        updateStatus("❌ Erro ao criar backdoor!", Color3.fromRGB(200, 50, 50))
        notify("❌ ERRO", "Falha ao criar backdoor!", 3)
    end
end

-- Função para adicionar backdoor à lista
function addBackdoorToList(name, remotePath, remoteType)
    local BackdoorItem = Instance.new("Frame")
    local ItemGradient = Instance.new("UIGradient")
    local BackdoorName = Instance.new("TextLabel")
    local SkullIcon = Instance.new("ImageLabel")
    local UseButton = Instance.new("TextButton")
    
    BackdoorItem.Name = "BackdoorItem"
    BackdoorItem.Parent = BackdoorPanel
    BackdoorItem.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    BackdoorItem.BorderSizePixel = 0
    BackdoorItem.Size = UDim2.new(1, -10, 0, 40)
    
    local ItemCorner = Instance.new("UICorner")
    ItemCorner.CornerRadius = UDim.new(0, 8)
    ItemCorner.Parent = BackdoorItem
    
    ItemGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    }
    ItemGradient.Rotation = 45
    ItemGradient.Parent = BackdoorItem
    
    SkullIcon.Name = "SkullIcon"
    SkullIcon.Parent = BackdoorItem
    SkullIcon.BackgroundTransparency = 1
    SkullIcon.Position = UDim2.new(0, 5, 0.5, -8)
    SkullIcon.Size = UDim2.new(0, 16, 0, 16)
    SkullIcon.Image = skullIcon
    SkullIcon.ImageColor3 = Color3.fromRGB(255, 100, 100)
    SkullIcon.ScaleType = Enum.ScaleType.Fit
    
    BackdoorName.Name = "BackdoorName"
    BackdoorName.Parent = BackdoorItem
    BackdoorName.BackgroundTransparency = 1
    BackdoorName.Position = UDim2.new(0, 25, 0, 0)
    BackdoorName.Size = UDim2.new(0.55, -25, 1, 0)
    BackdoorName.Font = Enum.Font.GothamBold
    BackdoorName.Text = name
    BackdoorName.TextColor3 = Color3.fromRGB(150, 255, 150)
    BackdoorName.TextSize = 9
    BackdoorName.TextXAlignment = Enum.TextXAlignment.Left
    BackdoorName.TextWrapped = true
    
    UseButton.Name = "UseButton"
    UseButton.Parent = BackdoorItem
    UseButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
    UseButton.BorderSizePixel = 0
    UseButton.Position = UDim2.new(0.6, 0, 0.25, 0)
    UseButton.Size = UDim2.new(0.35, 0, 0.5, 0)
    UseButton.Font = Enum.Font.GothamBold
    UseButton.Text = "USAR"
    UseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    UseButton.TextSize = 9
    
    local UseCorner = Instance.new("UICorner")
    UseCorner.CornerRadius = UDim.new(0, 6)
    UseCorner.Parent = UseButton
    
    UseButton.MouseButton1Click:Connect(function()
        local script = ScriptBox.Text
        if script == "" then
            notify("⚠️ AVISO", "Cole um script primeiro!", 3)
            return
        end
        
        updateStatus("⚡ Executando via " .. name .. "...", Color3.fromRGB(255, 200, 50))
        
        if remoteType == "bindable" then
            -- Executa usando BindableEvent (SEM PROTEÇÃO)
            pcall(function()
                remotePath:Fire(script)
            end)
            wait(0.3)
            updateStatus("✅ Script executado!", Color3.fromRGB(50, 200, 50))
            notify("✅ SUCESSO", "Script executado com sucesso!", 3)
        else
            -- Tenta usar RemoteEvent normal
            pcall(function()
                remotePath:FireServer(script)
            end)
            wait(0.3)
            updateStatus("✅ Script enviado!", Color3.fromRGB(50, 200, 50))
            notify("✅ ENVIADO", "Script enviado ao servidor!", 3)
        end
    end)
    
    BackdoorPanel.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 35)
end

-- Função para escanear backdoors no jogo
local function scanForBackdoors()
    foundBackdoors = {}
    
    -- Limpar painel
    for _, child in ipairs(BackdoorPanel:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    updateStatus("🔍 Escaneando...", Color3.fromRGB(255, 200, 50))
    
    local backdoorNames = {
        "MainEvent", "RemoteEvent", "RemoteFunction", "Event", "Remote",
        "MainRemote", "Bindable", "RE", "RF", "Backdoor", "Admin",
        "AdminPanel", "AdminCommands", "CommandBar", "HD_AdminPanel",
        "Hint", "Message", "RemoteControl", "ServerControl", "Service",
        "Connection", "NetworkEvent", "ServerEvent", "ClientEvent",
        "GameEvent", "PlayerEvent", "CustomEvent", "Signal", "Trigger"
    }
    
    local function searchInContainer(container, depth)
        if depth > 8 then return end
        
        pcall(function()
            for _, obj in ipairs(container:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    for _, name in ipairs(backdoorNames) do
                        if string.find(obj.Name:lower(), name:lower()) then
                            table.insert(foundBackdoors, {name = obj.Name, path = obj:GetFullName(), remote = obj, type = "remote"})
                            break
                        end
                    end
                    
                    if #obj.Name <= 3 or obj.Name:match("%d+") then
                        table.insert(foundBackdoors, {name = obj.Name, path = obj:GetFullName(), remote = obj, type = "remote"})
                    end
                end
            end
        end)
    end
    
    searchInContainer(ReplicatedStorage, 0)
    searchInContainer(game.Workspace, 0)
    
    pcall(function()
        searchInContainer(game.Lighting, 0)
    end)
    
    wait(2)
    
    if #foundBackdoors > 0 then
        updateStatus("✅ " .. #foundBackdoors .. " backdoor(s) encontrado(s)!", Color3.fromRGB(50, 200, 50))
        notify("🔓 BACKDOORS", "Encontrados " .. #foundBackdoors .. " backdoors!", 4)
        
        for _, bd in ipairs(foundBackdoors) do
            addBackdoorToList(bd.name, bd.remote, bd.type)
        end
    else
        updateStatus("❌ Nenhum backdoor encontrado!", Color3.fromRGB(200, 50, 50))
        notify("⚠️ AVISO", "Nenhum backdoor detectado!", 4)
    end
end

-- Botão Criar Backdoor
CreateBackdoorBtn.MouseButton1Click:Connect(function()
    animateButton(CreateBackdoorBtn, 5)
    createCustomBackdoor()
end)

-- Botão Escanear
ScanBtn.MouseButton1Click:Connect(function()
    animateButton(ScanBtn, 5)
    scanForBackdoors()
end)

-- Botão Executar
ExecuteBtn.MouseButton1Click:Connect(function()
    animateButton(ExecuteBtn, 5)
    
    local script = ScriptBox.Text
    if script == "" then
        notify("⚠️ AVISO", "Cole um script primeiro!", 3)
        updateStatus("⚠️ Script vazio!", Color3.fromRGB(200, 150, 50))
        return
    end
    
    -- Se tem backdoor criado, usa ele
    if createdBackdoor then
        updateStatus("⚡ Executando via backdoor...", Color3.fromRGB(255, 200, 50))
        
        pcall(function()
            createdBackdoor.remote:Fire(script)
        end)
        
        wait(0.3)
        updateStatus("✅ Script executado!", Color3.fromRGB(50, 200, 50))
        notify("✅ SUCESSO", "Script executado!", 3)
        return
    end
    
    -- Se não tem, tenta executar direto
    if #foundBackdoors == 0 then
        updateStatus("⚡ Executando localmente...", Color3.fromRGB(255, 200, 50))
        
        local success, err = executeCode(script)
        
        wait(0.3)
        
        if success then
            updateStatus("✅ Executado localmente!", Color3.fromRGB(50, 200, 50))
            notify("✅ SUCESSO", "Script executado!", 3)
        else
            updateStatus("❌ Erro: " .. tostring(err), Color3.fromRGB(200, 50, 50))
            notify("❌ ERRO", tostring(err), 5)
        end
        return
    end
    
    -- Tenta usar backdoors encontrados
    updateStatus("⚡ Executando...", Color3.fromRGB(255, 200, 50))
    
    local success = false
    for _, bd in ipairs(foundBackdoors) do
        pcall(function()
            bd.remote:FireServer(script)
            success = true
        end)
        if success then break end
    end
    
    wait(0.3)
    
    if success then
        updateStatus("✅ Script enviado!", Color3.fromRGB(50, 200, 50))
        notify("✅ SUCESSO", "Script enviado!", 3)
    else
        updateStatus("⚠️ Tentativa concluída", Color3.fromRGB(255, 150, 50))
        notify("⚠️ PROCESSADO", "Script processado!", 3)
    end
end)

-- Botão Limpar
ClearBtn.MouseButton1Click:Connect(function()
    animateButton(ClearBtn, 5)
    ScriptBox.Text = ""
    updateStatus("🗑️ Script limpo!", Color3.fromRGB(150, 150, 150))
    notify("🗑️ LIMPO", "Caixa limpa!", 2)
end)

-- Botão Fechar
CloseBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    tween:Play()
    wait(0.5)
    KillerExecutor:Destroy()
end)

-- Botão Minimizar
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 600, 0, 40) or UDim2.new(0, 600, 0, 400)
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = targetSize
    })
    tween:Play()
end)

-- Toggle do Painel de Perfil
local profileOpen = false
ToggleButton.MouseButton1Click:Connect(function()
    profileOpen = not profileOpen
    
    local targetPos = profileOpen and UDim2.new(1, -200, 0, 40) or UDim2.new(1, 0, 0, 40)
    local buttonText = profileOpen and "▶" or "◀"
    
    local tween = TweenService:Create(ProfilePanel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = targetPos
    })
    tween:Play()
    
    ToggleButton.Text = buttonText
end)

-- Efeitos de hover
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        })
        tween:Play()
    end)
end

addHoverEffect(ExecuteBtn)
addHoverEffect(ScanBtn)
addHoverEffect(ClearBtn)
addHoverEffect(ToggleButton)
addHoverEffect(CreateBackdoorBtn)

-- Animação de entrada
MainFrame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 600, 0, 400)
})
openTween:Play()

-- Animação pulsante nas caveiras
spawn(function()
    while wait(1.5) do
        local tween = TweenService:Create(SkullLogo, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            ImageColor3 = Color3.fromRGB(255, 100, 100)
        })
        tween:Play()
        wait(0.5)
        local tween2 = TweenService:Create(SkullLogo, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            ImageColor3 = Color3.fromRGB(255, 50, 50)
        })
        tween2:Play()
    end
end)

spawn(function()
    while wait(1.5) do
        local tween = TweenService:Create(ProfileSkull, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            ImageColor3 = Color3.fromRGB(255, 100, 100)
        })
        tween:Play()
        wait(0.5)
        local tween2 = TweenService:Create(ProfileSkull, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            ImageColor3 = Color3.fromRGB(255, 50, 50)
        })
        tween2:Play()
    end
end)

-- Tocar som de inicialização
playInitSound()

-- Notificação de inicialização
notify("💀 KILLER EXECUTOR", "Executor carregado!", 4)
updateStatus("✅ Sistema pronto!", Color3.fromRGB(50, 200, 50))
