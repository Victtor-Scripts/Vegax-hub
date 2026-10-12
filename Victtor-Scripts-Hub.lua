--[[
    ⚡🌌👑 VICTTOR HUB — HYPER MEGA BRABO EDITION 👑🌌⚡
    Steal An Egg + Blox Fruits | 50+ Hubs
    Intro cinematográfica • Partículas • Horário global • Transições
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local function playSound(id, vol)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. id
        s.Volume = vol or 0.3
        s.Parent = SoundService
        s:Play()
        Debris:AddItem(s, 5)
    end)
end

local COLORS = {
    bg          = Color3.fromRGB(8, 4, 18),
    panel       = Color3.fromRGB(16, 10, 32),
    panelLight  = Color3.fromRGB(26, 18, 50),
    card        = Color3.fromRGB(22, 14, 44),
    cardHover   = Color3.fromRGB(40, 26, 76),
    stroke      = Color3.fromRGB(90, 60, 140),
    text        = Color3.fromRGB(248, 244, 255),
    subtext     = Color3.fromRGB(175, 155, 215),
    gold        = Color3.fromRGB(255, 220, 100),
    goldBright  = Color3.fromRGB(255, 245, 180),
    goldDark    = Color3.fromRGB(190, 140, 40),
    accent      = Color3.fromRGB(170, 105, 255),
    accentHover = Color3.fromRGB(200, 145, 255),
    accentDark  = Color3.fromRGB(90, 45, 170),
    green       = Color3.fromRGB(110, 250, 170),
    greenDark   = Color3.fromRGB(18, 80, 48),
    orange      = Color3.fromRGB(255, 165, 95),
    red         = Color3.fromRGB(255, 100, 130),
    cyan        = Color3.fromRGB(130, 230, 255),
    pink        = Color3.fromRGB(255, 130, 230),
    purple      = Color3.fromRGB(200, 130, 255),
    star        = Color3.fromRGB(240, 230, 255),
    white       = Color3.fromRGB(255, 255, 255),
}

local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = (typeof(r) == "number") and UDim.new(0, r) or r
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or COLORS.stroke
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

-- ==========================================
-- FUNDO HIPER GALÁCTICO
-- ==========================================
local GalaxyGui = Instance.new("ScreenGui")
GalaxyGui.Name = "HyperBackground"
GalaxyGui.IgnoreGuiInset = true
GalaxyGui.ResetOnSpawn = false
GalaxyGui.DisplayOrder = 0
GalaxyGui.Parent = CoreGui

for i = 1, 90 do
    local star = Instance.new("Frame")
    local sz = math.random(1, 4)
    star.Size = UDim2.new(0, sz, 0, sz)
    star.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
    star.BackgroundColor3 = COLORS.star
    star.BackgroundTransparency = math.random(20, 70) / 100
    star.BorderSizePixel = 0
    star.ZIndex = 0
    star.Parent = GalaxyGui
    corner(star, UDim.new(1, 0))

    task.spawn(function()
        while star.Parent do
            task.wait(math.random(15, 40) / 10)
            TweenService:Create(star, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
            task.wait(0.8)
            TweenService:Create(star, TweenInfo.new(0.8), {BackgroundTransparency = math.random(20, 70) / 100}):Play()
        end
    end)
end

task.spawn(function()
    while GalaxyGui.Parent do
        task.wait(math.random(3, 8))
        local Shooting = Instance.new("Frame")
        Shooting.Size = UDim2.new(0, 80, 0, 2)
        Shooting.Position = UDim2.new(math.random(0, 80) / 100, 0, math.random(0, 40) / 100, 0)
        Shooting.Rotation = 35
        Shooting.BackgroundColor3 = COLORS.goldBright
        Shooting.BorderSizePixel = 0
        Shooting.ZIndex = 0
        Shooting.Parent = GalaxyGui
        corner(Shooting, UDim.new(1, 0))

        TweenService:Create(Shooting, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {
            Position = UDim2.new(Shooting.Position.X.Scale + 0.5, 0, Shooting.Position.Y.Scale + 0.35, 0),
            BackgroundTransparency = 1
        }):Play()
        Debris:AddItem(Shooting, 1.6)
    end
end)

task.spawn(function()
    while GalaxyGui.Parent do
        task.wait(math.random(5, 12))
        local Beam = Instance.new("Frame")
        Beam.Size = UDim2.new(0, 2, 0, 350)
        Beam.Position = UDim2.new(math.random(0, 100) / 100, 0, -0.4, 0)
        Beam.BackgroundColor3 = COLORS.goldBright
        Beam.BackgroundTransparency = 0.4
        Beam.BorderSizePixel = 0
        Beam.ZIndex = 1
        Beam.Parent = GalaxyGui
        corner(Beam, UDim.new(1, 0))

        TweenService:Create(Beam, TweenInfo.new(2.2, Enum.EasingStyle.Quad), {
            Position = UDim2.new(Beam.Position.X.Scale, 0, 1.4, 0),
            BackgroundTransparency = 1
        }):Play()
        Debris:AddItem(Beam, 2.3)
    end
end)

-- ==========================================
-- INTRO HYPER MEGA
-- ==========================================
local function createIntro()
    local IntroGui = Instance.new("ScreenGui")
    IntroGui.Name = "HyperIntro"
    IntroGui.IgnoreGuiInset = true
    IntroGui.ResetOnSpawn = false
    IntroGui.DisplayOrder = 999
    IntroGui.Parent = CoreGui

    local BG = Instance.new("Frame")
    BG.Size = UDim2.new(1, 0, 1, 0)
    BG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BG.BackgroundTransparency = 1
    BG.BorderSizePixel = 0
    BG.Parent = IntroGui
    TweenService:Create(BG, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

    local Nebula = Instance.new("Frame")
    Nebula.Size = UDim2.new(1, 0, 1, 0)
    Nebula.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Nebula.BorderSizePixel = 0
    Nebula.ZIndex = 1
    Nebula.Parent = IntroGui

    local NG = Instance.new("UIGradient")
    NG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.25, COLORS.accentDark),
        ColorSequenceKeypoint.new(0.5, COLORS.goldDark),
        ColorSequenceKeypoint.new(0.75, COLORS.accentDark),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    NG.Rotation = 45
    NG.Parent = Nebula

    task.spawn(function()
        while Nebula.Parent do
            NG.Rotation = 45
            TweenService:Create(NG, TweenInfo.new(9, Enum.EasingStyle.Linear), {Rotation = 405}):Play()
            task.wait(9)
        end
    end)

    local Flash1 = Instance.new("Frame")
    Flash1.Size = UDim2.new(1, 0, 1, 0)
    Flash1.BackgroundColor3 = COLORS.goldBright
    Flash1.BorderSizePixel = 0
    Flash1.ZIndex = 30
    Flash1.Parent = IntroGui
    TweenService:Create(Flash1, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
    Debris:AddItem(Flash1, 0.4)

    for i = 1, 5 do
        local sz = 110 + (i * 25)
        local ring = Instance.new("Frame")
        ring.Size = UDim2.new(0, sz, 0, sz)
        ring.AnchorPoint = Vector2.new(0.5, 0.5)
        ring.Position = UDim2.new(0.5, 0, 0.33, 0)
        ring.BackgroundTransparency = 1
        ring.ZIndex = 6 - i
        ring.Parent = IntroGui
        corner(ring, UDim.new(1, 0))
        local colors = {COLORS.gold, COLORS.accent, COLORS.pink, COLORS.cyan, COLORS.purple}
        local rs = stroke(ring, colors[i], 2, 0.2)

        task.spawn(function()
            for _ = 1, 4 do
                ring.Size = UDim2.new(0, sz, 0, sz)
                rs.Transparency = 0.2
                TweenService:Create(ring, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, sz + 200, 0, sz + 200)
                }):Play()
                TweenService:Create(rs, TweenInfo.new(1.6), {Transparency = 1}):Play()
                task.wait(0.5)
            end
        end)
    end

    local LogoGlow = Instance.new("Frame")
    LogoGlow.Size = UDim2.new(0, 160, 0, 160)
    LogoGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoGlow.Position = UDim2.new(0.5, 0, 0.33, 0)
    LogoGlow.BackgroundColor3 = COLORS.accent
    LogoGlow.BackgroundTransparency = 0.65
    LogoGlow.BorderSizePixel = 0
    LogoGlow.ZIndex = 3
    LogoGlow.Parent = IntroGui
    corner(LogoGlow, 40)

    local LogoShadow = Instance.new("Frame")
    LogoShadow.Size = UDim2.new(0, 120, 0, 120)
    LogoShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoShadow.Position = UDim2.new(0.5, 0, 0.33, 7)
    LogoShadow.BackgroundColor3 = COLORS.accentDark
    LogoShadow.BackgroundTransparency = 0.25
    LogoShadow.BorderSizePixel = 0
    LogoShadow.ZIndex = 4
    LogoShadow.Parent = IntroGui
    corner(LogoShadow, 28)

    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(0, 110, 0, 110)
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.Position = UDim2.new(0.5, 0, 0.33, 0)
    Logo.BackgroundColor3 = COLORS.accent
    Logo.Text = "🌌"
    Logo.TextSize = 58
    Logo.Font = Enum.Font.GothamBlack
    Logo.BorderSizePixel = 0
    Logo.TextTransparency = 1
    Logo.BackgroundTransparency = 1
    Logo.ZIndex = 6
    Logo.Parent = IntroGui
    corner(Logo, 26)

    local LGrad = Instance.new("UIGradient")
    LGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.goldBright),
        ColorSequenceKeypoint.new(0.5, COLORS.accentHover),
        ColorSequenceKeypoint.new(1, COLORS.accentDark)
    })
    LGrad.Rotation = 45
    LGrad.Parent = Logo

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Position = UDim2.new(0, 0, 0.49, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "VICTTOR HUB"
    Title.TextColor3 = COLORS.text
    Title.TextStrokeTransparency = 0
    Title.TextStrokeColor3 = COLORS.goldDark
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 48
    Title.TextTransparency = 1
    Title.ZIndex = 6
    Title.Parent = IntroGui

    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(1, 0, 0, 26)
    Sub.Position = UDim2.new(0, 0, 0.575, 0)
    Sub.BackgroundTransparency = 1
    Sub.Text = "Steal An Egg  •  Blox Fruits"
    Sub.TextColor3 = COLORS.subtext
    Sub.Font = Enum.Font.GothamSemibold
    Sub.TextSize = 16
    Sub.TextTransparency = 1
    Sub.ZIndex = 6
    Sub.Parent = IntroGui

    local Tag = Instance.new("TextLabel")
    Tag.Size = UDim2.new(1, 0, 0, 22)
    Tag.Position = UDim2.new(0, 0, 0.625, 0)
    Tag.BackgroundTransparency = 1
    Tag.Text = "✦  H Y P E R   M E G A   B R A B O  ✦"
    Tag.TextColor3 = COLORS.pink
    Tag.Font = Enum.Font.GothamBlack
    Tag.TextSize = 13
    Tag.TextTransparency = 1
    Tag.ZIndex = 6
    Tag.Parent = IntroGui

    local LoadBarBG = Instance.new("Frame")
    LoadBarBG.Size = UDim2.new(0.5, 0, 0, 9)
    LoadBarBG.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadBarBG.Position = UDim2.new(0.5, 0, 0.71, 0)
    LoadBarBG.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
    LoadBarBG.BorderSizePixel = 0
    LoadBarBG.ZIndex = 5
    LoadBarBG.Parent = IntroGui
    corner(LoadBarBG, UDim.new(1, 0))

    local LoadBar = Instance.new("Frame")
    LoadBar.Size = UDim2.new(0, 0, 1, 0)
    LoadBar.BackgroundColor3 = COLORS.gold
    LoadBar.BorderSizePixel = 0
    LoadBar.ZIndex = 5
    LoadBar.Parent = LoadBarBG
    corner(LoadBar, UDim.new(1, 0))

    local LBGrad = Instance.new("UIGradient")
    LBGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.accent),
        ColorSequenceKeypoint.new(0.5, COLORS.goldBright),
        ColorSequenceKeypoint.new(1, COLORS.accent)
    })
    LBGrad.Parent = LoadBar

    local BarGlow = Instance.new("Frame")
    BarGlow.Size = UDim2.new(0, 55, 0, 28)
    BarGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    BarGlow.Position = UDim2.new(1, 0, 0.5, 0)
    BarGlow.BackgroundColor3 = COLORS.goldBright
    BarGlow.BackgroundTransparency = 0.25
    BarGlow.BorderSizePixel = 0
    BarGlow.ZIndex = 6
    BarGlow.Parent = LoadBar
    corner(BarGlow, UDim.new(1, 0))

    task.spawn(function()
        while BarGlow.Parent do
            TweenService:Create(BarGlow, TweenInfo.new(0.4), {BackgroundTransparency = 0.6, Size = UDim2.new(0, 70, 0, 34)}):Play()
            task.wait(0.4)
            TweenService:Create(BarGlow, TweenInfo.new(0.4), {BackgroundTransparency = 0.25, Size = UDim2.new(0, 55, 0, 28)}):Play()
            task.wait(0.4)
        end
    end)

    local loop = true
    task.spawn(function()
        while loop do
            task.wait(0.02)
            for _ = 1, 4 do
                local p = Instance.new("Frame")
                local sz = math.random(3, 9)
                p.Size = UDim2.new(0, sz, 0, sz)
                p.Position = UDim2.new(math.random(0, 100) / 100, 0, 1.05, 0)
                local colors = {COLORS.accent, COLORS.gold, COLORS.pink, COLORS.cyan, COLORS.star, COLORS.purple}
                p.BackgroundColor3 = colors[math.random(1, #colors)]
                p.BorderSizePixel = 0
                p.ZIndex = 7
                p.Parent = IntroGui
                corner(p, UDim.new(1, 0))
                TweenService:Create(p, TweenInfo.new(math.random(10, 18) / 10, Enum.EasingStyle.Quad), {
                    Position = UDim2.new(p.Position.X.Scale + math.random(-40, 40) / 100, 0, -0.1, 0),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 1, 0, 1)
                }):Play()
                Debris:AddItem(p, 2)
            end
        end
    end)

    task.spawn(function()
        task.wait(0.4)
        for _ = 1, 30 do
            Logo.Position = UDim2.new(0.5, math.random(-10, 10), 0.33, math.random(-10, 10))
            LogoShadow.Position = UDim2.new(0.5, math.random(-6, 6), 0.33, 7 + math.random(-6, 6))
            task.wait(0.02)
        end
        Logo.Position = UDim2.new(0.5, 0, 0.33, 0)
        LogoShadow.Position = UDim2.new(0.5, 0, 0.33, 7)
    end)

    task.spawn(function()
        while loop do
            task.wait(0.09)
            if math.random(1, 3) == 1 then
                Title.Position = UDim2.new(0, math.random(-4, 4), 0.49, math.random(-4, 4))
                task.wait(0.04)
                Title.Position = UDim2.new(0, 0, 0.49, 0)
            end
        end
    end)

    TweenService:Create(LogoGlow, TweenInfo.new(0.5, Enum.EasingStyle.Back), {BackgroundTransparency = 0.3, Size = UDim2.new(0, 210, 0, 210)}):Play()
    TweenService:Create(Logo, TweenInfo.new(0.5, Enum.EasingStyle.Back), {TextTransparency = 0, BackgroundTransparency = 0}):Play()
    TweenService:Create(LogoShadow, TweenInfo.new(0.5, Enum.EasingStyle.Back), {BackgroundTransparency = 0.05, Size = UDim2.new(0, 145, 0, 145)}):Play()
    task.wait(0.35)
    TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Back), {TextTransparency = 0}):Play()
    task.wait(0.2)
    TweenService:Create(Sub, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    task.wait(0.15)
    TweenService:Create(Tag, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(LoadBar, TweenInfo.new(2.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()

    task.spawn(function()
        while loop do
            task.wait(0.35)
            TweenService:Create(Title, TweenInfo.new(0.35), {TextColor3 = COLORS.goldBright, TextStrokeColor3 = COLORS.accent}):Play()
            task.wait(0.35)
            TweenService:Create(Title, TweenInfo.new(0.35), {TextColor3 = COLORS.text, TextStrokeColor3 = COLORS.goldDark}):Play()
        end
    end)

    task.wait(3)
    loop = false

    local Shock = Instance.new("Frame")
    Shock.Size = UDim2.new(0, 100, 0, 100)
    Shock.AnchorPoint = Vector2.new(0.5, 0.5)
    Shock.Position = UDim2.new(0.5, 0, 0.33, 0)
    Shock.BackgroundTransparency = 1
    Shock.ZIndex = 38
    Shock.Parent = IntroGui
    corner(Shock, UDim.new(1, 0))
    local ShockS = stroke(Shock, COLORS.goldBright, 5, 0)
    TweenService:Create(Shock, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 1200, 0, 1200)}):Play()
    TweenService:Create(ShockS, TweenInfo.new(1), {Transparency = 1, Thickness = 0}):Play()
    Debris:AddItem(Shock, 1.1)

    local Flash2 = Instance.new("Frame")
    Flash2.Size = UDim2.new(1, 0, 1, 0)
    Flash2.BackgroundColor3 = COLORS.goldBright
    Flash2.BorderSizePixel = 0
    Flash2.ZIndex = 40
    Flash2.Parent = IntroGui
    TweenService:Create(Flash2, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    Debris:AddItem(Flash2, 0.65)

    for i = 1, 64 do
        local Spike = Instance.new("Frame")
        local angle = (i / 64) * math.pi * 2
        Spike.Size = UDim2.new(0, 2, 0, 260)
        Spike.AnchorPoint = Vector2.new(0.5, 0.5)
        Spike.Position = UDim2.new(0.5, 0, 0.33, 0)
        Spike.Rotation = math.deg(angle)
        local c = i % 4 == 0 and COLORS.goldBright or (i % 4 == 1 and COLORS.white or (i % 4 == 2 and COLORS.pink or COLORS.accentHover))
        Spike.BackgroundColor3 = c
        Spike.BorderSizePixel = 0
        Spike.ZIndex = 35
        Spike.Parent = IntroGui
        TweenService:Create(Spike, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 640),
            BackgroundTransparency = 1
        }):Play()
        Debris:AddItem(Spike, 0.7)
    end

    playSound("5801257793", 0.85)

    TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 1, Position = UDim2.new(0, 0, 0.44, 0)}):Play()
    TweenService:Create(Sub, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(Tag, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(Logo, TweenInfo.new(0.3), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    TweenService:Create(LogoShadow, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LogoGlow, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadBarBG, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadBar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BG, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()

    task.wait(0.7)
    IntroGui:Destroy()
end

createIntro()

-- ==========================================
-- UI PRINCIPAL
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VicttorHub"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 58, 0, 58)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -29)
OpenBtn.BackgroundColor3 = COLORS.panel
OpenBtn.Text = "🌌"
OpenBtn.TextSize = 28
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextColor3 = COLORS.gold
OpenBtn.BorderSizePixel = 0
OpenBtn.AutoButtonColor = false
OpenBtn.Parent = ScreenGui
corner(OpenBtn, UDim.new(1, 0))
local OCS = stroke(OpenBtn, COLORS.gold, 2)

local OpenGlow = Instance.new("Frame")
OpenGlow.Size = UDim2.new(0, 76, 0, 76)
OpenGlow.Position = UDim2.new(0, 11, 0.5, -38)
OpenGlow.BackgroundColor3 = COLORS.gold
OpenGlow.BackgroundTransparency = 0.8
OpenGlow.BorderSizePixel = 0
OpenGlow.ZIndex = 0
OpenGlow.Parent = ScreenGui
corner(OpenGlow, UDim.new(1, 0))

task.spawn(function()
    while OpenBtn.Parent do
        TweenService:Create(OCS, TweenInfo.new(0.8), {Transparency = 0.3, Thickness = 3.5}):Play()
        TweenService:Create(OpenGlow, TweenInfo.new(0.8), {BackgroundTransparency = 0.5, Size = UDim2.new(0, 90, 0, 90), Position = UDim2.new(0, 4, 0.5, -45)}):Play()
        task.wait(0.8)
        TweenService:Create(OCS, TweenInfo.new(0.8), {Transparency = 0, Thickness = 2}):Play()
        TweenService:Create(OpenGlow, TweenInfo.new(0.8), {BackgroundTransparency = 0.8, Size = UDim2.new(0, 76, 0, 76), Position = UDim2.new(0, 11, 0.5, -38)}):Play()
        task.wait(0.8)
    end
end)

local WIN_W, WIN_H = 680, 370

local MainShadow = Instance.new("Frame")
MainShadow.Size = UDim2.new(0, WIN_W + 24, 0, WIN_H + 24)
MainShadow.Position = UDim2.new(0.5, -WIN_W/2 - 12, 0.5, -WIN_H/2 + 10)
MainShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.BackgroundTransparency = 0.55
MainShadow.BorderSizePixel = 0
MainShadow.Visible = false
MainShadow.ZIndex = 0
MainShadow.Parent = ScreenGui
corner(MainShadow, 24)

local MainShadow2 = Instance.new("Frame")
MainShadow2.Size = UDim2.new(0, WIN_W + 44, 0, WIN_H + 44)
MainShadow2.Position = UDim2.new(0.5, -WIN_W/2 - 22, 0.5, -WIN_H/2 + 16)
MainShadow2.BackgroundColor3 = COLORS.accent
MainShadow2.BackgroundTransparency = 0.85
MainShadow2.BorderSizePixel = 0
MainShadow2.Visible = false
MainShadow2.ZIndex = -1
MainShadow2.Parent = ScreenGui
corner(MainShadow2, 28)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, WIN_W, 0, WIN_H)
Main.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
Main.BackgroundColor3 = COLORS.bg
Main.BorderSizePixel = 0
Main.Visible = false
Main.ClipsDescendants = false
Main.Parent = ScreenGui
corner(Main, 18)
local MCS = stroke(Main, COLORS.goldDark, 1.8)

local PanelBG = Instance.new("Frame")
PanelBG.Size = UDim2.new(1, 0, 1, 0)
PanelBG.BackgroundColor3 = COLORS.bg
PanelBG.BorderSizePixel = 0
PanelBG.ZIndex = 0
PanelBG.ClipsDescendants = true
PanelBG.Parent = Main
corner(PanelBG, 18)

local PBG = Instance.new("UIGradient")
PBG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 6, 24)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(24, 14, 48)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 6, 24))
})
PBG.Rotation = 135
PBG.Parent = PanelBG

