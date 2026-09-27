-- Rise Ultimate v4 - Radio Ultimate + Scripts + ServerSaver, one shell, 3 tabs on top.
-- v4: complete GUI reskin - "glass" look (blurred backdrop, semi-transparent
-- panels, pill controls, icon tab rail) inspired by modern Roblox UI-kit
-- conventions. All data/logic is unchanged from v3 - only the visual layer
-- was rebuilt, so existing saved songs/tabs/servers/scripts/colors carry over.
print("[RiseUltimate] starting...")

_G.__RiseUltimateFirstShow = nil

local ok, err = pcall(function()

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local MPS = game:GetService("MarketplaceService")
local AssetService = game:GetService("AssetService")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

-- v4: shared blur effect used behind the menu for the "frosted glass" look.
-- Reused instead of recreated so re-running the script never stacks blurs.
local menuBlur = Lighting:FindFirstChild("RiseMenuBlur")
if not menuBlur then
  menuBlur = Instance.new("BlurEffect")
  menuBlur.Name = "RiseMenuBlur"
  menuBlur.Size = 0
  menuBlur.Parent = Lighting
end

local Inventory, PlaySong, SaveSong
pcall(function()
  Inventory = RS:WaitForChild("Remotes", 5)
  if Inventory then
    Inventory = Inventory:WaitForChild("Inventory", 5)
    if Inventory then
      PlaySong = Inventory:FindFirstChild("PlaySong")
      SaveSong = Inventory:FindFirstChild("SaveSong")
    end
  end
end)

local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end

local TH = {
  {"Amber",    rgb(15,10,8),  rgb(28,20,15), rgb(42,30,22), rgb(255,140,50), rgb(200,100,30), rgb(255,240,220), rgb(180,150,120), rgb(60,40,25), rgb(120,60,20), rgb(255,140,50)},
  {"Azure",    rgb(8,12,20),  rgb(15,25,45), rgb(25,40,70), rgb(60,150,255), rgb(40,100,200), rgb(220,235,255), rgb(130,160,200), rgb(30,50,90), rgb(30,70,140), rgb(60,150,255)},
  {"Violet",   rgb(12,8,18),  rgb(25,18,40), rgb(40,28,65), rgb(180,80,255), rgb(130,50,200), rgb(245,230,255), rgb(160,130,190), rgb(50,35,80), rgb(80,40,130), rgb(180,80,255)},
  {"Jade",     rgb(8,15,12),  rgb(18,32,28), rgb(28,50,42), rgb(80,220,160), rgb(50,180,120), rgb(230,255,245), rgb(140,190,170), rgb(35,60,50), rgb(40,100,80), rgb(80,220,160)},
  {"Crimson",  rgb(18,8,10),  rgb(35,15,20), rgb(55,25,32), rgb(255,70,90), rgb(200,45,65), rgb(255,230,235), rgb(200,140,150), rgb(70,30,40), rgb(130,30,45), rgb(255,70,90)},
  {"Graphite", rgb(8,8,12),   rgb(18,18,28), rgb(28,28,42), rgb(255,200,80), rgb(200,160,50), rgb(255,250,230), rgb(180,170,140), rgb(40,40,55), rgb(100,80,30), rgb(255,200,80)},
  {"Onyx",     rgb(10,10,10), rgb(20,20,20), rgb(30,30,30), rgb(225,225,225), rgb(160,160,160), rgb(245,245,245), rgb(150,150,150), rgb(55,55,55), rgb(170,60,60), rgb(200,200,200)},
  {"Pine",     rgb(8,14,10),  rgb(16,26,18), rgb(24,38,26), rgb(90,200,110), rgb(60,150,80), rgb(230,245,230), rgb(150,180,150), rgb(35,55,38), rgb(150,60,40), rgb(90,200,110)},
  {"Blush",    rgb(18,10,14), rgb(32,18,26), rgb(46,26,36), rgb(255,110,170), rgb(210,70,130), rgb(255,230,240), rgb(190,150,170), rgb(60,35,48), rgb(200,60,80), rgb(255,110,170)},
  {"Frost",    rgb(235,242,245), rgb(255,255,255), rgb(225,235,240), rgb(40,140,200), rgb(80,170,220), rgb(20,30,35), rgb(90,110,120), rgb(200,215,222), rgb(210,70,70), rgb(40,140,200)},
  {"Garnet",   rgb(14,6,6),   rgb(26,10,10), rgb(38,14,14), rgb(210,40,40), rgb(160,30,30), rgb(250,225,225), rgb(190,140,140), rgb(55,20,20), rgb(230,140,30), rgb(210,40,40)},
  {"Aurora",   rgb(8,16,14),  rgb(16,30,26), rgb(24,42,38), rgb(90,225,190), rgb(60,170,150), rgb(230,250,245), rgb(150,195,180), rgb(30,55,48), rgb(150,90,220), rgb(90,225,190),
    {rgb(8,20,18), rgb(14,32,45), rgb(24,20,50), rgb(10,14,25)}},
  {"Synthwave",rgb(14,6,20),  rgb(28,12,42), rgb(38,16,55), rgb(255,60,180), rgb(190,50,230), rgb(255,225,250), rgb(200,150,210), rgb(45,20,55), rgb(60,220,230), rgb(255,60,180),
    {rgb(20,6,30), rgb(45,10,55), rgb(15,15,60), rgb(8,30,45)}},
  {"Galaxy",   rgb(6,6,14),   rgb(14,10,28), rgb(22,16,40), rgb(150,120,255), rgb(100,80,210), rgb(230,225,255), rgb(160,155,200), rgb(35,30,60), rgb(255,90,150), rgb(150,120,255),
    {rgb(4,4,12), rgb(16,8,32), rgb(28,12,45), rgb(8,16,36)}},
  {"Toxic",    rgb(8,12,4),   rgb(18,26,8), rgb(28,38,10), rgb(180,235,40), rgb(130,180,30), rgb(240,250,220), rgb(170,190,120), rgb(40,50,15), rgb(255,80,60), rgb(180,235,40),
    {rgb(8,14,4), rgb(20,32,8), rgb(30,40,6), rgb(12,20,5)}},
  {"Ember",    rgb(12,5,3),   rgb(28,10,5), rgb(45,17,6), rgb(255,130,40), rgb(220,80,20), rgb(255,235,220), rgb(210,150,110), rgb(50,20,10), rgb(255,60,60), rgb(255,130,40),
    {rgb(10,4,3), rgb(32,10,4), rgb(50,20,6), rgb(20,6,4)}},
}

local CFG = {
  theme = 1, corner = 10, lang = "all", searchEng = "catalog",
  showOriginal = false, useEmoji = false, activeApp = "radio", autoImport = false,
  font = 1, textScale = 2, lang2 = "ru", menuOpacity = 0.86,
  useCustomColors = false, customColors = {}, useBlur = true,
}

local FONT_OPTIONS = {
  {"Gotham", Enum.Font.GothamBold, Enum.Font.GothamMedium},
  {"SourceSans", Enum.Font.SourceSansBold, Enum.Font.SourceSans},
  {"Bangers", Enum.Font.Bangers, Enum.Font.Bangers},
  {"Code", Enum.Font.Code, Enum.Font.Code},
  {"Fondamento", Enum.Font.Fondamento, Enum.Font.Fondamento},
}
local SCALE_OPTIONS = {0.85, 1.0, 1.15, 1.35}
local SCALE_LABELS = {"S", "M", "L", "XL"}

-- ===== custom color / background system (unchanged since v3) =====
local BG_PRESETS = {
  {name="\u{41F}\u{43E}\u{43B}\u{43D}\u{43E}\u{447}\u{44C}", stops={rgb(10,10,20), rgb(20,20,45), rgb(15,15,35)}},
  {name="\u{417}\u{430}\u{43A}\u{430}\u{442}",   stops={rgb(40,15,10), rgb(90,35,15), rgb(140,60,20)}},
  {name="\u{41E}\u{43A}\u{435}\u{430}\u{43D}",   stops={rgb(5,20,25),  rgb(10,40,55), rgb(15,60,80)}},
  {name="\u{41D}\u{435}\u{43E}\u{43D}",    stops={rgb(15,5,25),  rgb(60,10,70), rgb(10,50,70)}},
  {name="\u{41B}\u{435}\u{441}",     stops={rgb(8,18,10),  rgb(15,35,18), rgb(20,45,22)}},
  {name="\u{41C}\u{430}\u{433}\u{43C}\u{430}",   stops={rgb(15,5,5),   rgb(45,10,8),  rgb(80,20,10)}},
  {name="\u{41A}\u{43E}\u{441}\u{43C}\u{43E}\u{441}",  stops={rgb(5,5,12),   rgb(15,10,30), rgb(30,15,50)}},
  {name="\u{41C}\u{44F}\u{442}\u{430}",    stops={rgb(10,20,18), rgb(20,45,38), rgb(30,60,50)}},
  {name="\u{420}\u{43E}\u{437}\u{430}",    stops={rgb(25,10,16), rgb(55,20,32), rgb(80,30,45)}},
  {name="\u{423}\u{433}\u{43E}\u{43B}\u{44C}",   stops={rgb(12,12,12), rgb(24,24,24), rgb(34,34,34)}},
}

local function hexToColor3(hex)
  if type(hex) ~= "string" then return nil end
  hex = hex:gsub("#",""):gsub("%s+","")
  if #hex == 3 then
    local a,b,c = hex:sub(1,1), hex:sub(2,2), hex:sub(3,3)
    hex = a..a..b..b..c..c
  end
  if not hex:match("^%x%x%x%x%x%x$") then return nil end
  return Color3.fromRGB(tonumber(hex:sub(1,2),16), tonumber(hex:sub(3,4),16), tonumber(hex:sub(5,6),16))
end
local function color3ToHex(c)
  if not c then return "FFFFFF" end
  return string.format("%02X%02X%02X", math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))
end
local function lighten(c, amt)
  return Color3.new(math.clamp(c.R+amt,0,1), math.clamp(c.G+amt,0,1), math.clamp(c.B+amt,0,1))
end
local function blend(c1, c2, t)
  return Color3.new(c1.R+(c2.R-c1.R)*t, c1.G+(c2.G-c1.G)*t, c1.B+(c2.B-c1.B)*t)
end

local function getActiveColors()
  local THEME = TH[CFG.theme] or TH[1]
  local BG,PAN,PANA,AC,ACS,TX,TXM,BD,ST,DOT,GRAD =
    THEME[2],THEME[3],THEME[4],THEME[5],THEME[6],THEME[7],THEME[8],THEME[9],THEME[10],THEME[11],THEME[12]
  local cc = CFG.customColors
  if CFG.useCustomColors and cc then
    if cc.bg then BG = hexToColor3(cc.bg) or BG; BD = lighten(BG, 0.09) end
    if cc.panel then PAN = hexToColor3(cc.panel) or PAN; PANA = lighten(PAN, 0.06) end
    if cc.accent then AC = hexToColor3(cc.accent) or AC; ACS = AC end
    if cc.text then TX = hexToColor3(cc.text) or TX; TXM = blend(TX, BG, 0.55) end
  end
  if CFG.bgPreset and BG_PRESETS[CFG.bgPreset] then
    GRAD = BG_PRESETS[CFG.bgPreset].stops
  end
  return BG,PAN,PANA,AC,ACS,TX,TXM,BD,ST,DOT,GRAD
end

