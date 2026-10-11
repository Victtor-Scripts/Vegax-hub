--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║              VEGAX HUB V33 PREMIUM                               ║
    ║              Sistema de Autenticação + Anti-Leak                 ║
    ╚══════════════════════════════════════════════════════════════════╝
--]]

-- ⚙️ CONFIGURAÇÕES DO VENDEDOR
local CONFIG = {
    API_URL = "https://SEU_SERVIDOR.replit.app/api",  -- ⬅️ troque pela sua API
    PRODUCT = "VEGAX HUB PREMIUM",
    VERSION = "V33P",
    REQUIRE_KEY = true,
    DISCORD = "https://discord.gg/GUMcHjHgTp",
    LOGO = "rbxassetid://96373255363269",
    HUB_NAME = "VEGAX HUB",
}

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local SS=game:GetService("SoundService")
local RS=game:GetService("RunService")
local HttpService=game:GetService("HttpService")
local TeleportService=game:GetService("TeleportService")
local CoreGui=(gethui and gethui())or(protect_gui and protect_gui())or game:GetService("CoreGui")

local C={
    Bg=Color3.fromRGB(10,8,6), Panel=Color3.fromRGB(22,18,12), PanelLight=Color3.fromRGB(35,28,18),
    Primary=Color3.fromRGB(255,215,90), PrimaryDark=Color3.fromRGB(200,160,50),
    Accent=Color3.fromRGB(255,240,150), Text=Color3.fromRGB(245,240,230),
    TextDim=Color3.fromRGB(180,160,120), Success=Color3.fromRGB(120,255,180),
    Danger=Color3.fromRGB(255,90,120), Gold=Color3.fromRGB(255,220,120),
    Purple=Color3.fromRGB(160,120,255), Discord=Color3.fromRGB(88,101,242),
}
local F={Title=Enum.Font.GothamBold,Body=Enum.Font.Gotham}
local SND="rbxassetid://6042053626"
local AMB="rbxassetid://9046282862"
local ADMIN_KEY = "VEGAX-ADMIN-MASTER-KEY"

local function sound(id,v,p)
    pcall(function()
        local s=Instance.new("Sound")
        s.SoundId=id or SND; s.Volume=v or .5; s.PlaybackSpeed=p or 1
        s.Parent=SS; s:Play()
        task.delay(2,function() if s then s:Destroy() end end)
    end)
end

local function corner(i,r) local c=Instance.new("UICorner") c.CornerRadius=r or UDim.new(0,12) c.Parent=i end
local function shadow(i,t)
    local s=Instance.new("ImageLabel")
    s.Name="Shadow"; s.BackgroundTransparency=1
    s.Image="rbxassetid://6015897843"; s.ImageColor3=Color3.fromRGB(0,0,0)
    s.ImageTransparency=t or .5; s.ScaleType=Enum.ScaleType.Slice
    s.SliceCenter=Rect.new(49,49,450,450); s.ZIndex=i.ZIndex-1
    s.Size=UDim2.new(1,20,1,20); s.Position=UDim2.new(0,-10,0,-10); s.Parent=i
end
local function tw(i,t,p,st,d)
    local x=TS:Create(i,TweenInfo.new(t or .2,st or Enum.EasingStyle.Quart,d or Enum.EasingDirection.Out),p)
    x:Play(); return x
end

--══════════════════════════════════════════════════════════════════
-- 🔐 SISTEMA DE AUTENTICAÇÃO
--══════════════════════════════════════════════════════════════════

local Auth = { Key=nil, HWID=nil, Tier="premium", Expires=nil, Validated=false }

function Auth.getHWID()
    local ok, hwid = pcall(function()
        if gethwid then return gethwid() end
        if syn and syn.get_hwid then return syn.get_hwid() end
        if get_hwid then return get_hwid() end
    end)
    if ok and hwid then return tostring(hwid) end
    local lp = Players.LocalPlayer
    return tostring(lp.UserId) .. "_" .. tostring(game.PlaceId)
end

function Auth.saveKey(key)
    pcall(function()
        if writefile and isfolder and not isfolder("VEGAX_HUB") then makefolder("VEGAX_HUB") end
        if writefile then writefile("VEGAX_HUB/key.txt", key) end
    end)
end

function Auth.loadKey()
    local ok, key = pcall(function()
        if readfile and isfile and isfile("VEGAX_HUB/key.txt") then return readfile("VEGAX_HUB/key.txt") end
    end)
    if ok and key and key ~= "" then Auth.Key = key return key end
    return nil
end

function Auth.validate(key)
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if not req then return false, "Sem suporte HTTP" end
    local hwid = Auth.getHWID()
    Auth.HWID = hwid
    local ok, result = pcall(function()
        local res = req({
            Url = CONFIG.API_URL .. "/validate",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ key=key, hwid=hwid, product=CONFIG.PRODUCT, version=CONFIG.VERSION })
        })
        return HttpService:JSONDecode(res.Body)
    end)
    if not ok or not result then return false, "Falha na conexão" end
    if result.valid then
        Auth.Key = key
        Auth.Tier = result.tier or "premium"
        Auth.Expires = result.expires
        Auth.Validated = true
        Auth.saveKey(key)
        return true, "OK"
    end
    return false, result.error or "Key inválida"
end

--══════════════════════════════════════════════════════════════════
-- 📜 SCRIPTS
--══════════════════════════════════════════════════════════════════