task.spawn(function()
    while PanelBG.Parent do
        PBG.Rotation = 135
        TweenService:Create(PBG, TweenInfo.new(12, Enum.EasingStyle.Linear), {Rotation = 495}):Play()
        task.wait(12)
    end
end)

task.spawn(function()
    local t = 0
    while Main.Parent do
        t = t + 0.01
        if t > 1 then t = 0 end
        MCS.Color = COLORS.gold:Lerp(COLORS.accentHover, t)
        task.wait(0.05)
    end
end)

task.spawn(function()
    while Main.Parent do
        if Main.Visible then
            TweenService:Create(MCS, TweenInfo.new(1), {Thickness = 3}):Play()
            task.wait(1)
            TweenService:Create(MCS, TweenInfo.new(1), {Thickness = 1.8}):Play()
            task.wait(1)
        else
            task.wait(0.5)
        end
    end
end)

-- Partículas
task.spawn(function()
    while Main.Parent do
        task.wait(0.04)
        if Main.Visible then
            local p = Instance.new("Frame")
            local sz = math.random(3, 10)
            p.Size = UDim2.new(0, sz, 0, sz)
            p.Position = UDim2.new(math.random(0, 100) / 100, 0, 1, 0)
            p.BackgroundColor3 = ({COLORS.gold, COLORS.accent, COLORS.pink, COLORS.cyan, COLORS.star, COLORS.purple})[math.random(1, 6)]
            p.BorderSizePixel = 0
            p.ZIndex = 100
            p.Parent = Main.Parent
            corner(p, UDim.new(1, 0))

            TweenService:Create(p, TweenInfo.new(math.random(15, 25) / 10, Enum.EasingStyle.Quad), {
                Position = UDim2.new(p.Position.X.Scale + math.random(-50, 50) / 100, 0, -0.1, 0),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 1, 0, 1)
            }):Play()

            task.delay(3, function()
                if p and p.Parent then p:Destroy() end
            end)
        end
    end
