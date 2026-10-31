-- ============================================
-- PHANTOM HUB - BLACK EDITION SUPREMA
-- v2.2.0 - Scripts extras + Bypass integrado
-- ============================================

pcall(function()
    if readfile and isfile and isfile("Bypass/universalbypass.lua") then
        local bypass = loadstring(readfile("Bypass/universalbypass.lua"))()
        if bypass and bypass.enable then bypass.enable() end
    end
end)

local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local VERSAO = "2.2.0"
local CONFIG_FILE = "PHANTOM_Config.json"

local config = { preset = "Black", transparencia = 0, fonte = 11, somNotif = true, contadorScripts = 0 }
local function salvarConfig() pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(config)) end) end
local function carregarConfig() pcall(function() if isfile and isfile(CONFIG_FILE) then local d = HttpService:JSONDecode(readfile(CONFIG_FILE)); for k, v in pairs(d) do config[k] = v end end end) end
carregarConfig()

local function tocarSom(nome, volume)
    if not config.somNotif then return end
    pcall(function() local s = Instance.new("Sound"); s.SoundId = "rbxassetid://6895079853"; s.Volume = volume or 0.3; s.Parent = playerGui; s:Play(); task.delay(3, function() pcall(function() s:Destroy() end) end) end)
end

local presets = {
    Black = {fundo = Color3.fromRGB(0, 0, 0), painel = Color3.fromRGB(8, 8, 8), texto = Color3.fromRGB(230, 230, 230), botao = Color3.fromRGB(15, 15, 15), destaque = Color3.fromRGB(200, 0, 0)},
    Neon = {fundo = Color3.fromRGB(10, 10, 15), painel = Color3.fromRGB(20, 20, 30), texto = Color3.fromRGB(240, 240, 240), botao = Color3.fromRGB(30, 30, 45), destaque = Color3.fromRGB(0, 200, 255)},
    Matrix = {fundo = Color3.fromRGB(0, 10, 0), painel = Color3.fromRGB(0, 20, 0), texto = Color3.fromRGB(0, 255, 0), botao = Color3.fromRGB(0, 30, 0), destaque = Color3.fromRGB(0, 255, 100)}
}

local presetAtual = config.preset
local corDestaque = presets[presetAtual].destaque
local corFundo = presets[presetAtual].fundo
local corPainel = presets[presetAtual].painel
local corTexto = presets[presetAtual].texto
local corBotao = presets[presetAtual].botao

local tamanhos = {UDim2.new(0, 380, 0, 290), UDim2.new(0, 480, 0, 360), UDim2.new(0, 600, 0, 440)}
local tamanhoIdx = 2
local painelAberto = true
local sgPainel, janelaPrincipal, btnFlutuante, btnContainer, sJanela
local animando = false
local contadorScripts = 0
local tituloJanela, subTitulo, painelAbas, painelConteudo, indicador

local function notificar(titulo, texto, duracao, isErro)
    duracao = duracao or 3
    pcall(function()
        local sg = Instance.new("ScreenGui"); sg.Name = "Notif"; sg.ResetOnSpawn = false; sg.DisplayOrder = 1000; sg.Parent = playerGui
        local corBorda = isErro and Color3.fromRGB(255, 50, 50) or corDestaque
        local frame = Instance.new("Frame"); frame.Size = UDim2.new(0, 320, 0, 70); frame.Position = UDim2.new(1, 340, 0, 20); frame.BackgroundColor3 = corPainel; frame.BorderSizePixel = 0; frame.Parent = sg
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 12); c.Parent = frame
        local stroke = Instance.new("UIStroke"); stroke.Color = corBorda; stroke.Thickness = 2; stroke.Parent = frame
        local t1 = Instance.new("TextLabel"); t1.Size = UDim2.new(1, -60, 0, 22); t1.Position = UDim2.new(0, 55, 0, 8); t1.BackgroundTransparency = 1; t1.Text = titulo; t1.TextColor3 = corBorda; t1.Font = Enum.Font.GothamBold; t1.TextSize = 15; t1.TextXAlignment = Enum.TextXAlignment.Left; t1.Parent = frame
        local t2 = Instance.new("TextLabel"); t2.Size = UDim2.new(1, -60, 0, 32); t2.Position = UDim2.new(0, 55, 0, 32); t2.BackgroundTransparency = 1; t2.Text = texto; t2.TextColor3 = corTexto; t2.Font = Enum.Font.Gotham; t2.TextSize = 11; t2.TextWrapped = true; t2.TextXAlignment = Enum.TextXAlignment.Left; t2.Parent = frame
        TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -340, 0, 20)}):Play()
        task.delay(duracao, function() TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(1, 340, 0, 20)}):Play(); task.wait(0.4); sg:Destroy() end)
    end)