local CATS={
{Name="Egg • Destaques",Icon="🌟",Scripts={
{Name="Chilli Hub",Desc="Auto Steal • Target Areas",Url="https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua",Color=Color3.fromRGB(255,90,60)},
{Name="Clouthub Hub",Desc="ESP • Auto Grab",Url="https://raw.githubusercontent.com/ClouthubOnTop/Loader/main/main.lua",Color=Color3.fromRGB(255,170,60)},
{Name="Kira Hub",Desc="Auto Steal • Auto Hatch",Url="https://raw.githubusercontent.com/LSSOPS/OpenSource/refs/heads/main/KiraHub_Steal_An_Egg.lua",Color=Color3.fromRGB(239,68,68)},
{Name="Ouroboros Hub",Desc="Instant Steal • ESP",Url="https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua",Color=Color3.fromRGB(74,222,128)},
{Name="CRZHub",Desc="Egg Prediction • Fly",Url="https://flowauth.net/v1/loaders/3c4e87ed34813171b0f8d53a108a7d88.lua",Color=Color3.fromRGB(255,215,90)},
{Name="Miranda Hub",Desc="Fast Steal • Noclip",Url="https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/stealaegg",Color=Color3.fromRGB(74,222,128)},
{Name="Neva Hub",Desc="Auto Farm • Egg Selection",Url="https://raw.githubusercontent.com/VEZ2/NEVAHUB/main/2",Color=Color3.fromRGB(88,200,255)}}},
{Name="Egg • Auto Farm",Icon="⚡",Scripts={
{Name="Decode Hub",Desc="Auto Steal • Treadmill",Url="https://raw.githubusercontent.com/ItzYumi/Decode/refs/heads/main/DE%3ACODE.lua",Color=Color3.fromRGB(88,200,255)},
{Name="ON Hub",Desc="Auto Farm • Fast Grab",Url="https://raw.githubusercontent.com/davizin713/ONhub/refs/heads/main/script.lua",Color=Color3.fromRGB(74,222,128)},
{Name="Toolbox Hub",Desc="Bypass • Respawn",Url="https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/loader",Color=Color3.fromRGB(255,190,60)},
{Name="YOKUDO HUB",Desc="Farming • Combat",Url="https://raw.githubusercontent.com/betdoyvaka/stealanegg/main/Loader.lua",Color=Color3.fromRGB(255,170,60)},
{Name="Goha Hub",Desc="Auto Hatch • Auto Fuse",Url="https://api.goha.dev/loader",Color=Color3.fromRGB(255,215,90)},
{Name="UB Hub",Desc="Auto Place • Auto Hatch",Url="https://raw.githubusercontent.com/TeamUBHub/UBLoader/refs/heads/main/index/Key.lua",Color=Color3.fromRGB(88,200,255)},
{Name="Cyrus Hub",Desc="Steal Modes • Teleport",Url="https://raw.githubusercontent.com/CyrusOffc/scriptcyrus/refs/heads/main/loader",Color=Color3.fromRGB(74,222,128)},
{Name="Pig Hub",Desc="Auto Sell • Egg ESP",Url="https://raw.githubusercontent.com/mopsscript7-gif/steal-an-egg/refs/heads/main/script.lua",Color=Color3.fromRGB(255,190,60)},
{Name="UlamHUB",Desc="Instant Steal • God Mode",Url="https://api.jnkie.com/api/v1/luascripts/public/4fa5547b587b1f3110ad121fd9650a8256ed00c0c73ae49ecf07d2130a206125/download",Color=Color3.fromRGB(239,68,68)}}},
{Name="Egg • Keyless",Icon="🎁",Scripts={
{Name="Valinc Hub",Desc="Auto Steal • Auto Hatch",Url="https://api.valincsyndicate.com/v1/releases/5502cba03703f4a3628d522d396b80d8.lua",Color=Color3.fromRGB(255,170,60)},
{Name="Zeroin Hub",Desc="Instant Steal • Bosses",Url="https://zeroinhub.com/api/script",Color=Color3.fromRGB(88,200,255)},
{Name="FoxName Hub",Desc="Auto Steal",Url="https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Fn-stealanegg.lua",Color=Color3.fromRGB(74,222,128)},
{Name="Oxide Hub",Desc="Auto Farm • Instant Steal",Url="https://pastefy.app/aIzaPmW9/raw",Color=Color3.fromRGB(255,190,60)},
{Name="Zero Point",Desc="Instant Steal • Anti-Hit",Url="https://raw.githubusercontent.com/JaxRol/ZeroPoint/refs/heads/main/KeySystem",Color=Color3.fromRGB(239,68,68)},
{Name="Blyxo Hub",Desc="Instant Steal • Auto Events",Url="https://flowauth.net/v1/loaders/69d3463240384f3a73fbe32c178093a2.lua",Color=Color3.fromRGB(255,215,90)},
{Name="BK Hub",Desc="Auto Steal • Rift & Boss",Url="https://api.luarmor.net/files/v4/loaders/9ee4edde227ac85f50872bf9e4226508.lua",Color=Color3.fromRGB(255,170,60)},
{Name="Tsuo Hub",Desc="Fast Steal • Angel/Demon",Url="https://raw.githubusercontent.com/Tsuo7/TsuoHub/main/stealanegg",Color=Color3.fromRGB(88,200,255)},
{Name="BigFroot",Desc="Auto Steal • Auto Collect",Url="https://raw.githubusercontent.com/hanniii1/Loader/main/Loader.lua",Color=Color3.fromRGB(74,222,128)},
{Name="Airflow",Desc="Instant Steal • Ultra-fast",Url="https://airflowscript.com/loader",Color=Color3.fromRGB(255,190,60)},
{Name="Monarch Hub",Desc="Fly • ESP • Egg Sniper",Url="https://raw.githubusercontent.com/nobuxy/monarch.win/refs/heads/main/Monarch.lua",Color=Color3.fromRGB(88,200,255)},
{Name="Solix Hub",Desc="Auto Farm • Godmode",Url="https://solixhub.com/loader",Color=Color3.fromRGB(74,222,128)},
{Name="Jacob Helper",Desc="Auto Steal Best Egg",Url="https://gist.githubusercontent.com/asdasdasd1214/ec9c608ea0bf456c0f7e70db69b8f6e2/raw/gistfile1.txt",Color=Color3.fromRGB(255,170,60)}}},
{Name="BF • Auto Farm",Icon="🏴‍☠️",Scripts={
{Name="Cokka Hub",Desc="Auto Farm • Boss • Raids",Url="https://raw.githubusercontent.com/ShowScript79/cokkahub/refs/heads/main/cokkahub",Color=Color3.fromRGB(255,170,60)},
{Name="Gravity Hub",Desc="Auto Farm • Magnet",Url="https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/main/MainPremium.lua",Color=Color3.fromRGB(88,200,255)},
{Name="Quantum Onyx",Desc="Auto Farm • PvP",Url="https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua",Color=Color3.fromRGB(239,68,68)},
{Name="Void Hub",Desc="Auto Bounty • Sniper",Url="https://raw.githubusercontent.com/VoidDeveloper67/Void-Hub/refs/heads/main/VoidHub.lua",Color=Color3.fromRGB(88,200,255)},
{Name="Neru Hub",Desc="Auto Farm • Sniper",Url="https://raw.githubusercontent.com/Kenniel123/BloxFruits/refs/heads/main/BloxFruits",Color=Color3.fromRGB(255,170,60)},
{Name="Banana Hub",Desc="Leve • Celular fraco",Url="https://raw.githubusercontent.com/kimprobloxdz/banana-free/refs/heads/main/protected_5609200582002947.lua.txt",Color=Color3.fromRGB(255,215,90)},
{Name="RedZ Hub",Desc="Auto Farm • Mastery",Url="https://raw.githubusercontent.com/LuaCrack/Min/refs/heads/main/MinXt2Eng",Color=Color3.fromRGB(88,200,255)},
{Name="Raito Hub",Desc="PvP Premium",Url="https://raw.githubusercontent.com/Efe0626/RaitoHub/main/Script",Color=Color3.fromRGB(239,68,68)},
{Name="Hermanos",Desc="PvP • Silent Aim",Url="https://raw.githubusercontent.com/hermanos-dev/hermanos-hub/refs/heads/main/Loader.lua",Color=Color3.fromRGB(255,170,60)},
{Name="Nix Hub",Desc="Auto Level • Raid",Url="https://raw.githubusercontent.com/NYX8HUB/premium/refs/heads/main/script",Color=Color3.fromRGB(74,222,128)},
{Name="Annie Hub",Desc="All-in-One",Url="https://raw.githubusercontent.com/1st-Mars/Annie/main/1st.lua",Color=Color3.fromRGB(255,190,60)},
{Name="Thanh Hub",Desc="Auto Farm Fast",Url="https://raw.githubusercontent.com/thantzy/thanhub/refs/heads/main/thanv1",Color=Color3.fromRGB(255,170,60)},
{Name="BeanHub",Desc="Auto Farm Multi-Sea",Url="https://raw.githubusercontent.com/SoyElPekka/BeanHub/main/LoadingScreen",Color=Color3.fromRGB(74,222,128)},
{Name="NOKA V3",Desc="Skin Changer",Url="https://rawscripts.net/raw/RIVALS-Noks-unlock-all-205613",Color=Color3.fromRGB(255,215,90)},
{Name="Rasputin",Desc="Auto Farm • ESP",Url="https://raw.githubusercontent.com/rasputin-hub/BloxFruits/main/loader.lua",Color=Color3.fromRGB(180,120,255)}}},
{Name="Movimento",Icon="🚀",Scripts={
{Name="Fly Script",Desc="Fly • Speed",Url="https://pastefy.app/kQ2m1nSa/raw",Color=Color3.fromRGB(255,170,60)}}},
{Name="Server Hop",Icon="🌐",Scripts={
{Name="Hop Universal",Desc="Pula servidor",Url="https://raw.githubusercontent.com/Prox-Dev/ServerHop/main/ServerHop.lua",Color=Color3.fromRGB(88,200,255)},
{Name="Hop Rápido",Desc="Filtro região",Url="https://pastefy.app/8PqLLNV7/raw",Color=Color3.fromRGB(255,190,60)}}},
{Name="Premium 🔒",Icon="💎",Scripts={
{Name="Premium Script 1",Desc="Exclusivo PREMIUM",Url="https://SEU_SERVIDOR/premium1.lua",Color=Color3.fromRGB(255,215,90),Premium=true},
{Name="Premium Script 2",Desc="Exclusivo PREMIUM",Url="https://SEU_SERVIDOR/premium2.lua",Color=Color3.fromRGB(255,215,90),Premium=true}}}}

local S={UI={},Loading=false,CurrentTab=1,Fav={},Filter="ALL",Cache={},Sound=true,Ambient=false,Authenticated=not CONFIG.REQUIRE_KEY,IsAdmin=false}

--══════════════════════════════════════════════════════════════════
-- 🔐 TELA DE LOGIN
--══════════════════════════════════════════════════════════════════

local LoginUI = {}