end)

task.spawn(function()
    while Main.Parent do
        task.wait(0.08)
        if Main.Visible then
            local p = Instance.new("Frame")
            local sz = math.random(2, 8)
            p.Size = UDim2.new(0, sz, 0, sz)
            local fromLeft = math.random(1, 2) == 1
            if fromLeft then
                p.Position = UDim2.new(0, 0, math.random(0, 100) / 100, 0)
            else
                p.Position = UDim2.new(1, 0, math.random(0, 100) / 100, 0)
            end
            p.BackgroundColor3 = ({COLORS.gold, COLORS.accent, COLORS.pink, COLORS.cyan, COLORS.purple})[math.random(1, 5)]
            p.BorderSizePixel = 0
            p.ZIndex = 100
            p.Parent = Main.Parent
            corner(p, UDim.new(1, 0))

            local targetX = fromLeft and (p.Position.X.Scale - 0.1) or (p.Position.X.Scale + 0.1)
            TweenService:Create(p, TweenInfo.new(math.random(15, 25) / 10, Enum.EasingStyle.Quad), {
                Position = UDim2.new(targetX, 0, p.Position.Y.Scale + math.random(-20, 20) / 100, 0),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 1, 0, 1)
            }):Play()

            task.delay(3, function()
                if p and p.Parent then p:Destroy() end
            end)
        end
    end