end
local function explodirParticulas()
    pcall(function()
        local sg = Instance.new("ScreenGui"); sg.Name = "Explosao"; sg.ResetOnSpawn = false; sg.DisplayOrder = 2000; sg.Parent = playerGui
        for i = 1, 50 do
            local p = Instance.new("Frame"); p.Size = UDim2.new(0, math.random(5, 12), 0, math.random(5, 12)); p.Position = UDim2.new(0.5, 0, 0.5, 0); p.BackgroundColor3 = corDestaque; p.BorderSizePixel = 0; p.Parent = sg
            local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1, 0); c.Parent = p
            local angulo = math.random() * math.pi * 2; local dist = math.random(250, 600)
            TweenService:Create(p, TweenInfo.new(math.random(0.5, 1.5), Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, math.cos(angulo) * dist, 0.5, math.sin(angulo) * dist), BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}):Play()
        end
        task.delay(1.5, function() sg:Destroy() end)
    end)
end

-- ========== JANELA ==========
sgPainel = Instance.new("ScreenGui"); sgPainel.Name = "PHANTOMPainel"; sgPainel.ResetOnSpawn = false; sgPainel.DisplayOrder = 500; sgPainel.Parent = playerGui
janelaPrincipal = Instance.new("Frame"); janelaPrincipal.Size = tamanhos[tamanhoIdx]; janelaPrincipal.Position = UDim2.new(0.5, -tamanhos[tamanhoIdx].X.Offset/2, 0.5, -tamanhos[tamanhoIdx].Y.Offset/2); janelaPrincipal.BackgroundColor3 = corFundo; janelaPrincipal.BorderSizePixel = 0; janelaPrincipal.Active = true; janelaPrincipal.Draggable = true; janelaPrincipal.ClipsDescendants = true; janelaPrincipal.Parent = sgPainel
local cJanela = Instance.new("UICorner"); cJanela.CornerRadius = UDim.new(0, 16); cJanela.Parent = janelaPrincipal
sJanela = Instance.new("UIStroke"); sJanela.Color = corDestaque; sJanela.Thickness = 1; sJanela.Transparency = 0.3; sJanela.Parent = janelaPrincipal

-- ========== BARRA TÍTULO ==========
local barraTitulo = Instance.new("Frame"); barraTitulo.Size = UDim2.new(1, 0, 0, 40); barraTitulo.BackgroundColor3 = corPainel; barraTitulo.BackgroundTransparency = 0.5; barraTitulo.BorderSizePixel = 0; barraTitulo.Parent = janelaPrincipal
local cBarra = Instance.new("UICorner"); cBarra.CornerRadius = UDim.new(0, 16); cBarra.Parent = barraTitulo
tituloJanela = Instance.new("TextLabel"); tituloJanela.Size = UDim2.new(1, -170, 1, 0); tituloJanela.Position = UDim2.new(0, 15, 0, 0); tituloJanela.BackgroundTransparency = 1; tituloJanela.Text = "👻 PHANTOM HUB"; tituloJanela.TextColor3 = corDestaque; tituloJanela.Font = Enum.Font.GothamBlack; tituloJanela.TextSize = 16; tituloJanela.TextXAlignment = Enum.TextXAlignment.Left; tituloJanela.Parent = barraTitulo
subTitulo = Instance.new("TextLabel"); subTitulo.Size = UDim2.new(1, -170, 0, 10); subTitulo.Position = UDim2.new(0, 15, 0, 27); subTitulo.BackgroundTransparency = 1; subTitulo.Text = "v" .. VERSAO .. " • 0 scripts"; subTitulo.TextColor3 = Color3.fromRGB(120, 120, 120); subTitulo.Font = Enum.Font.Gotham; subTitulo.TextSize = 9; subTitulo.TextXAlignment = Enum.TextXAlignment.Left; subTitulo.Parent = barraTitulo

