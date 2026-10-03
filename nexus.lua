local cloneref = cloneref or function(obj) return obj end
local function Service(name) return cloneref(game:GetService(name)) end

local RunService = Service("RunService")
local UserInputService = Service("UserInputService")
local TweenService = Service("TweenService")
local CoreGui = Service("CoreGui")
local Players = Service("Players")
local Workspace = Service("Workspace")

local lplayer = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

local Env = (getgenv and getgenv()) or _G
if Env.__NEXUS_UI_UNLOAD then
    pcall(Env.__NEXUS_UI_UNLOAD)
end

pcall(function()
    local roots = { CoreGui, lplayer:FindFirstChildOfClass("PlayerGui") }
    if gethui then
        roots[#roots + 1] = gethui()
    end

    for _, root in ipairs(roots) do
        if root then
            local oldLoader = root:FindFirstChild("NexusLoaderGui")
            if oldLoader then oldLoader:Destroy() end

            local oldMenu = root:FindFirstChild("Nexus_UI_Shell")
            if oldMenu then oldMenu:Destroy() end
        end
    end
end)

local function Protect(gui)
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        end
    end)

    local ok = pcall(function()
        gui.Parent = (gethui and gethui()) or CoreGui
    end)

    if not ok or not gui.Parent then
        gui.Parent = lplayer:WaitForChild("PlayerGui")
    end
end

local NexusLoaderGui = Instance.new("ScreenGui")
NexusLoaderGui.Name = "NexusLoaderGui"
NexusLoaderGui.IgnoreGuiInset = true
NexusLoaderGui.ResetOnSpawn = false
NexusLoaderGui.DisplayOrder = 99999
NexusLoaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
Protect(NexusLoaderGui)

local NexusLoader = Instance.new("Frame")
NexusLoader.AnchorPoint = Vector2.new(0.5, 0.5)
NexusLoader.Position = UDim2.fromScale(0.5, 0.5)
NexusLoader.Size = UDim2.fromOffset(390, 170)
NexusLoader.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
NexusLoader.BorderSizePixel = 0
NexusLoader.ClipsDescendants = true
NexusLoader.Parent = NexusLoaderGui

local NexusLoaderCorner = Instance.new("UICorner")
NexusLoaderCorner.CornerRadius = UDim.new(0, 18)
NexusLoaderCorner.Parent = NexusLoader

local NexusTexture = Instance.new("Frame")
NexusTexture.BackgroundTransparency = 1
NexusTexture.Size = UDim2.fromScale(1, 1)
NexusTexture.ClipsDescendants = true
NexusTexture.ZIndex = 1
NexusTexture.Parent = NexusLoader

for i = -5, 12 do
    local stripe = Instance.new("Frame")
    stripe.BackgroundColor3 = Color3.fromRGB(119, 120, 255)
    stripe.BackgroundTransparency = 0.94
    stripe.BorderSizePixel = 0
    stripe.Size = UDim2.fromOffset(34, 270)
    stripe.Position = UDim2.new(0, i * 58, 0, -45)
    stripe.Rotation = 28
    stripe.ZIndex = 1
    stripe.Parent = NexusTexture
end

local NexusTextureGradient = Instance.new("UIGradient")
NexusTextureGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(119, 120, 255)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(160, 90, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 170, 255)),
})
NexusTextureGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.82),
    NumberSequenceKeypoint.new(0.5, 0.9),
    NumberSequenceKeypoint.new(1, 0.82),
})
NexusTextureGradient.Rotation = 25
NexusTextureGradient.Parent = NexusTexture

local NexusTextureStroke = Instance.new("UIStroke")
NexusTextureStroke.Color = Color3.fromRGB(119, 120, 255)
NexusTextureStroke.Transparency = 0.78
NexusTextureStroke.Thickness = 1
NexusTextureStroke.Parent = NexusLoader

local NexusLoaderStroke = Instance.new("UIStroke")
NexusLoaderStroke.Color = Color3.fromRGB(119, 120, 255)
NexusLoaderStroke.Transparency = 0.35
NexusLoaderStroke.Thickness = 1.2
NexusLoaderStroke.Parent = NexusLoader

local NexusLoaderScale = Instance.new("UIScale")
NexusLoaderScale.Scale = 0.86
NexusLoaderScale.Parent = NexusLoader

local NexusLoaderTitle = Instance.new("TextLabel")
NexusLoaderTitle.BackgroundTransparency = 1
NexusLoaderTitle.AnchorPoint = Vector2.new(0.5, 0)
NexusLoaderTitle.Position = UDim2.fromScale(0.5, 0.18)
NexusLoaderTitle.Size = UDim2.fromOffset(300, 42)
NexusLoaderTitle.Text = "NEXUS"
NexusLoaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
NexusLoaderTitle.Font = Enum.Font.Arcade
NexusLoaderTitle.TextSize = 31
NexusLoaderTitle.Parent = NexusLoader

local NexusTitleGradient = Instance.new("UIGradient")
NexusTitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 195, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(119, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 90, 255)),
})
NexusTitleGradient.Rotation = 0
NexusTitleGradient.Parent = NexusLoaderTitle

local NexusTitleStroke = Instance.new("UIStroke")
NexusTitleStroke.Color = Color3.fromRGB(0, 0, 0)
NexusTitleStroke.Transparency = 0.35
NexusTitleStroke.Thickness = 1.4
NexusTitleStroke.Parent = NexusLoaderTitle

local NexusLoaderSub = Instance.new("TextLabel")
NexusLoaderSub.BackgroundTransparency = 1
NexusLoaderSub.AnchorPoint = Vector2.new(0.5, 0)
NexusLoaderSub.Position = UDim2.fromScale(0.5, 0.46)
NexusLoaderSub.Size = UDim2.fromOffset(300, 20)
NexusLoaderSub.Text = "UI LOADER"
NexusLoaderSub.TextColor3 = Color3.fromRGB(165, 165, 175)
NexusLoaderSub.Font = Enum.Font.GothamMedium
NexusLoaderSub.TextSize = 11
NexusLoaderSub.Parent = NexusLoader

local NexusBarBack = Instance.new("Frame")
NexusBarBack.AnchorPoint = Vector2.new(0.5, 0)
NexusBarBack.Position = UDim2.fromScale(0.5, 0.67)
NexusBarBack.Size = UDim2.fromOffset(300, 6)
NexusBarBack.BackgroundColor3 = Color3.fromRGB(32, 30, 38)
NexusBarBack.BorderSizePixel = 0
NexusBarBack.Parent = NexusLoader

local NexusBarBackCorner = Instance.new("UICorner")
NexusBarBackCorner.CornerRadius = UDim.new(1, 0)
NexusBarBackCorner.Parent = NexusBarBack

local NexusBar = Instance.new("Frame")
NexusBar.Size = UDim2.new(0, 0, 1, 0)
NexusBar.BackgroundColor3 = Color3.fromRGB(119, 120, 255)
NexusBar.BorderSizePixel = 0
NexusBar.Parent = NexusBarBack

local NexusBarCorner = Instance.new("UICorner")
NexusBarCorner.CornerRadius = UDim.new(1, 0)
NexusBarCorner.Parent = NexusBar

local NexusPercent = Instance.new("TextLabel")
NexusPercent.BackgroundTransparency = 1
NexusPercent.AnchorPoint = Vector2.new(0.5, 0)
NexusPercent.Position = UDim2.fromScale(0.5, 0.76)
NexusPercent.Size = UDim2.fromOffset(120, 20)
NexusPercent.Text = "0%"
NexusPercent.TextColor3 = Color3.fromRGB(220, 220, 225)
NexusPercent.Font = Enum.Font.GothamBold
NexusPercent.TextSize = 10
NexusPercent.Parent = NexusLoader

pcall(function()
    TweenService:Create(
        NexusLoaderScale,
        TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Scale = 1 }
    ):Play()
end)

task.spawn(function()
    while NexusLoaderGui.Parent do
        pcall(function()
            NexusTextureGradient.Offset = Vector2.new(-0.6, 0)

            TweenService:Create(
                NexusTextureGradient,
                TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                { Offset = Vector2.new(0.6, 0) }
            ):Play()

            TweenService:Create(
                NexusTitleGradient,
                TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                { Offset = Vector2.new(0.35, 0) }
            ):Play()
        end)

        task.wait(1.8)
    end
end)

do
    local duration = 3
    local started = os.clock()

    while NexusLoaderGui.Parent do
        local alpha = math.clamp((os.clock() - started) / duration, 0, 1)
        NexusBar.Size = UDim2.new(alpha, 0, 1, 0)
        NexusPercent.Text = tostring(math.floor(alpha * 100)) .. "%"

        if alpha >= 1 then
            break
        end

        task.wait()
    end

    if NexusLoaderGui.Parent then
        NexusBar.Size = UDim2.new(1, 0, 1, 0)
        NexusPercent.Text = "100%"

        task.wait(0.12)

        local fadeInfo = TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        local fades = {}

        pcall(function()
            fades[#fades + 1] = TweenService:Create(NexusLoaderScale, fadeInfo, {
                Scale = 0.78
            })

            fades[#fades + 1] = TweenService:Create(NexusLoader, fadeInfo, {
                BackgroundTransparency = 1
            })

            fades[#fades + 1] = TweenService:Create(NexusLoaderStroke, fadeInfo, {
                Transparency = 1
            })

            fades[#fades + 1] = TweenService:Create(NexusLoaderTitle, fadeInfo, {
                TextTransparency = 1
            })

            fades[#fades + 1] = TweenService:Create(NexusTitleStroke, fadeInfo, {
                Transparency = 1
            })

            fades[#fades + 1] = TweenService:Create(NexusTexture, fadeInfo, {
                BackgroundTransparency = 1
            })

            fades[#fades + 1] = TweenService:Create(NexusTextureStroke, fadeInfo, {
                Transparency = 1
            })

            fades[#fades + 1] = TweenService:Create(NexusLoaderSub, fadeInfo, {
                TextTransparency = 1
            })

            fades[#fades + 1] = TweenService:Create(NexusPercent, fadeInfo, {
                TextTransparency = 1
            })

            fades[#fades + 1] = TweenService:Create(NexusBarBack, fadeInfo, {
                BackgroundTransparency = 1
            })

            fades[#fades + 1] = TweenService:Create(NexusBar, fadeInfo, {
                BackgroundTransparency = 1
            })

            for _, tween in ipairs(fades) do
                tween:Play()
            end
        end)

        task.wait(0.70)
    end

    if NexusLoaderGui then
        NexusLoaderGui:Destroy()
    end
end

local Connections = {}
local function Track(conn)
    Connections[#Connections + 1] = conn
    return conn
end

local function New(class, props)
    local inst = Instance.new(class)
    local parent

    for k, v in pairs(props) do
        if k == "Parent" then
            parent = v
        else
            inst[k] = v
        end
    end

    if parent then
        inst.Parent = parent
    end

    return inst
end

local Theme = {
    Accent = Color3.fromRGB(119, 120, 255),
    Panel = Color3.fromRGB(24, 24, 34),
    Element = Color3.fromRGB(38, 38, 52),
    Off = Color3.fromRGB(70, 70, 92),
    Text = Color3.fromRGB(240, 240, 250),
    Sub = Color3.fromRGB(150, 150, 175),
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
    for _, fn in ipairs(AccentList) do
        fn()
    end
end

local function Round(obj, r)
    return New("UICorner", {
        CornerRadius = UDim.new(0, r),
        Parent = obj,
    })
end

local function Stroke(obj, color, thickness, transparency)
    return New("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = obj,
    })
end

local function Tween(obj, props, t)
    TweenService:Create(
        obj,
        TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    ):Play()
end

local function IsPress(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

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
    if ActiveDrag and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        ActiveDrag(input.Position)
    end
end))

Track(UserInputService.InputEnded:Connect(function(input)
    if IsPress(input) then
        EndDrag()
    end
end))

local WIN_W, WIN_H = 560, 380
local vp = (Cam and Cam.ViewportSize) or Vector2.new(1280, 720)

local startScale = math.clamp(
    math.min(vp.X / (WIN_W + 60), vp.Y / (WIN_H + 60)),
    0.6,
    1
)
startScale = math.floor(startScale * 20 + 0.5) / 20

local MenuGui = New("ScreenGui", {
    Name = "Nexus_UI_Shell",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
Protect(MenuGui)

local Main = New("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(WIN_W, WIN_H),
    Position = UDim2.fromOffset(
        math.floor((vp.X - WIN_W * startScale) / 2),
        math.floor((vp.Y - WIN_H * startScale) / 2)
    ),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    Active = true,
    Parent = MenuGui,
})

Glass(Main, 0.1)
Round(Main, 12)

New("UIGradient", {
    Rotation = 60,
    Color = ColorSequence.new(
        Color3.fromRGB(34, 30, 60),
        Color3.fromRGB(12, 12, 18)
    ),
    Parent = Main,
})

local MainStroke = Stroke(Main, Theme.Accent, 1, 0.45)
OnAccent(function()
    MainStroke.Color = Theme.Accent
end)

local UIScaleObj = New("UIScale", {
    Scale = startScale,
    Parent = Main,
})

local Mini = New("TextButton", {
    Name = "Mini",
    Size = UDim2.fromOffset(52, 52),
    Position = UDim2.fromOffset(20, 100),
    BackgroundColor3 = Color3.fromRGB(18, 18, 26),
    Text = "NX",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Theme.Text,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Visible = false,
    Parent = MenuGui,
})

Glass(Mini, 0.1)
Round(Mini, 26)

local MiniStroke = Stroke(Mini, Theme.Accent, 2, 0)
OnAccent(function()
    MiniStroke.Color = Theme.Accent
end)

local Header = New("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    Active = true,
    Parent = Main,
})

