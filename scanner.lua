-- Scanner de Objetos e NPCs para Roblox
-- Usando Rayfield UI Library
-- Compatível com Delta, Fluxus, Arceus X, Solara e outros executores
-- Funciona em jogos publicados

-- Carregar Rayfield UI
local Rayfield
local success, err = pcall(function()
	Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
	warn("Erro ao carregar Rayfield:", err)
	warn("Tentando link alternativo...")
	Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
end

local Window = Rayfield:CreateWindow({
	Name = "🔍 Advanced NPC & Object Scanner",
	LoadingTitle = "Scanner Pro",
	LoadingSubtitle = "by Claude",
	ConfigurationSaving = {
		Enabled = false,
		FolderName = nil,
		FileName = "ScannerConfig"
	},
	Discord = {
		Enabled = false,
		Invite = "noinvitelink",
		RememberJoins = true
	},
	KeySystem = false
})

-- Variáveis globais
local lastScanResults = ""
local scanInProgress = false
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Tab principal
local MainTab = Window:CreateTab("🔍 Scanner", 4483362458)
local ResultsTab = Window:CreateTab("📋 Resultados", 4483362458)
local ConfigTab = Window:CreateTab("⚙️ Configurações", 4483362458)

-- Seção de controles
local ControlSection = MainTab:CreateSection("Controles do Scanner")

-- Configurações
local config = {
	maxNPCs = 50,
	maxObjects = 20,
	showScripts = true,
	showDistance = true,
	sortByDistance = true,
	scanRadius = math.huge,
	scanRemotes = true
}

-- Label de status
local StatusLabel = MainTab:CreateLabel("Status: Aguardando scan...")

-- Função para escanear scripts
local function scanScripts(parent, depth)
	if not config.showScripts then return {} end
	
	local scripts = {}
	depth = depth or 0
	
	if depth > 2 then return scripts end
	
	for _, child in pairs(parent:GetChildren()) do
		pcall(function()
			if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
				local scriptType = child.ClassName
				local icon = "📜"
				if scriptType == "LocalScript" then icon = "📝" 
				elseif scriptType == "ModuleScript" then icon = "📦" end
				
				table.insert(scripts, {
					name = child.Name,
					type = scriptType,
					icon = icon,
					enabled = (child:IsA("Script") or child:IsA("LocalScript")) and child.Enabled or true,
					path = child:GetFullName()
				})
			end
		end)
	end
	
	return scripts
end

-- Função principal de scan
local function performScan()
	if scanInProgress then
		Rayfield:Notify({
			Title = "⚠️ Atenção",
			Content = "Scan já em progresso!",
			Duration = 2,
			Image = 4483362458
		})
		return
	end
	
	scanInProgress = true
	StatusLabel:Set("Status: 🔄 Escaneando...")
	
	local results = {}
	table.insert(results, "╔═══════════════════════════════════════════╗")
	table.insert(results, "║       🔍 SCANNER RESULTS - RAYFIELD       ║")
	table.insert(results, "╚═══════════════════════════════════════════╝\n")
	
	-- Escanear NPCs
	table.insert(results, "━━━ 🤖 NPCs & HUMANOIDES ━━━\n")
	local npcCount = 0
	local npcData = {}
	
	for _, obj in pairs(workspace:GetDescendants()) do
		pcall(function()
			if obj:IsA("Humanoid") and obj.Parent then
				local character = obj.Parent
				if character ~= player.Character then
					local pos = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChildWhichIsA("BasePart")
					
					if pos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						local distance = (pos.Position - player.Character.HumanoidRootPart.Position).Magnitude
						
						if distance <= config.scanRadius then
							npcCount = npcCount + 1
							
							-- Escanear scripts do NPC
							local scripts = scanScripts(character, 0)
							for _, part in pairs(character:GetDescendants()) do
								if part:IsA("BasePart") then
									local partScripts = scanScripts(part, 0)
									for _, s in pairs(partScripts) do
										table.insert(scripts, s)
									end
								end
							end
							
							table.insert(npcData, {
								name = character.Name,
								health = obj.Health,
								maxHealth = obj.MaxHealth,
								walkSpeed = obj.WalkSpeed,
								jumpPower = obj.JumpPower or obj.JumpHeight or 0,
								distance = distance,
								scripts = scripts,
								humanoid = obj,
								position = pos.Position
							})
						end
					end
				end
			end
		end)
		
		if npcCount >= config.maxNPCs then break end
	end
	
	-- Ordenar NPCs por distância
	if config.sortByDistance then
		table.sort(npcData, function(a, b)
			return a.distance < b.distance
		end)
	end
	
	-- Formatar resultados dos NPCs
	for i, npc in ipairs(npcData) do
		table.insert(results, string.format("[NPC #%d] %s", i, npc.name))
		table.insert(results, string.format("  ├─ 💚 HP: %.0f/%.0f (%.1f%%)", 
			npc.health, npc.maxHealth, (npc.health/npc.maxHealth)*100))
		table.insert(results, string.format("  ├─ 🏃 WalkSpeed: %.0f", npc.walkSpeed))
		table.insert(results, string.format("  ├─ 🦘 JumpPower: %.0f", npc.jumpPower))
		
		if config.showDistance then
			table.insert(results, string.format("  ├─ 📍 Distância: %.1f studs", npc.distance))
			table.insert(results, string.format("  ├─ 📌 Posição: (%.0f, %.0f, %.0f)", 
				npc.position.X, npc.position.Y, npc.position.Z))
		end
		
		if #npc.scripts > 0 then
			table.insert(results, "  ├─ 📜 Scripts:")
			for j, script in ipairs(npc.scripts) do
				local status = script.enabled and "[ON]" or "[OFF]"
				table.insert(results, string.format("  │  %s %s (%s) %s", 
					script.icon, script.name, script.type, status))
			end
		else
			table.insert(results, "  ├─ 📜 Sem scripts detectados")
		end
		table.insert(results, "  └─────────────────────────────────\n")
	end
	
	if npcCount == 0 then
		table.insert(results, "  ⚠️ Nenhum NPC encontrado no raio especificado\n")
	end
	
	-- Escanear RemoteEvents e RemoteFunctions
	if config.scanRemotes then
		table.insert(results, "\n━━━ 📡 REMOTE EVENTS & FUNCTIONS ━━━\n")
	
	local remotes = {}
	local remoteCount = {
		RemoteEvent = 0,
		RemoteFunction = 0,
		BindableEvent = 0,
		BindableFunction = 0
	}
	
	-- Escanear em ReplicatedStorage
	for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
		pcall(function()
			if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or 
			   obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
				
				local remoteType = obj.ClassName
				remoteCount[remoteType] = remoteCount[remoteType] + 1
				
				-- Detectar tipo de remote por nome
				local category = "🔷 Genérico"
				local name = obj.Name:lower()
				
				if name:match("damage") or name:match("hit") or name:match("attack") or name:match("combat") then
					category = "⚔️ Combate"
				elseif name:match("buy") or name:match("purchase") or name:match("shop") or name:match("trade") then
					category = "💰 Economia"
				elseif name:match("chat") or name:match("message") or name:match("talk") then
					category = "💬 Chat"
				elseif name:match("admin") or name:match("kick") or name:match("ban") or name:match("mod") then
					category = "👮 Admin"
				elseif name:match("teleport") or name:match("tp") or name:match("move") then
					category = "🚀 Teleporte"
				elseif name:match("give") or name:match("add") or name:match("equip") then
					category = "🎁 Items"
				elseif name:match("player") or name:match("character") or name:match("spawn") then
					category = "👤 Player"
				elseif name:match("gui") or name:match("ui") or name:match("menu") then
					category = "🖥️ Interface"
				end
				
				local icon = "📡"
				if obj:IsA("RemoteEvent") then icon = "📤"
				elseif obj:IsA("RemoteFunction") then icon = "📥"
				elseif obj:IsA("BindableEvent") then icon = "🔗"
				elseif obj:IsA("BindableFunction") then icon = "🔀" end
				
				table.insert(remotes, {
					name = obj.Name,
					type = remoteType,
					category = category,
					icon = icon,
					path = obj:GetFullName(),
					parent = obj.Parent.Name
				})
			end
		end)
	end
	
	-- Escanear em Workspace
	for _, obj in pairs(workspace:GetDescendants()) do
		pcall(function()
			if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
				local remoteType = obj.ClassName
				remoteCount[remoteType] = remoteCount[remoteType] + 1
				
				local category = "🔷 Workspace"
				local name = obj.Name:lower()
				
				if name:match("damage") or name:match("hit") then
					category = "⚔️ Combate (WS)"
				elseif name:match("interact") or name:match("click") then
					category = "👆 Interação (WS)"
				end
				
				local icon = obj:IsA("RemoteEvent") and "📤" or "📥"
				
				table.insert(remotes, {
					name = obj.Name,
					type = remoteType,
					category = category,
					icon = icon,
					path = obj:GetFullName(),
					parent = obj.Parent.Name
				})
			end
		end)
	end
	
	-- Escanear em Players (PlayerGui, etc)
	for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
		pcall(function()
			for _, obj in pairs(plr:GetDescendants()) do
				pcall(function()
					if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
						local remoteType = obj.ClassName
						remoteCount[remoteType] = remoteCount[remoteType] + 1
						
						local icon = obj:IsA("RemoteEvent") and "📤" or "📥"
						
						table.insert(remotes, {
							name = obj.Name,
							type = remoteType,
							category = "👤 Player GUI",
							icon = icon,
							path = obj:GetFullName(),
							parent = obj.Parent.Name
						})
					end
				end)
			end
		end)
	end
	
	-- Resumo de remotes
	table.insert(results, string.format("📊 Total de Remotes: %d", 
		remoteCount.RemoteEvent + remoteCount.RemoteFunction + 
		remoteCount.BindableEvent + remoteCount.BindableFunction))
	table.insert(results, string.format("  📤 RemoteEvents: %d", remoteCount.RemoteEvent))
	table.insert(results, string.format("  📥 RemoteFunctions: %d", remoteCount.RemoteFunction))
	table.insert(results, string.format("  🔗 BindableEvents: %d", remoteCount.BindableEvent))
	table.insert(results, string.format("  🔀 BindableFunctions: %d\n", remoteCount.BindableFunction))
	
	if #remotes > 0 then
		-- Agrupar por categoria
		local categories = {}
		for _, remote in ipairs(remotes) do
			if not categories[remote.category] then
				categories[remote.category] = {}
			end
			table.insert(categories[remote.category], remote)
		end
		
		-- Mostrar por categoria
		for category, categoryRemotes in pairs(categories) do
			table.insert(results, string.format("%s (%d):", category, #categoryRemotes))
			
			-- Limitar a 10 por categoria para não ficar muito longo
			local limit = math.min(#categoryRemotes, 10)
			for i = 1, limit do
				local remote = categoryRemotes[i]
				table.insert(results, string.format("  %s %s [%s]", 
					remote.icon, remote.name, remote.type))
				table.insert(results, string.format("     📂 %s", remote.parent))
			end
			
			if #categoryRemotes > 10 then
				table.insert(results, string.format("  ... e mais %d remotes", #categoryRemotes - 10))
			end
			table.insert(results, "")
		end
	else
		table.insert(results, "  ⚠️ Nenhum remote detectado (jogo pode ter proteção)\n")
	end
	else
		table.insert(results, "\n━━━ 📡 REMOTE EVENTS & FUNCTIONS ━━━\n")
		table.insert(results, "  ⚙️ Scan de remotes desativado nas configurações\n")
	end
	
	-- Escanear itens e ferramentas
	table.insert(results, "\n━━━ 🎒 ITENS & FERRAMENTAS ━━━\n")
	
	local items = {}
	for _, obj in pairs(workspace:GetDescendants()) do
		pcall(function()
			if obj:IsA("Tool") then
				local pos = obj:FindFirstChildWhichIsA("BasePart")
				if pos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local distance = (pos.Position - player.Character.HumanoidRootPart.Position).Magnitude
					
					if distance <= config.scanRadius then
						-- Detectar se é arma/item de combate
						local hasDamage = obj:FindFirstChild("Damage") or obj:FindFirstChild("DMG") or 
										  obj:FindFirstChild("AttackDamage") or obj:FindFirstChild("Power")
						local hasHandle = obj:FindFirstChild("Handle")
						local damageValue = "N/A"
						
						if hasDamage then
							damageValue = tostring(hasDamage.Value or hasDamage)
						end
						
						-- Detectar scripts de combate
						local combatScripts = {}
						for _, child in pairs(obj:GetDescendants()) do
							if child:IsA("Script") or child:IsA("LocalScript") then
								local scriptName = child.Name:lower()
								if scriptName:match("damage") or scriptName:match("combat") or 
								   scriptName:match("attack") or scriptName:match("hit") or
								   scriptName:match("swing") or scriptName:match("shoot") then
									table.insert(combatScripts, child.Name)
								end
							end
						end
						
						table.insert(items, {
							name = obj.Name,
							distance = distance,
							damage = damageValue,
							hasCombat = #combatScripts > 0,
							scripts = combatScripts,
							type = hasDamage and "⚔️ Arma" or "🔧 Ferramenta"
						})
					end
				end
			end
		end)
	end
	
	-- Ordenar itens por distância
	table.sort(items, function(a, b) return a.distance < b.distance end)
	
	if #items > 0 then
		for i, item in ipairs(items) do
			table.insert(results, string.format("%s %s (%.1f studs)", item.type, item.name, item.distance))
			if item.damage ~= "N/A" then
				table.insert(results, string.format("  ├─ 💥 Dano: %s", item.damage))
			end
			if item.hasCombat then
				table.insert(results, "  ├─ ⚔️ Scripts de Combate:")
				for _, script in ipairs(item.scripts) do
					table.insert(results, string.format("  │  • %s", script))
				end
			end
			table.insert(results, "")
		end
	else
		table.insert(results, "  ⚠️ Nenhum item encontrado\n")
	end
	
	-- Escanear sistemas de dano
	table.insert(results, "\n━━━ 💥 SISTEMAS DE DANO ━━━\n")
	
	local damageSystems = {}
	for _, obj in pairs(workspace:GetDescendants()) do
		pcall(function()
			-- Detectar objetos com damage
			if obj.Name:lower():match("damage") or obj.Name:lower():match("dmg") or
			   obj.Name:lower():match("hurt") or obj.Name:lower():match("kill") then
				
				local pos = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart") or obj.Parent
				if pos and pos:IsA("BasePart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local distance = (pos.Position - player.Character.HumanoidRootPart.Position).Magnitude
					
					if distance <= config.scanRadius then
						local damageValue = "Desconhecido"
						local damageType = "💢 Sistema de Dano"
						
						-- Tentar encontrar valor de dano
						if obj:IsA("NumberValue") or obj:IsA("IntValue") then
							damageValue = tostring(obj.Value)
						elseif obj:FindFirstChild("Value") then
							damageValue = tostring(obj.Value.Value)
						end
						
						-- Detectar tipo de dano
						if obj.Name:lower():match("kill") or obj.Name:lower():match("instakill") then
							damageType = "☠️ Dano Letal"
						elseif obj.Name:lower():match("fire") or obj.Name:lower():match("burn") then
							damageType = "🔥 Dano de Fogo"
						elseif obj.Name:lower():match("poison") or obj.Name:lower():match("toxic") then
							damageType = "☢️ Dano de Veneno"
						end
						
						table.insert(damageSystems, {
							name = obj.Name,
							distance = distance,
							damageValue = damageValue,
							type = damageType,
							class = obj.ClassName,
							parent = obj.Parent.Name
						})
					end
				end
			end
			
			-- Detectar TouchInterest (partes que causam dano ao toque)
			if obj:IsA("BasePart") and obj:FindFirstChildOfClass("TouchTransmitter") then
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local distance = (obj.Position - player.Character.HumanoidRootPart.Position).Magnitude
					
					if distance <= config.scanRadius then
						-- Verificar scripts que podem causar dano
						local hasDamageScript = false
						for _, child in pairs(obj:GetChildren()) do
							if child:IsA("Script") or child:IsA("LocalScript") then
								hasDamageScript = true
								break
							end
						end
						
						if hasDamageScript then
							table.insert(damageSystems, {
								name = obj.Name,
								distance = distance,
								damageValue = "Ao Toque",
								type = "⚠️ Zona de Dano",
								class = "TouchPart",
								parent = obj.Parent.Name
							})
						end
					end
				end
			end
		end)
	end
	
	-- Ordenar sistemas de dano
	table.sort(damageSystems, function(a, b) return a.distance < b.distance end)
	
	if #damageSystems > 0 then
		for i, sys in ipairs(damageSystems) do
			table.insert(results, string.format("%s %s", sys.type, sys.name))
			table.insert(results, string.format("  ├─ 💥 Valor: %s", sys.damageValue))
			table.insert(results, string.format("  ├─ 📍 Distância: %.1f studs", sys.distance))
			table.insert(results, string.format("  ├─ 📦 Tipo: %s", sys.class))
			table.insert(results, string.format("  └─ 📂 Parent: %s", sys.parent))
			table.insert(results, "")
		end
	else
		table.insert(results, "  ⚠️ Nenhum sistema de dano detectado\n")
	end
	
	-- Escanear objetos importantes
	table.insert(results, "\n━━━ 📦 OUTROS OBJETOS ━━━\n")
	
	local objectTypes = {
		{class = "SpawnLocation", name = "Spawns", icon = "🚀"},
		{class = "Seat", name = "Assentos", icon = "💺"},
		{class = "VehicleSeat", name = "Assentos de Veículo", icon = "🚗"},
		{class = "ClickDetector", name = "Detectores de Click", icon = "👆"},
		{class = "ProximityPrompt", name = "Prompts de Proximidade", icon = "💬"},
	}
	
	for _, objType in ipairs(objectTypes) do
		local found = {}
		for _, obj in pairs(workspace:GetDescendants()) do
			pcall(function()
				if obj:IsA(objType.class) and #found < 10 then
					local pos = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart") or obj.Parent
					
					if pos and pos:IsA("BasePart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						local distance = (pos.Position - player.Character.HumanoidRootPart.Position).Magnitude
						
						if distance <= config.scanRadius then
							table.insert(found, {
								name = obj.Name, 
								distance = distance,
								parent = obj.Parent and obj.Parent.Name or "Workspace"
							})
						end
					end
				end
			end)
		end
		
		if #found > 0 then
			table.insert(results, string.format("%s %s (%d encontrados):", objType.icon, objType.name, #found))
			
			-- Ordenar por distância
			table.sort(found, function(a, b) return a.distance < b.distance end)
			
			for i, item in ipairs(found) do
				if config.showDistance then
					table.insert(results, string.format("  • %s (%.1f studs) [%s]", 
						item.name, item.distance, item.parent))
				else
					table.insert(results, string.format("  • %s [%s]", item.name, item.parent))
				end
			end
			table.insert(results, "")
		end
	end
	
	-- Footer
	local totalRemotes = 0
	if config.scanRemotes then
		totalRemotes = remoteCount.RemoteEvent + remoteCount.RemoteFunction + 
					   remoteCount.BindableEvent + remoteCount.BindableFunction
	end
	table.insert(results, "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	table.insert(results, string.format("⏰ Scan completado: %s", os.date("%H:%M:%S")))
	table.insert(results, string.format("📊 NPCs: %d | Itens: %d | Dano: %d | Remotes: %d", 
		npcCount, #items, #damageSystems, totalRemotes))
	table.insert(results, string.format("🎯 Raio: %s studs", 
		config.scanRadius == math.huge and "Infinito" or tostring(config.scanRadius)))
	table.insert(results, "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	
	lastScanResults = table.concat(results, "\n")
	StatusLabel:Set("Status: ✅ Scan completo! " .. npcCount .. " NPCs encontrados")
	scanInProgress = false
	
	local totalRemotes = 0
	if config.scanRemotes then
		totalRemotes = remoteCount.RemoteEvent + remoteCount.RemoteFunction + 
					   remoteCount.BindableEvent + remoteCount.BindableFunction
	end
	Rayfield:Notify({
		Title = "✅ Scan Completo",
		Content = string.format("%d NPCs | %d Itens | %d Dano | %d Remotes", 
			npcCount, #items, #damageSyste