function LoginUI.show()
    local sg = Instance.new("ScreenGui")
    sg.Name = "VegaxLogin"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 9999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Enabled = true
    sg.Parent = CoreGui
    LoginUI.Gui = sg
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.4
    bg.BorderSizePixel = 0
    bg.Active = false
    bg.ZIndex = 1
    bg.Parent = sg
    
    local box = Instance.new("Frame")
    box.Name = "LoginBox"
    box.Size = UDim2.new(0, 420, 0, 360)
    box.Position = UDim2.new(0.5, -210, 0.5, -180)
    box.BackgroundColor3 = C.Panel
    box.BorderSizePixel = 0
    box.Active = true
    box.ZIndex = 10
    box.Parent = sg
    corner(box, UDim.new(0, 20))
    shadow(box, 0.3)
    
    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 2
    boxStroke.Color = C.Primary
    boxStroke.Transparency = 0.4
    boxStroke.Parent = box
    
    task.spawn(function()
        while box.Parent do
            tw(boxStroke, 1.5, { Transparency = 0.7 })
            task.wait(1.5)
            tw(boxStroke, 1.5, { Transparency = 0.2 })
            task.wait(1.5)
        end
    end)
    
    local logoF = Instance.new("Frame")
    logoF.Size = UDim2.new(0, 60, 0, 60)
    logoF.Position = UDim2.new(0.5, -30, 0, 20)
    logoF.BackgroundTransparency = 1
    logoF.ZIndex = 11
    logoF.Parent = box
    
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.BackgroundTransparency = 1
    logo.Image = CONFIG.LOGO
    logo.ScaleType = Enum.ScaleType.Fit
    logo.ZIndex = 11
    logo.Parent = logoF
    
    local logoGlow = Instance.new("ImageLabel")
    logoGlow.Size = UDim2.new(1, 20, 1, 20)
    logoGlow.Position = UDim2.new(0, -10, 0, -10)
    logoGlow.BackgroundTransparency = 1
    logoGlow.Image = CONFIG.LOGO
    logoGlow.ImageColor3 = C.Primary
    logoGlow.ImageTransparency = 0.5
    logoGlow.ZIndex = 10
    logoGlow.Parent = logoF
    
    task.spawn(function()
        while logoGlow.Parent do
            tw(logoGlow, 1, { ImageTransparency = 0.7 })
            task.wait(1)
            tw(logoGlow, 1, { ImageTransparency = 0.3 })
            task.wait(1)
        end
    end)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 24)
    title.Position = UDim2.new(0, 0, 0, 90)
    title.BackgroundTransparency = 1
    title.Text = "🔐 VEGAX HUB PREMIUM"
    title.TextColor3 = C.Primary
    title.Font = F.Title
    title.TextSize = 20
    title.ZIndex = 11
    title.Parent = box
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 18)
    sub.Position = UDim2.new(0, 0, 0, 118)
    sub.BackgroundTransparency = 1
    sub.Text = "Toque no campo e digite sua key"
    sub.TextColor3 = C.TextDim
    sub.Font = F.Body
    sub.TextSize = 12
    sub.ZIndex = 11
    sub.Parent = box
    
    local inputF = Instance.new("Frame")
    inputF.Size = UDim2.new(1, -40, 0, 50)
    inputF.Position = UDim2.new(0, 20, 0, 155)
    inputF.BackgroundColor3 = C.PanelLight
    inputF.BorderSizePixel = 0
    inputF.Active = true
    inputF.ZIndex = 11
    inputF.Parent = box
    corner(inputF, UDim.new(0, 10))
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Thickness = 1
    inputStroke.Color = C.Primary
    inputStroke.Transparency = 0.6
    inputStroke.Parent = inputF
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 1, 0)
    input.Position = UDim2.new(0, 10, 0, 0)
    input.BackgroundTransparency = 1
    input.Text = ""
    input.PlaceholderText = "VEGAX-XXXX-XXXX-XXXX"
    input.PlaceholderColor3 = C.TextDim
    input.TextColor3 = C.Text
    input.Font = F.Num
    input.TextSize = 14
    input.ClearTextOnFocus = false
    input.TextEditable = true
    input.MultiLine = false
    input.ZIndex = 12
    input.Parent = inputF
    
    task.wait(0.4)
    pcall(function() input:CaptureFocus() end)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 46)
    btn.Position = UDim2.new(0, 20, 0, 220)
    btn.BackgroundColor3 = C.Primary
    btn.Text = "ATIVAR"
    btn.TextColor3 = Color3.fromRGB(30, 20, 10)
    btn.Font = F.Title
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Active = true
    btn.ZIndex = 11
    btn.Parent = box
    corner(btn, UDim.new(0, 10))
    
    btn.MouseEnter:Connect(function() tw(btn, 0.15, { BackgroundColor3 = C.PrimaryDark }) end)
    btn.MouseLeave:Connect(function() tw(btn, 0.15, { BackgroundColor3 = C.Primary }) end)
    
    local adminBtn = Instance.new("TextButton")
    adminBtn.Size = UDim2.new(1, -40, 0, 34)
    adminBtn.Position = UDim2.new(0, 20, 0, 275)
    adminBtn.BackgroundColor3 = C.PanelLight
    adminBtn.Text = "👑 Entrar como Admin"
    adminBtn.TextColor3 = C.Primary
    adminBtn.Font = F.Title
    adminBtn.TextSize = 11
    adminBtn.BorderSizePixel = 0
    adminBtn.AutoButtonColor = false
    adminBtn.Active = true
    adminBtn.ZIndex = 11
    adminBtn.Parent = box
    corner(adminBtn, UDim.new(0, 8))
    
    adminBtn.MouseEnter:Connect(function() tw(adminBtn, 0.15, { BackgroundColor3 = C.Panel }) end)
    adminBtn.MouseLeave:Connect(function() tw(adminBtn, 0.15, { BackgroundColor3 = C.PanelLight }) end)
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -40, 0, 20)
    status.Position = UDim2.new(0, 20, 0, 315)
    status.BackgroundTransparency = 1
    status.Text = ""
    status.TextColor3 = C.TextDim
    status.Font = F.Body
    status.TextSize = 11
    status.ZIndex = 11
    status.Parent = box
    
    local disc = Instance.new("TextLabel")
    disc.Size = UDim2.new(1, -40, 0, 16)
    disc.Position = UDim2.new(0, 20, 1, -22)
    disc.BackgroundTransparency = 1
    disc.Text = "💬 discord.gg/GUMcHjHgTp"
    disc.TextColor3 = C.Discord
    disc.Font = F.Body
    disc.TextSize = 10
    disc.ZIndex = 11
    disc.Parent = box
    
    box.Size = UDim2.new(0, 0, 0, 0)
    box.Position = UDim2.new(0.5, 0, 0.5, 0)
    tw(box, 0.4, { Size = UDim2.new(0, 420, 0, 360), Position = UDim2.new(0.5, -210, 0.5, -180) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    local function tryActivate()
        local key = input.Text:gsub("%s+", "")
        if key == "" then
            status.Text = "❌ Insira uma key válida"
            status.TextColor3 = C.Danger
            sound(SND, 0.5, 0.7)
            return
        end
        if key == ADMIN_KEY then
            status.Text = "👑 Admin! Entrando..."
            status.TextColor3 = C.Success
            sound(SND, 0.6, 1.4)
            task.wait(0.8)
            sg:Destroy()
            S.Authenticated = true
            S.IsAdmin = true
            init()
            return
        end
        status.Text = "⏳ Validando..."
        status.TextColor3 = C.Accent
        sound(SND, 0.5, 1.1)
        task.spawn(function()
            local ok, err = Auth.validate(key)
            if ok then
                status.Text = "✅ Key válida!"
                status.TextColor3 = C.Success
                sound(SND, 0.6, 1.3)
                task.wait(1)
                sg:Destroy()
                S.Authenticated = true
                init()
            else
                status.Text = "❌ " .. tostring(err)
                status.TextColor3 = C.Danger
                sound(SND, 0.5, 0.7)
                local op = inputF.Position
                for i = 1, 3 do
                    tw(inputF, 0.05, { Position = UDim2.new(0, op.X.Offset + 5, 0, op.Y.Offset) })
                    task.wait(0.05)
                    tw(inputF, 0.05, { Position = UDim2.new(0, op.X.Offset - 5, 0, op.Y.Offset) })
                    task.wait(0.05)
                end
                tw(inputF, 0.1, { Position = op })
            end
        end)
    end
    
    btn.MouseButton1Click:Connect(tryActivate)
    adminBtn.MouseButton1Click:Connect(function()
        sound(SND, 0.6, 1.4)
        status.Text = "👑 Entrando como Admin..."
        status.TextColor3 = C.Success
        task.wait(0.6)
        sg:Destroy()
        S.Authenticated = true
        S.IsAdmin = true
        init()
    end)
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then tryActivate() end
    end)
end

--══════════════════════════════════════════════════════════════════
-- 🛡️ ANTI-LEAK
--══════════════════════════════════════════════════════════════════

local LeakSystem = { Detected = false, Count = 0 }

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.PrintScreen then
        LeakSystem.Detected = true
        LeakSystem.Count = LeakSystem.Count + 1
        warn("[VEGAX PREMIUM] ⚠️ Screenshot detectado!")
        if S.UI and S.UI.Gui then S.UI.Gui.Enabled = false end
        pcall(function()
            local sg = Instance.new("ScreenGui")
            sg.Name = "LeakWarning"
            sg.ResetOnSpawn = false
            sg.Parent = CoreGui
            local b = Instance.new("TextLabel")
            b.Size = UDim2.new(0, 400, 0, 50)
            b.Position = UDim2.new(0.5, -200, 0.1, 0)
            b.BackgroundColor3 = C.Danger
            b.Text = "⚠️ Screenshot detectado! Painel fechado."
            b.TextColor3 = C.Text
            b.Font = F.Title
            b.TextSize = 14
            b.BorderSizePixel = 0
            b.Parent = sg
            corner(b, UDim.new(0, 10))
            shadow(b, 0.3)
            task.wait(3)
            sg:Destroy()
        end)
    end
end)