local STR = {
  ru = {
    radio="\u{420}\u{430}\u{434}\u{438}\u{43E}", scripts="\u{421}\u{43A}\u{440}\u{438}\u{43F}\u{442}\u{44B}", servers="\u{421}\u{435}\u{440}\u{432}\u{435}\u{440}\u{44B}",
    songs="\u{442}\u{440}\u{435}\u{43A}\u{438}", search="\u{43F}\u{43E}\u{438}\u{441}\u{43A}", import="\u{438}\u{43C}\u{43F}\u{43E}\u{440}\u{442}", settings="\u{43D}\u{430}\u{441}\u{442}\u{440}\u{43E}\u{439}\u{43A}\u{438}",
    themeLabel="\u{426}\u{432}\u{435}\u{442}\u{43E}\u{432}\u{430}\u{44F} \u{442}\u{435}\u{43C}\u{430}", fontLabel="\u{428}\u{440}\u{438}\u{444}\u{442}", sizeLabel="\u{420}\u{430}\u{437}\u{43C}\u{435}\u{440} \u{442}\u{435}\u{43A}\u{441}\u{442}\u{430}",
    langLabel="\u{42F}\u{437}\u{44B}\u{43A}", useEmoji="\u{418}\u{43A}\u{43E}\u{43D}\u{43A}\u{438}-\u{44D}\u{43C}\u{43E}\u{434}\u{437}\u{438}", showOriginal="\u{41F}\u{43E}\u{43A}\u{430}\u{437}\u{44B}\u{432}\u{430}\u{442}\u{44C} \u{438}\u{43C}\u{435}\u{43D}\u{430} Roblox",
    autoImport="\u{410}\u{432}\u{442}\u{43E}-\u{438}\u{43C}\u{43F}\u{43E}\u{440}\u{442} \u{43F}\u{440}\u{438} \u{437}\u{430}\u{43F}\u{443}\u{441}\u{43A}\u{435}", roundedCorners="\u{421}\u{43A}\u{440}\u{443}\u{433}\u{43B}\u{451}\u{43D}\u{43D}\u{44B}\u{435} \u{443}\u{433}\u{43B}\u{44B}",
    fixScroll="\u{418}\u{441}\u{43F}\u{440}\u{430}\u{432}\u{438}\u{442}\u{44C} \u{441}\u{43A}\u{440}\u{43E}\u{43B}\u{43B} \u{433}\u{435}\u{439}\u{43C}\u{43F}\u{430}\u{441}\u{441}\u{430}", exportAll="\u{42D}\u{43A}\u{441}\u{43F}\u{43E}\u{440}\u{442} \u{432}\u{441}\u{435}\u{445} \u{432} \u{433}\u{435}\u{439}\u{43C}\u{43F}\u{430}\u{441}\u{441}",
    brokenHdr="\u{41D}\u{435}\u{440}\u{430}\u{431}\u{43E}\u{447}\u{438}\u{435} \u{442}\u{440}\u{435}\u{43A}\u{438}", brokenScan="\u{421}\u{43A}\u{430}\u{43D}\u{438}\u{440}\u{43E}\u{432}\u{430}\u{442}\u{44C} \u{431}\u{438}\u{431}\u{43B}\u{438}\u{43E}\u{442}\u{435}\u{43A}\u{443}",
    brokenNone="\u{41D}\u{435}\u{440}\u{430}\u{431}\u{43E}\u{447}\u{438}\u{445} \u{442}\u{440}\u{435}\u{43A}\u{43E}\u{432} \u{43D}\u{435} \u{43D}\u{430}\u{439}\u{434}\u{435}\u{43D}\u{43E}", brokenNotScanned="\u{415}\u{449}\u{451} \u{43D}\u{435} \u{441}\u{43A}\u{430}\u{43D}\u{438}\u{440}\u{43E}\u{432}\u{430}\u{43B}\u{43E}\u{441}\u{44C}",
    addServer="+ \u{414}\u{43E}\u{431}\u{430}\u{432}\u{438}\u{442}\u{44C} \u{442}\u{435}\u{43A}\u{443}\u{449}\u{438}\u{439} \u{441}\u{435}\u{440}\u{432}\u{435}\u{440}", addScript="+ \u{414}\u{43E}\u{431}\u{430}\u{432}\u{438}\u{442}\u{44C} \u{441}\u{43A}\u{440}\u{438}\u{43F}\u{442}",
    delConfirm="\u{423}\u{434}\u{430}\u{43B}\u{438}\u{442}\u{44C}?", delSongConfirm="\u{423}\u{434}\u{430}\u{43B}\u{438}\u{442}\u{44C} \u{442}\u{440}\u{435}\u{43A}?", delServerConfirm="\u{423}\u{434}\u{430}\u{43B}\u{438}\u{442}\u{44C} \u{441}\u{435}\u{440}\u{432}\u{435}\u{440}?",
    opacityLabel="\u{41F}\u{440}\u{43E}\u{437}\u{440}\u{430}\u{447}\u{43D}\u{43E}\u{441}\u{442}\u{44C} \u{43C}\u{435}\u{43D}\u{44E}",
    customStyleHdr="\u{421}\u{432}\u{43E}\u{439} \u{441}\u{442}\u{438}\u{43B}\u{44C}",
    useCustomColorsLabel="\u{421}\u{432}\u{43E}\u{438} \u{446}\u{432}\u{435}\u{442}\u{430}",
    accentLabel="\u{410}\u{43A}\u{446}\u{435}\u{43D}\u{442}",
    bgColorLabel="\u{426}\u{432}\u{435}\u{442} \u{444}\u{43E}\u{43D}\u{430}",
    panelLabel="\u{41F}\u{430}\u{43D}\u{435}\u{43B}\u{44C}",
    textColorLabel="\u{422}\u{435}\u{43A}\u{441}\u{442}",
    bgPresetLabel="\u{413}\u{440}\u{430}\u{434}\u{438}\u{435}\u{43D}\u{442} \u{444}\u{43E}\u{43D}\u{430}",
    bgPresetDefault="\u{41F}\u{43E} \u{442}\u{435}\u{43C}\u{435}",
    resetColorsLabel="\u{421}\u{431}\u{440}\u{43E}\u{441}\u{438}\u{442}\u{44C} \u{446}\u{432}\u{435}\u{442}\u{430}",
    useBlurLabel="\u{420}\u{430}\u{437}\u{43C}\u{44B}\u{442}\u{438}\u{435} \u{444}\u{43E}\u{43D}\u{430} (\u{431}\u{43B}\u{451}\u{440})",
  },
  en = {
    radio="Radio", scripts="Scripts", servers="Servers",
    songs="songs", search="search", import="import", settings="settings",
    themeLabel="Color Theme", fontLabel="Font", sizeLabel="Text Size",
    langLabel="Language", useEmoji="Emoji icons", showOriginal="Show Roblox names",
    autoImport="Auto-import on load", roundedCorners="Rounded corners",
    fixScroll="Fix gamepass scroll", exportAll="Export all to gamepass",
    brokenHdr="Broken tracks", brokenScan="Scan library",
    brokenNone="No broken tracks found", brokenNotScanned="Not scanned yet",
    addServer="+ Add current server", addScript="+ Add script",
    delConfirm="Delete?", delSongConfirm="Delete track?", delServerConfirm="Delete server?",
    opacityLabel="Menu opacity",
    customStyleHdr="Custom style",
    useCustomColorsLabel="Custom colors",
    accentLabel="Accent",
    bgColorLabel="Background color",
    panelLabel="Panel",
    textColorLabel="Text",
    bgPresetLabel="Background gradient",
    bgPresetDefault="Theme default",
    resetColorsLabel="Reset colors",
    useBlurLabel="Blur behind menu",
  },
}
local function T(key) return (STR[CFG.lang2] and STR[CFG.lang2][key]) or STR.en[key] or key end

local searchQuery = ""
local Songs = {}
local Tabs = {}
local TabMeta = {
  {id="all", label="all", builtin=true},
  {id="new", label="new", builtin=true},
  {id="phonk", label="phonk", builtin=false},
  {id="ru", label="ru", builtin=false},
  {id="en", label="en", builtin=false},
  {id="gazan", label="gazan", builtin=false},
  {id="molli", label="molli", builtin=false},
  {id="memes", label="memes", builtin=false},
  {id="short", label="short", builtin=false},
  {id="other", label="other", builtin=false},
}

local SEED = {
  {"114276461896688", "\u{444}\u{43E}\u{43D}\u{43A}", "phonk", "ru", "\u{444}\u{43E}\u{43D}\u{43A}"},
  {"117499298661785", "\u{444}\u{43E}\u{43D}\u{43A} 2", "phonk", "ru", "\u{444}\u{43E}\u{43D}\u{43A} 2"},
  {"121242462527636", "\u{43F}\u{440}\u{438}\u{43A}\u{43E}\u{43B}\u{44C}\u{43D}\u{44B}\u{439} \u{444}\u{43E}\u{43D}\u{43A}", "phonk", "ru", "\u{43F}\u{440}\u{438}\u{43A}\u{43E}\u{43B}\u{44C}\u{43D}\u{44B}\u{439} \u{444}\u{43E}\u{43D}\u{43A}"},
  {"91668250502992", "\u{43C}\u{43E}\u{440}\u{433}\u{435}\u{43D} \u{43C}\u{44B} \u{441} \u{442}\u{43E}\u{431}\u{43E}\u{439} \u{434}\u{435}\u{442}\u{438} 90", "ru", "ru", "\u{43C}\u{43E}\u{440}\u{433}\u{435}\u{43D} \u{43C}\u{44B} \u{441} \u{442}\u{43E}\u{431}\u{43E}\u{439} \u{434}\u{435}\u{442}\u{438} 90"},
  {"93602974995833", "18 \u{43C}\u{43D}\u{435} \u{443}\u{436}\u{435}", "ru", "ru", "18 \u{43C}\u{43D}\u{435} \u{443}\u{436}\u{435}"},
  {"131245885742260", "t.a.t.u \u{43D}\u{430}\u{441} \u{43D}\u{435} \u{434}\u{43E}\u{433}\u{43E}\u{43D}\u{44F}\u{442}", "ru", "ru", "Nas Ne Dogonyat"},
  {"74865649597403", "\u{420}\u{410}\u{428}\u{410} \u{420}\u{410}\u{428}\u{410}", "ru", "ru", "\u{420}\u{410}\u{428}\u{410} \u{420}\u{410}\u{428}\u{410}"},
  {"128291940309861", "\u{447}\u{443}\u{434}\u{43D}\u{43E}\u{439}", "ru", "ru", "\u{447}\u{443}\u{434}\u{43D}\u{43E}\u{439}"},
  {"129898761032889", "\u{440}\u{43E}\u{437}\u{43E}\u{432}\u{43E}\u{435} \u{432}\u{438}\u{43D}\u{43E}", "ru", "ru", "\u{420}\u{43E}\u{437}\u{43E}\u{432}\u{43E}\u{435} \u{432}\u{438}\u{43D}\u{43E}"},
  {"139344691622468", "Buzova \u{2014} \u{44F} \u{445}\u{43E}\u{447}\u{443}", "ru", "ru", "Buzova \u{2014} \u{44F} \u{445}\u{43E}\u{447}\u{443}"},
  {"91007045451630", "under your spell", "en", "en", "Under Your Spell"},
  {"88523902860927", "unhappy", "en", "en", "Unhappy"},
  {"82238396227577", "slaughter house", "en", "en", "slaughter house"},
  {"76776089178278", "\u{413}\u{430}\u{437}\u{430}\u{43D} \u{442}\u{44F}\u{433}\u{438}", "gazan", "ru", "\u{413}\u{430}\u{437}\u{430}\u{43D} \u{442}\u{44F}\u{433}\u{438}"},
  {"94521112852370", "\u{43F}\u{43E}\u{448}\u{43B}\u{430}\u{44F} \u{43C}\u{43E}\u{43B}\u{43B}\u{438}", "molli", "ru", "\u{43F}\u{43E}\u{448}\u{43B}\u{430}\u{44F} \u{43C}\u{43E}\u{43B}\u{43B}\u{438}"},
  {"121239777513594", "\u{43F}\u{440}\u{438}\u{43A}\u{43E}\u{43B}", "memes", "ru", "\u{43F}\u{440}\u{438}\u{43A}\u{43E}\u{43B}"},
  {"83712066133001", "cachalot", "short", "en", "Cachalot"},
  {"79359688008346", "\u{445}\u{437} \u{43D}\u{430}\u{437}\u{432}\u{430}\u{43D}\u{438}\u{435}", "other", "ru", "\u{445}\u{437} \u{43D}\u{430}\u{437}\u{432}\u{430}\u{43D}\u{438}\u{435}"},
}
for _,s in ipairs(SEED) do
  Songs[s[1]] = {id=s[1], name=s[2], cat=s[3], lang=s[4], robloxName=s[5] or s[2], imported=false}
  Tabs[s[3]] = Tabs[s[3]] or {}
  table.insert(Tabs[s[3]], s[1])
  Tabs["new"] = Tabs["new"] or {}
  table.insert(Tabs["new"], s[1])
end

local function rebuildAll()
  Tabs.all = {}
  for id,_ in pairs(Songs) do table.insert(Tabs.all, id) end
end
rebuildAll()

local SAVE = "MM2Radio_v11.json"
local function saveConfig()
  pcall(function()
    if writefile then
      writefile(SAVE, HttpService:JSONEncode({cfg=CFG, songs=Songs, tabs=Tabs, tabMeta=TabMeta}))
    end
  end)
end
pcall(function()
  if isfile and readfile and isfile(SAVE) then
    local d = HttpService:JSONDecode(readfile(SAVE))
    if d.cfg then for k,v in pairs(d.cfg) do CFG[k]=v end end
    if d.songs then Songs = d.songs end
    if d.tabs then Tabs = d.tabs end
    if d.tabMeta then TabMeta = d.tabMeta end
    rebuildAll()
  end
end)
if CFG.searchEng == "internal" then CFG.searchEng = "catalog" end

local prv = Instance.new("Sound")
prv.Name = "RadioPreview"; prv.Volume = 0.5; prv.Parent = SoundService

local function idToUrl(id) return "https://www.roblox.com/asset/?id="..tostring(id) end
local function radioPlay(id) pcall(function() if PlaySong then PlaySong:FireServer(idToUrl(id)) end end) end
local function radioStop() pcall(function() if PlaySong then PlaySong:FireServer("") end end) prv:Stop() end
local function prvPlay(id) prv.SoundId = "rbxassetid://"..tostring(id); prv:Play() end

local nameCache = {}
local function robloxNameFor(id)
  if nameCache[id] then return nameCache[id] end
  local ok2, info = pcall(function() return MPS:GetProductInfo(tonumber(id), Enum.InfoType.Asset) end)
  if ok2 and info and info.Name then
    nameCache[id] = info.Name
    if Songs[id] then Songs[id].robloxName = info.Name; saveConfig() end
    return info.Name
  end
  return nil
end

local function trySaveSong(id, name)
  if not SaveSong then
    local invOk, inv = pcall(function() return RS:WaitForChild("Remotes",3):WaitForChild("Inventory",3) end)
    if invOk and inv then SaveSong = inv:FindFirstChild("SaveSong") or SaveSong end
  end
  if not SaveSong then return false end
  local fireOk = pcall(function() SaveSong:FireServer(idToUrl(id), name) end)
  return fireOk
end

local function ensureSong(id, customName, lang, imported, tabId)
  if not Songs[id] then
    Songs[id] = {
      id=id, name=customName or ("song "..id), robloxName=customName or ("song "..id),
      lang=lang or "ru", imported=imported or false, cat=tabId or "other"
    }
    task.spawn(function()
      local rn = robloxNameFor(id)
      if rn and Songs[id] then
        Songs[id].robloxName = rn
        if Songs[id].name == "song "..id then Songs[id].name = rn end
        saveConfig()
      end
    end)
  end
  if tabId then
    Tabs[tabId] = Tabs[tabId] or {}
    local found = false
    for _,x in ipairs(Tabs[tabId]) do if x == id then found = true; break end end
    if not found then table.insert(Tabs[tabId], id) end
  end
  Tabs["new"] = Tabs["new"] or {}
  local foundNew = false
  for _,x in ipairs(Tabs["new"]) do if x == id then foundNew = true; break end end
  if not foundNew then table.insert(Tabs["new"], id) end
  rebuildAll(); saveConfig()
end

local ContentProvider = game:GetService("ContentProvider")
local BrokenTracks = {}
local BROKEN_FILE = "MM2Radio_Broken.json"
local function loadBroken()
  pcall(function()
    if isfile and readfile and isfile(BROKEN_FILE) then
      local d = HttpService:JSONDecode(readfile(BROKEN_FILE))
      if type(d) == "table" then BrokenTracks = d end
    end
  end)
end
local function saveBroken()
  pcall(function() if writefile then writefile(BROKEN_FILE, HttpService:JSONEncode(BrokenTracks)) end end)
end
loadBroken()

local scanningBroken = false
local function scanForBroken(progressCb, doneCb)
  if scanningBroken then return end
  scanningBroken = true
  task.spawn(function()
    local ids = {}
    for id,_ in pairs(Songs) do table.insert(ids, id) end
    local total = #ids
    for i, id in ipairs(ids) do
      local snd = Instance.new("Sound")
      snd.SoundId = "rbxassetid://" .. id
      local status = nil
      pcall(function()
        ContentProvider:PreloadAsync({snd}, function(_, fetchStatus) status = fetchStatus end)
      end)
      if status == Enum.AssetFetchStatus.Failure then
        BrokenTracks[id] = true
      else
        BrokenTracks[id] = nil
      end
      snd:Destroy()
      if progressCb then progressCb(i, total) end
      task.wait(0.03)
    end
    saveBroken()
    scanningBroken = false
    if doneCb then doneCb() end
  end)
end

local function fixScroll()
  pcall(function()
    local p = PG:FindFirstChild("CrossPlatform")
    if not p then return end
    p = p:FindFirstChild("Inventory"); if not p then return end
    p = p:FindFirstChild("Small"); if not p then return end
    p = p:FindFirstChild("Container"); if not p then return end
    p = p:FindFirstChild("Main"); if not p then return end
    p = p:FindFirstChild("Songs"); if not p then return end
    p = p:FindFirstChild("Main"); if not p then return end
    p = p:FindFirstChild("MySongs"); if not p then return end
    local sf = p:FindFirstChild("ScrollFrame"); if not sf then return end
    local lay = sf:FindFirstChildOfClass("UIListLayout")
    if lay then
      sf.CanvasSize = UDim2.new(0,0,0,lay.AbsoluteContentSize.Y+200)
      lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sf.CanvasSize = UDim2.new(0,0,0,lay.AbsoluteContentSize.Y+200)
      end)
    end
  end)
