--[[
    RISE NEXUS  —  единый хаб
    Вкладки: ESP · Радио/Каталог · Скрипты/Серверы · Blade Ball · MM2 · Настройки
    Auto Parry вынесен во второй файл: RiseNexus_AutoParry.lua
    • RightShift — показать / скрыть меню (клавишу можно поменять в «Настройки»)
    • «–» — свернуть в кружок, тап по кружку — открыть обратно
    • «×» — нажать два раза, чтобы выгрузить хаб
]]

-- ============================================================
-- LOADER (метод VIREX): сервисы через cloneref, GUI в gethui()/CoreGui,
-- ждём загрузку игры и персонажа, ~3 сек прогресс-бар, и только потом строится хаб.
-- ============================================================
do
    local cloneref = cloneref or function(o) return o end
    local TweenSvc = cloneref(game:GetService("TweenService"))
    local PlayersSvc = cloneref(game:GetService("Players"))
    local CoreGuiSvc = cloneref(game:GetService("CoreGui"))

    if not game:IsLoaded() then game.Loaded:Wait() end
    local lp = PlayersSvc.LocalPlayer
    local t0 = os.clock()
    while not lp.Character and os.clock() - t0 < 10 do task.wait(0.1) end

    local LoaderGui = Instance.new("ScreenGui")
    LoaderGui.Name = "RiseNexusLoader"
    LoaderGui.IgnoreGuiInset = true
    LoaderGui.ResetOnSpawn = false
    LoaderGui.DisplayOrder = 99999
    LoaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    LoaderGui.Parent = (gethui and gethui()) or CoreGuiSvc

    local Card = Instance.new("Frame")
    Card.AnchorPoint = Vector2.new(0.5, 0.5)
    Card.Position = UDim2.fromScale(0.5, 0.5)
    Card.Size = UDim2.fromOffset(390, 170)
    Card.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
    Card.BorderSizePixel = 0
    Card.ClipsDescendants = true
    Card.Parent = LoaderGui
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 18)

    local tex = Instance.new("Frame")
    tex.BackgroundTransparency = 1
    tex.Size = UDim2.fromScale(1, 1)
    tex.ClipsDescendants = true
    tex.Parent = Card
    for i = -5, 12 do
        local stripe = Instance.new("Frame")
        stripe.BackgroundColor3 = Color3.fromRGB(119, 120, 255)
        stripe.BackgroundTransparency = 0.94
        stripe.BorderSizePixel = 0
        stripe.Size = UDim2.fromOffset(34, 270)
        stripe.Position = UDim2.new(0, i * 58, 0, -45)
        stripe.Rotation = 28
        stripe.Parent = tex
    end
    local texGrad = Instance.new("UIGradient")
    texGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(119, 120, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 80, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 170, 255)),
    })
    texGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.82), NumberSequenceKeypoint.new(0.5, 0.9), NumberSequenceKeypoint.new(1, 0.82),
    })
    texGrad.Rotation = 25
    texGrad.Parent = tex

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(119, 120, 255)
    cardStroke.Transparency = 0.35
    cardStroke.Thickness = 1.2
    cardStroke.Parent = Card
    local cardScale = Instance.new("UIScale")
    cardScale.Scale = 0.86
    cardScale.Parent = Card

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.AnchorPoint = Vector2.new(0.5, 0)
    title.Position = UDim2.fromScale(0.5, 0.18)
    title.Size = UDim2.fromOffset(300, 42)
    title.Text = "RISE NEXUS"
    title.TextColor3 = Color3.fromRGB(235, 235, 255)
    title.Font = Enum.Font.Arcade
    title.TextSize = 31
    title.Parent = Card
    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.AnchorPoint = Vector2.new(0.5, 0)
    sub.Position = UDim2.fromScale(0.5, 0.46)
    sub.Size = UDim2.fromOffset(300, 20)
    sub.Text = "ESP · RADIO · BLADE BALL · MM2"
    sub.TextColor3 = Color3.fromRGB(165, 165, 175)
    sub.Font = Enum.Font.GothamMedium
    sub.TextSize = 11
    sub.Parent = Card

    local barBack = Instance.new("Frame")
    barBack.AnchorPoint = Vector2.new(0.5, 0)
    barBack.Position = UDim2.fromScale(0.5, 0.67)
    barBack.Size = UDim2.fromOffset(300, 6)
    barBack.BackgroundColor3 = Color3.fromRGB(32, 30, 38)
    barBack.BorderSizePixel = 0
    barBack.Parent = Card
    Instance.new("UICorner", barBack).CornerRadius = UDim.new(1, 0)
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(119, 120, 255)
    bar.BorderSizePixel = 0
    bar.Parent = barBack
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local percent = Instance.new("TextLabel")
    percent.BackgroundTransparency = 1
    percent.AnchorPoint = Vector2.new(0.5, 0)
    percent.Position = UDim2.fromScale(0.5, 0.76)
    percent.Size = UDim2.fromOffset(120, 20)
    percent.Text = "0%"
    percent.TextColor3 = Color3.fromRGB(220, 220, 225)
    percent.Font = Enum.Font.GothamBold
    percent.TextSize = 10
    percent.Parent = Card

    pcall(function()
        TweenSvc:Create(cardScale, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    end)

    -- фаза 1: 3 секунды до 100%, хаб в это время НЕ строится
    local duration, started = 3, os.clock()
    while LoaderGui.Parent do
        local alpha = math.clamp((os.clock() - started) / duration, 0, 1)
        bar.Size = UDim2.new(alpha, 0, 1, 0)
        percent.Text = tostring(math.floor(alpha * 100)) .. "%"
        if alpha >= 1 then break end
        task.wait()
    end
    bar.Size = UDim2.new(1, 0, 1, 0)
    percent.Text = "100%"
    task.wait(0.12)

    -- фаза 2: загрузчик исчезает полностью
    pcall(function()
        local info = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        for _, tw in ipairs({
            TweenSvc:Create(cardScale, info, { Scale = 0.8 }),
            TweenSvc:Create(Card, info, { BackgroundTransparency = 1 }),
            TweenSvc:Create(cardStroke, info, { Transparency = 1 }),
            TweenSvc:Create(title, info, { TextTransparency = 1 }),
            TweenSvc:Create(sub, info, { TextTransparency = 1 }),
            TweenSvc:Create(percent, info, { TextTransparency = 1 }),
            TweenSvc:Create(barBack, info, { BackgroundTransparency = 1 }),
            TweenSvc:Create(bar, info, { BackgroundTransparency = 1 }),
        }) do tw:Play() end
    end)
    task.wait(0.55)
    LoaderGui:Destroy()
end



local cloneref = cloneref or function(obj) return obj end
local function Service(name) return cloneref(game:GetService(name)) end

local Workspace        = Service("Workspace")
local RunService       = Service("RunService")
local Players          = Service("Players")
local UserInputService = Service("UserInputService")
local TweenService     = Service("TweenService")
local CoreGui          = Service("CoreGui")

local lplayer = Players.LocalPlayer
local Cam     = Workspace.CurrentCamera

local Env = (getgenv and getgenv()) or _G
if Env.__RISE_NEXUS_UNLOAD then pcall(Env.__RISE_NEXUS_UNLOAD) end

-- ============================================================
-- HELPERS
-- ============================================================
local Connections = {}
local function Track(conn)
    Connections[#Connections + 1] = conn
    return conn
end

local function New(class, props)
    local inst = Instance.new(class)
    local parent
    for k, v in pairs(props) do
        if k == "Parent" then parent = v else inst[k] = v end
    end
    if parent then inst.Parent = parent end
    return inst
end

local function Protect(gui)
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local ok = pcall(function() gui.Parent = (gethui and gethui()) or CoreGui end)
    if not ok or not gui.Parent then gui.Parent = lplayer:WaitForChild("PlayerGui") end
end

-- ============================================================
-- CONFIG
-- ============================================================
local ESP = {
    Enabled = true,
    TeamCheck = true,
    MaxDistance = 200,
    FontSize = 11,
    FadeOut = { OnDistance = true },
    Options = {
        Friendcheck = true,
        FriendcheckRGB = Color3.fromRGB(0, 255, 0),
        EnemyRGB = Color3.fromRGB(255, 70, 70),
    },
    Drawing = {
        Chams = {
            Enabled = true, Thermal = true, VisibleCheck = true,
            FillRGB = Color3.fromRGB(119, 120, 255), Fill_Transparency = 0.35,
            OutlineRGB = Color3.fromRGB(119, 120, 255), Outline_Transparency = 0,
        },
        Names = { Enabled = true, RGB = Color3.fromRGB(255, 255, 255) },
        Distances = { Enabled = true, Position = "Text", RGB = Color3.fromRGB(255, 255, 255) },
        Weapons = { Enabled = true, WeaponTextRGB = Color3.fromRGB(119, 120, 255) },
        Healthbar = {
            Enabled = true, HealthText = true, Lerp = false, Width = 2.5,
            HealthTextRGB = Color3.fromRGB(119, 120, 255),
            Gradient = true,
            GradientRGB1 = Color3.fromRGB(200, 0, 0),
            GradientRGB2 = Color3.fromRGB(60, 60, 125),
            GradientRGB3 = Color3.fromRGB(119, 120, 255),
        },
        Boxes = {
            Animate = true, RotationSpeed = 300,
            Gradient = false,
            GradientRGB1 = Color3.fromRGB(119, 120, 255), GradientRGB2 = Color3.fromRGB(0, 0, 0),
            GradientFill = true,
            GradientFillRGB1 = Color3.fromRGB(119, 120, 255), GradientFillRGB2 = Color3.fromRGB(0, 0, 0),
            Filled = { Enabled = true, Transparency = 0.75, RGB = Color3.fromRGB(0, 0, 0) },
            Full = { Enabled = false, RGB = Color3.fromRGB(255, 255, 255) },
            Corner = { Enabled = true, RGB = Color3.fromRGB(255, 255, 255) },
        },
    },
}

-- ============================================================
-- ESP CORE
-- ============================================================
local Holder = New("ScreenGui", {
    Name = "ESPHolder", ResetOnSpawn = false, DisplayOrder = 10,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
Protect(Holder)

local Objects = {}
local RotationAngle, LastTick = -45, tick()

local function IsEnemy(plr)
    if not ESP.TeamCheck then return true end
    local mine, theirs = lplayer.Team, plr.Team
    if mine == nil and theirs == nil then return true end
    return mine ~= theirs
end

local function Fade(base, alpha)
    return 1 - (1 - base) * alpha
end

local function StyleLabel(label, color, alpha)
    label.TextColor3 = color
    label.TextSize = ESP.FontSize
    label.TextTransparency = Fade(0, alpha)
    label.TextStrokeTransparency = Fade(0, alpha)
end

local function MakeLabel(rich)
    return New("TextLabel", {
        Parent = Holder, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(180, 20),
        BackgroundTransparency = 1, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.Code,
        TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.new(0, 0, 0),
        RichText = rich or false, Visible = false, ZIndex = 5,
    })
end

local function MakeFrame(z)
    return New("Frame", {
        Parent = Holder, BorderSizePixel = 0, BackgroundColor3 = Color3.new(1, 1, 1),
        Visible = false, ZIndex = z or 1,
    })
end

local function CreateESP(plr)
    local o = { Player = plr, Hidden = true, Friend = false, Corners = {}, Gui = {} }

    o.Box = MakeFrame(1)
    o.FillGradient = New("UIGradient", { Parent = o.Box })
    o.Outline = New("UIStroke", {
        Parent = o.Box, Thickness = 1, LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
    o.OutlineGradient = New("UIGradient", { Parent = o.Outline })

    o.HealthBack = MakeFrame(2)
    o.HealthBack.BackgroundColor3 = Color3.new(0, 0, 0)
    o.Health = MakeFrame(3)
    o.HealthGradient = New("UIGradient", { Parent = o.Health, Rotation = -90 })

    o.HealthText = MakeLabel(false)
    o.HealthText.AnchorPoint = Vector2.new(1, 0.5)
    o.HealthText.TextXAlignment = Enum.TextXAlignment.Right
    o.NameLabel = MakeLabel(true)
    o.DistLabel = MakeLabel(false)
    o.WeaponLabel = MakeLabel(false)

    local defs = {
        { -1, -1, true }, { -1, -1, false }, { 1, -1, true }, { 1, -1, false },
        { -1, 1, true }, { -1, 1, false }, { 1, 1, true }, { 1, 1, false },
    }
    for _, d in ipairs(defs) do
        local f = MakeFrame(4)
        f.AnchorPoint = Vector2.new(d[1] == 1 and 1 or 0, d[2] == 1 and 1 or 0)
        o.Corners[#o.Corners + 1] = { f = f, sx = d[1], sy = d[2], horiz = d[3] }
        o.Gui[#o.Gui + 1] = f
    end

    o.Chams = New("Highlight", {
        Parent = Holder, Enabled = false, FillTransparency = 1, OutlineTransparency = 0,
    })

    for _, g in ipairs({ o.Box, o.HealthBack, o.Health, o.HealthText, o.NameLabel, o.DistLabel, o.WeaponLabel }) do
        o.Gui[#o.Gui + 1] = g
    end

    task.spawn(function()
        local ok, res = pcall(function() return lplayer:IsFriendsWith(plr.UserId) end)
        if ok then o.Friend = res end
    end)

    return o
end

local function HideESP(o)
    if o.Hidden then return end
    o.Hidden = true
    for _, g in ipairs(o.Gui) do g.Visible = false end
    o.Chams.Enabled = false
    o.Chams.Adornee = nil
end

local function UpdateESP(o)
    if not ESP.Enabled then return HideESP(o) end

    local plr  = o.Player
    local char = plr.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum) or hum.Health <= 0 or not IsEnemy(plr) then return HideESP(o) end

    local pos, onScreen = Cam:WorldToScreenPoint(hrp.Position)
    local dist = (Cam.CFrame.Position - hrp.Position).Magnitude / 3.5714285714
    if not onScreen or dist > ESP.MaxDistance then return HideESP(o) end
    o.Hidden = false

    local D = ESP.Drawing
    local deco
    if ESP.Decorate then
        local okD, rD = pcall(ESP.Decorate, plr)
        if okD then deco = rD end
    end
    local alpha = ESP.FadeOut.OnDistance and math.max(0.1, 1 - dist / ESP.MaxDistance) or 1
    local x, y = pos.X, pos.Y
    local sf = (hrp.Size.Y * Cam.ViewportSize.Y) / (pos.Z * 2)
    local w, h = 3 * sf, 4.5 * sf
    local left, top = x - w / 2, y - h / 2

    -- ===== Box =====
    local B = D.Boxes
    o.Box.Position = UDim2.fromOffset(left, top)
    o.Box.Size = UDim2.fromOffset(w, h)
    o.Box.Visible = B.Filled.Enabled or B.Full.Enabled
    if B.Filled.Enabled then
        o.Box.BackgroundTransparency = Fade(B.Filled.Transparency, alpha)
        o.Box.BackgroundColor3 = B.GradientFill and Color3.new(1, 1, 1) or B.Filled.RGB
    else
        o.Box.BackgroundTransparency = 1
    end
    o.FillGradient.Enabled = B.GradientFill and B.Filled.Enabled
    o.FillGradient.Color = ColorSequence.new(B.GradientFillRGB1, B.GradientFillRGB2)
    o.Outline.Enabled = B.Full.Enabled
    o.Outline.Transparency = Fade(0, alpha)
    o.Outline.Color = B.Gradient and Color3.new(1, 1, 1) or B.Full.RGB
    o.OutlineGradient.Enabled = B.Gradient
    o.OutlineGradient.Color = ColorSequence.new(B.GradientRGB1, B.GradientRGB2)
    if B.Animate then
        o.FillGradient.Rotation = RotationAngle
        o.OutlineGradient.Rotation = RotationAngle
    else
        o.FillGradient.Rotation = -45
        o.OutlineGradient.Rotation = -45
    end

    -- ===== Corners =====
    local cw, ch = w / 5, h / 5
    for _, c in ipairs(o.Corners) do
        local f = c.f
        f.Visible = B.Corner.Enabled
        if B.Corner.Enabled then
            f.Position = UDim2.fromOffset(x + c.sx * w / 2, y + c.sy * h / 2)
            f.Size = c.horiz and UDim2.fromOffset(cw, 1) or UDim2.fromOffset(1, ch)
            f.BackgroundColor3 = (deco and deco.color) or B.Corner.RGB
            f.BackgroundTransparency = Fade(0, alpha)
        end
    end

    -- ===== Healthbar =====
    local H = D.Healthbar
    local hp = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
    local barX = left - 6
    o.HealthBack.Visible = H.Enabled
    o.Health.Visible = H.Enabled
    if H.Enabled then
        o.HealthBack.Position = UDim2.fromOffset(barX, top)
        o.HealthBack.Size = UDim2.fromOffset(H.Width, h)
        o.HealthBack.BackgroundTransparency = Fade(0.35, alpha)
        o.Health.Position = UDim2.fromOffset(barX, top + h * (1 - hp))
        o.Health.Size = UDim2.fromOffset(H.Width, h * hp)
        o.Health.BackgroundTransparency = Fade(0, alpha)
        if H.Lerp then
            o.HealthGradient.Enabled = false
            o.Health.BackgroundColor3 = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), hp)
        elseif H.Gradient then
            o.HealthGradient.Enabled = true
            o.HealthGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, H.GradientRGB1),
                ColorSequenceKeypoint.new(0.5, H.GradientRGB2),
                ColorSequenceKeypoint.new(1, H.GradientRGB3),
            })
            o.Health.BackgroundColor3 = Color3.new(1, 1, 1)
        else
            o.HealthGradient.Enabled = false
            o.Health.BackgroundColor3 = H.GradientRGB3
        end
    end
    local showHpText = H.HealthText and hp < 1
    o.HealthText.Visible = showHpText
    if showHpText then
        o.HealthText.Text = tostring(math.floor(hp * 100))
        o.HealthText.Position = UDim2.fromOffset(barX - 3, top + h * (1 - hp))
        StyleLabel(o.HealthText, H.HealthTextRGB, alpha)
    end

    -- ===== Name =====
    local N = D.Names
    o.NameLabel.Visible = N.Enabled
    if N.Enabled then
        local text = plr.Name
        if ESP.Options.Friendcheck then
            local c = o.Friend and ESP.Options.FriendcheckRGB or ESP.Options.EnemyRGB
            text = string.format(
                '(<font color="rgb(%d,%d,%d)">%s</font>) %s',
                math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5),
                o.Friend and "F" or "E", plr.Name
            )
        end
        if D.Distances.Enabled and D.Distances.Position == "Text" then
            text = text .. string.format(" [%d]", math.floor(dist))
        end
        if deco and deco.tag then
            local dc = deco.color or Color3.new(1, 1, 1)
            text = string.format('<font color="rgb(%d,%d,%d)">[%s]</font> %s', math.floor(dc.R * 255 + 0.5), math.floor(dc.G * 255 + 0.5), math.floor(dc.B * 255 + 0.5), deco.tag, text)
        end
        o.NameLabel.Text = text
        o.NameLabel.Position = UDim2.fromOffset(x, top - 9)
        StyleLabel(o.NameLabel, (deco and deco.color) or N.RGB, alpha)
    end

    -- ===== Distance (bottom) =====
    local distBottom = D.Distances.Enabled and D.Distances.Position == "Bottom"
    o.DistLabel.Visible = distBottom
    if distBottom then
        o.DistLabel.Text = string.format("%d m", math.floor(dist))
        o.DistLabel.Position = UDim2.fromOffset(x, y + h / 2 + 7)
        StyleLabel(o.DistLabel, D.Distances.RGB, alpha)
    end

    -- ===== Weapon =====
    local W = D.Weapons
    local showW = W.Enabled or (deco ~= nil and deco.extra ~= nil)
    o.WeaponLabel.Visible = showW and true or false
    if showW then
        local tool = char:FindFirstChildOfClass("Tool")
        o.WeaponLabel.Text = (deco and deco.extra) or (tool and tool.Name or "none")
        o.WeaponLabel.Position = UDim2.fromOffset(x, y + h / 2 + (distBottom and 19 or 8))
        StyleLabel(o.WeaponLabel, W.WeaponTextRGB, alpha)
    end

    -- ===== Chams =====
    local C = D.Chams
    o.Chams.Enabled = C.Enabled
    if C.Enabled then
        local pulse = C.Thermal and (0.4 + 0.6 * (0.5 + 0.5 * math.sin(tick() * 3))) or 1
        o.Chams.Adornee = char
        o.Chams.FillColor = (deco and deco.color) or C.FillRGB
        o.Chams.OutlineColor = (deco and deco.color) or C.OutlineRGB
        o.Chams.FillTransparency = Fade(Fade(C.Fill_Transparency, pulse), alpha)
        o.Chams.OutlineTransparency = Fade(Fade(C.Outline_Transparency, pulse), alpha)
        o.Chams.DepthMode = C.VisibleCheck and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
    end
end

local function AddESP(plr)
    if plr == lplayer or Objects[plr] then return end
    Objects[plr] = CreateESP(plr)
end

local function RemoveESP(plr)
    local o = Objects[plr]
    if not o then return end
    for _, g in ipairs(o.Gui) do pcall(function() g:Destroy() end) end
    pcall(function() o.Chams:Destroy() end)
    Objects[plr] = nil
end

for _, p in ipairs(Players:GetPlayers()) do AddESP(p) end
Track(Players.PlayerAdded:Connect(AddESP))
Track(Players.PlayerRemoving:Connect(RemoveESP))

Track(RunService.RenderStepped:Connect(function()
    Cam = Workspace.CurrentCamera
    if not Cam then return end
    local now = tick()
    RotationAngle = RotationAngle + (now - LastTick) * ESP.Drawing.Boxes.RotationSpeed * math.cos(math.pi / 4 * now - math.pi / 2)
    LastTick = now
    for _, o in pairs(Objects) do
        pcall(UpdateESP, o)
    end
end))

-- ============================================================
-- UI
-- ============================================================
local Theme = {
    Accent  = Color3.fromRGB(119, 120, 255),
    Panel   = Color3.fromRGB(24, 24, 34),
    Element = Color3.fromRGB(38, 38, 52),
    Off     = Color3.fromRGB(70, 70, 92),
    Text    = Color3.fromRGB(240, 240, 250),
    Sub     = Color3.fromRGB(150, 150, 175),
}

local Opacity = 0.85
local GlassList, AccentList = {}, {}

local function Glass(obj, base)
    GlassList[#GlassList + 1] = { obj, base }
    obj.BackgroundTransparency = 1 - (1 - base) * Opacity
end
local function ApplyGlass()
    for _, g in ipairs(GlassList) do
        g[1].BackgroundTransparency = 1 - (1 - g[2]) * Opacity
    end
end
local function OnAccent(fn)
    AccentList[#AccentList + 1] = fn
    fn()
end
local function SetAccent(c)
    Theme.Accent = c
    for _, fn in ipairs(AccentList) do fn() end
end
local function Round(obj, r)
    return New("UICorner", { CornerRadius = UDim.new(0, r), Parent = obj })
end
local function Stroke(obj, color, thickness, transparency)
    return New("UIStroke", {
        Color = color, Thickness = thickness or 1, Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = obj,
    })
end
local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end
local function IsPress(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

-- ===== единый менеджер перетаскивания (окно, слайдеры, палитра) =====
local ActiveDrag, DragPage
local function BeginDrag(fn, page)
    ActiveDrag = fn
    if page then
        DragPage = page
        page.ScrollingEnabled = false
    end
end
local function EndDrag()
    ActiveDrag = nil
    if DragPage then
        DragPage.ScrollingEnabled = true
        DragPage = nil
    end
end
Track(UserInputService.InputChanged:Connect(function(input)
    if ActiveDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        ActiveDrag(input.Position)
    end
end))
Track(UserInputService.InputEnded:Connect(function(input)
    if IsPress(input) then EndDrag() end
end))

-- ===== окно =====
local WIN_W, WIN_H = 560, 380
local vp = (Cam and Cam.ViewportSize) or Vector2.new(1280, 720)
local startScale = math.clamp(math.min(vp.X / (WIN_W + 60), vp.Y / (WIN_H + 60)), 0.6, 1)
startScale = math.floor(startScale * 20 + 0.5) / 20

local MenuGui = New("ScreenGui", {
    Name = "RiseNexus_UI", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
Protect(MenuGui)

local Main = New("Frame", {
    Name = "Main", Size = UDim2.fromOffset(WIN_W, WIN_H),
    Position = UDim2.fromOffset(math.floor((vp.X - WIN_W * startScale) / 2), math.floor((vp.Y - WIN_H * startScale) / 2)),
    BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Active = true, Parent = MenuGui,
})
Glass(Main, 0.1)
Round(Main, 12)
New("UIGradient", {
    Rotation = 60,
    Color = ColorSequence.new(Color3.fromRGB(34, 30, 60), Color3.fromRGB(12, 12, 18)),
    Parent = Main,
})
local MainStroke = Stroke(Main, Theme.Accent, 1, 0.45)
OnAccent(function() MainStroke.Color = Theme.Accent end)
local UIScaleObj = New("UIScale", { Scale = startScale, Parent = Main })

-- ===== кружок (свернутое состояние) =====
local Mini = New("TextButton", {
    Name = "Mini", Size = UDim2.fromOffset(52, 52), Position = UDim2.fromOffset(20, 100),
    BackgroundColor3 = Color3.fromRGB(18, 18, 26), Text = "RN", Font = Enum.Font.GothamBold,
    TextSize = 14, TextColor3 = Theme.Text, BorderSizePixel = 0, AutoButtonColor = false,
    Visible = false, Parent = MenuGui,
})
Glass(Mini, 0.1)
Round(Mini, 26)
local MiniStroke = Stroke(Mini, Theme.Accent, 2, 0)
OnAccent(function() MiniStroke.Color = Theme.Accent end)

-- ===== шапка =====
local Header = New("Frame", {
    Name = "Header", Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Active = true, Parent = Main,
})
local Dot = New("Frame", {
    Position = UDim2.fromOffset(14, 15), Size = UDim2.fromOffset(10, 10), BorderSizePixel = 0, Parent = Header,
})
Round(Dot, 5)
OnAccent(function() Dot.BackgroundColor3 = Theme.Accent end)
New("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -120, 1, 0),
    Text = "Rise Nexus", Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left, Parent = Header,
})
local function HeaderButton(text, x, color)
    local b = New("TextButton", {
        Size = UDim2.fromOffset(28, 24), Position = UDim2.new(1, x, 0, 8), Text = text,
        Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Theme.Text, BackgroundColor3 = color,
        BorderSizePixel = 0, AutoButtonColor = true, Parent = Header,
    })
    Glass(b, 0.35)
    Round(b, 6)
    return b
end
local MinBtn   = HeaderButton("–", -70, Theme.Element)
local CloseBtn = HeaderButton("×", -38, Color3.fromRGB(150, 50, 50))

New("Frame", {
    Position = UDim2.fromOffset(10, 40), Size = UDim2.new(1, -20, 0, 1),
    BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.9, BorderSizePixel = 0, Parent = Main,
})

-- перетаскивание окна
Header.InputBegan:Connect(function(input)
    if IsPress(input) then
        local startInput, startPos = input.Position, Main.Position
        BeginDrag(function(p)
            local d = p - startInput
            Main.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
        end)
    end
end)

-- перетаскивание кружка + открытие по тапу
local MiniMoved = false
Mini.InputBegan:Connect(function(input)
    if IsPress(input) then
        local startInput, startPos = input.Position, Mini.Position
        MiniMoved = false
        BeginDrag(function(p)
            local d = p - startInput
            if math.abs(d.X) > 6 or math.abs(d.Y) > 6 then MiniMoved = true end
            Mini.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
        end)
    end
end)

local function ShowMain()
    Mini.Visible = false
    Main.Visible = true
end
local function ShowMini()
    Main.Visible = false
    Mini.Visible = true
end
Mini.Activated:Connect(function()
    if not MiniMoved then ShowMain() end
end)
MinBtn.Activated:Connect(ShowMini)

local Unload
local confirmUntil = 0
CloseBtn.Activated:Connect(function()
    if tick() < confirmUntil then
        Unload()
        return
    end
    confirmUntil = tick() + 2
    CloseBtn.Text = "?"
    task.delay(2, function()
        if CloseBtn.Parent then CloseBtn.Text = "×" end
    end)
end)

-- ===== боковая панель и контент =====
local Sidebar = New("ScrollingFrame", {
    Position = UDim2.fromOffset(8, 48), Size = UDim2.new(0, 124, 1, -56),
    BackgroundColor3 = Theme.Panel, BorderSizePixel = 0, ScrollBarThickness = 0,
    CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y, ElasticBehavior = Enum.ElasticBehavior.Never, Parent = Main,
})
Glass(Sidebar, 0.35)
Round(Sidebar, 10)
New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Sidebar })
New("UIPadding", {
    PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = Sidebar,
})

local Content = New("Frame", {
    Position = UDim2.fromOffset(140, 48), Size = UDim2.new(1, -148, 1, -56),
    BackgroundTransparency = 1, Parent = Main,
})

local Tabs = {}
local function SelectTab(t)
    for _, x in ipairs(Tabs) do
        local on = (x == t)
        x.Page.Visible = on
        x.Bar.Visible = on
        x.Btn.TextColor3 = on and Theme.Text or Theme.Sub
        Tween(x.Btn, { BackgroundTransparency = on and 0.8 or 1 }, 0.12)
    end
end

-- ============================================================
-- RISE NEXUS: расширения кита (общие для всех модулей)
-- ============================================================
local SideOrder = 0
local Cleanups = {}
local function OnUnload(fn) Cleanups[#Cleanups + 1] = fn end

local function SideLabel(text)
    SideOrder = SideOrder + 1
    local l = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = text,
        Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.Sub,
        TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = SideOrder, Parent = Sidebar,
    })
    New("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingTop = UDim.new(0, 8), Parent = l })
end

-- фоновый блюр как в Rise (один общий эффект, не дублируется при перезапуске)
local NX = { Blur = true }
local LightingSvc = Service("Lighting")
local BlurFx = LightingSvc:FindFirstChild("RiseMenuBlur")
if not BlurFx then
    BlurFx = Instance.new("BlurEffect")
    BlurFx.Name = "RiseMenuBlur"
    BlurFx.Size = 0
    BlurFx.Parent = LightingSvc
end
Track(Main:GetPropertyChangedSignal("Visible"):Connect(function()
    Tween(BlurFx, { Size = (Main.Visible and NX.Blur) and 14 or 0 }, 0.25)
end))
OnUnload(function() BlurFx.Size = 0 end)
if Main.Visible then Tween(BlurFx, { Size = 14 }, 0.4) end

-- тост-уведомление
local function Toast(text, kind)
    local old = MenuGui:FindFirstChild("RNToast")
    if old then old:Destroy() end
    local col = Theme.Panel
    if kind == "ok" then col = Color3.fromRGB(40, 170, 100) elseif kind == "bad" then col = Color3.fromRGB(190, 60, 60) end
    local card = New("Frame", {
        Name = "RNToast", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, -50),
        Size = UDim2.fromOffset(0, 32), AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = col, BorderSizePixel = 0, ZIndex = 300, Parent = MenuGui,
    })
    Round(card, 16)
    Stroke(card, Color3.new(1, 1, 1), 1, 0.75)
    New("UIPadding", { PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16), Parent = card })
    New("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 32), AutomaticSize = Enum.AutomaticSize.X,
        Text = text, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(1, 1, 1),
        ZIndex = 301, Parent = card,
    })
    Tween(card, { Position = UDim2.new(0.5, 0, 0, 16) }, 0.25)
    task.delay(1.9, function()
        if card.Parent then
            Tween(card, { Position = UDim2.new(0.5, 0, 0, -50) }, 0.25)
            task.delay(0.3, function() if card.Parent then card:Destroy() end end)
        end
    end)
end

-- маленькая круглая кнопка внутри строки списка
local function MiniBtn(parent, text, x, w, color, cb, left)
    local b = New("TextButton", {
        AnchorPoint = Vector2.new(left and 0 or 1, 0.5),
        Position = UDim2.new(left and 0 or 1, x, 0.5, 0),
        Size = UDim2.fromOffset(w, 22), BackgroundColor3 = color or Theme.Off, BorderSizePixel = 0,
        Text = text, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(1, 1, 1),
        AutoButtonColor = true, ZIndex = 2, Parent = parent,
    })
    Round(b, 11)
    b.Activated:Connect(function() if cb then cb(b) end end)
    return b
end

-- кнопка с подтверждением: первое нажатие "?", второе в течение 2 сек — действие
local function ConfirmBtn(parent, text, x, w, color, cb)
    local armedUntil = 0
    local b
    b = MiniBtn(parent, text, x, w, color, function()
        if tick() < armedUntil then
            armedUntil = 0
            b.Text = text
            cb()
            return
        end
        armedUntil = tick() + 2
        b.Text = "?"
        task.delay(2, function()
            if b.Parent then b.Text = text end
        end)
    end)
    return b
end

-- всплывающее меню возле кнопки: items = { {"текст", function() end}, ... }
local ActivePopup, ActivePopupConn
local function ClosePopup()
    if ActivePopupConn then ActivePopupConn:Disconnect(); ActivePopupConn = nil end
    if ActivePopup then ActivePopup:Destroy(); ActivePopup = nil end
end
OnUnload(ClosePopup)
local function PopupMenu(anchor, items)
    ClosePopup()
    if #items == 0 then return end
    local rowH = 26
    local h = math.min(#items * (rowH + 2) + 8, 220)
    local pos, size = anchor.AbsolutePosition, anchor.AbsoluteSize
    local vpY = MenuGui.AbsoluteSize.Y
    local y = pos.Y + size.Y + 2
    if y + h > vpY then y = math.max(4, pos.Y - h - 2) end
    local w = 150
    local pop = New("ScrollingFrame", {
        Position = UDim2.fromOffset(math.max(4, pos.X + size.X - w), y), Size = UDim2.fromOffset(w, h),
        BackgroundColor3 = Theme.Panel, BackgroundTransparency = 0.05, BorderSizePixel = 0,
        ScrollBarThickness = 3, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 200, Parent = MenuGui,
    })
    Round(pop, 8)
    Stroke(pop, Theme.Accent, 1, 0.5)
    New("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = pop })
    New("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = pop })
    for i, it in ipairs(items) do
        local b = New("TextButton", {
            Size = UDim2.new(1, 0, 0, rowH), BackgroundColor3 = Theme.Element, BackgroundTransparency = 0.4,
            BorderSizePixel = 0, Text = "  " .. it[1], TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.Text, AutoButtonColor = true,
            LayoutOrder = i, ZIndex = 201, Parent = pop,
        })
        Round(b, 6)
        b.Activated:Connect(function()
            ClosePopup()
            it[2]()
        end)
    end
    ActivePopup = pop
    ActivePopupConn = UserInputService.InputBegan:Connect(function(input)
        if IsPress(input) then
            task.delay(0.15, function()
                if ActivePopup == pop then ClosePopup() end
            end)
        end
    end)
end

-- убираем из списка "стекла" объекты, которые уже уничтожены
local function PruneGlass()
    for i = #GlassList, 1, -1 do
        if GlassList[i][1].Parent == nil then table.remove(GlassList, i) end
    end
end


local Presets = {
    Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 150, 255), Color3.fromRGB(119, 120, 255), Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(255, 130, 0), Color3.fromRGB(255, 105, 180), Color3.fromRGB(0, 255, 255),
    Color3.fromRGB(160, 0, 255), Color3.fromRGB(120, 120, 120), Color3.fromRGB(0, 0, 0),
}

local function CreateTab(name)
    local btn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = name, Font = Enum.Font.Gotham,
        TextSize = 13, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = (function() SideOrder = SideOrder + 1; return SideOrder end)(), Parent = Sidebar,
    })
    Round(btn, 7)
    New("UIPadding", { PaddingLeft = UDim.new(0, 14), Parent = btn })
    OnAccent(function() btn.BackgroundColor3 = Theme.Accent end)
    local bar = New("Frame", {
        Position = UDim2.new(0, -11, 0.5, -8), Size = UDim2.fromOffset(3, 16),
        BorderSizePixel = 0, Visible = false, Parent = btn,
    })
    Round(bar, 2)
    OnAccent(function() bar.BackgroundColor3 = Theme.Accent end)

    local page = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageTransparency = 0.3, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
        ElasticBehavior = Enum.ElasticBehavior.Never, Visible = false, Parent = Content,
    })
    OnAccent(function() page.ScrollBarImageColor3 = Theme.Accent end)
    New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page })
    New("UIPadding", { PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 6), Parent = page })

    local tab = { Btn = btn, Bar = bar, Page = page }
    Tabs[#Tabs + 1] = tab
    btn.Activated:Connect(function() SelectTab(tab) end)

    local P = {}
    local order = 0
    local function nextOrder()
        order = order + 1
        return order
    end
    local function Row(height, class)
        local r = New(class or "Frame", {
            Size = UDim2.new(1, 0, 0, height), BackgroundColor3 = Theme.Element,
            BorderSizePixel = 0, LayoutOrder = nextOrder(), Parent = page,
        })
        if class == "TextButton" then
            r.Text = ""
            r.AutoButtonColor = false
        end
        Glass(r, 0.45)
        Round(r, 8)
        return r
    end
    local function RowLabel(parent, text, reserve)
        return New("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 0),
            Size = UDim2.new(1, -(reserve or 70), 1, 0), Text = text, TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = parent,
        })
    end

    function P:Section(text)
        local f = New("Frame", {
            Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = nextOrder(), Parent = page,
        })
        local l = New("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(4, 4), Size = UDim2.new(1, -4, 1, -4),
            Text = text, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
            Parent = f,
        })
        OnAccent(function() l.TextColor3 = Theme.Accent end)
    end

    function P:Label(text)
        New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = text, TextWrapped = true,
            TextColor3 = Theme.Sub, Font = Enum.Font.Gotham, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
            LayoutOrder = nextOrder(), Parent = page,
        })
    end

    function P:Toggle(text, default, cb)
        local state = default and true or false
        local row = Row(36, "TextButton")
        RowLabel(row, text, 70)
        local track = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
            Size = UDim2.fromOffset(38, 20), BackgroundColor3 = Theme.Off, BorderSizePixel = 0, Parent = row,
        })
        Round(track, 10)
        local knob = New("Frame", {
            AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(14, 14),
            BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = track,
        })
        Round(knob, 7)
        local function render(t)
            Tween(track, { BackgroundColor3 = state and Theme.Accent or Theme.Off }, t)
            Tween(knob, { Position = state and UDim2.new(0, 21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) }, t)
        end
        OnAccent(function() render(0) end)
        row.Activated:Connect(function()
            state = not state
            render(0.15)
            if cb then cb(state) end
        end)
        return { Set = function(v) state = v and true or false; render(0) end }
    end

    function P:Slider(text, min, max, default, step, cb)
        local decimals = step >= 1 and 0 or (step >= 0.1 and 1 or 2)
        local fmt = "%." .. decimals .. "f"
        local value = default
        local row = Row(50)
        New("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 5), Size = UDim2.new(1, -90, 0, 18),
            Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
        })
        local valLabel = New("TextLabel", {
            BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 5),
            Size = UDim2.fromOffset(70, 18), Text = "", TextColor3 = Theme.Sub, Font = Enum.Font.GothamBold,
            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = row,
        })
        local hit = New("TextButton", {
            BackgroundTransparency = 1, Text = "", Position = UDim2.fromOffset(12, 26),
            Size = UDim2.new(1, -24, 0, 20), Parent = row,
        })
        local bar = New("Frame", {
            AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 6),
            BackgroundColor3 = Theme.Off, BorderSizePixel = 0, Parent = hit,
        })
        Round(bar, 3)
        local fill = New("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, Parent = bar })
        Round(fill, 3)
        OnAccent(function() fill.BackgroundColor3 = Theme.Accent end)
        local knob = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(14, 14),
            BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = bar,
        })
        Round(knob, 7)

        local function render()
            local a = (value - min) / (max - min)
            fill.Size = UDim2.fromScale(a, 1)
            knob.Position = UDim2.fromScale(a, 0.5)
            valLabel.Text = string.format(fmt, value)
        end
        local function set(v)
            v = math.clamp(math.floor((v - min) / step + 0.5) * step + min, min, max)
            v = tonumber(string.format(fmt, v))
            local changed = (v ~= value)
            value = v
            render()
            if changed and cb then cb(value) end
        end
        render()

        hit.InputBegan:Connect(function(input)
            if IsPress(input) then
                local function move(p)
                    set(min + math.clamp((p.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1) * (max - min))
                end
                move(input.Position)
                BeginDrag(move, page)
            end
        end)
    end

    function P:Selector(text, options, current, cb)
        local index = 1
        for i, opt in ipairs(options) do
            if opt[2] == current then index = i end
        end
        local row = Row(36, "TextButton")
        RowLabel(row, text, 140)
        local val = New("TextLabel", {
            BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 0),
            Size = UDim2.fromOffset(120, 36), Text = options[index][1], Font = Enum.Font.GothamBold,
            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = row,
        })
        OnAccent(function() val.TextColor3 = Theme.Accent end)
        row.Activated:Connect(function()
            index = index % #options + 1
            val.Text = options[index][1]
            if cb then cb(options[index][2]) end
        end)
    end

    function P:Button(text, color, cb)
        local b = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 36), Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold,
            TextSize = 13, BackgroundColor3 = color or Theme.Element, BorderSizePixel = 0,
            AutoButtonColor = true, LayoutOrder = nextOrder(), Parent = page,
        })
        Glass(b, 0.35)
        Round(b, 8)
        b.Activated:Connect(function()
            if cb then cb(b) end
        end)
        return b
    end

    function P:ColorPicker(text, default, cb)
        local color = default
        local h, s, v = Color3.toHSV(color)
        local box = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = nextOrder(), Parent = page,
        })
        New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = box })
        local head = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 36), Text = "", AutoButtonColor = false, BackgroundColor3 = Theme.Element,
            BorderSizePixel = 0, LayoutOrder = 1, Parent = box,
        })
        Glass(head, 0.45)
        Round(head, 8)
        RowLabel(head, text, 70)
        local swatch = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(36, 18),
            BackgroundColor3 = color, BorderSizePixel = 0, Parent = head,
        })
        Round(swatch, 5)
        Stroke(swatch, Color3.new(1, 1, 1), 1, 0.6)

        local built, open = false, false
        local body, sv, svCursor, hueCursor

        local function refresh(fire)
            color = Color3.fromHSV(h, s, v)
            swatch.BackgroundColor3 = color
            if built then
                sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svCursor.Position = UDim2.fromScale(s, 1 - v)
                hueCursor.Position = UDim2.fromScale(h, 0.5)
            end
            if fire and cb then cb(color) end
        end

        local function build()
            built = true
            body = New("Frame", {
                Size = UDim2.new(1, 0, 0, 166), BackgroundColor3 = Theme.Element, BorderSizePixel = 0,
                LayoutOrder = 2, Parent = box,
            })
            Glass(body, 0.45)
            Round(body, 8)

            sv = New("Frame", {
                Position = UDim2.fromOffset(10, 10), Size = UDim2.new(1, -20, 0, 98),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1), BorderSizePixel = 0, Parent = body,
            })
            Round(sv, 6)
            local white = New("Frame", {
                Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = sv,
            })
            Round(white, 6)
            New("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = white })
            local black = New("Frame", {
                Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = sv,
            })
            Round(black, 6)
            New("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0), Parent = black })
            svCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(10, 10),
                BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = sv,
            })
            Round(svCursor, 5)
            Stroke(svCursor, Color3.new(0, 0, 0), 1.5, 0)
            local svHit = New("TextButton", {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = sv,
            })
            svHit.InputBegan:Connect(function(input)
                if IsPress(input) then
                    local function move(p)
                        s = math.clamp((p.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp((p.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
                        refresh(true)
                    end
                    move(input.Position)
                    BeginDrag(move, page)
                end
            end)

            local hueBar = New("Frame", {
                Position = UDim2.fromOffset(10, 116), Size = UDim2.new(1, -20, 0, 14),
                BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = body,
            })
            Round(hueBar, 7)
            local kps = {}
            for i = 0, 6 do
                kps[#kps + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV((i % 6) / 6, 1, 1))
            end
            New("UIGradient", { Color = ColorSequence.new(kps), Parent = hueBar })
            hueCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(6, 18),
                BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = hueBar,
            })
            Round(hueCursor, 3)
            Stroke(hueCursor, Color3.new(0, 0, 0), 1.5, 0)
            local hueHit = New("TextButton", {
                Position = UDim2.fromOffset(0, -4), Size = UDim2.new(1, 0, 1, 8),
                BackgroundTransparency = 1, Text = "", Parent = hueBar,
            })
            hueHit.InputBegan:Connect(function(input)
                if IsPress(input) then
                    local function move(p)
                        h = math.clamp((p.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                        refresh(true)
                    end
                    move(input.Position)
                    BeginDrag(move, page)
                end
            end)

            local presetRow = New("Frame", {
                Position = UDim2.fromOffset(10, 140), Size = UDim2.new(1, -20, 0, 18),
                BackgroundTransparency = 1, Parent = body,
            })
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder, Parent = presetRow,
            })
            for i, col in ipairs(Presets) do
                local pb = New("TextButton", {
                    Size = UDim2.fromOffset(18, 18), BackgroundColor3 = col, Text = "", BorderSizePixel = 0,
                    AutoButtonColor = false, LayoutOrder = i, Parent = presetRow,
                })
                Round(pb, 5)
                Stroke(pb, Color3.new(1, 1, 1), 1, 0.7)
                pb.Activated:Connect(function()
                    h, s, v = Color3.toHSV(col)
                    refresh(true)
                end)
            end
        end

        head.Activated:Connect(function()
            if not built then build() end
            open = not open
            body.Visible = open
            refresh(false)
        end)

        return {
            Set = function(c, fire)
                h, s, v = Color3.toHSV(c)
                refresh(fire)
            end,
        }
    end

    -- ===== Rise Nexus: доп. элементы страницы =====
    function P:Input(text, placeholder, cb, opts)
        opts = opts or {}
        local h = opts.Height or 36
        local bw = opts.BoxWidth or 170
        local row = Row(h)
        RowLabel(row, text, bw + 24)
        local box = New("TextBox", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
            Size = UDim2.new(0, bw, 0, h - 10), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.5,
            BorderSizePixel = 0, Text = opts.Default or "", PlaceholderText = placeholder or "",
            PlaceholderColor3 = Theme.Sub, TextColor3 = Theme.Text,
            Font = opts.Mono and Enum.Font.Code or Enum.Font.Gotham, TextSize = 12, ClearTextOnFocus = false,
            MultiLine = opts.MultiLine and true or false, TextWrapped = opts.MultiLine and true or false,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = opts.MultiLine and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
            Parent = row,
        })
        Round(box, 6)
        New("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = box })
        if opts.Live then
            box:GetPropertyChangedSignal("Text"):Connect(function()
                if cb then cb(box.Text, false) end
            end)
        else
            box.FocusLost:Connect(function(enter)
                if cb then cb(box.Text, enter) end
            end)
        end
        return box, row
    end

    -- динамический список: L:Clear(), L:Row(h), L:Info(text)
    function P:List()
        local box = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = nextOrder(), Parent = page,
        })
        New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = box })
        local L = { Frame = box }
        local n = 0
        function L:Clear()
            for _, c in ipairs(box:GetChildren()) do
                if c:IsA("GuiObject") then c:Destroy() end
            end
            n = 0
            PruneGlass()
        end
        function L:Row(height)
            n = n + 1
            local r = New("Frame", {
                Size = UDim2.new(1, 0, 0, height or 34), BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0, LayoutOrder = n, Parent = box,
            })
            Glass(r, 0.45)
            Round(r, 8)
            return r
        end
        function L:Info(text, color)
            n = n + 1
            return New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = text, Font = Enum.Font.Gotham,
                TextSize = 12, TextColor3 = color or Theme.Sub, TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = n, Parent = box,
            })
        end
        return L
    end

    P.Page = page
    return P