end)

-- ==========================================
-- HEADER
-- ==========================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 62)
Header.BackgroundColor3 = COLORS.panel
Header.BorderSizePixel = 0
Header.ZIndex = 2
Header.Parent = Main
corner(Header, 18)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = COLORS.panel
HeaderFix.BorderSizePixel = 0
HeaderFix.ZIndex = 2
HeaderFix.Parent = Header

local HGrad = Instance.new("UIGradient")
HGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 12, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 30, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 12, 40))
})
HGrad.Parent = Header

task.spawn(function()
    while Header.Parent do
        HGrad.Rotation = 0
        TweenService:Create(HGrad, TweenInfo.new(3), {Rotation = 180}):Play()
        task.wait(3)
    end
end)

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 1, -1)
HeaderLine.BackgroundColor3 = COLORS.gold
HeaderLine.BorderSizePixel = 0
HeaderLine.ZIndex = 3
HeaderLine.Parent = Header

local HLGrad = Instance.new("UIGradient")
HLGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.accent),
    ColorSequenceKeypoint.new(0.5, COLORS.goldBright),
    ColorSequenceKeypoint.new(1, COLORS.accent)
})
HLGrad.Parent = HeaderLine

task.spawn(function()
    while HeaderLine.Parent do
        HLGrad.Offset = Vector2.new(0, 0)
        TweenService:Create(HLGrad, TweenInfo.new(3), {Offset = Vector2.new(1, 0)}):Play()
        task.wait(3)
    end
end)

task.spawn(function()
    while Header.Parent do
        local glow = Instance.new("Frame")
        glow.Size = UDim2.new(0, 80, 1, 0)
        glow.Position = UDim2.new(-0.2, 0, 0, 0)
        glow.BackgroundColor3 = COLORS.goldBright
        glow.BackgroundTransparency = 0.7
        glow.BorderSizePixel = 0
        glow.ZIndex = 4
        glow.Parent = Header

        local gGrad = Instance.new("UIGradient")
        gGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        gGrad.Parent = glow

        TweenService:Create(glow, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {
            Position = UDim2.new(1.2, 0, 0, 0)
        }):Play()
        Debris:AddItem(glow, 2.6)
        task.wait(5)
    end
end)

local HLogoShadow = Instance.new("Frame")
HLogoShadow.Size = UDim2.new(0, 46, 0, 46)
HLogoShadow.Position = UDim2.new(0, 18, 0, 12)
HLogoShadow.BackgroundColor3 = COLORS.accentDark
HLogoShadow.BackgroundTransparency = 0.4
HLogoShadow.BorderSizePixel = 0
HLogoShadow.ZIndex = 2
HLogoShadow.Parent = Header
corner(HLogoShadow, 13)

local HLogo = Instance.new("TextLabel")
HLogo.Size = UDim2.new(0, 42, 0, 42)
HLogo.Position = UDim2.new(0, 16, 0, 10)
HLogo.BackgroundColor3 = COLORS.accent
HLogo.Text = "🌌"
HLogo.TextSize = 24
HLogo.Font = Enum.Font.GothamBlack
HLogo.BorderSizePixel = 0
HLogo.ZIndex = 3
HLogo.Parent = Header
corner(HLogo, 11)

local HLG2 = Instance.new("UIGradient")
HLG2.Color = ColorSequence.new(COLORS.goldBright, COLORS.accentDark)
HLG2.Rotation = 45
HLG2.Parent = HLogo

task.spawn(function()
    while HLG2.Parent do
        HLG2.Rotation = 0
        TweenService:Create(HLG2, TweenInfo.new(3), {Rotation = 360}):Play()
        task.wait(3)
    end
end)

local HTitle = Instance.new("TextLabel")
HTitle.Size = UDim2.new(0, 220, 0, 22)
HTitle.Position = UDim2.new(0, 70, 0, 12)
HTitle.BackgroundTransparency = 1
HTitle.Text = "VICTTOR HUB"
HTitle.TextColor3 = COLORS.goldBright
HTitle.Font = Enum.Font.GothamBlack
HTitle.TextSize = 17
HTitle.TextXAlignment = Enum.TextXAlignment.Left
HTitle.ZIndex = 3
HTitle.Parent = Header

local HSub = Instance.new("TextLabel")
HSub.Size = UDim2.new(0, 220, 0, 16)
HSub.Position = UDim2.new(0, 70, 0, 33)
HSub.BackgroundTransparency = 1
HSub.Text = "Steal An Egg  •  Blox Fruits"
HSub.TextColor3 = COLORS.subtext
HSub.Font = Enum.Font.GothamSemibold
HSub.TextSize = 11
HSub.TextXAlignment = Enum.TextXAlignment.Left
HSub.ZIndex = 3
HSub.Parent = Header

