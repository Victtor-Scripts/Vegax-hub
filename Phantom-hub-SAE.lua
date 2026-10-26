-- ============================================
-- PHANTOM HUB - STEAL AN EGG
-- Black Edition + todos os scripts + animações
-- ============================================

local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local VERSAO = "1.7.0"
local CONFIG_FILE = "PHANTOM_Config.json"
local PERFIS_FILE = "PHANTOM_Perfis.json"

local config = {
    preset = "Black",
    transparencia = 0,
    fonte = 11,
    somNotif = true,
    somId = "rbxassetid://6895079853",
    contadorScripts = 0,
    notifOvoRaro = true,
    modoCompacto = false,
    historico = {}
}

local function salvarConfig()
    pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(config)) end)
end

local function carregarConfig()
    pcall(function()
        if isfile and isfile(CONFIG_FILE) then
            local d = HttpService:JSONDecode(readfile(CONFIG_FILE))
            for k, v in pairs(d) do config[k] = v end
        end
    end)
end
carregarConfig()

-- ========== PERFIS ==========
local perfis = {}
local perfilAtual = "Padrão"

local function carregarPerfis()
    pcall(function()
        if isfile and isfile(PERFIS_FILE) then
            perfis = HttpService:JSONDecode(readfile(PERFIS_FILE))
        end
    end)
    if not perfis[perfilAtual] then perfis[perfilAtual] = {} end
end

local function salvarPerfis()
    pcall(function() writefile(PERFIS_FILE, HttpService:JSONEncode(perfis)) end)
end
carregarPerfis()

-- ========== SONS ==========
local sons = {
    clicar = "rbxassetid://6895079853",
    abrir = "rbxassetid://6895079853",
    fechar = "rbxassetid://6895079853",
    erro = "rbxassetid://6895079853",
    toggleOn = "rbxassetid://6895079853",
    toggleOff = "rbxassetid://6895079853",
    aba = "rbxassetid://6895079853",
    carregar = "rbxassetid://6895079853",
    sucesso = "rbxassetid://6895079853"
}

local function tocarSom(nome, volume)
    if not config.somNotif then return end
    pcall(function()
        local som = Instance.new("Sound")
        som.SoundId = sons[nome] or sons.clicar
        som.Volume = volume or 0.3
        som.Parent = playerGui
        som:Play()
        task.delay(3, function() pcall(function() som:Destroy() end) end)
    end)
end

-- ========== PRESETS (BLACK EDITION INCLUÍDO) ==========
local presets = {
    Black = {fundo = Color3.fromRGB(0, 0, 0), painel = Color3.fromRGB(10, 10, 10), texto = Color3.fromRGB(220, 220, 220), botao = Color3.fromRGB(18, 18, 18), destaque = Color3.fromRGB(180, 0, 0)},
    BlackRoxo = {fundo = Color3.fromRGB(0, 0, 0), painel = Color3.fromRGB(10, 10, 10), texto = Color3.fromRGB(220, 220, 220), botao = Color3.fromRGB(18, 18, 18), destaque = Color3.fromRGB(100, 0, 180)},
    BlackVerde = {fundo = Color3.fromRGB(0, 0, 0), painel = Color3.fromRGB(10, 10, 10), texto = Color3.fromRGB(220, 220, 220), botao = Color3.fromRGB(18, 18, 18), destaque = Color3.fromRGB(0, 150, 70)},
    Cyberpunk = {fundo = Color3.fromRGB(15, 5, 25), painel = Color3.fromRGB(25, 10, 40), texto = Color3.fromRGB(255, 200, 50), botao = Color3.fromRGB(40, 15, 60), destaque = Color3.fromRGB(255, 50, 200)},
    Neon = {fundo = Color3.fromRGB(10, 10, 15), painel = Color3.fromRGB(20, 20, 30), texto = Color3.fromRGB(240, 240, 240), botao = Color3.fromRGB(30, 30, 45), destaque = Color3.fromRGB(0, 200, 255)},
    Dark = {fundo = Color3.fromRGB(5, 5, 5), painel = Color3.fromRGB(15, 15, 15), texto = Color3.fromRGB(200, 200, 200), botao = Color3.fromRGB(25, 25, 25), destaque = Color3.fromRGB(120, 120, 120)},
    Matrix = {fundo = Color3.fromRGB(0, 10, 0), painel = Color3.fromRGB(0, 20, 0), texto = Color3.fromRGB(0, 255, 0), botao = Color3.fromRGB(0, 30, 0), destaque = Color3.fromRGB(0, 255, 100)},
    Sunset = {fundo = Color3.fromRGB(25, 10, 15), painel = Color3.fromRGB(40, 15, 25), texto = Color3.fromRGB(255, 220, 200), botao = Color3.fromRGB(55, 20, 30), destaque = Color3.fromRGB(255, 100, 50)},
    Ocean = {fundo = Color3.fromRGB(5, 15, 25), painel = Color3.fromRGB(10, 25, 40), texto = Color3.fromRGB(200, 230, 255), botao = Color3.fromRGB(15, 35, 55), destaque = Color3.fromRGB(0, 150, 255)}
}

local presetAtual = config.preset
if not presets[presetAtual] then presetAtual = "Black" end
local corDestaque = presets[presetAtual].destaque
local corFundo = presets[presetAtual].fundo
local corPainel = presets[presetAtual].painel
local corTexto = presets[presetAtual].texto
local corBotao = presets[presetAtual].botao
local transparenciaPainel = config.transparencia
local tamanhoFonte = config.fonte
local modoCompacto = config.modoCompacto

local tamanhos = {UDim2.new(0, 380, 0, 290), UDim2.new(0, 480, 0, 360), UDim2.new(0, 600, 0, 440)}
local tamanhoIdx = 2

local painelAberto = true
local sgPainel, janelaPrincipal, btnFlutuante, btnContainer, sJanela
local animando = false
local contadorScripts = config.contadorScripts
local tituloJanela, subTitulo, painelAbas, painelConteudo, indicador
local logAcoes = {}
local historicoNotif = {}
local particulasFundo = {}
local orbs = {}

-- ========== LOG ==========
local function addLog(acao)
    table.insert(logAcoes, 1, "[" .. os.date("%H:%M:%S") .. "] " .. acao)
    if #logAcoes > 50 then table.remove(logAcoes) end
end

-- ========== HISTÓRICO ==========
local function addHistorico(nome, url)
    table.insert(config.historico, 1, {nome = nome, url = url, hora = os.date("%H:%M:%S")})
    if #config.historico > 10 then table.remove(config.historico) end
    salvarConfig()
end

-- ========== DIGITAR ==========
local function digitar(label, textoFinal, velocidade, scramble)
    velocidade = velocidade or 0.08
    label.Text = ""
    task.spawn(function()
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%"
        for i = 1, #textoFinal do
            local letra = textoFinal:sub(i, i)
            if scramble and letra ~= " " then
                label.Text = label.Text .. chars:sub(math.random(1, #chars), math.random(1, #chars))
                task.wait(velocidade * 0.5)
                label.Text = label.Text:sub(1, -2) .. letra
            else
                label.Text = label.Text .. letra
            end
            task.wait(velocidade)
        end
    end)
end

-- ========== NOTIFICAÇÃO ==========
local function notificar(titulo, texto, duracao, isErro)
    duracao = duracao or 3
    table.insert(historicoNotif, 1, {titulo = titulo, texto = texto, hora = os.date("%H:%M:%S")})
    if #historicoNotif > 20 then table.remove(historicoNotif) end

    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "NotifPHANTOM"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 1000
        sg.Parent = playerGui

        local corBorda = isErro and Color3.fromRGB(255, 50, 50) or corDestaque
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 300, 0, 65)
        frame.Position = UDim2.new(1, 320, 0, 20)
        frame.BackgroundColor3 = isErro and Color3.fromRGB(60, 10, 10) or corPainel
        frame.BorderSizePixel = 0
        frame.Parent = sg

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 10)
        c.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = corBorda
        stroke.Thickness = 2
        stroke.Parent = frame

        local icone = Instance.new("TextLabel")
        icone.Size = UDim2.new(0, 36, 0, 36)
        icone.Position = UDim2.new(0, 8, 0, 14)
        icone.BackgroundTransparency = 1
        icone.Text = isErro and "❌" or "⚡"
        icone.TextColor3 = corBorda
        icone.Font = Enum.Font.GothamBold
        icone.TextSize = 22
        icone.Parent = frame

        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(1, -55, 0, 20)
        t1.Position = UDim2.new(0, 45, 0, 6)
        t1.BackgroundTransparency = 1
        t1.Text = ""
        t1.TextColor3 = corBorda
        t1.Font = Enum.Font.GothamBold
        t1.TextSize = 14
        t1.TextXAlignment = Enum.TextXAlignment.Left
        t1.Parent = frame

        local t2 = Instance.new("TextLabel")
        t2.Size = UDim2.new(1, -55, 0, 28)
        t2.Position = UDim2.new(0, 45, 0, 28)
        t2.BackgroundTransparency = 1
        t2.Text = texto
        t2.TextColor3 = corTexto
        t2.Font = Enum.Font.Gotham
        t2.TextSize = 11
        t2.TextWrapped = true
        t2.TextXAlignment = Enum.TextXAlignment.Left
        t2.Parent = frame

        digitar(t1, titulo, 0.04, false)
        tocarSom(isErro and "erro" or "sucesso", 0.3)

        TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Position = UDim2.new(1, -320, 0, 20)
        }):Play()

        task.delay(duracao, function()
            TweenService:Create(frame, TweenInfo.new(0.3), {
                Position = UDim2.new(1, 320, 0, 20)
            }):Play()
            task.wait(0.4)
            sg:Destroy()
        end)
    end)