end

-- ============================================================
-- СОДЕРЖИМОЕ ВКЛАДОК
-- ============================================================
local D = ESP.Drawing

-- ===== Основное =====
SideLabel("ESP")
local TabMain = CreateTab("Основное")
TabMain:Section("Общее")
TabMain:Toggle("ESP", ESP.Enabled, function(v) ESP.Enabled = v end)
TabMain:Toggle("Team Check (только враги)", ESP.TeamCheck, function(v) ESP.TeamCheck = v end)
TabMain:Toggle("Метка друг / враг", ESP.Options.Friendcheck, function(v) ESP.Options.Friendcheck = v end)
TabMain:Toggle("Fade по дистанции", ESP.FadeOut.OnDistance, function(v) ESP.FadeOut.OnDistance = v end)
TabMain:Section("Параметры")
TabMain:Slider("Макс. дистанция", 50, 2000, ESP.MaxDistance, 10, function(v) ESP.MaxDistance = v end)
TabMain:Slider("Размер шрифта", 8, 24, ESP.FontSize, 1, function(v) ESP.FontSize = v end)
TabMain:Label("RightShift — скрыть / показать меню.\nКнопка «–» сворачивает меню в кружок.")

-- ===== Визуалы =====
local TabVis = CreateTab("Визуалы")
TabVis:Section("Текст")
TabVis:Toggle("Ники", D.Names.Enabled, function(v) D.Names.Enabled = v end)
TabVis:Toggle("Дистанция", D.Distances.Enabled, function(v) D.Distances.Enabled = v end)
TabVis:Selector("Положение дистанции", { { "В нике", "Text" }, { "Снизу", "Bottom" } }, D.Distances.Position,
    function(v) D.Distances.Position = v end)