end
task.spawn(function() task.wait(2); fixScroll(); while task.wait(5) do fixScroll() end end)

local importing = false
local importConns = {}
local importStatus = nil
local importCount = 0
local tempImported = {}
local CHAR_SOUNDS = {
  ["rbxasset://sounds/action_get_up.mp3"]=true, ["rbxasset://sounds/uuhhh.mp3"]=true,
  ["rbxasset://sounds/action_falling.mp3"]=true, ["rbxasset://sounds/action_jump.mp3"]=true,
  ["rbxasset://sounds/action_jump_land.mp3"]=true, ["rbxasset://sounds/impact_water.mp3"]=true,
  ["rbxasset://sounds/action_swim.mp3"]=true, ["rbxasset://sounds/action_footsteps_plastic.mp3"]=true,
}
local sessionImportedIds = {}

local function extractId(str)
  if not str or str == "" then return nil end
  if CHAR_SOUNDS[str] then return nil end
  if str:match("rbxasset://sounds") then return nil end
  local id = str:match("id=(%d+)") or str:match("rbxassetid://(%d+)") or str:match("^(%d+)$")
  if id and #id >= 5 then return id end
  return nil
end

local function importToTemp(songId)
  if not songId then return end
  if Songs[songId] then return false end
  if tempImported[songId] then return false end
  if sessionImportedIds[songId] then return false end
  sessionImportedIds[songId] = true
  importCount = importCount + 1
  local rn = robloxNameFor(songId)
  local finalName = rn or ("song "..songId)
  tempImported[songId] = {id=songId, name=finalName, robloxName=rn or finalName}
  if importStatus then importStatus.Text = "  [" .. importCount .. "] song " .. finalName end
  return true
end

local function saveImportedSong(songId)
  local temp = tempImported[songId]
  if not temp then return false end
  if Songs[songId] then return false end
  Songs[songId] = {id=songId, name=temp.name, robloxName=temp.robloxName or temp.name, lang="ru", imported=true, cat="new"}
  Tabs["new"] = Tabs["new"] or {}
  local foundNew = false
  for _, id in ipairs(Tabs["new"]) do if id == songId then foundNew = true; break end end
  if not foundNew then table.insert(Tabs["new"], songId) end
  rebuildAll(); saveConfig()
  tempImported[songId] = nil
  return true
end

local function startImport()
  if importing then return end
  importing = true
  importCount = 0
  sessionImportedIds = {}
  if importStatus then importStatus.Text = "  LISTENING..." end
  if PlaySong and PlaySong.OnClientEvent then
    local c1 = PlaySong.OnClientEvent:Connect(function(...)
      local args = {...}
      for _, a in ipairs(args) do
        if type(a) == "string" then
          local songId = extractId(a)
          if songId then importToTemp(songId) end
        end
      end
    end)
    table.insert(importConns, c1)
  end
end

local function stopImport()
  importing = false
  for _, conn in ipairs(importConns) do pcall(function() conn:Disconnect() end) end
  importConns = {}
  local tempCount = 0
  for _ in pairs(tempImported) do tempCount = tempCount + 1 end
  if importStatus then importStatus.Text = "  Stopped. Pending: " .. tempCount end
end

local function clearTempImported()
  tempImported = {}; sessionImportedIds = {}; importCount = 0
end

if CFG.autoImport then startImport() end

local WORKSPACE_PATH = "/storage/emulated/0/Delta/Workspace"

local function getBaseName(path) return (path:match("([^/\\]+)$")) or path end

local function listWorkspaceFiles()
  local ok1, files = pcall(function() return listfiles("") end)
  if not ok1 or type(files) ~= "table" then
    ok1, files = pcall(function() return listfiles(WORKSPACE_PATH) end)
  end
  if not ok1 or type(files) ~= "table" then return {} end
  return files
end

local function safeWrite(name, data)
  local ok1 = pcall(function() writefile(name, data) end)
  if not ok1 then pcall(function() writefile(WORKSPACE_PATH .. "/" .. name, data) end) end
end

local function safeRead(name)
  local ok1, content = pcall(function() return readfile(name) end)
  if not ok1 or content == nil then
    ok1, content = pcall(function() return readfile(WORKSPACE_PATH .. "/" .. name) end)
  end
  if ok1 then return content end
  return nil
end

local function safeDelete(name)
  local ok1 = pcall(function() delfile(name) end)
  if not ok1 then pcall(function() delfile(WORKSPACE_PATH .. "/" .. name) end) end
end

local SERVERS_FILE = "RiseLoader.Servers.json"
local PlaceId = game.PlaceId
local CurrentJobId = game.JobId
local Store = {}

local function loadServers()
  local raw = safeRead(SERVERS_FILE)
  if raw then
    local ok1, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
    Store = (ok1 and type(decoded) == "table") and decoded or {}
  else
    Store = {}
  end
end
local function saveServersFile() safeWrite(SERVERS_FILE, HttpService:JSONEncode(Store)) end

local function addCurrentServer()
  local names = {}
  for _, plr in ipairs(Players:GetPlayers()) do table.insert(names, plr.Name) end
  for _, entry in ipairs(Store) do
    if entry.JobId == CurrentJobId then
      entry.Players = names; entry.SavedAt = os.time()
      saveServersFile(); return
    end
  end
  table.insert(Store, 1, {JobId=CurrentJobId, PlaceId=PlaceId, Players=names, SavedAt=os.time()})
  saveServersFile()
end

local function deleteServerEntry(jobId)
  for i, entry in ipairs(Store) do
    if entry.JobId == jobId then table.remove(Store, i); break end
  end
  saveServersFile()
end

local function joinServerEntry(entry)
  local ok1, e1 = pcall(function() TeleportService:TeleportToPlaceInstance(entry.PlaceId, entry.JobId, LP) end)
  if not ok1 then warn("[RiseUltimate] \u{422}\u{435}\u{43B}\u{435}\u{43F}\u{43E}\u{440}\u{442} \u{43D}\u{435} \u{443}\u{434}\u{430}\u{43B}\u{441}\u{44F}: " .. tostring(e1)) end
end

loadServers()

local function formatTime(t) return os.date("%d.%m %H:%M", t) end

local FOLDERS_FILE = "RiseLoader.Folders.json"
local Folders = {}

local function loadFolders()
  local raw = safeRead(FOLDERS_FILE)
  if raw then
    local ok1, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
    Folders = (ok1 and type(decoded) == "table") and decoded or {}
  else
    Folders = {}
  end
end
local function saveFolders() safeWrite(FOLDERS_FILE, HttpService:JSONEncode(Folders)) end
loadFolders()

local function getNextScriptNumber()
  local max = 0
  for _, entry in ipairs(listWorkspaceFiles()) do
    local num = getBaseName(entry):match("^Script%.Loader%.(%d+)%.txt$")
    if num and tonumber(num) > max then max = tonumber(num) end
  end
  return max + 1
end
local function getNextDeleteNumber()
  local max = 0
  for _, entry in ipairs(listWorkspaceFiles()) do
    local num = getBaseName(entry):match("^ScriptHasDelte%.Loader%.(%d+)%.txt$")
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
        local ok1, data = pcall(function() return HttpService:JSONDecode(content) end)
        if ok1 and data and data.name and data.code then
          table.insert(result, {filename=base, name=data.name, code=data.code, folderId=data.folderId or "root"})
        end
      end
    end
  end
  return result
end

local function genId() return HttpService:GenerateGUID(false) end

local curTab = "all"
local curView = "songs"
local showOrig = CFG.showOriginal
local activeApp = CFG.activeApp or "radio"
local currentFolder = "root"
local pendingDelete = nil
local guiMode = "classic"

local buildUI