local Dot = New("Frame", {
    Position = UDim2.fromOffset(14, 15),
    Size = UDim2.fromOffset(10, 10),
    BorderSizePixel = 0,
    Parent = Header,
})
Round(Dot, 5)

OnAccent(function()
    Dot.BackgroundColor3 = Theme.Accent
end)

New("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(32, 0),
    Size = UDim2.new(1, -120, 1, 0),
    Text = "Nexus UI",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header,
})

local function HeaderButton(text, x, color)
    local b = New("TextButton", {
        Size = UDim2.fromOffset(28, 24),
        Position = UDim2.new(1, x, 0, 8),
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.Text,
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        AutoButtonColor = true,
        Parent = Header,
    })

    Glass(b, 0.35)
    Round(b, 6)

    return b
end

local MinBtn = HeaderButton("–", -70, Theme.Element)
local CloseBtn = HeaderButton("×", -38, Color3.fromRGB(150, 50, 50))

New("Frame", {
    Position = UDim2.fromOffset(10, 40),
    Size = UDim2.new(1, -20, 0, 1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BackgroundTransparency = 0.9,
    BorderSizePixel = 0,
    Parent = Main,
})

Header.InputBegan:Connect(function(input)
    if IsPress(input) then
        local startInput, startPos = input.Position, Main.Position

        BeginDrag(function(p)
            local d = p - startInput
            Main.Position = UDim2.fromOffset(
                startPos.X.Offset + d.X,
                startPos.Y.Offset + d.Y
            )
        end)
    end
end)

local MiniMoved = false
Mini.InputBegan:Connect(function(input)
    if IsPress(input) then
        local startInput, startPos = input.Position, Mini.Position
        MiniMoved = false

        BeginDrag(function(p)
            local d = p - startInput
            if math.abs(d.X) > 6 or math.abs(d.Y) > 6 then
                MiniMoved = true
            end

            Mini.Position = UDim2.fromOffset(
                startPos.X.Offset + d.X,
                startPos.Y.Offset + d.Y
            )
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
    if not MiniMoved then
        ShowMain()
    end
end)

MinBtn.Activated:Connect(ShowMini)

local Unload
local confirmUntil = 0

CloseBtn.Activated:Connect(function()
    if tick() < confirmUntil then
        if Unload then
            Unload()
        end
        return
    end

    confirmUntil = tick() + 2
    CloseBtn.Text = "?"

    task.delay(2, function()
        if CloseBtn.Parent then
            CloseBtn.Text = "×"
        end
    end)
end)

local Sidebar = New("ScrollingFrame", {
    Position = UDim2.fromOffset(8, 48),
    Size = UDim2.new(0, 124, 1, -56),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 0,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ElasticBehavior = Enum.ElasticBehavior.Never,
    Parent = Main,
})

Glass(Sidebar, 0.35)
Round(Sidebar, 10)

New("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Sidebar,
})

New("UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6),
    Parent = Sidebar,
})

local Content = New("Frame", {
    Position = UDim2.fromOffset(140, 48),
    Size = UDim2.new(1, -148, 1, -56),
    BackgroundTransparency = 1,
    Parent = Main,
})

local Tabs = {}

local function SelectTab(t)
    for _, x in ipairs(Tabs) do
        local on = (x == t)
        x.Page.Visible = on
        x.Bar.Visible = on
        x.Btn.TextColor3 = on and Theme.Text or Theme.Sub

        Tween(x.Btn, {
            BackgroundTransparency = on and 0.8 or 1
        }, 0.12)
    end
end

local SideOrder = 0
local Cleanups = {}

local function OnUnload(fn)
    Cleanups[#Cleanups + 1] = fn
end

local function SideLabel(text)
    SideOrder = SideOrder + 1

    local l = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = Theme.Sub,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = SideOrder,
        Parent = Sidebar,
    })

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 6),
        PaddingTop = UDim.new(0, 8),
        Parent = l,
    })
end

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
    Tween(BlurFx, {
        Size = (Main.Visible and NX.Blur) and 14 or 0
    }, 0.25)
end))

OnUnload(function()
    BlurFx.Size = 0
end)

if Main.Visible then
    Tween(BlurFx, { Size = 14 }, 0.4)
end

local function Toast(text, kind)
    local old = MenuGui:FindFirstChild("RNToast")
    if old then
        old:Destroy()
    end

    local col = Theme.Panel
    if kind == "ok" then
        col = Color3.fromRGB(40, 170, 100)
    elseif kind == "bad" then
        col = Color3.fromRGB(190, 60, 60)
    end

    local card = New("Frame", {
        Name = "RNToast",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, -50),
        Size = UDim2.fromOffset(0, 32),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = col,
        BorderSizePixel = 0,
        ZIndex = 300,
        Parent = MenuGui,
    })

    Round(card, 16)
    Stroke(card, Color3.new(1, 1, 1), 1, 0.75)

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        Parent = card,
    })

    New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 32),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.new(1, 1, 1),
        ZIndex = 301,
        Parent = card,
    })

    Tween(card, {
        Position = UDim2.new(0.5, 0, 0, 16)
    }, 0.25)

    task.delay(1.9, function()
        if card.Parent then
            Tween(card, {
                Position = UDim2.new(0.5, 0, 0, -50)
            }, 0.25)

            task.delay(0.3, function()
                if card.Parent then
                    card:Destroy()
                end
            end)
        end
    end)
end

local function CreateTab(name)
    local btn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Theme.Sub,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        LayoutOrder = (function()
            SideOrder = SideOrder + 1
            return SideOrder
        end)(),
        Parent = Sidebar,
    })

    Round(btn, 7)

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 14),
        Parent = btn,
    })

    OnAccent(function()
        btn.BackgroundColor3 = Theme.Accent
    end)

    local bar = New("Frame", {
        Position = UDim2.new(0, -11, 0.5, -8),
        Size = UDim2.fromOffset(3, 16),
        BorderSizePixel = 0,
        Visible = false,
        Parent = btn,
    })

    Round(bar, 2)

    OnAccent(function()
        bar.BackgroundColor3 = Theme.Accent
    end)

    local page = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageTransparency = 0.3,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        Visible = false,
        Parent = Content,
    })

    New("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page,
    })

    New("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        Parent = page,
    })

    local tabObj = {
        Btn = btn,
        Page = page,
        Bar = bar,
        Order = 0,
    }
    Tabs[#Tabs + 1] = tabObj

    local function AddItem(height)
        tabObj.Order = tabObj.Order + 1

        local item = New("Frame", {
            Size = UDim2.new(1, 0, 0, height),
            BackgroundTransparency = 1,
            LayoutOrder = tabObj.Order,
            Parent = page,
        })

        return item
    end

    function tabObj:Section(text)
        local item = AddItem(24)

        New("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = Theme.Accent,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = item,
        })
    end

    function tabObj:Label(text)
        local item = AddItem(20)

        New("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextColor3 = Theme.Sub,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = item,
        })
    end

    function tabObj:Toggle(text, default, callback)
        local item = AddItem(28)
        local state = default

        New("TextLabel", {
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, -36, 1, 0),
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = item,
        })

        local toggleBg = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(32, 16),
            BackgroundColor3 = Theme.Off,
            BorderSizePixel = 0,
            Parent = item,
        })
        Round(toggleBg, 8)

        local toggleCircle = New("Frame", {
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.fromOffset(12, 12),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            Parent = toggleBg,
        })
        Round(toggleCircle, 6)

        local function update()
            Tween(toggleBg, {
                BackgroundColor3 = state and Theme.Accent or Theme.Off
            }, 0.15)

            Tween(toggleCircle, {
                Position = UDim2.fromOffset(state and 18 or 2, 2)
            }, 0.15)
        end

        update()

        item.InputBegan:Connect(function(input)
            if IsPress(input) then
                state = not state
                update()

                if callback then
                    callback(state)
                end
            end
        end)

        return {
            Set = function(v)
                state = v
                update()

                if callback then
                    callback(state)
                end
            end
        }
    end

    function tabObj:Slider(text, min, max, default, step, callback)
        local item = AddItem(36)
        local val = default

        local lbl = New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            Text = text .. " (" .. tostring(val) .. ")",
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = item,
        })

        local track = New("Frame", {
            Position = UDim2.fromOffset(0, 20),
            Size = UDim2.new(1, 0, 0, 6),
            BackgroundColor3 = Theme.Off,
            BorderSizePixel = 0,
            Parent = item,
        })
        Round(track, 3)

        local fill = New("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Parent = track,
        })
        Round(fill, 3)

        local knob = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(12, 12),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            Parent = track,
        })
        Round(knob, 6)

        local function update()
            local pct = (val - min) / (max - min)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.Position = UDim2.new(pct, 0, 0.5, 0)
            lbl.Text = text .. " (" .. string.format("%.2f", val) .. ")"
        end

        update()

        local dragging = false

        track.InputBegan:Connect(function(input)
            if IsPress(input) then
                dragging = true

                local function onMove(moveInput)
                    local pct = math.clamp(
                        (moveInput.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X,
                        0,
                        1
                    )

                    val = min + pct * (max - min)
                    val = math.floor(val / step + 0.5) * step

                    update()

                    if callback then
                        callback(val)
                    end
                end

                onMove(input)

                local conn = UserInputService.InputChanged:Connect(function(moveInput)
                    if dragging and IsPress(moveInput) then
                        onMove(moveInput)
                    end
                end)

                local endConn = UserInputService.InputEnded:Connect(function(endInput)
                    if IsPress(endInput) then
                        dragging = false
                        conn:Disconnect()
                        endConn:Disconnect()
                    end
                end)
            end
        end)

        return {
            Set = function(v)
                val = v
                update()

                if callback then
                    callback(val)
                end
            end
        }
    end

    function tabObj:ColorPicker(text, default, callback)
        local item = AddItem(28)
        local val = default

        New("TextLabel", {
            Size = UDim2.new(1, -36, 1, 0),
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = item,
        })

        local preview = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(24, 24),
            BackgroundColor3 = val,
            BorderSizePixel = 0,
            Parent = item,
        })

        Round(preview, 4)
        Stroke(preview, Color3.new(1, 1, 1), 1, 0.5)

        item.InputBegan:Connect(function(input)
            if IsPress(input) then
                val = Color3.fromRGB(
                    math.random(0, 255),
                    math.random(0, 255),
                    math.random(0, 255)
                )

                preview.BackgroundColor3 = val

                if callback then
                    callback(val)
                end

                Toast("Цвет изменён", "ok")
            end
        end)

        return {
            Set = function(v)
                val = v
                preview.BackgroundColor3 = val

                if callback then
                    callback(val)
                end
            end
        }
    end

    function tabObj:Button(text, color, callback)
        local item = AddItem(32)

        local button = New("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = color or Theme.Element,
            BorderSizePixel = 0,
            Text = text,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = Color3.new(1, 1, 1),
            AutoButtonColor = true,
            Parent = item,
        })

        Round(button, 6)

        button.Activated:Connect(function()
            if callback then
                callback()
            end
        end)

        return button
    end

    function tabObj:Selector(text, options, default, callback)
        local item = AddItem(28)
        local val = default

        New("TextLabel", {
            Size = UDim2.new(1, -36, 1, 0),
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = item,
        })

        local selectorBtn = New("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(80, 24),
            BackgroundColor3 = Theme.Off,
            BorderSizePixel = 0,
            Text = "Select",
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextColor3 = Color3.new(1, 1, 1),
            AutoButtonColor = true,
            Parent = item,
        })

        Round(selectorBtn, 4)

        local function updateText()
            for _, opt in ipairs(options) do
                if opt[2] == val then
                    selectorBtn.Text = opt[1]
                    break
                end
            end
        end

        updateText()

        selectorBtn.Activated:Connect(function()
            local idx = 1

            for i, opt in ipairs(options) do
                if opt[2] == val then
                    idx = i + 1
                    break
                end
            end

            if idx > #options then
                idx = 1
            end

            val = options[idx][2]
            updateText()

            if callback then
                callback(val)
            end
        end)

        return {
            Set = function(v)
                val = v
                updateText()

                if callback then
                    callback(val)
                end
            end
        }
    end

    btn.Activated:Connect(function()
        SelectTab(tabObj)
    end)

    return tabObj
end

SideLabel("MODULES")

local Home = CreateTab("Главная")
Home:Section("Nexus")
Home:Label("Интерфейс загружен.")
Home:Button("Уведомление (OK)", Color3.fromRGB(40, 170, 100), function()
    Toast("Nexus", "ok")
end)
Home:Button("Уведомление (Error)", Color3.fromRGB(190, 60, 60), function()
    Toast("Ошибка", "bad")
end)
Home:Toggle("Переключатель", false, function(state)
    Toast(tostring(state), state and "ok" or "bad")
end)

--========================================================--
-- NEXUS UI CLICK SOUND
--========================================================--
local NexusClickSound = Instance.new("Sound")
NexusClickSound.Name = "NexusUIClick"
NexusClickSound.SoundId = "rbxassetid://12221967"
NexusClickSound.Volume = 0.28
NexusClickSound.Parent = game:GetService("SoundService")