TabVis:Toggle("Оружие", D.Weapons.Enabled, function(v) D.Weapons.Enabled = v end)

TabVis:Section("Боксы")
TabVis:Toggle("Контур бокса", D.Boxes.Full.Enabled, function(v) D.Boxes.Full.Enabled = v end)
TabVis:Toggle("Уголки", D.Boxes.Corner.Enabled, function(v) D.Boxes.Corner.Enabled = v end)
TabVis:Toggle("Заливка бокса", D.Boxes.Filled.Enabled, function(v) D.Boxes.Filled.Enabled = v end)
TabVis:Slider("Прозрачность заливки", 0, 1, D.Boxes.Filled.Transparency, 0.05, function(v) D.Boxes.Filled.Transparency = v end)
TabVis:Toggle("Градиент заливки", D.Boxes.GradientFill, function(v) D.Boxes.GradientFill = v end)
TabVis:Toggle("Градиент контура", D.Boxes.Gradient, function(v) D.Boxes.Gradient = v end)
TabVis:Toggle("Анимация градиента", D.Boxes.Animate, function(v) D.Boxes.Animate = v end)
TabVis:Slider("Скорость анимации", 0, 800, D.Boxes.RotationSpeed, 10, function(v) D.Boxes.RotationSpeed = v end)

