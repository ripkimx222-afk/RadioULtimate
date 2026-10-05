--[[
    NEXUS  -  единый хаб
    Вкладки: ESP · Радио/Каталог · Скрипты/Серверы · Blade Ball · MM2 · Guts & Blackpowder · Настройки
    • RightShift - показать / скрыть меню (клавишу можно поменять в «Настройки»)
    • «-» - свернуть в кружок, тап по кружку - открыть обратно
    • «×» - нажать два раза, чтобы выгрузить хаб
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
    LoaderGui.Name = "NexusLoader"
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
    title.Text = "NEXUS"
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
if Env.__NEXUS_UNLOAD then pcall(Env.__NEXUS_UNLOAD) end

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
    Name = "Nexus_UI", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999,
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
local MainGradient = New("UIGradient", {
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
    BackgroundColor3 = Color3.fromRGB(18, 18, 26), Text = "NX", Font = Enum.Font.GothamBold,
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
    Text = "Nexus Ver.01", Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = Theme.Text,
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
local MinBtn   = HeaderButton("-", -70, Theme.Element)
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
-- NEXUS: расширения кита (общие для всех модулей)
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
local BlurFx = LightingSvc:FindFirstChild("NexusMenuBlur")
if not BlurFx then
    BlurFx = Instance.new("BlurEffect")
    BlurFx.Name = "NexusMenuBlur"
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

-- кнопка с подтверждением: первое нажатие "?", второе в течение 2 сек - действие
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


-- ===== Кнопки на экране: нажимаешь по центру, двигаешь за рамку =====
local FloatGui = New("ScreenGui", {
    Name = "Nexus_Buttons", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 500,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
Protect(FloatGui)
OnUnload(function() FloatGui:Destroy() end)
local FloaterList, FloaterN = {}, 0
local FLOAT_EDGE = 10
local function Floater(id, text, onClick, opts)
    opts = opts or {}
    FloaterN = FloaterN + 1
    local n = FloaterN
    local w, h = opts.w or 112, opts.h or 56
    local F = { id = id, text = text, on = false }
    F.frame = New("Frame", {
        Size = UDim2.fromOffset(w, h),
        Position = UDim2.fromOffset(14 + math.floor((n - 1) / 6) * (w + 10), 64 + ((n - 1) % 6) * (h + 8)),
        BackgroundColor3 = Theme.Panel, BackgroundTransparency = 0.12, BorderSizePixel = 0,
        Visible = false, Active = true, Parent = FloatGui,
    })
    Round(F.frame, 14)
    local stroke = Stroke(F.frame, Theme.Accent, 2, 0.35)
    local btn = New("TextButton", {
        Position = UDim2.fromOffset(FLOAT_EDGE, FLOAT_EDGE), Size = UDim2.new(1, -FLOAT_EDGE * 2, 1, -FLOAT_EDGE * 2),
        BackgroundTransparency = 1, Text = text, Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = Theme.Text, TextWrapped = true, AutoButtonColor = false, Parent = F.frame,
    })
    local function paint()
        if opts.toggle then
            btn.Text = text .. (F.on and "\nON" or "\nOFF")
            btn.TextColor3 = F.on and Color3.fromRGB(110, 235, 150) or Theme.Text
            stroke.Color = F.on and Color3.fromRGB(110, 235, 150) or Theme.Accent
        end
    end
    function F.SetOn(v)
        F.on = v and true or false
        paint()
    end
    function F.Show(v) F.frame.Visible = v and true or false end
    btn.Activated:Connect(function()
        if onClick then onClick(F) end
    end)
    paint()
    FloaterList[#FloaterList + 1] = F
    return F
end
local function FloaterToggle(P, F, text)
    local h = P:Toggle(text, F.frame.Visible, function(v) F.Show(v) end)
    F.ui = h
    return h
end
Track(UserInputService.InputBegan:Connect(function(input)
    if not IsPress(input) then return end
    local p = input.Position
    for _, F in ipairs(FloaterList) do
        local fr = F.frame
        if fr.Visible then
            local ap, as = fr.AbsolutePosition, fr.AbsoluteSize
            local x, y = p.X - ap.X, p.Y - ap.Y
            if x >= 0 and x <= as.X and y >= 0 and y <= as.Y
                and (x <= FLOAT_EDGE or y <= FLOAT_EDGE or x >= as.X - FLOAT_EDGE or y >= as.Y - FLOAT_EDGE) then
                local startP, startPos = p, fr.Position
                BeginDrag(function(np)
                    local d = np - startP
                    fr.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
                end)
                return
            end
        end
    end
end))


local Presets = {
    Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 150, 255), Color3.fromRGB(119, 120, 255), Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(255, 130, 0), Color3.fromRGB(255, 105, 180), Color3.fromRGB(0, 255, 255),
    Color3.fromRGB(160, 0, 255), Color3.fromRGB(120, 120, 120), Color3.fromRGB(0, 0, 0),
}

local function CreateTab(name, detached)
    local btn, bar
    if not detached then
    btn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = name, Font = Enum.Font.Gotham,
        TextSize = 13, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = (function() SideOrder = SideOrder + 1; return SideOrder end)(), Parent = Sidebar,
    })
    Round(btn, 7)
    New("UIPadding", { PaddingLeft = UDim.new(0, 14), Parent = btn })
    OnAccent(function() btn.BackgroundColor3 = Theme.Accent end)
    bar = New("Frame", {
        Position = UDim2.new(0, -11, 0.5, -8), Size = UDim2.fromOffset(3, 16),
        BorderSizePixel = 0, Visible = false, Parent = btn,
    })
    Round(bar, 2)
    OnAccent(function() bar.BackgroundColor3 = Theme.Accent end)
    end

    local page = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageTransparency = 0.3, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
        ElasticBehavior = Enum.ElasticBehavior.Never, Visible = detached and true or false, Parent = detached or Content,
    })
    OnAccent(function() page.ScrollBarImageColor3 = Theme.Accent end)
    New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page })
    New("UIPadding", { PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 6), Parent = page })

    local tab = { Btn = btn, Bar = bar, Page = page }
    if not detached then
        Tabs[#Tabs + 1] = tab
        btn.Activated:Connect(function() SelectTab(tab) end)
    end

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

    -- ===== Nexus: доп. элементы страницы =====
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

    -- переключатель с шестерёнкой настроек
    function P:ToggleGear(text, default, cb, onGear)
        local state = default and true or false
        local row = Row(36, "TextButton")
        RowLabel(row, text, 116)
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
        local gear = New("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -56, 0.5, 0), Size = UDim2.fromOffset(32, 24),
            BackgroundColor3 = Theme.Off, BackgroundTransparency = 0.3, BorderSizePixel = 0, Text = "⚙",
            Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = Theme.Text, AutoButtonColor = true, Parent = row,
        })
        Round(gear, 8)
        gear.Activated:Connect(function() if onGear then onGear() end end)
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

    P.Page = page
    return P
end

-- ===== Окно настроек (шестерёнка): отдельная страница кита в плавающем окне =====
local function SettingsWindow(title)
    local win = New("Frame", {
        Name = "RNWin", Size = UDim2.fromOffset(380, 330), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), BackgroundColor3 = Theme.Panel, BorderSizePixel = 0,
        Visible = false, Active = true, ZIndex = 120, Parent = MenuGui,
    })
    Glass(win, 0.06)
    Round(win, 14)
    local wst = Stroke(win, Theme.Accent, 1, 0.4)
    OnAccent(function() wst.Color = Theme.Accent end)
    local sc = New("UIScale", { Scale = UIScaleObj.Scale, Parent = win })
    local head = New("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Active = true, Parent = win })
    New("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -60, 1, 0), Text = title,
        Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = head,
    })
    local close = New("TextButton", {
        Size = UDim2.fromOffset(28, 22), Position = UDim2.new(1, -36, 0, 6), BackgroundColor3 = Color3.fromRGB(150, 50, 50),
        BorderSizePixel = 0, Text = "×", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Theme.Text,
        AutoButtonColor = true, Parent = head,
    })
    Round(close, 6)
    head.InputBegan:Connect(function(input)
        if IsPress(input) then
            local startInput, startPos = input.Position, win.Position
            BeginDrag(function(p)
                local d = p - startInput
                win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end)
        end
    end)
    local holder = New("Frame", {
        Position = UDim2.fromOffset(8, 38), Size = UDim2.new(1, -16, 1, -46), BackgroundTransparency = 1, Parent = win,
    })
    local W = { Frame = win }
    W.P = CreateTab(title, holder)
    function W.Open() sc.Scale = UIScaleObj.Scale; win.Visible = true end
    function W.Close() win.Visible = false end
    function W.Toggle()
        if win.Visible then W.Close() else W.Open() end
    end
    close.Activated:Connect(W.Close)
    return W
end



-- ============================================================
-- СОДЕРЖИМОЕ ВКЛАДОК
-- ============================================================
local D = ESP.Drawing

-- ===== Основное =====
SideLabel("UNIVERSAL")
local ESPWin = SettingsWindow("Настройки ESP")
local TabMain = CreateTab("ESP")
TabMain:Section("ESP")
TabMain:ToggleGear("ESP", ESP.Enabled, function(v) ESP.Enabled = v end, function() ESPWin.Toggle() end)
ESPWin.P:Toggle("Team Check (только враги)", ESP.TeamCheck, function(v) ESP.TeamCheck = v end)
ESPWin.P:Toggle("Метка друг / враг", ESP.Options.Friendcheck, function(v) ESP.Options.Friendcheck = v end)
ESPWin.P:Toggle("Fade по дистанции", ESP.FadeOut.OnDistance, function(v) ESP.FadeOut.OnDistance = v end)
ESPWin.P:Section("Параметры")
ESPWin.P:Slider("Макс. дистанция", 50, 2000, ESP.MaxDistance, 10, function(v) ESP.MaxDistance = v end)
ESPWin.P:Slider("Размер шрифта", 8, 24, ESP.FontSize, 1, function(v) ESP.FontSize = v end)
TabMain:Label("RightShift - скрыть / показать меню.\nКнопка «-» сворачивает меню в кружок.")


TabMain:Section("Камера")
local ZoomCfg = { on = false, value = 35, orig = nil, alive = true }
TabMain:Toggle("Ограничить макс. зум камеры", false, function(v)
    ZoomCfg.on = v
    if v then
        ZoomCfg.orig = lplayer.CameraMaxZoomDistance
    elseif ZoomCfg.orig then
        pcall(function() lplayer.CameraMaxZoomDistance = ZoomCfg.orig end)
    end
end)
TabMain:Slider("Макс. зум камеры (1-100)", 1, 100, ZoomCfg.value, 1, function(v) ZoomCfg.value = v end)
task.spawn(function()
    while ZoomCfg.alive do
        if ZoomCfg.on then
            pcall(function()
                if lplayer.CameraMaxZoomDistance ~= ZoomCfg.value then lplayer.CameraMaxZoomDistance = ZoomCfg.value end
            end)
        end
        task.wait(1)
    end
end)
OnUnload(function()
    ZoomCfg.alive = false
    if ZoomCfg.on and ZoomCfg.orig then pcall(function() lplayer.CameraMaxZoomDistance = ZoomCfg.orig end) end
end)