local NexusSoundHooked = setmetatable({}, {__mode = "k"})
local function NexusHookButton(button)
    if not button or not button:IsA("GuiButton") or NexusSoundHooked[button] then return end
    NexusSoundHooked[button] = true
    button.Activated:Connect(function()
        pcall(function()
            NexusClickSound.TimePosition = 0
            NexusClickSound:Play()
        end)
    end)
end

local function NexusScanButtons(root)
    if not root then return end
    for _, obj in ipairs(root:GetDescendants()) do
        NexusHookButton(obj)
    end
end

pcall(function()
    NexusScanButtons(MenuGui)
end)
pcall(function()
    Track(MenuGui.DescendantAdded:Connect(NexusHookButton))
end)
pcall(function()
    Track(game:GetService("CoreGui").DescendantAdded:Connect(NexusHookButton))
end)

OnUnload(function()
    pcall(function()
        NexusClickSound:Destroy()
    end)
end)

--========================================================--
-- BLADE BALL TABS (filled in once the backend is loaded)
--========================================================--
local ParryTab = CreateTab("Авто-парри")
local SpamTab = CreateTab("Спам")
local WindowsTab = CreateTab("Окна")
local CharTab = CreateTab("Персонаж")
local EmoteTab = CreateTab("Эмоции")