TabVis:Section("Хп бар")
TabVis:Toggle("Хп бар", D.Healthbar.Enabled, function(v) D.Healthbar.Enabled = v end)
TabVis:Toggle("Хп текст", D.Healthbar.HealthText, function(v) D.Healthbar.HealthText = v end)
TabVis:Toggle("Градиент хп бара", D.Healthbar.Gradient, function(v) D.Healthbar.Gradient = v end)
TabVis:Toggle("Цвет по здоровью", D.Healthbar.Lerp, function(v) D.Healthbar.Lerp = v end)
TabVis:Slider("Толщина бара", 1, 8, D.Healthbar.Width, 0.5, function(v) D.Healthbar.Width = v end)

TabVis:Section("Chams")
TabVis:Toggle("Chams (Highlight)", D.Chams.Enabled, function(v) D.Chams.Enabled = v end)
TabVis:Toggle("Мигание персонажа", D.Chams.Thermal, function(v) D.Chams.Thermal = v end)
TabVis:Toggle("Только видимые части", D.Chams.VisibleCheck, function(v) D.Chams.VisibleCheck = v end)
TabVis:Slider("Прозрачность заливки", 0, 1, D.Chams.Fill_Transparency, 0.05, function(v) D.Chams.Fill_Transparency = v end)
TabVis:Slider("Прозрачность контура", 0, 1, D.Chams.Outline_Transparency, 0.05, function(v) D.Chams.Outline_Transparency = v end)

-- ===== Цвета =====
local TabCol = CreateTab("Цвета")
local pickers = {}
local function CP(text, get, set)
    local p = TabCol:ColorPicker(text, get(), set)
    pickers[#pickers + 1] = { p = p, get = get }
end

TabCol:Section("Быстро")
TabCol:ColorPicker("Все элементы", D.Chams.FillRGB, function(c)
    local B, H = D.Boxes, D.Healthbar
    B.Full.RGB = c; B.Corner.RGB = c
    B.GradientRGB1 = c; B.GradientRGB2 = c
    B.GradientFillRGB1 = c; B.GradientFillRGB2 = c
    D.Names.RGB = c
    D.Chams.FillRGB = c; D.Chams.OutlineRGB = c
    D.Distances.RGB = c
    D.Weapons.WeaponTextRGB = c
    H.HealthTextRGB = c
    H.GradientRGB1 = c; H.GradientRGB2 = c; H.GradientRGB3 = c
    for _, e in ipairs(pickers) do e.p.Set(e.get(), false) end
end)

TabCol:Section("Текст")
CP("Ники", function() return D.Names.RGB end, function(c) D.Names.RGB = c end)
CP("Дистанция", function() return D.Distances.RGB end, function(c) D.Distances.RGB = c end)
CP("Оружие", function() return D.Weapons.WeaponTextRGB end, function(c) D.Weapons.WeaponTextRGB = c end)
CP("Метка: друг", function() return ESP.Options.FriendcheckRGB end, function(c) ESP.Options.FriendcheckRGB = c end)
CP("Метка: враг", function() return ESP.Options.EnemyRGB end, function(c) ESP.Options.EnemyRGB = c end)

TabCol:Section("Бокс")
CP("Контур бокса", function() return D.Boxes.Full.RGB end, function(c) D.Boxes.Full.RGB = c end)
CP("Уголки", function() return D.Boxes.Corner.RGB end, function(c) D.Boxes.Corner.RGB = c end)
CP("Заливка (без градиента)", function() return D.Boxes.Filled.RGB end, function(c) D.Boxes.Filled.RGB = c end)
CP("Градиент заливки: цвет 1", function() return D.Boxes.GradientFillRGB1 end, function(c) D.Boxes.GradientFillRGB1 = c end)
CP("Градиент заливки: цвет 2", function() return D.Boxes.GradientFillRGB2 end, function(c) D.Boxes.GradientFillRGB2 = c end)
CP("Градиент контура: цвет 1", function() return D.Boxes.GradientRGB1 end, function(c) D.Boxes.GradientRGB1 = c end)
CP("Градиент контура: цвет 2", function() return D.Boxes.GradientRGB2 end, function(c) D.Boxes.GradientRGB2 = c end)

TabCol:Section("Хп бар")
CP("Хп текст", function() return D.Healthbar.HealthTextRGB end, function(c) D.Healthbar.HealthTextRGB = c end)
CP("Градиент хп: низ", function() return D.Healthbar.GradientRGB1 end, function(c) D.Healthbar.GradientRGB1 = c end)
CP("Градиент хп: середина", function() return D.Healthbar.GradientRGB2 end, function(c) D.Healthbar.GradientRGB2 = c end)
CP("Градиент хп: верх", function() return D.Healthbar.GradientRGB3 end, function(c) D.Healthbar.GradientRGB3 = c end)

TabCol:Section("Chams")
CP("Заливка персонажа", function() return D.Chams.FillRGB end, function(c) D.Chams.FillRGB = c end)
CP("Контур персонажа", function() return D.Chams.OutlineRGB end, function(c) D.Chams.OutlineRGB = c end)

-- ============================================================
-- МОДУЛЬ: MUSIC  (логика Rise Radio: библиотека / каталог / импорт)
-- Данные совместимы с Rise: MM2Radio_v11.json, MM2Radio_Broken.json
-- ============================================================
SideLabel("MUSIC")
do
    local HttpService = Service("HttpService")
    local RS = Service("ReplicatedStorage")
    local MPS = Service("MarketplaceService")
    local AssetService = Service("AssetService")
    local SoundService = Service("SoundService")
    local ContentProvider = Service("ContentProvider")

    local SAVE_FILE, BROKEN_FILE = "MM2Radio_v11.json", "MM2Radio_Broken.json"
    local Cfg = { showOriginal = false, autoImport = false, searchEng = "catalog" }
    local Songs, Lists = {}, {}
    local TabMeta = {
        { id = "all", label = "all", builtin = true },
        { id = "new", label = "new", builtin = true },
        { id = "phonk", label = "phonk" }, { id = "ru", label = "ru" }, { id = "en", label = "en" },
        { id = "gazan", label = "gazan" }, { id = "molli", label = "molli" }, { id = "memes", label = "memes" },
        { id = "short", label = "short" }, { id = "other", label = "other" },
    }
    local SEED = {
        { "114276461896688", "фонк", "phonk" }, { "117499298661785", "фонк 2", "phonk" },
        { "121242462527636", "прикольный фонк", "phonk" },
        { "91668250502992", "морген мы с тобой дети 90", "ru" }, { "93602974995833", "18 мне уже", "ru" },
        { "131245885742260", "t.a.t.u нас не догонят", "ru" }, { "74865649597403", "РАША РАША", "ru" },
        { "128291940309861", "чудной", "ru" }, { "129898761032889", "розовое вино", "ru" },
        { "139344691622468", "Buzova — я хочу", "ru" },
        { "91007045451630", "under your spell", "en" }, { "88523902860927", "unhappy", "en" },
        { "82238396227577", "slaughter house", "en" },
        { "76776089178278", "Газан тяги", "gazan" }, { "94521112852370", "пошлая молли", "molli" },
        { "121239777513594", "прикол", "memes" }, { "83712066133001", "cachalot", "short" },
        { "79359688008346", "хз название", "other" },
    }
    for _, s in ipairs(SEED) do
        Songs[s[1]] = { id = s[1], name = s[2], robloxName = s[2], cat = s[3], lang = "ru", imported = false }
        Lists[s[3]] = Lists[s[3]] or {}
        table.insert(Lists[s[3]], s[1])
        Lists.new = Lists.new or {}
        table.insert(Lists.new, s[1])
    end

    local function rebuildAll()
        local all = {}
        for id in pairs(Songs) do all[#all + 1] = id end
        table.sort(all, function(a, b)
            return tostring(Songs[a].name):lower() < tostring(Songs[b].name):lower()
        end)
        Lists.all = all
    end
    rebuildAll()

    local function saveAll()
        pcall(function()
            if writefile then
                writefile(SAVE_FILE, HttpService:JSONEncode({ cfg = Cfg, songs = Songs, tabs = Lists, tabMeta = TabMeta }))
            end
        end)
    end
    pcall(function()
        if isfile and readfile and isfile(SAVE_FILE) then
            local d = HttpService:JSONDecode(readfile(SAVE_FILE))
            if type(d.cfg) == "table" then
                for _, k in ipairs({ "showOriginal", "autoImport", "searchEng" }) do
                    if d.cfg[k] ~= nil then Cfg[k] = d.cfg[k] end
                end
            end
            if type(d.songs) == "table" then Songs = d.songs end
            if type(d.tabs) == "table" then Lists = d.tabs end
            if type(d.tabMeta) == "table" then TabMeta = d.tabMeta end
            if Cfg.searchEng ~= "id" then Cfg.searchEng = "catalog" end
            rebuildAll()
        end
    end)

    -- ремоуты MM2 (ищем в фоне, в других играх их просто не будет)
    local PlaySong, SaveSong
    task.spawn(function()
        pcall(function()
            local r = RS:WaitForChild("Remotes", 8)
            local inv = r and r:WaitForChild("Inventory", 8)
            if inv then
                PlaySong = inv:FindFirstChild("PlaySong")
                SaveSong = inv:FindFirstChild("SaveSong")
            end
        end)
    end)

    local function idToUrl(id) return "https://www.roblox.com/asset/?id=" .. tostring(id) end
    local function radioPlay(id)
        if not PlaySong then Toast("PlaySong не найден (не MM2?)", "bad") return end
        pcall(function() PlaySong:FireServer(idToUrl(id)) end)
    end

    local prv = Instance.new("Sound")
    prv.Name = "RadioPreview"
    prv.Volume = 0.5
    prv.Parent = Service("SoundService")
    local prvId
    local function radioStop()
        if PlaySong then pcall(function() PlaySong:FireServer("") end) end
        prv:Stop()
        prvId = nil
    end
    local function prvToggle(id)
        if prvId == id and prv.IsPlaying then
            prv:Stop()
            prvId = nil
            return
        end
        prvId = id
        prv.SoundId = "rbxassetid://" .. tostring(id)
        prv:Play()
    end
    OnUnload(function() pcall(function() prv:Stop(); prv:Destroy() end) end)

    local nameCache = {}
    local function robloxNameFor(id)
        if nameCache[id] then return nameCache[id] end
        local ok, info = pcall(function() return MPS:GetProductInfo(tonumber(id), Enum.InfoType.Asset) end)
        if ok and info and info.Name then
            nameCache[id] = info.Name
            return info.Name
        end
        return nil
    end

    local function trySaveSong(id, name)
        if not SaveSong then return false end
        return (pcall(function() SaveSong:FireServer(idToUrl(id), name) end))
    end

    local function addSong(id, name, tabId)
        if not Songs[id] then
            Songs[id] = {
                id = id, name = name or ("song " .. id), robloxName = name or ("song " .. id),
                lang = "ru", imported = false, cat = tabId or "new",
            }
        end
        for _, t in ipairs({ tabId or "new", "new" }) do
            Lists[t] = Lists[t] or {}
            if not table.find(Lists[t], id) then table.insert(Lists[t], id) end
        end
        rebuildAll()
        saveAll()
    end

    -- ===== импорт (перехват PlaySong.OnClientEvent) =====
    local importing, importConn = false, nil
    local tempImported, sessionSeen, importCount = {}, {}, 0
    local renderImport
    local function extractId(str)
        if type(str) ~= "string" or str == "" then return nil end
        if str:match("rbxasset://sounds") then return nil end
        local id = str:match("id=(%d+)") or str:match("rbxassetid://(%d+)") or str:match("^(%d+)$")
        if id and #id >= 5 then return id end
        return nil
    end
    local function importToTemp(id)
        if Songs[id] or tempImported[id] or sessionSeen[id] then return end
        sessionSeen[id] = true
        importCount = importCount + 1
        task.spawn(function()
            local rn = robloxNameFor(id)
            tempImported[id] = { id = id, name = rn or ("song " .. id), robloxName = rn or ("song " .. id) }
            if renderImport then renderImport() end
        end)
    end
    local function startImport()
        if importing then return end
        if not (PlaySong and PlaySong.OnClientEvent) then
            Toast("PlaySong не найден", "bad")
            return
        end
        importing = true
        importConn = PlaySong.OnClientEvent:Connect(function(...)
            for _, a in ipairs({ ... }) do
                if type(a) == "string" then
                    local id = extractId(a)
                    if id then importToTemp(id) end
                end
            end
        end)
    end
    local function stopImport()
        importing = false
        if importConn then importConn:Disconnect(); importConn = nil end
    end
    OnUnload(stopImport)

    -- ===== скан нерабочих треков =====
    local BrokenTracks, scanning = {}, false
    pcall(function()
        if isfile and readfile and isfile(BROKEN_FILE) then
            local d = HttpService:JSONDecode(readfile(BROKEN_FILE))
            if type(d) == "table" then BrokenTracks = d end
        end
    end)
    local function saveBroken()
        pcall(function() if writefile then writefile(BROKEN_FILE, HttpService:JSONEncode(BrokenTracks)) end end)
    end
    local function scanForBroken(progressCb, doneCb)
        if scanning then return end
        scanning = true
        task.spawn(function()
            local ids = {}
            for id in pairs(Songs) do ids[#ids + 1] = id end
            for i, id in ipairs(ids) do
                local snd = Instance.new("Sound")
                snd.SoundId = "rbxassetid://" .. id
                local status
                pcall(function()
                    ContentProvider:PreloadAsync({ snd }, function(_, fetchStatus) status = fetchStatus end)
                end)
                BrokenTracks[id] = (status == Enum.AssetFetchStatus.Failure) and true or nil
                snd:Destroy()
                if progressCb then progressCb(i, #ids) end
                task.wait(0.03)
            end
            saveBroken()
            scanning = false
            if doneCb then doneCb() end
        end)
    end

    -- ===== каталог =====
    local function collectPage(pages, out)
        local pageData = pages and pages:GetCurrentPage()
        if pageData then
            for _, it in ipairs(pageData) do
                local sid = it.Id or it.id
                local sn = it.Title or it.title or it.Name or it.name
                if sid then table.insert(out, { id = tostring(sid), name = sn or ("asset " .. tostring(sid)) }) end
            end
        end
    end
    local function catalogSearch(q)
        local results = {}
        if Cfg.searchEng == "id" then
            local cleanId = q:match("(%d+)")
            if cleanId then table.insert(results, { id = cleanId, name = robloxNameFor(cleanId) or ("song " .. cleanId) }) end
            return results
        end
        pcall(function()
            local params = Instance.new("AudioSearchParams")
            params.SearchKeyword = q
            collectPage(AssetService:SearchAudio(params), results)
        end)
        if #results == 0 then
            pcall(function()
                local params = Instance.new("AudioSearchParams")
                params.SearchKeyword = q
                collectPage(AssetService:SearchAudioAsync(params), results)
            end)
        end
        if #results == 0 and q:match("^%d+$") then
            table.insert(results, { id = q, name = robloxNameFor(q) or ("song " .. q) })
        end
        return results
    end

    -- ==================== UI: Радио ====================
    local curTab, filterQ = "all", ""
    local renderRadio, renderBroken

    local TabRadio = CreateTab("Радио")
    TabRadio:Section("Управление")
    TabRadio:Button("■  Остановить радио", Color3.fromRGB(150, 50, 50), function() radioStop() end)
    TabRadio:Toggle("Показывать имена Roblox", Cfg.showOriginal, function(v)
        Cfg.showOriginal = v
        saveAll()
        renderRadio()
    end)

    TabRadio:Section("Вкладки")
    local swList = TabRadio:List()
    local swRow = swList:Row(36)
    local swLbl = New("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.fromOffset(44, 0), Size = UDim2.new(1, -88, 1, 0),
        Text = "", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text, Parent = swRow,
    })
    local function metaIndex()
        for i, m in ipairs(TabMeta) do
            if m.id == curTab then return i end
        end
        return 1
    end
    local function step(d)
        local i = (metaIndex() - 1 + d) % #TabMeta + 1
        curTab = TabMeta[i].id
        renderRadio()
    end
    MiniBtn(swRow, "‹", 8, 28, Theme.Off, function() step(-1) end, true)
    MiniBtn(swRow, "›", -8, 28, Theme.Off, function() step(1) end)

    local newTabBox
    newTabBox = TabRadio:Input("Новая вкладка", "название...", function(t, enter)
        if not enter then return end
        local id = (t:gsub("%s+", "_"))
        if id == "" then return end
        for _, m in ipairs(TabMeta) do
            if m.id == id then id = id .. "_" .. math.random(99) end
        end
        table.insert(TabMeta, { id = id, label = id })
        Lists[id] = {}
        curTab = id
        newTabBox.Text = ""
        saveAll()
        renderRadio()
    end, { BoxWidth = 150 })

    local delArmed = 0
    TabRadio:Button("Удалить текущую вкладку", nil, function(b)
        local i = metaIndex()
        local m = TabMeta[i]
        if m.builtin then
            Toast("Встроенную вкладку удалить нельзя", "bad")
            return
        end
        if tick() > delArmed then
            delArmed = tick() + 2
            b.Text = "Нажми ещё раз: удалить «" .. m.label .. "»"
            task.delay(2, function() b.Text = "Удалить текущую вкладку" end)
            return
        end
        delArmed = 0
        b.Text = "Удалить текущую вкладку"
        table.remove(TabMeta, i)
        Lists[m.id] = nil
        curTab = "all"
        saveAll()
        renderRadio()
    end)

    TabRadio:Section("Треки")
    TabRadio:Input("Фильтр", "название или ID...", function(t)
        filterQ = t
        renderRadio()
    end, { Live = true, BoxWidth = 180 })
    local radioList = TabRadio:List()

    local function songRow(id, s)
        local display = (Cfg.showOriginal and s.robloxName) or s.name
        local row = radioList:Row(34)
        local nm = New("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -172, 1, 0),
            Text = tostring(display), TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
        })
        ConfirmBtn(row, "✕", -6, 22, Color3.fromRGB(150, 50, 50), function()
            Songs[id] = nil
            for _, t in pairs(Lists) do
                for i = #t, 1, -1 do
                    if t[i] == id then table.remove(t, i) end
                end
            end
            rebuildAll()
            saveAll()
            renderRadio()
        end)
        MiniBtn(row, "⊕", -32, 22, Theme.Off, function(b)
            local items = {}
            for _, m in ipairs(TabMeta) do
                if m.id ~= "all" then
                    table.insert(items, { m.label, function()
                        Lists[m.id] = Lists[m.id] or {}
                        if not table.find(Lists[m.id], id) then
                            table.insert(Lists[m.id], id)
                            saveAll()
                        end
                        Toast("Добавлено в " .. m.label, "ok")
                        renderRadio()
                    end })
                end
            end
            PopupMenu(b, items)
        end)
        MiniBtn(row, "✎", -58, 22, Theme.Off, function()
            local box = New("TextBox", {
                Position = nm.Position, Size = nm.Size, BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.4, Text = s.name, TextColor3 = Theme.Text, Font = Enum.Font.Gotham,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
                BorderSizePixel = 0, ZIndex = 5, Parent = row,
            })
            Round(box, 6)
            box.FocusLost:Connect(function()
                if box.Text ~= "" then
                    s.name = box.Text
                    saveAll()
                end
                renderRadio()
            end)
            box:CaptureFocus()
        end)
        MiniBtn(row, "⤓", -84, 22, Color3.fromRGB(180, 150, 40), function()
            local okExp = trySaveSong(id, s.name)
            Toast(okExp and "Экспортировано в геймпасс" or "Ошибка экспорта", okExp and "ok" or "bad")
        end)
        MiniBtn(row, "♪", -110, 22, Theme.Off, function() prvToggle(id) end)
        MiniBtn(row, "▶", -136, 22, Theme.Accent, function() radioPlay(id) end)
    end

    renderRadio = function()
        radioList:Clear()
        local m = TabMeta[metaIndex()]
        swLbl.Text = m.label .. "  ·  " .. #(Lists[m.id] or {})
        local q = filterQ:lower()
        local seen, shown, total = {}, 0, 0
        for _, id in ipairs(Lists[curTab] or {}) do
            local s = Songs[id]
            if s and not seen[id] then
                seen[id] = true
                local hay = (tostring(s.name) .. " " .. tostring(s.robloxName or "") .. " " .. id):lower()
                if q == "" or hay:find(q, 1, true) then
                    total = total + 1
                    if shown < 200 then
                        shown = shown + 1
                        songRow(id, s)
                    end
                end
            end
        end
        if total == 0 then
            radioList:Info(q ~= "" and "Ничего не найдено" or "Пусто")
        elseif total > shown then
            radioList:Info("Показано " .. shown .. " из " .. total .. " — уточни фильтр")
        end
    end

    -- ==================== UI: Каталог / Импорт ====================
    local TabCat = CreateTab("Каталог")
    TabCat:Section("Поиск треков")
    TabCat:Selector("Источник", { { "Каталог", "catalog" }, { "Asset ID", "id" } }, Cfg.searchEng, function(v)
        Cfg.searchEng = v
        saveAll()
    end)
    local resultsList
    local function doSearch(q)
        if q == "" then Toast("Введи запрос") return end
        resultsList:Clear()
        resultsList:Info("Ищу...")
        task.spawn(function()
            local results = catalogSearch(q)
            resultsList:Clear()
            if #results == 0 then
                resultsList:Info("Ничего не найдено")
                return
            end
            resultsList:Info("Найдено: " .. #results)
            for _, r in ipairs(results) do
                local row = resultsList:Row(34)
                New("TextLabel", {
                    BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -120, 1, 0),
                    Text = tostring(r.name) .. " · #" .. r.id, TextColor3 = Theme.Text, Font = Enum.Font.Gotham,
                    TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
                })
                MiniBtn(row, "+", -6, 26, Color3.fromRGB(40, 150, 90), function()
                    addSong(r.id, r.name, "new")
                    Toast("Добавлено", "ok")
                    renderRadio()
                end)
                MiniBtn(row, "♪", -36, 26, Theme.Off, function() prvToggle(r.id) end)
                MiniBtn(row, "▶", -66, 26, Theme.Accent, function() radioPlay(r.id) end)
            end
        end)
    end
    local qBox = TabCat:Input("Запрос", "название или ID...", function(t, enter)
        if enter then doSearch(t) end
    end, { BoxWidth = 200 })
    TabCat:Button("Искать", nil, function() doSearch(qBox.Text) end)
    resultsList = TabCat:List()

    TabCat:Section("Импорт (перехват треков из игры)")
    TabCat:Toggle("Слушать PlaySong", importing, function(v)
        if v then startImport() else stopImport() end
        renderImport()
    end)
    TabCat:Toggle("Авто-импорт при запуске", Cfg.autoImport, function(v)
        Cfg.autoImport = v
        saveAll()
    end)
    TabCat:Button("+ Добавить все пойманные", nil, function()
        local n = 0
        for id, t in pairs(tempImported) do
            if not Songs[id] then
                Songs[id] = { id = id, name = t.name, robloxName = t.robloxName or t.name, lang = "ru", imported = true, cat = "new" }
                Lists.new = Lists.new or {}
                table.insert(Lists.new, id)
                n = n + 1
            end
            tempImported[id] = nil
        end
        rebuildAll()
        saveAll()
        Toast("Добавлено: " .. n, "ok")
        renderImport()
        renderRadio()
    end)
    TabCat:Button("Очистить список", nil, function()
        tempImported, sessionSeen, importCount = {}, {}, 0
        renderImport()
    end)
    local impList = TabCat:List()
    renderImport = function()
        impList:Clear()
        local any = false
        for id, t in pairs(tempImported) do
            any = true
            local row = impList:Row(32)
            New("TextLabel", {
                BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -150, 1, 0),
                Text = tostring(t.name) .. "  #" .. id, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
            })
            MiniBtn(row, "✕", -6, 22, Color3.fromRGB(150, 50, 50), function()
                tempImported[id] = nil
                renderImport()
            end)
            MiniBtn(row, "+", -32, 22, Color3.fromRGB(40, 150, 90), function()
                if not Songs[id] then
                    Songs[id] = { id = id, name = t.name, robloxName = t.robloxName or t.name, lang = "ru", imported = true, cat = "new" }
                    Lists.new = Lists.new or {}
                    table.insert(Lists.new, id)
                    rebuildAll()
                    saveAll()
                end
                tempImported[id] = nil
                Toast("Добавлено", "ok")
                renderImport()
                renderRadio()
            end)
            MiniBtn(row, "⤓", -58, 22, Color3.fromRGB(180, 150, 40), function()
                local okExp = trySaveSong(id, t.name)
                Toast(okExp and "Экспортировано" or "Ошибка экспорта", okExp and "ok" or "bad")
            end)
            MiniBtn(row, "♪", -84, 22, Theme.Off, function() prvToggle(id) end)
            MiniBtn(row, "▶", -110, 22, Theme.Accent, function() radioPlay(id) end)
        end
        if not any then
            impList:Info(importing and ("Слушаю... поймано: " .. importCount) or "Пока пусто")
        end
    end

    TabCat:Section("Нерабочие треки")
    TabCat:Button("Сканировать библиотеку", nil, function(b)
        b.Text = "0/0"
        scanForBroken(function(i, total) b.Text = i .. "/" .. total end, function()
            b.Text = "Сканировать библиотеку"
            renderBroken()
        end)
    end)
    local brokenList = TabCat:List()
    renderBroken = function()
        brokenList:Clear()
        local any = false
        for id in pairs(BrokenTracks) do
            local s = Songs[id]
            if s then
                any = true
                local row = brokenList:Row(32)
                New("TextLabel", {
                    BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -80, 1, 0),
                    Text = tostring(s.name), TextColor3 = Color3.fromRGB(255, 120, 120), Font = Enum.Font.Gotham,
                    TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
                })
                MiniBtn(row, "✕", -6, 22, Color3.fromRGB(150, 50, 50), function()
                    Songs[id] = nil
                    BrokenTracks[id] = nil
                    for _, t in pairs(Lists) do
                        for i = #t, 1, -1 do
                            if t[i] == id then table.remove(t, i) end
                        end
                    end
                    rebuildAll()
                    saveAll()
                    saveBroken()
                    renderBroken()
                    renderRadio()
                end)
                MiniBtn(row, "✓", -32, 22, Theme.Off, function()
                    BrokenTracks[id] = nil
                    saveBroken()
                    renderBroken()
                end)
            end
        end
        if not any then brokenList:Info("Нерабочих треков нет") end
    end

    renderRadio()
    renderImport()
    renderBroken()
    if Cfg.autoImport then
        task.delay(4, startImport)
    end