--══════════════════════════════════════════════════════════════════
-- ⚠️ ANTI-TAMPER
--══════════════════════════════════════════════════════════════════

local function verifyIntegrity()
    local checks = {
        Auth.validate ~= nil,
        Auth.getHWID ~= nil,
        S.UI ~= nil,
        CONFIG.API_URL ~= nil,
    }
    for _, check in ipairs(checks) do
        if not check then
            warn("[VEGAX PREMIUM] 🚨 Integridade comprometida!")
            return false
        end
    end
    return true
end

--══════════════════════════════════════════════════════════════════
-- 💎 SELO PREMIUM
--══════════════════════════════════════════════════════════════════

local function addPremiumBadge(header)
    local badge = Instance.new("TextLabel")
    badge.Size = UDim2.new(0, 78, 0, 18)
    badge.Position = UDim2.new(0, 178, 0, 9)
    badge.BackgroundColor3 = C.Primary
    badge.Text = "💎 PREMIUM"
    badge.TextColor3 = Color3.fromRGB(30, 20, 10)
    badge.Font = F.Title
    badge.TextSize = 9
    badge.BorderSizePixel = 0
    badge.ZIndex = 5
    badge.Parent = header
    corner(badge, UDim.new(0, 4))
    task.spawn(function()
        while badge.Parent do
            tw(badge, 1.2, { BackgroundColor3 = C.Gold, Size = UDim2.new(0, 82, 0, 20) }, Enum.EasingStyle.Sine)
            task.wait(1.2)
            tw(badge, 1.2, { BackgroundColor3 = C.Primary, Size = UDim2.new(0, 78, 0, 18) }, Enum.EasingStyle.Sine)
            task.wait(1.2)
        end
    end)
    if S.IsAdmin then
        badge.Text = "👑 ADMIN"
        badge.BackgroundColor3 = C.Danger
    end
end

--══════════════════════════════════════════════════════════════════
-- 🔊 AMBIENTE + TOAST
--══════════════════════════════════════════════════════════════════

local ambientSound=nil
local function toggleAmbient()
    if S.Ambient then
        if ambientSound then ambientSound:Stop() ambientSound:Destroy() ambientSound=nil end
        S.Ambient=false
    else
        pcall(function()
            ambientSound=Instance.new("Sound")
            ambientSound.SoundId=AMB
            ambientSound.Volume=.12
            ambientSound.Looped=true
            ambientSound.Parent=SS
            ambientSound:Play()
        end)
        S.Ambient=true
    end
end