end

-- ========== CARREGAR SCRIPT ==========
local function carregarScript(nome, url)
    contadorScripts = contadorScripts + 1
    config.contadorScripts = contadorScripts
    salvarConfig()
    if subTitulo then
        subTitulo.Text = "PHANTOM HUB • " .. contadorScripts .. " scripts"
        local tamOriginal = subTitulo.TextSize
        TweenService:Create(subTitulo, TweenInfo.new(0.1), {TextSize = tamOriginal + 4}):Play()
        task.wait(0.1)
        TweenService:Create(subTitulo, TweenInfo.new(0.2), {TextSize = tamOriginal}):Play()
    end
    addLog("Carregando " .. nome)
    addHistorico(nome, url)
    notificar("Carregando", nome, 2)
    tocarSom("carregar", 0.4)

    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)

    if not ok then
        notificar("❌ Erro ao carregar", nome .. ": " .. tostring(err):sub(1, 80), 5, true)
        addLog("ERRO em " .. nome)
        tocarSom("erro", 0.5)
    end
end

-- ========== EXPLOSÃO DE PARTÍCULAS ==========
local function explodirParticulas()
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "ExplosaoPHANTOM"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 2000
        sg.Parent = playerGui
        for i = 1, 30 do
            local p = Instance.new("Frame")
            p.Size = UDim2.new(0, math.random(4, 10), 0, math.random(4, 10))
            p.Position = UDim2.new(0.5, 0, 0.5, 0)
            p.BackgroundColor3 = corDestaque
            p.BorderSizePixel = 0
            p.Parent = sg
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = p
            local angulo = math.random() * math.pi * 2
            local dist = math.random(200, 500)
            TweenService:Create(p, TweenInfo.new(math.random(0.5, 1.2), Enum.EasingStyle.Quad), {
                Position = UDim2.new(0.5, math.cos(angulo) * dist, 0.5, math.sin(angulo) * dist),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
        end
        task.delay(1.5, function() sg:Destroy() end)
    end)
end

-- ========== JANELA PRINCIPAL ==========
sgPainel = Instance.new("ScreenGui")
sgPainel.Name = "PHANTOMPainel"
sgPainel.ResetOnSpawn = false
sgPainel.DisplayOrder = 500
sgPainel.Parent = playerGui

janelaPrincipal = Instance.new("Frame")
janelaPrincipal.Size = tamanhos[tamanhoIdx]
janelaPrincipal.Position = UDim2.new(0.5, -tamanhos[tamanhoIdx].X.Offset/2, 0.5, -tamanhos[tamanhoIdx].Y.Offset/2)
janelaPrincipal.BackgroundColor3 = corFundo
janelaPrincipal.BackgroundTransparency = transparenciaPainel
janelaPrincipal.BorderSizePixel = 0
janelaPrincipal.Active = true
janelaPrincipal.Draggable = true
janelaPrincipal.ClipsDescendants = true
janelaPrincipal.Parent = sgPainel

local cJanela = Instance.new("UICorner")
cJanela.CornerRadius = UDim.new(0, 14)
cJanela.Parent = janelaPrincipal

local gradFundo = Instance.new("UIGradient")
gradFundo.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, corDestaque),
    ColorSequenceKeypoint.new(0.3, corFundo),
    ColorSequenceKeypoint.new(0.7, corPainel),
    ColorSequenceKeypoint.new(1, corDestaque)
})
gradFundo.Rotation = 45
gradFundo.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.85),
    NumberSequenceKeypoint.new(0.5, 0.95),
    NumberSequenceKeypoint.new(1, 0.85)
})
gradFundo.Parent = janelaPrincipal

sJanela = Instance.new("UIStroke")
sJanela.Color = corDestaque
sJanela.Thickness = 1
sJanela.Transparency = 0.3
sJanela.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
sJanela.Parent = janelaPrincipal

local scanline = Instance.new("Frame")
scanline.Size = UDim2.new(1, 0, 0, 2)
scanline.Position = UDim2.new(0, 0, 0, 0)
scanline.BackgroundColor3 = corDestaque
scanline.BackgroundTransparency = 0.7
scanline.BorderSizePixel = 0
scanline.Parent = janelaPrincipal

local cScan = Instance.new("UICorner")
cScan.CornerRadius = UDim.new(1, 0)
cScan.Parent = scanline

for i = 1, 6 do
    local orb = Instance.new("Frame")
    orb.Size = UDim2.new(0, math.random(8, 14), 0, math.random(8, 14))
    orb.Position = UDim2.new(math.random(), 0, math.random(), 0)
    orb.BackgroundColor3 = corDestaque
    orb.BackgroundTransparency = 0.5
    orb.BorderSizePixel = 0
    orb.Parent = janelaPrincipal

    local oc = Instance.new("UICorner")
    oc.CornerRadius = UDim.new(1, 0)
    oc.Parent = orb

    local glow = Instance.new("UIStroke")
    glow.Color = corDestaque
    glow.Thickness = 3
    glow.Transparency = 0.6
    glow.Parent = orb

    table.insert(orbs, {frame = orb, glow = glow})
end

for i = 1, 8 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    p.BackgroundColor3 = corDestaque
    p.BackgroundTransparency = 0.6
    p.BorderSizePixel = 0
    p.Parent = janelaPrincipal

    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(1, 0)
    pc.Parent = p

    table.insert(particulasFundo, p)
end

task.spawn(function()
    while janelaPrincipal and janelaPrincipal.Parent do
        for i, orb in ipairs(orbs) do
            if orb.frame and orb.frame.Parent then
                local novaX = math.random()
                local novaY = math.random()
                local novoTam = math.random(8, 16)
                TweenService:Create(orb.frame, TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Sine), {
                    Position = UDim2.new(novaX, 0, novaY, 0),
                    Size = UDim2.new(0, novoTam, 0, novoTam),
                    BackgroundTransparency = math.random(40, 70) / 100
                }):Play()
                TweenService:Create(orb.glow, TweenInfo.new(math.random(2, 4), Enum.EasingStyle.Sine), {
                    Transparency = math.random(30, 70) / 100
                }):Play()
            end
        end
        task.wait(3)
    end
end)

task.spawn(function()
    while janelaPrincipal and janelaPrincipal.Parent do
        for i, p in ipairs(particulasFundo) do
            if p and p.Parent then
                local novaX = math.random()
                local novaY = math.random()
                TweenService:Create(p, TweenInfo.new(math.random(2, 5), Enum.EasingStyle.Sine), {
                    Position = UDim2.new(novaX, 0, novaY, 0),
                    BackgroundTransparency = math.random(30, 80) / 100
                }):Play()
            end
        end
        task.wait(2)
    end
end)

task.spawn(function()
    while gradFundo and gradFundo.Parent do
        gradFundo.Rotation = (gradFundo.Rotation + 2) % 360
        task.wait(0.05)
    end
end)

task.spawn(function()
    while sJanela and sJanela.Parent do
        TweenService:Create(sJanela, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Transparency = 0.6, Thickness = 2}):Play()
        task.wait(1.5)
        TweenService:Create(sJanela, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Transparency = 0.3, Thickness = 1}):Play()
        task.wait(1.5)
    end
end)

task.spawn(function()
    while scanline and scanline.Parent do
        scanline.Position = UDim2.new(0, 0, 0, 0)
        TweenService:Create(scanline, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {
            Position = UDim2.new(0, 0, 1, 0)
        }):Play()
        task.wait(2.5)
    end
end)

-- ========== BARRA TÍTULO ==========
local barraTitulo = Instance.new("Frame")
barraTitulo.Size = UDim2.new(1, 0, 0, 40)
barraTitulo.BackgroundColor3 = corPainel
barraTitulo.BackgroundTransparency = 0.5
barraTitulo.BorderSizePixel = 0
barraTitulo.Parent = janelaPrincipal

local cBarra = Instance.new("UICorner")
cBarra.CornerRadius = UDim.new(0, 14)
cBarra.Parent = barraTitulo

