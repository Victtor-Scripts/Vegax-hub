-- ============================================
-- PHANTOM HUB - BLACK EDITION SUPREMA
-- v2.0.0 - Completo em 2 partes
-- ============================================

local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local VERSAO = "2.0.0"
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
    sucesso = "rbxassetid://6895079853",
    hover = "rbxassetid://6895079853",
    whoosh = "rbxassetid://6895079853",
    pop = "rbxassetid://6895079853"
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

-- ========== PRESETS BLACK EDITION ==========
local presets = {
    Black = {fundo = Color3.fromRGB(0, 0, 0), painel = Color3.fromRGB(8, 8, 8), texto = Color3.fromRGB(230, 230, 230), botao = Color3.fromRGB(15, 15, 15), destaque = Color3.fromRGB(200, 0, 0)},
    BlackRoxo = {fundo = Color3.fromRGB(0, 0, 0), painel = Color3.fromRGB(8, 8, 8), texto = Color3.fromRGB(230, 230, 230), botao = Color3.fromRGB(15, 15, 15), destaque = Color3.fromRGB(120, 0, 200)},
    BlackVerde = {fundo = Color3.fromRGB(0, 0, 0), painel = Color3.fromRGB(8, 8, 8), texto = Color3.fromRGB(230, 230, 230), botao = Color3.fromRGB(15, 15, 15), destaque = Color3.fromRGB(0, 180, 80)},
    BlackAzul = {fundo = Color3.fromRGB(0, 0, 0), painel = Color3.fromRGB(8, 8, 8), texto = Color3.fromRGB(230, 230, 230), botao = Color3.fromRGB(15, 15, 15), destaque = Color3.fromRGB(0, 120, 255)},
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
        frame.Size = UDim2.new(0, 320, 0, 70)
        frame.Position = UDim2.new(1, 340, 0, 20)
        frame.BackgroundColor3 = isErro and Color3.fromRGB(50, 5, 5) or corPainel
        frame.BorderSizePixel = 0
        frame.Parent = sg

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 12)
        c.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = corBorda
        stroke.Thickness = 2
        stroke.Parent = frame

        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, corBorda),
            ColorSequenceKeypoint.new(1, corPainel)
        })
        grad.Rotation = 45
        grad.Parent = frame

        local icone = Instance.new("TextLabel")
        icone.Size = UDim2.new(0, 40, 0, 40)
        icone.Position = UDim2.new(0, 10, 0, 15)
        icone.BackgroundTransparency = 1
        icone.Text = isErro and "❌" or "⚡"
        icone.TextColor3 = corBorda
        icone.Font = Enum.Font.GothamBold
        icone.TextSize = 24
        icone.Parent = frame

        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(1, -60, 0, 22)
        t1.Position = UDim2.new(0, 55, 0, 8)
        t1.BackgroundTransparency = 1
        t1.Text = ""
        t1.TextColor3 = corBorda
        t1.Font = Enum.Font.GothamBold
        t1.TextSize = 15
        t1.TextXAlignment = Enum.TextXAlignment.Left
        t1.Parent = frame

        local t2 = Instance.new("TextLabel")
        t2.Size = UDim2.new(1, -60, 0, 32)
        t2.Position = UDim2.new(0, 55, 0, 32)
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

        TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Position = UDim2.new(1, -340, 0, 20)
        }):Play()

        task.delay(duracao, function()
            TweenService:Create(frame, TweenInfo.new(0.3), {
                Position = UDim2.new(1, 340, 0, 20)
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
        TweenService:Create(subTitulo, TweenInfo.new(0.1), {TextSize = tamOriginal + 5}):Play()
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
        for i = 1, 50 do
            local p = Instance.new("Frame")
            p.Size = UDim2.new(0, math.random(5, 12), 0, math.random(5, 12))
            p.Position = UDim2.new(0.5, 0, 0.5, 0)
            p.BackgroundColor3 = corDestaque
            p.BorderSizePixel = 0
            p.Parent = sg
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = p
            local angulo = math.random() * math.pi * 2
            local dist = math.random(250, 600)
            TweenService:Create(p, TweenInfo.new(math.random(0.5, 1.5), Enum.EasingStyle.Quad), {
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
cJanela.CornerRadius = UDim.new(0, 16)
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
    NumberSequenceKeypoint.new(0, 0.9),
    NumberSequenceKeypoint.new(0.5, 0.98),
    NumberSequenceKeypoint.new(1, 0.9)
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
scanline.BackgroundTransparency = 0.8
scanline.BorderSizePixel = 0
scanline.Parent = janelaPrincipal

local cScan = Instance.new("UICorner")
cScan.CornerRadius = UDim.new(1, 0)
cScan.Parent = scanline

for i = 1, 8 do
    local orb = Instance.new("Frame")
    orb.Size = UDim2.new(0, math.random(10, 18), 0, math.random(10, 18))
    orb.Position = UDim2.new(math.random(), 0, math.random(), 0)
    orb.BackgroundColor3 = corDestaque
    orb.BackgroundTransparency = 0.6
    orb.BorderSizePixel = 0
    orb.Parent = janelaPrincipal

    local oc = Instance.new("UICorner")
    oc.CornerRadius = UDim.new(1, 0)
    oc.Parent = orb

    local glow = Instance.new("UIStroke")
    glow.Color = corDestaque
    glow.Thickness = 4
    glow.Transparency = 0.7
    glow.Parent = orb

    table.insert(orbs, {frame = orb, glow = glow})
end

for i = 1, 12 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, math.random(3, 7), 0, math.random(3, 7))
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    p.BackgroundColor3 = corDestaque
    p.BackgroundTransparency = 0.7
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
                local novoTam = math.random(10, 20)
                TweenService:Create(orb.frame, TweenInfo.new(math.random(3, 7), Enum.EasingStyle.Sine), {
                    Position = UDim2.new(novaX, 0, novaY, 0),
                    Size = UDim2.new(0, novoTam, 0, novoTam),
                    BackgroundTransparency = math.random(40, 80) / 100
                }):Play()
                TweenService:Create(orb.glow, TweenInfo.new(math.random(2, 5), Enum.EasingStyle.Sine), {
                    Transparency = math.random(30, 80) / 100
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
                TweenService:Create(p, TweenInfo.new(math.random(2, 6), Enum.EasingStyle.Sine), {
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
        gradFundo.Rotation = (gradFundo.Rotation + 3) % 360
        task.wait(0.05)
    end
end)

task.spawn(function()
    while sJanela and sJanela.Parent do
        TweenService:Create(sJanela, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Transparency = 0.7, Thickness = 2}):Play()
        task.wait(1.5)
        TweenService:Create(sJanela, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Transparency = 0.3, Thickness = 1}):Play()
        task.wait(1.5)
    end
end)

task.spawn(function()
    while scanline and scanline.Parent do
        scanline.Position = UDim2.new(0, 0, 0, 0)
        TweenService:Create(scanline, TweenInfo.new(2, Enum.EasingStyle.Linear), {
            Position = UDim2.new(0, 0, 1, 0)
        }):Play()
        task.wait(2)
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
cBarra.CornerRadius = UDim.new(0, 16)
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
            tocarSom("hover", 0.15)
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

-- ========== CRIA ABAS (SEM "SOBRE") ==========
local AbaKeyless = criarAba("Keyless", "🔥")
local AbaKey = criarAba("Com Key", "🔑")
local AbaFun = criarAba("Funções", "⚡")
local AbaVisual = criarAba("Visual", "🎨")
local AbaUtils = criarAba("Utils", "🛠️")
local AbaNotif = criarAba("Notif", "🔔")
local AbaHist = criarAba("Histórico", "📜")
local AbaPerfis = criarAba("Perfis", "💾")
local AbaDiscord = criarAba("Discord", "💬")

abas[1].frame.Visible = true
abas[1].btn.BackgroundColor3 = corDestaque
abas[1].btn.BackgroundTransparency = 0
abaAtiva = abas[1].frame
indicador.Position = UDim2.new(0, 0, 0, 0)