local btnFechar = Instance.new("TextButton"); btnFechar.Size = UDim2.new(0, 28, 0, 28); btnFechar.Position = UDim2.new(1, -38, 0, 6); btnFechar.BackgroundColor3 = Color3.fromRGB(200, 50, 50); btnFechar.Text = "✕"; btnFechar.TextColor3 = corTexto; btnFechar.Font = Enum.Font.GothamBold; btnFechar.TextSize = 14; btnFechar.BorderSizePixel = 0; btnFechar.Parent = barraTitulo
local cFechar = Instance.new("UICorner"); cFechar.CornerRadius = UDim.new(0, 8); cFechar.Parent = btnFechar

-- ========== ÁREA ABAS E CONTEÚDO ==========
painelAbas = Instance.new("ScrollingFrame"); painelAbas.Size = UDim2.new(0, 110, 1, -50); painelAbas.Position = UDim2.new(0, 8, 0, 44); painelAbas.BackgroundTransparency = 1; painelAbas.ScrollBarThickness = 4; painelAbas.ScrollBarImageColor3 = corDestaque; painelAbas.AutomaticCanvasSize = Enum.AutomaticSize.Y; painelAbas.CanvasSize = UDim2.new(0, 0, 0, 0); painelAbas.Parent = janelaPrincipal
local layoutAbas = Instance.new("UIListLayout"); layoutAbas.Padding = UDim.new(0, 5); layoutAbas.Parent = painelAbas
painelConteudo = Instance.new("Frame"); painelConteudo.Size = UDim2.new(1, -128, 1, -50); painelConteudo.Position = UDim2.new(0, 122, 0, 44); painelConteudo.BackgroundTransparency = 1; painelConteudo.Parent = janelaPrincipal
indicador = Instance.new("Frame"); indicador.Size = UDim2.new(0, 4, 0, 28); indicador.BackgroundColor3 = corDestaque; indicador.BorderSizePixel = 0; indicador.Parent = painelAbas
local cInd = Instance.new("UICorner"); cInd.CornerRadius = UDim.new(1, 0); cInd.Parent = indicador

local abas = {}
local abaAtiva = nil

local function criarAba(nome, icone)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, -10, 0, 28); btn.BackgroundColor3 = corBotao; btn.BackgroundTransparency = 0.3; btn.Text = icone .. " " .. nome; btn.TextColor3 = corTexto; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.Parent = painelAbas
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = btn
    local s = Instance.new("UIStroke"); s.Color = corDestaque; s.Thickness = 1; s.Transparency = 0.8; s.Parent = btn
    local frame = Instance.new("ScrollingFrame"); frame.Size = UDim2.new(1, 0, 1, 0); frame.BackgroundTransparency = 1; frame.ScrollBarThickness = 4; frame.ScrollBarImageColor3 = corDestaque; frame.AutomaticCanvasSize = Enum.AutomaticSize.Y; frame.CanvasSize = UDim2.new(0, 0, 0, 0); frame.Visible = false; frame.Parent = painelConteudo
    local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 6); layout.Parent = frame
    table.insert(abas, {nome = nome, frame = frame, btn = btn, stroke = s})

    btn.MouseButton1Click:Connect(function()
        if abaAtiva == frame then return end
        for _, a in ipairs(abas) do a.frame.Visible = false; a.btn.BackgroundColor3 = corBotao end
        frame.Visible = true; btn.BackgroundColor3 = corDestaque; abaAtiva = frame
    end)
    return frame