local gradBarra = Instance.new("UIGradient")
gradBarra.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, corDestaque),
    ColorSequenceKeypoint.new(0.5, corPainel),
    ColorSequenceKeypoint.new(1, corDestaque)
})
gradBarra.Rotation = 0
gradBarra.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.85),
    NumberSequenceKeypoint.new(0.5, 0.6),
    NumberSequenceKeypoint.new(1, 0.85)
})
gradBarra.Parent = barraTitulo

tituloJanela = Instance.new("TextLabel")
tituloJanela.Size = UDim2.new(1, -170, 1, 0)
tituloJanela.Position = UDim2.new(0, 15, 0, 0)
tituloJanela.BackgroundTransparency = 1
tituloJanela.Text = "👻 PHANTOM HUB"
tituloJanela.TextColor3 = corDestaque
tituloJanela.Font = Enum.Font.GothamBlack
tituloJanela.TextSize = 16
tituloJanela.TextXAlignment = Enum.TextXAlignment.Left
tituloJanela.Parent = barraTitulo

task.spawn(function()
    while tituloJanela and tituloJanela.Parent do
        task.wait(math.random(3, 6))
        for i = 1, 5 do
            tituloJanela.Position = UDim2.new(0, 15 + math.random(-3, 3), 0, math.random(-2, 2))
            task.wait(0.05)
        end
        tituloJanela.Position = UDim2.new(0, 15, 0, 0)
    end
end)

subTitulo = Instance.new("TextLabel")
subTitulo.Size = UDim2.new(1, -170, 0, 10)
subTitulo.Position = UDim2.new(0, 15, 0, 27)
subTitulo.BackgroundTransparency = 1
subTitulo.Text = "PHANTOM HUB • " .. contadorScripts .. " scripts"
subTitulo.TextColor3 = Color3.fromRGB(120, 120, 120)
subTitulo.Font = Enum.Font.Gotham
subTitulo.TextSize = 9
subTitulo.TextXAlignment = Enum.TextXAlignment.Left
subTitulo.Parent = barraTitulo

-- ========== BOTÕES TÍTULO ==========
local function criarBotaoTitulo(icone, cor, posX, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Position = UDim2.new(1, posX, 0, 6)
    btn.BackgroundColor3 = cor
    btn.Text = icone
    btn.TextColor3 = corTexto
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = barraTitulo

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = corDestaque
    s.Thickness = 1
    s.Transparency = 0.6
    s.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = corDestaque,
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, posX - 1, 0, 5)
        }):Play()
        TweenService:Create(s, TweenInfo.new(0.15), {Transparency = 0, Thickness = 2}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = cor,
            Size = UDim2.new(0, 28, 0, 28),
            Position = UDim2.new(1, posX, 0, 6)
        }):Play()
        TweenService:Create(s, TweenInfo.new(0.15), {Transparency = 0.6, Thickness = 1}):Play()
    end)
    btn.MouseButton1Click:Connect(callback)

    return btn
end

local btnCompacto = criarBotaoTitulo("◱", corBotao, -162, function()
    tocarSom("clicar", 0.3)
    modoCompacto = not modoCompacto
    config.modoCompacto = modoCompacto
    salvarConfig()
    painelAbas.Visible = not modoCompacto
    if modoCompacto then
        painelConteudo.Size = UDim2.new(1, -10, 1, -50)
        painelConteudo.Position = UDim2.new(0, 5, 0, 44)
    else
        painelConteudo.Size = UDim2.new(1, -128, 1, -50)
        painelConteudo.Position = UDim2.new(0, 122, 0, 44)
    end
    notificar("Compacto", modoCompacto and "ON" or "OFF", 2)
end)

local btnDiminuir = criarBotaoTitulo("−", corBotao, -132, function()
    if tamanhoIdx > 1 then tamanhoIdx = tamanhoIdx - 1; aplicarTamanho() end
end)

local btnAumentar = criarBotaoTitulo("+", corBotao, -102, function()
    if tamanhoIdx < 3 then tamanhoIdx = tamanhoIdx + 1; aplicarTamanho() end
end)

local btnFechar = criarBotaoTitulo("✕", Color3.fromRGB(80, 0, 0), -38, function()
    fecharPainel()
end)

-- ========== ÁREA ABAS ==========
painelAbas = Instance.new("ScrollingFrame")
painelAbas.Size = UDim2.new(0, 110, 1, -50)
painelAbas.Position = UDim2.new(0, 8, 0, 44)
painelAbas.BackgroundTransparency = 1
painelAbas.BorderSizePixel = 0
painelAbas.ScrollBarThickness = 4
painelAbas.ScrollBarImageColor3 = corDestaque
painelAbas.AutomaticCanvasSize = Enum.AutomaticSize.Y
painelAbas.CanvasSize = UDim2.new(0, 0, 0, 0)
painelAbas.ScrollingDirection = Enum.ScrollingDirection.Y
painelAbas.Parent = janelaPrincipal

local layoutAbas = Instance.new("UIListLayout")
layoutAbas.Padding = UDim.new(0, 5)
layoutAbas.Parent = painelAbas

painelConteudo = Instance.new("Frame")
painelConteudo.Size = UDim2.new(1, -128, 1, -50)
painelConteudo.Position = UDim2.new(0, 122, 0, 44)
painelConteudo.BackgroundTransparency = 1
painelConteudo.Parent = janelaPrincipal

indicador = Instance.new("Frame")
indicador.Size = UDim2.new(0, 4, 0, 28)
indicador.BackgroundColor3 = corDestaque
indicador.BorderSizePixel = 0
indicador.Parent = painelAbas

local cInd = Instance.new("UICorner")
cInd.CornerRadius = UDim.new(1, 0)
cInd.Parent = indicador

local gradInd = Instance.new("UIGradient")
gradInd.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, corDestaque),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
gradInd.Parent = indicador

-- ========== ABAS ==========
local abas = {}
local abaAtiva = nil

local function criarAba(nome, icone)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 28)
    btn.BackgroundColor3 = corBotao
    btn.BackgroundTransparency = 0.3
    btn.Text = icone .. " " .. nome
    btn.TextColor3 = corTexto
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = tamanhoFonte - 1
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = painelAbas

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = corDestaque
    s.Thickness = 1
    s.Transparency = 0.8
    s.Parent = btn

    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = corDestaque
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.Visible = false
    frame.Parent = painelConteudo

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = frame

    table.insert(abas, {nome = nome, frame = frame, btn = btn, stroke = s})

    btn.MouseEnter:Connect(function()
        if abaAtiva ~= frame then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = corDestaque, BackgroundTransparency = 0.7}):Play()
            TweenService:Create(s, TweenInfo.new(0.15), {Transparency = 0.3}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if abaAtiva ~= frame then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = corBotao, BackgroundTransparency = 0.3}):Play()
            TweenService:Create(s, TweenInfo.new(0.15), {Transparency = 0.8}):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if abaAtiva == frame then return end
        tocarSom("aba", 0.25)
        for _, aba in ipairs(abas) do
            if aba.frame == abaAtiva then
                aba.frame.Visible = false
                aba.btn.BackgroundColor3 = corBotao
                aba.btn.BackgroundTransparency = 0.3
                TweenService:Create(aba.stroke, TweenInfo.new(0.15), {Transparency = 0.8}):Play()
            end
        end
        TweenService:Create(indicador, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Position = UDim2.new(0, 0, 0, btn.AbsolutePosition.Y - painelAbas.AbsolutePosition.Y)
        }):Play()
        frame.Visible = true
        frame.Position = UDim2.new(0, -20, 0, 0)
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        btn.BackgroundColor3 = corDestaque
        btn.BackgroundTransparency = 0
        TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 32)}):Play()
        TweenService:Create(s, TweenInfo.new(0.15), {Transparency = 0, Thickness = 2}):Play()
        task.delay(0.3, function()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 28)}):Play()
        end)
        abaAtiva = frame
    end)

    return frame
end