end


-- ============================================================
-- МОДУЛЬ: TOOLS  (Rise Scripts + Rise Servers)
-- Файлы совместимы с Rise: Script.Loader.N.txt, RiseLoader.Folders.json, RiseLoader.Servers.json
-- ============================================================
SideLabel("TOOLS")
do
    local HttpService = Service("HttpService")
    local TeleportService = Service("TeleportService")
    local WORKSPACE_PATH = "/storage/emulated/0/Delta/Workspace"

    local function getBaseName(path) return (path:match("([^/\\]+)$")) or path end
    local function listWorkspaceFiles()
        local ok, files = pcall(function() return listfiles("") end)
        if not ok or type(files) ~= "table" then
            ok, files = pcall(function() return listfiles(WORKSPACE_PATH) end)
        end
        if not ok or type(files) ~= "table" then return {} end
        return files
    end
    local function safeWrite(name, data)
        local ok = pcall(function() writefile(name, data) end)
        if not ok then pcall(function() writefile(WORKSPACE_PATH .. "/" .. name, data) end) end
    end
    local function safeRead(name)
        local ok, content = pcall(function() return readfile(name) end)
        if not ok or content == nil then
            ok, content = pcall(function() return readfile(WORKSPACE_PATH .. "/" .. name) end)
        end
        if ok then return content end
        return nil
    end
    local function safeDelete(name)
        local ok = pcall(function() delfile(name) end)
        if not ok then pcall(function() delfile(WORKSPACE_PATH .. "/" .. name) end) end
    end
    local function loadJson(name, default)
        local raw = safeRead(name)
        if raw then
            local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok and type(decoded) == "table" then return decoded end
        end
        return default
    end

    -- ==================== SCRIPTS ====================
    local FOLDERS_FILE = "RiseLoader.Folders.json"
    local Folders = loadJson(FOLDERS_FILE, {})
    local function saveFolders() safeWrite(FOLDERS_FILE, HttpService:JSONEncode(Folders)) end

    local function nextNumber(pattern)
        local max = 0
        for _, entry in ipairs(listWorkspaceFiles()) do
            local num = getBaseName(entry):match(pattern)
            if num and tonumber(num) > max then max = tonumber(num) end
        end
        return max + 1
    end
    local function loadAllScriptFiles()
        local result = {}
        for _, entryPath in ipairs(listWorkspaceFiles()) do
            local base = getBaseName(entryPath)
            if base:match("^Script%.Loader%.%d+%.txt$") then
                local content = safeRead(base)
                if content then
                    local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
                    if ok and type(data) == "table" and data.name and data.code then
                        table.insert(result, { filename = base, name = data.name, code = data.code, folderId = data.folderId or "root" })
                    end
                end
            end
        end
        return result
    end

    local currentFolder = "root"
    local renderScripts
    local TabScripts = CreateTab("Скрипты")
    TabScripts:Section("Мои скрипты")
    local scriptList = TabScripts:List()

    TabScripts:Section("Добавить")
    local folderBox
    folderBox = TabScripts:Input("Новая папка", "название...", function(t, enter)
        if not enter or t == "" then return end
        table.insert(Folders, { id = HttpService:GenerateGUID(false), name = t })
        saveFolders()
        folderBox.Text = ""
        renderScripts()
        Toast("Папка создана", "ok")
    end, { BoxWidth = 170 })
    local nameBox = TabScripts:Input("Название скрипта", "Script Name...", nil, { BoxWidth = 170 })
    local codeBox = TabScripts:Input("Код", "loadstring(game:HttpGet(...))()", nil,
        { BoxWidth = 250, Height = 84, MultiLine = true, Mono = true })
    TabScripts:Button("+ Добавить скрипт в текущую папку", nil, function()
        local name, code = nameBox.Text, codeBox.Text
        if name == "" or code == "" then
            Toast("Введи название и код", "bad")
            return
        end
        local num = nextNumber("^Script%.Loader%.(%d+)%.txt$")
        safeWrite("Script.Loader." .. num .. ".txt", HttpService:JSONEncode({ name = name, code = code, folderId = currentFolder }))
        nameBox.Text, codeBox.Text = "", ""
        renderScripts()
        Toast("Скрипт добавлен", "ok")
    end)

    renderScripts = function()
        scriptList:Clear()
        if currentFolder ~= "root" then
            local fname = "?"
            for _, f in ipairs(Folders) do
                if f.id == currentFolder then fname = f.name end
            end
            local head = scriptList:Row(34)
            New("TextLabel", {
                BackgroundTransparency = 1, Position = UDim2.fromOffset(82, 0), Size = UDim2.new(1, -90, 1, 0),
                Text = "📁 " .. fname, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = head,
            })
            MiniBtn(head, "‹ Root", 8, 66, Theme.Off, function()
                currentFolder = "root"
                renderScripts()
            end, true)
        else
            for _, f in ipairs(Folders) do
                local row = scriptList:Row(38)
                local open = New("TextButton", {
                    BackgroundTransparency = 1, Size = UDim2.new(1, -44, 1, 0), Text = "📁  " .. f.name,
                    Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
                })
                New("UIPadding", { PaddingLeft = UDim.new(0, 12), Parent = open })
                open.Activated:Connect(function()
                    currentFolder = f.id
                    renderScripts()
                end)
                ConfirmBtn(row, "✕", -8, 26, Color3.fromRGB(150, 50, 50), function()
                    for i, ff in ipairs(Folders) do
                        if ff.id == f.id then table.remove(Folders, i) break end
                    end
                    saveFolders()
                    -- скрипты из удалённой папки возвращаются в корень
                    for _, s in ipairs(loadAllScriptFiles()) do
                        if s.folderId == f.id then
                            safeWrite(s.filename, HttpService:JSONEncode({ name = s.name, code = s.code, folderId = "root" }))
                        end
                    end
                    renderScripts()
                end)
            end
            -- встроенная кнопка Rise (как в оригинале)
            local riseRow = scriptList:Row(38)
            local riseBtn = New("TextButton", {
                BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "Rise loader",
                Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Theme.Accent, Parent = riseRow,
            })
            riseBtn.Activated:Connect(function()
                Toast("Запускаю Rise...")
                task.spawn(function()
                    local ok, err = pcall(function()
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/joshhhie/rise/refs/heads/main/loader.lua"))()
                    end)
                    if not ok then Toast("Ошибка: " .. tostring(err):sub(1, 60), "bad") end
                end)
            end)
        end

        for _, s in ipairs(loadAllScriptFiles()) do
            if s.folderId == currentFolder then
                local row = scriptList:Row(38)
                local run = New("TextButton", {
                    BackgroundTransparency = 1, Size = UDim2.new(1, -44, 1, 0), Text = "▶  " .. s.name,
                    Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
                })
                New("UIPadding", { PaddingLeft = UDim.new(0, 12), Parent = run })
                run.Activated:Connect(function()
                    task.spawn(function()
                        local fn, cerr = loadstring(s.code)
                        if not fn then
                            Toast("Ошибка кода: " .. tostring(cerr):sub(1, 60), "bad")
                            return
                        end
                        local ok, err = pcall(fn)
                        if not ok then Toast("Ошибка: " .. tostring(err):sub(1, 60), "bad") end
                    end)
                end)
                ConfirmBtn(row, "✕", -8, 26, Color3.fromRGB(150, 50, 50), function()
                    -- как в Rise: копия удалённого уходит в ScriptHasDelte.Loader.N.txt
                    local c = safeRead(s.filename)
                    if c then safeWrite("ScriptHasDelte.Loader." .. nextNumber("^ScriptHasDelte%.Loader%.(%d+)%.txt$") .. ".txt", c) end
                    safeDelete(s.filename)
                    renderScripts()
                end)
            end
        end
    end
    renderScripts()

    -- ==================== SERVERS ====================
    local SERVERS_FILE = "RiseLoader.Servers.json"
    local Store = loadJson(SERVERS_FILE, {})
    local function saveServers() safeWrite(SERVERS_FILE, HttpService:JSONEncode(Store)) end
    local CurrentJobId, PlaceId = game.JobId, game.PlaceId

    local renderServers
    local TabServers = CreateTab("Серверы")
    TabServers:Section("Сохранённые серверы")
    TabServers:Button("+ Сохранить текущий сервер", nil, function()
        local names = {}
        for _, plr in ipairs(Players:GetPlayers()) do table.insert(names, plr.Name) end
        local found = false
        for _, e in ipairs(Store) do
            if e.JobId == CurrentJobId then
                e.Players, e.SavedAt, found = names, os.time(), true
            end
        end
        if not found then
            table.insert(Store, 1, { JobId = CurrentJobId, PlaceId = PlaceId, Players = names, SavedAt = os.time() })
        end
        saveServers()
        renderServers()
        Toast("Сервер сохранён", "ok")
    end)
    local serverList = TabServers:List()

    renderServers = function()
        serverList:Clear()
        if #Store == 0 then
            serverList:Info("Список пуст")
            return
        end
        for _, entry in ipairs(Store) do
            local isCurrent = entry.JobId == CurrentJobId
            local card = serverList:Row(84)
            New("TextLabel", {
                BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 6), Size = UDim2.new(1, -20, 0, 16),
                Text = isCurrent and "ТЕКУЩИЙ" or ("PlaceId " .. tostring(entry.PlaceId)), Font = Enum.Font.Code,
                TextSize = 11, TextColor3 = isCurrent and Theme.Accent or Theme.Sub,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = card,
            })
            local plist = entry.Players or {}
            New("TextLabel", {
                BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 24), Size = UDim2.new(1, -20, 0, 30),
                Text = "Игроки: " .. (#plist > 0 and table.concat(plist, ", ") or "нет данных"), TextWrapped = true,
                Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, Parent = card,
            })
            New("TextLabel", {
                BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -8),
                Size = UDim2.fromOffset(110, 14), Text = os.date("%d.%m %H:%M", entry.SavedAt or 0),
                Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.Sub,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = card,
            })
            local join = New("TextButton", {
                AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -86, 1, -6), Size = UDim2.fromOffset(64, 24),
                BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Text = "Join", Font = Enum.Font.GothamBold,
                TextSize = 12, TextColor3 = Color3.new(1, 1, 1), Parent = card,
            })
            Round(join, 8)
            join.Activated:Connect(function()
                Toast("Телепорт...", "ok")
                local ok, err = pcall(function() TeleportService:TeleportToPlaceInstance(entry.PlaceId, entry.JobId, lplayer) end)
                if not ok then Toast("Не удалось: " .. tostring(err):sub(1, 50), "bad") end
            end)
            ConfirmBtn(card, "Удалить", -8, 68, Color3.fromRGB(150, 50, 50), function()
                for i, e in ipairs(Store) do
                    if e.JobId == entry.JobId then table.remove(Store, i) break end
                end
                saveServers()
                renderServers()
            end).Position = UDim2.new(1, -8, 1, -18)
        end
    end
    renderServers()