task.spawn(function()
    local Players           = cloneref(game:GetService('Players'))
    local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
    local UserInputService  = cloneref(game:GetService('UserInputService'))
    local RunService        = cloneref(game:GetService('RunService'))
    local TweenService      = cloneref(game:GetService('TweenService'))
    local Stats             = cloneref(game:GetService('Stats'))
    local Debris            = cloneref(game:GetService('Debris'))
    local CoreGui           = cloneref(game:GetService('CoreGui'))
    local HttpService       = cloneref(game:GetService('HttpService'))
    local Workspace         = cloneref(game:GetService('Workspace'))

    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()

    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end

    local Alive   = Workspace:FindFirstChild("Alive") or Workspace:WaitForChild("Alive")
    local Runtime = Workspace.Runtime

    local function detectMobile()
        local touch = UserInputService.TouchEnabled
        local mouse = UserInputService.MouseEnabled
        local keyboard = UserInputService.KeyboardEnabled
        if touch and not keyboard then return true end
        if touch and not mouse then return true end
        return false
    end

    local function Notify(title, content, duration)
        duration = duration or 2
        task.spawn(function()
            pcall(function()
                local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
                local parent = CoreGui
                if not parent then parent = playerGui end
                if not parent then return end

                local gui = parent:FindFirstChild("NEXUS_Notifications")
                if not gui then
                    gui = Instance.new("ScreenGui")
                    gui.Name = "NEXUS_Notifications"
                    gui.ResetOnSpawn = false
                    gui.IgnoreGuiInset = true
                    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    gui.Parent = parent
                end

                local holder = gui:FindFirstChild("Holder")
                if not holder then
                    holder = Instance.new("Frame")
                    holder.Name = "Holder"
                    holder.AnchorPoint = Vector2.new(1, 0)
                    holder.Position = UDim2.new(1, -18, 0, 18)
                    holder.Size = UDim2.fromOffset(320, 0)
                    holder.BackgroundTransparency = 1
                    holder.Parent = gui

                    local layout = Instance.new("UIListLayout")
                    layout.Padding = UDim.new(0, 8)
                    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                    layout.VerticalAlignment = Enum.VerticalAlignment.Top
                    layout.Parent = holder
                end

                local frame = Instance.new("Frame")
                frame.Name = "Notification"
                frame.Size = UDim2.fromOffset(320, 72)
                frame.BackgroundColor3 = Color3.fromRGB(20, 28, 40)
                frame.BackgroundTransparency = 0.03
                frame.BorderSizePixel = 0
                frame.ClipsDescendants = true
                frame.Parent = holder

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 12)
                corner.Parent = frame

                local gradient = Instance.new("UIGradient")
                gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(145, 145, 145)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
                })
                gradient.Rotation = 0
                gradient.Parent = frame

                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(255, 255, 255)
                stroke.Transparency = 0.35
                stroke.Thickness = 1
                stroke.Parent = frame

                local titleLabel = Instance.new("TextLabel")
                titleLabel.BackgroundTransparency = 1
                titleLabel.Position = UDim2.fromOffset(14, 10)
                titleLabel.Size = UDim2.new(1, -28, 0, 20)
                titleLabel.Font = Enum.Font.GothamBold
                titleLabel.Text = tostring(title)
                titleLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
                titleLabel.TextSize = 14
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.Parent = frame

                local contentLabel = Instance.new("TextLabel")
                contentLabel.BackgroundTransparency = 1
                contentLabel.Position = UDim2.fromOffset(14, 32)
                contentLabel.Size = UDim2.new(1, -28, 0, 30)
                contentLabel.Font = Enum.Font.Gotham
                contentLabel.Text = tostring(content)
                contentLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
                contentLabel.TextSize = 12
                contentLabel.TextWrapped = true
                contentLabel.TextXAlignment = Enum.TextXAlignment.Left
                contentLabel.TextYAlignment = Enum.TextYAlignment.Top
                contentLabel.Parent = frame

                frame.Position = UDim2.new(1, 25, 0, 0)
                TweenService:Create(frame, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play()

                task.wait(duration)
                local out = TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    Position = UDim2.new(1, 25, 0, 0),
                    BackgroundTransparency = 1
                })
                out:Play()
                out.Completed:Wait()
                frame:Destroy()
            end)
        end)
    end

    local System = {
        __properties = {
            __autoparry_enabled = false,
            __triggerbot_enabled = false,
            __manual_spam_enabled = false,
            __auto_spam_enabled = false,
            __play_animation = false,
            __accuracy = 50,
            __divisor_multiplier = 1.1,
            __parried = false,
            __training_parried = false,
            __spam_threshold = 1.5,
            __parries = 0,
            __parry_key = nil,
            __grab_animation = nil,
            __tornado_time = tick(),
            __first_parry_done = false,
            __connections = {},
            __reverted_remotes = {},
            __spam_accumulator = 0,
            __spam_rate = 340,
            __infinity_active = false,
            __deathslash_active = false,
            __timehole_active = false,
            __slashesoffury_active = false,
            __slashesoffury_count = 0,
            __is_mobile = detectMobile(),
            __mobile_guis = {},
            __randomized_accuracy_enabled = false,
            __speed_display_enabled = false,
            __auto_jump_enabled = false,
            __ball_speed = 0,
            __peak_ball_speed = 0,
            __headless_enabled = false,
            __korblox_enabled = false,
            __thunder_dash_enabled = false
        },
        __config = {
            __detections = {
                __infinity=false,__deathslash=false,
                __timehole=false,__slashesoffury=false,__phantom=false
            }
        },
        __triggerbot = {
            __enabled=false,__is_parrying=false,
            __parries=0,__max_parries=10000,__parry_delay=0.05
        }
    }

    local function update_divisor()
        System.__properties.__divisor_multiplier = 0.7 + (System.__properties.__accuracy - 1) * (0.9/99)
    end

    local function update_randomized_accuracy()
        if not System.__properties.__randomized_accuracy_enabled then return end
        local ping_str = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        local ping = tonumber(ping_str:match("%d+")) or 0
        local new_accuracy
        if ping >= 90 then new_accuracy = 4
        elseif ping <= 50 then new_accuracy = math.random(70, 100)
        else new_accuracy = System.__properties.__accuracy end
        if new_accuracy then System.__properties.__accuracy = new_accuracy; update_divisor() end
    end

    task.spawn(function()
        while task.wait(1) do
            if System.__properties.__randomized_accuracy_enabled then update_randomized_accuracy() end
        end
    end)

    local replicated_storage = cloneref(game:GetService('ReplicatedStorage'))
    local workspace = cloneref(game:GetService('Workspace'))

    local _token
    local _tokenFound = false

    local _gcCount = 0
    for _, Function in getgc(true) do
        _gcCount = _gcCount + 1
        if _gcCount % 2500 == 0 then task.wait() end
        if type(Function) ~= 'function' or not debug.info(Function, 's'):find('PRY', 1, true) then
            continue
        end
        for _, value in debug.getupvalues(Function) do
            if type(value) == 'function' then
                _token = value
                _tokenFound = true
                break
            end
        end
        if _token then break end
    end

    if not _tokenFound then
        Notify("NEXUS", "Remote not found! Re-inject vÃ  cháº¡y láº¡i.", 5)
        return
    end

    function _tokenize(_remote_uid)
        local time = tostring(math.floor(workspace:GetServerTimeNow() * 100))
        local key = _token(_remote_uid, 'TIME')
        local characters = table.create(#time)
        for index = 1, #time do
            characters[index] = string.char(bit32.bxor(
                (string.byte(time, index ) + index) % 256,
                string.byte(key, (index - 1) % #key + 1)
            ))
        end
        return table.concat(characters)
    end

    local _reverted = {}
    local _original = {}
    local _captured = nil
    local _capturedRemote = nil
    local _capturedArgs = nil

    function _is_valid(args)
        if not args or #args < 8 then return false end
        return true
    end

    local _hookedMeta, _hookedOld

    -- The Instance metatable is shared by EVERY object in the game, so while
    -- this __index hook is installed each property read in the game goes
    -- through Lua. Once the remote is captured it is no longer needed.
    local function _unhook()
        local meta, old = _hookedMeta, _hookedOld
        if not meta then return end
        _hookedMeta, _hookedOld = nil, nil
        pcall(function()
            setreadonly(meta, false)
            meta.__index = old
            setreadonly(meta, true)
        end)
    end

    function _hook(remote)
        if not remote then return end
        if _reverted[remote] then return end
        if _original[getrawmetatable(remote)] then return end

        _original[getrawmetatable(remote)] = true
        local _meta = getrawmetatable(remote)
        setreadonly(_meta, false)

        local _old = _meta.__index
        _hookedMeta, _hookedOld = _meta, _old
        _meta.__index = function(self, key)
            if (key == 'FireServer' and self:IsA('RemoteEvent')) or
               (key == 'InvokeServer' and self:IsA('RemoteFunction')) then
                return function(_, ...)
                    local _arguments = {...}
                    if _is_valid(_arguments) then
                        if not _reverted[self] then
                            _reverted[self] = _arguments
                            _captured = { remote = self, args = _arguments }
                            _capturedRemote = self
                            _capturedArgs = _arguments
                            task.defer(_unhook)
                        end
                    end
                    return _old(self, key)(_, unpack(_arguments))
                end
            end
            return _old(self, key)
        end
        setreadonly(_meta, true)
    end

    for _iterator, _remote in pairs(replicated_storage:GetDescendants()) do
        if _remote:IsA('RemoteEvent') or _remote:IsA('RemoteFunction') then
            _hook(_remote)
        end
    end

    task.wait(5)

    task.spawn(function()
        while not _capturedRemote do
            task.wait(1)
        end
        if _capturedRemote then
            Notify("NEXUS", "Anti-cheat Bypassed", 3)
        end
    end)

    local function fireParryRemote(curveCF)
        if not _capturedRemote or not _capturedArgs then
            return false
        end

        local cam = Workspace.CurrentCamera
        local is_mobile = System.__properties.__is_mobile
        local aim_target

        if is_mobile then
            local vp = cam.ViewportSize
            aim_target = {math.floor(vp.X / 2), math.floor(vp.Y / 2)}
        else
            local ok, mouse = pcall(function() return UserInputService:GetMouseLocation() end)
            if ok and mouse then
                aim_target = {math.floor(mouse.X), math.floor(mouse.Y)}
            else
                local vp = cam.ViewportSize
                aim_target = {math.floor(vp.X / 2), math.floor(vp.Y / 2)}
            end
        end

        local event_data = {}
        if Alive then
            for _, entity in pairs(Alive:GetChildren()) do
                if entity.PrimaryPart then
                    local ok, sp = pcall(function() return cam:WorldToScreenPoint(entity.PrimaryPart.Position) end)
                    if ok then event_data[entity.Name] = sp end
                end
            end
        end

        local packet = {
            _capturedArgs[1],
            _capturedArgs[2],
            _tokenize(_capturedArgs[2]),
            0.5,
            curveCF or cam.CFrame,
            event_data,
            aim_target,
            false
        }

        pcall(function()
            if _capturedRemote:IsA('RemoteEvent') then
                _capturedRemote:FireServer(unpack(packet))
            elseif _capturedRemote:IsA('RemoteFunction') then
                _capturedRemote:InvokeServer(unpack(packet))
            end
        end)
        return true
    end

    System.animation = {}

    local SwordAPI = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("SwordAPI")
    local LastPlayedd = 0
    local Sword_CP = false
    local Sword_Spped = 1
    local Grab_Parry = nil
    local AnimFix_Cache = {}

    local function GetParryAnimation(swordName)
        if not swordName or swordName == "" then
            return SwordAPI.Collection.Default:FindFirstChild("GrabParry")
        end
        if AnimFix_Cache[swordName] then return AnimFix_Cache[swordName] end
        local ok, swordData = pcall(function()
            return ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(swordName)
        end)
        if not ok or not swordData or type(swordData) ~= "table" or not swordData.AnimationType then
            AnimFix_Cache[swordName] = SwordAPI.Collection.Default:FindFirstChild("GrabParry")
            return AnimFix_Cache[swordName]
        end
        for _, obj in pairs(SwordAPI.Collection:GetChildren()) do
            if obj.Name == swordData.AnimationType then
                local anim = obj:FindFirstChild("GrabParry") or obj:FindFirstChild("Grab")
                if anim then
                    AnimFix_Cache[swordName] = anim
                    return anim
                end
            end
        end
        AnimFix_Cache[swordName] = SwordAPI.Collection.Default:FindFirstChild("GrabParry")
        return AnimFix_Cache[swordName]
    end

    local function GrabParryPlay(track)
        if not track then return end
        pcall(function()
            track:Play(
                track:GetAttribute("PlayFadeTime") or 0,
                track:GetAttribute("PlayWeight") or 1,
                track:GetAttribute("PlaySpeed") or 1
            )
        end)
    end

    local function GrabParryStop(track)
        if not track then return end
        pcall(function()
            track:Stop(track:GetAttribute("StopFadeTime") or 0.1)
        end)
    end

    function System.animation.play_grab_parry()
        if not System.__properties.__play_animation then return end
        if not ((os.clock() - LastPlayedd) >= (Sword_Spped - 0.8) or Sword_CP) then return end
        LastPlayedd = os.clock()
        Sword_CP = false
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local currentSword
        if getgenv().skinChanger then
            currentSword = (getgenv().swordAnimations ~= "" and getgenv().swordAnimations)
                        or (getgenv().swordModel ~= "" and getgenv().swordModel)
                        or char:GetAttribute("CurrentlyEquippedSword")
        else
            currentSword = char:GetAttribute("CurrentlyEquippedSword")
        end
        local animation = GetParryAnimation(currentSword)
        if not animation then return end
        for _, track in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
            if track.Name == "GrabParry" or track.Name == "Grab" then
                track.TimePosition = 0
                GrabParryStop(track)
            elseif track.Name == "SuccessParry" or track.Name == "Success" then
                GrabParryStop(track)
            end
        end
        Grab_Parry = humanoid.Animator:LoadAnimation(animation)
        GrabParryPlay(Grab_Parry)
    end

    pcall(function()
        Track(ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function()
            Sword_CP = true
            local char = LocalPlayer.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            for _, track in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
                if track.Name == "GrabParry" or track.Name == "Grab" then
                    GrabParryStop(track)
                end
            end
        end))
    end)

    System.ball = {}
    function System.ball.get()
        local balls=Workspace:FindFirstChild('Balls'); if not balls then return nil end
        for _,ball in pairs(balls:GetChildren()) do
            if ball:GetAttribute('realBall') then ball.CanCollide=false; return ball end
        end; return nil
    end
    function System.ball.get_all()
        local balls_table={}; local balls=Workspace:FindFirstChild('Balls')
        if not balls then return balls_table end
        for _,ball in pairs(balls:GetChildren()) do
            if ball:GetAttribute('realBall') then ball.CanCollide=false; table.insert(balls_table,ball) end
        end; return balls_table
    end

    System.player = {}
    local Closest_Entity=nil; local last_closest_check=0
    function System.player.get_closest()
        local now=tick()
        if now-last_closest_check < 0.1 then return Closest_Entity end
        last_closest_check=now
        local max_distance=math.huge; local closest_entity=nil
        if not Alive then return nil end
        for _,entity in pairs(Alive:GetChildren()) do
            if entity ~= LocalPlayer.Character and entity.PrimaryPart then
                local distance=LocalPlayer:DistanceFromCharacter(entity.PrimaryPart.Position)
                if distance < max_distance then max_distance=distance; closest_entity=entity end
            end
        end
        Closest_Entity=closest_entity; return closest_entity
    end

    local CURVE_NAMES = {"Camera","Random","Accelerated","Backwards","Slow","High","Normal","Speed","Down","Left","Right"}
    local Selected_Parry_Type = "Camera"
    local CurveType = "Camera"

    System.curve = {}
    function System.curve.get_cframe()
        local Camera = Workspace.CurrentCamera
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local root_pos = root and root.Position or Camera.CFrame.Position

        local targetPart
        do
            local bestDist = math.huge
            local mouseLoc = not System.__properties.__is_mobile and UserInputService:GetMouseLocation() or nil
            if Alive then
                for _, v in pairs(Alive:GetChildren()) do
                    if v ~= LocalPlayer.Character and v.PrimaryPart then
                        local screenPos, onScreen = Camera:WorldToScreenPoint(v.PrimaryPart.Position)
                        if onScreen then
                            local dist
                            if mouseLoc then
                                dist = (Vector2.new(screenPos.X, screenPos.Y) - mouseLoc).Magnitude
                            else
                                local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                                dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                            end
                            if dist < bestDist then bestDist = dist; targetPart = v.PrimaryPart end
                        end
                    end
                end
            end
        end
        local target_pos = targetPart and targetPart.Position or (root_pos + Camera.CFrame.LookVector * 100)

        local Parry_Type = Selected_Parry_Type
        local cf

        if Parry_Type == "Camera" then
            cf = Camera.CFrame
        elseif Parry_Type == "Random" then
            local direction = (target_pos - root_pos).Unit
            local random_offset
            local attempts = 0
            repeat
                random_offset = Vector3.new(math.random(-4000,4000), math.random(-4000,4000), math.random(-4000,4000))
                local curve_dir = (target_pos + random_offset - root_pos).Unit
                local dot = direction:Dot(curve_dir)
                attempts = attempts + 1
            until dot < 0.95 or attempts > 10
            cf = CFrame.new(root_pos, target_pos + random_offset)
        elseif Parry_Type == "Accelerated" then
            cf = CFrame.new(root_pos, target_pos + Vector3.new(0, 5, 0))
        elseif Parry_Type == "Backwards" then
            local direction = (root_pos - target_pos).Unit
            local backwards_pos = root_pos + direction * 10000 + Vector3.new(0, 1000, 0)
            cf = CFrame.new(Camera.CFrame.Position, backwards_pos)
        elseif Parry_Type == "Slow" then
            cf = CFrame.new(root_pos, target_pos + Vector3.new(0, -9e18, 0))
        elseif Parry_Type == "High" then
            cf = CFrame.new(root_pos, target_pos + Vector3.new(0, 9e18, 0))
        elseif Parry_Type == "Normal" then
            cf = CFrame.new(root_pos, root_pos + (root and root.CFrame.LookVector or Camera.CFrame.LookVector))
        elseif Parry_Type == "Speed" then
            cf = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Camera.CFrame.UpVector * 5)
        elseif Parry_Type == "Down" then
            cf = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Camera.CFrame.UpVector * -9e9)
        elseif Parry_Type == "Left" then
            cf = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position - Camera.CFrame.RightVector * 9e9)
        elseif Parry_Type == "Right" then
            cf = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Camera.CFrame.RightVector * 9e9)
        else
            cf = Camera.CFrame
        end

        return cf
    end

    System.parry = {}
    function System.parry.execute()
        if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end
        fireParryRemote(System.curve.get_cframe())
        if System.__properties.__parries > 10000 then return end
        System.__properties.__parries=System.__properties.__parries+1
        task.delay(0.5,function() if System.__properties.__parries > 0 then System.__properties.__parries=System.__properties.__parries-1 end end)
    end

    function System.parry.keypress()
        if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end
        fireParryRemote(System.curve.get_cframe())
        if System.__properties.__parries > 10000 then return end
        System.__properties.__parries=System.__properties.__parries+1
        task.delay(0.5,function() if System.__properties.__parries > 0 then System.__properties.__parries=System.__properties.__parries-1 end end)
    end

    function System.parry.execute_action()
        System.animation.play_grab_parry(); System.parry.execute()
    end

    local function linear_predict(a,b,t) return a+(b-a)*t end

    System.detection = {
        __ball_properties = {__aerodynamic_time=tick(),__last_warping=tick(),__lerp_radians=0,__curving=tick()}
    }

    function System.detection.is_curved()
        local props=System.detection.__ball_properties
        local ball=System.ball.get(); if not ball then return false end
        local zoomies=ball:FindFirstChild("zoomies"); if not zoomies then return false end
        local velocity=zoomies.VectorVelocity; local speed=velocity.Magnitude
        if speed < 1 then return false end
        local ball_dir=velocity.Unit; local char=LocalPlayer.Character
        if not char or not char.PrimaryPart then return false end
        local pos=char.PrimaryPart.Position; local direction=(pos-ball.Position).Unit
        local dot=direction:Dot(ball_dir)
        local ping=Stats.Network.ServerStatsItem["Data Ping"]:GetValue()/1000
        local distance=(pos-ball.Position).Magnitude; local reach_time=distance/speed-ping
        local dot_threshold=math.clamp(0.55-(ping*0.75),-1,0.45)
        local speed_threshold=math.min(speed/100,45)
        local ball_distance_threshold=15-math.min(distance/1000,15)+speed_threshold
        local clamped_dot=math.clamp(dot,-1,1); local radians=math.asin(clamped_dot)
        props.__lerp_radians=linear_predict(props.__lerp_radians,radians,0.85)
        if props.__lerp_radians < 0.016 then props.__last_warping=tick() end
        if distance < (ball_distance_threshold*0.85) then return false end
        if (tick()-props.__last_warping) < (reach_time/1.4) then return true end
        if (tick()-props.__curving) < (reach_time/1.1) then return true end
        return dot < dot_threshold
    end

    Track(ReplicatedStorage.Remotes.DeathBall.OnClientEvent:Connect(function(c,d)
        System.__properties.__deathslash_active = d or false
    end))
    Track(ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(a,b)
        System.__properties.__infinity_active = b or false
    end))

    Track(ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/TimeHoleActivate"].OnClientEvent:Connect(function(...)
        local args={...}; local player=args[1]
        if player==LocalPlayer or player==LocalPlayer.Name or (player and player.Name==LocalPlayer.Name) then
            System.__properties.__timehole_active=true
        end
    end))
    Track(ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/TimeHoleDeactivate"].OnClientEvent:Connect(function()
        System.__properties.__timehole_active=false
    end))

    local maxParryCount=36; local parryDelay=0.05

    Track(ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryActivate"].OnClientEvent:Connect(function(...)
        local args={...}; local player=args[1]
        if player==LocalPlayer or player==LocalPlayer.Name or (player and player.Name==LocalPlayer.Name) then
            System.__properties.__slashesoffury_active=true; System.__properties.__slashesoffury_count=0
        end
    end))
    Track(ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryEnd"].OnClientEvent:Connect(function()
        System.__properties.__slashesoffury_active=false; System.__properties.__slashesoffury_count=0
    end))
    Track(ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryParry"].OnClientEvent:Connect(function()
        System.__properties.__slashesoffury_count=System.__properties.__slashesoffury_count+1
    end))
    Track(ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryCatch"].OnClientEvent:Connect(function()
        spawn(function()
            while System.__properties.__slashesoffury_active and System.__properties.__slashesoffury_count < maxParryCount do
                if System.__config.__detections.__slashesoffury then System.parry.execute(); task.wait(parryDelay)
                else break end
            end
        end)
    end))

    Track(Runtime.ChildAdded:Connect(function(Object)
        if System.__config.__detections.__phantom then
            if Object.Name=="maxTransmission" or Object.Name=="transmissionpart" then
                local Weld=Object:FindFirstChildWhichIsA("WeldConstraint")
                if Weld then
                    local Character=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    if Character and Weld.Part1==Character.HumanoidRootPart then
                        local CurrentBall=System.ball.get(); Weld:Destroy()
                        if CurrentBall then
                            local FocusConnection
                            FocusConnection=RunService.RenderStepped:Connect(function()
                                local Highlighted=CurrentBall:GetAttribute("highlighted")
                                if Highlighted==true then
                                    ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                                    System.__properties.__parried=true
                                    task.delay(1,function() System.__properties.__parried=false end)
                                elseif Highlighted==false then FocusConnection:Disconnect() end
                            end)
                            task.delay(3,function() if FocusConnection and FocusConnection.Connected then FocusConnection:Disconnect() end end)
                        end
                    end
                end
            end
        end
    end))

    Track(ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_,root)
        if root.Parent and root.Parent ~= LocalPlayer.Character then
            if not Alive or root.Parent.Parent ~= Alive then return end
        end
        local closest=System.player.get_closest(); local ball=System.ball.get()
        if not ball or not closest then return end
        local target_distance=(LocalPlayer.Character.PrimaryPart.Position-closest.PrimaryPart.Position).Magnitude
        local distance=(LocalPlayer.Character.PrimaryPart.Position-ball.Position).Magnitude
        local direction=(LocalPlayer.Character.PrimaryPart.Position-ball.Position).Unit
        local dot=direction:Dot(ball.AssemblyLinearVelocity.Unit)
        local curve_detected=System.detection.is_curved()
        if target_distance < 15 and distance < 15 and dot > -0.25 then
            if curve_detected then System.parry.execute_action() end
        end
        if System.__properties.__grab_animation then System.__properties.__grab_animation:Stop() end
    end))

    Track(ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
        if not Alive or LocalPlayer.Character.Parent ~= Alive then return end
        if System.__properties.__grab_animation then System.__properties.__grab_animation:Stop() end
    end))

    Track(ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(a,b)
        local Primary_Part=LocalPlayer.Character.PrimaryPart
        local Ball=System.ball.get(); if not Ball then return end
        local Zoomies=Ball:FindFirstChild('zoomies'); if not Zoomies then return end
        local Speed=Zoomies.VectorVelocity.Magnitude
        local Distance=(LocalPlayer.Character.PrimaryPart.Position-Ball.Position).Magnitude
        local Velocity=Zoomies.VectorVelocity; local Ball_Direction=Velocity.Unit
        local Direction=(LocalPlayer.Character.PrimaryPart.Position-Ball.Position).Unit
        local Dot=Direction:Dot(Ball_Direction)
        local Pings=Stats.Network.ServerStatsItem['Data Ping']:GetValue()
        local Speed_Threshold=math.min(Speed/100,40)
        local Reach_Time=Distance/Speed-(Pings/1000)
        local Enough_Speed=Speed > 1
        local Ball_Distance_Threshold=15-math.min(Distance/1000,15)+Speed_Threshold
        if Enough_Speed and Reach_Time > Pings/10 then
            Ball_Distance_Threshold=math.max(Ball_Distance_Threshold-15,15)
        end
        if b ~= Primary_Part and Distance > Ball_Distance_Threshold then
            System.detection.__ball_properties.__curving=tick()
        end
    end))

    System.triggerbot = {}
    local triggerbotCooldown = false

    function System.triggerbot.trigger(ball)
        if triggerbotCooldown then return end
        if System.__triggerbot.__is_parrying then return end
        if System.__triggerbot.__parries > System.__triggerbot.__max_parries then return end
        if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and
           LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape') then return end

        triggerbotCooldown = true
        System.__triggerbot.__is_parrying=true
        System.__triggerbot.__parries=System.__triggerbot.__parries+1

        System.parry.execute()

        if System.__properties.__play_animation then
            System.animation.play_grab_parry()
        end

        task.delay(0.2,function()
            triggerbotCooldown = false
            if System.__triggerbot.__parries > 0 then
                System.__triggerbot.__parries=System.__triggerbot.__parries-1
            end
        end)

        task.spawn(function()
            local start_time=tick()
            repeat RunService.Heartbeat:Wait()
            until (tick()-start_time >= 0.15 or not System.__triggerbot.__is_parrying)
            System.__triggerbot.__is_parrying=false
        end)
    end

    function System.triggerbot.loop()
        if not System.__triggerbot.__enabled then return end
        if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and
           LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape') then return end
        local balls=Workspace:FindFirstChild('Balls'); if not balls then return end
        for _,ball in pairs(balls:GetChildren()) do
            if ball:IsA('BasePart') and ball:GetAttribute('target')==LocalPlayer.Name then
                System.triggerbot.trigger(ball)
                break
            end
        end
    end

    function System.triggerbot.enable(enabled)
        System.__triggerbot.__enabled=enabled
        if enabled then
            if not System.__properties.__connections.__triggerbot then
                System.__properties.__connections.__triggerbot=RunService.Heartbeat:Connect(System.triggerbot.loop)
            end
        else
            if System.__properties.__connections.__triggerbot then
                System.__properties.__connections.__triggerbot:Disconnect()
                System.__properties.__connections.__triggerbot=nil
            end
            System.__triggerbot.__is_parrying=false
            System.__triggerbot.__parries=0
            triggerbotCooldown = false
        end
    end

    System.manual_spam = {}
    local manualSpamThread=nil
    local macroSpamActive=false
    local macroFrameFireCount=0; local macroFrameTime=0; local macroRealCPS=0; local macroAnimFix=true

    function System.manual_spam.start()
        System.manual_spam.stop()
        System.__properties.__manual_spam_enabled=true; macroSpamActive=true
        local parry_keypress=System.parry.keypress; local parry_execute=System.parry.execute
        local play_animation=System.animation.play_grab_parry; local threshold=0.015
        manualSpamThread=coroutine.create(function()
            local last_spam=0
            while System.__properties.__manual_spam_enabled do
                local now=os.clock()
                if now-last_spam >= threshold then
                    last_spam=now
                    if getgenv().ManualSpamMode=="Keypress" then parry_keypress()
                    else parry_execute(); if getgenv().ManualSpamAnimationFix then play_animation() end end
                end
                coroutine.yield()
            end
        end)
        task.spawn(function()
            while System.__properties.__manual_spam_enabled and manualSpamThread
                  and coroutine.status(manualSpamThread) ~= "dead" do
                coroutine.resume(manualSpamThread); task.wait()
            end
        end)
    end

    function System.manual_spam.stop()
        System.__properties.__manual_spam_enabled=false; macroSpamActive=false; manualSpamThread=nil
    end

    Track(RunService.Heartbeat:Connect(function(dt)
        macroFrameTime=macroFrameTime+dt
        if macroFrameTime >= 0.1 then
            if macroSpamActive then macroRealCPS=math.floor(macroFrameFireCount/macroFrameTime) end
            macroFrameFireCount=0; macroFrameTime=0
        end
        if macroSpamActive and _capturedRemote then
            pcall(function() fireParryRemote(System.curve.get_cframe()); macroFrameFireCount=macroFrameFireCount+1 end)
            if macroAnimFix then System.animation.play_grab_parry() end
        end
    end))

    System.auto_spam = {}

    function System.auto_spam:get_entity_properties()
        System.player.get_closest()
        if not Closest_Entity or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart or not Closest_Entity.PrimaryPart then return false end
        local entity_velocity = Closest_Entity.PrimaryPart.AssemblyLinearVelocity
        local entity_direction = (LocalPlayer.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Unit
        local entity_distance = (LocalPlayer.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
        return {Velocity = entity_velocity, Direction = entity_direction, Distance = entity_distance}
    end

    function System.auto_spam:get_ball_properties()
        local ball = System.ball.get()
        if not ball or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return false end
        local ball_velocity = ball.AssemblyLinearVelocity
        local ball_direction = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
        local ball_distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
        local ball_dot = ball_velocity.Magnitude > 0 and ball_direction:Dot(ball_velocity.Unit) or 0
        return {Velocity = ball_velocity, Direction = ball_direction, Distance = ball_distance, Dot = ball_dot}
    end

    function System.auto_spam.spam_service(self)
        local ball = System.ball.get()
        local entity = System.player.get_closest()
        if not ball or not entity or not entity.PrimaryPart or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return 0 end
        local velocity = ball.AssemblyLinearVelocity
        local speed = velocity.Magnitude
        local direction = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
        local dot = speed > 0 and direction:Dot(velocity.Unit) or 0
        local target_distance = LocalPlayer:DistanceFromCharacter(entity.PrimaryPart.Position)
        local maximum_spam_distance = self.Ping + math.min(speed / 6, 255)
        if self.Entity_Properties.Distance > maximum_spam_distance or self.Ball_Properties.Distance > maximum_spam_distance or target_distance > maximum_spam_distance then return 0 end
        local maximum_speed = 5 - math.min(speed / 5, 5)
        local maximum_dot = math.clamp(dot, -1, 0) * maximum_speed
        return maximum_spam_distance - maximum_dot
    end

    function System.auto_spam.start()
        if System.__properties.__connections.__auto_spam then
            System.__properties.__connections.__auto_spam:Disconnect()
        end
        System.__properties.__auto_spam_enabled = true
        System.__properties.__connections.__auto_spam = RunService.PreSimulation:Connect(function()
            if not System.__properties.__auto_spam_enabled then return end
            local ball = System.ball.get()
            if not ball or System.__properties.__slashesoffury_active then return end
            local zoomies = ball:FindFirstChild("zoomies")
            if not zoomies then return end
            System.player.get_closest()
            local ball_properties = System.auto_spam:get_ball_properties()
            local entity_properties = System.auto_spam:get_entity_properties()
            if not ball_properties or not entity_properties or not Closest_Entity or not Closest_Entity.PrimaryPart then return end
            local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            local ping_threshold = math.clamp(ping / 10, 1, 16)
            local spam_accuracy = System.auto_spam.spam_service({
                Ball_Properties = ball_properties,
                Entity_Properties = entity_properties,
                Ping = ping_threshold
            })
            local target_distance = LocalPlayer:DistanceFromCharacter(Closest_Entity.PrimaryPart.Position)
            local direction = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
            local ball_direction = zoomies.VectorVelocity.Magnitude > 0 and zoomies.VectorVelocity.Unit or Vector3.zero
            local dot = ball_direction.Magnitude > 0 and direction:Dot(ball_direction) or 0
            local distance = LocalPlayer:DistanceFromCharacter(ball.Position)
            local ball_target = ball:GetAttribute("target")
            if not ball_target or target_distance > spam_accuracy or distance > spam_accuracy then return end
            if LocalPlayer.Character:GetAttribute("Pulsed") then return end
            if ball_target == LocalPlayer.Name and target_distance > 30 and distance > 30 then return end
            if distance <= spam_accuracy and System.__properties.__parries > System.__properties.__spam_threshold then
                if getgenv().AutoSpamMode == "Keypress" then
                    if PF then PF() end
                else
                    System.parry.execute()
                    if getgenv().AutoSpamAnimationFix and PF then PF() end
                end
            end
        end)
    end

    function System.auto_spam.stop()
        System.__properties.__auto_spam_enabled = false
        if System.__properties.__connections.__auto_spam then
            System.__properties.__connections.__auto_spam:Disconnect()
            System.__properties.__connections.__auto_spam = nil
        end
    end

    System.autoparry = {}

    -- One persistent 'target changed' connection per ball (weak table), instead of
    -- creating a new :Once() connection on every frame for every ball.
    local _targetWatched = setmetatable({}, {__mode = "k"})
    local function _watchTarget(ball, propName)
        if _targetWatched[ball] then return end
        _targetWatched[ball] = true
        ball:GetAttributeChangedSignal('target'):Connect(function()
            System.__properties[propName] = false
        end)
    end
    function System.autoparry.start()
        if System.__properties.__connections.__autoparry then
            System.__properties.__connections.__autoparry:Disconnect()
        end
        System.__properties.__connections.__autoparry=RunService.PreSimulation:Connect(function()
            if not System.__properties.__autoparry_enabled or not LocalPlayer.Character or
               not LocalPlayer.Character.PrimaryPart then return end
            local balls=System.ball.get_all(); local one_ball=System.ball.get()
            local training_ball=nil
            if Workspace:FindFirstChild("TrainingBalls") then
                for _,Instance in pairs(Workspace.TrainingBalls:GetChildren()) do
                    if Instance:GetAttribute("realBall") then training_ball=Instance; break end
                end
            end
            for _,ball in pairs(balls) do
                if System.__triggerbot.__enabled then return end
                if getgenv().BallVelocityAbove800 then return end
                if not ball then continue end
                local zoomies=ball:FindFirstChild('zoomies'); if not zoomies then continue end
                _watchTarget(ball, '__parried')
                if System.__properties.__parried then continue end
                local ball_target=ball:GetAttribute('target')
                local velocity=zoomies.VectorVelocity
                local distance=(LocalPlayer.Character.PrimaryPart.Position-ball.Position).Magnitude
                local ping=Stats.Network.ServerStatsItem['Data Ping']:GetValue()/10
                local ping_threshold=math.clamp(ping/10,5,17); local speed=velocity.Magnitude
                local capped_speed_diff=math.min(math.max(speed-9.5,0),650)
                local speed_divisor=(2.4+capped_speed_diff*0.002)*System.__properties.__divisor_multiplier
                local parry_accuracy=ping_threshold+math.max(speed/speed_divisor,9.5)
                local curved=System.detection.is_curved()
                if ball:FindFirstChild('AeroDynamicSlashVFX') then
                    ball.AeroDynamicSlashVFX:Destroy(); System.__properties.__tornado_time=tick()
                end
                if Runtime:FindFirstChild('Tornado') then
                    if (tick()-System.__properties.__tornado_time) <
                       (Runtime.Tornado:GetAttribute('TornadoTime') or 1)+0.314159 then continue end
                end
                if one_ball and one_ball:GetAttribute('target')==LocalPlayer.Name and curved then continue end
                if ball:FindFirstChild('ComboCounter') then continue end
                if LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape') then continue end
                if System.__config.__detections.__infinity and System.__properties.__infinity_active then continue end
                if System.__config.__detections.__deathslash and System.__properties.__deathslash_active then continue end
                if System.__config.__detections.__timehole and System.__properties.__timehole_active then continue end
                if System.__config.__detections.__slashesoffury and System.__properties.__slashesoffury_active then continue end
                if ball_target==LocalPlayer.Name and distance <= parry_accuracy then
                    if getgenv().AutoAbility then
                        local AbilityCD=LocalPlayer.PlayerGui.Hotbar.Ability.UIGradient
                        if AbilityCD and AbilityCD.Offset.Y==0.5 then
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Abilities") then
                                local abilities=LocalPlayer.Character.Abilities
                                if (abilities:FindFirstChild("Raging Deflection") and abilities["Raging Deflection"].Enabled) or
                                   (abilities:FindFirstChild("Rapture") and abilities["Rapture"].Enabled) or
                                   (abilities:FindFirstChild("Calming Deflection") and abilities["Calming Deflection"].Enabled) or
                                   (abilities:FindFirstChild("Aerodynamic Slash") and abilities["Aerodynamic Slash"].Enabled) or
                                   (abilities:FindFirstChild("Fracture") and abilities["Fracture"].Enabled) or
                                   (abilities:FindFirstChild("Death Slash") and abilities["Death Slash"].Enabled) then
                                    System.__properties.__parried=true
                                    ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                                    task.wait(2.432)
                                    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DeathSlashShootActivation"):FireServer(true)
                                    continue
                                end
                            end
                        end
                    end
                end
                if ball_target==LocalPlayer.Name and distance <= parry_accuracy then
                    if getgenv().AutoParryMode=="Keypress" then System.parry.keypress()
                    else System.parry.execute_action() end
                    System.__properties.__parried=true
                end
                local last_parrys=tick()
                repeat RunService.Stepped:Wait()
                until (tick()-last_parrys) >= 1 or not System.__properties.__parried
                System.__properties.__parried=false
            end
            if training_ball then
                local zoomies=training_ball:FindFirstChild('zoomies')
                if zoomies then
                    _watchTarget(training_ball, '__training_parried')
                    if not System.__properties.__training_parried then
                        local ball_target=training_ball:GetAttribute('target')
                        local velocity=zoomies.VectorVelocity
                        local distance=LocalPlayer:DistanceFromCharacter(training_ball.Position)
                        local speed=velocity.Magnitude
                        local ping=Stats.Network.ServerStatsItem['Data Ping']:GetValue()/10
                        local ping_threshold=math.clamp(ping/10,5,17)
                        local capped_speed_diff=math.min(math.max(speed-9.5,0),650)
                        local speed_divisor=(2.4+capped_speed_diff*0.002)*System.__properties.__divisor_multiplier
                        local parry_accuracy=ping_threshold+math.max(speed/speed_divisor,9.5)
                        if ball_target==LocalPlayer.Name and distance <= parry_accuracy then
                            if getgenv().AutoParryMode=="Keypress" then System.parry.keypress()
                            else System.parry.execute_action() end
                            System.__properties.__training_parried=true
                            local last_parrys=tick()
                            repeat RunService.Stepped:Wait()
                            until (tick()-last_parrys) >= 1 or not System.__properties.__training_parried
                            System.__properties.__training_parried=false
                        end
                    end
                end
            end
        end)
    end

    function System.autoparry.stop()
        if System.__properties.__connections.__autoparry then
            System.__properties.__connections.__autoparry:Disconnect()
            System.__properties.__connections.__autoparry=nil
        end
    end

    local ManualSpamGui = nil
    local ManualSpamConnections = {}
    local TriggerGui = nil
    local TriggerConnections = {}
    local CurveGui = nil
    local CurveConnections = {}
    local KeyboardGui = nil
    local KeyboardConnections = {}
    local KeyboardKeyConnections = {}
    local KeyboardCapture = nil
    local KeyboardCaptureConsumed = false

    local KeyboardSettings = {
        AutoParry = Enum.KeyCode.T,
        AutoSpam = Enum.KeyCode.V,
        ManualSpam = Enum.KeyCode.F,
        ManualSpamMode = "Hold to Spam"
    }

    local function keyName(keyCode)
        return keyCode == Enum.KeyCode.Unknown and "None" or keyCode.Name
    end

    local function isKeyboardInput(input)
        return input.UserInputType == Enum.UserInputType.Keyboard
            and input.KeyCode ~= Enum.KeyCode.Unknown
    end

    local function stopManualKeyboardSpam()
        if KeyboardSettings.ManualSpamMode == "Hold to Spam" and System.__properties.__manual_spam_enabled then
            _G.manualSpamEnabled = false
            if _G.NEXUS then _G.NEXUS.manualSpamEnabled = false end
            System.manual_spam.stop()
            macroSpamActive = false
        end
    end

    local function toggleManualKeyboardSpam()
        local state = not System.__properties.__manual_spam_enabled
        _G.manualSpamEnabled = state
        _G.NEXUS = _G.NEXUS or {}
        _G.NEXUS.manualSpamEnabled = state
        System.__properties.__manual_spam_enabled = state
        macroSpamActive = state
        if state then
            System.manual_spam.start()
        else
            System.manual_spam.stop()
        end
    end

    local function SetKeyboardKey(name, keyCode)
        KeyboardSettings[name] = keyCode
    end

    local DisconnectConnections

    local function CreateKeyboardUI()
        if KeyboardGui and KeyboardGui.Parent then
            KeyboardGui.Enabled = true
            return
        end

        local gui = Instance.new("ScreenGui")
        gui.Name = "NEXUS_KeyboardUI"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = CoreGui
        KeyboardGui = gui

        local Main = Instance.new("Frame")
        Main.Name = "Keyboard"
        Main.Size = UDim2.fromOffset(260, 126)
        Main.Position = UDim2.new(0.5, -130, 0.5, -63)
        Main.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
        Main.BorderSizePixel = 0
        Main.Active = true
        Main.ZIndex = 2500
        Main.Parent = gui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 13)
        Corner.Parent = Main

        local Stroke = Instance.new("UIStroke")
        Stroke.Thickness = 1.5
        Stroke.Color = Color3.fromRGB(70, 70, 70)
        Stroke.Transparency = 0.25
        Stroke.Parent = Main

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -20, 0, 32)
        Title.Position = UDim2.fromOffset(10, 5)
        Title.BackgroundTransparency = 1
        Title.Text = "Keyboard"
        Title.TextColor3 = Color3.fromRGB(245, 245, 245)
        Title.TextSize = 15
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Center
        Title.ZIndex = 2502
        Title.Parent = Main

        local Divider = Instance.new("Frame")
        Divider.Size = UDim2.new(1, 0, 0, 1)
        Divider.Position = UDim2.fromOffset(0, 40)
        Divider.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
        Divider.BorderSizePixel = 0
        Divider.ZIndex = 2501
        Divider.Parent = Main

        local Rows = Instance.new("Frame")
        Rows.Size = UDim2.new(1, -20, 0, 76)
        Rows.Position = UDim2.fromOffset(10, 47)
        Rows.BackgroundTransparency = 1
        Rows.ZIndex = 2502
        Rows.Parent = Main

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 4)
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.Parent = Rows

        local modeOpen = false
        local modePanel = Instance.new("Frame")
        modePanel.Size = UDim2.new(1, -20, 0, 46)
        modePanel.Position = UDim2.fromOffset(10, 123)
        modePanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        modePanel.BorderSizePixel = 0
        modePanel.Visible = false
        modePanel.ZIndex = 2510
        modePanel.Parent = Main

        local modeCorner = Instance.new("UICorner")
        modeCorner.CornerRadius = UDim.new(0, 9)
        modeCorner.Parent = modePanel

        local modeStroke = Instance.new("UIStroke")
        modeStroke.Thickness = 1
        modeStroke.Color = Color3.fromRGB(55, 55, 55)
        modeStroke.Parent = modePanel

        local function makeButton(parent, textValue, widthScale, xScale)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(widthScale, -4, 1, 0)
            button.Position = UDim2.new(xScale, 2, 0, 0)
            button.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            button.BorderSizePixel = 0
            button.Text = textValue
            button.TextColor3 = Color3.fromRGB(245, 245, 245)
            button.TextSize = 12
            button.Font = Enum.Font.GothamSemibold
            button.AutoButtonColor = false
            button.ZIndex = 2512
            button.Parent = parent
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 7)
            c.Parent = button
            local st = Instance.new("UIStroke")
            st.Thickness = 1
            st.Color = Color3.fromRGB(55, 55, 55)
            st.Parent = button
            return button
        end

        local function makeRow(label, settingName)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 22)
            row.BackgroundTransparency = 1
            row.ZIndex = 2503
            row.Parent = Rows

            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(0.58, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = label
            text.TextColor3 = Color3.fromRGB(230, 230, 230)
            text.TextSize = 13
            text.Font = Enum.Font.GothamMedium
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.ZIndex = 2504
            text.Parent = row

            local button = makeButton(row, keyName(KeyboardSettings[settingName]), 0.42, 0.58)
            return button
        end

        local autoParryButton = makeRow("Auto Parry", "AutoParry")
        local autoSpamButton = makeRow("Auto Spam", "AutoSpam")

        local manualRow = Instance.new("Frame")
        manualRow.Size = UDim2.new(1, 0, 0, 22)
        manualRow.BackgroundTransparency = 1
        manualRow.ZIndex = 2503
        manualRow.Parent = Rows

        local manualText = Instance.new("TextLabel")
        manualText.Size = UDim2.new(0.34, 0, 1, 0)
        manualText.BackgroundTransparency = 1
        manualText.Text = "Manual Spam"
        manualText.TextColor3 = Color3.fromRGB(230, 230, 230)
        manualText.TextSize = 13
        manualText.Font = Enum.Font.GothamMedium
        manualText.TextXAlignment = Enum.TextXAlignment.Left
        manualText.ZIndex = 2504
        manualText.Parent = manualRow

        local manualKeyButton = makeButton(manualRow, keyName(KeyboardSettings.ManualSpam), 0.28, 0.34)
        local manualModeButton = makeButton(manualRow, KeyboardSettings.ManualSpamMode, 0.38, 0.62)

        local function animateMode(open)
            modeOpen = open
            if open then
                modePanel.Visible = true
                modePanel.Size = UDim2.new(1, -20, 0, 0)
                modePanel.Position = UDim2.fromOffset(10, 123)
                TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(260, 180)
                }):Play()
                TweenService:Create(modePanel, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, -20, 0, 46)
                }):Play()
            else
                local tween = TweenService:Create(modePanel, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    Size = UDim2.new(1, -20, 0, 0)
                })
                tween:Play()
                TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    Size = UDim2.fromOffset(260, 126)
                }):Play()
                tween.Completed:Connect(function()
                    if not modeOpen then modePanel.Visible = false end
                end)
            end
        end

        local holdOption = makeButton(modePanel, "Hold to Spam", 0.5, 0)
        local onceOption = makeButton(modePanel, "Press Once to Spam", 0.5, 0.5)

        local function selectMode(mode)
            KeyboardSettings.ManualSpamMode = mode
            manualModeButton.Text = mode
            animateMode(false)
        end

        manualModeButton.MouseButton1Click:Connect(function()
            animateMode(not modeOpen)
        end)
        holdOption.MouseButton1Click:Connect(function()
            selectMode("Hold to Spam")
        end)
        onceOption.MouseButton1Click:Connect(function()
            selectMode("Press Once to Spam")
        end)

        local function beginKeyCapture(settingName, button)
            if KeyboardCapture then return end
            KeyboardCapture = settingName
            button.Text = "Press a key..."
            task.spawn(function()
                local timeout = os.clock() + 8
                while KeyboardCapture == settingName and os.clock() < timeout do
                    task.wait()
                end
                if KeyboardCapture == settingName then
                    KeyboardCapture = nil
                    button.Text = keyName(KeyboardSettings[settingName])
                end
            end)
        end

        autoParryButton.MouseButton1Click:Connect(function()
            beginKeyCapture("AutoParry", autoParryButton)
        end)
        autoSpamButton.MouseButton1Click:Connect(function()
            beginKeyCapture("AutoSpam", autoSpamButton)
        end)
        manualKeyButton.MouseButton1Click:Connect(function()
            beginKeyCapture("ManualSpam", manualKeyButton)
        end)

        KeyboardConnections.capture = UserInputService.InputBegan:Connect(function(input, processed)
            if not isKeyboardInput(input) then return end
            if KeyboardCapture then
                local name = KeyboardCapture
                KeyboardCapture = nil
                KeyboardCaptureConsumed = true
                SetKeyboardKey(name, input.KeyCode)
                local button = name == "AutoParry" and autoParryButton or name == "AutoSpam" and autoSpamButton or manualKeyButton
                button.Text = keyName(input.KeyCode)
                return
            end
        end)

        KeyboardConnections.inputBegan = UserInputService.InputBegan:Connect(function(input, processed)
            if KeyboardCaptureConsumed then
                KeyboardCaptureConsumed = false
                return
            end
            if processed or not isKeyboardInput(input) or KeyboardCapture then return end
            if input.KeyCode == KeyboardSettings.AutoParry then
                local state = not System.__properties.__autoparry_enabled
                System.__properties.__autoparry_enabled = state
                System.__properties.__play_animation = state
                if state then System.autoparry.start() else System.autoparry.stop() end
            elseif input.KeyCode == KeyboardSettings.AutoSpam then
                local state = not System.__properties.__auto_spam_enabled
                System.__properties.__auto_spam_enabled = state
                if state then System.auto_spam.start() else System.auto_spam.stop() end
            elseif input.KeyCode == KeyboardSettings.ManualSpam then
                if KeyboardSettings.ManualSpamMode == "Press Once to Spam" then
                    toggleManualKeyboardSpam()
                else
                    if not System.__properties.__manual_spam_enabled then
                        _G.manualSpamEnabled = true
                        _G.NEXUS = _G.NEXUS or {}
                        _G.NEXUS.manualSpamEnabled = true
                        System.manual_spam.start()
                    end
                end
            end
        end)

        KeyboardConnections.inputEnded = UserInputService.InputEnded:Connect(function(input)
            if not isKeyboardInput(input) or KeyboardCapture then return end
            if input.KeyCode == KeyboardSettings.ManualSpam and KeyboardSettings.ManualSpamMode == "Hold to Spam" then
                stopManualKeyboardSpam()
            end
        end)

        local dragging = false
        local dragStart
        local startPos
        KeyboardConnections.dragBegan = Main.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end)
        KeyboardConnections.dragChanged = UserInputService.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end)
        KeyboardConnections.dragEnded = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    local function DestroyKeyboardUI()
        KeyboardCapture = nil
        DisconnectConnections(KeyboardConnections)
        if KeyboardGui then
            KeyboardGui:Destroy()
            KeyboardGui = nil
        end
    end

    DisconnectConnections = function(tbl)
        for _, connection in pairs(tbl) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(tbl)
    end

    local function CreateSmallActionUI(kind)
        local isTrigger = (kind == "Trigger")
        local existing = isTrigger and TriggerGui or ManualSpamGui
        local connections = isTrigger and TriggerConnections or ManualSpamConnections

        if existing and existing.Parent then
            existing.Enabled = true
            return
        end

        local gui = Instance.new("ScreenGui")
        gui.Name = isTrigger and "NEXUS_TriggerUI" or "NEXUS_SpamUI"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = CoreGui

        if isTrigger then
            TriggerGui = gui
        else
            ManualSpamGui = gui
            _G.manualSpamEnabled = false
            _G.NEXUS = _G.NEXUS or {}
            _G.NEXUS.manualSpamEnabled = false
        end

        local Main = Instance.new("Frame")
        Main.Size = UDim2.fromOffset(180, 60)
        Main.Position = UDim2.new(0.5, -90, 0.5, -30)
        Main.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
        Main.BorderSizePixel = 0
        Main.Active = true
        Main.ZIndex = 999
        Main.Parent = gui

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 13)
        UICorner.Parent = Main

        local Stroke = Instance.new("UIStroke")
        Stroke.Thickness = 2
        Stroke.Color = Color3.fromRGB(255, 255, 255)
        Stroke.Transparency = 0.35
        Stroke.Parent = Main

        local Gradient = Instance.new("UIGradient")
        Gradient.Rotation = 90
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.3, Color3.fromRGB(170, 170, 170)),
            ColorSequenceKeypoint.new(0.7, Color3.fromRGB(60, 60, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
        })
        Gradient.Parent = Main

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = isTrigger and "TRIGGER" or "SPAM"
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 18
        Button.Font = Enum.Font.GothamBold
        Button.AutoButtonColor = false
        Button.ZIndex = 1000
        Button.Parent = Main

        local dragging = false
        local dragStart
        local startPos
        local dragThreshold = 6
        local dragInput = nil
        local dragCandidate = false

        local function isOnBorder(inputPosition)
            local absolutePosition = Main.AbsolutePosition
            local absoluteSize = Main.AbsoluteSize
            local x = inputPosition.X - absolutePosition.X
            local y = inputPosition.Y - absolutePosition.Y
            local border = 10
            return x >= 0 and x <= absoluteSize.X
                and y >= 0 and y <= absoluteSize.Y
                and (x <= border or x >= absoluteSize.X - border
                    or y <= border or y >= absoluteSize.Y - border)
        end

        if isTrigger then
            connections.button = Button.MouseButton1Click:Connect(function()
                local state = not System.__properties.__triggerbot_enabled
                System.__properties.__triggerbot_enabled = state
                System.triggerbot.enable(state)
                Button.Text = state and "OFF" or "TRIGGER"
                Notify("Trigger", state and "ON" or "OFF", 2)
            end)
        else
            connections.button = Button.MouseButton1Click:Connect(function()
                local state = not _G.manualSpamEnabled
                _G.manualSpamEnabled = state
                _G.NEXUS.manualSpamEnabled = state
                System.__properties.__manual_spam_enabled = state
                macroSpamActive = state
                if state then
                    System.manual_spam.start()
                    Button.Text = "OFF"
                    Notify("Manual Spam", "ON", 2)
                else
                    System.manual_spam.stop()
                    Button.Text = "SPAM"
                    Notify("Manual Spam", "OFF", 2)
                end
            end)
        end

        connections.inputBegan = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not isOnBorder(input.Position) then
                dragCandidate = false
                return
            end
            dragCandidate = true
            dragging = false
            dragInput = input
            dragStart = input.Position
            startPos = Main.Position
        end)

        connections.inputChanged = UserInputService.InputChanged:Connect(function(input)
            if not dragCandidate then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = input.Position - dragStart
            if not dragging then
                if math.abs(delta.X) < dragThreshold and math.abs(delta.Y) < dragThreshold then return end
                dragging = true
            end
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end)

        connections.inputEnded = UserInputService.InputEnded:Connect(function(input)
            if input == dragInput
                or input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                dragCandidate = false
                dragInput = nil
            end
        end)
    end


    local function CreateCurveUI()
        if CurveGui and CurveGui.Parent then
            CurveGui.Enabled = true
            return
        end

        local gui = Instance.new("ScreenGui")
        gui.Name = "NEXUS_CurveUI"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = CoreGui
        CurveGui = gui

        local Main = Instance.new("Frame")
        Main.Name = "CurveUI"
        Main.AnchorPoint = Vector2.new(0.5, 0)
        Main.Size = UDim2.fromOffset(118, 42)
        Main.Position = UDim2.new(0.5, 0, 0, 16)
        Main.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
        Main.BackgroundTransparency = 0.04
        Main.BorderSizePixel = 0
        Main.ClipsDescendants = true
        Main.Active = true
        Main.ZIndex = 2000
        Main.Parent = gui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 14)
        Corner.Parent = Main

        local Gradient = Instance.new("UIGradient")
        Gradient.Rotation = 0
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.48, Color3.fromRGB(155, 155, 155)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
        })
        Gradient.Parent = Main

        local Stroke = Instance.new("UIStroke")
        Stroke.Thickness = 1.5
        Stroke.Color = Color3.fromRGB(255, 255, 255)
        Stroke.Transparency = 0.3
        Stroke.Parent = Main

        local Header = Instance.new("TextButton")
        Header.Name = "Header"
        Header.Size = UDim2.new(1, -10, 0, 42)
        Header.Position = UDim2.fromOffset(5, 0)
        Header.BackgroundTransparency = 1
        Header.Text = tostring(Selected_Parry_Type or "Camera")
        Header.TextColor3 = Color3.fromRGB(255, 255, 255)
        Header.TextSize = 14
        Header.Font = Enum.Font.GothamBold
        Header.AutoButtonColor = false
        Header.ZIndex = 2002
        Header.Parent = Main

        local OptionsHolder = Instance.new("Frame")
        OptionsHolder.Name = "Options"
        OptionsHolder.Position = UDim2.fromOffset(8, 50)
        OptionsHolder.Size = UDim2.new(1, -16, 1, -58)
        OptionsHolder.BackgroundTransparency = 1
        OptionsHolder.Visible = false
        OptionsHolder.ZIndex = 2002
        OptionsHolder.Parent = Main

        local Grid = Instance.new("UIGridLayout")
        Grid.CellSize = UDim2.fromOffset(136, 29)
        Grid.CellPadding = UDim2.fromOffset(8, 5)
        Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Grid.VerticalAlignment = Enum.VerticalAlignment.Top
        Grid.Parent = OptionsHolder

        local expanded = false
        local current = Selected_Parry_Type or "Camera"
        local CLOSED_WIDTH = 118
        local OPEN_WIDTH = 296
        local OPEN_HEIGHT = 268

        local function setHeader()
            Header.Text = tostring(current)
        end

        local function closeUI()
            expanded = false
            OptionsHolder.Visible = false
            local heightTween = TweenService:Create(Main, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Size = UDim2.fromOffset(OPEN_WIDTH, 42)
            })
            heightTween:Play()
            heightTween.Completed:Wait()
            TweenService:Create(Main, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(CLOSED_WIDTH, 42)
            }):Play()
        end

        local function setSelected(value)
            current = value
            Selected_Parry_Type = value
            CurveType = value
            setHeader()
            closeUI()
        end

        for _, name in ipairs(CURVE_NAMES) do
            local Option = Instance.new("TextButton")
            Option.Name = name
            Option.Size = UDim2.fromOffset(136, 29)
            Option.BackgroundColor3 = Color3.fromRGB(115, 115, 115)
            Option.BackgroundTransparency = 0.18
            Option.BorderSizePixel = 0
            Option.Text = name
            Option.TextColor3 = Color3.fromRGB(255, 255, 255)
            Option.TextSize = 12
            Option.Font = Enum.Font.GothamSemibold
            Option.AutoButtonColor = false
            Option.ZIndex = 2003
            Option.Parent = OptionsHolder

            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 9)
            OptionCorner.Parent = Option

            local OptionGradient = Instance.new("UIGradient")
            OptionGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 235, 235)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 120, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
            })
            OptionGradient.Parent = Option

            CurveConnections["option_" .. name] = Option.MouseButton1Click:Connect(function()
                setSelected(name)
            end)
        end

        CurveConnections.selected = Header.MouseButton1Click:Connect(function()
            if expanded then
                closeUI()
                return
            end

            expanded = true
            Header.Text = tostring(current)
            TweenService:Create(Main, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(OPEN_WIDTH, 42)
            }):Play()

            task.wait(0.32)
            if not expanded then return end

            OptionsHolder.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(OPEN_WIDTH, OPEN_HEIGHT)
            }):Play()
        end)

        local dragging = false
        local dragStart
        local startPos
        local dragInput

        CurveConnections.inputBegan = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end

            local p = input.Position
            local pos = Main.AbsolutePosition
            local size = Main.AbsoluteSize
            if p.X < pos.X or p.X > pos.X + size.X or p.Y < pos.Y or p.Y > pos.Y + size.Y then
                return
            end

            if expanded and p.Y >= pos.Y + 45 then return end

            dragging = true
            dragInput = input
            dragStart = p
            startPos = Main.Position
        end)

        CurveConnections.inputChanged = UserInputService.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then return end

            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end)

        CurveConnections.inputEnded = UserInputService.InputEnded:Connect(function(input)
            if input == dragInput
                or input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                dragInput = nil
            end
        end)
    end

    local function DestroyCurveUI()
        DisconnectConnections(CurveConnections)
        if CurveGui then
            CurveGui:Destroy()
            CurveGui = nil
        end
    end

    local function CreateSpamUI()
        CreateSmallActionUI("Spam")
    end

    local function CreateTriggerUI()
        CreateSmallActionUI("Trigger")
    end

    local function DestroySpamUI()
        _G.manualSpamEnabled = false
        if _G.NEXUS then _G.NEXUS.manualSpamEnabled = false end
        System.__properties.__manual_spam_enabled = false
        macroSpamActive = false
        System.manual_spam.stop()
        DisconnectConnections(ManualSpamConnections)
        if ManualSpamGui then
            ManualSpamGui:Destroy()
            ManualSpamGui = nil
        end
    end

    local function DestroyTriggerUI()
        System.__properties.__triggerbot_enabled = false
        System.triggerbot.enable(false)
        DisconnectConnections(TriggerConnections)
        if TriggerGui then
            TriggerGui:Destroy()
            TriggerGui = nil
        end
    end


    local function CharacterBackendApply()
        if not getgenv().CharacterModifierEnabled then return end

        local char = LocalPlayer.Character
        if not char then return end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")

        if humanoid then
            if not getgenv().OriginalValues or getgenv().OriginalValues.Character ~= char then
                getgenv().OriginalValues = {
                    Character = char,
                    WalkSpeed = humanoid.WalkSpeed,
                    JumpPower = humanoid.JumpPower,
                    JumpHeight = humanoid.JumpHeight,
                    HipHeight = humanoid.HipHeight,
                    AutoRotate = humanoid.AutoRotate
                }
            end

            if getgenv().WalkspeedCheckboxEnabled then
                humanoid.WalkSpeed = tonumber(getgenv().CustomWalkSpeed) or 36
            end

            if getgenv().JumpPowerCheckboxEnabled then
                if humanoid.UseJumpPower then
                    humanoid.JumpPower = tonumber(getgenv().CustomJumpPower) or 50
                else
                    humanoid.JumpHeight = tonumber(getgenv().CustomJumpHeight) or 7.2
                end
            end

            if getgenv().HipHeightCheckboxEnabled then
                humanoid.HipHeight = tonumber(getgenv().CustomHipHeight) or 0
            end

            if getgenv().SpinbotCheckboxEnabled and root then
                humanoid.AutoRotate = false
                getgenv().spinAngle = ((getgenv().spinAngle or 0) + (tonumber(getgenv().CustomSpinSpeed) or 5)) % 360
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(getgenv().spinAngle), 0)
            elseif getgenv().OriginalValues.AutoRotate ~= nil then
                humanoid.AutoRotate = getgenv().OriginalValues.AutoRotate
            end
        end

        if getgenv().GravityCheckboxEnabled then
            workspace.Gravity = tonumber(getgenv().CustomGravity) or 196.2
        end
    end

    local function CharacterBackendRestore()
        local char = LocalPlayer.Character
        local original = getgenv().OriginalValues

        if char and original and original.Character == char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if original.WalkSpeed ~= nil then humanoid.WalkSpeed = original.WalkSpeed end
                if humanoid.UseJumpPower then
                    if original.JumpPower ~= nil then humanoid.JumpPower = original.JumpPower end
                elseif original.JumpHeight ~= nil then
                    humanoid.JumpHeight = original.JumpHeight
                end
                if original.HipHeight ~= nil then humanoid.HipHeight = original.HipHeight end
                if original.AutoRotate ~= nil then humanoid.AutoRotate = original.AutoRotate end
            end
        end

        workspace.Gravity = 196.2
    end

    local function CharacterBackendSetInfiniteJump(enabled)
        getgenv().InfiniteJumpCheckboxEnabled = enabled

        if enabled and getgenv().CharacterModifierEnabled then
            if not getgenv().InfiniteJumpConnection then
                getgenv().InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                    if not getgenv().CharacterModifierEnabled or not getgenv().InfiniteJumpCheckboxEnabled then return end
                    local char = LocalPlayer.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
        elseif getgenv().InfiniteJumpConnection then
            getgenv().InfiniteJumpConnection:Disconnect()
            getgenv().InfiniteJumpConnection = nil
        end
    end

    local function CharacterBackendSetEnabled(value)
        getgenv().CharacterModifierEnabled = value

        if value then
            getgenv().spinAngle = getgenv().spinAngle or 0

            if not getgenv().CharacterConnection then
                getgenv().CharacterConnection = RunService.Heartbeat:Connect(function()
                    pcall(CharacterBackendApply)
                end)
            end

            if not getgenv().CharacterAddedConnection then
                getgenv().CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(character)
                    task.spawn(function()
                        character:WaitForChild("Humanoid", 5)
                        character:WaitForChild("HumanoidRootPart", 5)
                        task.wait(0.1)
                        if getgenv().CharacterModifierEnabled then
                            getgenv().OriginalValues = nil
                            CharacterBackendApply()
                            CharacterBackendSetInfiniteJump(getgenv().InfiniteJumpCheckboxEnabled == true)
                        end
                    end)
                end)
            end

            CharacterBackendApply()
            CharacterBackendSetInfiniteJump(getgenv().InfiniteJumpCheckboxEnabled == true)
        else
            if getgenv().CharacterConnection then
                getgenv().CharacterConnection:Disconnect()
                getgenv().CharacterConnection = nil
            end

            if getgenv().CharacterAddedConnection then
                getgenv().CharacterAddedConnection:Disconnect()
                getgenv().CharacterAddedConnection = nil
            end

            if getgenv().InfiniteJumpConnection then
                getgenv().InfiniteJumpConnection:Disconnect()
                getgenv().InfiniteJumpConnection = nil
            end

            CharacterBackendRestore()
            getgenv().OriginalValues = nil
            getgenv().spinAngle = nil
        end
    end

    local animation_system = {
        storage = {},
        current = nil,
        track = nil
    }

    function animation_system.load_animations()
        local emotes_folder = game:GetService("ReplicatedStorage").Misc.Emotes

        for _, animation in pairs(emotes_folder:GetChildren()) do
            if animation:IsA("Animation") and animation:GetAttribute("EmoteName") then
                local emote_name = animation:GetAttribute("EmoteName")
                animation_system.storage[emote_name] = animation
            end
        end
    end

    function animation_system.get_emotes_list()
        local emotes_list = {}

        for emote_name in pairs(animation_system.storage) do
            table.insert(emotes_list, emote_name)
        end

        table.sort(emotes_list)
        return emotes_list
    end

    function animation_system.play(emote_name)
        local animation_data = animation_system.storage[emote_name]

        if not animation_data or not LocalPlayer.Character then
            return false
        end

        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if not humanoid then
            return false
        end

        local animator = humanoid:FindFirstChild("Animator")
        if not animator then
            return false
        end

        if animation_system.track then
            animation_system.track:Stop()
            animation_system.track:Destroy()
        end

        animation_system.track = animator:LoadAnimation(animation_data)
        animation_system.track:Play()
        animation_system.current = emote_name

        return true
    end

    function animation_system.stop()
        if animation_system.track then
            animation_system.track:Stop()
            animation_system.track:Destroy()
            animation_system.track = nil
        end
        animation_system.current = nil
    end

    function animation_system.start()
        if not System.__properties.__connections.animations then
            System.__properties.__connections.animations = RunService.Heartbeat:Connect(function()
                if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
                    return
                end

                local speed = LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity.Magnitude

                if speed > 30 and getgenv().AutoStop then
                    if animation_system.track and animation_system.track.IsPlaying then
                        animation_system.track:Stop()
                    end
                else
                    if animation_system.current and (not animation_system.track or not animation_system.track.IsPlaying) then
                        animation_system.play(animation_system.current)
                    end
                end
            end)
        end
    end

    function animation_system.cleanup()
        animation_system.stop()

        if System.__properties.__connections.animations then
            System.__properties.__connections.animations:Disconnect()
            System.__properties.__connections.animations = nil
        end
    end

    animation_system.load_animations()
    local emotes_data = animation_system.get_emotes_list()
    local selected

    --========================================================--
    -- NEXUS UI WIRING
    --========================================================--
    local detections = System.__config.__detections

    -- Auto Parry
    ParryTab:Section("Авто-парри")
    ParryTab:Toggle("Авто-парри", false, function(state)
        System.__properties.__autoparry_enabled = state
        System.__properties.__play_animation = state
        if state then System.autoparry.start() else System.autoparry.stop() end
    end)

    ParryTab:Selector("Режим парри", { { "Remote", "Remote" }, { "Keypress", "Keypress" } }, "Remote", function(v)
        getgenv().AutoParryMode = v
    end)

    local curveOptions = {}
    for _, name in ipairs(CURVE_NAMES) do
        curveOptions[#curveOptions + 1] = { name, name }
    end

    ParryTab:Selector("Тип кривой", curveOptions, Selected_Parry_Type, function(v)
        Selected_Parry_Type = v
        CurveType = v
    end)

    ParryTab:Slider("Точность", 1, 100, System.__properties.__accuracy, 1, function(v)
        System.__properties.__accuracy = v
        update_divisor()
    end)

    ParryTab:Toggle("Случайная точность", false, function(state)
        System.__properties.__randomized_accuracy_enabled = state
    end)

    ParryTab:Toggle("Авто-способность", false, function(state)
        getgenv().AutoAbility = state
    end)

    ParryTab:Section("Детекты")
    ParryTab:Toggle("Infinity", false, function(state)
        detections.__infinity = state
    end)
    ParryTab:Toggle("Death Slash", false, function(state)
        detections.__deathslash = state
    end)
    ParryTab:Toggle("Time Hole", false, function(state)
        detections.__timehole = state
    end)
    ParryTab:Toggle("Slashes of Fury", false, function(state)
        detections.__slashesoffury = state
    end)
    ParryTab:Toggle("Phantom", false, function(state)
        detections.__phantom = state
    end)

    -- Spam / Trigger
    SpamTab:Section("Авто-спам")
    SpamTab:Toggle("Авто-спам", false, function(state)
        System.__properties.__auto_spam_enabled = state
        if state then System.auto_spam.start() else System.auto_spam.stop() end
    end)

    SpamTab:Selector("Режим авто-спама", { { "Remote", "Remote" }, { "Keypress", "Keypress" } }, "Remote", function(v)
        getgenv().AutoSpamMode = v
    end)

    SpamTab:Toggle("Фикс анимации (авто)", false, function(state)
        getgenv().AutoSpamAnimationFix = state
    end)

    SpamTab:Section("Мануальный спам")
    SpamTab:Toggle("Мануальный спам", false, function(state)
        _G.manualSpamEnabled = state
        _G.NEXUS = _G.NEXUS or {}
        _G.NEXUS.manualSpamEnabled = state
        System.__properties.__manual_spam_enabled = state
        macroSpamActive = state
        if state then System.manual_spam.start() else System.manual_spam.stop() end
    end)

    SpamTab:Selector("Режим мануал-спама", { { "Remote", "Remote" }, { "Keypress", "Keypress" } }, "Remote", function(v)
        getgenv().ManualSpamMode = v
    end)

    SpamTab:Toggle("Фикс анимации (мануал)", false, function(state)
        getgenv().ManualSpamAnimationFix = state
    end)

    SpamTab:Section("Триггербот")
    SpamTab:Toggle("Триггербот", false, function(state)
        System.__properties.__triggerbot_enabled = state
        System.triggerbot.enable(state)
    end)

    -- Helper windows
    WindowsTab:Section("Окна")
    WindowsTab:Toggle("Клавиатура", false, function(state)
        if state then CreateKeyboardUI() else DestroyKeyboardUI() end
    end)
    WindowsTab:Toggle("Кривая", false, function(state)
        if state then CreateCurveUI() else DestroyCurveUI() end
    end)
    WindowsTab:Toggle("Спам", false, function(state)
        if state then CreateSpamUI() else DestroySpamUI() end
    end)
    WindowsTab:Toggle("Триггер", false, function(state)
        if state then CreateTriggerUI() else DestroyTriggerUI() end
    end)

    -- Character
    CharTab:Section("Персонаж")
    CharTab:Toggle("Модификатор персонажа", false, function(state)
        CharacterBackendSetEnabled(state)
    end)

    CharTab:Toggle("Скорость ходьбы", false, function(state)
        getgenv().WalkspeedCheckboxEnabled = state
    end)
    CharTab:Slider("Значение скорости", 0, 200, 36, 1, function(v)
        getgenv().CustomWalkSpeed = v
    end)

    CharTab:Toggle("Сила прыжка", false, function(state)
        getgenv().JumpPowerCheckboxEnabled = state
    end)
    CharTab:Slider("Значение прыжка", 0, 300, 50, 1, function(v)
        getgenv().CustomJumpPower = v
    end)
    CharTab:Slider("Высота прыжка", 0, 50, 7.2, 0.1, function(v)
        getgenv().CustomJumpHeight = v
    end)

    CharTab:Toggle("Высота бёдер", false, function(state)
        getgenv().HipHeightCheckboxEnabled = state
    end)
    CharTab:Slider("Значение высоты", 0, 50, 0, 0.5, function(v)
        getgenv().CustomHipHeight = v
    end)

    CharTab:Toggle("Спинбот", false, function(state)
        getgenv().SpinbotCheckboxEnabled = state
    end)
    CharTab:Slider("Скорость вращения", 1, 50, 5, 1, function(v)
        getgenv().CustomSpinSpeed = v
    end)

    CharTab:Toggle("Гравитация", false, function(state)
        getgenv().GravityCheckboxEnabled = state
    end)
    CharTab:Slider("Значение гравитации", 0, 400, 196.2, 1, function(v)
        getgenv().CustomGravity = v
    end)

    CharTab:Toggle("Бесконечный прыжок", false, function(state)
        CharacterBackendSetInfiniteJump(state)
    end)

    -- Emotes
    local selectedEmote = emotes_data[1]

    EmoteTab:Section("Эмоции")
    if #emotes_data > 0 then
        local emoteOptions = {}
        for _, name in ipairs(emotes_data) do
            emoteOptions[#emoteOptions + 1] = { name, name }
        end

        EmoteTab:Selector("Эмоция", emoteOptions, selectedEmote, function(v)
            selectedEmote = v
        end)
    else
        EmoteTab:Label("Эмоции не найдены.")
    end

    EmoteTab:Button("Играть", Color3.fromRGB(40, 170, 100), function()
        if selectedEmote and animation_system.play(selectedEmote) then
            animation_system.start()
        end
    end)
    EmoteTab:Button("Стоп", Color3.fromRGB(150, 50, 50), function()
        animation_system.stop()
    end)
    EmoteTab:Toggle("Стоп при беге", false, function(state)
        getgenv().AutoStop = state
    end)

    -- Cleanup on unload
    OnUnload(function()
        System.__properties.__autoparry_enabled = false
        System.autoparry.stop()
        System.auto_spam.stop()
        System.triggerbot.enable(false)
        DestroySpamUI()
        DestroyTriggerUI()
        DestroyKeyboardUI()
        DestroyCurveUI()
        animation_system.cleanup()
        if getgenv().CharacterModifierEnabled then
            CharacterBackendSetEnabled(false)
        end
    end)
end)

local Settings = CreateTab("Настройки")
Settings:Section("Вид меню")

Settings:Slider("Непрозрачность меню", 0.3, 1, Opacity, 0.05, function(v)
    Opacity = v
    ApplyGlass()
end)

Settings:Slider("Размер меню", 0.6, 1.4, startScale, 0.05, function(v)
    UIScaleObj.Scale = v
end)

Settings:ColorPicker("Акцентный цвет", Theme.Accent, function(c)
    SetAccent(c)
end)

local AccentPresets = {
    { "Default", Color3.fromRGB(119, 120, 255) },
    { "Amber", Color3.fromRGB(255, 140, 50) },
    { "Azure", Color3.fromRGB(60, 150, 255) },
    { "Violet", Color3.fromRGB(180, 80, 255) },
}

Settings:Selector("Пресет акцента", AccentPresets, AccentPresets[1][2], function(c)
    SetAccent(c)
end)

Settings:Toggle("Размытие фона", NX.Blur, function(v)
    NX.Blur = v
    Tween(BlurFx, {
        Size = (Main.Visible and v) and 14 or 0
    }, 0.2)
end)

Settings:Section("Управление")

local MenuKey, Listening = Enum.KeyCode.RightShift, false

local keyBtn = Settings:Button("Клавиша меню: " .. MenuKey.Name, nil, function()
    Listening = true
    keyBtn.Text = "Нажмите любую клавишу..."
end)

Settings:Button("Выгрузить скрипт", Color3.fromRGB(150, 50, 50), function()
    if Unload then
        Unload()
    end
end)

Track(UserInputService.InputBegan:Connect(function(input, processed)
    if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
        Listening = false
        MenuKey = input.KeyCode
        keyBtn.Text = "Клавиша меню: " .. MenuKey.Name
        return
    end

    if not processed
        and input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode == MenuKey then
        if Main.Visible then
            Main.Visible = false
            Mini.Visible = false
        else
            ShowMain()
        end
    end
end))

SelectTab(Tabs[1])

Unload = function()
    for _, fn in ipairs(Cleanups) do
        pcall(fn)
    end

    for _, c in ipairs(Connections) do
        pcall(function()
            c:Disconnect()
        end)
    end

    table.clear(Connections)

    pcall(function()
        MenuGui:Destroy()
    end)

    Env.__NEXUS_UI_UNLOAD = nil
end

Env.__NEXUS_UI_UNLOAD = Unload

ShowMain()