-- ========== COMPONENTES ==========
local function criarBotao(parent, nome, callback, altura)
    altura = altura or 28
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, altura)
    btn.BackgroundColor3 = corBotao
    btn.BackgroundTransparency = 0.15
    btn.Text = nome
    btn.TextColor3 = corTexto
    btn.Font = Enum.Font.Gotham
    btn.TextSize = tamanhoFonte
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    btn.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = corDestaque
    s.Thickness = 1
    s.Transparency = 0.6
    s.Parent = btn

    local brilho = Instance.new("Frame")
    brilho.Size = UDim2.new(0, 60, 1, 0)
    brilho.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    brilho.BackgroundTransparency = 0.9
    brilho.BorderSizePixel = 0
    brilho.Parent = btn

    local cb = Instance.new("UICorner")
    cb.CornerRadius = UDim.new(1, 0)
    cb.Parent = brilho

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = corDestaque,
            BackgroundTransparency = 0.2,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        TweenService:Create(s, TweenInfo.new(0.15), {Transparency = 0, Thickness = 2}):Play()
        TweenService:Create(brilho, TweenInfo.new(0.6, Enum.EasingStyle.Linear), {
            Position = UDim2.new(1.2, 0, 0, 0)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = corBotao,
            BackgroundTransparency = 0.15,
            TextColor3 = corTexto
        }):Play()
        TweenService:Create(s, TweenInfo.new(0.15), {Transparency = 0.6, Thickness = 1}):Play()
        brilho.Position = UDim2.new(-0.2, 0, 0, 0)
    end)

    btn.MouseButton1Click:Connect(function()
        tocarSom("clicar", 0.3)
        local posOriginal = btn.Position
        for i = 1, 3 do
            btn.Position = posOriginal + UDim2.new(0, math.random(-3, 3), 0, math.random(-2, 2))
            task.wait(0.03)
        end
        btn.Position = posOriginal
        pcall(callback)
    end)

    return btn
end