end


-- ============================================================
-- GAMES / Blade Ball (сторона хаба): ESP способностей + запуск отдельного скрипта Auto Parry
-- Сам Auto Parry вынесен в RiseNexus_AutoParry.lua (метод VIREX), чтобы не влиять на хаб.
-- ============================================================
SideLabel("GAMES")
local BB = {}
do
    local LocalPlayer = lplayer

    -- способности / меч для ESP
    function BB.AbilityOf(plr)
        local char = plr.Character
        if not char then return nil end
        local ab = char:FindFirstChild("Abilities")
        if ab then
            local list = {}
            for _, a in ipairs(ab:GetChildren()) do
                local okE, en = pcall(function() return a.Enabled end)
                if okE and en == true then table.insert(list, a.Name) end
            end
            if #list > 0 then return table.concat(list, ", ") end
            local kids = ab:GetChildren()
            if #kids == 1 then return kids[1].Name end
        end
        for _, holder in ipairs({ char, plr }) do
            for _, n in ipairs({ "CurrentlyEquippedAbility", "EquippedAbility", "Ability", "AbilityName" }) do
                local v = holder:GetAttribute(n)
                if type(v) == "string" and v ~= "" then return v end
            end
        end
        return nil
    end
    function BB.Decorate(plr)
        local char = plr.Character
        if not char then return nil end
        local parts = {}
        local sword = char:GetAttribute("CurrentlyEquippedSword")
        if type(sword) == "string" and sword ~= "" then table.insert(parts, "Sword: " .. sword) end
        table.insert(parts, "Ability: " .. (BB.AbilityOf(plr) or "?"))
        return { extra = table.concat(parts, " | ") }
    end

    local PARRY_FILE = "RiseNexus_AutoParry.lua"
    local function readTry(name)
        local paths = { name, "/storage/emulated/0/Delta/Workspace/" .. name }
        for _, p in ipairs(paths) do
            local ok, res = pcall(function() return readfile(p) end)
            if ok and type(res) == "string" and #res > 0 then return res end
        end
        return nil
    end
    -- запускает второй скрипт (Auto Parry). silent = не показывать тост, если файла нет
    function BB.RunParryScript(silent)
        if Env.RiseParry then
            if not silent then Toast("Auto Parry уже запущен") end
            return true
        end
        local src = readTry(PARRY_FILE)
        if not src then
            if not silent then Toast("Файл " .. PARRY_FILE .. " не найден — запусти его вторым скриптом", "bad") end
            return false
        end
        local fn, err = loadstring(src)
        if not fn then
            Toast("Ошибка Auto Parry: " .. tostring(err):sub(1, 60), "bad")
            return false
        end
        task.spawn(function()
            local ok, e = pcall(fn)
            if not ok then Toast("Auto Parry: " .. tostring(e):sub(1, 60), "bad") end
        end)
        return true
    end

    local TabBB = CreateTab("Blade Ball")
    TabBB:Section("ESP")
    TabBB:Label("Меч и способность над игроками (строка показывается независимо от опции «Оружие»).")
    local uiEsp
    uiEsp = TabBB:Toggle("ESP: меч и способности", false, function(v)
        if v then
            ESP.Decorate = BB.Decorate
            ESP.Enabled = true
        elseif ESP.Decorate == BB.Decorate then
            ESP.Decorate = nil
        end
    end)
    function BB.EnableAbilityEsp()
        uiEsp.Set(true)
        ESP.Decorate = BB.Decorate
        ESP.Enabled = true
    end
    TabBB:Button("Диагностика: атрибуты ближайшего игрока (консоль F9)", nil, function()
        local best, bd = nil, math.huge
        local myc = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        for _, p in ipairs(Players:GetPlayers()) do
            local h = p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if h and myc and (h.Position - myc.Position).Magnitude < bd then
                bd, best = (h.Position - myc.Position).Magnitude, p
            end
        end
        if not best then
            Toast("Нет игроков рядом", "bad")
            return
        end
        print("[RiseNexus] diag:", best.Name)
        for k, v in pairs(best:GetAttributes()) do print("  player attr", k, v) end
        for k, v in pairs(best.Character:GetAttributes()) do print("  char attr", k, v) end
        local ab = best.Character:FindFirstChild("Abilities")
        if ab then
            for _, a in ipairs(ab:GetChildren()) do
                local okE, en = pcall(function() return a.Enabled end)
                print("  Abilities:", a.Name, a.ClassName, okE and en or "-")
            end
        else
            print("  Abilities: нет папки")
        end
        Toast("Атрибуты выведены в консоль", "ok")
    end)

    TabBB:Section("Auto Parry")
    TabBB:Label("Отдельный скрипт RiseNexus_AutoParry.lua (метод VIREX). Положи файл в workspace экзекьютора — хаб запустит его сам, либо запусти его вручную после хаба.")
    TabBB:Button("Запустить Auto Parry", nil, function() BB.RunParryScript(false) end)

    -- место в боковой панели под вкладку «Auto Parry», которую создаёт второй скрипт
    local parrySlot = SideOrder + 1
    SideOrder = SideOrder + 2
    -- API для внешних скриптов (Auto Parry подключается как вкладка хаба)
    Env.RiseNexus = {
        Version = 2,
        Toast = Toast,
        Track = Track,
        OnUnload = OnUnload,
        ESP = ESP,
        Theme = Theme,
        CreateParryTab = function(name)
            local saved = SideOrder
            SideOrder = parrySlot - 1
            local t = CreateTab(name)
            SideOrder = saved
            return t
        end,
    }
    OnUnload(function()
        Env.RiseNexus = nil
        local rp = Env.RiseParry
        if rp and rp.Destroy then pcall(rp.Destroy) end
    end)
end


-- ============================================================
-- МОДУЛЬ: GAMES / MM2 Values  (оверлей цен трейда из «валюты.lua»)
-- Оригинальная логика сохранена; собственные кнопка/GUI заменены на вкладку хаба.
-- ============================================================
local MM2Alive = true
OnUnload(function() MM2Alive = false end)
do
    local LocalPlayer = lplayer

local TradeValues = {
	["Gingerscope"] = 17750, ["Traveler's Axe"] = 8100, ["Celestial"] = 2050,
	["Vampire's Axe"] = 1225, ["Harvester"] = 250, ["Icepiercer"] = 160,
	["Icebreaker"] = 65, ["Batwing"] = 42, ["Elderwood Scythe"] = 38,
	["Swirly Axe"] = 38, ["Hallowscythe"] = 30, ["Logchopper"] = 18, ["Icewing"] = 13,
	["Chroma Traveler's Gun"] = 220000, ["Chroma Evergun"] = 75000,
["Chroma Evergreen"] = 52000, ["Chroma Bauble"] = 34000,
["Chroma Vampire's Gun"] = 29000, ["Chroma Constellation"] = 27000,
["Chroma Alienbeam"] = 24000, ["Chroma Sunrise"] = 13250,
["Chroma Raygun"] = 12750, ["Chroma Snowcannon"] = 8500,
	["Chroma Sunset"] = 8250, ["Chroma Blizzard"] = 8000,
	["Chroma Icecream"] = 6500, ["Chroma Snow Dagger"] = 4250,
	["Chroma Snowstorm"] = 4250, ["Chroma Heart Wand"] = 4250,
	["Chroma Watergun"] = 3400, ["Chroma Beachy"] = 3250,
	["Chroma Sands"] = 3250, ["Chroma Treat"] = 2600,
	["Chroma Sweet"] = 2200, ["Chroma Ornament"] = 1800,
	["Chroma Darkbringer"] = 65, ["Chroma Lightbringer"] = 60,
	["Chroma Luger"] = 50, ["Chroma Candleflame"] = 40,
	["Chroma Laser"] = 40, ["Chroma Swirly Gun"] = 38,
	["Chroma Elderwood Blade"] = 37, ["Chroma Deathshard"] = 35,
	["Chroma Cookiecane"] = 32, ["Chroma Fang"] = 32,
	["Chroma Gemstone"] = 32, ["Chroma Shark"] = 32,
	["Chroma Slasher"] = 32, ["Chroma Heat"] = 28,
	["Chroma Seer"] = 28, ["Chroma Gingerblade"] = 27,
	["Chroma Tides"] = 27, ["Chroma Saw"] = 23,
	["Chroma Boneblade"] = 22,
	["Chroma Fire Bat"] = 3, ["Chroma Fire Bear"] = 3,
	["Chroma Fire Bunny"] = 3, ["Chroma Fire Cat"] = 3,
	["Chroma Fire Dog"] = 3, ["Chroma Fire Fox"] = 3,
	["Chroma Fire Pig"] = 3,
["Traveler's Gun"] = 5600, ["Evergun"] = 3450,
["Constellation"] = 2700, ["Evergreen"] = 2500,
["Turkey"] = 2450, ["Vampire's Gun"] = 1950,
["Alienbeam"] = 1850, ["Darkshot"] = 1650,
["Darksword"] = 1625, ["Raygun"] = 1450,
["Blossom"] = 1310, ["Sakura"] = 1300,
["Sunrise"] = 1125, ["Snowcannon"] = 850,
["Bauble"] = 825, ["Icecream"] = 160,
["Sunset"] = 625, ["Soul"] = 615,
["Spirit"] = 605, ["Rainbow Gun"] = 420,
	["Flora"] = 410, ["Rainbow"] = 410,
	["Bloom"] = 400, ["Heart Wand"] = 340,
	["Beachy"] = 160, ["Sands"] = 160,
	["Ocean"] = 280, ["Waves"] = 275,
	["Xenoknife"] = 275, ["Xenoshot"] = 275,
	["Flowerwood Gun"] = 265, ["Blizzard"] = 260,
	["Flowerwood"] = 260, ["Snowstorm"] = 260,
	["Snow Dagger"] = 255, ["Watergun"] = 250,
	["Treat"] = 155, ["Sweet"] = 150,
	["Borealis"] = 150, ["Australis"] = 145,
	["Bat"] = 120, ["Pearlshine"] = 95,
	["Pearl"] = 90, ["Candy"] = 80,
	["Heartblade"] = 65, ["Luger"] = 40,
	["Red Luger"] = 38, ["Phantom"] = 35,
	["Spectre"] = 35, ["Candleflame"] = 33,
	["Darkbringer"] = 33, ["Elderwood Blade"] = 33,
	["Elderwood Revolver"] = 33, ["Iceblaster"] = 33,
	["Lightbringer"] = 33, ["Makeshift"] = 33,
	["Sugar"] = 32, ["Ornament"] = 27,
	["Green Luger"] = 23, ["Amerilaser"] = 22,
	["Laser"] = 22, ["Hallowgun"] = 20,
	["Nightblade"] = 20, ["Shark"] = 20,
	["Icebeam"] = 18, ["Plasmabeam"] = 18,
	["Swirly Gun"] = 18, ["Battleaxe II"] = 17,
	["Blaster"] = 17, ["Ginger Luger"] = 17,
	["Pixel"] = 17, ["Gemstone"] = 15,
	["Iceflake"] = 15, ["Old Glory"] = 15,
	["Plasmablade"] = 15, ["Slasher"] = 15,
	["Vampire's Edge"] = 15, ["Cookiecane"] = 13,
	["Deathshard"] = 13, ["Eternalcane"] = 13,
	["Gingerblade"] = 13, ["Jinglegun"] = 13,
	["Lugercane"] = 13, ["Minty"] = 13,
	["Nebula"] = 13, ["Virtual"] = 13,
	["Battleaxe"] = 12, ["Gingermint"] = 12,
	["Swirly Blade"] = 12, ["Chill"] = 10,
	["Clockwork"] = 10, ["Fang"] = 10,
	["Frostsaber"] = 10, ["Heat"] = 10,
	["Spider"] = 10, ["Tides"] = 10,
	["Bioblade"] = 8, ["Eternal III"] = 8,
	["Eternal IV"] = 8, ["Hallow's Blade"] = 8,
	["Hallow's Edge"] = 8, ["Handsaw"] = 8,
	["Boneblade"] = 7, ["Eternal"] = 7,
	["Eternal II"] = 7, ["Frostbite"] = 7,
	["Ghostblade"] = 7, ["Ice Dragon"] = 7,
	["Ice Shard"] = 7, ["Prismatic"] = 7,
	["Pumpking"] = 7, ["Saw"] = 7, ["Xmas"] = 7,
	["Eggblade"] = 5, ["Flames"] = 5,
	["Snowflake"] = 5, ["Winter's Edge"] = 5,
	["Peppermint"] = 4, ["Cookieblade"] = 3,
	["Blue Seer"] = 3, ["Purple Seer"] = 3,
	["Red Seer"] = 3, ["Seer"] = 3,
	["Orange Seer"] = 2, ["Yellow Seer"] = 2,
	["Default Gun"] = 1, ["Default Knife"] = 1,
	["8bit"] = 1, ["Big Kill"] = 1,
	["Eco"] = 1, ["Fallout"] = 1,
	["Slate"] = 1, ["Camo"] = 1,
	["Strawberries"] = 1, ["Plaid"] = 0,
	["Tourist"] = 0, ["Footsteps"] = 1,
	["Regular"] = 1, ["Bubble Blower"] = 1,
	["Sit"] = 1, ["Pizza"] = 1,
}