end

local function criarBotao(parent, nome, callback)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, -10, 0, 32); btn.BackgroundColor3 = corBotao; btn.BackgroundTransparency = 0.15; btn.Text = nome; btn.TextColor3 = corTexto; btn.Font = Enum.Font.Gotham; btn.TextSize = 11; btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 9); c.Parent = btn
    btn.MouseButton1Click:Connect(function() pcall(callback) end)
    return btn
end

local function criarToggle(parent, nome, valorInicial, callback)
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(1, -10, 0, 32); frame.BackgroundColor3 = corBotao; frame.BackgroundTransparency = 0.15; frame.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 9); c.Parent = frame
    local label = Instance.new("TextLabel"); label.Size = UDim2.new(1, -60, 1, 0); label.Position = UDim2.new(0, 12, 0, 0); label.BackgroundTransparency = 1; label.Text = nome; label.TextColor3 = corTexto; label.Font = Enum.Font.Gotham; label.TextSize = 11; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = frame
    local switch = Instance.new("Frame"); switch.Size = UDim2.new(0, 40, 0, 20); switch.Position = UDim2.new(1, -50, 0.5, -10); switch.BackgroundColor3 = valorInicial and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(40, 40, 40); switch.Parent = frame
    local cs = Instance.new("UICorner"); cs.CornerRadius = UDim.new(1, 0); cs.Parent = switch
    local bolinha = Instance.new("Frame"); bolinha.Size = UDim2.new(0, 16, 0, 16); bolinha.Position = valorInicial and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8); bolinha.BackgroundColor3 = Color3.fromRGB(255, 255, 255); bolinha.Parent = switch
    local cb = Instance.new("UICorner"); cb.CornerRadius = UDim.new(1, 0); cb.Parent = bolinha; local estado = valorInicial
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.Parent = frame
    btn.MouseButton1Click:Connect(function() estado = not estado; if estado then switch.BackgroundColor3 = Color3.fromRGB(0, 220, 100); bolinha.Position = UDim2.new(1, -18, 0.5, -8) else switch.BackgroundColor3 = Color3.fromRGB(40, 40, 40); bolinha.Position = UDim2.new(0, 2, 0.5, -8) end; pcall(callback, estado) end)
    return frame
end