local function criarToggle(parent, nome, valorInicial, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.BackgroundColor3 = corBotao
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = frame

    local s = Instance.new("UIStroke")
    s.Color = corDestaque
    s.Thickness = 1
    s.Transparency = 0.6
    s.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = nome
    label.TextColor3 = corTexto
    label.Font = Enum.Font.Gotham
    label.TextSize = tamanhoFonte
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 46, 0, 24)
    switch.Position = UDim2.new(1, -56, 0.5, -12)
    switch.BackgroundColor3 = valorInicial and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(40, 40, 40)
    switch.BorderSizePixel = 0
    switch.Parent = frame

    local cs = Instance.new("UICorner")
    cs.CornerRadius = UDim.new(1, 0)
    cs.Parent = switch

    local bolinha = Instance.new("Frame")
    bolinha.Size = UDim2.new(0, 20, 0, 20)
    bolinha.Position = valorInicial and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    bolinha.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bolinha.BorderSizePixel = 0
    bolinha.Parent = switch

    local cb = Instance.new("UICorner")
    cb.CornerRadius = UDim.new(1, 0)
    cb.Parent = bolinha

    local estado = valorInicial

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        estado = not estado
        tocarSom(estado and "toggleOn" or "toggleOff", 0.3)
        if estado then
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 220, 100)}):Play()
            TweenService:Create(bolinha, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            TweenService:Create(bolinha, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
        pcall(callback, estado)
    end)

    return frame
end

local function criarSlider(parent, nome, min, max, valorInicial, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 52)
    frame.BackgroundColor3 = corBotao
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = frame

    local s = Instance.new("UIStroke")
    s.Color = corDestaque
    s.Thickness = 1
    s.Transparency = 0.6
    s.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = nome .. ": " .. math.floor(valorInicial)
    label.TextColor3 = corTexto
    label.Font = Enum.Font.Gotham
    label.TextSize = tamanhoFonte - 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local barraFundo = Instance.new("Frame")
    barraFundo.Size = UDim2.new(1, -24, 0, 8)
    barraFundo.Position = UDim2.new(0, 12, 0, 32)
    barraFundo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    barraFundo.BorderSizePixel = 0
    barraFundo.Parent = frame

    local cbf = Instance.new("UICorner")
    cbf.CornerRadius = UDim.new(1, 0)
    cbf.Parent = barraFundo

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(math.clamp((valorInicial - min) / (max - min), 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = corDestaque
    fill.BorderSizePixel = 0
    fill.Parent = barraFundo

    local cf = Instance.new("UICorner")
    cf.CornerRadius = UDim.new(1, 0)
    cf.Parent = fill

    local gradFill = Instance.new("UIGradient")
    gradFill.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, corDestaque),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    gradFill.Parent = fill

    local arrastando = false
    local btnBarra = Instance.new("TextButton")
    btnBarra.Size = UDim2.new(1, 0, 1, 0)
    btnBarra.BackgroundTransparency = 1
    btnBarra.Text = ""
    btnBarra.Parent = barraFundo

    btnBarra.MouseButton1Down:Connect(function() arrastando = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            arrastando = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if arrastando and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = UserInputService:GetMouseLocation()
            local abs = barraFundo.AbsolutePosition
            local size = barraFundo.AbsoluteSize
            local porcent = math.clamp((pos.X - abs.X) / size.X, 0, 1)
            local valor = min + porcent * (max - min)
            fill.Size = UDim2.new(porcent, 0, 1, 0)
            label.Text = nome .. ": " .. math.floor(valor)
            pcall(callback, math.floor(valor))
        end
    end)

    return frame
end

-- ========== CRIA ABAS ==========
local AbaKeyless = criarAba("Keyless", "🔥")
local AbaKey = criarAba("Com Key", "🔑")
local AbaFun = criarAba("Funções", "⚡")
local AbaVisual = criarAba("Visual", "🎨")
local AbaUtils = criarAba("Utils", "🛠️")
local AbaNotif = criarAba("Notif", "🔔")
local AbaHist = criarAba("Histórico", "📜")
local AbaPerfis = criarAba("Perfis", "💾")
local AbaSobre = criarAba("Sobre", "ℹ️")
local AbaDiscord = criarAba("Discord", "💬")

abas[1].frame.Visible = true
abas[1].btn.BackgroundColor3 = corDestaque
abas[1].btn.BackgroundTransparency = 0
abaAtiva = abas[1].frame
indicador.Position = UDim2.new(0, 0, 0, 0)

-- ========== KEYLESS ==========
local function addKeyless(nome, url) criarBotao(AbaKeyless, nome, function() carregarScript(nome, url) end) end

addKeyless("Polluted Hub", "https://raw.githubusercontent.com/PollutedHub/Sae/main/SaePolluted")
addKeyless("Sena v6.2", "https://raw.githubusercontent.com/LSSOPS/OpenSource/refs/heads/main/Senav6.2Hub_Steal_An_Egg.lua")
addKeyless("Moondiety", "https://moondiety.com/loader")
addKeyless("Glitch Egg Panel", "https://giscript.org/scripts/stealanegg/Glitch_Panel.lua")
addKeyless("Pig Hub", "https://raw.githubusercontent.com/mopsscript7-gif/steal-an-egg/refs/heads/main/script.lua")
addKeyless("Toolbox Hub", "https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/loader")
addKeyless("Venyx Hub", "https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub")
addKeyless("XPLT", "https://cdn.luaprotect.dev/u/8d9aa2/KjxGj-E0uqDEY-V8")
addKeyless("Yslem Free", "https://raw.githubusercontent.com/Main-Scripts-Ready-V9/Yslem/refs/heads/main/Free.lua")
addKeyless("Axur Hub", "https://raw.githubusercontent.com/XE3Scripts/Axur-sGamesHub/refs/heads/main/StealAnEgg")
addKeyless("SpeedHub X", "https://raw.githubusercontent.com/LSSOPS/OpenSource/refs/heads/main/SpeedHubX_Steal_An_Egg.lua")
addKeyless("Kira Hub", "https://raw.githubusercontent.com/LSSOPS/OpenSource/refs/heads/main/KiraHub_Steal_An_Egg.lua")
addKeyless("RayzHubz", "https://raw.githubusercontent.com/vertexscript650-cloud/Steal-an-Egg/refs/heads/main/Lua")
addKeyless("ScriptVerse Hub", "https://pastebin.com/raw/vE3xvTaR")
addKeyless("Chilli Hub", "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua")
addKeyless("LKZ Hub", "https://raw.githubusercontent.com/LucasggkX/LKZ-Hub/refs/heads/main/Loader.lua")
addKeyless("PulseZax", "https://raw.githubusercontent.com/PulseZax/Loader/main/.lua")
addKeyless("SoftKillz Auto Cosmic", "https://pastebin.com/raw/ZuEBwb5K")
addKeyless("Monarch Hub", "https://raw.githubusercontent.com/nobuxy/monarch.win/refs/heads/main/Monarch.lua")
addKeyless("CRZ Hub", "https://flowauth.net/v1/loaders/3c4e87ed34813171b0f8d53a108a7d88.lua")
addKeyless("Delta Instant Steal", "https://pastebin.com/raw/27AqHcXs")
addKeyless("Ouroboros Hub", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua")
addKeyless("Nox Hub", "https://noxscript.com/loader")
addKeyless("Oxide Hub", "https://raw.githubusercontent.com/LSSOPS/OpenSource/refs/heads/main/OxideHub_Steal_An_Egg.lua")
addKeyless("Foxname", "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Fn-stealanegg.lua")
addKeyless("Sources Hub (64+)", "https://pastefy.app/Lk0vDMmN/raw")
addKeyless("Goha Hub", "https://api.goha.dev/loader")
addKeyless("ASA MIKATA HUB", "https://raw.githubusercontent.com/discordtiktok76-ctrl/Asa-Mikata-Hub-/refs/heads/main/protected.lua")
addKeyless("MIRANDA AFK", "https://raw.githubusercontent.com/kadit9999/stealanegg/refs/heads/main/miirandahubk.lua")
addKeyless("VXEZE", "https://gist.githubusercontent.com/angeryy-tvy/6a9ce750ddf5860230196ac468868fdb/raw/Steal-An-Egg-Vxeze")

-- ========== COM KEY ==========
local aviso = Instance.new("TextLabel")
aviso.Size = UDim2.new(1, -10, 0, 32)
aviso.BackgroundColor3 = Color3.fromRGB(30, 20, 5)
aviso.BackgroundTransparency = 0.3
aviso.Text = "⚠️ Estes scripts pedem key!"
aviso.TextColor3 = Color3.fromRGB(255, 200, 50)
aviso.Font = Enum.Font.Gotham
aviso.TextSize = 10
aviso.TextWrapped = true
aviso.Parent = AbaKey

local function addKey(nome, url) criarBotao(AbaKey, nome, function() carregarScript(nome, url) end) end

addKey("UB Hub", "https://raw.githubusercontent.com/TeamUBHub/UBLoader/refs/heads/main/index/Key.lua")
addKey("Monarch", "https://raw.githubusercontent.com/nobuxy/monarch.win/refs/heads/main/Monarch.lua")
addKey("The BSMT", "https://thebsmt.xyz/BSMT")
addKey("CRZ Hub", "https://flowauth.net/v1/loaders/3c4e87ed34813171b0f8d53a108a7d88.lua")
addKey("Neva Hub", "https://raw.githubusercontent.com/VEZ2/NEVAHUB/main/2")
addKey("BK's Hub", "https://api.luarmor.net/files/v4/loaders/9ee4edde227ac85f50872bf9e4226508.lua")
addKey("Codex Hub", "https://cdxhub.net/load.lua")
addKey("Lennon Hub", "https://api.jnkie.com/api/v1/luascripts/public/bf52181bce5c28e6ecd16eebfa1a88ddaf646c7acb10015fbaa7b30dc7bad0a8/download")
addKey("Fishy Hub", "https://api.jnkie.com/api/v1/loaders/public/f303b97c2bb24ac31f25d957eb3e28e66c09789bf720909e0f6a5d4b29503501/download")

-- ========== FUNÇÕES ==========
criarSlider(AbaFun, "FOV", 30, 120, camera.FieldOfView, function(v) camera.FieldOfView = v end)
criarSlider(AbaFun, "Velocidade", 16, 200, 16, function(v)
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = v end
end)
criarSlider(AbaFun, "Pulo", 50, 300, 50, function(v)
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.JumpPower = v end
end)
criarToggle(AbaFun, "Fullbright", false, function(v)
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
    end
end)
criarToggle(AbaFun, "Noclip", false, function(v)
    if _G.noclipCon then _G.noclipCon:Disconnect(); _G.noclipCon = nil end
    if v then
        _G.noclipCon = RunService.Stepped:Connect(function()
            local char = Players.LocalPlayer.Character
            if char then
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end
end)
criarToggle(AbaFun, "Infinite Jump", false, function(v)
    if _G.infJumpCon then _G.infJumpCon:Disconnect(); _G.infJumpCon = nil end
    if v then
        _G.infJumpCon = UserInputService.JumpRequest:Connect(function()
            local char = Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then char.Humanoid:ChangeState("Jumping") end
        end)
    end
end)
criarToggle(AbaFun, "Anti AFK", false, function(v)
    if v then
        pcall(function()
            local vu = game:GetService("VirtualUser")
            Players.LocalPlayer.Idled:Connect(function()
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end)
    end
end)
criarToggle(AbaFun, "ESP Jogadores", false, function(v)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Character then
            if v then
                if not p.Character:FindFirstChild("ESPHighlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESPHighlight"
                    hl.FillColor = corDestaque
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = p.Character
                end
            else
                local hl = p.Character:FindFirstChild("ESPHighlight")
                if hl then hl:Destroy() end
            end
        end
    end
end)

-- ========== VISUAL ==========
local presetLabel = Instance.new("TextLabel")
presetLabel.Size = UDim2.new(1, -10, 0, 24)
presetLabel.BackgroundTransparency = 1
presetLabel.Text = "🎨 Preset: " .. presetAtual
presetLabel.TextColor3 = corDestaque
presetLabel.Font = Enum.Font.GothamBold
presetLabel.TextSize = tamanhoFonte + 1
presetLabel.TextXAlignment = Enum.TextXAlignment.Left
presetLabel.Parent = AbaVisual

local function aplicarPreset(nome)
    presetAtual = nome
    config.preset = nome
    local p = presets[nome]
    corFundo = p.fundo
    corPainel = p.painel
    corTexto = p.texto
    corBotao = p.botao
    corDestaque = p.destaque

    janelaPrincipal.BackgroundColor3 = corFundo
    barraTitulo.BackgroundColor3 = corPainel
    sJanela.Color = corDestaque
    indicador.BackgroundColor3 = corDestaque
    tituloJanela.TextColor3 = corDestaque
    presetLabel.Text = "🎨 Preset: " .. nome

    gradFundo.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, corDestaque),
        ColorSequenceKeypoint.new(0.3, corFundo),
        ColorSequenceKeypoint.new(0.7, corPainel),
        ColorSequenceKeypoint.new(1, corDestaque)
    })

    for _, p in ipairs(particulasFundo) do
        if p and p.Parent then p.BackgroundColor3 = corDestaque end
    end
    for _, orb in ipairs(orbs) do
        if orb.frame and orb.frame.Parent then
            orb.frame.BackgroundColor3 = corDestaque
            orb.glow.Color = corDestaque
        end
    end

    salvarConfig()
    addLog("Preset: " .. nome)
    notificar("Preset", nome .. " aplicado!", 2)
end

for nome, _ in pairs(presets) do
    criarBotao(AbaVisual, "🎨 " .. nome, function() aplicarPreset(nome) end)
end

criarSlider(AbaVisual, "Transparência (%)", 0, 90, transparenciaPainel * 100, function(v)
    transparenciaPainel = v / 100
    config.transparencia = transparenciaPainel
    janelaPrincipal.BackgroundTransparency = transparenciaPainel
    salvarConfig()
end)

criarSlider(AbaVisual, "Tamanho da Fonte", 8, 16, tamanhoFonte, function(v)
    tamanhoFonte = v
    config.fonte = v
    salvarConfig()
end)

criarToggle(AbaVisual, "💎 Modo Transparente Total", false, function(v)
    if v then
        TweenService:Create(janelaPrincipal, TweenInfo.new(0.5), {BackgroundTransparency = 0.95}):Play()
        notificar("Visual", "Transparente ON", 2)
    else
        TweenService:Create(janelaPrincipal, TweenInfo.new(0.5), {BackgroundTransparency = transparenciaPainel}):Play()
        notificar("Visual", "Transparente OFF", 2)
    end
end)

criarToggle(AbaVisual, "🌫️ Blur no Fundo", false, function(v)
    if v then
        pcall(function()
            local b = Instance.new("BlurEffect")
            b.Size = 20
            b.Name = "PHANTOMBlur"
            b.Parent = Lighting
        end)
        notificar("Visual", "Blur ON", 2)
    else
        pcall(function()
            local b = Lighting:FindFirstChild("PHANTOMBlur")
            if b then b:Destroy() end
        end)
        notificar("Visual", "Blur OFF", 2)
    end
end)

local compactoExtremo = false
criarToggle(AbaVisual, "📱 Modo Compacto Extremo", false, function(v)
    compactoExtremo = v
    if v then
        janelaPrincipal.Size = UDim2.new(0, 60, 0, 60)
        janelaPrincipal.Position = UDim2.new(0, 15, 0.4, 0)
        barraTitulo.Visible = false
        painelAbas.Visible = false
        painelConteudo.Visible = false
        janelaPrincipal.BackgroundTransparency = 1
        notificar("Compacto", "Extremo ON", 3)
    else
        barraTitulo.Visible = true
        painelAbas.Visible = true
        painelConteudo.Visible = true
        janelaPrincipal.BackgroundTransparency = transparenciaPainel
        local tam = tamanhos[tamanhoIdx]
        janelaPrincipal.Size = tam
        janelaPrincipal.Position = UDim2.new(0.5, -(tam.X.Offset/2), 0.5, -(tam.Y.Offset/2))
        notificar("Compacto", "Extremo OFF", 2)
    end
end)

local temaAutoCon = nil
criarToggle(AbaVisual, "🕐 Tema Automático (Dia/Noite)", false, function(v)
    if v then
        if temaAutoCon then temaAutoCon:Disconnect() end
        temaAutoCon = task.spawn(function()
            while true do
                local hora = tonumber(os.date("%H"))
                if hora >= 6 and hora < 18 then
                    if presetAtual ~= "Neon" then aplicarPreset("Neon") end
                else
                    if presetAtual ~= "Dark" then aplicarPreset("Dark") end
                end
                task.wait(60)
            end
        end)
        notificar("Visual", "Tema automático ON", 2)
    else
        if temaAutoCon then task.cancel(temaAutoCon); temaAutoCon = nil end
        notificar("Visual", "Tema automático OFF", 2)
    end
end)

criarToggle(AbaVisual, "🪟 Efeito Vidro (Glassmorphism)", false, function(v)
    if v then
        janelaPrincipal.BackgroundTransparency = 0.7
        sJanela.Thickness = 2
        sJanela.Transparency = 0.3
        pcall(function()
            local b = Instance.new("BlurEffect")
            b.Size = 10
            b.Name = "GlassBlur"
            b.Parent = Lighting
        end)
        notificar("Visual", "Vidro ON", 2)
    else
        janelaPrincipal.BackgroundTransparency = transparenciaPainel
        sJanela.Thickness = 1
        sJanela.Transparency = 0.3
        pcall(function()
            local b = Lighting:FindFirstChild("GlassBlur")
            if b then b:Destroy() end
        end)
        notificar("Visual", "Vidro OFF", 2)
    end
end)

local cicloAtivo = false
criarToggle(AbaVisual, "🌈 Ciclo de Cores RGB", false, function(v)
    cicloAtivo = v
    if v then
        task.spawn(function()
            local h = 0
            while cicloAtivo do
                h = (h + 1) % 360
                local cor = Color3.fromHSV(h / 360, 1, 1)
                corDestaque = cor
                sJanela.Color = cor
                indicador.BackgroundColor3 = cor
                tituloJanela.TextColor3 = cor
                task.wait(0.05)
            end
        end)
        notificar("Visual", "Ciclo RGB ON", 2)
    else
        notificar("Visual", "Ciclo RGB OFF", 2)
    end
end)

criarToggle(AbaVisual, "📡 Modo Holograma", false, function(v)
    if v then
        janelaPrincipal.BackgroundTransparency = 0.85
        sJanela.Color = Color3.fromRGB(0, 255, 200)
        sJanela.Thickness = 2
        sJanela.Transparency = 0.3
        notificar("Visual", "Holograma ON", 2)
    else
        janelaPrincipal.BackgroundTransparency = transparenciaPainel
        sJanela.Color = corDestaque
        sJanela.Thickness = 1
        sJanela.Transparency = 0.3
        notificar("Visual", "Holograma OFF", 2)
    end
end)

criarBotao(AbaVisual, "💾 Salvar Config", function()
    salvarConfig()
    notificar("Config", "Salvo!", 2)
end)

criarBotao(AbaVisual, "🔄 Resetar Visual", function()
    config.preset = "Black"
    config.transparencia = 0
    config.fonte = 11
    salvarConfig()
    aplicarPreset("Black")
    transparenciaPainel = 0
    tamanhoFonte = 11
    janelaPrincipal.BackgroundTransparency = 0
    notificar("Reset", "Visual resetado!", 2)
end)

-- ========== UTILS ==========
criarBotao(AbaUtils, "Anti Trap", function() carregarScript("Anti Trap", "https://raw.githubusercontent.com/Lutosys/opensrc/refs/heads/main/StealAnEggAntiTrap.lua") end)
criarBotao(AbaUtils, "Auto Redeem Index", function() carregarScript("Auto Redeem", "https://raw.githubusercontent.com/Lutosys/opensrc/refs/heads/main/StealAnEggAutoredeemIndex.lua") end)
criarBotao(AbaUtils, "Rejoin Server", function() game:GetService("TeleportService"):Teleport(game.PlaceId, Players.LocalPlayer) end)

criarToggle(AbaUtils, "Rejoin Automático", false, function(v)
    if _G.rejoinCon then _G.rejoinCon:Disconnect(); _G.rejoinCon = nil end
    if v then
        _G.rejoinCon = Players.LocalPlayer.OnTeleport:Connect(function()
            task.wait(3)
            game:GetService("TeleportService"):Teleport(game.PlaceId, Players.LocalPlayer)
        end)
    end
end)

criarBotao(AbaUtils, "FPS Boost", function()
    pcall(function() settings().Rendering.QualityLevel = 1 end)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            pcall(function() v.Enabled = false end)
        end
    end
    notificar("FPS Boost", "Ativado!", 2)
end)

criarBotao(AbaUtils, "Server Hop", function()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, res = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    if ok and res and res.data then
        for _, s in ipairs(res.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, Players.LocalPlayer)
                return
            end
        end
    end
    notificar("Server Hop", "Nenhum encontrado.", 2)
end)

criarBotao(AbaUtils, "📋 Copiar Job ID", function()
    pcall(function() setclipboard(game.JobId) end)
    notificar("Job ID", "Copiado!", 2)
end)

criarBotao(AbaUtils, "🔄 Resetar Contador", function()
    contadorScripts = 0
    config.contadorScripts = 0
    salvarConfig()
    subTitulo.Text = "PHANTOM HUB • 0 scripts"
    notificar("Contador", "Resetado!", 2)
end)

local autoClickAtivo = false
local autoClickCon = nil
local autoClickIntervalo = 0.1

criarToggle(AbaUtils, "🖱️ Auto Clicker", false, function(v)
    autoClickAtivo = v
    if v then
        if autoClickCon then autoClickCon:Disconnect() end
        autoClickCon = task.spawn(function()
            while autoClickAtivo do
                pcall(function()
                    local vu = game:GetService("VirtualUser")
                    vu:CaptureController()
                    vu:ClickButton1(Vector2.new(500, 500))
                end)
                task.wait(autoClickIntervalo)
            end
        end)
        notificar("Auto Clicker", "ON", 2)
    else
        notificar("Auto Clicker", "OFF", 2)
    end
end)

criarSlider(AbaUtils, "Intervalo Auto Click (ms)", 10, 1000, 100, function(v)
    autoClickIntervalo = v / 1000
end)

criarToggle(AbaUtils, "🚫 Anti Kick (AFK)", false, function(v)
    if v then
        pcall(function()
            local vu = game:GetService("VirtualUser")
            Players.LocalPlayer.Idled:Connect(function()
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end)
        notificar("Anti Kick", "ON", 2)
    else
        notificar("Anti Kick", "OFF", 2)
    end
end)

local antiTeleportCon = nil
criarToggle(AbaUtils, "🛡️ Anti Teleport", false, function(v)
    if v then
        if antiTeleportCon then antiTeleportCon:Disconnect() end
        antiTeleportCon = RunService.Heartbeat:Connect(function()
            local char = Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                if _G.lastPos and (pos - _G.lastPos).Magnitude > 50 then
                    char.HumanoidRootPart.CFrame = _G.lastCFrame
                end
                _G.lastPos = pos
                _G.lastCFrame = char.HumanoidRootPart.CFrame
            end
        end)
        notificar("Anti TP", "ON", 2)
    else
        if antiTeleportCon then antiTeleportCon:Disconnect(); antiTeleportCon = nil end
        notificar("Anti TP", "OFF", 2)
    end
end)

criarToggle(AbaUtils, "💀 Auto Respawn", false, function(v)
    if v then
        Players.LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(1)
            pcall(function() char:WaitForChild("Humanoid") end)
        end)
        notificar("Auto Respawn", "ON", 2)
    else
        notificar("Auto Respawn", "OFF", 2)
    end
end)

local chatLog = {}
criarToggle(AbaUtils, "💬 Log de Chat", false, function(v)
    if v then
        Players.LocalPlayer.Chatted:Connect(function(msg)
            table.insert(chatLog, 1, "[" .. os.date("%H:%M:%S") .. "] " .. msg)
            if #chatLog > 50 then table.remove(chatLog) end
        end)
        notificar("Log Chat", "ON", 2)
    else
        notificar("Log Chat", "OFF", 2)
    end
end)

criarBotao(AbaUtils, "📜 Ver Log do Chat", function()
    local texto = ""
    for i, v in ipairs(chatLog) do
        if i > 10 then break end
        texto = texto .. v .. "\n"
    end
    notificar("💬 Chat", texto ~= "" and texto or "Nenhuma.", 5)
end)

criarBotao(AbaUtils, "🗑️ Limpar Log do Chat", function()
    chatLog = {}
    notificar("Chat", "Limpo!", 2)
end)

local espOvosAtivo = false
local ovosDestacados = {}
local espOvosCon = nil

local function limparESP()
    for _, obj in pairs(ovosDestacados) do
        pcall(function()
            if obj and obj.Parent then
                local hl = obj:FindFirstChild("ESPOvo")
                if hl then hl:Destroy() end
                local bill = obj:FindFirstChild("ESPOvoBillboard")
                if bill then bill:Destroy() end
            end
        end)
    end
    ovosDestacados = {}
end

local function destacarOvo(obj)
    if not obj or not obj:IsA("BasePart") then return end
    if obj:FindFirstChild("ESPOvo") then return end

    local hl = Instance.new("Highlight")
    hl.Name = "ESPOvo"
    hl.FillColor = Color3.fromRGB(255, 215, 0)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.Parent = obj

    local bill = Instance.new("BillboardGui")
    bill.Name = "ESPOvoBillboard"
    bill.Size = UDim2.new(0, 100, 0, 30)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true
    bill.Parent = obj

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🥚 " .. obj.Name
    label.TextColor3 = Color3.fromRGB(255, 215, 0)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = bill

    table.insert(ovosDestacados, obj)
end

local function escanearOvos()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nome = obj.Name:lower()
            if nome:find("egg") or nome:find("ovo") then
                destacarOvo(obj)
            end
        end
    end
end

criarToggle(AbaUtils, "🥚 ESP de Ovos", false, function(v)
    espOvosAtivo = v
    if v then
        escanearOvos()
        espOvosCon = workspace.DescendantAdded:Connect(function(obj)
            if espOvosAtivo and obj:IsA("BasePart") then
                local nome = obj.Name:lower()
                if nome:find("egg") or nome:find("ovo") then
                    destacarOvo(obj)
                end
            end
        end)
        notificar("ESP Ovos", "ON", 2)
    else
        if espOvosCon then espOvosCon:Disconnect(); espOvosCon = nil end
        limparESP()
        notificar("ESP Ovos", "OFF", 2)
    end
end)

criarBotao(AbaUtils, "🔄 Re-escanear Ovos", function()
    limparESP()
    escanearOvos()
    notificar("ESP Ovos", #ovosDestacados .. " ovos", 2)
end)

-- ========== NOTIFICAÇÕES ==========
criarToggle(AbaNotif, "Som de Notificação", config.somNotif, function(v)
    config.somNotif = v
    salvarConfig()
end)
criarToggle(AbaNotif, "Notificação de Ovo Raro", config.notifOvoRaro, function(v)
    config.notifOvoRaro = v
    salvarConfig()
end)
criarBotao(AbaNotif, "📜 Ver Histórico", function()
    local texto = ""
    for i, v in ipairs(historicoNotif) do
        if i > 8 then break end
        texto = texto .. v.hora .. " - " .. v.titulo .. ": " .. v.texto .. "\n"
    end
    notificar("Histórico", texto ~= "" and texto or "Nenhuma.", 5)
end)

-- ========== HISTÓRICO ==========
local histLabel = Instance.new("TextLabel")
histLabel.Size = UDim2.new(1, -10, 0, 24)
histLabel.BackgroundTransparency = 1
histLabel.Text = "📜 Últimos scripts carregados"
histLabel.TextColor3 = corDestaque
histLabel.Font = Enum.Font.GothamBold
histLabel.TextSize = tamanhoFonte + 1
histLabel.TextXAlignment = Enum.TextXAlignment.Left
histLabel.Parent = AbaHist

local botoesHistorico = {}

local function recriarHistorico()
    for _, b in ipairs(botoesHistorico) do
        pcall(function() b:Destroy() end)
    end
    botoesHistorico = {}
    for i, item in ipairs(config.historico) do
        local b = criarBotao(AbaHist, "🔄 " .. item.nome .. " (" .. item.hora .. ")", function()
            carregarScript(item.nome, item.url)
        end)
        table.insert(botoesHistorico, b)
    end
    if #config.historico == 0 then
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 30)
        label.BackgroundTransparency = 1
        label.Text = "Nenhum script carregado ainda."
        label.TextColor3 = corTexto
        label.Font = Enum.Font.Gotham
        label.TextSize = tamanhoFonte
        label.Parent = AbaHist
        table.insert(botoesHistorico, label)
    end
end

criarBotao(AbaHist, "🔄 Atualizar Lista", function() recriarHistorico() end)
criarBotao(AbaHist, "🗑️ Limpar Histórico", function()
    config.historico = {}
    salvarConfig()
    recriarHistorico()
    notificar("Histórico", "Limpo!", 2)
end)

-- ========== PERFIS ==========
local perfilLabel = Instance.new("TextLabel")
perfilLabel.Size = UDim2.new(1, -10, 0, 24)
perfilLabel.BackgroundTransparency = 1
perfilLabel.Text = "💾 Perfil: " .. perfilAtual
perfilLabel.TextColor3 = corDestaque
perfilLabel.Font = Enum.Font.GothamBold
perfilLabel.TextSize = tamanhoFonte + 1
perfilLabel.TextXAlignment = Enum.TextXAlignment.Left
perfilLabel.Parent = AbaPerfis

local listaPerfis = Instance.new("ScrollingFrame")
listaPerfis.Size = UDim2.new(1, -10, 0, 100)
listaPerfis.BackgroundTransparency = 1
listaPerfis.BorderSizePixel = 0
listaPerfis.ScrollBarThickness = 4
listaPerfis.ScrollBarImageColor3 = corDestaque
listaPerfis.AutomaticCanvasSize = Enum.AutomaticSize.Y
listaPerfis.CanvasSize = UDim2.new(0, 0, 0, 0)
listaPerfis.Parent = AbaPerfis

local layoutPerfis = Instance.new("UIListLayout")
layoutPerfis.Padding = UDim.new(0, 4)
layoutPerfis.Parent = listaPerfis

local function recriarListaPerfis()
    for _, child in pairs(listaPerfis:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for nome, dados in pairs(perfis) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -5, 0, 24)
        b.BackgroundColor3 = (nome == perfilAtual) and corDestaque or corBotao
        b.Text = "💾 " .. nome .. " (" .. (dados.data or "sem data") .. ")"
        b.TextColor3 = corTexto
        b.Font = Enum.Font.Gotham
        b.TextSize = tamanhoFonte - 1
        b.BorderSizePixel = 0
        b.Parent = listaPerfis

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = b

        b.MouseButton1Click:Connect(function()
            perfilAtual = nome
            perfilLabel.Text = "💾 Perfil: " .. nome
            recriarListaPerfis()
            if perfis[nome] then
                config.preset = perfis[nome].preset or "Black"
                config.transparencia = perfis[nome].transparencia or 0
                config.fonte = perfis[nome].fonte or 11
                config.somNotif = perfis[nome].somNotif ~= false
                config.modoCompacto = perfis[nome].modoCompacto or false
                salvarConfig()
                aplicarPreset(config.preset)
                transparenciaPainel = config.transparencia
                tamanhoFonte = config.fonte
                janelaPrincipal.BackgroundTransparency = transparenciaPainel
                notificar("Perfil", nome .. " carregado!", 2)
            end
        end)
    end
end

criarBotao(AbaPerfis, "💾 Salvar Perfil Atual", function()
    perfis[perfilAtual] = {
        preset = config.preset,
        transparencia = config.transparencia,
        fonte = config.fonte,
        somNotif = config.somNotif,
        modoCompacto = config.modoCompacto,
        data = os.date("%d/%m %H:%M")
    }
    salvarPerfis()
    recriarListaPerfis()
    notificar("Perfil", perfilAtual .. " salvo!", 2)
end)

criarBotao(AbaPerfis, "➕ Criar Novo Perfil", function()
    local nome = "Perfil_" .. os.date("%H%M%S")
    perfilAtual = nome
    perfis[nome] = {data = os.date("%d/%m %H:%M")}
    perfilLabel.Text = "💾 Perfil: " .. nome
    salvarPerfis()
    recriarListaPerfis()
    notificar("Perfil", nome .. " criado!", 2)
end)

criarBotao(AbaPerfis, "🗑️ Deletar Perfil Atual", function()
    if perfilAtual == "Padrão" then
        notificar("Perfil", "Não pode deletar o Padrão!", 2, true)
        return
    end
    perfis[perfilAtual] = nil
    salvarPerfis()
    perfilAtual = "Padrão"
    perfilLabel.Text = "💾 Perfil: Padrão"
    recriarListaPerfis()
    notificar("Perfil", "Deletado!", 2)
end)

criarBotao(AbaPerfis, "📤 Exportar Config", function()
    pcall(function()
        setclipboard(HttpService:JSONEncode(config))
        notificar("Exportar", "Config copiada!", 3)
    end)
end)

criarBotao(AbaPerfis, "📥 Importar Config", function()
    pcall(function()
        local texto = getclipboard()
        if texto and texto ~= "" then
            local dados = HttpService:JSONDecode(texto)
            for k, v in pairs(dados) do config[k] = v end
            salvarConfig()
            aplicarPreset(config.preset or "Black")
            notificar("Importar", "Config importada!", 3)
        else
            notificar("Importar", "Clipboard vazio!", 2, true)
        end
    end)
end)

criarBotao(AbaPerfis, "📦 Backup Agora", function()
    pcall(function()
        local nome = "backup_" .. os.date("%Y%m%d_%H%M%S") .. ".json"
        writefile(nome, HttpService:JSONEncode(config))
        notificar("Backup", "Salvo: " .. nome, 3)
    end)
end)

recriarListaPerfis()

-- ========== SOBRE ==========
local sobreLabel = Instance.new("TextLabel")
sobreLabel.Size = UDim2.new(1, -10, 1, -10)
sobreLabel.BackgroundTransparency = 1
sobreLabel.Text = "👻 PHANTOM HUB\n\nVersão: " .. VERSAO .. "\nAutor: V Scripts\n\nChangelog:\n• v1.7.0 - Black Edition + ASA MIKATA + MIRANDA + VXEZE\n• v1.6.0 - Novos scripts + orbs + explosão\n• v1.5.0 - Visual super insano\n• v1.4.0 - Visual avançado + utils + perfis\n• v1.3.0 - Rolagem + LKZ + PulseZax\n• v1.2.0 - Sons + sem intro\n• v1.1.0 - ESP + Webhook\n• v1.0.0 - Lançamento\n\nDiscord: discord.gg/CYp5CTu8rY"
sobreLabel.TextColor3 = corTexto
sobreLabel.Font = Enum.Font.Gotham
sobreLabel.TextSize = tamanhoFonte
sobreLabel.TextXAlignment = Enum.TextXAlignment.Left
sobreLabel.TextYAlignment = Enum.TextYAlignment.Top
sobreLabel.TextWrapped = true
sobreLabel.Parent = AbaSobre

-- ========== WEBHOOK ==========
local WEBHOOK_URL = ""

local function enviarWebhook(titulo, descricao, cor)
    if WEBHOOK_URL == "" then return end
    pcall(function()
        local dados = {
            ["embeds"] = {{
                ["title"] = titulo,
                ["description"] = descricao,
                ["color"] = cor or 3447003,
                ["footer"] = {["text"] = "PHANTOM HUB • " .. os.date("%d/%m/%Y %H:%M:%S")}
            }},
            ["username"] = "PHANTOM HUB"
        }
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(dados)
        })
    end)
end

local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(1, -10, 0, 34)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "𝐕 𝐒𝐂𝐑𝐈𝐏𝐓𝐒 𝗢𝗙𝗙𝗜𝗖𝗜𝗔𝗟\nEntre no servidor oficial!"
discordLabel.TextColor3 = corDestaque
discordLabel.Font = Enum.Font.GothamBold
discordLabel.TextSize = tamanhoFonte
discordLabel.TextWrapped = true
discordLabel.Parent = AbaDiscord

criarBotao(AbaDiscord, "💬 Entrar no Discord", function()
    local url = "https://discord.gg/CYp5CTu8rY"
    local ok = pcall(function() game:GetService("GuiService"):OpenBrowserWindow(url) end)
    if not ok then
        pcall(function() setclipboard(url) end)
        notificar("Discord", "Link copiado!", 3)
    end
end)
criarBotao(AbaDiscord, "📋 Copiar Link", function()
    pcall(function() setclipboard("https://discord.gg/CYp5CTu8rY") end)
    notificar("Copiado", "Link copiado!", 2)
end)
criarBotao(AbaDiscord, "🔗 Testar Webhook", function()
    if WEBHOOK_URL == "" then
        notificar("Webhook", "Configure a URL primeiro!", 3, true)
        return
    end
    enviarWebhook("🧪 Teste PHANTOM HUB", "Webhook funcionando!", 5763719)
    notificar("Webhook", "Teste enviado!", 2)
end)
criarBotao(AbaDiscord, "📤 Enviar Info Jogador", function()
    if WEBHOOK_URL == "" then
        notificar("Webhook", "Configure a URL primeiro!", 3, true)
        return
    end
    local j = Players.LocalPlayer
    enviarWebhook("👻 Novo usuário", "**Jogador:** " .. j.Name .. "\n**Display:** " .. j.DisplayName .. "\n**User ID:** " .. j.UserId, 3447003)
    notificar("Webhook", "Enviado!", 2)
end)
criarBotao(AbaDiscord, "📊 Enviar Stats", function()
    if WEBHOOK_URL == "" then
        notificar("Webhook", "Configure a URL primeiro!", 3, true)
        return
    end
    enviarWebhook("📊 Stats", "**Scripts:** " .. contadorScripts .. "\n**Jogadores:** " .. #Players:GetPlayers() .. "\n**Versão:** " .. VERSAO, 15844367)
    notificar("Webhook", "Enviado!", 2)
end)

-- ========== FUNÇÃO DE TAMANHO ==========
local function aplicarTamanho()
    local tam = tamanhos[tamanhoIdx]
    TweenService:Create(janelaPrincipal, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = tam,
        Position = UDim2.new(0.5, -(tam.X.Offset / 2), 0.5, -(tam.Y.Offset / 2))
    }):Play()
end

-- ========== BOTÃO FLUTUANTE ==========
local sgBotao = Instance.new("ScreenGui")
sgBotao.Name = "PHANTOMBotao"
sgBotao.ResetOnSpawn = false
sgBotao.IgnoreGuiInset = true
sgBotao.DisplayOrder = 999
sgBotao.Parent = playerGui

btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(0, 80, 0, 80)
btnContainer.Position = UDim2.new(0, 15, 0.4, 0)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = sgBotao

btnFlutuante = Instance.new("TextButton")
btnFlutuante.Size = UDim2.new(0, 60, 0, 60)
btnFlutuante.Position = UDim2.new(0.5, -30, 0.5, -30)
btnFlutuante.BackgroundColor3 = corDestaque
btnFlutuante.Text = "👻"
btnFlutuante.TextColor3 = Color3.fromRGB(255, 255, 255)
btnFlutuante.Font = Enum.Font.GothamBold
btnFlutuante.TextSize = 28
btnFlutuante.BorderSizePixel = 0
btnFlutuante.Visible = true
btnFlutuante.AutoButtonColor = false
btnFlutuante.Parent = btnContainer

local cBtn = Instance.new("UICorner")
cBtn.CornerRadius = UDim.new(1, 0)
cBtn.Parent = btnFlutuante

local sBtn = Instance.new("UIStroke")
sBtn.Color = Color3.fromRGB(255, 255, 255)
sBtn.Thickness = 2
sBtn.Parent = btnFlutuante

task.spawn(function()
    while btnFlutuante and btnFlutuante.Parent do
        TweenService:Create(btnFlutuante, TweenInfo.new(0.8), {Size = UDim2.new(0, 66, 0, 66), Position = UDim2.new(0.5, -33, 0.5, -33)}):Play()
        task.wait(0.8)
        TweenService:Create(btnFlutuante, TweenInfo.new(0.8), {Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0.5, -30, 0.5, -30)}):Play()
        task.wait(0.8)
    end
end)