buildUI = function()
  local old = PG:FindFirstChild("MM2Radio")

  local BG,PAN,PANA,AC,ACS,TX,TXM,BD,ST,DOT,GRAD = getActiveColors()
  local CR = CFG.corner or 10
  local FO = FONT_OPTIONS[CFG.font] or FONT_OPTIONS[1]
  local FONT_BOLD, FONT_REG = FO[2], FO[3]
  local SCALE = SCALE_OPTIONS[CFG.textScale] or 1.0
  local function SZ(n) return math.floor(n*SCALE + 0.5) end

  -- v4 glass design tokens
  local RAD_WIN  = CR > 0 and 22 or 6
  local RAD_CARD = CR > 0 and 14 or 4
  local RAD_SM   = CR > 0 and 9 or 3
  local GLASS_TRANS = math.clamp(0.10 + (1-CFG.menuOpacity)*0.75, 0.10, 0.88)
  local CARD_TRANS = math.clamp(GLASS_TRANS + 0.10, 0.10, 0.92)

  local gui = Instance.new("ScreenGui"); gui.Name = "MM2Radio"
  gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  gui.Parent = PG

  local BUILD_OK, BUILD_ERR = pcall(function()

  -- ===== v4: reusable "glass" UI primitives =====
  local function corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = (typeof(r) == "UDim") and r or UDim.new(0, r)
    c.Parent = inst
    return c
  end

  local function sheen(parent, z, strength)
    local s = Instance.new("Frame")
    s.Size = UDim2.new(1,0,1,0)
    s.BackgroundColor3 = Color3.new(1,1,1)
    s.BorderSizePixel = 0
    s.ZIndex = z
    s.Parent = parent
    local g = Instance.new("UIGradient")
    g.Rotation = 90
    g.Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1))
    g.Transparency = NumberSequence.new({
      NumberSequenceKeypoint.new(0, 1-(strength or 0.10)),
      NumberSequenceKeypoint.new(0.4, 1),
      NumberSequenceKeypoint.new(1, 1),
    })
    g.Parent = s
    local pc = parent:FindFirstChildOfClass("UICorner")
    if pc then local c2 = Instance.new("UICorner"); c2.CornerRadius = pc.CornerRadius; c2.Parent = s end
    return s
  end

  local function glass(parent, size, pos, trans, z, radius)
    local f = Instance.new("Frame")
    f.Size = size
    if pos then f.Position = pos end
    f.BackgroundColor3 = PAN
    f.BackgroundTransparency = trans or CARD_TRANS
    f.BorderSizePixel = 0
    f.ZIndex = z or 51
    f.Parent = parent
    corner(f, radius or RAD_CARD)
    local st = Instance.new("UIStroke")
    st.Color = BD; st.Transparency = 0.4; st.Thickness = 1
    st.Parent = f
    sheen(f, (z or 51)+1, 0.10)
    return f
  end

  local function glassButton(parent, txt, size, pos, kind, z)
    local b = Instance.new("TextButton")
    b.Size = size; if pos then b.Position = pos end
    b.Text = ""; b.AutoButtonColor = false; b.BorderSizePixel = 0
    b.ZIndex = z or 54; b.Parent = parent
    local baseCol = kind == "accent" and AC or (kind == "danger" and ST or PANA)
    b.BackgroundColor3 = baseCol
    b.BackgroundTransparency = kind == "ghost" and 0.35 or 0.02
    corner(b, RAD_SM)
    if kind == "accent" or kind == "danger" then
      local g = Instance.new("UIGradient")
      g.Rotation = 90
      g.Color = ColorSequence.new(lighten(baseCol,0.10), baseCol)
      g.Parent = b
    else
      local st = Instance.new("UIStroke"); st.Color = BD; st.Transparency = 0.35; st.Thickness = 1; st.Parent = b
    end
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
    lbl.Text = txt
    lbl.TextColor3 = (kind=="accent" or kind=="danger") and Color3.new(1,1,1) or TX
    lbl.Font = FONT_BOLD; lbl.TextSize = SZ(11)
    lbl.ZIndex = (z or 54)+1; lbl.Parent = b
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundTransparency = math.max(0,(kind=="ghost" and 0.35 or 0.02)-0.15)}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundTransparency = kind=="ghost" and 0.35 or 0.02}):Play() end)
    return b, lbl
  end

  local function pillToggle(parent, sz, pos, getter, setter, z)
    local track = Instance.new("Frame")
    track.Size = sz or UDim2.new(0,40,0,20)
    if pos then track.Position = pos end
    track.BorderSizePixel = 0; track.ZIndex = z or 54; track.Parent = parent
    corner(track, UDim.new(1,0))
    local h = track.Size.Y.Offset
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,h-4,0,h-4); knob.Position = UDim2.new(0,2,0,2)
    knob.BackgroundColor3 = Color3.new(1,1,1); knob.BorderSizePixel = 0
    knob.ZIndex = (z or 54)+1; knob.Parent = track
    corner(knob, UDim.new(1,0))
    local function paint(animated)
      local on = getter()
      local col = on and AC or rgb(80,80,92)
      local tp = on and 0.05 or 0.55
      local kPos = on and UDim2.new(1,-(h-2),0,2) or UDim2.new(0,2,0,2)
      if animated then
        TweenService:Create(track, TweenInfo.new(0.18), {BackgroundColor3=col, BackgroundTransparency=tp}):Play()
        TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Back), {Position=kPos}):Play()
      else
        track.BackgroundColor3 = col; track.BackgroundTransparency = tp; knob.Position = kPos
      end
    end
    paint(false)
    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1; hit.Size = UDim2.new(1,0,1,0); hit.Text = ""
    hit.ZIndex = (z or 54)+2; hit.Parent = track
    hit.MouseButton1Click:Connect(function() setter(not getter()); paint(true) end)
    return track, paint
  end

  local function notify(text, kind)
    local prev = gui:FindFirstChild("RiseToast")
    if prev then prev:Destroy() end
    local card = Instance.new("Frame"); card.Name = "RiseToast"
    card.AnchorPoint = Vector2.new(0.5,0)
    card.Position = UDim2.new(0.5,0,0,-40)
    card.Size = UDim2.new(0,0,0,34); card.AutomaticSize = Enum.AutomaticSize.X
    card.BackgroundColor3 = kind=="danger" and ST or (kind=="ok" and rgb(40,170,100) or PAN)
    card.BackgroundTransparency = 0.06
    card.ZIndex = 300; card.Parent = gui
    corner(card, UDim.new(1,0))
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.new(1,1,1); stroke.Transparency = 0.75; stroke.Thickness = 1; stroke.Parent = card
    local pad = Instance.new("UIPadding", card)
    pad.PaddingLeft = UDim.new(0,16); pad.PaddingRight = UDim.new(0,16)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,0,1,0); lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.BackgroundTransparency = 1; lbl.Text = text
    lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = FONT_BOLD; lbl.TextSize = SZ(11)
    lbl.ZIndex = 301; lbl.Parent = card
    TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position=UDim2.new(0.5,0,0,18)}):Play()
    task.delay(1.6, function()
      if card and card.Parent then
        local tw = TweenService:Create(card, TweenInfo.new(0.25), {Position=UDim2.new(0.5,0,0,-40)})
        tw:Play()
        tw.Completed:Connect(function() if card then card:Destroy() end end)
      end
    end)
  end

  -- ===== launcher orb =====
  local tog = Instance.new("TextButton")
  tog.Size = UDim2.new(0,52,0,52); tog.Position = UDim2.new(0,10,0.5,-26)
  tog.BackgroundColor3 = PAN; tog.BackgroundTransparency = 0.12
  tog.Text = ""; tog.AutoButtonColor = false
  tog.BorderSizePixel = 0; tog.ZIndex = 100; tog.Parent = gui
  corner(tog, UDim.new(1,0))
  local togGrad = Instance.new("UIGradient", tog)
  togGrad.Rotation = 90
  togGrad.Color = ColorSequence.new(lighten(PAN,0.12), PAN)
  local togRing = Instance.new("UIStroke", tog)
  togRing.Color = AC; togRing.Thickness = 1.5; togRing.Transparency = 0.25

  local barsHolder = Instance.new("Frame")
  barsHolder.Size = UDim2.new(0,20,0,20)
  barsHolder.AnchorPoint = Vector2.new(0.5,0.5)
  barsHolder.Position = UDim2.new(0.5,0,0.5,0)
  barsHolder.BackgroundTransparency = 1
  barsHolder.ZIndex = 101
  barsHolder.Parent = tog
  local barsLay = Instance.new("UIListLayout", barsHolder)
  barsLay.FillDirection = Enum.FillDirection.Horizontal
  barsLay.VerticalAlignment = Enum.VerticalAlignment.Center
  barsLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
  barsLay.Padding = UDim.new(0,3)
  for _, h in ipairs({9,18,13}) do
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0,4,0,h)
    bar.BackgroundColor3 = AC
    bar.BorderSizePixel = 0
    bar.ZIndex = 101
    bar.Parent = barsHolder
    corner(bar, UDim.new(1,0))
  end
  task.spawn(function()
    while tog and tog.Parent do
      TweenService:Create(togRing, TweenInfo.new(1.1), {Transparency = 0.7}):Play()
      task.wait(1.1)
      TweenService:Create(togRing, TweenInfo.new(1.1), {Transparency = 0.25}):Play()
      task.wait(1.1)
    end
  end)

  -- ===== main glass window =====
  local main = Instance.new("Frame"); main.Name = "Main"
  main.Size = UDim2.new(0.86,0,0.93,0)
  main.Position = UDim2.new(0.07,0,-0.95,0)
  main.BackgroundColor3 = BG; main.BackgroundTransparency = GLASS_TRANS; main.BorderSizePixel = 0
  main.Visible = false; main.ZIndex = 50; main.Parent = gui
  corner(main, RAD_WIN)
  local mainStroke = Instance.new("UIStroke", main)
  mainStroke.Color = Color3.new(1,1,1); mainStroke.Thickness = 1; mainStroke.Transparency = 0.75
  local mainGrad = Instance.new("UIGradient", main)
  mainGrad.Rotation = 90
  if GRAD then
    local kp = {}
    for gi, col in ipairs(GRAD) do
      table.insert(kp, ColorSequenceKeypoint.new((gi-1)/(#GRAD-1), col))
    end
    mainGrad.Color = ColorSequence.new(kp)
  else
    mainGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, lighten(BG,0.04)),
      ColorSequenceKeypoint.new(1, PAN),
    })
  end
  sheen(main, 50, 0.07)

  local hdr = Instance.new("Frame"); hdr.Size = UDim2.new(1,0,0,46)
  hdr.BackgroundTransparency = 1; hdr.ZIndex = 51; hdr.Parent = main

  local hdrChip = Instance.new("Frame")
  hdrChip.Size = UDim2.new(0,30,0,30); hdrChip.Position = UDim2.new(0,10,0,8)
  hdrChip.BackgroundColor3 = AC; hdrChip.ZIndex = 52; hdrChip.Parent = hdr
  corner(hdrChip, RAD_SM)
  local hdrChipGrad = Instance.new("UIGradient", hdrChip)
  hdrChipGrad.Rotation = 90
  hdrChipGrad.Color = ColorSequence.new(lighten(AC,0.1), AC)
  local hdrChipTxt = Instance.new("TextLabel")
  hdrChipTxt.Size = UDim2.new(1,0,1,0); hdrChipTxt.BackgroundTransparency = 1
  hdrChipTxt.Text = "\u{266B}"; hdrChipTxt.Font = Enum.Font.GothamBold; hdrChipTxt.TextSize = SZ(15)
  hdrChipTxt.TextColor3 = Color3.new(1,1,1); hdrChipTxt.ZIndex = 53; hdrChipTxt.Parent = hdrChip

  local ttl = Instance.new("TextLabel")
  local titleText = "radio.ultimate"
  if activeApp == "scripts" then titleText = "rise.scripts"
  elseif activeApp == "servers" then titleText = "rise.servers" end
  ttl.Text = titleText
  ttl.Size = UDim2.new(0,160,0,18); ttl.Position = UDim2.new(0,48,0,7)
  ttl.BackgroundTransparency = 1; ttl.Font = FONT_BOLD; ttl.TextSize = SZ(15)
  ttl.TextColor3 = TX; ttl.TextXAlignment = Enum.TextXAlignment.Left; ttl.ZIndex = 52; ttl.Parent = hdr
  local sub = Instance.new("TextLabel")
  local subText = "mm2 \u{B7} v11"
  if activeApp == "scripts" then subText = "folders \u{B7} loader"
  elseif activeApp == "servers" then subText = "jobid \u{B7} teleport" end
  sub.Text = subText
  sub.Size = UDim2.new(0,160,0,14); sub.Position = UDim2.new(0,48,0,23)
  sub.BackgroundTransparency = 1; sub.Font = Enum.Font.Code; sub.TextSize = SZ(9)
  sub.TextColor3 = TXM; sub.TextXAlignment = Enum.TextXAlignment.Left; sub.ZIndex = 52; sub.Parent = hdr

  local liveDot = Instance.new("Frame")
  liveDot.Size = UDim2.new(0,6,0,6); liveDot.Position = UDim2.new(0,215,0,14)
  liveDot.BackgroundColor3 = importing and rgb(60,220,130) or TXM
  liveDot.BorderSizePixel = 0; liveDot.ZIndex = 52; liveDot.Parent = hdr
  corner(liveDot, UDim.new(1,0))
  task.spawn(function()
    while liveDot and liveDot.Parent do
      local c = importing and rgb(60,220,130) or TXM
      TweenService:Create(liveDot, TweenInfo.new(0.7), {BackgroundColor3=c, BackgroundTransparency=0.5, Size=UDim2.new(0,5,0,5)}):Play()
      task.wait(0.7)
      TweenService:Create(liveDot, TweenInfo.new(0.7), {BackgroundColor3=c, BackgroundTransparency=0, Size=UDim2.new(0,6,0,6)}):Play()
      task.wait(0.7)
    end
  end)
  if CFG.autoImport then
    local autoLbl = Instance.new("TextLabel")
    autoLbl.Text = "AUTO"
    autoLbl.Size = UDim2.new(0,40,0,12); autoLbl.Position = UDim2.new(0,226,0,13)
    autoLbl.BackgroundTransparency = 1; autoLbl.Font = Enum.Font.Code; autoLbl.TextSize = SZ(8)
    autoLbl.TextColor3 = rgb(60,220,130); autoLbl.TextXAlignment = Enum.TextXAlignment.Left
    autoLbl.ZIndex = 52; autoLbl.Parent = hdr
  end

  local drag, dragS, posS = false, nil, nil
  hdr.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
      drag = true; dragS = i.Position; posS = main.Position
    end
  end)
  hdr.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
  end)
  UIS.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
      local d = i.Position - dragS
      main.Position = UDim2.new(posS.X.Scale, posS.X.Offset+d.X, posS.Y.Scale, posS.Y.Offset+d.Y)
    end
  end)

  local hideMain
  local function showMain()
    main.Visible = true
    main.Position = UDim2.new(0.07,0,-0.95,0)
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
      {Position = UDim2.new(0.07,0,0.04,0)}):Play()
    TweenService:Create(menuBlur, TweenInfo.new(0.4), {Size = CFG.useBlur and 16 or 0}):Play()
  end
  hideMain = function()
    local tw = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
      {Position = UDim2.new(0.07,0,-0.95,0)})
    tw:Play()
    tw.Completed:Connect(function() main.Visible = false end)
    TweenService:Create(menuBlur, TweenInfo.new(0.3), {Size = 0}):Play()
  end

  local function hdrIconBtn(glyph, xOff, kind)
    local b = Instance.new("TextButton"); b.Text = ""
    b.Size = UDim2.new(0,28,0,28); b.Position = UDim2.new(1,xOff,0,9)
    b.AutoButtonColor = false; b.BorderSizePixel = 0
    b.BackgroundColor3 = kind == "danger" and ST or PANA
    b.BackgroundTransparency = kind == "danger" and 0.15 or 0.35
    b.ZIndex = 52; b.Parent = hdr
    corner(b, RAD_SM)
    local g = Instance.new("TextLabel")
    g.Size = UDim2.new(1,0,1,0); g.BackgroundTransparency = 1
    g.Text = glyph; g.Font = Enum.Font.GothamBold; g.TextSize = SZ(13)
    g.TextColor3 = Color3.new(1,1,1); g.ZIndex = 53; g.Parent = b
    return b
  end
  local bMin = hdrIconBtn("\u{2013}", -122)
  local bHelp = nil
  if activeApp == "radio" then bHelp = hdrIconBtn("?", -88) end
  local bSet = hdrIconBtn("\u{2699}", -54)
  local bX = hdrIconBtn("\u{2715}", -20, "danger")

  -- ===== segmented app switcher (Radio / Scripts / Servers) =====
  local segWrap = glass(main, UDim2.new(1,-28,0,30), UDim2.new(0,14,0,50), CARD_TRANS+0.05, 51, RAD_SM)
  local segLay = Instance.new("UIListLayout", segWrap)
  segLay.FillDirection = Enum.FillDirection.Horizontal
  segLay.Padding = UDim.new(0,2)
  local segPad = Instance.new("UIPadding", segWrap)
  segPad.PaddingLeft = UDim.new(0,2); segPad.PaddingRight = UDim.new(0,2)
  segPad.PaddingTop = UDim.new(0,2); segPad.PaddingBottom = UDim.new(0,2)

  local function segBtn(glyph, label, id)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1/3,-2,1,0)
    b.Text = ""; b.AutoButtonColor = false; b.BorderSizePixel = 0
    local active = activeApp == id
    b.BackgroundColor3 = active and AC or PAN
    b.BackgroundTransparency = active and 0.04 or 1
    b.ZIndex = 53; b.Parent = segWrap
    corner(b, RAD_SM-2)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,0,1,0); row.BackgroundTransparency = 1; row.ZIndex = 54; row.Parent = b
    local rl = Instance.new("UIListLayout", row)
    rl.FillDirection = Enum.FillDirection.Horizontal
    rl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    rl.VerticalAlignment = Enum.VerticalAlignment.Center
    rl.Padding = UDim.new(0,5)
    local ic = Instance.new("TextLabel")
    ic.Size = UDim2.new(0,14,0,14); ic.BackgroundTransparency = 1
    ic.Text = glyph; ic.Font = Enum.Font.GothamBold; ic.TextSize = SZ(12)
    ic.TextColor3 = active and Color3.new(1,1,1) or TXM
    ic.ZIndex = 55; ic.Parent = row
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(0,0,1,0); lb.AutomaticSize = Enum.AutomaticSize.X
    lb.BackgroundTransparency = 1; lb.Text = label
    lb.Font = FONT_BOLD; lb.TextSize = SZ(11)
    lb.TextColor3 = active and Color3.new(1,1,1) or TXM
    lb.ZIndex = 55; lb.Parent = row
    b.MouseButton1Click:Connect(function()
      if activeApp ~= id then
        activeApp = id; CFG.activeApp = id; saveConfig(); buildUI()
        task.defer(function()
          if main and main.Parent then main.Visible = true; main.Position = UDim2.new(0.07,0,0.04,0) end
        end)
      end
    end)
    return b
  end
  segBtn("\u{266B}", "Radio", "radio")
  segBtn("\u{2318}", "Scripts", "scripts")
  segBtn("\u{1F310}", "Servers", "servers")

  if activeApp == "radio" then

  local side = Instance.new("ScrollingFrame")
  side.Size = UDim2.new(0,148,1,-160); side.Position = UDim2.new(0,8,0,88)
  side.BackgroundTransparency = 1; side.BorderSizePixel = 0; side.ScrollBarThickness = 0
  side.ZIndex = 51; side.Parent = main
  local sideLay = Instance.new("UIListLayout"); sideLay.Padding = UDim.new(0,4); sideLay.Parent = side
  sideLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    side.CanvasSize = UDim2.new(0,0,0,sideLay.AbsoluteContentSize.Y+4)
  end)

  local function renderSidebar()
    for _,c in pairs(side:GetChildren()) do
      if c:IsA("TextButton") or c:IsA("TextBox") or c:IsA("Frame") then c:Destroy() end
    end
    for _,tm in ipairs(TabMeta) do
      local active = (tm.id == curTab and curView == "songs")
      local row = Instance.new("Frame")
      row.Size = UDim2.new(1,0,0,26); row.BackgroundTransparency = 1; row.ZIndex = 52; row.Parent = side
      local b = Instance.new("TextButton"); b.Text = ""
      b.Size = UDim2.new(1,-36,1,0); b.AutoButtonColor = false
      b.BackgroundColor3 = active and AC or PAN
      b.BackgroundTransparency = active and 0.05 or 0.55
      b.BorderSizePixel = 0; b.ZIndex = 52; b.Parent = row
      corner(b, UDim.new(1,0))
      local lbl = Instance.new("TextLabel"); lbl.Text = tm.label
      lbl.Size = UDim2.new(1,-28,1,0); lbl.Position = UDim2.new(0,12,0,0)
      lbl.BackgroundTransparency = 1
      lbl.TextColor3 = active and Color3.new(1,1,1) or TXM
      lbl.Font = FONT_BOLD; lbl.TextSize = SZ(11)
      lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextTruncate = Enum.TextTruncate.AtEnd
      lbl.ZIndex = 53; lbl.Parent = b
      local cnt = Instance.new("TextLabel")
      cnt.Text = tostring(#(Tabs[tm.id] or {}))
      cnt.Size = UDim2.new(0,22,1,0); cnt.Position = UDim2.new(1,-24,0,0)
      cnt.BackgroundTransparency = 1
      cnt.TextColor3 = active and Color3.new(1,1,1) or TXM
      cnt.Font = Enum.Font.Code; cnt.TextSize = SZ(9)
      cnt.TextXAlignment = Enum.TextXAlignment.Right
      cnt.ZIndex = 53; cnt.Parent = b
      b.MouseButton1Click:Connect(function() curView = "songs"; curTab = tm.id; buildUI() end)
      if not tm.builtin then
        local rn = Instance.new("TextButton"); rn.Text = ""
        rn.Size = UDim2.new(0,16,0,16); rn.Position = UDim2.new(1,-34,0,5)
        rn.BackgroundColor3 = PAN; rn.BackgroundTransparency = 0.2; rn.AutoButtonColor = false
        rn.BorderSizePixel = 0; rn.ZIndex = 53; rn.Parent = row
        corner(rn, UDim.new(1,0))
        local rnIc = Instance.new("TextLabel"); rnIc.Text = "\u{270E}"
        rnIc.Size = UDim2.new(1,0,1,0); rnIc.BackgroundTransparency = 1
        rnIc.TextColor3 = TXM; rnIc.Font = Enum.Font.GothamBold; rnIc.TextSize = SZ(8)
        rnIc.ZIndex = 54; rnIc.Parent = rn
        rn.MouseButton1Click:Connect(function()
          local box = Instance.new("TextBox"); box.Text = tm.label
          box.Size = UDim2.new(1,-40,1,-4); box.Position = UDim2.new(0,0,0,2)
          box.BackgroundColor3 = BG; box.TextColor3 = TX
          box.Font = FONT_BOLD; box.TextSize = SZ(11)
          box.TextXAlignment = Enum.TextXAlignment.Left
          box.BorderSizePixel = 0; box.ZIndex = 60; box.Parent = row
          corner(box, UDim.new(1,0))
          box.FocusLost:Connect(function()
            if box.Text ~= "" then tm.label = box.Text; saveConfig() end
            renderSidebar()
          end)
          box:CaptureFocus()
        end)
        local dl = Instance.new("TextButton"); dl.Text = ""
        dl.Size = UDim2.new(0,16,0,16); dl.Position = UDim2.new(1,-18,0,5)
        dl.BackgroundColor3 = ST; dl.BackgroundTransparency = 0.2; dl.AutoButtonColor = false
        dl.BorderSizePixel = 0; dl.ZIndex = 53; dl.Parent = row
        corner(dl, UDim.new(1,0))
        local dlIc = Instance.new("TextLabel"); dlIc.Text = "\u{2715}"
        dlIc.Size = UDim2.new(1,0,1,0); dlIc.BackgroundTransparency = 1
        dlIc.TextColor3 = Color3.new(1,1,1); dlIc.Font = Enum.Font.GothamBold; dlIc.TextSize = SZ(8)
        dlIc.ZIndex = 54; dlIc.Parent = dl
        dl.MouseButton1Click:Connect(function()
          for i,x in ipairs(TabMeta) do
            if x.id == tm.id then table.remove(TabMeta, i); break end
          end
          Tabs[tm.id] = nil
          if curTab == tm.id then curTab = "all" end
          saveConfig(); buildUI()
        end)
      end
    end
    local addT = Instance.new("TextButton"); addT.Text = "+ new tab"
    addT.Size = UDim2.new(1,0,0,24); addT.BackgroundTransparency = 1
    addT.AutoButtonColor = false
    addT.TextColor3 = TXM; addT.Font = FONT_BOLD; addT.TextSize = SZ(10)
    addT.ZIndex = 52; addT.Parent = side
    local addTStroke = Instance.new("UIStroke", addT)
    addTStroke.Color = BD; addTStroke.Transparency = 0.3; addTStroke.Thickness = 1
    corner(addT, UDim.new(1,0))
    addT.MouseButton1Click:Connect(function()
      local box = Instance.new("TextBox"); box.PlaceholderText = "tab name..."
      box.Size = UDim2.new(1,-8,0,22); box.Position = UDim2.new(0,4,1,-26)
      box.BackgroundColor3 = PAN; box.TextColor3 = TX
      box.Font = FONT_BOLD; box.TextSize = SZ(10)
      box.BorderSizePixel = 0; box.ZIndex = 60; box.Parent = main
      corner(box, UDim.new(1,0))
      box.FocusLost:Connect(function()
        local nm = box.Text:gsub("%s+","_")
        if nm ~= "" then
          for _,tm in ipairs(TabMeta) do
            if tm.id == nm then nm = nm.."_"..math.random(99) end
          end
          table.insert(TabMeta, {id=nm, label=nm, builtin=false})
          Tabs[nm] = {}
          saveConfig()
        end
        renderSidebar()
      end)
      box:CaptureFocus()
    end)
  end

  local content = Instance.new("Frame")
  content.Size = UDim2.new(1,-164,1,-160); content.Position = UDim2.new(0,160,0,88)
  content.BackgroundTransparency = 1; content.ZIndex = 51; content.Parent = main

  local searchBar = glass(content, UDim2.new(1,0,0,32), nil, CARD_TRANS, 52, RAD_SM)
  local searchBox = Instance.new("TextBox")
  searchBox.Size = UDim2.new(1,-74,1,0); searchBox.Position = UDim2.new(0,12,0,0)
  searchBox.BackgroundTransparency = 1; searchBox.TextColor3 = TX
  searchBox.PlaceholderText = "Filter songs..."; searchBox.PlaceholderColor3 = TXM
  searchBox.Font = FONT_REG; searchBox.TextSize = SZ(11)
  searchBox.TextXAlignment = Enum.TextXAlignment.Left; searchBox.Text = searchQuery
  searchBox.ZIndex = 54; searchBox.Parent = searchBar
  local searchBtn, _ = glassButton(searchBar, "\u{1F50D}", UDim2.new(0,28,0,24), UDim2.new(1,-64,0.5,-12), "accent", 54)
  local clearSearch, _ = glassButton(searchBar, "\u{2715}", UDim2.new(0,28,0,24), UDim2.new(1,-32,0.5,-12), "ghost", 54)

  local cHdr = Instance.new("Frame"); cHdr.Size = UDim2.new(1,0,0,24)
  cHdr.Position = UDim2.new(0,4,0,40)
  cHdr.BackgroundTransparency = 1; cHdr.ZIndex = 52; cHdr.Parent = content
  local cTitle = Instance.new("TextLabel")
  cTitle.Size = UDim2.new(1,-100,1,0); cTitle.Position = UDim2.new(0,0,0,0)
  cTitle.BackgroundTransparency = 1; cTitle.TextColor3 = TX
  cTitle.Font = FONT_BOLD; cTitle.TextSize = SZ(13)
  cTitle.TextXAlignment = Enum.TextXAlignment.Left; cTitle.ZIndex = 53; cTitle.Parent = cHdr

  local scroll = Instance.new("ScrollingFrame")
  scroll.Size = UDim2.new(1,0,1,-108); scroll.Position = UDim2.new(0,0,0,70)
  scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 3
  scroll.ScrollBarImageColor3 = AC; scroll.ZIndex = 52; scroll.Parent = content
  local sLay = Instance.new("UIListLayout"); sLay.Padding = UDim.new(0,6); sLay.SortOrder = Enum.SortOrder.LayoutOrder; sLay.Parent = scroll
  sLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,sLay.AbsoluteContentSize.Y+8)
  end)

  local function iconBtn(parent, glyph, size, pos, bg, z)
    local b = Instance.new("TextButton"); b.Text = ""
    b.Size = size; b.Position = pos
    b.BackgroundColor3 = bg; b.AutoButtonColor = false; b.BorderSizePixel = 0
    b.ZIndex = z or 54; b.Parent = parent
    corner(b, UDim.new(1,0))
    local g = Instance.new("TextLabel")
    g.Size = UDim2.new(1,0,1,0); g.BackgroundTransparency = 1
    g.Text = glyph; g.Font = Enum.Font.GothamBold; g.TextSize = SZ(10)
    g.TextColor3 = Color3.new(1,1,1); g.ZIndex = (z or 54)+1; g.Parent = b
    return b
  end
  local function rowBtn(parent, txt, w, bg, xFromRight)
    return iconBtn(parent, txt, UDim2.new(0,w,0,22), UDim2.new(1,xFromRight,0.5,-11), bg, 54)
  end

  -- ===== glass modal + dim backdrop helper (used for all confirm dialogs) =====
  local function confirmModal(text)
    local backdrop = Instance.new("Frame")
    backdrop.Size = UDim2.new(1,0,1,0); backdrop.BackgroundColor3 = Color3.new(0,0,0)
    backdrop.BackgroundTransparency = 0.45; backdrop.ZIndex = 199; backdrop.Visible = false
    backdrop.Parent = gui
    local modal = glass(gui, UDim2.new(0,240,0,112), UDim2.new(0.5,-120,0.5,-56), 0.06, 200, RAD_CARD)
    modal.Visible = false
    local lbl = Instance.new("TextLabel"); lbl.Text = text
    lbl.Size = UDim2.new(1,-20,0,40); lbl.Position = UDim2.new(0,10,0,8)
    lbl.BackgroundTransparency = 1; lbl.TextColor3 = TX
    lbl.Font = FONT_BOLD; lbl.TextSize = SZ(14); lbl.TextWrapped = true
    lbl.ZIndex = 201; lbl.Parent = modal
    local yesBtn = select(1, glassButton(modal, "Yes", UDim2.new(0,90,0,30), UDim2.new(0.5,-96,1,-40), "accent", 201))
    local noBtn = select(1, glassButton(modal, "No", UDim2.new(0,90,0,30), UDim2.new(0.5,6,1,-40), "danger", 201))
    local function open() backdrop.Visible = true; modal.Visible = true end
    local function close() backdrop.Visible = false; modal.Visible = false end
    return {open=open, close=close, yes=yesBtn, no=noBtn}
  end

  local delSong = confirmModal("\u{423}\u{434}\u{430}\u{43B}\u{438}\u{442}\u{44C} \u{43F}\u{435}\u{441}\u{43D}\u{44E}?")
  local pendingSongDelete = nil
  local renderSongs

  delSong.yes.MouseButton1Click:Connect(function()
    if pendingSongDelete then
      Songs[pendingSongDelete] = nil
      for _,t in pairs(Tabs) do
        for i = #t, 1, -1 do if t[i] == pendingSongDelete then table.remove(t, i) end end
      end
      rebuildAll(); saveConfig()
    end
    delSong.close()
    pendingSongDelete = nil
    if renderSongs then renderSongs() end
  end)
  delSong.no.MouseButton1Click:Connect(function() delSong.close(); pendingSongDelete = nil end)

  local function doSearch()
    searchQuery = searchBox.Text
    if curView == "songs" and renderSongs then renderSongs() end
  end
  searchBtn.MouseButton1Click:Connect(doSearch)
  searchBox.FocusLost:Connect(function(enterPressed) if enterPressed then doSearch() end end)
  clearSearch.MouseButton1Click:Connect(function()
    searchQuery = ""; searchBox.Text = ""; doSearch()
  end)

  renderSongs = function()
    for _,c in pairs(scroll:GetChildren()) do
      if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end
    end
    local ids = Tabs[curTab] or {}
    cTitle.Text = curTab
    local countLabel = cHdr:FindFirstChild("CountLabel")
    if not countLabel then
      countLabel = Instance.new("TextLabel"); countLabel.Name = "CountLabel"
      countLabel.Size = UDim2.new(0,100,1,0); countLabel.Position = UDim2.new(1,-100,0,0)
      countLabel.BackgroundTransparency = 1; countLabel.Font = Enum.Font.Code; countLabel.TextSize = SZ(9)
      countLabel.TextColor3 = TXM; countLabel.TextXAlignment = Enum.TextXAlignment.Right
      countLabel.ZIndex = 53; countLabel.Parent = cHdr
    end
    local seen = {}
    local count = 0
    local filtered = 0

    local btnPlay = "\u{25B6}"
    local btnPrev = "\u{266A}"
    local btnEdit = "\u{270E}"
    local btnCopy = "\u{2295}"
    local btnRem = "\u{2212}"
    local btnDel = "\u{2715}"
    local btnExp = "\u{2913}"

    for _,id in ipairs(ids) do
      if not seen[id] then
        seen[id] = true
        local s = Songs[id]
        if s then
          local display = (showOrig and s.robloxName) or s.name
          local match = true
          if searchQuery ~= "" then
            local q = searchQuery:lower()
            local haystack = (display or ""):lower() .. " " .. (s.robloxName or ""):lower() .. " " .. id
            if not haystack:find(q, 1, true) then match = false end
          end

          if match then
            count = count + 1
            local row = glass(scroll, UDim2.new(1,-2,0,34), nil, CARD_TRANS, 53, RAD_SM)
            row.MouseEnter:Connect(function() TweenService:Create(row, TweenInfo.new(0.12), {BackgroundTransparency = math.max(0,CARD_TRANS-0.12)}):Play() end)
            row.MouseLeave:Connect(function() TweenService:Create(row, TweenInfo.new(0.12), {BackgroundTransparency = CARD_TRANS}):Play() end)
            local nm = Instance.new("TextLabel"); nm.Text = display
            nm.Size = UDim2.new(1,-190,1,0); nm.Position = UDim2.new(0,10,0,0)
            nm.BackgroundTransparency = 1; nm.TextColor3 = TX
            nm.Font = FONT_REG; nm.TextSize = SZ(10)
            nm.TextXAlignment = Enum.TextXAlignment.Left
            nm.TextTruncate = Enum.TextTruncate.AtEnd
            nm.ZIndex = 54; nm.Parent = row

            local bExp = rowBtn(row, btnExp, 22, rgb(180,150,40), -184)
            local bPlay = rowBtn(row, btnPlay, 22, AC, -160)
            local bPrev = rowBtn(row, btnPrev, 22, rgb(90,90,100), -136)
            local bEdit = rowBtn(row, btnEdit, 22, rgb(90,90,100), -112)
            local bCopy = rowBtn(row, btnCopy, 22, rgb(90,90,100), -88)
            local bRem = rowBtn(row, btnRem, 22, rgb(90,90,100), -64)
            local bDel = rowBtn(row, btnDel, 22, ST, -40)

            bExp.MouseButton1Click:Connect(function()
              local success = trySaveSong(id, s.name)
              notify(success and "\u{42D}\u{43A}\u{441}\u{43F}\u{43E}\u{440}\u{442}\u{438}\u{440}\u{43E}\u{432}\u{430}\u{43D}\u{43E}" or "\u{41E}\u{448}\u{438}\u{431}\u{43A}\u{430}", success and "ok" or "danger")
            end)
            bPlay.MouseButton1Click:Connect(function() radioPlay(id) end)
            bPrev.MouseButton1Click:Connect(function() prvPlay(id) end)
            bEdit.MouseButton1Click:Connect(function()
              local box = Instance.new("TextBox"); box.Text = s.name
              box.Size = UDim2.new(1,-198,1,-8); box.Position = UDim2.new(0,8,0,4)
              box.BackgroundColor3 = BG; box.TextColor3 = TX
              box.Font = FONT_BOLD; box.TextSize = SZ(10)
              box.TextXAlignment = Enum.TextXAlignment.Left
              box.BorderSizePixel = 0; box.ZIndex = 60; box.Parent = row
              corner(box, RAD_SM)
              box.FocusLost:Connect(function()
                if box.Text ~= "" then s.name = box.Text; saveConfig() end
                renderSongs()
              end)
              box:CaptureFocus()
            end)
            bCopy.MouseButton1Click:Connect(function()
              local oldPop = gui:FindFirstChild("CopyPopup")
              if oldPop then oldPop:Destroy() end
              local btnPos = bCopy.AbsolutePosition
              local btnSize = bCopy.AbsoluteSize
              local popup = glass(gui, UDim2.new(0,140,0,4), nil, 0.05, 200, RAD_SM)
              popup.Name = "CopyPopup"
              local popLay = Instance.new("UIListLayout", popup)
              popLay.Padding = UDim.new(0,2)
              local popPad = Instance.new("UIPadding", popup)
              popPad.PaddingLeft = UDim.new(0,3); popPad.PaddingRight = UDim.new(0,3)
              popPad.PaddingTop = UDim.new(0,3); popPad.PaddingBottom = UDim.new(0,3)
              local popH = 6
              for _, tm in ipairs(TabMeta) do
                if tm.id ~= "all" then
                  popH = popH + 24
                  local opt = Instance.new("TextButton"); opt.Text = "  " .. tm.label
                  opt.Size = UDim2.new(1,0,0,22); opt.BackgroundColor3 = PANA
                  opt.BackgroundTransparency = 1
                  opt.TextColor3 = TX; opt.Font = FONT_REG; opt.TextSize = SZ(10)
                  opt.TextXAlignment = Enum.TextXAlignment.Left; opt.AutoButtonColor = false
                  opt.BorderSizePixel = 0; opt.ZIndex = 201; opt.Parent = popup
                  corner(opt, RAD_SM-3)
                  opt.MouseEnter:Connect(function() opt.BackgroundTransparency = 0.3 end)
                  opt.MouseLeave:Connect(function() opt.BackgroundTransparency = 1 end)
                  opt.MouseButton1Click:Connect(function()
                    Tabs[tm.id] = Tabs[tm.id] or {}
                    local found = false
                    for _, x in ipairs(Tabs[tm.id]) do if x == id then found = true; break end end
                    if not found then table.insert(Tabs[tm.id], id); saveConfig() end
                    popup:Destroy()
                    notify("\u{414}\u{43E}\u{431}\u{430}\u{432}\u{43B}\u{435}\u{43D}\u{43E} \u{432} " .. tm.label, "ok")
                  end)
                end
              end
              local popW = 140
              local screenH = gui.AbsoluteSize.Y
              local yPos = btnPos.Y + btnSize.Y + 2
              if yPos + popH > screenH then yPos = btnPos.Y - popH - 2 end
              popup.Size = UDim2.new(0, popW, 0, popH)
              popup.Position = UDim2.new(0, btnPos.X - popW + btnSize.X, 0, yPos)
              local closeConn
              closeConn = UIS.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                  task.wait(0.15)
                  if popup and popup.Parent then popup:Destroy() end
                  if closeConn then closeConn:Disconnect() end
                end
              end)
            end)
            bRem.MouseButton1Click:Connect(function()
              local t = Tabs[curTab] or {}
              for i,x in ipairs(t) do if x == id then table.remove(t, i); break end end
              saveConfig(); renderSongs()
            end)
            bDel.MouseButton1Click:Connect(function()
              pendingSongDelete = id
              delSong.open()
            end)
          else
            filtered = filtered + 1
          end
        end
      end
    end
    if count == 0 then
      local emptyText = (searchQuery ~= "" and ("No results for '" .. searchQuery .. "'") or "empty")
      local empty = Instance.new("TextLabel"); empty.Text = emptyText
      empty.Size = UDim2.new(1,0,0,28); empty.BackgroundTransparency = 1
      empty.TextColor3 = TXM; empty.Font = FONT_REG; empty.TextSize = SZ(11)
      empty.ZIndex = 53; empty.Parent = scroll
    end
    if countLabel then
      local txt = count .. " songs"
      if filtered > 0 then txt = txt .. " (+" .. filtered .. " hidden)" end
      countLabel.Text = "\u{B7} " .. txt
    end
  end

  local renderSearch, renderImport, renderSettings, refreshCurrentView

  refreshCurrentView = function()
    if curView == "songs" then renderSongs()
    elseif curView == "search" then renderSearch()
    elseif curView == "import" then renderImport()
    elseif curView == "settings" then renderSettings()
    end
  end

  renderSearch = function()
    for _,c in pairs(scroll:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
    cTitle.Text = "search"

    local engRow = glass(scroll, UDim2.new(1,0,0,36), nil, CARD_TRANS, 53, RAD_SM)
    engRow.Name = "SearchUI"
    local engHL = Instance.new("UIListLayout", engRow)
    engHL.FillDirection = Enum.FillDirection.Horizontal; engHL.Padding = UDim.new(0,4)
    engHL.HorizontalAlignment = Enum.HorizontalAlignment.Center
    engHL.VerticalAlignment = Enum.VerticalAlignment.Center
    local engPad = Instance.new("UIPadding", engRow)
    engPad.PaddingLeft = UDim.new(0,4); engPad.PaddingRight = UDim.new(0,4)
    local engs = {{"catalog","Catalog"},{"id","Asset ID"}}
    for idx, e in ipairs(engs) do
      local active = CFG.searchEng == e[1]
      local b = select(1, glassButton(engRow, e[2], UDim2.new(0.5,-4,1,-6), nil, active and "accent" or "ghost", 54))
      b.LayoutOrder = idx
      b.MouseButton1Click:Connect(function() CFG.searchEng = e[1]; saveConfig(); buildUI() end)
    end

    local inpRow = glass(scroll, UDim2.new(1,0,0,34), nil, CARD_TRANS, 53, RAD_SM)
    inpRow.Name = "SearchUI"
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-98,1,0); box.Position = UDim2.new(0,10,0,0)
    box.BackgroundTransparency = 1; box.TextColor3 = TX
    box.Font = FONT_REG; box.TextSize = SZ(11)
    box.PlaceholderText = CFG.searchEng == "id" and "Paste asset id..." or "Type song name..."
    box.PlaceholderColor3 = TXM
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ZIndex = 54; box.Parent = inpRow
    local go = select(1, glassButton(inpRow, "Search", UDim2.new(0,80,1,-6), UDim2.new(1,-86,0,3), "accent", 54))

    local status = Instance.new("TextLabel"); status.Name = "SearchUI"; status.Text = ""
    status.Size = UDim2.new(1,0,0,18)
    status.BackgroundTransparency = 1; status.TextColor3 = TXM
    status.Font = FONT_REG; status.TextSize = SZ(10)
    status.TextXAlignment = Enum.TextXAlignment.Left; status.ZIndex = 53; status.Parent = scroll

    local resultsContainer = Instance.new("Frame"); resultsContainer.Name = "ResultsContainer"
    resultsContainer.Size = UDim2.new(1,0,0,0); resultsContainer.BackgroundTransparency = 1
    resultsContainer.BorderSizePixel = 0; resultsContainer.ZIndex = 53; resultsContainer.Parent = scroll
    resultsContainer.AutomaticSize = Enum.AutomaticSize.Y
    local resLay = Instance.new("UIListLayout", resultsContainer); resLay.Padding = UDim.new(0,4)
    resLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
      resultsContainer.Size = UDim2.new(1,0,0,resLay.AbsoluteContentSize.Y)
    end)

    local function doCatalogSearch()
      for _,c in pairs(resultsContainer:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
      end
      local q = box.Text
      if q == "" then status.Text = "Enter a query"; return end
      local results = {}
      if CFG.searchEng == "id" then
        local cleanId = q:match("(%d+)")
        if cleanId then
          local rn = robloxNameFor(cleanId)
          table.insert(results, {id=cleanId, name=rn or ("song "..cleanId), robloxName=rn})
        end
      else
        status.Text = "Searching..."
        pcall(function()
          local params = Instance.new("AudioSearchParams")
          params.SearchKeyword = q
          local pages = AssetService:SearchAudio(params)
          if pages then
            local pageData = pages:GetCurrentPage()
            if pageData then
              for _, it in ipairs(pageData) do
                local sid = it.Id or it.id
                local sn = it.Title or it.title or it.Name or it.name
                if sid then table.insert(results, {id=tostring(sid), name=sn or ("asset "..sid), robloxName=sn}) end
              end
            end
          end
        end)
        if #results == 0 then
          pcall(function()
            local params = Instance.new("AudioSearchParams")
            params.SearchKeyword = q
            local pages = AssetService:SearchAudioAsync(params)
            if pages then
              local pageData = pages:GetCurrentPage()
              if pageData then
                for _, it in ipairs(pageData) do
                  local sid = it.Id or it.id
                  local sn = it.Title or it.title or it.Name or it.name
                  if sid then table.insert(results, {id=tostring(sid), name=sn or ("asset "..sid), robloxName=sn}) end
                end
              end
            end
          end)
        end
        if #results == 0 and q:match("^%d+$") then
          local rn = robloxNameFor(q)
          table.insert(results, {id=q, name=rn or ("song "..q), robloxName=rn})
        end
      end
      status.Text = "Found " .. #results
      for _, r in ipairs(results) do
        local row = glass(resultsContainer, UDim2.new(1,-2,0,34), nil, CARD_TRANS, 53, RAD_SM)
        row.Name = "Result"
        local nm = Instance.new("TextLabel")
        nm.Text = r.name .. " \u{B7} #" .. r.id
        nm.Size = UDim2.new(1,-134,1,0); nm.Position = UDim2.new(0,10,0,0)
        nm.BackgroundTransparency = 1; nm.TextColor3 = TX
        nm.Font = FONT_REG; nm.TextSize = SZ(10)
        nm.TextXAlignment = Enum.TextXAlignment.Left
        nm.TextTruncate = Enum.TextTruncate.AtEnd
        nm.ZIndex = 54; nm.Parent = row
        local bP = rowBtn(row, "\u{25B6}", 24, AC, -128)
        local bQ = rowBtn(row, "\u{266A}", 24, rgb(90,90,100), -100)
        local bA, bALbl = glassButton(row, "+ Add", UDim2.new(0,60,0,24), UDim2.new(1,-70,0.5,-12), "accent", 54)
        bP.MouseButton1Click:Connect(function() radioPlay(r.id) end)
        bQ.MouseButton1Click:Connect(function() prvPlay(r.id) end)
        bA.MouseButton1Click:Connect(function()
          ensureSong(r.id, r.name, "ru", false, "new")
          bALbl.Text = "OK"
          notify("\u{414}\u{43E}\u{431}\u{430}\u{432}\u{43B}\u{435}\u{43D}\u{43E}", "ok")
          task.wait(0.5)
          if bALbl and bALbl.Parent then bALbl.Text = "+ Add" end
        end)
      end
    end
    go.MouseButton1Click:Connect(doCatalogSearch)
    box.FocusLost:Connect(function(enter) if enter then doCatalogSearch() end end)
  end

  renderImport = function()
    for _,c in pairs(scroll:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
    cTitle.Text = "import"
    local tempCount = 0
    local tempList = {}
    for k,v in pairs(tempImported) do
      tempCount = tempCount + 1
      table.insert(tempList, {id=k, data=v})
    end

    local order = 0
    local function nextOrder() order = order + 1; return order end

    local statBox = glass(scroll, UDim2.new(1,-4,0,28), nil, CARD_TRANS, 53, RAD_SM)
    statBox.Name = "stat"; statBox.LayoutOrder = nextOrder()
    local statDot = Instance.new("Frame")
    statDot.Size = UDim2.new(0,8,0,8); statDot.Position = UDim2.new(0,10,0,10)
    statDot.BackgroundColor3 = importing and rgb(60,220,130) or TXM
    statDot.BorderSizePixel = 0; statDot.ZIndex = 54; statDot.Parent = statBox
    corner(statDot, UDim.new(1,0))
    local stat = Instance.new("TextLabel")
    stat.Text = importing and ("LISTENING  " .. importCount .. " caught") or ("IDLE  " .. tempCount .. " pending")
    stat.Size = UDim2.new(1,-26,1,0); stat.Position = UDim2.new(0,22,0,0)
    stat.BackgroundTransparency = 1
    stat.TextColor3 = importing and rgb(60,220,130) or TXM
    stat.Font = FONT_BOLD; stat.TextSize = SZ(10)
    stat.TextXAlignment = Enum.TextXAlignment.Left; stat.ZIndex = 54; stat.Parent = statBox
    importStatus = stat

    local btnBar = Instance.new("Frame"); btnBar.Name = "btns"
    btnBar.Size = UDim2.new(1,-4,0,30); btnBar.LayoutOrder = nextOrder()
    btnBar.BackgroundTransparency = 1; btnBar.BorderSizePixel = 0
    btnBar.ZIndex = 53; btnBar.Parent = scroll
    local btnLay = Instance.new("UIListLayout", btnBar)
    btnLay.FillDirection = Enum.FillDirection.Horizontal; btnLay.Padding = UDim.new(0,4)

    local bStart = select(1, glassButton(btnBar, "Start", UDim2.new(0,70,0,26), nil, "accent", 54))
    local bStop = select(1, glassButton(btnBar, "Stop", UDim2.new(0,70,0,26), nil, "danger", 54))
    local bClear = select(1, glassButton(btnBar, "Clear", UDim2.new(0,60,0,26), nil, "ghost", 54))
    local bAddAll = select(1, glassButton(btnBar, "+ All", UDim2.new(0,60,0,26), nil, "accent", 54))

    bStart.MouseButton1Click:Connect(function() startImport(); refreshCurrentView() end)
    bStop.MouseButton1Click:Connect(function() stopImport(); refreshCurrentView() end)
    bClear.MouseButton1Click:Connect(function() clearTempImported(); refreshCurrentView() end)
    bAddAll.MouseButton1Click:Connect(function()
      for songId, _ in pairs(tempImported) do saveImportedSong(songId) end
      refreshCurrentView()
    end)

    local autoRow = glass(scroll, UDim2.new(1,-4,0,32), nil, CARD_TRANS, 53, RAD_SM)
    autoRow.Name = "auto"; autoRow.LayoutOrder = nextOrder()
    local autoLbl = Instance.new("TextLabel"); autoLbl.Text = "Auto Import (persists across restarts)"
    autoLbl.Size = UDim2.new(1,-62,1,0); autoLbl.Position = UDim2.new(0,12,0,0)
    autoLbl.BackgroundTransparency = 1; autoLbl.TextColor3 = TX
    autoLbl.Font = FONT_BOLD; autoLbl.TextSize = SZ(10)
    autoLbl.TextXAlignment = Enum.TextXAlignment.Left; autoLbl.ZIndex = 54; autoLbl.Parent = autoRow
    local _, paintAuto = pillToggle(autoRow, UDim2.new(0,40,0,20), UDim2.new(1,-50,0.5,-10),
      function() return CFG.autoImport end,
      function(v)
        CFG.autoImport = v; saveConfig()
        if v then startImport() else stopImport() end
        refreshCurrentView()
      end, 54)

    local pendingHdr = Instance.new("TextLabel"); pendingHdr.Name = "hdr"
    pendingHdr.Text = "Imported songs (" .. tempCount .. ")"
    pendingHdr.Size = UDim2.new(1,-4,0,20); pendingHdr.LayoutOrder = nextOrder()
    pendingHdr.BackgroundTransparency = 1
    pendingHdr.TextColor3 = TX; pendingHdr.Font = FONT_BOLD; pendingHdr.TextSize = SZ(11)
    pendingHdr.TextXAlignment = Enum.TextXAlignment.Left; pendingHdr.ZIndex = 53; pendingHdr.Parent = scroll

    if tempCount == 0 then
      local empty = Instance.new("TextLabel"); empty.Name = "empty"
      empty.Text = importing and "Waiting for songs..." or "No songs. Press Start."
      empty.Size = UDim2.new(1,-4,0,24); empty.LayoutOrder = nextOrder()
      empty.BackgroundTransparency = 1
      empty.TextColor3 = TXM; empty.Font = FONT_REG; empty.TextSize = SZ(10)
      empty.ZIndex = 53; empty.Parent = scroll
    else
      for _, entry in ipairs(tempList) do
        local songId = entry.id
        local data = entry.data
        local row = glass(scroll, UDim2.new(1,-4,0,30), nil, CARD_TRANS, 53, RAD_SM)
        row.Name = "imp"; row.LayoutOrder = nextOrder()

        local nm = Instance.new("TextLabel")
        nm.Text = (data.name or songId) .. "  #" .. songId
        nm.Size = UDim2.new(1,-146,1,0); nm.Position = UDim2.new(0,8,0,0)
        nm.BackgroundTransparency = 1; nm.TextColor3 = TX
        nm.Font = FONT_REG; nm.TextSize = SZ(9)
        nm.TextXAlignment = Enum.TextXAlignment.Left
        nm.TextTruncate = Enum.TextTruncate.AtEnd
        nm.ZIndex = 54; nm.Parent = row

        local bPlay = rowBtn(row, "\u{25B6}", 24, AC, -140)
        local bPrev = rowBtn(row, "\u{266A}", 24, rgb(90,90,100), -112)
        local bAdd = rowBtn(row, "+", 22, rgb(40,150,90), -86)
        local bExp = rowBtn(row, "\u{2913}", 24, rgb(180,150,40), -58)
        local bRem = rowBtn(row, "\u{2715}", 22, ST, -30)

        bPlay.MouseButton1Click:Connect(function() radioPlay(songId) end)
        bPrev.MouseButton1Click:Connect(function() prvPlay(songId) end)
        bAdd.MouseButton1Click:Connect(function()
          if saveImportedSong(songId) then
            notify("\u{414}\u{43E}\u{431}\u{430}\u{432}\u{43B}\u{435}\u{43D}\u{43E}", "ok")
            task.wait(0.15); refreshCurrentView()
          end
        end)
        bExp.MouseButton1Click:Connect(function()
          local success = trySaveSong(songId, data.name or songId)
          notify(success and "\u{42D}\u{43A}\u{441}\u{43F}\u{43E}\u{440}\u{442}\u{438}\u{440}\u{43E}\u{432}\u{430}\u{43D}\u{43E}" or "\u{41E}\u{448}\u{438}\u{431}\u{43A}\u{430}", success and "ok" or "danger")
        end)
        bRem.MouseButton1Click:Connect(function()
          tempImported[songId] = nil; refreshCurrentView()
        end)
      end
    end
  end

  renderSettings = function()
    for _,c in pairs(scroll:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
    cTitle.Text = "settings"

    local thCols = 3
    local thRows = math.ceil(#TH / thCols)
    local thBoxHeight = 30 + thRows*30 + 10
    local thBox = glass(scroll, UDim2.new(1,0,0,thBoxHeight), nil, CARD_TRANS, 53, RAD_CARD)
    local thL = Instance.new("TextLabel")
    thL.Text = T("themeLabel")
    thL.Size = UDim2.new(1,-16,0,18); thL.Position = UDim2.new(0,10,0,6)
    thL.BackgroundTransparency = 1; thL.TextColor3 = TX
    thL.Font = FONT_BOLD; thL.TextSize = SZ(11)
    thL.TextXAlignment = Enum.TextXAlignment.Left; thL.ZIndex = 54; thL.Parent = thBox
    for i, t in ipairs(TH) do
      local col = (i-1) % thCols
      local rowN = math.floor((i-1)/thCols)
      local tb = Instance.new("TextButton"); tb.Text = ""; tb.AutoButtonColor = false
      tb.Size = UDim2.new(0,98,0,26)
      tb.Position = UDim2.new(0,10+col*103,0,30+rowN*30)
      tb.BackgroundColor3 = t[5]; tb.BorderSizePixel = 0; tb.ZIndex = 54; tb.Parent = thBox
      corner(tb, RAD_SM)
      local tbLbl = Instance.new("TextLabel"); tbLbl.Text = t[1]
      tbLbl.Size = UDim2.new(1,0,1,0); tbLbl.BackgroundTransparency = 1
      tbLbl.TextColor3 = t[7]; tbLbl.Font = FONT_BOLD; tbLbl.TextSize = SZ(10)
      tbLbl.ZIndex = 55; tbLbl.Parent = tb
      if i == CFG.theme then
        local s2 = Instance.new("UIStroke", tb); s2.Color = Color3.new(1,1,1); s2.Thickness = 2
      end
      tb.MouseButton1Click:Connect(function() CFG.theme = i; saveConfig(); buildUI()
        task.defer(function() if main and main.Parent then main.Visible = true; main.Position = UDim2.new(0.07,0,0.04,0) end end)
      end)
    end

    local function toggle(label, getter, setter, doFullRebuild)
      local row = glass(scroll, UDim2.new(1,0,0,32), nil, CARD_TRANS, 53, RAD_SM)
      local lbl = Instance.new("TextLabel"); lbl.Text = label
      lbl.Size = UDim2.new(1,-62,1,0); lbl.Position = UDim2.new(0,12,0,0)
      lbl.BackgroundTransparency = 1; lbl.TextColor3 = TX
      lbl.Font = FONT_BOLD; lbl.TextSize = SZ(10)
      lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 54; lbl.Parent = row
      local _, paint = pillToggle(row, UDim2.new(0,40,0,20), UDim2.new(1,-50,0.5,-10), getter, function(v)
        setter(v); saveConfig()
        if doFullRebuild then buildUI() else refreshCurrentView() end
      end, 54)
    end
    toggle(T("useEmoji"), function() return CFG.useEmoji end, function(v) CFG.useEmoji = v end, false)
    toggle(T("showOriginal"), function() return CFG.showOriginal end,
      function(v) CFG.showOriginal = v; showOrig = v end, false)
    toggle(T("autoImport"), function() return CFG.autoImport end,
      function(v) CFG.autoImport = v; if v then startImport() else stopImport() end end, false)
    toggle(T("roundedCorners"), function() return CFG.corner > 0 end,
      function(v) CFG.corner = v and 10 or 0 end, true)
    toggle(T("useBlurLabel"), function() return CFG.useBlur end,
      function(v) CFG.useBlur = v; if not v then menuBlur.Size = 0 end end, false)

    local opWrap = glass(scroll, UDim2.new(1,0,0,50), nil, CARD_TRANS, 53, RAD_SM)
    local opLbl = Instance.new("TextLabel"); opLbl.Text = T("opacityLabel") .. " (" .. math.floor(CFG.menuOpacity*100) .. "%)"
    opLbl.Size = UDim2.new(1,-20,0,16); opLbl.Position = UDim2.new(0,10,0,6)
    opLbl.BackgroundTransparency = 1
    opLbl.TextColor3 = TXM; opLbl.Font = FONT_BOLD; opLbl.TextSize = SZ(9)
    opLbl.TextXAlignment = Enum.TextXAlignment.Left; opLbl.ZIndex = 54; opLbl.Parent = opWrap

    local opSlider = Instance.new("Frame"); opSlider.Size = UDim2.new(1,-20,0,20)
    opSlider.Position = UDim2.new(0,10,0,26)
    opSlider.BackgroundTransparency = 1; opSlider.ZIndex = 54; opSlider.Parent = opWrap
    local opTrack = Instance.new("Frame"); opTrack.Size = UDim2.new(1,0,0,6)
    opTrack.Position = UDim2.new(0,0,0.5,-3)
    opTrack.BackgroundColor3 = rgb(80,80,92); opTrack.BorderSizePixel = 0; opTrack.ZIndex = 54; opTrack.Parent = opSlider
    corner(opTrack, UDim.new(1,0))
    local opFill = Instance.new("Frame"); opFill.Size = UDim2.new(CFG.menuOpacity,0,1,0)
    opFill.BackgroundColor3 = AC; opFill.BorderSizePixel = 0; opFill.ZIndex = 55; opFill.Parent = opTrack
    corner(opFill, UDim.new(1,0))
    local opKnob = Instance.new("Frame"); opKnob.Size = UDim2.new(0,18,0,18)
    opKnob.AnchorPoint = Vector2.new(0.5,0.5)
    opKnob.Position = UDim2.new(CFG.menuOpacity,0,0.5,0)
    opKnob.BackgroundColor3 = Color3.new(1,1,1); opKnob.BorderSizePixel = 0
    opKnob.ZIndex = 56; opKnob.Parent = opSlider
    corner(opKnob, UDim.new(1,0))

    local opDragging = false
    local function setOpacity(px)
      local abs = opSlider.AbsoluteSize.X
      local rel = math.clamp(px / math.max(abs,1), 0.15, 1)
      CFG.menuOpacity = rel
      opFill.Size = UDim2.new(rel,0,1,0)
      opKnob.Position = UDim2.new(rel,0,0.5,0)
      opLbl.Text = T("opacityLabel") .. " (" .. math.floor(rel*100) .. "%)"
    end
    local function beginDrag(input)
      opDragging = true
      local relX = input.Position.X - opSlider.AbsolutePosition.X
      setOpacity(relX)
    end
    opKnob.InputBegan:Connect(function(i)
      if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then beginDrag(i) end
    end)
    opTrack.InputBegan:Connect(function(i)
      if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then beginDrag(i) end
    end)
    UIS.InputChanged:Connect(function(i)
      if opDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local relX = i.Position.X - opSlider.AbsolutePosition.X
        setOpacity(relX)
      end
    end)
    UIS.InputEnded:Connect(function(i)
      if opDragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
        opDragging = false
        saveConfig()
        main.BackgroundTransparency = math.clamp(0.10 + (1-CFG.menuOpacity)*0.75, 0.10, 0.88)
      end
    end)

    local function action(label, col, cb)
      local b, lbl = glassButton(scroll, label, UDim2.new(1,0,0,32), nil, "ghost", 53)
      b.MouseButton1Click:Connect(function() cb(b, lbl) end)
      return b, lbl
    end
    action(T("fixScroll"), nil, function(b, lbl)
      lbl.Text = "..."; fixScroll(); lbl.Text = "Done"; task.wait(1); lbl.Text = T("fixScroll")
    end)
    action(T("exportAll"), nil, function(b, lbl)
      local n, total, fails = 0, 0, 0
      for _ in pairs(Songs) do total = total + 1 end
      for id, s in pairs(Songs) do
        n = n + 1
        if not trySaveSong(id, s.name) then fails = fails + 1 end
        lbl.Text = n.."/"..total; task.wait(0.3)
      end
      lbl.Text = fails > 0 and ("Done ("..fails.." failed)") or "Done"
      task.wait(1.2); lbl.Text = T("exportAll")
    end)

    -- ===== custom style: colors / hex / background gradients =====
    local function reopenAfterRebuild()
      saveConfig(); buildUI()
      task.defer(function()
        if main and main.Parent then main.Visible = true; main.Position = UDim2.new(0.07,0,0.04,0) end
      end)
    end

    local styleHdr = Instance.new("TextLabel"); styleHdr.Text = T("customStyleHdr")
    styleHdr.Size = UDim2.new(1,0,0,22); styleHdr.BackgroundTransparency = 1
    styleHdr.TextColor3 = TX; styleHdr.Font = FONT_BOLD; styleHdr.TextSize = SZ(13)
    styleHdr.TextXAlignment = Enum.TextXAlignment.Left; styleHdr.ZIndex = 53; styleHdr.Parent = scroll

    toggle(T("useCustomColorsLabel"), function() return CFG.useCustomColors end,
      function(v) CFG.useCustomColors = v end, true)

    local function hexRow(label, slotKey, currentColor)
      local row = glass(scroll, UDim2.new(1,0,0,36), nil, CARD_TRANS, 53, RAD_SM)
      local lbl = Instance.new("TextLabel"); lbl.Text = label
      lbl.Size = UDim2.new(0,58,1,0); lbl.Position = UDim2.new(0,10,0,0)
      lbl.BackgroundTransparency = 1; lbl.TextColor3 = TX
      lbl.Font = FONT_BOLD; lbl.TextSize = SZ(10)
      lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 54; lbl.Parent = row

      local swatch = Instance.new("Frame")
      swatch.Size = UDim2.new(0,22,0,22); swatch.Position = UDim2.new(0,66,0.5,-11)
      swatch.BackgroundColor3 = currentColor
      swatch.BorderSizePixel = 0; swatch.ZIndex = 54; swatch.Parent = row
      corner(swatch, UDim.new(1,0))
      local swStroke = Instance.new("UIStroke", swatch); swStroke.Color = Color3.new(1,1,1); swStroke.Transparency = 0.6; swStroke.Thickness = 1

      local box = Instance.new("TextBox")
      box.Size = UDim2.new(0,80,0,26); box.Position = UDim2.new(0,96,0.5,-13)
      box.BackgroundColor3 = BG; box.BackgroundTransparency = 0.2; box.TextColor3 = TX
      box.Font = Enum.Font.Code; box.TextSize = SZ(11)
      box.Text = "#" .. color3ToHex(currentColor)
      box.ClearTextOnFocus = false
      box.ZIndex = 54; box.Parent = row
      corner(box, RAD_SM-3)

      local applyBtn = select(1, glassButton(row, "OK", UDim2.new(0,38,0,26), UDim2.new(1,-46,0.5,-13), "accent", 54))

      local function apply()
        local col = hexToColor3(box.Text)
        if col then
          CFG.customColors = CFG.customColors or {}
          CFG.customColors[slotKey] = color3ToHex(col)
          CFG.useCustomColors = true
          reopenAfterRebuild()
        else
          box.Text = "#" .. color3ToHex(currentColor)
        end
      end
      applyBtn.MouseButton1Click:Connect(apply)
      box.FocusLost:Connect(function(enter) if enter then apply() end end)
    end

    hexRow(T("accentLabel"), "accent", AC)
    hexRow(T("bgColorLabel"), "bg", BG)
    hexRow(T("panelLabel"), "panel", PAN)
    hexRow(T("textColorLabel"), "text", TX)

    local bgRow = glass(scroll, UDim2.new(1,0,0,36), nil, CARD_TRANS, 53, RAD_SM)
    local bgLbl = Instance.new("TextLabel"); bgLbl.Text = T("bgPresetLabel")
    bgLbl.Size = UDim2.new(0,110,1,0); bgLbl.Position = UDim2.new(0,10,0,0)
    bgLbl.BackgroundTransparency = 1; bgLbl.TextColor3 = TX
    bgLbl.Font = FONT_BOLD; bgLbl.TextSize = SZ(10)
    bgLbl.TextXAlignment = Enum.TextXAlignment.Left; bgLbl.ZIndex = 54; bgLbl.Parent = bgRow

    local bgPickBtn, bgPickLbl = glassButton(bgRow,
      (CFG.bgPreset and BG_PRESETS[CFG.bgPreset] and BG_PRESETS[CFG.bgPreset].name) or T("bgPresetDefault"),
      UDim2.new(0,140,0,26), UDim2.new(1,-148,0.5,-13), "ghost", 54)
    bgPickLbl.TextTruncate = Enum.TextTruncate.AtEnd

    bgPickBtn.MouseButton1Click:Connect(function()
      local oldPop = gui:FindFirstChild("BgPopup")
      if oldPop then oldPop:Destroy() end
      local btnPos = bgPickBtn.AbsolutePosition
      local btnSize = bgPickBtn.AbsoluteSize
      local rowH = 26
      local totalItems = #BG_PRESETS + 1
      local totalH = totalItems * (rowH+3) + 6
      local maxPopH = 230
      local popH = math.min(totalH, maxPopH)

      local popup = glass(gui, UDim2.new(0,170,0,popH), nil, 0.05, 200, RAD_CARD)
      popup.Name = "BgPopup"

      local listArea = Instance.new("ScrollingFrame")
      listArea.Size = UDim2.new(1,-6,1,-6); listArea.Position = UDim2.new(0,3,0,3)
      listArea.BackgroundTransparency = 1; listArea.BorderSizePixel = 0
      listArea.ScrollBarThickness = 3; listArea.ScrollBarImageColor3 = AC
      listArea.CanvasSize = UDim2.new(0,0,0,totalH)
      listArea.ZIndex = 201; listArea.Parent = popup
      local popLay = Instance.new("UIListLayout", listArea)
      popLay.Padding = UDim.new(0,3)

      local function optionRow(name, swatchColor, onClick)
        local opt = Instance.new("TextButton"); opt.Text = "  " .. name
        opt.Size = UDim2.new(1,-4,0,rowH); opt.BackgroundColor3 = PANA
        opt.BackgroundTransparency = 1; opt.AutoButtonColor = false
        opt.TextColor3 = TX; opt.Font = FONT_REG; opt.TextSize = SZ(10)
        opt.TextXAlignment = Enum.TextXAlignment.Left; opt.BorderSizePixel = 0
        opt.ZIndex = 202; opt.Parent = listArea
        corner(opt, RAD_SM-3)
        if swatchColor then
          local sw = Instance.new("Frame")
          sw.Size = UDim2.new(0,14,0,14); sw.Position = UDim2.new(1,-22,0.5,-7)
          sw.BackgroundColor3 = swatchColor; sw.BorderSizePixel = 0
          sw.ZIndex = 203; sw.Parent = opt
          corner(sw, UDim.new(1,0))
        end
        opt.MouseEnter:Connect(function() opt.BackgroundTransparency = 0.3 end)
        opt.MouseLeave:Connect(function() opt.BackgroundTransparency = 1 end)
        opt.MouseButton1Click:Connect(onClick)
      end

      optionRow(T("bgPresetDefault"), nil, function()
        CFG.bgPreset = nil; popup:Destroy(); reopenAfterRebuild()
      end)
      for pi, preset in ipairs(BG_PRESETS) do
        optionRow(preset.name, preset.stops[1], function()
          CFG.bgPreset = pi; popup:Destroy(); reopenAfterRebuild()
        end)
      end

      local popW = 170
      local screenH = gui.AbsoluteSize.Y
      local yPos = btnPos.Y + btnSize.Y + 2
      if yPos + popH > screenH then yPos = math.max(4, btnPos.Y - popH - 2) end
      popup.Position = UDim2.new(0, btnPos.X - popW + btnSize.X, 0, yPos)

      local closeConn
      closeConn = UIS.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
          task.wait(0.15)
          if popup and popup.Parent then popup:Destroy() end
          if closeConn then closeConn:Disconnect() end
        end
      end)
    end)

    action(T("resetColorsLabel"), nil, function(b, lbl)
      CFG.customColors = nil; CFG.useCustomColors = false; CFG.bgPreset = nil
      reopenAfterRebuild()
    end)

    local function pickerRow(title, options, getIdx, onPick, boxW)
      local hdrLbl = Instance.new("TextLabel"); hdrLbl.Text = title
      hdrLbl.Size = UDim2.new(1,0,0,16); hdrLbl.BackgroundTransparency = 1
      hdrLbl.TextColor3 = TXM; hdrLbl.Font = FONT_BOLD; hdrLbl.TextSize = SZ(9)
      hdrLbl.TextXAlignment = Enum.TextXAlignment.Left; hdrLbl.ZIndex = 53; hdrLbl.Parent = scroll
      local rowFrame = glass(scroll, UDim2.new(1,0,0,32), nil, CARD_TRANS, 53, RAD_SM)
      local rl = Instance.new("UIListLayout", rowFrame)
      rl.FillDirection = Enum.FillDirection.Horizontal; rl.Padding = UDim.new(0,4)
      local rPad = Instance.new("UIPadding", rowFrame)
      rPad.PaddingLeft = UDim.new(0,3); rPad.PaddingTop = UDim.new(0,3); rPad.PaddingBottom = UDim.new(0,3)
      for oi, opt in ipairs(options) do
        local active = getIdx() == oi
        local ob = select(1, glassButton(rowFrame, opt, UDim2.new(0, boxW, 1, -6), nil, active and "accent" or "ghost", 54))
        ob.MouseButton1Click:Connect(function() onPick(oi) end)
      end
    end

    local fontNames = {}
    for _, fo in ipairs(FONT_OPTIONS) do table.insert(fontNames, fo[1]) end
    pickerRow(T("fontLabel"), fontNames, function() return CFG.font end, function(oi)
      CFG.font = oi; reopenAfterRebuild()
    end, 76)

    pickerRow(T("sizeLabel"), SCALE_LABELS, function() return CFG.textScale end, function(oi)
      CFG.textScale = oi; reopenAfterRebuild()
    end, 48)

    pickerRow(T("langLabel"), {"RU","EN"}, function() return CFG.lang2 == "ru" and 1 or 2 end, function(oi)
      CFG.lang2 = oi == 1 and "ru" or "en"; reopenAfterRebuild()
    end, 48)

    local brokenHdr = Instance.new("TextLabel"); brokenHdr.Text = T("brokenHdr")
    brokenHdr.Size = UDim2.new(1,0,0,20); brokenHdr.BackgroundTransparency = 1
    brokenHdr.TextColor3 = TX; brokenHdr.Font = FONT_BOLD; brokenHdr.TextSize = SZ(12)
    brokenHdr.TextXAlignment = Enum.TextXAlignment.Left; brokenHdr.ZIndex = 53; brokenHdr.Parent = scroll

    local scanBtn, scanLbl = glassButton(scroll, T("brokenScan"), UDim2.new(1,0,0,32), nil, "ghost", 53)
    scanBtn.MouseButton1Click:Connect(function()
      scanLbl.Text = "0/0"
      scanForBroken(function(i, total) scanLbl.Text = i.."/"..total end, function()
        scanLbl.Text = T("brokenScan")
        refreshCurrentView()
      end)
    end)

    local brokenAny = false
    for id,_ in pairs(BrokenTracks) do
      if Songs[id] then
        brokenAny = true
        local row = glass(scroll, UDim2.new(1,0,0,34), nil, CARD_TRANS, 53, RAD_SM)
        local nm = Instance.new("TextLabel"); nm.Text = Songs[id].name
        nm.Size = UDim2.new(1,-134,1,0); nm.Position = UDim2.new(0,10,0,0)
        nm.BackgroundTransparency = 1; nm.TextColor3 = ST
        nm.Font = FONT_REG; nm.TextSize = SZ(10)
        nm.TextXAlignment = Enum.TextXAlignment.Left; nm.TextTruncate = Enum.TextTruncate.AtEnd
        nm.ZIndex = 54; nm.Parent = row
        local okBtn = rowBtn(row, "\u{2713}", 26, rgb(90,90,100), -122)
        local rmBtn = rowBtn(row, "\u{2715}", 26, ST, -92)
        okBtn.MouseButton1Click:Connect(function() BrokenTracks[id] = nil; saveBroken(); refreshCurrentView() end)
        rmBtn.MouseButton1Click:Connect(function()
          Songs[id] = nil; BrokenTracks[id] = nil
          for _,t in pairs(Tabs) do
            for i = #t, 1, -1 do if t[i] == id then table.remove(t, i) end end
          end
          rebuildAll(); saveConfig(); saveBroken(); refreshCurrentView()
        end)
      end
    end
    if not brokenAny then
      local emptyLbl = Instance.new("TextLabel")
      emptyLbl.Text = scanningBroken and "..." or T("brokenNone")
      emptyLbl.Size = UDim2.new(1,0,0,22); emptyLbl.BackgroundTransparency = 1
      emptyLbl.TextColor3 = TXM; emptyLbl.Font = FONT_REG; emptyLbl.TextSize = SZ(10)
      emptyLbl.ZIndex = 53; emptyLbl.Parent = scroll
    end
  end

  local bar = glass(main, UDim2.new(1,-16,0,38), UDim2.new(0,8,1,-46), CARD_TRANS+0.04, 51, RAD_SM)
  local subViews = {{"songs","songs"},{"search","search"},{"import","import"},{"settings","settings"}}
  local barLay = Instance.new("UIListLayout", bar)
  barLay.FillDirection = Enum.FillDirection.Horizontal; barLay.Padding = UDim.new(0,3)
  local barPad = Instance.new("UIPadding", bar)
  barPad.PaddingLeft = UDim.new(0,4); barPad.PaddingRight = UDim.new(0,60)
  barPad.PaddingTop = UDim.new(0,4); barPad.PaddingBottom = UDim.new(0,4)
  for i, sv in ipairs(subViews) do
    local active = curView == sv[1]
    local b = Instance.new("TextButton"); b.Text = ""
    b.Size = UDim2.new(0,68,1,0); b.AutoButtonColor = false; b.BorderSizePixel = 0
    b.BackgroundColor3 = active and AC or PAN
    b.BackgroundTransparency = active and 0.05 or 1
    b.ZIndex = 52; b.Parent = bar
    corner(b, RAD_SM-2)
    local lbl = Instance.new("TextLabel"); lbl.Text = sv[2]
    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
    lbl.TextColor3 = active and Color3.new(1,1,1) or TXM
    lbl.Font = FONT_BOLD; lbl.TextSize = SZ(10)
    lbl.ZIndex = 53; lbl.Parent = b
    b.MouseButton1Click:Connect(function() curView = sv[1]; buildUI() end)
  end

  local stopTrack = Instance.new("Frame")
  stopTrack.Size = UDim2.new(0,44,0,22); stopTrack.Position = UDim2.new(1,-50,0.5,-11)
  stopTrack.BackgroundColor3 = rgb(40,170,100); stopTrack.BorderSizePixel = 0
  stopTrack.ZIndex = 52; stopTrack.Parent = bar
  corner(stopTrack, UDim.new(1,0))
  local stopKnob = Instance.new("TextButton")
  stopKnob.Size = UDim2.new(0,18,0,18); stopKnob.Position = UDim2.new(1,-20,0,2)
  stopKnob.BackgroundColor3 = Color3.new(1,1,1)
  stopKnob.Text = ""; stopKnob.AutoButtonColor = false; stopKnob.BorderSizePixel = 0
  stopKnob.ZIndex = 53; stopKnob.Parent = stopTrack
  corner(stopKnob, UDim.new(1,0))
  local playing = false
  stopKnob.MouseButton1Click:Connect(function()
    playing = not playing
    if playing then
      radioStop()
      TweenService:Create(stopTrack, TweenInfo.new(0.15), {BackgroundColor3 = ST}):Play()
      TweenService:Create(stopKnob, TweenInfo.new(0.15), {Position = UDim2.new(0,2,0,2)}):Play()
    else
      TweenService:Create(stopTrack, TweenInfo.new(0.15), {BackgroundColor3 = rgb(40,170,100)}):Play()
      TweenService:Create(stopKnob, TweenInfo.new(0.15), {Position = UDim2.new(1,-20,0,2)}):Play()
    end
  end)

  local sideOk, sideErr = pcall(renderSidebar)
  if not sideOk then warn("[RiseUltimate] renderSidebar error: " .. tostring(sideErr)) end
  refreshCurrentView()

  if bHelp then
    bHelp.MouseButton1Click:Connect(function() curView = "import"; buildUI() end)
  end
  bSet.MouseButton1Click:Connect(function() curView = "settings"; buildUI() end)

  elseif activeApp == "scripts" then

  local content = Instance.new("Frame")
  content.Size = UDim2.new(1,-28,1,-160); content.Position = UDim2.new(0,14,0,88)
  content.BackgroundTransparency = 1; content.ZIndex = 51; content.Parent = main

  local scriptsSubHeader = Instance.new("Frame")
  scriptsSubHeader.Size = UDim2.new(1,0,0,32)
  scriptsSubHeader.BackgroundTransparency = 1
  scriptsSubHeader.ZIndex = 52
  scriptsSubHeader.Parent = content

  local backBtn, backLbl = glassButton(scriptsSubHeader, "\u{2039} Root", UDim2.new(0,64,1,0), nil, "ghost", 53)
  backBtn.Visible = false

  local pathLabel = Instance.new("TextLabel")
  pathLabel.BackgroundTransparency = 1
  pathLabel.Position = UDim2.new(0,72,0,0)
  pathLabel.Size = UDim2.new(1,-150,1,0)
  pathLabel.Text = "Root"
  pathLabel.TextSize = SZ(12)
  pathLabel.Font = FONT_BOLD
  pathLabel.TextColor3 = TX
  pathLabel.TextXAlignment = Enum.TextXAlignment.Left
  pathLabel.ZIndex = 53
  pathLabel.Parent = scriptsSubHeader

  local newFolderBtn = select(1, glassButton(scriptsSubHeader, "+ Folder", UDim2.new(0,72,1,0), UDim2.new(1,-72,0,0), "ghost", 53))

  local scroll = Instance.new("ScrollingFrame")
  scroll.Size = UDim2.new(1,0,1,-82); scroll.Position = UDim2.new(0,0,0,38)
  scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 3
  scroll.ScrollBarImageColor3 = AC; scroll.ZIndex = 52; scroll.Parent = conte