local PlayerCounter = Instance.new("TextLabel")
PlayerCounter.Size = UDim2.new(0, 120, 0, 16)
PlayerCounter.Position = UDim2.new(0, 260, 0, 33)
PlayerCounter.BackgroundTransparency = 1
PlayerCounter.Text = "👥 Online: 0"
PlayerCounter.TextColor3 = COLORS.cyan
PlayerCounter.Font = Enum.Font.GothamBold
PlayerCounter.TextSize = 10
PlayerCounter.TextXAlignment = Enum.TextXAlignment.Left
PlayerCounter.ZIndex = 3
PlayerCounter.Parent = Header

task.spawn(function()
    while PlayerCounter.Parent do
        PlayerCounter.Text = "👥 Online: " .. #Players:GetPlayers()
        task.wait(2)
    end
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -46, 0, 16)
CloseBtn.BackgroundColor3 = COLORS.red
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 3
CloseBtn.Parent = Header
corner(CloseBtn, 9)

-- ==========================================
-- SEARCH + PILLS
-- ==========================================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, -24, 0, 42)
TopBar.Position = UDim2.new(0, 12, 0, 72)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 2
TopBar.Parent = Main

local SearchHolder = Instance.new("Frame")
SearchHolder.Size = UDim2.new(0, 0.35, 1, 0)
SearchHolder.BackgroundColor3 = COLORS.card
SearchHolder.BorderSizePixel = 0
SearchHolder.ZIndex = 2
SearchHolder.Parent = TopBar
corner(SearchHolder, 10)
local SearchStroke = stroke(SearchHolder, COLORS.stroke, 1)

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 28, 1, 0)
SearchIcon.Position = UDim2.new(0, 4, 0, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextSize = 12
SearchIcon.Font = Enum.Font.GothamBold
SearchIcon.ZIndex = 3
SearchIcon.Parent = SearchHolder

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -40, 1, 0)
SearchBox.Position = UDim2.new(0, 32, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "Buscar script..."
SearchBox.PlaceholderColor3 = COLORS.subtext
SearchBox.TextColor3 = COLORS.text
SearchBox.Font = Enum.Font.GothamSemibold
SearchBox.TextSize = 11
SearchBox.BorderSizePixel = 0
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.ZIndex = 3
SearchBox.Parent = SearchHolder

SearchBox.Focused:Connect(function()
    TweenService:Create(SearchStroke, TweenInfo.new(0.15), {Color = COLORS.gold, Thickness = 1.5}):Play()
end)
SearchBox.FocusLost:Connect(function()
    TweenService:Create(SearchStroke, TweenInfo.new(0.15), {Color = COLORS.stroke, Thickness = 1}):Play()
end)

local PillsScroll = Instance.new("ScrollingFrame")
PillsScroll.Size = UDim2.new(0.65, -8, 1, 0)
PillsScroll.Position = UDim2.new(0.35, 8, 0, 0)
PillsScroll.BackgroundTransparency = 1
PillsScroll.BorderSizePixel = 0
PillsScroll.ScrollBarThickness = 0
PillsScroll.ScrollingDirection = Enum.ScrollingDirection.X
PillsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PillsScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
PillsScroll.ZIndex = 2
PillsScroll.Parent = TopBar

local PillsLayout = Instance.new("UIListLayout")
PillsLayout.FillDirection = Enum.FillDirection.Horizontal
PillsLayout.Padding = UDim.new(0, 5)
PillsLayout.SortOrder = Enum.SortOrder.LayoutOrder
PillsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
PillsLayout.Parent = PillsScroll

-- ==========================================
-- CARDS
-- ==========================================
local CardsScroll = Instance.new("ScrollingFrame")
CardsScroll.Size = UDim2.new(1, -24, 1, -196)
CardsScroll.Position = UDim2.new(0, 12, 0, 122)
CardsScroll.BackgroundTransparency = 1
CardsScroll.BorderSizePixel = 0
CardsScroll.ScrollBarThickness = 4
CardsScroll.ScrollBarImageColor3 = COLORS.gold
CardsScroll.ScrollBarImageTransparency = 0.3
CardsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
CardsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
CardsScroll.ZIndex = 2
CardsScroll.Parent = Main

local CardsGrid = Instance.new("UIGridLayout")
CardsGrid.CellSize = UDim2.new(0.5, -4, 0, 70)
CardsGrid.CellPadding = UDim2.new(0, 8, 0, 8)
CardsGrid.SortOrder = Enum.SortOrder.LayoutOrder
CardsGrid.Parent = CardsScroll

local CardsPad = Instance.new("UIPadding")
CardsPad.PaddingRight = UDim.new(0, 8)
CardsPad.Parent = CardsScroll

local ResultCount = Instance.new("TextLabel")
ResultCount.Size = UDim2.new(1, -24, 0, 18)
ResultCount.Position = UDim2.new(0, 12, 0, 118)
ResultCount.BackgroundTransparency = 1
ResultCount.Text = ""
ResultCount.TextColor3 = COLORS.subtext
ResultCount.Font = Enum.Font.GothamSemibold
ResultCount.TextSize = 10
ResultCount.TextXAlignment = Enum.TextXAlignment.Left
ResultCount.ZIndex = 3
ResultCount.Parent = Main

-- ==========================================
-- STATUS BAR
-- ==========================================
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -24, 0, 40)
StatusBar.Position = UDim2.new(0, 12, 1, -52)
StatusBar.BackgroundColor3 = COLORS.panel
StatusBar.BorderSizePixel = 0
StatusBar.ZIndex = 3
StatusBar.Parent = Main
corner(StatusBar, 11)
stroke(StatusBar, COLORS.stroke, 1)

local StatusDotGlow = Instance.new("Frame")
StatusDotGlow.Size = UDim2.new(0, 16, 0, 16)
StatusDotGlow.Position = UDim2.new(0, 10, 0.5, -8)
StatusDotGlow.BackgroundColor3 = COLORS.green
StatusDotGlow.BackgroundTransparency = 0.7
StatusDotGlow.BorderSizePixel = 0
StatusDotGlow.ZIndex = 4
StatusDotGlow.Parent = StatusBar
corner(StatusDotGlow, UDim.new(1, 0))

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 9, 0, 9)
StatusDot.Position = UDim2.new(0, 14, 0.5, -4.5)
StatusDot.BackgroundColor3 = COLORS.green
StatusDot.BorderSizePixel = 0
StatusDot.ZIndex = 5
StatusDot.Parent = StatusBar
corner(StatusDot, UDim.new(1, 0))

task.spawn(function()
    while StatusDot.Parent do
        TweenService:Create(StatusDotGlow, TweenInfo.new(1), {BackgroundTransparency = 0.3, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 8, 0.5, -10)}):Play()
        task.wait(1)
        TweenService:Create(StatusDotGlow, TweenInfo.new(1), {BackgroundTransparency = 0.7, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 10, 0.5, -8)}):Play()
        task.wait(1)
    end