local createdLabels = {}
local active = false

local function fmt(v)
	if v == 0 then return "0" end
	if v >= 1000000 then return string.format("%.1fM", v / 1000000) end
	if v >= 1000 then return string.format("%.1fK", v / 1000) end
	return tostring(v)
end

local function getValColor(v)
	if v >= 100000 then return Color3.fromRGB(255, 50, 50) end
	if v >= 10000 then return Color3.fromRGB(255, 100, 50) end
	if v >= 1000 then return Color3.fromRGB(255, 215, 0) end
	if v >= 100 then return Color3.fromRGB(0, 200, 100) end
	if v >= 10 then return Color3.fromRGB(100, 200, 255) end
	return Color3.fromRGB(150, 150, 150)
end

local function addValueLabel(parent, itemName)
	if not parent then return end
	local existing = parent:FindFirstChild("ValueLabel")
	if existing then existing:Destroy() end
	local val = TradeValues[itemName]
	if val == nil then val = 0 end
	local label = Instance.new("TextLabel")
	label.Name = "ValueLabel"
	label.Size = UDim2.new(1, 0, 0, 16)
	label.Position = UDim2.new(0, 0, 1, -16)
	label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	label.BackgroundTransparency = 0.15
	label.Text = "$" .. fmt(val)
	label.TextColor3 = getValColor(val)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.ZIndex = 100
	label.Parent = parent
	Instance.new("UICorner", label).CornerRadius = UDim.new(0, 4)
	table.insert(createdLabels, label)
end

local function removeAllLabels()
	for _, l in pairs(createdLabels) do
		pcall(function() l:Destroy() end)
	end
	createdLabels = {}
end

local function processSlot(slot)
	if not slot or not slot:IsA("Frame") then return end
	local container = slot:FindFirstChild("Container")
	if not container then return end
	local icon = container:FindFirstChild("Icon")
	local nameFrame = slot:FindFirstChild("ItemName")
	if not icon or not nameFrame then return end
	local nameLabel = nameFrame:FindFirstChild("Label")
	if not nameLabel then return end
	local itemName = nameLabel.Text
	if itemName == "" or itemName == "Loading..." then return end
	addValueLabel(container, itemName)
end

local function processOffer(offer)
	if not offer then return end
	local container = offer:FindFirstChild("Container")
	if not container then return end
	for _, child in pairs(container:GetChildren()) do
		if child:IsA("Frame") and child.Name:find("NewItem") then processSlot(child) end
	end
end

local function sumOffer(offer)
	local total = 0
	if not offer then return total end
	local container = offer:FindFirstChild("Container")
	if not container then return total end
	for _, child in pairs(container:GetChildren()) do
		if child:IsA("Frame") and child.Name:find("NewItem") then
			local nameFrame = child:FindFirstChild("ItemName")
			if nameFrame then
				local label = nameFrame:FindFirstChild("Label")
				if label then
					local itemName = label.Text
					if itemName ~= "" and itemName ~= "Loading..." then
						local v = TradeValues[itemName]
						if v == nil then v = 0 end
						total = total + v
					end
				end
			end
		end
	end
	return total
end

local totalsPanel = nil
local youLabel = nil
local themLabel = nil
local verdictLabel = nil

local function getTotalsPanel(parent)
	if totalsPanel and (not totalsPanel.Parent or totalsPanel.Parent ~= parent) then
		pcall(function() totalsPanel:Destroy() end)
		totalsPanel = nil
	end
	if not totalsPanel then
		totalsPanel = Instance.new("Frame")
		totalsPanel.Name = "ValueTotals"
		totalsPanel.Size = UDim2.new(0, 340, 0, 56)
		totalsPanel.Position = UDim2.new(0.5, -170, 1, -70)
		totalsPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		totalsPanel.BackgroundTransparency = 0.12
		totalsPanel.BorderSizePixel = 0
		totalsPanel.ZIndex = 900
		totalsPanel.Parent = parent
		Instance.new("UICorner", totalsPanel).CornerRadius = UDim.new(0, 8)

		youLabel = Instance.new("TextLabel")
		youLabel.Size = UDim2.new(0, 150, 0, 18)
		youLabel.Position = UDim2.new(0, 12, 0, 6)
		youLabel.BackgroundTransparency = 1
		youLabel.Font = Enum.Font.GothamBold
		youLabel.Text = "YOU: $0"
		youLabel.TextColor3 = Color3.fromRGB(120, 220, 255)
		youLabel.TextSize = 14
		youLabel.TextXAlignment = Enum.TextXAlignment.Left
		youLabel.ZIndex = 901
		youLabel.Parent = totalsPanel

		themLabel = Instance.new("TextLabel")
		themLabel.Size = UDim2.new(0, 150, 0, 18)
		themLabel.Position = UDim2.new(1, -162, 0, 6)
		themLabel.BackgroundTransparency = 1
		themLabel.Font = Enum.Font.GothamBold
		themLabel.Text = "THEM: $0"
		themLabel.TextColor3 = Color3.fromRGB(255, 200, 120)
		themLabel.TextSize = 14
		themLabel.TextXAlignment = Enum.TextXAlignment.Right
		themLabel.ZIndex = 901
		themLabel.Parent = totalsPanel

		verdictLabel = Instance.new("TextLabel")
		verdictLabel.Size = UDim2.new(1, -16, 0, 22)
		verdictLabel.Position = UDim2.new(0, 8, 1, -26)
		verdictLabel.BackgroundTransparency = 1
		verdictLabel.Font = Enum.Font.GothamBold
		verdictLabel.Text = "FAIR"
		verdictLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
		verdictLabel.TextScaled = true
		verdictLabel.TextXAlignment = Enum.TextXAlignment.Center
		verdictLabel.ZIndex = 901
		verdictLabel.Parent = totalsPanel
	end
	local pDragging = false
	local pDragStart = nil
	local pStartPos = nil
	local function connectDrag(target)
		target.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				pDragging = true
				pDragStart = input.Position
				pStartPos = target.Position
			end
		end)
		target.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				pDragging = false
			end
		end)
	end
	connectDrag(totalsPanel)
	for _, child in pairs(totalsPanel:GetDescendants()) do
		if child:IsA("GuiObject") then connectDrag(child) end
	end
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if pDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - pDragStart
			totalsPanel.Position = UDim2.new(pStartPos.X.Scale, pStartPos.X.Offset + d.X, pStartPos.Y.Scale, pStartPos.Y.Offset + d.Y)
		end
	end)
	return totalsPanel
end

local function updateTotals(trade, container)
	local you = sumOffer(trade:FindFirstChild("YourOffer"))
	local them = sumOffer(trade:FindFirstChild("TheirOffer"))
	local panel = getTotalsPanel(container)
	youLabel.Text = "YOU: $" .. fmt(you)
	themLabel.Text = "THEM: $" .. fmt(them)
	local diff = you - them
	if diff > 0 then
		verdictLabel.Text = "LOSE  -$" .. fmt(diff)
		verdictLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
	elseif diff < 0 then
		verdictLabel.Text = "WIN  +$" .. fmt(-diff)
		verdictLabel.TextColor3 = Color3.fromRGB(0, 220, 100)
	else
		verdictLabel.Text = "FAIR"
		verdictLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	end
	panel.Visible = true
end

local function processInventoryScroll(scrollFrame)
	if not scrollFrame then return end
	local current = scrollFrame:FindFirstChild("Current")
	if not current then return end
	local itemsContainer = current:FindFirstChild("Container")
	if not itemsContainer then return end
	for _, child in pairs(itemsContainer:GetChildren()) do
		if child:IsA("Frame") then
			local container = child:FindFirstChild("Container")
			if container then
				local icon = container:FindFirstChild("Icon")
				local nameFrame = child:FindFirstChild("ItemName")
				if icon and nameFrame then
					local label = nameFrame:FindFirstChild("Label")
					if label and label.Text ~= "" and label.Text ~= "Loading..." then
						addValueLabel(container, label.Text)
					end
				end
			end
		end
	end
end


    local function setActive(v)
        active = v
        if not v then
            removeAllLabels()
            if totalsPanel then totalsPanel.Visible = false end
        end
    end
    OnUnload(function()
        active = false
        removeAllLabels()
        if totalsPanel then pcall(function() totalsPanel:Destroy() end) end
    end)

task.spawn(function()
	while MM2Alive and task.wait(0.5) do
		if active then
		if totalsPanel then totalsPanel.Visible = false end
		pcall(function()
			local tradeGUI = LocalPlayer.PlayerGui:FindFirstChild("TradeGUI")
			if tradeGUI then
				local container = tradeGUI:FindFirstChild("Container")
				if container then
					local trade = container:FindFirstChild("Trade")
					if trade then
						processOffer(trade:FindFirstChild("YourOffer"))
						processOffer(trade:FindFirstChild("TheirOffer"))
						updateTotals(trade, container)
					end
					local items = container:FindFirstChild("Items")
					if items then
						local main = items:FindFirstChild("Main")
						if main then
							for _, tab in pairs(main:GetChildren()) do
								if tab:IsA("Frame") then
									local wItems = tab:FindFirstChild("Items")
									if wItems then
										local scroll = wItems:FindFirstChild("ScrollingFrame")
										if scroll then processInventoryScroll(scroll) end
									end
								end
							end
						end
					end
				end
			end
			local mainGUI = LocalPlayer.PlayerGui:FindFirstChild("MainGUI")
			if mainGUI then
				local gameFrame = mainGUI:FindFirstChild("Game")
				if gameFrame then
					local inv = gameFrame:FindFirstChild("Inventory")
					if inv and inv.Visible then
						for _, desc in pairs(inv:GetDescendants()) do
							if desc:IsA("Frame") and desc.Name == "Container" then
								for _, child in pairs(desc:GetChildren()) do
									if child:IsA("Frame") then
										local container = child:FindFirstChild("Container")
										if container then
											local icon = container:FindFirstChild("Icon")
											local nameFrame = child:FindFirstChild("ItemName")
											if icon and nameFrame then
												local label = nameFrame:FindFirstChild("Label")
												if label and label.Text ~= "" and label.Text ~= "Loading..." then
													addValueLabel(container, label.Text)
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end)
		end
	end
end)


    local TabMM2 = CreateTab("MM2 Values")
    TabMM2:Section("Оверлей трейда")
    TabMM2:Label("Показывает цену над каждым предметом в инвентаре и в окне обмена, плюс итог WIN / LOSE.")
    TabMM2:Toggle("Показывать цены (оверлей)", false, function(v) setActive(v) end)

    TabMM2:Section("Поиск цены")
    local resList
    local function renderValues(q)
        resList:Clear()
        q = (q or ""):lower()
        local found = {}
        for name, val in pairs(TradeValues) do
            if q == "" or tostring(name):lower():find(q, 1, true) then
                table.insert(found, { name = tostring(name), val = tonumber(val) or 0 })
            end
        end
        table.sort(found, function(a, b)
            if a.val ~= b.val then return a.val > b.val end
            return a.name < b.name
        end)
        if #found == 0 then
            resList:Info("Ничего не найдено")
            return
        end
        for i = 1, math.min(#found, 40) do
            local it = found[i]
            local row = resList:Row(30)
            New("TextLabel", {
                BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -100, 1, 0),
                Text = it.name, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
            })
            New("TextLabel", {
                BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 0),
                Size = UDim2.fromOffset(80, 30), Text = "$" .. fmt(it.val), TextColor3 = getValColor(it.val),
                Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = row,
            })
        end
        if #found > 40 then resList:Info("Показаны первые 40 из " .. #found) end
    end
    TabMM2:Input("Предмет", "название...", function(t) renderValues(t) end, { Live = true, BoxWidth = 180 })
    resList = TabMM2:List()
    renderValues("")
end