local function criarSlider(parent, nome, min, max, valorInicial, callback)
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(1, -10, 0, 45); frame.BackgroundColor3 = corBotao; frame.BackgroundTransparency = 0.15; frame.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 9); c.Parent = frame
    local label = Instance.new("TextLabel"); label.Size = UDim2.new(1, -20, 0, 20); label.Position = UDim2.new(0, 12, 0, 4); label.BackgroundTransparency = 1; label.Text = nome .. ": " .. math.floor(valorInicial); label.TextColor3 = corTexto; label.Font = Enum.Font.Gotham; label.TextSize = 11; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = frame
    local barra = Instance.new("Frame"); barra.Size = UDim2.new(1, -24, 0, 6); barra.Position = UDim2.new(0, 12, 0, 28); barra.BackgroundColor3 = Color3.fromRGB(40, 40, 40); barra.Parent = frame
    local cb = Instance.new("UICorner"); cb.CornerRadius = UDim.new(1, 0); cb.Parent = barra
    local fill = Instance.new("Frame"); fill.Size = UDim2.new((valorInicial - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = corDestaque; fill.Parent = barra
    local cf = Instance.new("UICorner"); cf.CornerRadius = UDim.new(1, 0); cf.Parent = fill
    return frame
end

-- ========== CRIA AS ABAS ==========
local AbaKeyless = criarAba("Keyless", "🔥")
local AbaFun = criarAba("Funções", "⚡")
local AbaVisual = criarAba("Visual", "🎨")
local AbaUtils = criarAba("Utils", "🛠️")

abas[1].frame.Visible = true; abas[1].btn.BackgroundColor3 = corDestaque; abaAtiva = abas[1].frame
-- ========== ABA KEYLESS ==========
local function AddScript(nome, url)
    criarBotao(AbaKeyless, nome, function()
        notificar("Carregando", nome, 2)
        pcall(function() loadstring(game:HttpGet(url))() end)
        contadorScripts = contadorScripts + 1
        if subTitulo then subTitulo.Text = "v" .. VERSAO .. " • " .. contadorScripts .. " scripts" end
    end)
end

AddScript("Polluted Hub", "https://raw.githubusercontent.com/PollutedHub/Sae/main/SaePolluted")
AddScript("Sena v6.2", "https://raw.githubusercontent.com/LSSOPS/OpenSource/refs/heads/main/Senav6.2Hub_Steal_An_Egg.lua")
AddScript("Moondiety", "https://moondiety.com/loader")
AddScript("Glitch Egg Panel", "https://giscript.org/scripts/stealanegg/Glitch_Panel.lua")
AddScript("Venyx Hub", "https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub")
AddScript("Chilli Hub", "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua")
AddScript("ASA MIKATA HUB", "https://raw.githubusercontent.com/discordtiktok76-ctrl/Asa-Mikata-Hub-/refs/heads/main/protected.lua")
AddScript("Hip Hub", "https://hiphub.cloud/api/script-roblox/loader")
AddScript("Nasi Rendang Hub", "https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua")
AddScript("Monarch Hub", "https://raw.githubusercontent.com/nobuxy/monarch.win/refs/heads/main/Monarch.lua")
AddScript("ScriptVerse", "https://pastebin.com/raw/vE3xvTaR")
AddScript("Delta Instant Steal", "https://pastebin.com/raw/27AqHcXs")
AddScript("SoftKillz Auto Cosmic", "https://pastebin.com/raw/ZuEBwb5K")

-- NOVOS (2026)
AddScript("Evil Hub Duels (SAB)", "https://pastefy.app/V0blGtti/raw")
AddScript("K2 Duels (SAB)", "https://pastefy.app/y4Amvnet/raw")
AddScript("Frostware (SAB Keyless)", "https://raw.githubusercontent.com/Jake-Brock/Scripts/main/Fw%20SAB.lua")
AddScript("Snipcola (SAB Keyless)", "https://gist.githubusercontent.com/snipcola/2be4691920e907c223243de4e9c277c3/raw/Steal%20a%20Brainrot.luau")
AddScript("Snowy Hub (80+ games)", "https://flowauth.net/v1/ui/a87f00d9adf63658655fcd02ab86a4ef.lua")
AddScript("ChronixHub (12+ games)", "https://raw.atomgit.com/Furrycalin/ChronixHub/raw/main/mainv3.lua")

-- ========== ABA FUNÇÕES ==========
criarBotao(AbaFun, "Velocidade 100", function() local char = Players.LocalPlayer.Character; if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 100 end end)
criarBotao(AbaFun, "Pulo 200", function() local char = Players.LocalPlayer.Character; if char and char:FindFirstChild("Humanoid") then char.Humanoid.JumpPower = 200 end end)

criarToggle(AbaFun, "Fly (Voar)", false, function(state)
    if state then
        local char = Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9); bv.Velocity = Vector3.new(0,0,0)
            _G.flyCon = UserInputService.InputBegan:Connect(function(input)
                local dir = Vector3.new(0,0,0)
                if input.KeyCode == Enum.KeyCode.W then dir = workspace.CurrentCamera.CFrame.LookVector * 50 end
                if input.KeyCode == Enum.KeyCode.Space then dir = Vector3.new(0,50,0) end
                bv.Velocity = dir
            end)
        end
    else
        if _G.flyCon then _G.flyCon:Disconnect() end
        local char = Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local bv = char.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"); if bv then bv:Destroy() end
        end
    end
end)

criarToggle(AbaFun, "Noclip", false, function(state)
    if state then
        _G.noclipCon = RunService.Stepped:Connect(function()
            local char = Players.LocalPlayer.Character
            if char then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        end)
    else
        if _G.noclipCon then _G.noclipCon:Disconnect() end
    end
end)

criarBotao(AbaFun, "📍 Teleportar pro Ovo Próximo", function()
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local ovo, dist = nil, math.huge
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("egg") or obj.Name:lower():find("ovo")) then
                local d = (char.HumanoidRootPart.Position - obj.Position).Magnitude
                if d < dist then dist, ovo = d, obj end
            end
        end
        if ovo then char.HumanoidRootPart.CFrame = ovo.CFrame + Vector3.new(0, 5, 0); notificar("Teleporte", "Fui!", 2) end
    end
end)

