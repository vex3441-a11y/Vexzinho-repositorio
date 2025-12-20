-- Configuração inicial
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

-- Variáveis globais
local remoteEvents = {}
local remoteFunctions = {}
local bindableEvents = {}
local bindableFunctions = {}
local scanned = false

-- Função para verificar se é seguro escanear
local function isSafe()
    return pcall(function()
        return game:GetService("Players").LocalPlayer
    end)
end

-- Função para escanear RemoteEvents
local function scanRemotes()
    remoteEvents = {}
    remoteFunctions = {}
    bindableEvents = {}
    bindableFunctions = {}
    
    -- Função recursiva para buscar em todos os lugares
    local function searchInInstance(instance, path)
        if not instance then return end
        
        for _, child in ipairs(instance:GetChildren()) do
            local newPath = path .. "." .. child.Name
            
            -- Verificar tipo de objeto
            if child:IsA("RemoteEvent") then
                table.insert(remoteEvents, {
                    Name = child.Name,
                    Path = newPath,
                    Instance = child,
                    Parent = child.Parent.Name
                })
            elseif child:IsA("RemoteFunction") then
                table.insert(remoteFunctions, {
                    Name = child.Name,
                    Path = newPath,
                    Instance = child,
                    Parent = child.Parent.Name
                })
            elseif child:IsA("BindableEvent") then
                table.insert(bindableEvents, {
                    Name = child.Name,
                    Path = newPath,
                    Instance = child,
                    Parent = child.Parent.Name
                })
            elseif child:IsA("BindableFunction") then
                table.insert(bindableFunctions, {
                    Name = child.Name,
                    Path = newPath,
                    Instance = child,
                    Parent = child.Parent.Name
                })
            end
            
            -- Continuar busca recursiva
            searchInInstance(child, newPath)
        end
    end
    
    -- Começar a busca pela raiz do jogo
    searchInInstance(game, "game")
    
    -- Buscar também em serviços específicos
    for _, service in ipairs(game:GetChildren()) do
        if service:IsA("ModuleScript") == false then
            searchInInstance(service, "game." .. service.Name)
        end
    end
    
    scanned = true
    return true
end