btnFlutuante.MouseButton1Click:Connect(function() abrirPainel() end)

-- ========== ABRIR/FECHAR ==========
function abrirPainel()
    if animando then return end
    animando = true
    painelAberto = true
    sgPainel.Enabled = true
    btnContainer.Visible = false
    tocarSom("abrir", 0.4)
    explodirParticulas()

    local tam = tamanhos[tamanhoIdx]
    janelaPrincipal.Size = UDim2.new(0, 0, 0, 0)
    janelaPrincipal.Position = UDim2.new(0.5, 0, 0.5, 0)
    janelaPrincipal.BackgroundTransparency = 1
    janelaPrincipal.Rotation = -15

    for i = 1, 3 do
        janelaPrincipal.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        task.wait(0.03)
        janelaPrincipal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        task.wait(0.03)
        janelaPrincipal.BackgroundColor3 = corFundo
        task.wait(0.03)
    end

    TweenService:Create(janelaPrincipal, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = tam,
        Position = UDim2.new(0.5, -(tam.X.Offset / 2), 0.5, -(tam.Y.Offset / 2)),
        BackgroundTransparency = transparenciaPainel,
        Rotation = 0
    }):Play()

    task.wait(0.55)
    animando = false
end

function fecharPainel()
    if animando then return end
    animando = true
    tocarSom("fechar", 0.4)

    TweenService:Create(janelaPrincipal, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Rotation = 15
    }):Play()

    task.wait(0.4)

    painelAberto = false
    sgPainel.Enabled = false
    janelaPrincipal.Rotation = 0
    btnContainer.Visible = true
    animando = false
end

-- ========== INIT ==========
abrirPainel()
recriarHistorico()
recriarListaPerfis()
notificar("👻 PHANTOM HUB", "Black Edition + 3 scripts novos!", 4)