-- ===== Визуалы =====
local TabVis = ESPWin.P
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
local TabCol = ESPWin.P
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
    local Cfg = { showOriginal = false, autoImport = false, searchEng = "catalog", loopPreview = false, continueMode = "off", favs = {} }
    local Songs, Lists = {}, {}
    local TabMeta = {
        { id = "all", label = "all", builtin = true },
        { id = "fav", label = "★ избранное", builtin = true },
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
        { "139344691622468", "Buzova - я хочу", "ru" },
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
        local fav = {}
        for _, id in ipairs(all) do
            if Cfg.favs[id] then fav[#fav + 1] = id end
        end
        Lists.fav = fav
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
                for _, k in ipairs({ "showOriginal", "autoImport", "searchEng", "loopPreview", "continueMode", "favs" }) do
                    if d.cfg[k] ~= nil then Cfg[k] = d.cfg[k] end
                end
            end
            if type(d.songs) == "table" then Songs = d.songs end
            if type(d.tabs) == "table" then Lists = d.tabs end
            if type(d.tabMeta) == "table" then TabMeta = d.tabMeta end
            if type(Cfg.favs) ~= "table" then Cfg.favs = {} end
            local hasFav = false
            for _, m in ipairs(TabMeta) do
                if m.id == "fav" then hasFav = true end
            end
            if not hasFav then table.insert(TabMeta, 2, { id = "fav", label = "★ избранное", builtin = true }) end
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

    local prv = Instance.new("Sound")
    prv.Name = "RadioPreview"
    prv.Volume = 0.5
    prv.Parent = Service("SoundService")
    local prvId
    local playCtx = { list = nil, token = 0 }

    local function nextIn(list, id)
        if not list or #list == 0 then return nil end
        for i, x in ipairs(list) do
            if x == id then return list[i % #list + 1] end
        end
        return list[1]
    end

    -- длительность трека (грузим невидимый Sound, не проигрываем)
    local lenCache = {}
    local function lengthOf(id)
        if lenCache[id] then return lenCache[id] end
        local snd = Instance.new("Sound")
        snd.SoundId = "rbxassetid://" .. tostring(id)
        snd.Volume = 0
        snd.Parent = Service("SoundService")
        local t0 = os.clock()
        while not snd.IsLoaded and os.clock() - t0 < 6 do task.wait(0.1) end
        local len = snd.IsLoaded and snd.TimeLength or nil
        snd:Destroy()
        if len and len > 0 then lenCache[id] = len end
        return lenCache[id]
    end

    local function prvStart(id, list)
        prvId = id
        playCtx.list = list
        prv.Looped = Cfg.loopPreview and Cfg.continueMode ~= "preview"
        prv.SoundId = "rbxassetid://" .. tostring(id)
        prv:Play()
    end
    prv.Ended:Connect(function()
        if Cfg.continueMode == "preview" and prvId then
            local nxt = nextIn(playCtx.list, prvId)
            if nxt then prvStart(nxt, playCtx.list) end
        end
    end)
    local function prvToggle(id, list)
        if prvId == id and prv.IsPlaying then
            prv:Stop()
            prvId = nil
            return
        end
        prvStart(id, list)
    end

    local radioPlayList
    local function radioPlay(id, list)
        if not PlaySong then Toast("PlaySong не найден (не MM2?)", "bad") return end
        pcall(function() PlaySong:FireServer(idToUrl(id)) end)
        playCtx.token = playCtx.token + 1
        local token = playCtx.token
        if Cfg.continueMode == "radio" and list and #list > 1 then
            task.spawn(function()
                local len = lengthOf(id)
                if not len then return end
                task.wait(len + 0.6)
                if playCtx.token ~= token or Cfg.continueMode ~= "radio" then return end
                local nxt = nextIn(list, id)
                if nxt then radioPlay(nxt, list) end
            end)
        end
    end
    local function radioStop()
        playCtx.token = playCtx.token + 1
        if PlaySong then pcall(function() PlaySong:FireServer("") end) end
        prv:Stop()
        prvId = nil
    end
    -- «играть где можно»: в MM2 - радио геймпасса, в других играх - превью
    local function playAny(id, list)
        if PlaySong then radioPlay(id, list) else prvStart(id, list) end
    end
    OnUnload(function()
        playCtx.token = playCtx.token + 1
        pcall(function() prv:Stop(); prv:Destroy() end)
    end)

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
    local viewIds = {}
    local renderRadio, renderBroken

    local TabRadio = CreateTab("Радио")
    TabRadio:Section("Управление")
    TabRadio:Button("■  Остановить радио", Color3.fromRGB(150, 50, 50), function() radioStop() end)
    TabRadio:Toggle("Показывать имена Roblox", Cfg.showOriginal, function(v)
        Cfg.showOriginal = v
        saveAll()
        renderRadio()
    end)
    TabRadio:Toggle("Зацикливать превью (трек играет заново)", Cfg.loopPreview, function(v)
        Cfg.loopPreview = v
        prv.Looped = v and Cfg.continueMode ~= "preview"
        saveAll()
    end)
    TabRadio:Selector("Продолжение списка", { { "Выкл", "off" }, { "Превью", "preview" }, { "Радио (геймпасс)", "radio" } },
        Cfg.continueMode, function(v)
            Cfg.continueMode = v
            prv.Looped = Cfg.loopPreview and v ~= "preview"
            saveAll()
        end)

    -- избранное на экране: 1 трек - играет сразу, больше - показывает список названий
    local favPanel
    local function closeFavPanel()
        if favPanel then favPanel:Destroy(); favPanel = nil end
    end
    local function openFavPanel()
        closeFavPanel()
        local ids = {}
        for id in pairs(Cfg.favs) do
            if Songs[id] then ids[#ids + 1] = id end
        end
        table.sort(ids, function(a, b) return tostring(Songs[a].name):lower() < tostring(Songs[b].name):lower() end)
        if #ids == 0 then
            Toast("Избранное пусто - отметь треки звёздочкой ☆")
            return
        end
        if #ids == 1 then
            playAny(ids[1], ids)
            return
        end
        local h = math.min(#ids, 8) * 34 + 44
        favPanel = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(280, h),
            BackgroundColor3 = Theme.Panel, BackgroundTransparency = 0.05, BorderSizePixel = 0, ZIndex = 5, Parent = FloatGui,
        })
        Round(favPanel, 14)
        Stroke(favPanel, Theme.Accent, 1.5, 0.35)
        New("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -50, 0, 34),
            Text = "★ Избранное", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, Parent = favPanel,
        })
        local x = New("TextButton", {
            Position = UDim2.new(1, -34, 0, 6), Size = UDim2.fromOffset(26, 22), BackgroundColor3 = Color3.fromRGB(150, 50, 50),
            BorderSizePixel = 0, Text = "×", Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = Color3.new(1, 1, 1),
            ZIndex = 6, Parent = favPanel,
        })
        Round(x, 6)
        x.Activated:Connect(closeFavPanel)
        local sf = New("ScrollingFrame", {
            Position = UDim2.fromOffset(8, 36), Size = UDim2.new(1, -16, 1, -44), BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 3, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 6, Parent = favPanel,
        })
        New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sf })
        for i, id in ipairs(ids) do
            local b = New("TextButton", {
                Size = UDim2.new(1, -4, 0, 30), BackgroundColor3 = Theme.Element, BackgroundTransparency = 0.3,
                BorderSizePixel = 0, Text = "  " .. tostring(Songs[id].name), TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.Text,
                LayoutOrder = i, ZIndex = 7, Parent = sf,
            })
            Round(b, 8)
            b.Activated:Connect(function()
                closeFavPanel()
                playAny(id, ids)
            end)
        end
    end
    OnUnload(closeFavPanel)
    local favF = Floater("fav", "★ Избранное", function() openFavPanel() end)
    FloaterToggle(TabRadio, favF, "Кнопка на экране: ★ Избранное")

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
            BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -198, 1, 0),
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
        MiniBtn(row, "♪", -110, 22, Theme.Off, function() prvToggle(id, viewIds) end)
        MiniBtn(row, "▶", -136, 22, Theme.Accent, function() radioPlay(id, viewIds) end)
        local starBtn
        starBtn = MiniBtn(row, Cfg.favs[id] and "★" or "☆", -162, 22, Cfg.favs[id] and Color3.fromRGB(230, 170, 40) or Theme.Off, function()
            if Cfg.favs[id] then Cfg.favs[id] = nil else Cfg.favs[id] = true end
            rebuildAll()
            saveAll()
            renderRadio()
        end)
    end

    renderRadio = function()
        radioList:Clear()
        local m = TabMeta[metaIndex()]
        swLbl.Text = m.label .. "  ·  " .. #(Lists[m.id] or {})
        local q = filterQ:lower()
        local seen, shown, total = {}, 0, 0
        viewIds = {}
        for _, id in ipairs(Lists[curTab] or {}) do
            local s = Songs[id]
            if s and not seen[id] then
                seen[id] = true
                local hay = (tostring(s.name) .. " " .. tostring(s.robloxName or "") .. " " .. id):lower()
                if q == "" or hay:find(q, 1, true) then
                    total = total + 1
                    viewIds[#viewIds + 1] = id
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
            radioList:Info("Показано " .. shown .. " из " .. total .. " - уточни фильтр")
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
-- Файлы совместимы с Rise: Script.Loader.N.txt, Nexus.Folders.json, Nexus.Servers.json
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
    local FOLDERS_FILE = "Nexus.Folders.json"
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
    local SERVERS_FILE = "Nexus.Servers.json"
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
-- GAMES / Blade Ball - всё в одном файле (метод VIREX: getgc-токен + перехват парри)
-- Режимы: Triggerbot НЕ работает с Auto Parry (выкл. триггера сразу включает Auto Parry);
-- со Spam / Manual Spam триггер работает вместе.
-- Новое: Auto Accuracy (пинг + скорость мяча + диапазон), Instant Parry, Anti Slash of Fury (мс),
--        предугадывание Auto Spam (подсветка цели), кнопки на экране.
-- ============================================================
SideLabel("GAMES")
local BB = { Loaded = false, Loading = false, Alive = true, Curve = "Camera", Method = "VIREX" }
OnUnload(function() BB.Alive = false end)
do
    local Stats = Service("Stats")
    local ReplicatedStorage = Service("ReplicatedStorage")
    local LocalPlayer = lplayer
    local CURVE_NAMES = { "Camera", "Random", "Accelerated", "Backwards", "Slow", "High", "Normal", "Speed", "Down", "Left", "Right" }

    local S = {
        autoparry = false, animation = false, accuracy = 50, divisor = 1.1, parried = false, trainingParried = false,
        spamThreshold = 1.5, parries = 0, randomCurve = false, autoAbility = false,
        autoAcc = false, accMin = 20, accMax = 90,
        instant = false, instantRange = 25,
        antiSof = false, antiSofMs = 0,
        spamPredict = true, spamHighlight = true, spamNear = 5, spamBallNear = 3, spamGrace = 2,
        tornadoTime = tick(), infinityActive = false, deathslashActive = false, timeholeActive = false,
        slashesActive = false, slashesCount = 0, triggerEnabled = false, triggerParrying = false,
        autoSpam = false, manualSpam = false,
        det = { infinity = false, deathslash = false, timehole = false, slashes = false },
    }
    BB.S = S
    function BB.UpdateDivisor()
        S.divisor = 0.7 + (S.accuracy - 1) * (0.9 / 99)
    end
    BB.UpdateDivisor()

    local function build()
        local Alive = Workspace:FindFirstChild("Alive") or Workspace:WaitForChild("Alive", 10)
        local Runtime = Workspace:FindFirstChild("Runtime")
        local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not (Alive and Runtime and Remotes and Remotes:FindFirstChild("ParrySuccessAll")) then
            return false, "Это не Blade Ball (нет Alive / Runtime / Remotes)"
        end
        if not (getgc and getrawmetatable and setreadonly and debug and debug.getupvalues) then
            return false, "Executor не поддерживает getgc / getrawmetatable"
        end

        -- ===== токен (VIREX) =====
        local _token
        local gcList = getgc(true)
        for gi = 1, #gcList do
            local fn = gcList[gi]
            if gi % 2500 == 0 then task.wait() end
            if type(fn) == "function" then
                local okS, src = pcall(debug.info, fn, "s")
                if okS and type(src) == "string" and src:find("PRY", 1, true) then
                    for _, value in pairs(debug.getupvalues(fn)) do
                        if type(value) == "function" then
                            _token = value
                            break
                        end
                    end
                    if _token then break end
                end
            end
        end
        if not _token then return false, "Токен не найден - перезайди и запусти хаб заново" end

        local function tokenize(_remote_uid)
            local time = tostring(math.floor(Workspace:GetServerTimeNow() * 100))
            local key = _token(_remote_uid, "TIME")
            local characters = table.create(#time)
            for index = 1, #time do
                characters[index] = string.char(bit32.bxor(
                    (string.byte(time, index) + index) % 256,
                    string.byte(key, (index - 1) % #key + 1)
                ))
            end
            return table.concat(characters)
        end

        -- ===== перехват ремоута парри (метод VIREX) =====
        -- Метатаблица Instance общая для всех объектов игры, пока хук стоит, каждое чтение
        -- FireServer идёт через Lua. После первого настоящего парри хук снимается.
        local _reverted, _original, _hooked = {}, {}, {}
        local capturedRemote, capturedArgs
        local function _is_valid(args)
            if not args or #args < 8 then return false end
            return true
        end
        local function unhookAll()
            for _, h in ipairs(_hooked) do
                pcall(function()
                    setreadonly(h.meta, false)
                    h.meta.__index = h.old
                    setreadonly(h.meta, true)
                end)
            end
            table.clear(_hooked)
        end
        local function _hook(remote)
            if not remote then return end
            if _reverted[remote] then return end
            local _meta = getrawmetatable(remote)
            if _original[_meta] then return end
            _original[_meta] = true
            setreadonly(_meta, false)
            local _old = _meta.__index
            _hooked[#_hooked + 1] = { meta = _meta, old = _old }
            _meta.__index = function(self, key)
                if (key == "FireServer" and self:IsA("RemoteEvent")) or
                   (key == "InvokeServer" and self:IsA("RemoteFunction")) then
                    return function(_, ...)
                        local _arguments = {...}
                        if BB.Alive and _is_valid(_arguments) and not _reverted[self] then
                            _reverted[self] = _arguments
                            capturedRemote = self
                            capturedArgs = _arguments
                            task.defer(unhookAll)
                        end
                        return _old(self, key)(_, unpack(_arguments))
                    end
                end
                return _old(self, key)
            end
            setreadonly(_meta, true)
        end
        local function hookAllRemotes()
            for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then _hook(r) end
            end
        end
        hookAllRemotes()
        -- повторный перехват, если ремоут сменился (после этого нужен один ручной парри)
        function BB.Rehook()
            unhookAll()
            _reverted, _original = {}, {}
            capturedRemote, capturedArgs = nil, nil
            hookAllRemotes()
        end
        OnUnload(unhookAll)
        function BB.HasToken() return capturedRemote ~= nil end

        -- как в VIREX: после установки хука даём игре спокойно догрузиться
        task.wait(5)
        task.spawn(function()
            while BB.Alive and not capturedRemote do task.wait(1) end
            if capturedRemote then Toast("Blade Ball: парри перехвачен - всё готово", "ok") end
        end)

local function fireParry(curveCF)
    if not capturedRemote or not capturedArgs then return false end
    local cam = Workspace.CurrentCamera
    local aim
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        aim = { math.floor(cam.ViewportSize.X / 2), math.floor(cam.ViewportSize.Y / 2) }
    else
        local okM, m = pcall(function() return UserInputService:GetMouseLocation() end)
        if okM and m then
            aim = { math.floor(m.X), math.floor(m.Y) }
        else
            aim = { math.floor(cam.ViewportSize.X / 2), math.floor(cam.ViewportSize.Y / 2) }
        end
    end
    local eventData = {}
    for _, entity in pairs(Alive:GetChildren()) do
        if entity.PrimaryPart then
            local okP, sp = pcall(function() return cam:WorldToScreenPoint(entity.PrimaryPart.Position) end)
            if okP then eventData[entity.Name] = sp end
        end
    end
    local packet = {
        capturedArgs[1], capturedArgs[2], tokenize(capturedArgs[2]), 0.5,
        curveCF or cam.CFrame, eventData, aim, false,
    }
    pcall(function()
        if typeof(capturedRemote) == "Instance" and capturedRemote:IsA("RemoteFunction") then
            capturedRemote:InvokeServer(unpack(packet))
        else
            capturedRemote:FireServer(unpack(packet))
        end
    end)
    return true
end

-- ===== мячи / игроки =====
local function getBall()
    local balls = Workspace:FindFirstChild("Balls")
    if not balls then return nil end
    for _, b in pairs(balls:GetChildren()) do
        if b:GetAttribute("realBall") then
            b.CanCollide = false
            return b
        end
    end
    return nil
end
local function getAllBalls()
    local out = {}
    local balls = Workspace:FindFirstChild("Balls")
    if not balls then return out end
    for _, b in pairs(balls:GetChildren()) do
        if b:GetAttribute("realBall") then
            b.CanCollide = false
            table.insert(out, b)
        end
    end
    return out
end
local closest, lastClosestCheck = nil, 0
local function getClosest()
    local now = tick()
    if now - lastClosestCheck < 0.1 then return closest end
    lastClosestCheck = now
    local maxD, best = math.huge, nil
    for _, e in pairs(Alive:GetChildren()) do
        if e ~= LocalPlayer.Character and e.PrimaryPart then
            local d = LocalPlayer:DistanceFromCharacter(e.PrimaryPart.Position)
            if d < maxD then maxD, best = d, e end
        end
    end
    closest = best
    return best
end

-- ===== анимация парри =====
local Shared = ReplicatedStorage:FindFirstChild("Shared")
local SwordAPI = Shared and Shared:FindFirstChild("SwordAPI")
local animCache, lastPlayed, swordCP = {}, 0, false
local function getParryAnimation(swordName)
    local coll = SwordAPI and SwordAPI:FindFirstChild("Collection")
    local def = coll and coll:FindFirstChild("Default") and coll.Default:FindFirstChild("GrabParry")
    if not swordName or swordName == "" then return def end
    if animCache[swordName] then return animCache[swordName] end
    local result = def
    local okG, data = pcall(function() return Shared.ReplicatedInstances.Swords.GetSword:Invoke(swordName) end)
    if okG and type(data) == "table" and data.AnimationType and coll then
        for _, obj in pairs(coll:GetChildren()) do
            if obj.Name == data.AnimationType then
                local a = obj:FindFirstChild("GrabParry") or obj:FindFirstChild("Grab")
                if a then
                    result = a
                    break
                end
            end
        end
    end
    animCache[swordName] = result
    return result
end
local function playGrabParry()
    if not S.animation then return end
    if not ((os.clock() - lastPlayed) >= 0.2 or swordCP) then return end
    lastPlayed, swordCP = os.clock(), false
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    local anim = getParryAnimation(char:GetAttribute("CurrentlyEquippedSword"))
    if not anim then return end
    for _, tr in pairs(animator:GetPlayingAnimationTracks()) do
        if tr.Name == "GrabParry" or tr.Name == "Grab" then
            tr.TimePosition = 0
            tr:Stop(0.1)
        elseif tr.Name == "SuccessParry" or tr.Name == "Success" then
            tr:Stop(0.1)
        end
    end
    local track = animator:LoadAnimation(anim)
    pcall(function() track:Play(0, 1, 1) end)
end

-- ===== кривая (curve) =====
local function getCurveCFrame()
    local cam = Workspace.CurrentCamera
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local rootPos = root and root.Position or cam.CFrame.Position
    local targetPart
    local bestDist = math.huge
    local mouseLoc = (not (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)) and UserInputService:GetMouseLocation() or nil
    for _, v in pairs(Alive:GetChildren()) do
        if v ~= LocalPlayer.Character and v.PrimaryPart then
            local sp, onScreen = cam:WorldToScreenPoint(v.PrimaryPart.Position)
            if onScreen then
                local ref = mouseLoc or Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                local dist = (Vector2.new(sp.X, sp.Y) - ref).Magnitude
                if dist < bestDist then bestDist, targetPart = dist, v.PrimaryPart end
            end
        end
    end
    local targetPos = targetPart and targetPart.Position or (rootPos + cam.CFrame.LookVector * 100)
    local t = BB.Curve
    if t == "Camera" then
        return cam.CFrame
    elseif t == "Random" then
        local direction = (targetPos - rootPos).Unit
        local off
        local attempts = 0
        repeat
            off = Vector3.new(math.random(-4000, 4000), math.random(-4000, 4000), math.random(-4000, 4000))
            local dot = direction:Dot((targetPos + off - rootPos).Unit)
            attempts = attempts + 1
        until dot < 0.95 or attempts > 10
        return CFrame.new(rootPos, targetPos + off)
    elseif t == "Accelerated" then
        return CFrame.new(rootPos, targetPos + Vector3.new(0, 5, 0))
    elseif t == "Backwards" then
        local direction = (rootPos - targetPos).Unit
        return CFrame.new(cam.CFrame.Position, rootPos + direction * 10000 + Vector3.new(0, 1000, 0))
    elseif t == "Slow" then
        return CFrame.new(rootPos, targetPos + Vector3.new(0, -9e18, 0))
    elseif t == "High" then
        return CFrame.new(rootPos, targetPos + Vector3.new(0, 9e18, 0))
    elseif t == "Normal" then
        return CFrame.new(rootPos, rootPos + (root and root.CFrame.LookVector or cam.CFrame.LookVector))
    elseif t == "Speed" then
        return CFrame.new(cam.CFrame.Position, cam.CFrame.Position + cam.CFrame.UpVector * 5)
    elseif t == "Down" then
        return CFrame.new(cam.CFrame.Position, cam.CFrame.Position + cam.CFrame.UpVector * -9e9)
    elseif t == "Left" then
        return CFrame.new(cam.CFrame.Position, cam.CFrame.Position - cam.CFrame.RightVector * 9e9)
    elseif t == "Right" then
        return CFrame.new(cam.CFrame.Position, cam.CFrame.Position + cam.CFrame.RightVector * 9e9)
    end
    return cam.CFrame
end

local function parryExecute()
    if S.parries > 10000 or not LocalPlayer.Character then return end
    fireParry(getCurveCFrame())
    S.parries = S.parries + 1
    task.delay(0.5, function()
        if S.parries > 0 then S.parries = S.parries - 1 end
    end)
end
local function parryAction()
    playGrabParry()
    parryExecute()
end

-- ===== детект кривого мяча =====
local dp = { lastWarping = tick(), lerpRadians = 0, curving = tick() }
local function lerp(a, b, t) return a + (b - a) * t end
local function isCurved()
    local ball = getBall()
    if not ball then return false end
    local zoomies = ball:FindFirstChild("zoomies")
    if not zoomies then return false end
    local velocity = zoomies.VectorVelocity
    local speed = velocity.Magnitude
    if speed < 1 then return false end
    local char = LocalPlayer.Character
    if not char or not char.PrimaryPart then return false end
    local pos = char.PrimaryPart.Position
    local direction = (pos - ball.Position).Unit
    local dot = direction:Dot(velocity.Unit)
    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    local distance = (pos - ball.Position).Magnitude
    local reachTime = distance / speed - ping
    local dotThreshold = math.clamp(0.55 - (ping * 0.75), -1, 0.45)
    local speedThreshold = math.min(speed / 100, 45)
    local ballDistThreshold = 15 - math.min(distance / 1000, 15) + speedThreshold
    local radians = math.asin(math.clamp(dot, -1, 1))
    dp.lerpRadians = lerp(dp.lerpRadians, radians, 0.85)
    if dp.lerpRadians < 0.016 then dp.lastWarping = tick() end
    if distance < (ballDistThreshold * 0.85) then return false end
    if (tick() - dp.lastWarping) < (reachTime / 1.4) then return true end
    if (tick() - dp.curving) < (reachTime / 1.1) then return true end
    return dot < dotThreshold
end



        -- ===== события игры =====
        local function safeConnect(getEvent, fn)
            pcall(function() Track(getEvent():Connect(fn)) end)
        end
        local net
        pcall(function() net = ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net end)
        safeConnect(function() return Remotes.DeathBall.OnClientEvent end, function(_, d) S.deathslashActive = d or false end)
        safeConnect(function() return Remotes.InfinityBall.OnClientEvent end, function(_, b) S.infinityActive = b or false end)
        local function isMe(p)
            return p == LocalPlayer or p == LocalPlayer.Name or (typeof(p) == "Instance" and p.Name == LocalPlayer.Name)
        end

        -- ===== Anti Slash of Fury: единичный парри после окончания абилки чужого игрока =====
        local sof = { other = false, since = 0 }
        local function antiSofParry()
            local delaySec = math.clamp((S.antiSofMs or 0) / 1000, 0, 1)
            local deadline = os.clock() + 2.5
            while BB.Alive and os.clock() < deadline do
                local ball = getBall()
                local char = LocalPlayer.Character
                if ball and char and char.PrimaryPart and ball:GetAttribute("target") == LocalPlayer.Name then
                    if delaySec > 0 then task.wait(delaySec) end
                    parryAction() -- единичный парри: режимы Auto Parry / Trigger / Spam не трогаем
                    return
                end
                RunService.Heartbeat:Wait()
            end
        end

        if net then
            safeConnect(function() return net["RE/TimeHoleActivate"].OnClientEvent end, function(p)
                if isMe(p) then S.timeholeActive = true end
            end)
            safeConnect(function() return net["RE/TimeHoleDeactivate"].OnClientEvent end, function() S.timeholeActive = false end)
            safeConnect(function() return net["RE/SlashesOfFuryActivate"].OnClientEvent end, function(p)
                if isMe(p) then
                    S.slashesActive = true
                    S.slashesCount = 0
                else
                    sof.other, sof.since = true, os.clock()
                end
            end)
            safeConnect(function() return net["RE/SlashesOfFuryEnd"].OnClientEvent end, function()
                local wasOther = sof.other
                sof.other = false
                S.slashesActive = false
                S.slashesCount = 0
                if S.antiSof and wasOther then task.spawn(antiSofParry) end
            end)
            safeConnect(function() return net["RE/SlashesOfFuryParry"].OnClientEvent end, function()
                S.slashesCount = S.slashesCount + 1
            end)
            safeConnect(function() return net["RE/SlashesOfFuryCatch"].OnClientEvent end, function()
                task.spawn(function()
                    while S.slashesActive and S.slashesCount < 36 do
                        if S.det.slashes then
                            parryExecute()
                            task.wait(0.05)
                        else
                            break
                        end
                    end
                end)
            end)
        end
        safeConnect(function() return Remotes.ParrySuccessAll.OnClientEvent end, function(_, root)
            swordCP = true
            local char = LocalPlayer.Character
            if not char or not char.PrimaryPart then return end
            if root and root.Parent and root.Parent ~= char and root.Parent.Parent ~= Alive then return end
            local cl, ball = getClosest(), getBall()
            if not ball or not cl or not cl.PrimaryPart then return end
            local pos = char.PrimaryPart.Position
            local targetDistance = (pos - cl.PrimaryPart.Position).Magnitude
            local distance = (pos - ball.Position).Magnitude
            local dot = ((pos - ball.Position).Unit):Dot(ball.AssemblyLinearVelocity.Unit)
            if targetDistance < 15 and distance < 15 and dot > -0.25 and isCurved() then
                parryAction()
            end
        end)
        safeConnect(function() return Remotes.ParrySuccessAll.OnClientEvent end, function(_, b)
            local char = LocalPlayer.Character
            local ball = getBall()
            if not char or not char.PrimaryPart or not ball then return end
            local zoomies = ball:FindFirstChild("zoomies")
            if not zoomies then return end
            local speed = zoomies.VectorVelocity.Magnitude
            local distance = (char.PrimaryPart.Position - ball.Position).Magnitude
            local pings = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            local speedThreshold = math.min(speed / 100, 40)
            local reachTime = distance / math.max(speed, 1) - (pings / 1000)
            local thr = 15 - math.min(distance / 1000, 15) + speedThreshold
            if speed > 1 and reachTime > pings / 10 then thr = math.max(thr - 15, 15) end
            if b ~= char.PrimaryPart and distance > thr then dp.curving = tick() end
        end)

        -- ===== Auto Accuracy: пинг + скорость мяча в пределах диапазона =====
        local function autoAccuracy(speed)
            local pingMs = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            local speedF = math.clamp((speed - 30) / 370, 0, 1)
            local pingF = math.clamp((pingMs - 30) / 170, 0, 1)
            local t = math.clamp(speedF * 0.65 + pingF * 0.35, 0, 1)
            local lo, hi = math.min(S.accMin, S.accMax), math.max(S.accMin, S.accMax)
            S.accuracy = math.clamp(math.floor(hi - (hi - lo) * t + 0.5), 1, 100)
            BB.UpdateDivisor()
        end

        -- ===== Auto Parry =====
        local function handleBall(ball, oneBall)
            local zoomies = ball:FindFirstChild("zoomies")
            if not zoomies then return end
            ball:GetAttributeChangedSignal("target"):Once(function() S.parried = false end)
            if S.parried then return end
            local char = LocalPlayer.Character
            local target = ball:GetAttribute("target")
            local distance = (char.PrimaryPart.Position - ball.Position).Magnitude
            local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
            local pingThreshold = math.clamp(ping / 10, 5, 17)
            local speed = zoomies.VectorVelocity.Magnitude
            if S.autoAcc then autoAccuracy(speed) end
            local capped = math.min(math.max(speed - 9.5, 0), 650)
            local speedDivisor = (2.4 + capped * 0.002) * S.divisor
            local accuracy = pingThreshold + math.max(speed / speedDivisor, 9.5)
            local curved = isCurved()
            if ball:FindFirstChild("AeroDynamicSlashVFX") then
                ball.AeroDynamicSlashVFX:Destroy()
                S.tornadoTime = tick()
            end
            if Runtime:FindFirstChild("Tornado") then
                if (tick() - S.tornadoTime) < (Runtime.Tornado:GetAttribute("TornadoTime") or 1) + 0.314159 then return end
            end
            if oneBall and oneBall:GetAttribute("target") == LocalPlayer.Name and curved then return end
            if ball:FindFirstChild("ComboCounter") then return end
            if char.PrimaryPart:FindFirstChild("SingularityCape") then return end
            if S.det.infinity and S.infinityActive then return end
            if S.det.deathslash and S.deathslashActive then return end
            if S.det.timehole and S.timeholeActive then return end
            if S.det.slashes and S.slashesActive then return end
            if target == LocalPlayer.Name and distance <= accuracy then
                if S.autoAbility then
                    local used = false
                    pcall(function()
                        local cd = LocalPlayer.PlayerGui.Hotbar.Ability.UIGradient
                        local abilities = char:FindFirstChild("Abilities")
                        if cd and cd.Offset.Y == 0.5 and abilities then
                            for _, n in ipairs({ "Raging Deflection", "Rapture", "Calming Deflection", "Aerodynamic Slash", "Fracture", "Death Slash" }) do
                                local a = abilities:FindFirstChild(n)
                                if a and a.Enabled then
                                    S.parried = true
                                    ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                                    task.wait(2.432)
                                    ReplicatedStorage.Remotes.DeathSlashShootActivation:FireServer(true)
                                    used = true
                                    break
                                end
                            end
                        end
                    end)
                    if used then return end
                end
                parryAction()
                S.parried = true
            end
            local t0 = tick()
            repeat RunService.Stepped:Wait() until (tick() - t0) >= 1 or not S.parried
            S.parried = false
        end

        local function autoparryStep()
            local char = LocalPlayer.Character
            if not S.autoparry or not char or not char.PrimaryPart then return end
            local oneBall = getBall()
            for _, ball in pairs(getAllBalls()) do
                if S.triggerEnabled then return end
                handleBall(ball, oneBall)
            end
            local tb = Workspace:FindFirstChild("TrainingBalls")
            if tb and not S.trainingParried then
                for _, inst in pairs(tb:GetChildren()) do
                    if inst:GetAttribute("realBall") then
                        local zoomies = inst:FindFirstChild("zoomies")
                        if zoomies then
                            inst:GetAttributeChangedSignal("target"):Once(function() S.trainingParried = false end)
                            local distance = LocalPlayer:DistanceFromCharacter(inst.Position)
                            local speed = zoomies.VectorVelocity.Magnitude
                            local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
                            local capped = math.min(math.max(speed - 9.5, 0), 650)
                            local acc = math.clamp(ping / 10, 5, 17) + math.max(speed / ((2.4 + capped * 0.002) * S.divisor), 9.5)
                            if inst:GetAttribute("target") == LocalPlayer.Name and distance <= acc then
                                parryAction()
                                S.trainingParried = true
                                local t0 = tick()
                                repeat RunService.Stepped:Wait() until (tick() - t0) >= 1 or not S.trainingParried
                                S.trainingParried = false
                            end
                        end
                        break
                    end
                end
            end
        end

        -- ===== Instant Parry: парри в момент, когда мяч стал целью меня =====
        local instantFired = setmetatable({}, { __mode = "k" })
        local function instantStep()
            local char = LocalPlayer.Character
            if not S.instant or not char or not char.PrimaryPart then return end
            for _, ball in pairs(getAllBalls()) do
                local isMine = ball:GetAttribute("target") == LocalPlayer.Name
                if isMine then
                    if not instantFired[ball] then
                        local d = (char.PrimaryPart.Position - ball.Position).Magnitude
                        if d <= S.instantRange then
                            instantFired[ball] = true
                            parryAction()
                            S.parried = true
                            task.delay(1, function() S.parried = false end)
                        end
                    end
                else
                    instantFired[ball] = nil
                end
            end
        end

        -- ===== Auto Spam: клэш + предугадывание =====
        local function playerByName(name)
            return name and Alive:FindFirstChild(name) or nil
        end
        -- кому полетит мяч после удара игрока hitterName: ближайший к направлению взгляда
        -- (для меня - направление камеры, для остальных - взгляд их персонажа)
        local function nextTargetFrom(hitterName)
            local hitter = playerByName(hitterName)
            local hrp = hitter and hitter:FindFirstChild("HumanoidRootPart")
            if not hrp then return nil end
            local look
            if hitterName == LocalPlayer.Name then
                look = Workspace.CurrentCamera.CFrame.LookVector
            else
                local head = hitter:FindFirstChild("Head")
                look = (head or hrp).CFrame.LookVector
            end
            local best, bestDot = nil, -2
            for _, e in ipairs(Alive:GetChildren()) do
                if e ~= hitter and e.PrimaryPart then
                    local dir = e.PrimaryPart.Position - hrp.Position
                    if dir.Magnitude > 0.1 then
                        local d = look:Dot(dir.Unit)
                        if d > bestDot then bestDot, best = d, e end
                    end
                end
            end
            return best
        end

        local predHl, predBb
        local function setPredict(ent)
            if not (S.spamPredict and S.spamHighlight and ent and ent.PrimaryPart) then
                if predHl then predHl.Enabled = false end
                if predBb then predBb.Enabled = false end
                return
            end
            if not predHl or not predHl.Parent then
                predHl = Instance.new("Highlight")
                predHl.FillColor = Color3.fromRGB(70, 255, 120)
                predHl.OutlineColor = Color3.new(1, 1, 1)
                predHl.FillTransparency = 0.45
                predHl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                predHl.Parent = Holder
                predBb = Instance.new("BillboardGui")
                predBb.Size = UDim2.fromOffset(130, 24)
                predBb.StudsOffset = Vector3.new(0, 3.4, 0)
                predBb.AlwaysOnTop = true
                predBb.Parent = Holder
                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.fromScale(1, 1)
                tl.BackgroundTransparency = 1
                tl.Text = "PREDICT"
                tl.Font = Enum.Font.GothamBold
                tl.TextSize = 14
                tl.TextColor3 = Color3.fromRGB(70, 255, 120)
                tl.TextStrokeTransparency = 0
                tl.Parent = predBb
                OnUnload(function()
                    pcall(function() predHl:Destroy() end)
                    pcall(function() predBb:Destroy() end)
                end)
            end
            predHl.Adornee = ent
            predHl.Enabled = true
            predBb.Adornee = ent:FindFirstChild("Head") or ent.PrimaryPart
            predBb.Enabled = true
        end

        local spam = { active = false, since = 0, by = "normal" }
        local function spamStart(by)
            if spam.active then return end
            spam = { active = true, since = os.clock(), by = by }
        end
        local function spamStop()
            spam.active = false
        end
        BB.SpamActive = function() return spam.active, spam.by end

        local function autoSpamStep()
            local ball = getBall()
            local char = LocalPlayer.Character
            if not ball or S.slashesActive or not char or not char.PrimaryPart then
                spamStop()
                setPredict(nil)
                return
            end
            local zoomies = ball:FindFirstChild("zoomies")
            if not zoomies then spamStop() return end
            local me = LocalPlayer.Name
            local target = ball:GetAttribute("target")
            local pos = char.PrimaryPart.Position
            local now = os.clock()
            local targetIsMe = target == me

            -- кого «думает» предугадывание: тот, кому уйдёт мяч после удара текущей цели
            if S.spamPredict and S.spamHighlight and target then
                local nxt = nextTargetFrom(target)
                if nxt == char then nxt = nil end
                setPredict(nxt)
            else
                setPredict(nil)
            end

            -- вход в спам по предугадыванию: мяч летит к игроку рядом со мной и уже вплотную к нему
            if not spam.active and not targetIsMe and target then
                local tEnt = playerByName(target)
                if tEnt and tEnt.PrimaryPart then
                    local dMe = (tEnt.PrimaryPart.Position - pos).Magnitude
                    local dBall = (ball.Position - tEnt.PrimaryPart.Position).Magnitude
                    if dMe <= S.spamNear and dBall <= S.spamBallNear then
                        if not S.spamPredict or nextTargetFrom(target) == char then
                            spamStart("predict")
                        end
                    end
                end
            end

            -- обычный клэш: я уже парирую подряд, а мяч летит в меня
            if not spam.active and targetIsMe and S.parries > S.spamThreshold then
                local entity = getClosest()
                if entity and entity.PrimaryPart then
                    local speed = ball.AssemblyLinearVelocity.Magnitude
                    local pingT = math.clamp(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10, 1, 16)
                    local maxSpam = pingT + math.min(speed / 6, 255)
                    local eDist = (pos - entity.PrimaryPart.Position).Magnitude
                    local bDist = (pos - ball.Position).Magnitude
                    if eDist <= maxSpam and bDist <= maxSpam then spamStart("normal") end
                end
            end

            if not spam.active then return end

            -- условия остановки: мяч перестал лететь в меня (после льготного окна предугадывания)
            local inGrace = spam.by == "predict" and (now - spam.since) <= S.spamGrace
            if not targetIsMe and not inGrace then
                spamStop()
                return
            end
            if char:GetAttribute("Pulsed") then return end
            parryExecute()
        end

        -- ===== Triggerbot =====
        local triggerCooldown = false
        local function triggerbotStep()
            local char = LocalPlayer.Character
            if triggerCooldown or S.triggerParrying or not char or not char.PrimaryPart then return end
            if char.PrimaryPart:FindFirstChild("SingularityCape") then return end
            local balls = Workspace:FindFirstChild("Balls")
            if not balls then return end
            for _, ball in pairs(balls:GetChildren()) do
                if ball:IsA("BasePart") and ball:GetAttribute("target") == LocalPlayer.Name then
                    triggerCooldown = true
                    S.triggerParrying = true
                    parryExecute()
                    playGrabParry()
                    task.delay(0.2, function() triggerCooldown = false end)
                    task.delay(0.15, function() S.triggerParrying = false end)
                    break
                end
            end
        end

        Track(RunService.PreSimulation:Connect(function()
            if S.autoparry then pcall(autoparryStep) end
            if S.instant then pcall(instantStep) end
            if S.autoSpam then
                pcall(autoSpamStep)
            else
                if spam.active then spamStop() end
                if predHl then setPredict(nil) end
            end
        end))
        Track(RunService.Heartbeat:Connect(function()
            if S.manualSpam and capturedRemote then
                pcall(function()
                    fireParry(getCurveCFrame())
                    playGrabParry()
                end)
            end
            if S.triggerEnabled then pcall(triggerbotStep) end
            if S.randomCurve then BB.Curve = CURVE_NAMES[math.random(1, #CURVE_NAMES)] end
        end))
        -- сброс «чужого» Slash of Fury, если End не пришёл
        task.spawn(function()
            while BB.Alive do
                task.wait(1)
                if sof.other and os.clock() - sof.since > 20 then sof.other = false end
            end
        end)
        return true, "Blade Ball: модуль загружен (метод VIREX)"
    end

    function BB.Ensure()
        if BB.Loaded then return true end
        if BB.Loading then
            while BB.Loading do task.wait(0.1) end
            return BB.Loaded
        end
        BB.Loading = true
        local ok, res, msg = pcall(build)
        BB.Loading = false
        if not ok then
            Toast("Blade Ball: " .. tostring(res):sub(1, 70), "bad")
            return false
        end
        if res then
            BB.Loaded = true
            Toast(msg, "ok")
            return true
        end
        Toast(tostring(msg), "bad")
        return false
    end

    -- ===== способности / меч для ESP =====
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

    -- ===== режимы =====
    local ui, fl = {}, {}
    local state = { autoparry = false, autospam = false, trigger = false, manual = false }
    local function applyMode(name, v)
        state[name] = v
        if name == "autoparry" then
            S.autoparry, S.animation = v, v
        elseif name == "autospam" then
            S.autoSpam = v
        elseif name == "trigger" then
            S.triggerEnabled = v
        elseif name == "manual" then
            S.manualSpam = v
        end
        if ui[name] then ui[name].Set(v) end
        if fl[name] then fl[name].SetOn(v) end
    end
    -- Triggerbot несовместим ТОЛЬКО с Auto Parry. Выключение триггера сразу включает Auto Parry.
    local function setMode(name, v)
        if v and not BB.Ensure() then
            applyMode(name, false)
            return false
        end
        if name == "trigger" then
            if v then
                if state.autoparry then
                    applyMode("autoparry", false)
                    Toast("Auto Parry выключен на время Triggerbot")
                end
                applyMode("trigger", true)
            else
                applyMode("trigger", false)
                if BB.Ensure() then
                    applyMode("autoparry", true)
                    Toast("Triggerbot выключен - Auto Parry включён", "ok")
                end
            end
        elseif name == "autoparry" and v and state.trigger then
            applyMode("trigger", false)
            applyMode("autoparry", true)
            Toast("Triggerbot выключен (несовместим с Auto Parry)")
        else
            applyMode(name, v)
        end
        return true
    end
    BB.SetMode = setMode

    -- ===== UI =====
    local TabBB = CreateTab("Blade Ball")
    TabBB:Section("Модуль")
    local status = TabBB:List()
    local statusLbl = status:Info("Модуль не загружен")
    TabBB:Button("Загрузить модуль Blade Ball", nil, function(b)
        task.spawn(function()
            if BB.Ensure() then b.Text = "Модуль загружен ✓" end
        end)
    end)
    TabBB:Button("Перехватить парри заново (потом один ручной парри)", nil, function()
        if BB.Loaded and BB.Rehook then
            BB.Rehook()
            Toast("Хук поставлен, сделай один ручной парри")
        else
            Toast("Сначала загрузи модуль", "bad")
        end
    end)

    -- окна настроек (шестерёнки)
    local winParry = SettingsWindow("Настройки Auto Parry")
    do
        local W = winParry.P
        W:Section("Accuracy")
        W:Slider("Accuracy (ручной)", 1, 100, S.accuracy, 1, function(v)
            S.accuracy = v
            BB.UpdateDivisor()
        end)
        W:Toggle("Auto Accuracy (пинг + скорость мяча)", false, function(v) S.autoAcc = v end)
        W:Slider("Range accuracy: минимум", 1, 100, S.accMin, 1, function(v) S.accMin = v end)
        W:Slider("Range accuracy: максимум", 1, 100, S.accMax, 1, function(v) S.accMax = v end)
        W:Section("Парри")
        local curveOpts = {}
        for _, n in ipairs(CURVE_NAMES) do table.insert(curveOpts, { n, n }) end
        W:Selector("Curve", curveOpts, BB.Curve, function(v) BB.Curve = v end)
        W:Toggle("Random Curve", false, function(v) S.randomCurve = v end)
        W:Toggle("Auto Ability", false, function(v) S.autoAbility = v end)
        W:Section("Детекторы способностей")
        W:Toggle("Infinity", false, function(v) S.det.infinity = v end)
        W:Toggle("Death Slash", false, function(v) S.det.deathslash = v end)
        W:Toggle("Time Hole", false, function(v) S.det.timehole = v end)
        W:Toggle("Slashes Of Fury (моя)", false, function(v) S.det.slashes = v end)
    end
    local winSpam = SettingsWindow("Настройки Auto Spam")
    do
        local W = winSpam.P
        W:Section("Предугадывание")
        W:Toggle("Предугадывание (мяч к игроку рядом со мной)", S.spamPredict, function(v) S.spamPredict = v end)
        W:Toggle("Подсветка цели (зелёные chams + текст)", S.spamHighlight, function(v) S.spamHighlight = v end)
        W:Slider("Игрок рядом со мной, студов", 1, 15, S.spamNear, 1, function(v) S.spamNear = v end)
        W:Slider("Мяч у него ближе, студов", 1, 10, S.spamBallNear, 1, function(v) S.spamBallNear = v end)
        W:Slider("Проверка через, сек", 1, 5, S.spamGrace, 1, function(v) S.spamGrace = v end)
        W:Label("Спам идёт, пока мяч летит в меня. Если после проверки мяч ушёл к другому - спам выключается сразу.")
    end
    local winSof = SettingsWindow("Anti Slash of Fury")
    do
        local W = winSof.P
        W:Section("Задержка парри")
        W:Slider("После конца абилки, мс (0 - мгновенно)", 0, 1000, S.antiSofMs, 10, function(v) S.antiSofMs = v end)
        W:Label("Единичный парри: ждёт конца Slash of Fury у соперника, затем парирует через заданные мс. Режимы Auto Parry / Trigger / Spam не отключаются.")
    end

    TabBB:Section("Основные режимы")
    ui.autoparry = TabBB:ToggleGear("Auto Parry", false, function(v)
        task.spawn(function() setMode("autoparry", v) end)
    end, function() winParry.Toggle() end)
    TabBB:Toggle("Instant Parry (мгновенно при цели на меня)", false, function(v)
        task.spawn(function()
            if v and not BB.Ensure() then return end
            S.instant = v
        end)
    end)
    TabBB:Slider("Instant: макс. дистанция, студов", 5, 80, S.instantRange, 1, function(v) S.instantRange = v end)
    ui.trigger = TabBB:Toggle("Triggerbot (несовместим с Auto Parry)", false, function(v)
        task.spawn(function() setMode("trigger", v) end)
    end)
    ui.autospam = TabBB:ToggleGear("Auto Spam", false, function(v)
        task.spawn(function() setMode("autospam", v) end)
    end, function() winSpam.Toggle() end)
    ui.manual = TabBB:Toggle("Manual Spam (удобнее кнопкой на экране)", false, function(v)
        task.spawn(function() setMode("manual", v) end)
    end)
    TabBB:ToggleGear("Anti Slash of Fury", false, function(v)
        task.spawn(function()
            if v and not BB.Ensure() then return end
            S.antiSof = v
        end)
    end, function() winSof.Toggle() end)

    -- ===== кнопки на экране =====
    TabBB:Section("Кнопки на экране (двигай за рамку)")
    local function bbFloater(key, text)
        local F = Floater("bb_" .. key, text, function()
            task.spawn(function() setMode(key, not state[key]) end)
        end, { toggle = true })
        fl[key] = F
        FloaterToggle(TabBB, F, "Кнопка: " .. text)
        return F
    end
    BB.Floaters = {
        bbFloater("autoparry", "Auto Parry"),
        bbFloater("trigger", "Triggerbot"),
        bbFloater("manual", "Manual Spam"),
        bbFloater("autospam", "Auto Spam"),
    }

    -- ===== ESP =====
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
        print("[Nexus] diag:", best.Name)
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

    TabBB:Section("Горячие клавиши")
    TabBB:Label("T - Auto Parry, V - Auto Spam, F (зажать) - Manual Spam.")
    local hotkeys = false
    TabBB:Toggle("Включить горячие клавиши", false, function(v) hotkeys = v end)
    Track(UserInputService.InputBegan:Connect(function(input, processed)
        if not hotkeys or processed or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        task.spawn(function()
            if input.KeyCode == Enum.KeyCode.T then
                setMode("autoparry", not state.autoparry)
            elseif input.KeyCode == Enum.KeyCode.V then
                setMode("autospam", not state.autospam)
            elseif input.KeyCode == Enum.KeyCode.F then
                setMode("manual", true)
            end
        end)
    end))
    Track(UserInputService.InputEnded:Connect(function(input)
        if hotkeys and input.KeyCode == Enum.KeyCode.F and state.manual then applyMode("manual", false) end
    end))

    -- статус модуля
    task.spawn(function()
        while BB.Alive do
            local txt
            if BB.Loaded then
                txt = BB.HasToken and BB.HasToken() and "● модуль загружен, ремоут перехвачен" or "● модуль загружен - сделай один ручной парри"
                local sa, by = false, nil
                if BB.SpamActive then sa, by = BB.SpamActive() end
                if sa then txt = txt .. "  ·  SPAM (" .. tostring(by) .. ")" end
            elseif BB.Loading then
                txt = "○ загрузка (ждём 5 сек как в VIREX)..."
            else
                txt = "○ модуль не загружен"
            end
            if statusLbl and statusLbl.Parent then statusLbl.Text = txt end
            task.wait(0.5)
        end
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
    local infoLbl = info:Info("Убийца: -  ·  Шериф: -", Theme.Text)

    TabC:Section("Silent Aim (один хук для пистолета и ножа)")
    TabC:Label("Хук ставится при первом включении. Нужны hookmetamethod / getnamecallmethod.")
    TabC:Selector("Предсказание", { { "Dynamic", "Dynamic" }, { "Default", "Default" } }, MM2C.Mode, function(v) MM2C.Mode = v end)
    local uiGun, uiKnife, fGun, fKnife
    local function setGun(v)
        if v and not ensureHook() then v = false end
        MM2C.GunAim = v
        if uiGun then uiGun.Set(v) end
        if fGun then fGun.SetOn(v) end
    end
    local function setKnife(v)
        if v and not ensureHook() then v = false end
        MM2C.KnifeAim = v
        if uiKnife then uiKnife.Set(v) end
        if fKnife then fKnife.SetOn(v) end
    end
    uiGun = TabC:Toggle("Gun silent aim (шериф -> убийца)", false, setGun)
    uiKnife = TabC:Toggle("Knife silent aim (убийца -> цель)", false, setKnife)
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

    -- ===== кнопки на экране =====
    TabC:Section("Кнопки на экране (двигай за рамку)")
    local fShoot = Floater("mm2_shoot", "Выстрел в убийцу", function() task.spawn(MM2C.ShootMurderer) end)
    FloaterToggle(TabC, fShoot, "Кнопка: Выстрел в убийцу")
    local fGrab = Floater("mm2_grab", "Забрать пистолет", function() task.spawn(MM2C.GrabGun) end)
    FloaterToggle(TabC, fGrab, "Кнопка: Забрать пистолет")
    fGun = Floater("mm2_gun", "Gun Silent", function() setGun(not MM2C.GunAim) end, { toggle = true })
    FloaterToggle(TabC, fGun, "Кнопка: Gun Silent Aim")
    fKnife = Floater("mm2_knife", "Knife Silent", function() setKnife(not MM2C.KnifeAim) end, { toggle = true })
    FloaterToggle(TabC, fKnife, "Кнопка: Knife Silent Aim")
    MM2C.Floaters = { fShoot, fGrab, fGun, fKnife }

    -- фоновое обновление: инфо-строка и подсветка GunDrop
    local gunHl
    task.spawn(function()
        while MM2CAlive do
            task.wait(0.5)
            pcall(function()
                local m, s = findMurder(), findSheriff()
                infoLbl.Text = "Убийца: " .. (m and m.Name or "-") .. "  ·  Шериф: " .. (s and s.Name or "-")
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


-- ============================================================
-- GAMES / Guts & Blackpowder (PlaceId 12334109280)
-- ВАЖНО: структура этой игры мне неизвестна, всё построено на эвристиках (имена моделей/инструментов,
-- ProximityPrompt, атрибуты). Кнопка «Сканировать игру» выводит в консоль (F9) реальные имена -
-- по ним можно точно подогнать фильтры.
-- ============================================================
local GB = { Alive = true, Zombies = {}, Floaters = {} }
OnUnload(function() GB.Alive = false end)
do
    local LocalPlayer = lplayer
    local VIM
    pcall(function() VIM = Service("VirtualInputManager") end)

    local TYPES = { "Bomber", "Shambler", "Runner", "Zapper", "Igniter", "Cuirassier" }
    local COL = {
        Bomber = Color3.fromRGB(255, 140, 20), Shambler = Color3.fromRGB(160, 90, 230), Runner = Color3.fromRGB(255, 40, 40),
        Zapper = Color3.fromRGB(90, 190, 110), Igniter = Color3.fromRGB(255, 215, 40), Cuirassier = Color3.fromRGB(170, 60, 60),
        Team = Color3.fromRGB(135, 206, 235),
    }
    local PATTERNS = {
        { "Bomber", { "bomb", "barrel", "explo", "keg" } },
        { "Runner", { "runner", "sprinter" } },
        { "Zapper", { "zapper", "zap" } },
        { "Igniter", { "igniter", "ignit", "torch", "flame" } },
        { "Cuirassier", { "cuirass", "kiras", "armor", "knight" } },
        { "Shambler", { "shambler", "walker", "zombie", "husk", "ghoul" } },
    }
    local CFG = {
        esp = false, espOn = { Bomber = true, Shambler = true, Runner = true, Zapper = true, Igniter = true, Cuirassier = true },
        teamEsp = false, alerts = true,
        shoot = false, part = "Head", maxM = 300, checkWall = true, rescue = true, shootOn = { Bomber = true, Shambler = true, Runner = true, Zapper = true, Igniter = true, Cuirassier = true },
        reload = false, coins = false, coinRadius = 40, supplies = false,
        medic = false, medicHp = 30, priest = false, priestInf = 100, sacrifice = false,
        autoEquip = false, autoStrike = false, aimHead = false,
        officer = false, officerKey = "R", musician = false, sapper = false,
    }
    GB.CFG = CFG

    local function textsOf(model, hum)
        local t = { model.Name:lower() }
        if hum and hum.DisplayName then t[#t + 1] = hum.DisplayName:lower() end
        for _, holder in ipairs({ model, hum }) do
            if holder then
                for k, v in pairs(holder:GetAttributes()) do
                    t[#t + 1] = tostring(k):lower()
                    if type(v) == "string" then t[#t + 1] = v:lower() end
                end
            end
        end
        for _, c in ipairs(model:GetChildren()) do t[#t + 1] = c.Name:lower() end
        return t
    end
    local function classify(model, hum)
        local texts = textsOf(model, hum)
        for _, p in ipairs(PATTERNS) do
            for _, w in ipairs(p[2]) do
                for _, tx in ipairs(texts) do
                    if tx:find(w, 1, true) then return p[1] end
                end
            end
        end
        -- запасной вариант по характеристикам, пока имена не уточнены сканом
        if hum then
            if hum.WalkSpeed >= 20 then return "Runner" end
            if hum.MaxHealth >= 300 then return "Cuirassier" end
        end
        return "Shambler"
    end
    local function isPlayerChar(model)
        return Players:GetPlayerFromCharacter(model) ~= nil
    end

    -- ===== список зомби: только папка Workspace.Zombies (в логах все зомби называются Agent) =====
    local function scanZombies()
        local found = {}
        local root = Workspace:FindFirstChild("Zombies")
        if not root then
            GB.Zombies = found
            return
        end
        local function consider(m)
            if m:IsA("Model") and not isPlayerChar(m) then
                local hum = m:FindFirstChildOfClass("Humanoid")
                local hrp = m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart
                if hum and hrp and hum.Health > 0 then
                    found[m] = { type = classify(m, hum), hum = hum, hrp = hrp }
                end
            end
        end
        for _, c in ipairs(root:GetChildren()) do
            consider(c)
            if c:IsA("Folder") then
                for _, c2 in ipairs(c:GetChildren()) do consider(c2) end
            end
        end
        GB.Zombies = found
    end

    local function myRoot()
        local c = LocalPlayer.Character
        return c and c:FindFirstChild("HumanoidRootPart")
    end
    local function studsToM(s) return s * 0.28 end

    -- ===== статус зомби (эвристика по атрибутам и анимациям) =====
    local STATUS_WORDS = {
        Bomber = { "explo", "fuse", "prime", "detonat", "boom" },
        Zapper = { "attack", "swing", "raise", "chop", "zap", "windup" },
        Cuirassier = { "charge", "lunge", "run", "attack" },
        Igniter = { "ignite", "attack", "burn" },
    }
    local function statusOf(info)
        local words = STATUS_WORDS[info.type]
        if not words then return false end
        local m = info.hrp.Parent
        for k, v in pairs(m:GetAttributes()) do
            local kk = tostring(k):lower()
            if v == true then
                for _, w in ipairs(words) do
                    if kk:find(w, 1, true) then return true end
                end
            end
        end
        local animator = info.hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
                local nm = (tr.Name .. " " .. (tr.Animation and tr.Animation.Name or "")):lower()
                for _, w in ipairs(words) do
                    if nm:find(w, 1, true) then return true end
                end
            end
        end
        if info.type == "Cuirassier" and info.hrp.AssemblyLinearVelocity.Magnitude > 24 then return true end
        return false
    end

    -- ===== ESP зомби (только chams + статус над головой) =====
    local hls, bbs = {}, {}
    local function dropVisual(m)
        if hls[m] then hls[m]:Destroy(); hls[m] = nil end
        if bbs[m] then bbs[m]:Destroy(); bbs[m] = nil end
    end
    local function ensureHl(m)
        local h = hls[m]
        if not h or not h.Parent then
            h = Instance.new("Highlight")
            h.FillTransparency = 0.5
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Adornee = m
            h.Parent = Holder
            hls[m] = h
        end
        return h
    end
    local function ensureBb(m, head)
        local b = bbs[m]
        if not b or not b.Parent then
            b = Instance.new("BillboardGui")
            b.Size = UDim2.fromOffset(150, 22)
            b.StudsOffset = Vector3.new(0, 3.2, 0)
            b.AlwaysOnTop = true
            b.Adornee = head
            b.Parent = Holder
            local tl = Instance.new("TextLabel")
            tl.Name = "T"
            tl.Size = UDim2.fromScale(1, 1)
            tl.BackgroundTransparency = 1
            tl.Font = Enum.Font.GothamBold
            tl.TextSize = 13
            tl.TextStrokeTransparency = 0
            tl.Parent = b
            bbs[m] = b
        end
        return b
    end

    -- ===== схваченные тиммейты =====
    local alertAt = {}
    local grabbed = {} -- [Player] = { by = typeName, zombie = model }
    local function updateGrabbed()
        grabbed = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local bestZ, bd = nil, 6
                    for m, info in pairs(GB.Zombies) do
                        local d = (info.hrp.Position - hrp.Position).Magnitude
                        if d < bd then bd, bestZ = d, m end
                    end
                    if bestZ then
                        local st = hum:GetState()
                        local held = st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
                            or st == Enum.HumanoidStateType.PlatformStand or st == Enum.HumanoidStateType.FallingDown
                            or hum.WalkSpeed < 1 or hum.PlatformStand
                        for k, v in pairs(p.Character:GetAttributes()) do
                            local kk = tostring(k):lower()
                            if v == true and (kk:find("grab") or kk:find("held") or kk:find("pinned") or kk:find("caught")) then held = true end
                        end
                        if held then
                            grabbed[p] = { by = GB.Zombies[bestZ].type, zombie = bestZ }
                            if CFG.alerts and (os.clock() - (alertAt[p] or 0)) > 5 then
                                alertAt[p] = os.clock()
                                Toast(p.Name .. " схвачен (" .. GB.Zombies[bestZ].type .. ") - Need help", "bad")
                            end
                        end
                    end
                end
            end
        end
    end

    local teamHl = {}
    local function updateVisuals()
        local seen = {}
        if CFG.esp then
            for m, info in pairs(GB.Zombies) do
                if CFG.espOn[info.type] and m.Parent then
                    seen[m] = true
                    local h = ensureHl(m)
                    local c = COL[info.type]
                    h.FillColor, h.OutlineColor, h.Enabled = c, c, true
                    if STATUS_WORDS[info.type] then
                        local head = m:FindFirstChild("Head") or info.hrp
                        local b = ensureBb(m, head)
                        local active = statusOf(info)
                        local tl = b.T
                        tl.Text = active and (info.type:upper() .. " !!") or info.type
                        tl.TextColor3 = active and Color3.fromRGB(255, 40, 40) or c
                    end
                end
            end
        end
        for m in pairs(hls) do
            if not seen[m] then dropVisual(m) end
        end
        -- тиммейты: голубые; схваченные - мигают красным и включаются даже при выключенном ESP
        local flash = math.floor(os.clock() * 7) % 2 == 0
        local seenT = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local g = grabbed[p]
                if CFG.teamEsp or g then
                    seenT[p] = true
                    local h = teamHl[p]
                    if not h or not h.Parent then
                        h = Instance.new("Highlight")
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent = Holder
                        teamHl[p] = h
                    end
                    h.Adornee = p.Character
                    h.Enabled = true
                    local c = g and (flash and Color3.fromRGB(255, 30, 30) or Color3.new(1, 1, 1)) or COL.Team
                    h.FillColor, h.OutlineColor, h.FillTransparency = c, c, g and 0.2 or 0.5
                end
            end
        end
        for p, h in pairs(teamHl) do
            if not seenT[p] then h:Destroy(); teamHl[p] = nil end
        end
    end

    -- ===== инструменты =====
    local FIREARM = { "gun", "rifle", "musket", "pistol", "carbine", "blunder", "revolver", "shotgun", "flint", "firearm", "mauser" }
    local MELEE = { "sabre", "saber", "spear", "sword", "knife", "axe", "bayonet", "cutlass", "lance", "pike", "halberd" }
    local function hasWord(name, list)
        name = name:lower()
        for _, w in ipairs(list) do
            if name:find(w, 1, true) then return true end
        end
        return false
    end
    local function heldTool()
        local c = LocalPlayer.Character
        return c and c:FindFirstChildOfClass("Tool")
    end
    local function isGun(tool)
        return tool:GetAttribute("IsGun") == true or hasWord(tool.Name, FIREARM)
    end
    local function findTool(list)
        local c, bp = LocalPlayer.Character, LocalPlayer:FindFirstChild("Backpack")
        for _, holder in ipairs({ c, bp }) do
            if holder then
                for _, t in ipairs(holder:GetChildren()) do
                    if t:IsA("Tool") and hasWord(t.Name, list) then return t end
                end
            end
        end
        return nil
    end
    local function pressKey(name)
        if not VIM then return end
        local kc = Enum.KeyCode[name]
        if not kc then return end
        pcall(function()
            VIM:SendKeyEvent(true, kc, false, game)
            task.wait(0.05)
            VIM:SendKeyEvent(false, kc, false, game)
        end)
    end

    -- ===== авто-выстрел =====
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local PART_NAMES = {
        Head = { "Head" },
        Body = { "UpperTorso", "Torso", "HumanoidRootPart" },
        Legs = { "LowerTorso", "LeftUpperLeg", "Left Leg", "RightUpperLeg", "Right Leg", "HumanoidRootPart" },
    }
    local function aimPartOf(m, which)
        for _, n in ipairs(PART_NAMES[which] or PART_NAMES.Head) do
            local p = m:FindFirstChild(n)
            if p and p:IsA("BasePart") then return p end
        end
        return m:FindFirstChild("HumanoidRootPart")
    end
    local function visible(from, part, model)
        rayParams.FilterDescendantsInstances = { LocalPlayer.Character }
        local hit = Workspace:Raycast(from, part.Position - from, rayParams)
        return hit == nil or hit.Instance:IsDescendantOf(model)
    end
    local function pickTarget(root)
        local cam = Workspace.CurrentCamera
        -- 1) спасение тиммейта: раннер, который держит союзника
        if CFG.rescue then
            for _, g in pairs(grabbed) do
                if g.by == "Runner" and g.zombie.Parent then
                    local part = aimPartOf(g.zombie, CFG.part)
                    if part and (not CFG.checkWall or visible(cam.CFrame.Position, part, g.zombie)) then
                        return g.zombie, part
                    end
                end
            end
        end
        -- 2) остальные: бомбер в приоритете, затем ближайшие
        local best, bestPart, bestScore = nil, nil, math.huge
        for m, info in pairs(GB.Zombies) do
            if CFG.shootOn[info.type] and m.Parent then
                local d = (info.hrp.Position - root.Position).Magnitude
                if studsToM(d) <= CFG.maxM then
                    local part = aimPartOf(m, CFG.part)
                    if part and (not CFG.checkWall or visible(cam.CFrame.Position, part, m)) then
                        local score = d - (info.type == "Bomber" and 1000 or 0)
                        if score < bestScore then bestScore, best, bestPart = score, m, part end
                    end
                end
            end
        end
        return best, bestPart
    end
    local function shootStep()
        local tool = heldTool()
        local root = myRoot()
        if not (tool and root and isGun(tool)) then return end
        local m, part = pickTarget(root)
        if not (m and part) then return end
        local cam = Workspace.CurrentCamera
        cam.CFrame = CFrame.new(cam.CFrame.Position, part.Position)
        pcall(function() tool:Activate() end)
    end

    -- ===== авто-перезарядка =====
    local lastReload = 0
    -- в G&B у оружия есть значения ShotsLoaded (заряды) и ReloadStage (0 = не перезаряжается)
    local function ammoOf(tool)
        local sl = tool:FindFirstChild("ShotsLoaded", true)
        if sl and (sl:IsA("IntValue") or sl:IsA("NumberValue")) then
            local rs = tool:FindFirstChild("ReloadStage", true)
            if rs and rs.Value ~= 0 then return nil end
            return sl.Value
        end
        for k, v in pairs(tool:GetAttributes()) do
            local kk = tostring(k):lower()
            if type(v) == "number" and (kk:find("ammo") or kk:find("clip") or kk:find("mag") or kk:find("shotsloaded")) then return v end
        end
        return nil
    end
    local function reloadStep()
        local tool = heldTool()
        if tool and isGun(tool) and os.clock() - lastReload > 1.5 then
            local a = ammoOf(tool)
            if a ~= nil and a <= 0 then
                lastReload = os.clock()
                pressKey("R")
            end
        end
    end

    -- ===== монеты =====
    local coinCache, coinAt = {}, 0
    local COIN_WORDS = { "coin", "gold", "cash", "money", "loot", "drop" }
    local function coinStep()
        local root = myRoot()
        if not root then return end
        if os.clock() - coinAt > 3 then
            coinAt = os.clock()
            coinCache = {}
            for _, d in ipairs(Workspace:GetDescendants()) do
                if d:IsA("BasePart") and hasWord(d.Name, COIN_WORDS) and not d:FindFirstAncestorOfClass("Humanoid") then
                    local mdl = d:FindFirstAncestorOfClass("Model")
                    if not (mdl and mdl:FindFirstChildOfClass("Humanoid")) then coinCache[#coinCache + 1] = d end
                end
            end
        end
        for i = #coinCache, 1, -1 do
            local p = coinCache[i]
            if not p.Parent then
                table.remove(coinCache, i)
            elseif (p.Position - root.Position).Magnitude <= CFG.coinRadius and firetouchinterest then
                pcall(function()
                    firetouchinterest(root, p, 0)
                    firetouchinterest(root, p, 1)
                end)
            end
        end
    end

    -- ===== ProximityPrompt: лечение / благословение / жертва =====
    local promptCache, promptAt = {}, 0
    local function promptText(pr) return (pr.ActionText .. " " .. pr.ObjectText .. " " .. pr.Name):lower() end
    local function matches(pr, words)
        local t = promptText(pr)
        for _, w in ipairs(words) do
            if t:find(w, 1, true) then return true end
        end
        return false
    end
    local function ownerChar(pr)
        local m = pr:FindFirstAncestorOfClass("Model")
        while m and not m:FindFirstChildOfClass("Humanoid") do m = m.Parent and m.Parent:FindFirstAncestorOfClass("Model") end
        return m
    end
    local function numAttr(inst, words)
        for k, v in pairs(inst:GetAttributes()) do
            local kk = tostring(k):lower()
            if type(v) == "number" then
                for _, w in ipairs(words) do
                    if kk:find(w, 1, true) then return v end
                end
            end
        end
        return nil
    end
    local function fire(pr)
        pcall(function() pr.HoldDuration = 0 end)
        if fireproximityprompt then pcall(fireproximityprompt, pr) end
    end
    local function promptStep()
        local root = myRoot()
        if not root then return end
        if os.clock() - promptAt > 1.5 then
            promptAt = os.clock()
            promptCache = {}
            for _, d in ipairs(Workspace:GetDescendants()) do
                if d:IsA("ProximityPrompt") then promptCache[#promptCache + 1] = d end
            end
        end
        for _, pr in ipairs(promptCache) do
            local part = pr.Parent
            if pr.Parent and pr.Enabled and part and part:IsA("BasePart") then
                if (part.Position - root.Position).Magnitude <= pr.MaxActivationDistance then
                    if CFG.sacrifice and matches(pr, { "sacrific", "пожертв" }) then
                        fire(pr)
                    elseif CFG.supplies and matches(pr, { "grab supplies", "supplies", "replenish" }) then
                        fire(pr)
                    elseif CFG.medic and matches(pr, { "heal", "request", "aid", "лечен", "med" }) then
                        local c = ownerChar(pr)
                        local hum = c and c:FindFirstChildOfClass("Humanoid")
                        if hum and hum.MaxHealth > 0 and (hum.Health / hum.MaxHealth * 100) <= CFG.medicHp then fire(pr) end
                    elseif CFG.priest and matches(pr, { "bless", "благослов", "pray" }) then
                        local c = ownerChar(pr)
                        local inf = c and (numAttr(c, { "infect", "corrupt" }) or (Players:GetPlayerFromCharacter(c) and numAttr(Players:GetPlayerFromCharacter(c), { "infect", "corrupt" })))
                        if inf == nil or inf >= CFG.priestInf then fire(pr) end
                    end
                end
            end
        end
    end

    -- ===== ближний бой / классы =====
    local lastHit, lastRage, lastMusic, lastSapper = 0, 0, 0, 0
    local function nearestZombie(maxStuds, skipBomber)
        local root = myRoot()
        if not root then return nil end
        local best, bd, binfo = nil, maxStuds, nil
        for m, info in pairs(GB.Zombies) do
            if not (skipBomber and info.type == "Bomber") then
                local d = (info.hrp.Position - root.Position).Magnitude
                if d < bd then bd, best, binfo = d, m, info end
            end
        end
        return best, binfo, bd
    end
    local function meleeStep()
        local root = myRoot()
        if not root then return end
        local tool = heldTool()
        if CFG.autoEquip and (not tool or not hasWord(tool.Name, MELEE)) then
            local z = nearestZombie(3, true)
            if z then
                local mt = findTool(MELEE)
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if mt and hum then hum:EquipTool(mt) end
            end
        end
        tool = heldTool()
        if tool and hasWord(tool.Name, MELEE) then
            local isSpear = tool.Name:lower():find("spear", 1, true) ~= nil
            local z, info, d = nearestZombie(12, not isSpear)
            if z and CFG.aimHead then
                local head = z:FindFirstChild("Head") or info.hrp
                local cam = Workspace.CurrentCamera
                cam.CFrame = CFrame.new(cam.CFrame.Position, head.Position)
            end
            if z and CFG.autoStrike and os.clock() - lastHit > 0.25 then
                local reach = info.type == "Cuirassier" and 4 or 3
                if d <= reach then
                    lastHit = os.clock()
                    pcall(function() tool:Activate() end)
                end
            end
        end
    end
    local function classStep()
        local root = myRoot()
        if not root then return end
        local tool = heldTool()
        -- офицер: rage при >50 зомби в 40 студах и >3 союзниках в 50
        if CFG.officer and tool and hasWord(tool.Name, { "sabre", "saber", "spear" }) and os.clock() - lastRage > 6 then
            local zc, pc = 0, 0
            for _, info in pairs(GB.Zombies) do
                if (info.hrp.Position - root.Position).Magnitude <= 40 then zc = zc + 1 end
            end
            for _, p in ipairs(Players:GetPlayers()) do
                local h = p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if h and (h.Position - root.Position).Magnitude <= 50 then pc = pc + 1 end
            end
            if zc > 50 and pc > 3 then
                lastRage = os.clock()
                pressKey(CFG.officerKey)
            end
        end
        -- музыкант: играет на инструменте (кроме трубы с кулдауном)
        if CFG.musician and tool and hasWord(tool.Name, { "flute", "fife", "drum", "pipe", "whistle", "bugle", "свирел", "барабан" })
            and not tool.Name:lower():find("trumpet", 1, true) and os.clock() - lastMusic > 1 then
            lastMusic = os.clock()
            pcall(function() tool:Activate() end)
        end
        -- сапёр: молоток у чертежа, лопата-аура
        if CFG.sapper and tool and os.clock() - lastSapper > 0.45 then
            local n = tool.Name:lower()
            if n:find("hammer", 1, true) or n:find("молот", 1, true) then
                for _, d in ipairs(Workspace:GetChildren()) do
                    local nn = d.Name:lower()
                    if (nn:find("blueprint", 1, true) or nn:find("barricade", 1, true) or nn:find("ghost", 1, true)) and d:IsA("Model") then
                        local pp = d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart", true)
                        if pp and (pp.Position - root.Position).Magnitude <= 12 then
                            lastSapper = os.clock()
                            pcall(function() tool:Activate() end)
                            break
                        end
                    end
                end
            elseif n:find("shovel", 1, true) or n:find("лопат", 1, true) then
                lastSapper = os.clock()
                pcall(function() tool:Activate() end)
            end
        end
    end

    -- ===== главный цикл =====
    task.spawn(function()
        local t = 0
        local function anyOn()
            return CFG.esp or CFG.teamEsp or CFG.shoot or CFG.reload or CFG.coins or CFG.supplies or CFG.medic
                or CFG.priest or CFG.sacrifice or CFG.autoEquip or CFG.autoStrike or CFG.aimHead
                or CFG.officer or CFG.musician or CFG.sapper
        end
        while GB.Alive do
            task.wait(0.1)
            if not anyOn() then
                if next(hls) or next(teamHl) then
                    CFG.esp = false
                    updateVisuals()
                end
                task.wait(0.4)
                continue
            end
            t = t + 1
            pcall(function()
                if t % 4 == 1 then
                    scanZombies()
                    updateGrabbed()
                end
                updateVisuals()
                if CFG.shoot then shootStep() end
                if CFG.reload and t % 3 == 0 then reloadStep() end
                if CFG.coins and t % 5 == 0 then coinStep() end
                if (CFG.sacrifice or CFG.medic or CFG.priest or CFG.supplies) and t % 2 == 0 then promptStep() end
                if CFG.autoEquip or CFG.autoStrike or CFG.aimHead then meleeStep() end
                if CFG.officer or CFG.musician or CFG.sapper then classStep() end
            end)
        end
    end)
    OnUnload(function()
        for m in pairs(hls) do dropVisual(m) end
        for _, h in pairs(teamHl) do pcall(function() h:Destroy() end) end
    end)

    -- ===== UI =====
    local winEsp = SettingsWindow("ESP зомби - настройки")
    do
        local W = winEsp.P
        W:Section("Какие зомби подсвечивать")
        for _, tn in ipairs(TYPES) do
            W:Toggle(tn, true, function(v) CFG.espOn[tn] = v end)
        end
        W:Section("Цвета (можно менять)")
        for _, tn in ipairs(TYPES) do
            W:ColorPicker(tn, COL[tn], function(c) COL[tn] = c end)
        end
        W:ColorPicker("Тиммейты", COL.Team, function(c) COL.Team = c end)
    end
    local winShoot = SettingsWindow("Авто-выстрел - настройки")
    do
        local W = winShoot.P
        W:Section("Цель")
        W:Selector("Куда целиться", { { "Голова", "Head" }, { "Тело", "Body" }, { "Ноги", "Legs" } }, CFG.part, function(v) CFG.part = v end)
        W:Slider("Макс. дистанция, м (1-600)", 1, 600, CFG.maxM, 1, function(v) CFG.maxM = v end)
        W:Toggle("Check wall (не стрелять через стены)", CFG.checkWall, function(v) CFG.checkWall = v end)
        W:Toggle("Спасать тиммейта от раннера (приоритет)", CFG.rescue, function(v) CFG.rescue = v end)
        W:Section("Список зомби для стрельбы")
        for _, tn in ipairs(TYPES) do
            W:Toggle(tn, true, function(v) CFG.shootOn[tn] = v end)
        end
    end

    local TabGB = CreateTab("G&B")
    TabGB:Section("ESP")
    TabGB:ToggleGear("ESP зомби (chams)", false, function(v) CFG.esp = v end, function() winEsp.Toggle() end)
    TabGB:Toggle("ESP тиммейтов (голубой)", false, function(v) CFG.teamEsp = v end)
    TabGB:Toggle("Тревога, когда тиммейта схватили", true, function(v) CFG.alerts = v end)

    TabGB:Section("Бой")
    local uiShoot, fShoot
    uiShoot = TabGB:ToggleGear("Авто-выстрел (нужен огнестрел в руках)", false, function(v)
        CFG.shoot = v
        if fShoot then fShoot.SetOn(v) end
    end, function() winShoot.Toggle() end)
    TabGB:Toggle("Авто-перезарядка", false, function(v) CFG.reload = v end)
    TabGB:Toggle("Авто-подбор монет", false, function(v) CFG.coins = v end)
    TabGB:Toggle("Авто-взять припасы (Grab Supplies)", false, function(v) CFG.supplies = v end)
    TabGB:Slider("Радиус подбора монет, студов", 5, 80, CFG.coinRadius, 1, function(v) CFG.coinRadius = v end)

    TabGB:Section("Ближний бой")
    TabGB:Toggle("Авто-взять оружие (зомби ≤ 3 студов, кроме бомбера)", false, function(v) CFG.autoEquip = v end)
    TabGB:Toggle("Авто-удар (≤ 3 студов, кирасир ≤ 4)", false, function(v) CFG.autoStrike = v end)
    TabGB:Toggle("Авто-прицел в голову", false, function(v) CFG.aimHead = v end)

    TabGB:Section("Классы")
    TabGB:Toggle("Медик: авто-запрос лечения", false, function(v) CFG.medic = v end)
    TabGB:Slider("Медик: запрос при HP ≤ %", 1, 100, CFG.medicHp, 1, function(v) CFG.medicHp = v end)
    TabGB:Toggle("Священник: авто-благословение", false, function(v) CFG.priest = v end)
    TabGB:Slider("Священник: заражение ≥", 1, 100, CFG.priestInf, 1, function(v) CFG.priestInf = v end)
    TabGB:Toggle("Сапёр: молоток у чертежа / лопата-аура", false, function(v) CFG.sapper = v end)
    TabGB:Toggle("Офицер: авто-rage (50+ зомби / 3+ союзника)", false, function(v) CFG.officer = v end)
    TabGB:Toggle("Музыкант: авто-игра (кроме трубы)", false, function(v) CFG.musician = v end)
    TabGB:Toggle("San Sebastian: авто-жертва без зажатия", false, function(v) CFG.sacrifice = v end)

    TabGB:Section("Кнопки на экране (двигай за рамку)")
    fShoot = Floater("gb_shoot", "Авто-выстрел", function()
        CFG.shoot = not CFG.shoot
        fShoot.SetOn(CFG.shoot)
        uiShoot.Set(CFG.shoot)
    end, { toggle = true })
    FloaterToggle(TabGB, fShoot, "Кнопка: Авто-выстрел")
    GB.Floaters = { fShoot }

    TabGB:Section("Диагностика")
    TabGB:Label("Если что-то не срабатывает - нажми и пришли текст из консоли (F9): так я подгоню имена под игру.")
    TabGB:Button("Сканировать игру (консоль F9)", nil, function()
        scanZombies()
        local names, n = {}, 0
        for m, info in pairs(GB.Zombies) do names[m.Name] = (names[m.Name] or 0) + 1 end
        print("[Nexus G&B] PlaceId", game.PlaceId, "| зомби по именам:")
        for nm, c in pairs(names) do print("   ", nm, "x" .. c) end
        for m, info in pairs(GB.Zombies) do
            n = n + 1
            if n <= 6 then
                local hum = info.hum
                print("[Nexus G&B] зомби", n, "тип по эвристике:", info.type, "| HP", hum.MaxHealth, "| speed", hum.WalkSpeed, "| DisplayName", hum.DisplayName)
                for k, v in pairs(m:GetAttributes()) do print("     model attr", k, v) end
                for k, v in pairs(hum:GetAttributes()) do print("     humanoid attr", k, v) end
                local kids = {}
                for _, c in ipairs(m:GetChildren()) do kids[#kids + 1] = c.Name .. ":" .. c.ClassName end
                print("     children:", table.concat(kids, ", "))
            end
        end
        local tool = heldTool()
        if tool then
            print("[Nexus G&B] в руках:", tool.Name)
            for k, v in pairs(tool:GetAttributes()) do print("   tool attr", k, v) end
            for _, d in ipairs(tool:GetDescendants()) do
                if d:IsA("ValueBase") then print("   tool value", d.Name, d.Value) end
            end
        end
        local z = Workspace:FindFirstChild("Zombies")
        print("[Nexus G&B] Workspace.Zombies:", z and (#z:GetChildren() .. " объектов") or "нет")
        local pc = 0
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("ProximityPrompt") and pc < 25 then
                pc = pc + 1
                print("   prompt:", d:GetFullName(), "|", d.ActionText, "|", d.ObjectText, "| hold", d.HoldDuration)
            end
        end
        Toast("Скан выведен в консоль (F9)", "ok")
    end)
end


SideLabel("SYSTEM")
-- ============================================================
-- ТЕМЫ: движок тем, хранение в файлах и ИИ-создатель
-- Файлы (в workspace экзекьютора, не зависят от версии скрипта):
--   Nexus.Themes.json   список созданных тем и активная тема
--   Nexus.Ai.json       провайдер, ключ, модель
--   Nexus.AiPrompt.txt  системный промпт для ИИ (можно править)
-- Тема это просто JSON из 12 цветов + opacity + blur (schema 1).
-- Неизвестные ключи игнорируются, недостающие берутся из стандартной темы,
-- поэтому старые темы работают и после обновления скрипта.
-- ============================================================
local ThemeAPI = {}
do
    local HttpService = Service("HttpService")
    local THEMES_FILE, AI_FILE, PROMPT_FILE = "Nexus.Themes.json", "Nexus.Ai.json", "Nexus.AiPrompt.txt"
    local DEFAULT_PROMPT = [==[
You are the visual theme designer of "Nexus", a Roblox executor hub with a glass style interface.
You design colors, glass opacity and blur only. You never write code and never explain anything.

OUTPUT RULES
- Reply with exactly ONE JSON object. No markdown, no code fences, no comments, no text before or after it.
- The user can write in any language (usually Russian). The JSON keys stay in English. The "name" may be in the user's language.
- The message contains "CURRENT THEME JSON" and "USER REQUEST". If the user asks to change the current look (darker, less red, more contrast), start from the current theme and change only what is needed. If the user asks for a new theme, design it from scratch.
- Every color is a hex string "#RRGGBB". Never output color names, rgb() or alpha channels.
- Always output every key listed below.

SCHEMA (schema 1)
{
  "schema": 1,
  "name": "theme name, 2 to 24 characters",
  "accent": "#RRGGBB",
  "text": "#RRGGBB",
  "textDim": "#RRGGBB",
  "panel": "#RRGGBB",
  "element": "#RRGGBB",
  "off": "#RRGGBB",
  "danger": "#RRGGBB",
  "ok": "#RRGGBB",
  "on": "#RRGGBB",
  "bg1": "#RRGGBB",
  "bg2": "#RRGGBB",
  "mini": "#RRGGBB",
  "opacity": 0.85,
  "blur": true
}

WHAT EACH KEY CHANGES IN THE INTERFACE
- accent: the main brand color. ON state of switches, filled part of sliders, the highlighted sidebar tab and its small side bar, window borders (main window, settings windows, popup menus), the round collapsed button ring, main buttons (Join, Search, Add), tab icons, scrollbars, the loader progress bar, launcher card border and logo, borders of on-screen buttons.
- text: all primary text: titles, labels, button captions, track names, input text.
- textDim: secondary text: hints, inactive tab captions, group captions in the sidebar (ESP, MUSIC, TOOLS, GAMES, SYSTEM), placeholders, status lines, small notes.
- panel: base surface of the sidebar, settings windows (gear windows), popup menus, on-screen floating buttons, toast notifications, the favorites list, the launcher card, the AI creator window.
- element: cards and rows inside pages: toggle rows, slider rows, list rows, input boxes, color picker body, server and script cards.
- off: OFF state of switches, empty track of sliders, neutral small round buttons (play, preview, copy, gear), disabled looking controls.
- danger: delete and close buttons, error toasts, red status marks.
- ok: success toasts and green add buttons.
- on: ON state of on-screen floating buttons (text and border) and green status indicators.
- bg1 and bg2: the main window background gradient. It runs diagonally from the top left corner (bg1) to the bottom right corner (bg2). For dark themes bg1 is a slightly lighter tinted shade, bg2 is the darkest color.
- mini: fill of the small round button shown when the menu is collapsed.
- opacity: glass transparency of the whole interface, from 0.3 (very transparent) to 1.0 (solid). Typical value 0.80 to 0.92.
- blur: true or false, blurs the game behind the menu while it is open.

DESIGN RULES
- Contrast is mandatory. text must differ from panel and element by at least 45 percent in brightness, textDim by at least 25 percent.
- accent must be clearly visible on both panel and element and must not equal them.
- For dark themes: panel brightness under 15 percent, element a little lighter than panel, off between element and textDim, bg2 darker than bg1.
- For light themes: panel and element are light, text is near black, bg1 and bg2 are light, blur false, opacity 0.9 or higher.
- danger should stay reddish and ok greenish so their meaning is clear, unless the user asks otherwise. Keep danger different from accent when accent is red (use a darker or more muted red).
- Keep the whole palette coherent: choose one hue family plus one accent, avoid random colors.
- Never copy the colors of the current theme if the user asks for a new theme.

EXAMPLE (user: "red and black theme")
{"schema":1,"name":"Red Black","accent":"#E01E37","text":"#F5F0F0","textDim":"#A89A9C","panel":"#15090B","element":"#241014","off":"#4A2A30","danger":"#8A1F2B","ok":"#2E9E5B","on":"#6EEB96","bg1":"#2A0D12","bg2":"#080506","mini":"#100608","opacity":0.88,"blur":true}
]==]

    local function hexOf(c)
        return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
    end
    local function colorOf(h)
        if type(h) ~= "string" then return nil end
        h = h:gsub("#", ""):gsub("%s+", "")
        if #h == 3 then h = h:sub(1, 1):rep(2) .. h:sub(2, 2):rep(2) .. h:sub(3, 3):rep(2) end
        if not h:match("^%x%x%x%x%x%x$") then return nil end
        return Color3.fromRGB(tonumber(h:sub(1, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16))
    end
    local function lum(c) return 0.2126 * c.R + 0.7152 * c.G + 0.0722 * c.B end

    local TOKENS = { "accent", "text", "textDim", "panel", "element", "off", "danger", "ok", "on", "bg1", "bg2", "mini" }
    local DEFAULT = {
        schema = 1, name = "Nexus", accent = "#7778FF", text = "#F0F0FA", textDim = "#9696AF", panel = "#181822",
        element = "#262634", off = "#46465C", danger = "#963232", ok = "#28AA64", on = "#6EEB96",
        bg1 = "#221E3C", bg2 = "#0C0C12", mini = "#12121A", opacity = 0.85, blur = true,
    }
    local BUILTIN = {
        DEFAULT,
        { schema = 1, name = "Red Black", accent = "#E01E37", text = "#F5F0F0", textDim = "#A89A9C", panel = "#15090B",
          element = "#241014", off = "#4A2A30", danger = "#8A1F2B", ok = "#2E9E5B", on = "#6EEB96",
          bg1 = "#2A0D12", bg2 = "#080506", mini = "#100608", opacity = 0.88, blur = true },
        { schema = 1, name = "Ocean", accent = "#28A8FF", text = "#EAF6FF", textDim = "#8DB2C8", panel = "#0E1B2A",
          element = "#162B40", off = "#35506A", danger = "#9B3A3A", ok = "#2BB673", on = "#6EEB96",
          bg1 = "#0E2A44", bg2 = "#060E18", mini = "#0A1624", opacity = 0.85, blur = true },
        { schema = 1, name = "Light", accent = "#2F6BFF", text = "#1A1C24", textDim = "#5B6070", panel = "#F2F4F8",
          element = "#E2E6EE", off = "#B8BFCC", danger = "#D14343", ok = "#22A06B", on = "#168A52",
          bg1 = "#FFFFFF", bg2 = "#DDE3EE", mini = "#EDEFF5", opacity = 0.92, blur = false },
    }

    local function normalize(raw)
        raw = type(raw) == "table" and raw or {}
        local spec = { schema = 1 }
        spec.name = (type(raw.name) == "string" and raw.name ~= "") and raw.name:sub(1, 24) or "Theme"
        for _, k in ipairs(TOKENS) do
            spec[k] = hexOf(colorOf(raw[k]) or colorOf(DEFAULT[k]))
        end
        spec.opacity = math.clamp(tonumber(raw.opacity) or DEFAULT.opacity, 0.3, 1)
        spec.blur = raw.blur ~= false
        -- защита от нечитаемого текста
        local pl = lum(colorOf(spec.panel))
        local function fix(key, minDiff)
            if math.abs(lum(colorOf(spec[key])) - pl) < minDiff then
                spec[key] = pl > 0.5 and "#14161C" or "#F5F6FA"
            end
        end
        fix("text", 0.45)
        fix("textDim", 0.25)
        return spec
    end

    -- ===== хранение =====
    local Store = { schema = 1, active = "Nexus", themes = {} }
    pcall(function()
        if isfile and readfile and isfile(THEMES_FILE) then
            local d = HttpService:JSONDecode(readfile(THEMES_FILE))
            if type(d) == "table" then
                if type(d.active) == "string" then Store.active = d.active end
                if type(d.themes) == "table" then Store.themes = d.themes end
            end
        end
    end)
    local function saveStore()
        pcall(function() if writefile then writefile(THEMES_FILE, HttpService:JSONEncode(Store)) end end)
    end
    local AiCfg = { provider = "gemini", key = "", model = "gemini-2.5-flash", base = "https://openrouter.ai/api/v1" }
    pcall(function()
        if isfile and readfile and isfile(AI_FILE) then
            local d = HttpService:JSONDecode(readfile(AI_FILE))
            if type(d) == "table" then
                for _, k in ipairs({ "provider", "key", "model", "base" }) do
                    if type(d[k]) == "string" then AiCfg[k] = d[k] end
                end
            end
        end
    end)
    local function saveAi()
        pcall(function() if writefile then writefile(AI_FILE, HttpService:JSONEncode(AiCfg)) end end)
    end
    local function getPrompt()
        local txt
        pcall(function()
            if isfile and readfile and isfile(PROMPT_FILE) then txt = readfile(PROMPT_FILE) end
        end)
        if type(txt) == "string" and #txt > 50 then return txt end
        pcall(function() if writefile then writefile(PROMPT_FILE, DEFAULT_PROMPT) end end)
        return DEFAULT_PROMPT
    end

    local function findTheme(name)
        for _, t in ipairs(BUILTIN) do
            if t.name == name then return t, true end
        end
        for _, t in ipairs(Store.themes) do
            if t.name == name then return t, false end
        end
        return nil
    end

    -- ===== применение темы к живому интерфейсу =====
    local CurTok = {
        danger = Color3.fromRGB(150, 50, 50), ok = Color3.fromRGB(40, 170, 100),
        on = Color3.fromRGB(110, 235, 150), mini = Color3.fromRGB(18, 18, 26),
    }
    local ALIASES = {
        danger = { Color3.fromRGB(190, 60, 60) },
        ok = { Color3.fromRGB(40, 150, 90) },
    }
    local ActiveSpec = normalize(DEFAULT)

    local function mapColor(c, map)
        for i = 1, #map do
            local o = map[i][1]
            if math.abs(c.R - o.R) < 0.006 and math.abs(c.G - o.G) < 0.006 and math.abs(c.B - o.B) < 0.006 then
                return map[i][2]
            end
        end
        return nil
    end
    local function recolor(root, map)
        local n = 0
        for _, d in ipairs(root:GetDescendants()) do
            n = n + 1
            if n % 500 == 0 then task.wait() end
            pcall(function()
                if d:IsA("GuiObject") then
                    local nc = mapColor(d.BackgroundColor3, map)
                    if nc then d.BackgroundColor3 = nc end
                    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                        nc = mapColor(d.TextColor3, map)
                        if nc then d.TextColor3 = nc end
                        if d:IsA("TextBox") then
                            nc = mapColor(d.PlaceholderColor3, map)
                            if nc then d.PlaceholderColor3 = nc end
                        end
                    elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
                        nc = mapColor(d.ImageColor3, map)
                        if nc then d.ImageColor3 = nc end
                    elseif d:IsA("ScrollingFrame") then
                        nc = mapColor(d.ScrollBarImageColor3, map)
                        if nc then d.ScrollBarImageColor3 = nc end
                    end
                elseif d:IsA("UIStroke") then
                    local nc = mapColor(d.Color, map)
                    if nc then d.Color = nc end
                end
            end)
        end
    end

    local function applySpec(raw)
        local spec = normalize(raw)
        local nc = {}
        for _, k in ipairs(TOKENS) do nc[k] = colorOf(spec[k]) end
        -- карта старый цвет -> новый строится ДО смены токенов
        local map = {}
        local function add(o, n) map[#map + 1] = { o, n } end
        add(Theme.Accent, nc.accent)
        add(Theme.Panel, nc.panel)
        add(Theme.Element, nc.element)
        add(Theme.Off, nc.off)
        add(Theme.Text, nc.text)
        add(Theme.Sub, nc.textDim)
        add(CurTok.danger, nc.danger)
        add(CurTok.ok, nc.ok)
        add(CurTok.on, nc.on)
        add(CurTok.mini, nc.mini)
        for _, a in ipairs(ALIASES.danger) do add(a, nc.danger) end
        for _, a in ipairs(ALIASES.ok) do add(a, nc.ok) end
        Theme.Panel, Theme.Element, Theme.Off, Theme.Text, Theme.Sub = nc.panel, nc.element, nc.off, nc.text, nc.textDim
        CurTok.danger, CurTok.ok, CurTok.on, CurTok.mini = nc.danger, nc.ok, nc.on, nc.mini
        SetAccent(nc.accent)
        MainGradient.Color = ColorSequence.new(nc.bg1, nc.bg2)
        Opacity = spec.opacity
        ApplyGlass()
        NX.Blur = spec.blur
        Tween(BlurFx, { Size = (Main.Visible and spec.blur) and 14 or 0 }, 0.2)
        ActiveSpec = spec
        task.spawn(function()
            recolor(MenuGui, map)
            recolor(FloatGui, map)
        end)
        return spec
    end

    function ThemeAPI.ApplyInitial()
        local t = findTheme(Store.active) or DEFAULT
        applySpec(t)
    end

    -- ===== ИИ =====
    local function httpRequest(opts)
        local fn = (syn and syn.request) or (http and http.request) or http_request or request
        if not fn then return nil, "в executor нет request / http_request" end
        local ok, res = pcall(fn, opts)
        if not ok then return nil, tostring(res) end
        return res
    end
    local function askAi(userText)
        local sys = getPrompt()
        local msg = "CURRENT THEME JSON:\n" .. HttpService:JSONEncode(ActiveSpec) .. "\n\nUSER REQUEST:\n" .. userText
        local req
        if AiCfg.provider == "gemini" then
            local model = AiCfg.model ~= "" and AiCfg.model or "gemini-2.5-flash"
            req = {
                Url = "https://generativelanguage.googleapis.com/v1beta/models/" .. model .. ":generateContent",
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json", ["x-goog-api-key"] = AiCfg.key },
                Body = HttpService:JSONEncode({
                    system_instruction = { parts = { { text = sys } } },
                    contents = { { role = "user", parts = { { text = msg } } } },
                    generationConfig = { temperature = 0.8, responseMimeType = "application/json" },
                }),
            }
        else
            local base = (AiCfg.base:gsub("/+$", ""))
            req = {
                Url = base .. "/chat/completions", Method = "POST",
                Headers = { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. AiCfg.key },
                Body = HttpService:JSONEncode({
                    model = AiCfg.model, temperature = 0.8,
                    messages = { { role = "system", content = sys }, { role = "user", content = msg } },
                }),
            }
        end
        local res, err = httpRequest(req)
        if not res then return nil, err end
        local code = res.StatusCode or 0
        if code < 200 or code >= 300 then
            local body = tostring(res.Body)
            local hint = ""
            if body:lower():find("location", 1, true) then hint = " (регион не поддерживается: нужен VPN или другой провайдер)" end
            return nil, "HTTP " .. code .. hint .. ": " .. body:sub(1, 140)
        end
        local okJ, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
        if not okJ then return nil, "ответ не JSON" end
        local text
        pcall(function()
            if AiCfg.provider == "gemini" then
                text = data.candidates[1].content.parts[1].text
            else
                text = data.choices[1].message.content
            end
        end)
        if not text then return nil, "пустой ответ ИИ" end
        return text
    end
    local function extractJson(text)
        text = text:gsub("```json", ""):gsub("```", "")
        local a, b = text:find("{", 1, true), nil
        for i = #text, 1, -1 do
            if text:sub(i, i) == "}" then b = i break end
        end
        if not (a and b) then return nil end
        local ok, d = pcall(function() return HttpService:JSONDecode(text:sub(a, b)) end)
        if ok and type(d) == "table" then return d end
        return nil
    end

    -- ===== UI =====
    local renderThemes
    local function uniqueName(name)
        local n, i = name, 1
        while findTheme(n) do
            i = i + 1
            n = name:sub(1, 20) .. " " .. i
        end
        return n
    end
    local function saveUserTheme(spec)
        spec.name = uniqueName(spec.name)
        table.insert(Store.themes, spec)
        Store.active = spec.name
        saveStore()
        if renderThemes then renderThemes() end
        return spec
    end

    local winAi = SettingsWindow("ИИ-создатель тем")
    local statusLbl
    do
        local W = winAi.P
        W:Section("Запрос к ИИ")
        local promptBox = W:Input("Что создать", "например: красно-чёрная тема", nil, { BoxWidth = 210, Height = 76, MultiLine = true })
        local statusList = W:List()
        statusLbl = statusList:Info("Готов. Нужен API ключ (раздел ниже).")
        local busy = false
        W:Button("Создать или изменить тему", nil, function()
            if busy then return end
            local text = promptBox.Text
            if text == "" then
                Toast("Опиши, какую тему создать")
                return
            end
            if AiCfg.key == "" then
                Toast("Вставь API ключ в разделе ниже", "bad")
                return
            end
            busy = true
            statusLbl.Text = "Думаю..."
            task.spawn(function()
                local reply, err = askAi(text)
                busy = false
                if not reply then
                    statusLbl.Text = "Ошибка: " .. tostring(err):sub(1, 150)
                    Toast("Ошибка ИИ", "bad")
                    return
                end
                local raw = extractJson(reply)
                if not raw then
                    statusLbl.Text = "ИИ вернул не JSON, попробуй ещё раз"
                    Toast("ИИ вернул не JSON", "bad")
                    return
                end
                local spec = normalize(raw)
                saveUserTheme(spec)
                applySpec(spec)
                statusLbl.Text = "Готово: тема «" .. spec.name .. "» сохранена и применена"
                Toast("Тема создана: " .. spec.name, "ok")
            end)
        end)

        W:Section("API (бесплатный ключ Google AI Studio для Gemini)")
        W:Selector("Провайдер", { { "Gemini", "gemini" }, { "OpenAI-совместимый", "openai" } }, AiCfg.provider, function(v)
            AiCfg.provider = v
            saveAi()
        end)
        W:Input("API ключ", "вставь ключ...", function(t)
            AiCfg.key = t:gsub("%s+", "")
            saveAi()
        end, { BoxWidth = 210, Mono = true, Default = AiCfg.key })
        W:Input("Модель", "gemini-2.5-flash", function(t)
            AiCfg.model = t:gsub("%s+", "")
            saveAi()
        end, { BoxWidth = 210, Mono = true, Default = AiCfg.model })
        W:Input("Base URL (для OpenAI-совместимого)", "https://.../v1", function(t)
            AiCfg.base = t:gsub("%s+", "")
            saveAi()
        end, { BoxWidth = 210, Mono = true, Default = AiCfg.base })
        W:Label("Ключ хранится только в файле Nexus.Ai.json на твоём устройстве и не попадает в код.")
        W:Section("Промпт")
        W:Label("Промпт лежит в файле Nexus.AiPrompt.txt: его можно править, он не зависит от версии скрипта.")
        W:Button("Сбросить промпт на стандартный", nil, function()
            pcall(function() if writefile then writefile(PROMPT_FILE, DEFAULT_PROMPT) end end)
            Toast("Промпт сброшен", "ok")
        end)
    end

    local TabTh = CreateTab("Темы")
    TabTh:Section("Текущая тема")
    local curInfo = TabTh:List()
    local curLbl = curInfo:Info("")
    TabTh:Button("Открыть ИИ-создатель темы", nil, function() winAi.Toggle() end)
    TabTh:Section("Список тем")
    local listTh = TabTh:List()
    TabTh:Section("Импорт и экспорт")
    local importBox = TabTh:Input("JSON темы", "вставь JSON...", nil, { BoxWidth = 220, Height = 64, MultiLine = true, Mono = true })
    TabTh:Button("Импортировать тему из JSON", nil, function()
        local d
        pcall(function() d = HttpService:JSONDecode(importBox.Text) end)
        if type(d) ~= "table" then
            Toast("Это не JSON", "bad")
            return
        end
        local spec = normalize(d)
        saveUserTheme(spec)
        applySpec(spec)
        importBox.Text = ""
        Toast("Тема импортирована: " .. spec.name, "ok")
    end)
    TabTh:Button("Копировать текущую тему (JSON)", nil, function()
        local json = HttpService:JSONEncode(ActiveSpec)
        if setclipboard then
            setclipboard(json)
            Toast("JSON темы скопирован", "ok")
        else
            print("[Nexus] JSON темы:", json)
            Toast("Нет буфера обмена, JSON в консоли F9")
        end
    end)
    TabTh:Button("Сбросить на стандартную тему", nil, function()
        Store.active = "Nexus"
        saveStore()
        applySpec(DEFAULT)
        renderThemes()
    end)

    renderThemes = function()
        curLbl.Text = "Активна: " .. ActiveSpec.name .. "  ·  прозрачность " .. string.format("%.2f", ActiveSpec.opacity)
        listTh:Clear()
        local function row(t, builtin)
            local r = listTh:Row(34)
            New("TextLabel", {
                BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -190, 1, 0),
                Text = t.name .. (builtin and "  (встроенная)" or ""), Font = Enum.Font.GothamBold, TextSize = 12,
                TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, Parent = r,
            })
            local sw = New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, builtin and -92 or -146, 0.5, 0), Size = UDim2.fromOffset(16, 16),
                BackgroundColor3 = colorOf(t.accent) or Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = r,
            })
            Round(sw, 8)
            MiniBtn(r, "Применить", -8, 78, Theme.Accent, function()
                Store.active = t.name
                saveStore()
                applySpec(t)
                Toast("Тема: " .. t.name, "ok")
                renderThemes()
            end)
            if not builtin then
                local del = ConfirmBtn(r, "✕", -8, 22, Theme.Off, function()
                    for i, x in ipairs(Store.themes) do
                        if x == t then table.remove(Store.themes, i) break end
                    end
                    if Store.active == t.name then Store.active = "Nexus" end
                    saveStore()
                    renderThemes()
                end)
                del.Position = UDim2.new(1, -92, 0.5, 0)
                del.BackgroundColor3 = CurTok.danger
            end
        end
        for _, t in ipairs(BUILTIN) do row(t, true) end
        for _, t in ipairs(Store.themes) do row(t, false) end
    end
    renderThemes()
end

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
TabSet:Selector("Пресет акцента", AccentPresets, AccentPresets[1][2], function(c) SetAccent(c) end)
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
    pcall(ThemeAPI.ApplyInitial)
    local ReplicatedStorage = Service("ReplicatedStorage")
    local PROFILES = {
        { id = "bb", name = "Blade Ball", sub = "Auto Parry · Spam · ESP способностей" },
        { id = "mm2", name = "Murder Mystery 2", sub = "ESP ролей · Silent Aim · Values · Радио" },
        { id = "gb", name = "Guts & Blackpowder", sub = "ESP зомби · Авто-выстрел · Классы" },
        { id = "all", name = "Все модули", sub = "Показать все вкладки" },
    }
    local GAME_TABS = { bb = { "Blade Ball" }, mm2 = { "MM2 Combat", "MM2 Values" }, gb = { "G&B" } }

    local function detect()
        if game.PlaceId == 13772394625 then return "bb" end
        if game.PlaceId == 142823291 then return "mm2" end
        if game.PlaceId == 12334109280 then return "gb" end
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        if r and r:FindFirstChild("ParrySuccessAll") then return "bb" end
        local inv = r and r:FindFirstChild("Inventory")
        if inv and inv:FindFirstChild("PlaySong") then return "mm2" end
        return nil
    end
    local detected = detect()
    -- как в VIREX: в Blade Ball хук ставится сразу после лоадера, не дожидаясь выбора
    if detected == "bb" then task.spawn(BB.Ensure) end

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
            task.spawn(BB.Ensure)
        elseif id == "mm2" then
            pcall(MM2C.EnableRoleEsp)
        end
        SelectTab((id ~= "all" and firstGameTab) or Tabs[1])
        if launcher then launcher:Destroy(); launcher = nil end
        ShowMain()
    end

    launcher = New("ScreenGui", {
        Name = "Nexus_Launcher", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1000,
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
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "NX", Font = Enum.Font.GothamBold,
        TextSize = 16, TextColor3 = Color3.new(1, 1, 1), Parent = logo,
    })
    New("TextLabel", {
        Position = UDim2.fromOffset(0, 58), Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
        Text = "Nexus", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Theme.Text, Parent = card,
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
    Env.__NEXUS_UNLOAD = nil
end
Env.__NEXUS_UNLOAD = Unload