end)

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0, 260, 1, 0)
StatusText.Position = UDim2.new(0, 34, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Pronto  •  VICTTOR HUB"
StatusText.TextColor3 = COLORS.goldBright
StatusText.Font = Enum.Font.GothamSemibold
StatusText.TextSize = 11
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.ZIndex = 4
StatusText.Parent = StatusBar

local function makeStatChip(parent, xoffset, icon, label)
    local Chip = Instance.new("Frame")
    Chip.Size = UDim2.new(0, 84, 0, 24)
    Chip.Position = UDim2.new(1, xoffset, 0.5, -12)
    Chip.BackgroundColor3 = COLORS.panelLight
    Chip.BorderSizePixel = 0
    Chip.ZIndex = 4
    Chip.Parent = parent
    corner(Chip, 6)

    local I = Instance.new("TextLabel")
    I.Size = UDim2.new(0, 18, 1, 0)
    I.Position = UDim2.new(0, 5, 0, 0)
    I.BackgroundTransparency = 1
    I.Text = icon
    I.TextSize = 10
    I.Font = Enum.Font.GothamBold
    I.ZIndex = 5
    I.Parent = Chip

    local T = Instance.new("TextLabel")
    T.Size = UDim2.new(1, -24, 1, 0)
    T.Position = UDim2.new(0, 20, 0, 0)
    T.BackgroundTransparency = 1
    T.Text = label
    T.TextColor3 = COLORS.subtext
    T.Font = Enum.Font.GothamSemibold
    T.TextSize = 9
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.ZIndex = 5
    T.Parent = Chip

    return T
end

local FpsVal  = makeStatChip(StatusBar, -376, "⚡", "FPS 60")
local PingVal = makeStatChip(StatusBar, -284, "📡", "PING --")
local PlrVal  = makeStatChip(StatusBar, -192, "👥", "PLR 1")
local TimeVal = makeStatChip(StatusBar, -100, "🕒", "00:00:00")

task.spawn(function()
    while StatusBar.Parent do
        local ok, ping = pcall(function()
            return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if not ok or ping < 0 then ping = 0 end
        local players = #Players:GetPlayers()
        local fps = math.floor(1 / workspace:GetRealPhysicsFPS())
        if fps <= 0 or fps > 999 then fps = 60 end
        FpsVal.Text = "FPS " .. fps
        PingVal.Text = "PING " .. ping
        PlrVal.Text = "PLR " .. players
        task.wait(1)
    end
end)

task.spawn(function()
    while StatusBar.Parent do
        local t = os.date("*t", os.time())
        TimeVal.Text = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
        task.wait(1)
    end
end)

-- ==========================================
-- DATABASE
-- ==========================================
local SCRIPTS = {
    -- EGG • DESTAQUES
    { name = "Chilli Hub", cat = "Egg • Destaques", desc = "Auto Steal • Target Areas", keyless = true, tag = "POPULAR",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))() end },
    { name = "Ouroboros Hub", cat = "Egg • Destaques", desc = "Auto Steal • Auto Hatch", keyless = true, tag = "NOVO",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"))() end },
    { name = "Pig Hub", cat = "Egg • Destaques", desc = "Auto Sell • Auto Farm", keyless = true, tag = "TOP",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/mopsscript7-gif/steal-an-egg/refs/heads/main/script.lua"))() end },
    { name = "Pulse Hub", cat = "Egg • Destaques", desc = "Auto Equip Best", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua"))() end },
    { name = "Polluted Hub", cat = "Egg • Destaques", desc = "Auto Steal • Auto Boss", keyless = true, tag = "TOP",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/PollutedHub/Sae/main/SaePolluted"))() end },
    { name = "Clover Hub", cat = "Egg • Destaques", desc = "Persistent Steal", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Ryuun0x/Clover/refs/heads/main/main.lua"))() end },
    { name = "Solix Hub", cat = "Egg • Destaques", desc = "Godmode • Auto Farm", keyless = false, tag = "KEY",
      load = function() loadstring(game:HttpGet("https://solixhub.com/loader"))() end },
    { name = "Snowy Hub", cat = "Egg • Destaques", desc = "Fly • Noclip", keyless = false, tag = "KEY",
      load = function() loadstring(game:HttpGet("https://flowauth.net/v1/ui/a87f00d9adf63658655fcd02ab86a4ef.lua"))() end },

    -- EGG • AUTO FARM
    { name = "Toolbox Hub", cat = "Egg • Auto Farm", desc = "Teleports • Anti Ragdoll", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/loader"))() end },
    { name = "Lunar X Jump", cat = "Egg • Auto Farm", desc = "Instant Steal", keyless = true, tag = "FAST",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/potassiumm/lx/main/loader.luau"))() end },
    { name = "Steal An Egg", cat = "Egg • Auto Farm", desc = "30+ Features", keyless = true, tag = "COMPLETO",
      load = function() loadstring(game:HttpGet("https://pastefy.app/pevVAjvs/raw"))() end },
    { name = "Airflow", cat = "Egg • Auto Farm", desc = "Instant Steal", keyless = true, tag = "FAST",
      load = function() loadstring(game:HttpGet("https://airflowscript.com/loader"))() end },
    { name = "SportsClub", cat = "Egg • Auto Farm", desc = "Auto Steal • Safe Tween", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://loader.sportsclub.fun/loader.luau"))() end },
    { name = "Ronix Hub", cat = "Egg • Auto Farm", desc = "Loop Steal • DNA Steal", keyless = false, tag = "KEY",
      load = function() loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/fda9babd071d6b536a745774b6bc681c.lua"))() end },

    -- EGG • KEYLESS
    { name = "Fly Script", cat = "Egg • Keyless", desc = "Fly • Speed", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://pastefy.app/kQ2m1nSa/raw"))() end },
    { name = "Oxide Hub", cat = "Egg • Keyless", desc = "Anti AC • Open Source", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/LSSOPS/OpenSource/refs/heads/main/OxideHub_Steal_An_Egg.lua"))() end },
    { name = "Axonic Hub", cat = "Egg • Keyless", desc = "Steal A Egg", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenniel123/Steal-A-Egg/refs/heads/main/Steal%20A%20Egg"))() end },
    { name = "Axurs Games", cat = "Egg • Keyless", desc = "Speed Bypass • ESP", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XE3Scripts/Axur-sGamesHub/refs/heads/main/StealAnEgg"))() end },
    { name = "Genesis Hub", cat = "Egg • Keyless", desc = "Auto-Steal simples", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/5946add9ab91f1e04cb005346a8b1968.lua"))() end },

    -- FRUIT • DESTAQUES
    { name = "Redz Hub", cat = "Fruit • Destaques", desc = "Auto Farm • Mastery", keyless = true, tag = "TOP",
      load = function()
        local Settings = { JoinTeam = "Pirates"; Translator = true }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"))(Settings)
      end },
    { name = "Tradesmith", cat = "Fruit • Destaques", desc = "Auto Trade Bot", keyless = true, tag = "NOVO",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/robomohit/tradesmith/main/tradesmith.luau"))() end },
    { name = "Gravity Hub", cat = "Fruit • Destaques", desc = "Auto Farm • Magnet", keyless = true, tag = "TOP",
      load = function()
        getgenv().GravityHub = { Key = "", Team = "Pirates", Color = "Red", SaveSetting = false, AutoExecute = false }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/main/MainPremium.lua"))()
      end },
    { name = "Synergy X Hub", cat = "Fruit • Destaques", desc = "One Hit • Instant TP", keyless = true, tag = "OP",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/synerxkirin/synergyXhub/refs/heads/main/bloxfruits/v2"))() end },
    { name = "Quantum Onyx", cat = "Fruit • Destaques", desc = "Auto Farm • ESP • PvP", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))() end },
    { name = "Void Hub", cat = "Fruit • Destaques", desc = "Auto Bounty • Kill Aura", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/VoidDeveloper67/Void-Hub/refs/heads/main/VoidHub.lua", true))() end },
    { name = "Cokka Hub", cat = "Fruit • Destaques", desc = "Auto Farm W1/W2/W3", keyless = false, tag = "XENO",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ShowScript79/cokkahub/refs/heads/main/cokkahub"))() end },

    -- FRUIT • AUTO FARM
    { name = "Speed Hub X", cat = "Fruit • Auto Farm", desc = "Auto Level • Chest", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"))() end },
    { name = "Dragon Hub", cat = "Fruit • Auto Farm", desc = "Fastest Auto Level", keyless = true, tag = "KEYLESS",
      load = function()
        getgenv().team = "Pirates"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dragonhubdev/dragonwitheveryone/refs/heads/main/Main-BF.lua"))()
      end },
    { name = "HoHo Hub", cat = "Fruit • Auto Farm", desc = "Auto Quest • Zero Lag", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))() end },
    { name = "Xero Kaitun", cat = "Fruit • Auto Farm", desc = "Auto Max • Godhuman", keyless = true, tag = "FAST",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/verudous/Xero-Hub/refs/heads/main/kaitun.lua"))() end },

    -- FRUIT • PVP
    { name = "Hermanos PVP", cat = "Fruit • PVP", desc = "Silent Aim • ESP", keyless = true, tag = "PVP",
      load = function()
        getgenv().script_mode = "PVP"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hermanos-dev/hermanos-hub/refs/heads/main/Loader.lua"))()
      end },
    { name = "VXEZE Bounty", cat = "Fruit • PVP", desc = "Auto Bounty Hunt V2", keyless = true, tag = "PVP",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubAutoBounty"))() end },

    -- FRUIT • KEYLESS
    { name = "BF Keyless", cat = "Fruit • Keyless", desc = "Hub sem key", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/MeoLazy/Script/refs/heads/main/V1.lua"))() end },
    { name = "Void Fruit Farmer", cat = "Fruit • Keyless", desc = "Fruit Grabber • ESP", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://pastebin.com/raw/yVRMbsR3"))() end },
    { name = "Raito Hub", cat = "Fruit • Keyless", desc = "Blox Fruits Keyless", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Efe0626/RaitoHub/main/Script"))() end },
    { name = "Alchemy Hub", cat = "Fruit • Keyless", desc = "Blox Fruits Script", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://scripts.alchemyhub.xyz"))() end },
    { name = "Skull Hub", cat = "Fruit • Keyless", desc = "Auto Chest • Auto Fruit", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet('https://skullhub.xyz/loader.lua'))() end },
    { name = "4479 Hub", cat = "Fruit • Keyless", desc = "Auto Farm • ESP • PVP", keyless = true, tag = "KEYLESS",
      load = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/4479cantcode/4479Hub/refs/heads/main/Script.lua"))() end },
}

local CATEGORIES = {
    { name = "Egg • Destaques",  icon = "✨" },
    { name = "Egg • Auto Farm",  icon = "⚡" },
    { name = "Egg • Keyless",    icon = "🎁" },
    { name = "Fruit • Destaques",icon = "✨" },
    { name = "Fruit • Auto Farm",icon = "⚡" },
    { name = "Fruit • PVP",      icon = "⚔" },
    { name = "Fruit • Keyless",  icon = "🎁" },
}

local activeCategory = CATEGORIES[1].name
local searchQuery = ""
local Pills = {}
local Cards = {}

local function clearCards()
    for _, c in pairs(Cards) do c:Destroy() end
    Cards = {}
end

local function createCard(script)
    local Card = Instance.new("Frame")
    Card.BackgroundColor3 = COLORS.card
    Card.BorderSizePixel = 0
    Card.ZIndex = 3
    Card.Parent = CardsScroll
    table.insert(Cards, Card)
    corner(Card, 10)
    local cs = stroke(Card, COLORS.stroke, 1)

    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 3, 0, 32)
    Accent.Position = UDim2.new(0, 0, 0.5, -16)
    Accent.BackgroundColor3 = COLORS.gold
    Accent.BorderSizePixel = 0
    Accent.ZIndex = 4
    Accent.Parent = Card
    corner(Accent, UDim.new(1, 0))

    local AGrad = Instance.new("UIGradient")
    AGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.accent),
        ColorSequenceKeypoint.new(0.5, COLORS.goldBright),
        ColorSequenceKeypoint.new(1, COLORS.accent)
    })
    AGrad.Rotation = 90
    AGrad.Parent = Accent

    task.spawn(function()
        while Accent.Parent do
            AGrad.Offset = Vector2.new(0, 0)
            TweenService:Create(AGrad, TweenInfo.new(1.8), {Offset = Vector2.new(0, 1)}):Play()
            task.wait(1.8)
        end
    end)

    local Name = Instance.new("TextLabel")
    Name.Size = UDim2.new(1, -85, 0, 20)
    Name.Position = UDim2.new(0, 12, 0, 8)
    Name.BackgroundTransparency = 1
    Name.Text = script.name
    Name.TextColor3 = COLORS.text
    Name.Font = Enum.Font.GothamBold
    Name.TextSize = 12
    Name.TextXAlignment = Enum.TextXAlignment.Left
    Name.TextTruncate = Enum.TextTruncate.AtEnd
    Name.ZIndex = 4
    Name.Parent = Card

    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -85, 0, 14)
    Desc.Position = UDim2.new(0, 12, 0, 26)
    Desc.BackgroundTransparency = 1
    Desc.Text = script.desc
    Desc.TextColor3 = COLORS.subtext
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 10
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.TextTruncate = Enum.TextTruncate.AtEnd
    Desc.ZIndex = 4
    Desc.Parent = Card

    if script.keyless then
        local Badge = Instance.new("TextLabel")
        Badge.Size = UDim2.new(0, 62, 0, 14)
        Badge.Position = UDim2.new(0, 12, 1, -19)
        Badge.BackgroundColor3 = COLORS.greenDark
        Badge.Text = "✓ KEYLESS"
        Badge.TextColor3 = COLORS.green
        Badge.Font = Enum.Font.GothamBold
        Badge.TextSize = 8
        Badge.BorderSizePixel = 0
        Badge.ZIndex = 4
        Badge.Parent = Card
        corner(Badge, 5)
    end

    if script.tag then
        local Tag = Instance.new("TextLabel")
        Tag.Size = UDim2.new(0, 55, 0, 14)
        Tag.Position = UDim2.new(0, 78, 1, -19)
        Tag.BackgroundColor3 = Color3.fromRGB(65, 32, 105)
        Tag.Text = script.tag
        Tag.TextColor3 = COLORS.goldBright
        Tag.Font = Enum.Font.GothamBold
        Tag.TextSize = 8
        Tag.BorderSizePixel = 0
        Tag.ZIndex = 4
        Tag.Parent = Card
        corner(Tag, 5)
    end

    local ExecHolder = Instance.new("Frame")
    ExecHolder.Size = UDim2.new(0, 70, 0, 28)
    ExecHolder.Position = UDim2.new(1, -78, 0.5, -14)
    ExecHolder.BackgroundColor3 = COLORS.accent
    ExecHolder.BorderSizePixel = 0
    ExecHolder.ZIndex = 4
    ExecHolder.ClipsDescendants = true
    ExecHolder.Parent = Card
    corner(ExecHolder, 8)

    local EG = Instance.new("UIGradient")
    EG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.goldBright),
        ColorSequenceKeypoint.new(0.5, COLORS.accent),
        ColorSequenceKeypoint.new(1, COLORS.accentDark)
    })
    EG.Rotation = 0
    EG.Parent = ExecHolder

    task.spawn(function()
        while EG.Parent do
            EG.Rotation = 0
            TweenService:Create(EG, TweenInfo.new(2.2), {Rotation = 360}):Play()
            task.wait(2.2)
        end
    end)

    local Exec = Instance.new("TextButton")
    Exec.Size = UDim2.new(1, 0, 1, 0)
    Exec.BackgroundTransparency = 1
    Exec.Text = "EXEC"
    Exec.TextColor3 = Color3.fromRGB(255, 255, 255)
    Exec.Font = Enum.Font.GothamBold
    Exec.TextSize = 11
    Exec.BorderSizePixel = 0
    Exec.AutoButtonColor = false
    Exec.ZIndex = 5
    Exec.Parent = ExecHolder

    Card.MouseEnter:Connect(function()
        TweenService:Create(Card, TweenInfo.new(0.18), {
            BackgroundColor3 = COLORS.cardHover,
            Size = UDim2.new(1, 3, 1, 3),
            Position = UDim2.new(0, -1.5, 0, -1.5)
        }):Play()
        TweenService:Create(cs, TweenInfo.new(0.18), {Color = COLORS.gold, Thickness = 1.5}):Play()

        local tip = Instance.new("TextLabel")
        tip.Size = UDim2.new(0, 240, 0, 50)
        tip.Position = UDim2.new(0, 0, 1, 4)
        tip.BackgroundColor3 = COLORS.panel
        tip.Text = script.name .. "\n" .. script.desc
        tip.TextColor3 = COLORS.text
        tip.Font = Enum.Font.GothamSemibold
        tip.TextSize = 10
        tip.TextWrapped = true
        tip.BorderSizePixel = 0
        tip.ZIndex = 200
        tip.Name = "Tooltip_" .. script.name
        tip.Parent = Card
        corner(tip, 6)
        stroke(tip, COLORS.gold, 1)

        tip.BackgroundTransparency = 1
        tip.TextTransparency = 1
        TweenService:Create(tip, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    end)
    Card.MouseLeave:Connect(function()
        TweenService:Create(Card, TweenInfo.new(0.18), {
            BackgroundColor3 = COLORS.card,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        TweenService:Create(cs, TweenInfo.new(0.18), {Color = COLORS.stroke, Thickness = 1}):Play()

        local tip = Card:FindFirstChild("Tooltip_" .. script.name)
        if tip then
            TweenService:Create(tip, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            task.delay(0.2, function()
                if tip and tip.Parent then tip:Destroy() end
            end)
        end
    end)

    Exec.MouseButton1Click:Connect(function()
        playSound("6042053626", 0.4)

        local oldText = Exec.Text
        Exec.Text = "⏳"
        task.spawn(function()
            local frames = {"⏳", "⌛", "⏳", "⌛"}
            local i = 1
            while Exec.Text ~= "OK!" and Exec.Text ~= "✗" and Exec.Parent do
                Exec.Text = frames[i]
                i = i % #frames + 1
                task.wait(0.15)
            end
        end)

        for i = 1, 2 do
            task.spawn(function()
                task.wait((i - 1) * 0.12)
                local ripple = Instance.new("Frame")
                ripple.Size = UDim2.new(0, 0, 0, 0)
                ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                ripple.BackgroundColor3 = i == 1 and COLORS.white or COLORS.goldBright
                ripple.BackgroundTransparency = 0.4
                ripple.BorderSizePixel = 0
                ripple.ZIndex = 6
                ripple.Parent = ExecHolder
                corner(ripple, UDim.new(1, 0))
                TweenService:Create(ripple, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, 240, 0, 240),
                    BackgroundTransparency = 1
                }):Play()
                Debris:AddItem(ripple, 0.7)
            end)
        end

        StatusText.Text = "Executando: " .. script.name
        StatusText.TextColor3 = COLORS.orange

        task.spawn(function()
            local ok, err = pcall(script.load)
            if ok then
                Exec.Text = "OK!"
                StatusText.Text = "✓ " .. script.name
                StatusText.TextColor3 = COLORS.green
            else
                Exec.Text = "✗"
                StatusText.Text = "✗ Falha: " .. tostring(err):sub(1, 40)
                StatusText.TextColor3 = COLORS.red
            end
            task.wait(1.5)
            Exec.Text = oldText
            task.wait(2)
            StatusText.Text = "Pronto  •  VICTTOR HUB"
            StatusText.TextColor3 = COLORS.goldBright
        end)
    end)

    return Card
end

local function refreshCards()
    clearCards()
    local count = 0
    for _, s in ipairs(SCRIPTS) do
        local matchCat = (s.cat == activeCategory)
        local matchSearch = (searchQuery == "" or s.name:lower():find(searchQuery:lower(), 1, true) or s.desc:lower():find(searchQuery:lower(), 1, true))
        if matchCat and matchSearch then
            local card = createCard(s)
            if card then
                card.BackgroundTransparency = 1
                card.Position = UDim2.new(0.05, 0, 0, 0)
                TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0,
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play()
                task.wait(0.03)
            end
            count = count + 1
        end
    end
    ResultCount.Text = count .. " script(s) em " .. activeCategory
end

local function setActivePill(catName)
    if activeCategory == catName then return end
    activeCategory = catName
    
    for name, data in pairs(Pills) do
        local p = data.button
        if name == catName then
            TweenService:Create(p, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.accent}):Play()
            TweenService:Create(data.stroke, TweenInfo.new(0.2), {Color = COLORS.goldBright, Thickness = 1.5}):Play()
            p.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            TweenService:Create(p, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.card}):Play()
            TweenService:Create(data.stroke, TweenInfo.new(0.2), {Color = COLORS.stroke, Thickness = 1}):Play()
            p.TextColor3 = COLORS.subtext
        end
    end
    refreshCards()
end

for _, cat in ipairs(CATEGORIES) do
    local isActive = (cat.name == activeCategory)
    
    local catCount = 0
    for _, s in ipairs(SCRIPTS) do
        if s.cat == cat.name then catCount = catCount + 1 end
    end
    
    local Pill = Instance.new("TextButton")
    Pill.Size = UDim2.new(0, 0, 1, 0)
    Pill.AutomaticSize = Enum.AutomaticSize.X
    Pill.BackgroundColor3 = isActive and COLORS.accent or COLORS.card
    Pill.Text = "  " .. cat.icon .. "  " .. cat.name .. "  (" .. catCount .. ")  "
    Pill.TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or COLORS.subtext
    Pill.Font = Enum.Font.GothamBold
    Pill.TextSize = 11
    Pill.BorderSizePixel = 0
    Pill.AutoButtonColor = false
    Pill.ZIndex = 3
    Pill.Parent = PillsScroll
    corner(Pill, 10)
    local ps = stroke(Pill, isActive and COLORS.goldBright or COLORS.stroke, isActive and 1.5 or 1)

    Pills[cat.name] = { button = Pill, stroke = ps }

    Pill.MouseButton1Click:Connect(function()
        playSound("6042053626", 0.3)
        setActivePill(cat.name)
    end)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    searchQuery = SearchBox.Text
    refreshCards()
end)

-- Arrastar
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        MainShadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X - 12, startPos.Y.Scale, startPos.Y.Offset + delta.Y + 10)
        MainShadow2.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X - 22, startPos.Y.Scale, startPos.Y.Offset + delta.Y + 16)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local function openPanel()
    Main.Visible = true
    MainShadow.Visible = true
    MainShadow2.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainShadow.Size = UDim2.new(0, 0, 0, 0)
    MainShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainShadow2.Size = UDim2.new(0, 0, 0, 0)
    MainShadow2.Position = UDim2.new(0.5, 0, 0.5, 0)
    local tw = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(Main, tw, {Size = UDim2.new(0, WIN_W, 0, WIN_H), Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)}):Play()
    TweenService:Create(MainShadow, tw, {Size = UDim2.new(0, WIN_W + 24, 0, WIN_H + 24), Position = UDim2.new(0.5, -WIN_W/2 - 12, 0.5, -WIN_H/2 + 10)}):Play()
    TweenService:Create(MainShadow2, tw, {Size = UDim2.new(0, WIN_W + 44, 0, WIN_H + 44), Position = UDim2.new(0.5, -WIN_W/2 - 22, 0.5, -WIN_H/2 + 16)}):Play()
end

local function closePanel()
    local tw = TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(Main, tw, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    TweenService:Create(MainShadow, tw, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    TweenService:Create(MainShadow2, tw, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    task.delay(0.28, function()
        Main.Visible = false
        MainShadow.Visible = false
        MainShadow2.Visible = false
    end)
end

OpenBtn.MouseButton1Click:Connect(function()
    if Main.Visible then closePanel() else openPanel() end
end)
CloseBtn.MouseButton1Click:Connect(closePanel)

setActivePill(CATEGORIES[1].name)
task.wait(0.15)
openPanel()

print("[VICTTOR HUB] Carregado com sucesso!")