local function toast(t,m,col)
    if not S.UI.Gui then return end
    local tt=Instance.new("Frame")
    tt.Size=UDim2.new(0,240,0,46)
    tt.Position=UDim2.new(1,300,0,20)
    tt.BackgroundColor3=C.Panel
    tt.BorderSizePixel=0
    tt.ZIndex=200
    tt.Parent=S.UI.Gui
    corner(tt,UDim.new(0,12))
    local st=Instance.new("Frame")
    st.Size=UDim2.new(0,4,1,-12)
    st.Position=UDim2.new(0,4,0,6)
    st.BackgroundColor3=col or C.Primary
    st.BorderSizePixel=0
    st.ZIndex=201
    st.Parent=tt
    corner(st,UDim.new(1,0))
    local a=Instance.new("TextLabel")
    a.Size=UDim2.new(1,-20,0,16)
    a.Position=UDim2.new(0,16,0,6)
    a.BackgroundTransparency=1
    a.Text=t
    a.TextColor3=C.Text
    a.Font=F.Title
    a.TextSize=11
    a.TextXAlignment=Enum.TextXAlignment.Left
    a.Parent=tt
    local b=Instance.new("TextLabel")
    b.Size=UDim2.new(1,-20,0,14)
    b.Position=UDim2.new(0,16,0,24)
    b.BackgroundTransparency=1
    b.Text=m
    b.TextColor3=C.TextDim
    b.Font=F.Body
    b.TextSize=9
    b.TextXAlignment=Enum.TextXAlignment.Left
    b.TextTruncate=Enum.TextTruncate.AtEnd
    b.Parent=tt
    tw(tt,.4,{Position=UDim2.new(1,-260,0,20)},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    task.delay(3,function()
        tw(tt,.3,{Position=UDim2.new(1,300,0,20)})
        task.wait(.3)
        if tt then tt:Destroy()end
    end)
end

--══════════════════════════════════════════════════════════════════
-- ✨ PARTÍCULAS
--══════════════════════════════════════════════════════════════════

local COLORS={Color3.fromRGB(255,215,90),Color3.fromRGB(255,240,150),Color3.fromRGB(200,150,255),Color3.fromRGB(255,180,100),Color3.fromRGB(120,255,180),Color3.fromRGB(255,150,220),Color3.fromRGB(120,200,255),Color3.fromRGB(255,255,255)}

local function particle(g,x,y,sz,col)
local p=Instance.new("Frame")
p.Size=UDim2.new(0,sz,0,sz)
p.Position=UDim2.new(0,x,0,y)
p.AnchorPoint=Vector2.new(.5,.5)
p.BackgroundColor3=col
p.BorderSizePixel=0
p.ZIndex=8
p.Parent=g
local sh=math.random(1,3)
if sh==1 then corner(p,UDim.new(1,0))
elseif sh==2 then corner(p,UDim.new(0,2))
else p.Rotation=45 corner(p,UDim.new(0,2))end
local st=Instance.new("UIStroke")
st.Thickness=1
st.Color=col
st.Transparency=.4
st.Parent=p
local a=math.random()*math.pi*2
local d=math.random(80,220)
local du=math.random(15,30)/10
local fs=math.random(1,3)
tw(p,du,{Position=UDim2.new(0,x+math.cos(a)*d,0,y+math.sin(a)*d),Size=UDim2.new(0,fs,0,fs),BackgroundTransparency=1,Rotation=p.Rotation+math.random(-180,180)},Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
tw(st,du,{Transparency=1})
task.delay(du+.1,function()if p then p:Destroy()end end)
end

local function explode(g,x,y,n)
n=n or 25
for i=1,n do task.spawn(function()
local col=COLORS[math.random(1,#COLORS)]
local sz=math.random(6,12)
local p=Instance.new("Frame")
p.Size=UDim2.new(0,sz,0,sz)
p.Position=UDim2.new(0,x,0,y)
p.AnchorPoint=Vector2.new(.5,.5)
p.BackgroundColor3=col
p.BorderSizePixel=0
p.ZIndex=20
p.Parent=g
corner(p,UDim.new(1,0))
local st=Instance.new("UIStroke")
st.Thickness=2
st.Color=col
st.Transparency=.2
st.Parent=p
local a=(i/n)*math.pi*2+math.random()*.3
local d=math.random(100,300)
tw(p,1.2,{Position=UDim2.new(0,x+math.cos(a)*d,0,y+math.sin(a)*d),Size=UDim2.new(0,2,0,2),BackgroundTransparency=1,Rotation=math.random(-360,360)},Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
tw(st,1.2,{Transparency=1})
task.delay(1.3,function()if p then p:Destroy()end end)
end)end
end

local function startParticles(main,gui)
task.spawn(function()
while main and main.Parent do
if main.Visible then
local pos=main.AbsolutePosition
local sz=main.AbsoluteSize
for i=1,3 do
local sd=math.random(1,5)
local ox,oy
if sd==1 then ox=pos.X+math.random(0,sz.X)oy=pos.Y
elseif sd==2 then ox=pos.X+math.random(0,sz.X)oy=pos.Y+sz.Y
elseif sd==3 then ox=pos.X oy=pos.Y+math.random(0,sz.Y)
elseif sd==4 then ox=pos.X+sz.X oy=pos.Y+math.random(0,sz.Y)
else ox=pos.X+(math.random()<.5 and 0 or sz.X)oy=pos.Y+(math.random()<.5 and 0 or sz.Y)end
particle(gui,ox,oy,math.random(4,8),COLORS[math.random(1,#COLORS)])
end
end
task.wait(.12)
end
end)
end
--══════════════════════════════════════════════════════════════════
-- 🎨 CONSTRUÇÃO DA UI PREMIUM
--══════════════════════════════════════════════════════════════════

local function buildUI()
local gui=Instance.new("ScreenGui")
gui.Name="VegaxPremiumUI"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.DisplayOrder=999
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=CoreGui
S.UI.Gui=gui

local main=Instance.new("Frame")
main.Name="Main"
main.Size=UDim2.new(0,600,0,380)
main.Position=UDim2.new(.5,-300,.5,-190)
main.BackgroundColor3=C.Bg
main.BorderSizePixel=0
main.Active=true
main.Draggable=true
main.Parent=gui
corner(main,UDim.new(0,16))
shadow(main,.5)
S.UI.Main=main

local stroke=Instance.new("UIStroke")
stroke.Thickness=2
stroke.Color=C.Primary
stroke.Transparency=.3
stroke.Parent=main

task.spawn(function()
while main.Parent do
tw(stroke,1.5,{Transparency=.7})
task.wait(1.5)
tw(stroke,1.5,{Transparency=.15})
task.wait(1.5)
end
end)

local header=Instance.new("Frame")
header.Size=UDim2.new(1,0,0,80)
header.BackgroundColor3=C.Panel
header.BorderSizePixel=0
header.Parent=main
corner(header,UDim.new(0,16))

local hFix=Instance.new("Frame")
hFix.Size=UDim2.new(1,0,0,18)
hFix.Position=UDim2.new(0,0,1,-18)
hFix.BackgroundColor3=C.Panel
hFix.BorderSizePixel=0
hFix.Parent=header

local logoF=Instance.new("Frame")
logoF.Size=UDim2.new(0,36,0,36)
logoF.Position=UDim2.new(0,12,0,7)
logoF.BackgroundTransparency=1
logoF.Parent=header

local logo=Instance.new("ImageLabel")
logo.Size=UDim2.new(1,0,1,0)
logo.BackgroundTransparency=1
logo.Image=CONFIG.LOGO
logo.ScaleType=Enum.ScaleType.Fit
logo.Parent=logoF

local title=Instance.new("TextLabel")
title.Size=UDim2.new(0,170,0,18)
title.Position=UDim2.new(0,56,0,8)
title.BackgroundTransparency=1
title.Text=CONFIG.HUB_NAME.." "..CONFIG.VERSION
title.TextColor3=C.Text
title.Font=F.Title
title.TextSize=14
title.TextXAlignment=Enum.TextXAlignment.Left
title.Parent=header

local sub=Instance.new("TextLabel")
sub.Size=UDim2.new(0,170,0,12)
sub.Position=UDim2.new(0,56,0,26)
sub.BackgroundTransparency=1
sub.Text="Premium Edition • 75+ scripts"
sub.TextColor3=C.TextDim
sub.Font=F.Body
sub.TextSize=9
sub.TextXAlignment=Enum.TextXAlignment.Left
sub.Parent=header

addPremiumBadge(header)

local btnRow=Instance.new("Frame")
btnRow.Size=UDim2.new(1,-20,0,34)
btnRow.Position=UDim2.new(0,10,0,44)
btnRow.BackgroundTransparency=1
btnRow.Parent=header

local bLay=Instance.new("UIListLayout")
bLay.FillDirection=Enum.FillDirection.Horizontal
bLay.Padding=UDim.new(0,8)
bLay.VerticalAlignment=Enum.VerticalAlignment.Center
bLay.Parent=btnRow

local function mkBtn(txt,col,cb)
local b=Instance.new("TextButton")
b.Size=UDim2.new(0,34,0,34)
b.BackgroundColor3=C.PanelLight
b.Text=txt
b.TextColor3=col
b.TextSize=16
b.Font=F.Body
b.BorderSizePixel=0
b.AutoButtonColor=false
b.Parent=btnRow
corner(b,UDim.new(1,0))
b.MouseEnter:Connect(function()
tw(b,.2,{Size=UDim2.new(0,38,0,38),BackgroundColor3=C.Primary,TextColor3=Color3.fromRGB(30,20,10)},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
end)
b.MouseLeave:Connect(function()
tw(b,.2,{Size=UDim2.new(0,34,0,34),BackgroundColor3=C.PanelLight,TextColor3=col})
end)
b.MouseButton1Click:Connect(cb)
return b
end

mkBtn("📸",C.Accent,function()
sound(SND,.5,1.1)
local i=string.format("%s %s\nTier: %s\nHWID: %s",CONFIG.HUB_NAME,CONFIG.VERSION,Auth.Tier or "premium",tostring(Auth.HWID):sub(1,12).."...")
if setclipboard then setclipboard(i) end
toast("📸","Info copiada!",C.Accent)
end)

mkBtn("🔔",C.Gold,function()
sound(SND,.5,1.1)
toggleAmbient()
toast("🔔","Som "..(S.Ambient and "ligado" or "desligado"),S.Ambient and C.Success or C.TextDim)
end)

mkBtn("💬",C.Discord,function()
sound(SND,.5,1.2)
if setclipboard then setclipboard(CONFIG.DISCORD) end
toast("💬","Discord copiado!",C.Discord)
end)

mkBtn("🔄",C.Success,function()
sound(SND,.5,1.1)
toast("🔄","Recarregando...",C.Accent)
task.wait(1.5)
if S.UI.Gui then S.UI.Gui:Destroy() end
local src=game:HttpGet("https://raw.githubusercontent.com/Victtor-Scripts/Vegax-hub/refs/heads/main/VegaX-Hub.lua")
local fn=loadstring(src)
if fn then fn() end
end)

mkBtn("✕",C.Danger,function()
sound(SND,.4,.9)
tw(main,.25,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(.5,0,.5,0)},Enum.EasingStyle.Quart,Enum.EasingDirection.In)
task.wait(.25)
main.Visible=false
end)

local searchF=Instance.new("Frame")
searchF.Size=UDim2.new(0,180,0,28)
searchF.Position=UDim2.new(0,12,0,90)
searchF.BackgroundColor3=C.Panel
searchF.BorderSizePixel=0
searchF.Parent=main
corner(searchF,UDim.new(0,10))

local searchB=Instance.new("TextBox")
searchB.Size=UDim2.new(1,-16,1,0)
searchB.Position=UDim2.new(0,8,0,0)
searchB.BackgroundTransparency=1
searchB.PlaceholderText="🔍 Buscar..."
searchB.PlaceholderColor3=C.TextDim
searchB.Text=""
searchB.TextColor3=C.Text
searchB.Font=F.Body
searchB.TextSize=11
searchB.ClearTextOnFocus=false
searchB.TextXAlignment=Enum.TextXAlignment.Left
searchB.Parent=searchF
S.UI.Search=searchB

local filtF=Instance.new("Frame")
filtF.Size=UDim2.new(0,160,0,28)
filtF.Position=UDim2.new(1,-172,0,90)
filtF.BackgroundTransparency=1
filtF.Parent=main

local fLay=Instance.new("UIListLayout")
fLay.FillDirection=Enum.FillDirection.Horizontal
fLay.Padding=UDim.new(0,5)
fLay.VerticalAlignment=Enum.VerticalAlignment.Center
fLay.HorizontalAlignment=Enum.HorizontalAlignment.Right
fLay.Parent=filtF

for _,fd in ipairs({
{N="ALL",L="🌐",C=C.TextDim},
{N="KEYLESS",L="✓",C=C.Success},
{N="⭐",L="⭐",C=C.Gold},
{N="PREMIUM",L="💎",C=C.Primary}})do
local fb=Instance.new("TextButton")
fb.Size=UDim2.new(0,34,0,28)
fb.BackgroundColor3=C.PanelLight
fb.Text=fd.L
fb.TextColor3=fd.C
fb.TextSize=13
fb.Font=F.Body
fb.BorderSizePixel=0
fb.AutoButtonColor=false
fb.Parent=filtF
corner(fb,UDim.new(0,8))
fb.MouseEnter:Connect(function()tw(fb,.15,{BackgroundColor3=C.Primary,TextColor3=Color3.fromRGB(30,20,10)})end)
fb.MouseLeave:Connect(function()tw(fb,.15,{BackgroundColor3=C.PanelLight,TextColor3=fd.C})end)
fb.MouseButton1Click:Connect(function()
sound(SND,.4,1.2)
S.Filter=fd.N
if S.UI.render then S.UI.render(S.CurrentTab)end
end)
end

local tabBar=Instance.new("ScrollingFrame")
tabBar.Size=UDim2.new(1,-24,0,28)
tabBar.Position=UDim2.new(0,12,0,126)
tabBar.BackgroundTransparency=1
tabBar.BorderSizePixel=0
tabBar.ScrollBarThickness=0
tabBar.ScrollingDirection=Enum.ScrollingDirection.X
tabBar.CanvasSize=UDim2.new(0,0,0,0)
tabBar.AutomaticCanvasSize=Enum.AutomaticSize.X
tabBar.Parent=main
S.UI.TabBar=tabBar

local tLay=Instance.new("UIListLayout")
tLay.FillDirection=Enum.FillDirection.Horizontal
tLay.Padding=UDim.new(0,5)
tLay.SortOrder=Enum.SortOrder.LayoutOrder
tLay.VerticalAlignment=Enum.VerticalAlignment.Center
tLay.Parent=tabBar

local listF=Instance.new("ScrollingFrame")
listF.Size=UDim2.new(1,-24,1,-246)
listF.Position=UDim2.new(0,12,0,162)
listF.BackgroundTransparency=1
listF.BorderSizePixel=0
listF.ScrollBarThickness=4
listF.ScrollBarImageColor3=C.Primary
listF.CanvasSize=UDim2.new(0,0,0,0)
listF.AutomaticCanvasSize=Enum.AutomaticSize.Y
listF.Parent=main
S.UI.List=listF

local lLay=Instance.new("UIListLayout")
lLay.Padding=UDim.new(0,7)
lLay.SortOrder=Enum.SortOrder.LayoutOrder
lLay.Parent=listF

local footer=Instance.new("Frame")
footer.Size=UDim2.new(1,-24,0,44)
footer.Position=UDim2.new(0,12,1,-54)
footer.BackgroundColor3=C.Panel
footer.BorderSizePixel=0
footer.Parent=main
corner(footer,UDim.new(0,10))

local dot=Instance.new("Frame")
dot.Size=UDim2.new(0,8,0,8)
dot.Position=UDim2.new(0,12,0,9)
dot.BackgroundColor3=C.Success
dot.BorderSizePixel=0
dot.Parent=footer
corner(dot,UDim.new(1,0))

task.spawn(function()
while dot.Parent do
tw(dot,.5,{BackgroundTransparency=.5})
task.wait(.5)
tw(dot,.5,{BackgroundTransparency=0})
task.wait(.5)
end
end)

local status=Instance.new("TextLabel")
status.Size=UDim2.new(1,-25,0,14)
status.Position=UDim2.new(0,28,0,6)
status.BackgroundTransparency=1
status.Text="Pronto • "..CONFIG.HUB_NAME.." • "..(S.IsAdmin and "👑 ADMIN" or "💎 PREMIUM")
status.TextColor3=C.TextDim
status.Font=F.Body
status.TextSize=10
status.TextXAlignment=Enum.TextXAlignment.Left
status.Parent=footer
S.UI.Status=status

local stats=Instance.new("TextLabel")
stats.Size=UDim2.new(1,-25,0,14)
stats.Position=UDim2.new(0,12,0,24)
stats.BackgroundTransparency=1
stats.Text="FPS: -- • Ping: --ms • 💬 discord.gg/GUMcHjHgTp"
stats.TextColor3=C.TextDim
stats.Font=F.Body
stats.TextSize=9
stats.TextXAlignment=Enum.TextXAlignment.Left
stats.Parent=footer
S.UI.Stats=stats

return gui
end

--══════════════════════════════════════════════════════════════════
-- 🎯 TABS
--══════════════════════════════════════════════════════════════════

local function createTab(cat,idx)
local b=Instance.new("TextButton")
b.Name="Tab"..idx
b.Size=UDim2.new(0,98,1,0)
b.BackgroundColor3=C.Panel
b.Text=(cat.Icon or "").." "..(cat.Name or "")
b.TextColor3=C.TextDim
b.Font=F.Title
b.TextSize=9
b.BorderSizePixel=0
b.AutoButtonColor=false
b.LayoutOrder=idx
b.Parent=S.UI.TabBar
corner(b,UDim.new(0,8))
b.MouseEnter:Connect(function()
if S.CurrentTab~=idx then tw(b,.15,{BackgroundColor3=C.PanelLight,Size=UDim2.new(0,102,1,2)})end
end)
b.MouseLeave:Connect(function()
if S.CurrentTab~=idx then tw(b,.15,{BackgroundColor3=C.Panel,Size=UDim2.new(0,98,1,0)})end
end)
b.MouseButton1Click:Connect(function()
sound(SND,.35,1.2)
S.CurrentTab=idx
S.UI.render(idx)
end)
return b
end

--══════════════════════════════════════════════════════════════════
-- 🎴 CARDS
--══════════════════════════════════════════════════════════════════

local function createCard(s,order)
local card=Instance.new("Frame")
card.Name=s.Name
card.Size=UDim2.new(1,-6,0,56)
card.BackgroundColor3=C.Panel
card.BorderSizePixel=0
card.LayoutOrder=order
card.Parent=S.UI.List
corner(card,UDim.new(0,10))

if s.Premium then
local ps=Instance.new("UIStroke")
ps.Thickness=1.5
ps.Color=C.Primary
ps.Transparency=.4
ps.Parent=card
end

local strip=Instance.new("Frame")
strip.Size=UDim2.new(0,4,0,34)
strip.Position=UDim2.new(0,0,.5,-17)
strip.BackgroundColor3=s.Color or C.Primary
strip.BorderSizePixel=0
strip.Parent=card
corner(strip,UDim2.new(1,0))

local name=Instance.new("TextLabel")
name.Size=UDim2.new(1,-180,0,14)
name.Position=UDim2.new(0,14,0,7)
name.BackgroundTransparency=1
name.Text=s.Name
name.TextColor3=C.Text
name.Font=F.Title
name.TextSize=13
name.TextXAlignment=Enum.TextXAlignment.Left
name.Parent=card

local desc=Instance.new("TextLabel")
desc.Size=UDim2.new(1,-180,0,12)
desc.Position=UDim2.new(0,14,0,22)
desc.BackgroundTransparency=1
desc.Text=s.Desc
desc.TextColor3=C.TextDim
desc.Font=F.Body
desc.TextSize=9
desc.TextXAlignment=Enum.TextXAlignment.Left
desc.TextTruncate=Enum.TextTruncate.AtEnd
desc.Parent=card

local tag=Instance.new("TextLabel")
tag.Size=UDim2.new(0,62,0,12)
tag.Position=UDim2.new(0,14,1,-14)
tag.BackgroundColor3=C.PanelLight
tag.Text=s.Premium and "💎 PREMIUM" or "✓ KEYLESS"
tag.TextColor3=s.Premium and C.Primary or C.Success
tag.Font=F.Title
tag.TextSize=7
tag.BorderSizePixel=0
tag.Parent=card
corner(tag,UDim.new(0,4))

local fav=Instance.new("TextButton")
fav.Size=UDim2.new(0,24,0,24)
fav.Position=UDim2.new(1,-148,.5,-12)
fav.BackgroundColor3=C.PanelLight
fav.Text=S.Fav[s.Name] and "⭐" or "☆"
fav.TextColor3=S.Fav[s.Name] and C.Gold or C.TextDim
fav.TextSize=13
fav.Font=F.Body
fav.BorderSizePixel=0
fav.AutoButtonColor=false
fav.Parent=card
corner(fav,UDim2.new(0,8))
fav.MouseButton1Click:Connect(function()
S.Fav[s.Name]=not S.Fav[s.Name]
if not S.Fav[s.Name]then S.Fav[s.Name]=nil end
fav.Text=S.Fav[s.Name] and "⭐" or "☆"
fav.TextColor3=S.Fav[s.Name] and C.Gold or C.TextDim
sound(SND,.4,S.Fav[s.Name] and 1.3 or .9)
end)

local exec=Instance.new("TextButton")
exec.Size=UDim2.new(0,78,0,28)
exec.Position=UDim2.new(1,-88,.5,-14)
exec.BackgroundColor3=C.Primary
exec.Text="EXEC"
exec.TextColor3=Color3.fromRGB(30,20,10)
exec.Font=F.Title
exec.TextSize=11
exec.BorderSizePixel=0
exec.AutoButtonColor=false
exec.Parent=card
corner(exec,UDim2.new(0,8))

exec.MouseButton1Click:Connect(function()
if S.Loading then return end
S.Loading=true
sound(SND,.6,1.0)

local btnX=exec.AbsolutePosition.X+exec.AbsoluteSize.X/2
local btnY=exec.AbsolutePosition.Y+exec.AbsoluteSize.Y/2
explode(S.UI.Gui,btnX,btnY,12)

exec.Text="..."
tw(exec,.15,{BackgroundColor3=C.Accent})
S.UI.Status.Text="Executando "..s.Name.."..."
S.UI.Status.TextColor3=C.Accent

local ok,err=pcall(function()
local src=S.Cache[s.Url]
if not src then
src=game:HttpGet(s.Url)
S.Cache[s.Url]=src
end
local fn=loadstring(src)
if fn then fn() else error("Falha") end
end)

task.wait(.3)
if ok then
exec.Text="✓"
tw(exec,.2,{BackgroundColor3=C.Success})
S.UI.Status.Text=s.Name.." executado!"
S.UI.Status.TextColor3=C.Success
sound(SND,.5,1.3)
toast("✓ Sucesso",s.Name.." executado!",C.Success)
else
exec.Text="✕"
tw(exec,.2,{BackgroundColor3=C.Danger})
S.UI.Status.Text="Erro: "..tostring(err):sub(1,40)
S.UI.Status.TextColor3=C.Danger
sound(SND,.5,.7)
toast("✕ Erro",tostring(err):sub(1,40),C.Danger)
end

task.wait(1.5)
exec.Text="EXEC"
tw(exec,.2,{BackgroundColor3=C.Primary})
S.Loading=false
end)

card.MouseEnter:Connect(function()
tw(card,.25,{BackgroundColor3=C.PanelLight,Size=UDim2.new(1,0,0,60)},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
end)
card.MouseLeave:Connect(function()
tw(card,.2,{BackgroundColor3=C.Panel,Size=UDim2.new(1,-6,0,56)})
end)
end

--══════════════════════════════════════════════════════════════════
-- 🎨 RENDER
--══════════════════════════════════════════════════════════════════

S.UI.render=function(idx)
for _,t in ipairs(S.UI.TabBar:GetChildren())do
if t:IsA("TextButton")then
local i=tonumber(t.Name:match("%d+"))
if i==idx then
tw(t,.2,{BackgroundColor3=C.Primary,TextColor3=Color3.fromRGB(30,20,10)})
else
tw(t,.2,{BackgroundColor3=C.Panel,TextColor3=C.TextDim})
end
end
end
for _,c in ipairs(S.UI.List:GetChildren())do
if c:IsA("Frame")then c:Destroy()end
end
local cat=CATS[idx]
if not cat then return end
local filtered={}
for _,s in ipairs(cat.Scripts)do
local pass=false
if S.Filter=="ALL"then pass=true
elseif S.Filter=="KEYLESS"then pass=not s.Key
elseif S.Filter=="⭐"then pass=S.Fav[s.Name]
elseif S.Filter=="PREMIUM"then pass=s.Premium end
if pass then table.insert(filtered,s)end
end
for i,s in ipairs(filtered)do createCard(s,i)end
S.UI.Search.Text=""
end

--══════════════════════════════════════════════════════════════════
-- 🔵 BOTÃO FLUTUANTE
--══════════════════════════════════════════════════════════════════

local function createFloat(gui)
local w=Instance.new("Frame")
w.Size=UDim2.new(0,72,0,72)
w.Position=UDim2.new(0,10,.5,-36)
w.BackgroundTransparency=1
w.ZIndex=49
w.Active=true
w.Parent=gui

local glow=Instance.new("Frame")
glow.Size=UDim2.new(0,54,0,54)
glow.Position=UDim2.new(.5,-27,.5,-27)
glow.BackgroundColor3=C.Primary
glow.BackgroundTransparency=.7
glow.BorderSizePixel=0
glow.ZIndex=49
glow.Parent=w
corner(glow,UDim.new(1,0))

local btn=Instance.new("TextButton")
btn.Size=UDim2.new(0,54,0,54)
btn.Position=UDim2.new(.5,-27,.5,-27)
btn.BackgroundColor3=Color3.fromRGB(10,8,6)
btn.Text=""
btn.BorderSizePixel=0
btn.AutoButtonColor=false
btn.ZIndex=51
btn.Active=true
btn.Parent=w
corner(btn,UDim2.new(1,0))

local st=Instance.new("UIStroke")
st.Thickness=2
st.Color=C.Primary
st.Transparency=.2
st.Parent=btn

local lh=Instance.new("Frame")
lh.Size=UDim2.new(1,-10,1,-10)
lh.Position=UDim2.new(0,5,0,5)
lh.BackgroundTransparency=1
lh.ZIndex=52
lh.Parent=btn

local li=Instance.new("ImageLabel")
li.Size=UDim2.new(1,0,1,0)
li.BackgroundTransparency=1
li.Image=CONFIG.LOGO
li.ScaleType=Enum.ScaleType.Fit
li.ZIndex=52
li.Parent=lh

task.spawn(function()
while w.Parent do
tw(glow,1.2,{BackgroundTransparency=.85})
task.wait(1.2)
tw(glow,1.2,{BackgroundTransparency=.5})
task.wait(1.2)
end
end)

local drag,ds,sp,moved=false,nil,nil,false
local function beginDrag(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
drag=true moved=false ds=input.Position sp=w.Position
local cn
cn=input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then
drag=false
if cn then cn:Disconnect()end
end
end)
end
end
w.InputBegan:Connect(beginDrag)
btn.InputBegan:Connect(beginDrag)
UIS.InputChanged:Connect(function(input)
if drag and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then
local d=input.Position-ds
if d.Magnitude>10 then moved=true end
w.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
end
end)
btn.MouseButton1Click:Connect(function()
if moved then return end
sound(SND,.5,1.1)
local m=S.UI.Main
if m.Visible then
tw(m,.25,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(.5,0,.5,0)},Enum.EasingStyle.Quart,Enum.EasingDirection.In)
task.wait(.25)
m.Visible=false
else
m.Visible=true
m.Size=UDim2.new(0,0,0,0)
m.Position=UDim2.new(.5,0,.5,0)
tw(m,.35,{Size=UDim2.new(0,600,0,380),Position=UDim2.new(.5,-300,.5,-190)})
end
end)
end

--══════════════════════════════════════════════════════════════════
-- 🎬 INTRO PREMIUM
--══════════════════════════════════════════════════════════════════

local function playIntro(gui)
sound(SND,.6,1)
local intro=Instance.new("Frame")
intro.Size=UDim2.new(1,0,1,0)
intro.BackgroundColor3=Color3.fromRGB(0,0,0)
intro.BackgroundTransparency=1
intro.BorderSizePixel=0
intro.ZIndex=100
intro.Parent=gui

local logoF=Instance.new("Frame")
logoF.Size=UDim2.new(0,0,0,0)
logoF.Position=UDim2.new(.5,0,.5,-80)
logoF.AnchorPoint=Vector2.new(.5,.5)
logoF.BackgroundTransparency=1
logoF.ZIndex=103
logoF.Parent=intro

local logoI=Instance.new("ImageLabel")
logoI.Size=UDim2.new(1,0,1,0)
logoI.BackgroundTransparency=1
logoI.Image=CONFIG.LOGO
logoI.ScaleType=Enum.ScaleType.Fit
logoI.ZIndex=103
logoI.Parent=logoF

local logoGlow=Instance.new("ImageLabel")
logoGlow.Size=UDim2.new(1,40,1,40)
logoGlow.Position=UDim2.new(0,-20,0,-20)
logoGlow.BackgroundTransparency=1
logoGlow.Image=CONFIG.LOGO
logoGlow.ImageColor3=C.Primary
logoGlow.ImageTransparency=.5
logoGlow.ZIndex=102
logoGlow.Parent=logoF

local nameFrame=Instance.new("Frame")
nameFrame.Size=UDim2.new(1,0,0,50)
nameFrame.Position=UDim2.new(0,0,.5,30)
nameFrame.BackgroundTransparency=1
nameFrame.ZIndex=104
nameFrame.Parent=intro

local nameText=CONFIG.HUB_NAME
for i=1,#nameText do
local letter=nameText:sub(i,i)
local lbl=Instance.new("TextLabel")
lbl.Size=UDim2.new(0,26,1,0)
lbl.Position=UDim2.new(.5,-#nameText*13+(i-1)*26,0,0)
lbl.BackgroundTransparency=1
lbl.Text=letter
lbl.TextColor3=C.Text
lbl.Font=F.Title
lbl.TextSize=36
lbl.TextStrokeColor3=C.Primary
lbl.TextStrokeTransparency=.5
lbl.TextTransparency=1
lbl.ZIndex=104
lbl.Parent=nameFrame
local op=lbl.Position
lbl.Position=UDim2.new(op.X.Scale,op.X.Offset,-80,0)
lbl.Rotation=math.random(-30,30)
task.delay((i-1)*.05,function()
tw(lbl,.5,{Position=op,TextTransparency=0,Rotation=0},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
end)
end

local subL=Instance.new("TextLabel")
subL.Size=UDim2.new(1,0,0,22)
subL.Position=UDim2.new(0,0,.5,75)
subL.BackgroundTransparency=1
subL.Text="💎 PREMIUM EDITION"
subL.TextColor3=C.Primary
subL.Font=F.Title
subL.TextSize=14
subL.TextTransparency=1
subL.ZIndex=104
subL.Parent=intro

local discL=Instance.new("TextLabel")
discL.Size=UDim2.new(1,0,0,20)
discL.Position=UDim2.new(0,0,.5,100)
discL.BackgroundTransparency=1
discL.Text="💬 discord.gg/GUMcHjHgTp"
discL.TextColor3=C.Discord
discL.Font=F.Body
discL.TextSize=12
discL.TextTransparency=1
discL.ZIndex=104
discL.Parent=intro

tw(intro,.3,{BackgroundTransparency=0})
tw(logoF,.6,{Size=UDim2.new(0,130,0,130)},Enum.EasingStyle.Back,Enum.EasingDirection.Out)

task.spawn(function()
while logoGlow.Parent do
tw(logoGlow,.8,{ImageTransparency=.7})
task.wait(.8)
tw(logoGlow,.8,{ImageTransparency=.3})
task.wait(.8)
end
end)

task.wait(1.2)
tw(subL,.4,{TextTransparency=0})
task.wait(.3)
tw(discL,.4,{TextTransparency=0})
task.wait(.8)
tw(logoF,.3,{Size=UDim2.new(0,0,0,0)})
for _,c in ipairs(nameFrame:GetChildren())do
if c:IsA("TextLabel")then tw(c,.3,{TextTransparency=1})end
end
tw(subL,.3,{TextTransparency=1})
tw(discL,.3,{TextTransparency=1})
tw(intro,.4,{BackgroundTransparency=1})
task.wait(.5)
intro:Destroy()
end

--══════════════════════════════════════════════════════════════════
-- 📊 STATS + INIT
--══════════════════════════════════════════════════════════════════

local function startStats()
task.spawn(function()
local frames,last,fps=0,tick(),60
RS.RenderStepped:Connect(function()
frames=frames+1
local now=tick()
if now-last>=1 then fps=frames frames=0 last=now end
end)
while S.UI.Gui and S.UI.Gui.Parent do
task.wait(2)
if S.UI.Stats and S.UI.Stats.Parent then
local ping=0
pcall(function() ping=math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
S.UI.Stats.Text=string.format("FPS: %d • Ping: %dms • Players: %d • 💬 discord.gg/GUMcHjHgTp",fps,ping,#game.Players:GetPlayers())
end
end
end)
end

function init()
if not verifyIntegrity() then
warn("[VEGAX PREMIUM] ❌ Integridade comprometida")
return
end

buildUI()
createFloat(S.UI.Gui)
for i,cat in ipairs(CATS)do createTab(cat,i) end
S.UI.render(1)

S.UI.Search:GetPropertyChangedSignal("Text"):Connect(function()
local q=S.UI.Search.Text:lower()
for _,c in ipairs(S.UI.List:GetChildren())do
if c:IsA("Frame")then c.Visible=q=="" or c.Name:lower():find(q,1,true) end
end
end)

startParticles(S.UI.Main,S.UI.Gui)
startStats()

UIS.InputBegan:Connect(function(input,proc)
if proc then return end
if input.KeyCode==Enum.KeyCode.K then
sound(SND,.4,1.0)
local m=S.UI.Main
if m.Visible then
tw(m,.25,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(.5,0,.5,0)},Enum.EasingStyle.Quart,Enum.EasingDirection.In)
task.wait(.25)
m.Visible=false
else
m.Visible=true
m.Size=UDim2.new(0,0,0,0)
m.Position=UDim2.new(.5,0,.5,0)
tw(m,.35,{Size=UDim2.new(0,600,0,380),Position=UDim2.new(.5,-300,.5,-190)})
end
end
end)

playIntro(S.UI.Gui)

task.wait(3.5)
local mp=S.UI.Main.AbsolutePosition
local ms=S.UI.Main.AbsoluteSize
explode(S.UI.Gui,mp.X+ms.X/2,mp.Y+ms.Y/2,30)

toast("👋 Bem-vindo!",CONFIG.HUB_NAME.." "..CONFIG.VERSION,C.Primary)
toast("💬 Discord","discord.gg/GUMcHjHgTp",C.Discord)

print("["..CONFIG.HUB_NAME.."] "..CONFIG.VERSION.." PREMIUM carregado ✅")
print("[VEGAX PREMIUM] Tier:",Auth.Tier or "premium")
if S.IsAdmin then print("[VEGAX PREMIUM] 👑 Você é ADMIN") end
end

--══════════════════════════════════════════════════════════════════
-- 🚀 START
--══════════════════════════════════════════════════════════════════

if CONFIG.REQUIRE_KEY then
    local saved = Auth.loadKey()
    if saved and saved ~= "" then
        local ok = Auth.validate(saved)
        if ok then
            S.Authenticated = true
            init()
        else
            LoginUI.show()
        end
    else
        LoginUI.show()
    end
else
    S.Authenticated = true
    S.IsAdmin = true
    init()
end