criarToggle(AbaFun, "🥚 ESP de Ovos", false, function(state)
    if state then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("egg") or obj.Name:lower():find("ovo")) then
                if not obj:FindFirstChild("ESPOvo") then
                    local hl = Instance.new("Highlight"); hl.Name = "ESPOvo"; hl.FillColor = Color3.fromRGB(255, 215, 0); hl.OutlineColor = Color3.fromRGB(255, 255, 255); hl.Parent = obj
                end
            end
        end
    else
        for _, obj in pairs(workspace:GetDescendants()) do local hl = obj:FindFirstChild("ESPOvo"); if hl then hl:Destroy() end end
    end
end)

criarToggle(AbaFun, "🎯 Aimbot", false, function(state)
    if state then
        _G.aimbotAtivo = true
        task.spawn(function()
            while _G.aimbotAtivo do
                task.wait()
                local closest, dist = nil, math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                        local d = (p.Character.Head.Position - camera.CFrame.Position).Magnitude
                        if d < dist then dist, closest = d, p.Character.Head end
                    end
                end
                if closest then camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Position) end
            end
        end)
    else _G.aimbotAtivo = false end
end)

-- ========== ABA VISUAL ==========
criarToggle(AbaVisual, "Fullbright", false, function(state) if state then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000 else Lighting.Brightness = 1; Lighting.FogEnd = 1000 end end)
criarBotao(AbaVisual, "🎨 Tema: Azul Neon", function() corDestaque = Color3.fromRGB(0, 200, 255); sJanela.Color = corDestaque; tituloJanela.TextColor3 = corDestaque end)
criarBotao(AbaVisual, "🎨 Tema: Verde Matrix", function() corDestaque = Color3.fromRGB(0, 255, 100); sJanela.Color = corDestaque; tituloJanela.TextColor3 = corDestaque end)
criarBotao(AbaVisual, "🎨 Tema: Roxo Galático", function() corDestaque = Color3.fromRGB(150, 0, 255); sJanela.Color = corDestaque; tituloJanela.TextColor3 = corDestaque end)

local glitchAtivo = false
criarToggle(AbaVisual, "👾 Glitch no Título", false, function(state)
    glitchAtivo = state
    if state then
        task.spawn(function() while glitchAtivo do tituloJanela.Position = UDim2.new(0, 15 + math.random(-5, 5), 0, math.random(-3, 3)); task.wait(0.05); tituloJanela.Position = UDim2.new(0, 15, 0, 0); task.wait(math.random(1, 3)) end end)
    end
end)

local fogoAtivo = false
criarToggle(AbaVisual, "🔥 Partículas de Fogo", false, function(state)
    fogoAtivo = state
    if state then
        task.spawn(function()
            while fogoAtivo do
                task.wait(0.15)
                local p = Instance.new("Frame"); p.Size = UDim2.new(0, math.random(4, 10), 0, math.random(4, 10)); p.Position = UDim2.new(math.random(), 0, 1, 0); p.BackgroundColor3 = Color3.fromRGB(255, math.random(50, 150), 0); p.BorderSizePixel = 0; p.Parent = janelaPrincipal
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1, 0); c.Parent = p
                TweenService:Create(p, TweenInfo.new(math.random(1, 2.5), Enum.EasingStyle.Linear), {Position = UDim2.new(p.Position.X.Scale, 0, 0, 0), BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}):Play()
                task.delay(3, function() p:Destroy() end)
            end
        end)
    end