-- Função para formatar os resultados como texto
local function formatResults()
    local result = "-- REMOTE SCANNER RESULTS --\n"
    result = result .. "Generated at: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
    result = result .. "Game: " .. game.PlaceId .. "\n\n"
    
    -- RemoteEvents
    result = result .. "=== REMOTE EVENTS (" .. #remoteEvents .. ") ===\n"
    for i, remote in ipairs(remoteEvents) do
        result = result .. string.format("[%d] %s\n", i, remote.Name)
        result = result .. string.format("    Path: %s\n", remote.Path)
        result = result .. string.format("    Parent: %s\n\n", remote.Parent)
    end
    
    -- RemoteFunctions
    result = result .. "=== REMOTE FUNCTIONS (" .. #remoteFunctions .. ") ===\n"
    for i, remote in ipairs(remoteFunctions) do
        result = result .. string.format("[%d] %s\n", i, remote.Name)
        result = result .. string.format("    Path: %s\n", remote.Path)
        result = result .. string.format("    Parent: %s\n\n", remote.Parent)
    end
    
    -- BindableEvents
    result = result .. "=== BINDABLE EVENTS (" .. #bindableEvents .. ") ===\n"
    for i, bindable in ipairs(bindableEvents) do
        result = result .. string.format("[%d] %s\n", i, bindable.Name)
        result = result .. string.format("    Path: %s\n", bindable.Path)
        result = result .. string.format("    Parent: %s\n\n", bindable.Parent)
    end
    
    -- BindableFunctions
    result = result .. "=== BINDABLE FUNCTIONS (" .. #bindableFunctions .. ") ===\n"
    for i, bindable in ipairs(bindableFunctions) do
        result = result .. string.format("[%d] %s\n", i, bindable.Name)
        result = result .. string.format("    Path: %s\n", bindable.Path)
        result = result .. string.format("    Parent: %s\n\n", bindable.Parent)
    end
    
    result = result .. "\n-- TOTAL OBJECTS FOUND --\n"
    result = result .. string.format("RemoteEvents: %d\n", #remoteEvents)
    result = result .. string.format("RemoteFunctions: %d\n", #remoteFunctions)
    result = result .. string.format("BindableEvents: %d\n", #bindableEvents)
    result = result .. string.format("BindableFunctions: %d\n", #bindableFunctions)
    result = result .. string.format("Total: %d\n", #remoteEvents + #remoteFunctions + #bindableEvents + #bindableFunctions)
    
    return result
end

-- Função para copiar texto para área de transferência
local function copyToClipboard(text)
    local success, message = pcall(function()
        if setclipboard then
            setclipboard(text)
            return true
        elseif writeclipboard then
            writeclipboard(text)
            return true
        elseif toclipboard then
            toclipboard(text)
            return true
        end
        return false
    end)
    
    return success and message ~= false
end

-- Criar interface
local function createGUI()
    -- Criar tela principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RemoteScannerGUI"
    screenGui.ResetOnSpawn = false
    
    if gethui then
        screenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = CoreGui
    else
        screenGui.Parent = CoreGui
    end
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.BorderSizePixel = 0
    title.Text = "REMOTE SCANNER"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    
    -- Área de resultados
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ResultsScroll"
    scrollFrame.Size = UDim2.new(1, -20, 1, -180)
    scrollFrame.Position = UDim2.new(0, 10, 0, 60)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = mainFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 6)
    scrollCorner.Parent = scrollFrame
    
    -- Container de resultados
    local resultsContainer = Instance.new("Frame")
    resultsContainer.Name = "ResultsContainer"
    resultsContainer.Size = UDim2.new(1, 0, 0, 0)
    resultsContainer.BackgroundTransparency = 1
    resultsContainer.Parent = scrollFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = resultsContainer
    
    -- Botões
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, -20, 0, 100)
    buttonContainer.Position = UDim2.new(0, 10, 1, -110)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = mainFrame
    
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    buttonLayout.Padding = UDim.new(0, 10)
    buttonLayout.Parent = buttonContainer
    
    -- Botão de scan
    local scanButton = Instance.new("TextButton")
    scanButton.Name = "ScanButton"
    scanButton.Size = UDim2.new(0, 150, 0, 40)
    scanButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    scanButton.BorderSizePixel = 0
    scanButton.Text = "SCAN REMOTES"
    scanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    scanButton.TextSize = 18
    scanButton.Font = Enum.Font.GothamBold
    scanButton.Parent = buttonContainer
    
    local scanCorner = Instance.new("UICorner")
    scanCorner.CornerRadius = UDim.new(0, 6)
    scanCorner.Parent = scanButton
    
    -- Botão de copiar
    local copyButton = Instance.new("TextButton")
    copyButton.Name = "CopyButton"
    copyButton.Size = UDim2.new(0, 150, 0, 40)
    copyButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    copyButton.BorderSizePixel = 0
    copyButton.Text = "COPY RESULTS"
    copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyButton.TextSize = 18
    copyButton.Font = Enum.Font.GothamBold
    copyButton.Parent = buttonContainer
    
    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, 6)
    copyCorner.Parent = copyButton
    
    -- Botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    -- Status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -20, 0, 30)
    statusLabel.Position = UDim2.new(0, 10, 1, -150)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Ready to scan"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = mainFrame
    
    -- Função para adicionar item à lista
    local function addResultItem(type, name, path)
        local itemFrame = Instance.new("Frame")
        itemFrame.Name = "ResultItem"
        itemFrame.Size = UDim2.new(1, 0, 0, 60)
        itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        itemFrame.BorderSizePixel = 0
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 4)
        itemCorner.Parent = itemFrame
        
        local typeLabel = Instance.new("TextLabel")
        typeLabel.Name = "Type"
        typeLabel.Size = UDim2.new(0, 120, 0, 20)
        typeLabel.Position = UDim2.new(0, 10, 0, 5)
        typeLabel.BackgroundTransparency = 1
        typeLabel.Text = "[" .. type .. "]"
        typeLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
        typeLabel.TextSize = 14
        typeLabel.Font = Enum.Font.GothamBold
        typeLabel.TextXAlignment = Enum.TextXAlignment.Left
        typeLabel.Parent = itemFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "Name"
        nameLabel.Size = UDim2.new(1, -20, 0, 20)
        nameLabel.Position = UDim2.new(0, 10, 0, 25)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.Parent = itemFrame
        
        local pathLabel = Instance.new("TextLabel")
        pathLabel.Name = "Path"
        pathLabel.Size = UDim2.new(1, -20, 0, 15)
        pathLabel.Position = UDim2.new(0, 10, 0, 45)
        pathLabel.BackgroundTransparency = 1
        pathLabel.Text = path
        pathLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        pathLabel.TextSize = 12
        pathLabel.Font = Enum.Font.Gotham
        pathLabel.TextXAlignment = Enum.TextXAlignment.Left
        pathLabel.TextTruncate = Enum.TextTruncate.AtEnd
        pathLabel.Parent = itemFrame
        
        itemFrame.Parent = resultsContainer
        
        return itemFrame
    end
    
    -- Função para limpar resultados
    local function clearResults()
        for _, child in ipairs(resultsContainer:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
    end
    
    -- Função para atualizar resultados na interface
    local function updateResultsUI()
        clearResults()
        
        local totalCount = 0
        
        -- Adicionar RemoteEvents
        if #remoteEvents > 0 then
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, 0, 0, 30)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = "REMOTE EVENTS (" .. #remoteEvents .. ")"
            sectionLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            sectionLabel.TextSize = 16
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = resultsContainer
            
            for _, remote in ipairs(remoteEvents) do
                addResultItem("RemoteEvent", remote.Name, remote.Path)
                totalCount = totalCount + 1
            end
        end
        
        -- Adicionar RemoteFunctions
        if #remoteFunctions > 0 then
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, 0, 0, 30)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = "REMOTE FUNCTIONS (" .. #remoteFunctions .. ")"
            sectionLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
            sectionLabel.TextSize = 16
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = resultsContainer
            
            for _, remote in ipairs(remoteFunctions) do
                addResultItem("RemoteFunction", remote.Name, remote.Path)
                totalCount = totalCount + 1
            end
        end
        
        statusLabel.Text = "Found " .. totalCount .. " remote objects"
    end
    
    -- Conectar botões
    scanButton.MouseButton1Click:Connect(function()
        if not isSafe() then
            statusLabel.Text = "Error: Game protection active"
            return
        end
        
        statusLabel.Text = "Scanning..."
        scanButton.Text = "SCANNING..."
        scanButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        local success = pcall(function()
            return scanRemotes()
        end)
        
        if success then
            updateResultsUI()
            statusLabel.Text = "Scan complete! Found " .. (#remoteEvents + #remoteFunctions) .. " remote objects"
            scanButton.Text = "RESCAN"
        else
            statusLabel.Text = "Scan failed!"
        end
        
        scanButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    end)
    
    copyButton.MouseButton1Click:Connect(function()
        if not scanned then
            statusLabel.Text = "Scan first before copying!"
            return
        end
        
        local resultsText = formatResults()
        local success = copyToClipboard(resultsText)
        
        if success then
            statusLabel.Text = "Results copied to clipboard!"
            copyButton.Text = "COPIED!"
            
            task.wait(1)
            copyButton.Text = "COPY RESULTS"
        else
            statusLabel.Text = "Failed to copy to clipboard!"
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Efeitos de hover
    local function setupButtonHover(button, normalColor, hoverColor)
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = hoverColor
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = normalColor
        end)
    end
    
    setupButtonHover(scanButton, Color3.fromRGB(60, 120, 200), Color3.fromRGB(80, 140, 220))
    setupButtonHover(copyButton, Color3.fromRGB(80, 180, 80), Color3.fromRGB(100, 200, 100))
    setupButtonHover(closeButton, Color3.fromRGB(200, 60, 60), Color3.fromRGB(220, 80, 80))
    
    return screenGui
end

-- Inicializar
if isSafe() then
    local gui = createGUI()
    print("Remote Scanner GUI loaded!")
    print("Use the GUI to scan and copy remote objects.")
else
    warn("Game has anti-exploit protection. Scanner may not work properly.")
    
    -- Tentar escanear mesmo assim (modo silencioso)
    local success, result = pcall(scanRemotes)
    if success then
        local text = formatResults()
        print(text)
        
        if copyToClipboard then
            copyToClipboard(text)
            print("\nResults automatically copied to clipboard!")
        end
    else
        print("Failed to scan remotes:", result)
    end
end 