-- ============================================================
-- МОДУЛЬ: GAMES / MM2 Combat
--  • ESP ролей: убийца / шериф (по наличию Knife / Gun в Character или Backpack)
--  • единый silent aim: ОДИН хук __namecall на FireServer("Shoot") и ("KnifeThrown")
--    + предсказание позиции цели (логика Thunder Hub, переписана без телеметрии/ключей)
--  • выстрел в убийцу по кнопке / бинду, подбор выпавшего пистолета
-- ============================================================
local MM2CAlive = true
local MM2C = { Role = false, ShowInnocent = false, GunAim = false, KnifeAim = false, Mode = "Dynamic", KnifeTarget = "Nearest" }
OnUnload(function() MM2CAlive = false end)
do
    local LocalPlayer = lplayer
    local COLORS = {
        Murderer = Color3.fromRGB(255, 60, 60),
        Sheriff = Color3.fromRGB(70, 150, 255),
        Innocent = Color3.fromRGB(90, 220, 130),
    }

    -- ===== роли =====
    local function hasTool(plr, name)
        local char = plr.Character
        local bp = plr:FindFirstChild("Backpack")
        return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name)) or nil
    end
    local function alive(plr)
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        return hum ~= nil and hum.Health > 0
    end
    local function getRole(plr)
        if hasTool(plr, "Knife") then return "Murderer" end
        if hasTool(plr, "Gun") then return "Sheriff" end
        return "Innocent"
    end
    local function findMurder()
        for _, p in ipairs(Players:GetPlayers()) do
            if hasTool(p, "Knife") and alive(p) then return p end
        end
        return nil
    end
    local function findSheriff()
        for _, p in ipairs(Players:GetPlayers()) do
            if hasTool(p, "Gun") and alive(p) then return p end
        end
        return nil
    end

    function MM2C.Decorate(plr)
        local role = getRole(plr)
        if role == "Innocent" and not MM2C.ShowInnocent then return nil end
        return { tag = role, color = COLORS[role] }
    end

    -- ===== предсказание позиции цели =====
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local function floorYFor(char, hrp, hum)
        rayParams.FilterDescendantsInstances = { char, LocalPlayer.Character }
        local hit = Workspace:Raycast(hrp.Position, Vector3.new(0, -300, 0), rayParams)
        if hit then return hit.Position.Y + hum.HipHeight + hrp.Size.Y * 0.5 end
        return nil
    end
    local function predictPos(plr, mode)
        local char = plr and plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not (hrp and hum) then return nil end
        local pos = hrp.Position
        local vel = hrp.AssemblyLinearVelocity
        if mode == "Default" then
            if vel.Magnitude == 0 then return pos end
            local n = vel / 16.5
            return pos + Vector3.new(n.X, math.clamp(n.Y, -2, 2.65), n.Z / 1.25)
        end
        -- Dynamic: упреждение = пинг + 0.113 c, скорость смешивается с направлением движения
        local lead = math.clamp(LocalPlayer:GetNetworkPing() + 0.113, 0.02, 0.6)
        local air = hum.FloorMaterial == Enum.Material.Air
        local ws = hum.WalkSpeed > 0 and hum.WalkSpeed or 16
        local intent = hum.MoveDirection * ws
        local flat = Vector3.new(vel.X, 0, vel.Z):Lerp(Vector3.new(intent.X, 0, intent.Z), air and 0.5 or 0.85)
        local y = pos.Y
        if air then
            y = pos.Y + vel.Y * lead - 0.5 * Workspace.Gravity * lead * lead
            local fy = floorYFor(char, hrp, hum)
            if fy then y = math.max(y, fy) end
        end
        return Vector3.new(pos.X + flat.X * lead, y, pos.Z + flat.Z * lead)
    end

    local function knifeTarget()
        if MM2C.KnifeTarget == "Sheriff" then return findSheriff() end
        local me = LocalPlayer.Character
        local myHrp = me and me:FindFirstChild("HumanoidRootPart")
        if not myHrp then return nil end
        local best, bd = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and alive(p) then
                local h = p.Character:FindFirstChild("HumanoidRootPart")
                if h then
                    local d = (h.Position - myHrp.Position).Magnitude
                    if d < bd then bd, best = d, p end
                end
            end
        end
        return best
    end

    -- ===== единый хук silent aim =====
    local hooked, oldNamecall = false, nil
    local function ensureHook()
        if hooked then return true end
        if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then
            Toast("Executor не поддерживает hookmetamethod", "bad")
            return false
        end
        hooked = true
        local wrap = newcclosure or function(f) return f end
        oldNamecall = hookmetamethod(game, "__namecall", wrap(function(self, ...)
            if MM2CAlive and (MM2C.GunAim or MM2C.KnifeAim) and getnamecallmethod() == "FireServer" and typeof(self) == "Instance" then
                local name = self.Name
                if MM2C.GunAim and name == "Shoot" then
                    local m = findMurder()
                    local pos = m and predictPos(m, MM2C.Mode)
                    if pos then
                        local args = table.pack(...)
                        args[2] = CFrame.new(pos)
                        return oldNamecall(self, table.unpack(args, 1, args.n))
                    end
                elseif MM2C.KnifeAim and name == "KnifeThrown" then
                    local t = knifeTarget()
                    local pos = t and predictPos(t, MM2C.Mode)
                    if pos then
                        local args = table.pack(...)
                        args[2] = CFrame.new(pos)
                        return oldNamecall(self, table.unpack(args, 1, args.n))
                    end
                end
            end
            return oldNamecall(self, ...)
        end))
        return true
    end

    -- ===== выстрел в убийцу =====
    function MM2C.ShootMurderer()
        local me = LocalPlayer.Character
        local myHrp = me and me:FindFirstChild("HumanoidRootPart")
        local hum = me and me:FindFirstChildOfClass("Humanoid")
        if not (me and myHrp and hum) then return false end
        local gun = me:FindFirstChild("Gun")
        if not gun then
            local bp = LocalPlayer:FindFirstChild("Backpack")
            local inBag = bp and bp:FindFirstChild("Gun")
            if not inBag then
                Toast("Ты не шериф (нет Gun)", "bad")
                return false
            end
            hum:EquipTool(inBag)
            local t0 = os.clock()
            while not me:FindFirstChild("Gun") and os.clock() - t0 < 0.4 do task.wait() end
            gun = me:FindFirstChild("Gun")
            if not gun then return false end
        end
        local m = findMurder()
        if not m then
            Toast("Убийца не найден", "bad")
            return false
        end
        local pos = predictPos(m, MM2C.Mode)
        local shoot = gun:FindFirstChild("Shoot")
        if not (pos and shoot) then return false end
        local att = myHrp:FindFirstChild("GunRaycastAttachment")
        local origin = att and att.WorldCFrame or myHrp.CFrame
        shoot:FireServer(origin, CFrame.new(pos))
        return true
    end

    -- ===== выпавший пистолет =====
    local function findGunDrop() return Workspace:FindFirstChild("GunDrop", true) end
    local function gunPart(gd)
        if not gd then return nil end
        if gd:IsA("BasePart") then return gd end
        return gd:FindFirstChildWhichIsA("BasePart", true)
    end
    function MM2C.GrabGun()
        local part = gunPart(findGunDrop())
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not (part and hrp) then
            Toast("Пистолет не найден", "bad")
            return
        end
        if firetouchinterest then
            pcall(function()
                firetouchinterest(hrp, part, 0)
                task.wait(0.1)
                firetouchinterest(hrp, part, 1)
            end)
        end
        local back = hrp.CFrame
        hrp.CFrame = part.CFrame + Vector3.new(0, 2, 0)
        task.wait(0.25)
        if hrp.Parent then hrp.CFrame = back end
        Toast("Забираю пистолет", "ok")
    end

    -- ===== UI =====
    local TabC = CreateTab("MM2 Combat")
    TabC:Section("Роли")
    local uiRole
    uiRole = TabC:Toggle("ESP ролей: убийца / шериф", false, function(v)
        MM2C.Role = v
        if v then
            ESP.Decorate = MM2C.Decorate
            ESP.Enabled = true
        elseif ESP.Decorate == MM2C.Decorate then
            ESP.Decorate = nil
        end
    end)
    function MM2C.EnableRoleEsp()
        uiRole.Set(true)
        MM2C.Role = true
        ESP.Decorate = MM2C.Decorate
        ESP.Enabled = true
    end
    TabC:Toggle("Показывать невиновных", false, function(v) MM2C.ShowInnocent = v end)
    local info = TabC:List()
    local infoLbl = info:Info("Убийца: —  ·  Шериф: —", Theme.Text)

    TabC:Section("Silent Aim (один хук для пистолета и ножа)")
    TabC:Label("Хук ставится при первом включении. Нужны hookmetamethod / getnamecallmethod.")
    TabC:Selector("Предсказание", { { "Dynamic", "Dynamic" }, { "Default", "Default" } }, MM2C.Mode, function(v) MM2C.Mode = v end)
    TabC:Toggle("Gun silent aim (шериф → убийца)", false, function(v)
        if v and not ensureHook() then return end
        MM2C.GunAim = v
    end)
    TabC:Toggle("Knife silent aim (убийца → цель)", false, function(v)
        if v and not ensureHook() then return end
        MM2C.KnifeAim = v
    end)
    TabC:Selector("Цель ножа", { { "Ближайший", "Nearest" }, { "Шериф", "Sheriff" } }, MM2C.KnifeTarget, function(v) MM2C.KnifeTarget = v end)

    TabC:Section("Выстрел")
    TabC:Button("Выстрелить в убийцу", nil, function()
        task.spawn(MM2C.ShootMurderer)
    end)
    local shootKey = false
    TabC:Toggle("Бинд Q = выстрел в убийцу", false, function(v) shootKey = v end)
    Track(UserInputService.InputBegan:Connect(function(input, processed)
        if shootKey and not processed and input.KeyCode == Enum.KeyCode.Q then
            task.spawn(MM2C.ShootMurderer)
        end
    end))

    TabC:Section("Пистолет")
    TabC:Button("Забрать выпавший пистолет", nil, function()
        task.spawn(MM2C.GrabGun)
    end)
    local gunEsp = false
    TabC:Toggle("Подсветка выпавшего пистолета", false, function(v) gunEsp = v end)

    -- фоновое обновление: инфо-строка и подсветка GunDrop
    local gunHl
    task.spawn(function()
        while MM2CAlive do
            task.wait(0.5)
            pcall(function()
                local m, s = findMurder(), findSheriff()
                infoLbl.Text = "Убийца: " .. (m and m.Name or "—") .. "  ·  Шериф: " .. (s and s.Name or "—")
                local part = gunEsp and gunPart(findGunDrop()) or nil
                if part then
                    if not gunHl or not gunHl.Parent then
                        gunHl = Instance.new("Highlight")
                        gunHl.FillColor = Color3.fromRGB(255, 210, 60)
                        gunHl.OutlineColor = Color3.new(1, 1, 1)
                        gunHl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        gunHl.Parent = Holder
                    end
                    gunHl.Adornee = part
                    gunHl.Enabled = true
                elseif gunHl then
                    gunHl.Enabled = false
                end
            end)
        end
    end)
    OnUnload(function()
        MM2C.GunAim, MM2C.KnifeAim = false, false
        if gunHl then pcall(function() gunHl:Destroy() end) end
    end)
end


SideLabel("SYSTEM")
-- ===== Настройки =====
local TabSet = CreateTab("Настройки")
local MenuKey, Listening = Enum.KeyCode.RightShift, false
local keyBtn

TabSet:Section("Вид меню")
TabSet:Slider("Непрозрачность меню", 0.3, 1, Opacity, 0.05, function(v)
    Opacity = v
    ApplyGlass()
end)
TabSet:Slider("Размер меню", 0.6, 1.4, startScale, 0.05, function(v) UIScaleObj.Scale = v end)
TabSet:ColorPicker("Акцентный цвет", Theme.Accent, function(c) SetAccent(c) end)
local AccentPresets = {
    { "Default", Color3.fromRGB(119, 120, 255) }, { "Amber", Color3.fromRGB(255, 140, 50) },
    { "Azure", Color3.fromRGB(60, 150, 255) }, { "Violet", Color3.fromRGB(180, 80, 255) },
    { "Jade", Color3.fromRGB(80, 220, 160) }, { "Crimson", Color3.fromRGB(255, 70, 90) },
    { "Graphite", Color3.fromRGB(255, 200, 80) }, { "Onyx", Color3.fromRGB(225, 225, 225) },
    { "Pine", Color3.fromRGB(90, 200, 110) }, { "Blush", Color3.fromRGB(255, 110, 170) },
    { "Aurora", Color3.fromRGB(90, 225, 190) }, { "Synthwave", Color3.fromRGB(255, 60, 180) },
    { "Galaxy", Color3.fromRGB(150, 120, 255) }, { "Toxic", Color3.fromRGB(180, 235, 40) },
    { "Ember", Color3.fromRGB(255, 130, 40) },
}
TabSet:Selector("Пресет акцента (Rise)", AccentPresets, AccentPresets[1][2], function(c) SetAccent(c) end)
TabSet:Toggle("Размытие фона (блюр)", NX.Blur, function(v)
    NX.Blur = v
    Tween(BlurFx, { Size = (Main.Visible and v) and 14 or 0 }, 0.2)
end)

TabSet:Section("Управление")
keyBtn = TabSet:Button("Клавиша меню: " .. MenuKey.Name, nil, function()
    Listening = true
    keyBtn.Text = "Нажмите любую клавишу..."
end)
TabSet:Button("Выгрузить скрипт", Color3.fromRGB(150, 50, 50), function() Unload() end)

Track(UserInputService.InputBegan:Connect(function(input, processed)
    if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
        Listening = false
        MenuKey = input.KeyCode
        keyBtn.Text = "Клавиша меню: " .. MenuKey.Name
        return
    end
    if not processed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == MenuKey then
        if Main.Visible then
            Main.Visible = false
            Mini.Visible = false
        else
            ShowMain()
        end
    end
end))

SelectTab(Tabs[1])

-- ============================================================
-- ЛАУНЧЕР ИГР: запускается перед хабом, подбирает набор вкладок под игру
-- ============================================================
do
    local ReplicatedStorage = Service("ReplicatedStorage")
    local PROFILES = {
        { id = "bb", name = "Blade Ball", sub = "Auto Parry · Spam · ESP способностей" },
        { id = "mm2", name = "Murder Mystery 2", sub = "ESP ролей · Silent Aim · Values · Радио" },
        { id = "all", name = "Все модули", sub = "Показать все вкладки" },
    }
    local GAME_TABS = { bb = { "Blade Ball", "Auto Parry" }, mm2 = { "MM2 Combat", "MM2 Values" } }

    local function detect()
        if game.PlaceId == 13772394625 then return "bb" end
        if game.PlaceId == 142823291 then return "mm2" end
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        if r and r:FindFirstChild("ParrySuccessAll") then return "bb" end
        local inv = r and r:FindFirstChild("Inventory")
        if inv and inv:FindFirstChild("PlaySong") then return "mm2" end
        return nil
    end
    local detected = detect()

    local launcher
    local function apply(id)
        local firstGameTab
        for _, t in ipairs(Tabs) do
            local owner
            for gid, list in pairs(GAME_TABS) do
                if table.find(list, t.Btn.Text) then owner = gid end
            end
            local visible = (owner == nil) or id == "all" or owner == id
            t.Btn.Visible = visible
            if visible and owner and not firstGameTab then firstGameTab = t end
        end
        if id == "bb" then
            pcall(BB.EnableAbilityEsp)
            task.spawn(function() pcall(BB.RunParryScript, true) end)
        end
        if id == "mm2" then pcall(MM2C.EnableRoleEsp) end
        SelectTab((id ~= "all" and firstGameTab) or Tabs[1])
        if launcher then launcher:Destroy(); launcher = nil end
        ShowMain()
    end

    launcher = New("ScreenGui", {
        Name = "RiseNexus_Launcher", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1000,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    Protect(launcher)
    OnUnload(function() if launcher then launcher:Destroy(); launcher = nil end end)

    local dim = New("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(5, 5, 8), BackgroundTransparency = 0.3,
        BorderSizePixel = 0, Parent = launcher,
    })
    local cardH = 96 + #PROFILES * 62 + 16
    local card = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(340, cardH),
        BackgroundColor3 = Theme.Panel, BackgroundTransparency = 0.08, BorderSizePixel = 0, Parent = dim,
    })
    Round(card, 20)
    Stroke(card, Theme.Accent, 1.5, 0.45)
    local cam = Workspace.CurrentCamera
    local vpY = cam and cam.ViewportSize.Y or 720
    New("UIScale", { Scale = math.clamp(vpY / (cardH + 40), 0.55, 1), Parent = card })

    local logo = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 14), Size = UDim2.fromOffset(40, 40),
        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Parent = card,
    })
    Round(logo, 12)
    New("TextLabel", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "RN", Font = Enum.Font.GothamBold,
        TextSize = 16, TextColor3 = Color3.new(1, 1, 1), Parent = logo,
    })
    New("TextLabel", {
        Position = UDim2.fromOffset(0, 58), Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
        Text = "Rise Nexus", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Theme.Text, Parent = card,
    })
    New("TextLabel", {
        Position = UDim2.fromOffset(0, 78), Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1,
        Text = detected and "Игра определена автоматически" or "Выбери игру", Font = Enum.Font.Gotham,
        TextSize = 11, TextColor3 = Theme.Sub, Parent = card,
    })

    local order = {}
    for _, p in ipairs(PROFILES) do
        if p.id == detected then table.insert(order, 1, p) else table.insert(order, p) end
    end
    for i, p in ipairs(order) do
        local isDet = p.id == detected
        local b = New("TextButton", {
            Position = UDim2.fromOffset(16, 100 + (i - 1) * 62), Size = UDim2.new(1, -32, 0, 54),
            BackgroundColor3 = Theme.Element, BackgroundTransparency = 0.25, BorderSizePixel = 0,
            Text = "", AutoButtonColor = false, Parent = card,
        })
        Round(b, 12)
        Stroke(b, isDet and Theme.Accent or Color3.new(1, 1, 1), isDet and 1.5 or 1, isDet and 0.2 or 0.8)
        New("TextLabel", {
            Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -28, 0, 20), BackgroundTransparency = 1,
            Text = p.name, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = b,
        })
        New("TextLabel", {
            Position = UDim2.fromOffset(14, 28), Size = UDim2.new(1, -28, 0, 16), BackgroundTransparency = 1,
            Text = p.sub, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.Sub,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = b,
        })
        if isDet then
            New("TextLabel", {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 8), Size = UDim2.fromOffset(110, 16),
                BackgroundTransparency = 1, Text = "● обнаружено", Font = Enum.Font.GothamBold, TextSize = 10,
                TextColor3 = Theme.Accent, TextXAlignment = Enum.TextXAlignment.Right, Parent = b,
            })
        end
        b.Activated:Connect(function() apply(p.id) end)
    end

    Main.Visible = false
    Mini.Visible = false
    Tween(BlurFx, { Size = NX.Blur and 14 or 0 }, 0.3)
end



-- ============================================================
-- UNLOAD
-- ============================================================
Unload = function()
    for _, fn in ipairs(Cleanups) do pcall(fn) end
    for _, c in ipairs(Connections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(Connections)
    for plr in pairs(Objects) do RemoveESP(plr) end
    pcall(function() Holder:Destroy() end)
    pcall(function() MenuGui:Destroy() end)
    Env.__RISE_NEXUS_UNLOAD = nil
end
Env.__RISE_NEXUS_UNLOAD = Unload