end)

local flashAtivo = false
criarToggle(AbaVisual, "⚡ Flash nas Bordas", false, function(state)
    flashAtivo = state
    if state then
        task.spawn(function() while flashAtivo do TweenService:Create(sJanela, TweenInfo.new(0.15), {Thickness = 5, Transparency = 0}):Play(); task.wait(0.15); TweenService:Create(sJanela, TweenInfo.new(0.15), {Thickness = 1, Transparency = 0.8}):Play(); task.wait(0.15) end end)
    end
end)

-- ========== ABA UTILS ==========
criarBotao(AbaUtils, "🔄 Rejoin Server", function() game:GetService("TeleportService"):Teleport(game.PlaceId, Players.LocalPlayer) end)
criarBotao(AbaUtils, "🚀 FPS Boost", function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") then pcall(function() v.Enabled = false end) end end; notificar("FPS", "Boost!", 2) end)
criarBotao(AbaUtils, "🔄 Server Hop", function()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, res = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    if ok and res and res.data then for _, s in ipairs(res.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, Players.LocalPlayer); return end end end
    notificar("Server Hop", "Nenhum encontrado.", 2)
end)

-- ========== BOTÃO FLUTUANTE ==========
local sgBotao = Instance.new("ScreenGui"); sgBotao.Name = "Botao"; sgBotao.ResetOnSpawn = false; sgBotao.DisplayOrder = 999; sgBotao.Parent = playerGui
btnContainer = Instance.new("Frame"); btnContainer.Size = UDim2.new(0, 80, 0, 80); btnContainer.Position = UDim2.new(0, 15, 0.4, 0); btnContainer.BackgroundTransparency = 1; btnContainer.Parent = sgBotao
btnFlutuante = Instance.new("TextButton"); btnFlutuante.Size = UDim2.new(0, 60, 0, 60); btnFlutuante.Position = UDim2.new(0.5, -30, 0.5, -30); btnFlutuante.BackgroundColor3 = corDestaque; btnFlutuante.Text = "👻"; btnFlutuante.TextColor3 = Color3.fromRGB(255, 255, 255); btnFlutuante.Font = Enum.Font.GothamBold; btnFlutuante.TextSize = 28; btnFlutuante.BorderSizePixel = 0; btnFlutuante.Visible = true; btnFlutuante.AutoButtonColor = false; btnFlutuante.Parent = btnContainer
local cBtn = Instance.new("UICorner"); cBtn.CornerRadius = UDim.new(1, 0); cBtn.Parent = btnFlutuante
btnFlutuante.MouseButton1Click:Connect(function() abrirPainel() end)

-- ========== ABRIR/FECHAR ==========
function fecharPainel()
    if animando then return end
    animando = true; painelAberto = false
    local tam = tamanhos[tamanhoIdx]
    TweenService:Create(janelaPrincipal, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.25)
    sgPainel.Enabled = false
    btnContainer.Visible = true
    janelaPrincipal.BackgroundTransparency = 0
    janelaPrincipal.Size = tam
    animando = false
end

function abrirPainel()
    if animando then return end
    animando = true; painelAberto = true; sgPainel.Enabled = true; btnContainer.Visible = false
    local tam = tamanhos[tamanhoIdx]
    janelaPrincipal.Size = UDim2.new(0, 0, 0, 0); janelaPrincipal.BackgroundTransparency = 1; janelaPrincipal.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(janelaPrincipal, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = tam, BackgroundTransparency = 0, Position = UDim2.new(0.5, -tam.X.Offset/2, 0.5, -tam.Y.Offset/2)
    }):Play()
    task.wait(0.35)
    animando = false
end

btnFechar.MouseButton1Click:Connect(function() fecharPainel() end)
