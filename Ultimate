-- Rise Ultimate v2 - Radio Ultimate + Scripts + ServerSaver, one shell, 3 tabs on top.
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
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

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
  font = 1, textScale = 2, lang2 = "ru",
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

local function addDots(parent, color, num)
  for i = 1, (num or 70) do
    local d = Instance.new("Frame")
    d.Size = UDim2.new(0,2,0,2)
    d.Position = UDim2.new(math.random()*0.98, 0, math.random()*0.98, 0)
    d.BackgroundColor3 = color
    d.BackgroundTransparency = 0.82 + math.random()*0.08
    d.BorderSizePixel = 0
    d.ZIndex = parent.ZIndex
    d.Parent = parent
    Instance.new("UICorner", d).CornerRadius = UDim.new(1,0)
  end
end

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

local buildUI

buildUI = function()
  local old = PG:FindFirstChild("MM2Radio")
  if old then old:Destroy() end

  local T = TH[CFG.theme] or TH[1]
  local BG,PAN,PANA,AC,ACS,TX,TXM,BD,ST,DOT,GRAD = T[2],T[3],T[4],T[5],T[6],T[7],T[8],T[9],T[10],T[11],T[12]
  local CR = CFG.corner or 10
  local FO = FONT_OPTIONS[CFG.font] or FONT_OPTIONS[1]
  local FONT_BOLD, FONT_REG = FO[2], FO[3]
  local SCALE = SCALE_OPTIONS[CFG.textScale] or 1.0
  local function SZ(n) return math.floor(n*SCALE + 0.5) end

  local gui = Instance.new("ScreenGui"); gui.Name = "MM2Radio"
  gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  gui.Parent = PG

  local tog = Instance.new("TextButton")
  tog.Size = UDim2.new(0,42,0,42); tog.Position = UDim2.new(0,10,0.5,-21)
  tog.BackgroundColor3 = AC; tog.Text = ""; tog.AutoButtonColor = false
  tog.BorderSizePixel = 0; tog.ZIndex = 100; tog.Parent = gui
  Instance.new("UICorner", tog).CornerRadius = UDim.new(0,CR)

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
    bar.BackgroundColor3 = Color3.new(1,1,1)
    bar.BorderSizePixel = 0
    bar.ZIndex = 101
    bar.Parent = barsHolder
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)
  end

  local main = Instance.new("Frame"); main.Name = "Main"
  main.Size = UDim2.new(0.86,0,0.82,0)
  main.Position = UDim2.new(0.07,0,-0.95,0)
  main.BackgroundColor3 = BG; main.BorderSizePixel = 0
  main.Visible = false; main.ZIndex = 50; main.Parent = gui
  Instance.new("UICorner", main).CornerRadius = UDim.new(0,CR)
  local mainStroke = Instance.new("UIStroke", main)
  mainStroke.Color = BD; mainStroke.Thickness = 1; mainStroke.Transparency = 0.2
  local mainGrad = Instance.new("UIGradient", main)
  mainGrad.Rotation = (CFG.theme * 37) % 360
  if GRAD then
    local kp = {}
    for gi, col in ipairs(GRAD) do
      table.insert(kp, ColorSequenceKeypoint.new((gi-1)/(#GRAD-1), col))
    end
    mainGrad.Color = ColorSequence.new(kp)
  else
    mainGrad.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, BG),
      ColorSequenceKeypoint.new(1, PAN),
    })
  end
  addDots(main, DOT, 80)

  local hdr = Instance.new("Frame"); hdr.Size = UDim2.new(1,0,0,42)
  hdr.BackgroundTransparency = 1; hdr.ZIndex = 51; hdr.Parent = main
  local ttl = Instance.new("TextLabel")
  local titleText = "radio.ultimate"
  if activeApp == "scripts" then titleText = "rise.scripts"
  elseif activeApp == "servers" then titleText = "rise.servers"
  elseif activeApp == "explorer" then titleText = "rise.explorer" end
  ttl.Text = titleText
  ttl.Size = UDim2.new(0,160,1,0); ttl.Position = UDim2.new(0,14,0,0)
  ttl.BackgroundTransparency = 1; ttl.Font = FONT_BOLD; ttl.TextSize = SZ(18)
  ttl.TextColor3 = TX; ttl.TextXAlignment = Enum.TextXAlignment.Left; ttl.ZIndex = 52; ttl.Parent = hdr
  local sub = Instance.new("TextLabel")
  local subText = "mm2 \u{B7} v11"
  if activeApp == "scripts" then subText = "folders \u{B7} loader"
  elseif activeApp == "servers" then subText = "jobid \u{B7} teleport"
  elseif activeApp == "explorer" then subText = "tree \u{B7} properties" end
  sub.Text = subText
  sub.Size = UDim2.new(0,140,1,0); sub.Position = UDim2.new(0,158,0,2)
  sub.BackgroundTransparency = 1; sub.Font = Enum.Font.Code; sub.TextSize = SZ(9)
  sub.TextColor3 = TXM; sub.TextXAlignment = Enum.TextXAlignment.Left; sub.ZIndex = 52; sub.Parent = hdr

  local liveDot = Instance.new("Frame")
  liveDot.Size = UDim2.new(0,6,0,6); liveDot.Position = UDim2.new(0,302,0.5,-3)
  liveDot.BackgroundColor3 = importing and rgb(34,197,94) or TXM
  liveDot.BorderSizePixel = 0; liveDot.ZIndex = 52; liveDot.Parent = hdr
  Instance.new("UICorner", liveDot).CornerRadius = UDim.new(1,0)
  task.spawn(function()
    while liveDot and liveDot.Parent do
      local c = importing and rgb(34,197,94) or TXM
      TweenService:Create(liveDot, TweenInfo.new(0.7), {BackgroundColor3=c, BackgroundTransparency=0.5, Size=UDim2.new(0,5,0,5)}):Play()
      task.wait(0.7)
      TweenService:Create(liveDot, TweenInfo.new(0.7), {BackgroundColor3=c, BackgroundTransparency=0, Size=UDim2.new(0,6,0,6)}):Play()
      task.wait(0.7)
    end
  end)
  if CFG.autoImport then
    local autoLbl = Instance.new("TextLabel")
    autoLbl.Text = "AUTO"
    autoLbl.Size = UDim2.new(0,40,0,12); autoLbl.Position = UDim2.new(0,312,0.5,-6)
    autoLbl.BackgroundTransparency = 1; autoLbl.Font = Enum.Font.Code; autoLbl.TextSize = SZ(8)
    autoLbl.TextColor3 = rgb(34,197,94); autoLbl.TextXAlignment = Enum.TextXAlignment.Left
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
    TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
      {Position = UDim2.new(0.07,0,0.09,0)}):Play()
  end
  hideMain = function()
    local tw = TweenService:Create(main, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
      {Position = UDim2.new(0.07,0,-0.95,0)})
    tw:Play()
    tw.Completed:Connect(function() main.Visible = false end)
  end

  local function hdrBtn(txt, xOff, bgCol, txtCol)
    local b = Instance.new("TextButton"); b.Text = txt
    b.Size = UDim2.new(0,30,0,26); b.Position = UDim2.new(1,xOff,0,8)
    b.BackgroundColor3 = bgCol or PAN; b.TextColor3 = txtCol or TX
    b.Font = FONT_BOLD; b.TextSize = SZ(11)
    b.BorderSizePixel = 0; b.ZIndex = 52; b.Parent = hdr
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
  end
  local bMin = hdrBtn("-", -118)
  local bHelp = nil
  if activeApp == "radio" then bHelp = hdrBtn("?", -86) end
  local bSet = hdrBtn("Set", -54)
  local bX = hdrBtn("X", -20, ST, Color3.new(1,1,1))

  local globalBar = Instance.new("Frame")
  globalBar.Size = UDim2.new(1,-28,0,24)
  globalBar.Position = UDim2.new(0,14,0,44)
  globalBar.BackgroundTransparency = 1
  globalBar.ZIndex = 51
  globalBar.Parent = main
  local gLay = Instance.new("UIListLayout", globalBar)
  gLay.FillDirection = Enum.FillDirection.Horizontal
  gLay.Padding = UDim.new(0,6)

  local function globalTabBtn(label, id)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1/4,-4,1,0)
    b.Text = label
    local active = activeApp == id
    b.BackgroundColor3 = active and AC or PANA
    b.TextColor3 = active and Color3.new(1,1,1) or TXM
    b.Font = FONT_BOLD; b.TextSize = SZ(10)
    b.BorderSizePixel = 0; b.ZIndex = 52; b.Parent = globalBar
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(function()
      if activeApp ~= id then
        activeApp = id; CFG.activeApp = id; saveConfig(); buildUI()
        task.defer(function()
          if main and main.Parent then main.Visible = true; main.Position = UDim2.new(0.07,0,0.09,0) end
        end)
      end
    end)
    return b
  end
  globalTabBtn("Radio", "radio")
  globalTabBtn("Scripts", "scripts")
  globalTabBtn("Servers", "servers")
  globalTabBtn("Explorer", "explorer")

  if activeApp == "radio" then

  local side = Instance.new("ScrollingFrame")
  side.Size = UDim2.new(0,150,1,-148); side.Position = UDim2.new(0,8,0,76)
  side.BackgroundTransparency = 1; side.BorderSizePixel = 0; side.ScrollBarThickness = 0
  side.ZIndex = 51; side.Parent = main
  local sideLay = Instance.new("UIListLayout"); sideLay.Padding = UDim.new(0,2); sideLay.Parent = side
  sideLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    side.CanvasSize = UDim2.new(0,0,0,sideLay.AbsoluteContentSize.Y+4)
  end)

  local function renderSidebar()
    for _,c in pairs(side:GetChildren()) do
      if c:IsA("TextButton") or c:IsA("TextBox") or c:IsA("Frame") then c:Destroy() end
    end
    for _,tm in ipairs(TabMeta) do
      local row = Instance.new("Frame")
      row.Size = UDim2.new(1,0,0,24); row.BackgroundTransparency = 1; row.ZIndex = 52; row.Parent = side
      local b = Instance.new("TextButton"); b.Text = tm.label
      b.Size = UDim2.new(1,-36,1,0); b.Position = UDim2.new(0,0,0,0)
      b.BackgroundColor3 = (tm.id == curTab and curView == "songs") and PANA or Color3.new(0,0,0)
      b.BackgroundTransparency = (tm.id == curTab and curView == "songs") and 0 or 1
      b.TextColor3 = TX; b.Font = FONT_BOLD; b.TextSize = SZ(11)
      b.TextXAlignment = Enum.TextXAlignment.Left; b.BorderSizePixel = 0; b.ZIndex = 52; b.Parent = row
      Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
      b.MouseButton1Click:Connect(function() curView = "songs"; curTab = tm.id; buildUI() end)
      if not tm.builtin then
        local rn = Instance.new("TextButton"); rn.Text = "E"
        rn.Size = UDim2.new(0,16,0,16); rn.Position = UDim2.new(1,-34,0,4)
        rn.BackgroundColor3 = PAN; rn.TextColor3 = TXM
        rn.Font = FONT_BOLD; rn.TextSize = SZ(9)
        rn.BorderSizePixel = 0; rn.ZIndex = 53; rn.Parent = row
        Instance.new("UICorner", rn).CornerRadius = UDim.new(0,3)
        rn.MouseButton1Click:Connect(function()
          local box = Instance.new("TextBox"); box.Text = tm.label
          box.Size = UDim2.new(1,-40,1,-4); box.Position = UDim2.new(0,0,0,2)
          box.BackgroundColor3 = BG; box.TextColor3 = TX
          box.Font = FONT_BOLD; box.TextSize = SZ(11)
          box.TextXAlignment = Enum.TextXAlignment.Left
          box.BorderSizePixel = 0; box.ZIndex = 60; box.Parent = row
          Instance.new("UICorner", box).CornerRadius = UDim.new(0,4)
          box.FocusLost:Connect(function()
            if box.Text ~= "" then tm.label = box.Text; saveConfig() end
            renderSidebar()
          end)
          box:CaptureFocus()
        end)
        local dl = Instance.new("TextButton"); dl.Text = "X"
        dl.Size = UDim2.new(0,16,0,16); dl.Position = UDim2.new(1,-18,0,4)
        dl.BackgroundColor3 = ST; dl.TextColor3 = Color3.new(1,1,1)
        dl.Font = FONT_BOLD; dl.TextSize = SZ(9)
        dl.BorderSizePixel = 0; dl.ZIndex = 53; dl.Parent = row
        Instance.new("UICorner", dl).CornerRadius = UDim.new(0,3)
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
    addT.Size = UDim2.new(1,0,0,22); addT.BackgroundColor3 = ACS; addT.BackgroundTransparency = 0.5
    addT.TextColor3 = TX; addT.Font = FONT_BOLD; addT.TextSize = SZ(10)
    addT.BorderSizePixel = 0; addT.ZIndex = 52; addT.Parent = side
    Instance.new("UICorner", addT).CornerRadius = UDim.new(0,5)
    addT.MouseButton1Click:Connect(function()
      local box = Instance.new("TextBox"); box.PlaceholderText = "tab name..."
      box.Size = UDim2.new(1,-8,0,22); box.Position = UDim2.new(0,4,1,-26)
      box.BackgroundColor3 = PAN; box.TextColor3 = TX
      box.Font = FONT_BOLD; box.TextSize = SZ(10)
      box.BorderSizePixel = 0; box.ZIndex = 60; box.Parent = main
      Instance.new("UICorner", box).CornerRadius = UDim.new(0,5)
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
  content.Size = UDim2.new(1,-166,1,-148); content.Position = UDim2.new(0,160,0,76)
  content.BackgroundTransparency = 1; content.ZIndex = 51; content.Parent = main

  local searchBar = Instance.new("Frame"); searchBar.Size = UDim2.new(1,0,0,28)
  searchBar.BackgroundColor3 = PAN; searchBar.BorderSizePixel = 0; searchBar.ZIndex = 52; searchBar.Parent = content
  Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0,6)
  local searchBox = Instance.new("TextBox")
  searchBox.Size = UDim2.new(1,-70,1,0); searchBox.Position = UDim2.new(0,10,0,0)
  searchBox.BackgroundTransparency = 1; searchBox.TextColor3 = TX
  searchBox.PlaceholderText = "Filter songs..."; searchBox.PlaceholderColor3 = TXM
  searchBox.Font = FONT_REG; searchBox.TextSize = SZ(11)
  searchBox.TextXAlignment = Enum.TextXAlignment.Left; searchBox.Text = searchQuery
  searchBox.ZIndex = 53; searchBox.Parent = searchBar
  local searchBtn = Instance.new("TextButton"); searchBtn.Text = "Go"
  searchBtn.Size = UDim2.new(0,30,0,20); searchBtn.Position = UDim2.new(1,-62,0,4)
  searchBtn.BackgroundColor3 = AC; searchBtn.TextColor3 = Color3.new(1,1,1)
  searchBtn.Font = FONT_BOLD; searchBtn.TextSize = SZ(10)
  searchBtn.BorderSizePixel = 0; searchBtn.ZIndex = 53; searchBtn.Parent = searchBar
  Instance.new("UICorner", searchBtn).CornerRadius = UDim.new(0,4)
  local clearSearch = Instance.new("TextButton"); clearSearch.Text = "X"
  clearSearch.Size = UDim2.new(0,24,0,20); clearSearch.Position = UDim2.new(1,-30,0,4)
  clearSearch.BackgroundColor3 = rgb(60,60,60); clearSearch.TextColor3 = TXM
  clearSearch.Font = FONT_BOLD; clearSearch.TextSize = SZ(10)
  clearSearch.BorderSizePixel = 0; clearSearch.ZIndex = 53; clearSearch.Parent = searchBar
  Instance.new("UICorner", clearSearch).CornerRadius = UDim.new(0,4)

  local cHdr = Instance.new("Frame"); cHdr.Size = UDim2.new(1,0,0,28)
  cHdr.Position = UDim2.new(0,0,0,32)
  cHdr.BackgroundColor3 = PANA; cHdr.BorderSizePixel = 0; cHdr.ZIndex = 52; cHdr.Parent = content
  Instance.new("UICorner", cHdr).CornerRadius = UDim.new(0,6)
  local cTitle = Instance.new("TextLabel")
  cTitle.Size = UDim2.new(1,-40,1,0); cTitle.Position = UDim2.new(0,10,0,0)
  cTitle.BackgroundTransparency = 1; cTitle.TextColor3 = TX
  cTitle.Font = FONT_BOLD; cTitle.TextSize = SZ(12)
  cTitle.TextXAlignment = Enum.TextXAlignment.Left; cTitle.ZIndex = 53; cTitle.Parent = cHdr

  local scroll = Instance.new("ScrollingFrame")
  scroll.Size = UDim2.new(1,0,1,-68); scroll.Position = UDim2.new(0,0,0,64)
  scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 4
  scroll.ScrollBarImageColor3 = AC; scroll.ZIndex = 52; scroll.Parent = content
  local sLay = Instance.new("UIListLayout"); sLay.Padding = UDim.new(0,3); sLay.SortOrder = Enum.SortOrder.LayoutOrder; sLay.Parent = scroll
  sLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,sLay.AbsoluteContentSize.Y+8)
  end)

  local function rowBtn(parent, txt, w, bg, xFromRight)
    local b = Instance.new("TextButton"); b.Text = txt; b.Size = UDim2.new(0,w,0,20)
    b.Position = UDim2.new(1, xFromRight, 0, 5)
    b.BackgroundColor3 = bg; b.TextColor3 = Color3.new(1,1,1)
    b.Font = FONT_BOLD; b.TextSize = SZ(9)
    b.BorderSizePixel = 0; b.ZIndex = 54; b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
    return b
  end

  local delSongModal = Instance.new("Frame")
  delSongModal.Size = UDim2.new(0,240,0,110)
  delSongModal.AnchorPoint = Vector2.new(0.5,0.5)
  delSongModal.Position = UDim2.new(0.5,0,0.5,0)
  delSongModal.Visible = false
  delSongModal.BackgroundColor3 = PAN
  delSongModal.ZIndex = 200
  delSongModal.Parent = gui
  Instance.new("UICorner", delSongModal).CornerRadius = UDim.new(0,12)
  local delSongStroke = Instance.new("UIStroke", delSongModal)
  delSongStroke.Color = ST; delSongStroke.Thickness = 1

  local delSongLabel = Instance.new("TextLabel")
  delSongLabel.Text = "\u{423}\u{434}\u{430}\u{43B}\u{438}\u{442}\u{44C} \u{43F}\u{435}\u{441}\u{43D}\u{44E}?"
  delSongLabel.Size = UDim2.new(1,-20,0,35); delSongLabel.Position = UDim2.new(0,10,0,5)
  delSongLabel.BackgroundTransparency = 1; delSongLabel.TextColor3 = TX
  delSongLabel.Font = FONT_BOLD; delSongLabel.TextSize = SZ(14); delSongLabel.TextWrapped = true
  delSongLabel.ZIndex = 201; delSongLabel.Parent = delSongModal

  local delSongYes = Instance.new("TextButton")
  delSongYes.Text = "Yes"; delSongYes.Size = UDim2.new(0,70,0,28)
  delSongYes.Position = UDim2.new(0.5,-75,1,-38)
  delSongYes.BackgroundColor3 = AC; delSongYes.TextColor3 = Color3.new(1,1,1)
  delSongYes.Font = FONT_BOLD; delSongYes.TextSize = SZ(14)
  delSongYes.BorderSizePixel = 0; delSongYes.ZIndex = 201; delSongYes.Parent = delSongModal
  Instance.new("UICorner", delSongYes).CornerRadius = UDim.new(0,8)

  local delSongNo = Instance.new("TextButton")
  delSongNo.Text = "No"; delSongNo.Size = UDim2.new(0,70,0,28)
  delSongNo.Position = UDim2.new(0.5,5,1,-38)
  delSongNo.BackgroundColor3 = ST; delSongNo.TextColor3 = Color3.new(1,1,1)
  delSongNo.Font = FONT_BOLD; delSongNo.TextSize = SZ(14)
  delSongNo.BorderSizePixel = 0; delSongNo.ZIndex = 201; delSongNo.Parent = delSongModal
  Instance.new("UICorner", delSongNo).CornerRadius = UDim.new(0,8)

  local pendingSongDelete = nil
  local renderSongs

  delSongYes.MouseButton1Click:Connect(function()
    if pendingSongDelete then
      Songs[pendingSongDelete] = nil
      for _,t in pairs(Tabs) do
        for i = #t, 1, -1 do if t[i] == pendingSongDelete then table.remove(t, i) end end
      end
      rebuildAll(); saveConfig()
    end
    delSongModal.Visible = false
    pendingSongDelete = nil
    if renderSongs then renderSongs() end
  end)
  delSongNo.MouseButton1Click:Connect(function()
    delSongModal.Visible = false; pendingSongDelete = nil
  end)

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
      countLabel.Size = UDim2.new(0,100,1,0); countLabel.Position = UDim2.new(0,80,0,0)
      countLabel.BackgroundTransparency = 1; countLabel.Font = Enum.Font.Code; countLabel.TextSize = SZ(9)
      countLabel.TextColor3 = TXM; countLabel.TextXAlignment = Enum.TextXAlignment.Left
      countLabel.ZIndex = 53; countLabel.Parent = cHdr
    end
    local seen = {}
    local count = 0
    local filtered = 0

    local btnPlay = CFG.useEmoji and "\u{25B6}" or "Ply"
    local btnPrev = CFG.useEmoji and "\u{266A}" or "Prv"
    local btnEdit = CFG.useEmoji and "\u{270E}" or "Edt"
    local btnCopy = CFG.useEmoji and "\u{1F4CB}" or "Cpy"
    local btnRem = CFG.useEmoji and "\u{2212}" or "Rem"
    local btnDel = "Del"
    local btnExp = "Exp"

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
            local row = Instance.new("Frame"); row.Size = UDim2.new(1,-2,0,30)
            row.BackgroundColor3 = PANA; row.BorderSizePixel = 0; row.ZIndex = 53; row.Parent = scroll
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = AC; rowStroke.Transparency = 1; rowStroke.Thickness = 1
            row.MouseEnter:Connect(function()
              TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = ACS}):Play()
              TweenService:Create(rowStroke, TweenInfo.new(0.12), {Transparency = 0.55}):Play()
            end)
            row.MouseLeave:Connect(function()
              TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = PANA}):Play()
              TweenService:Create(rowStroke, TweenInfo.new(0.12), {Transparency = 1}):Play()
            end)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0,5)
            local nm = Instance.new("TextLabel"); nm.Text = display
            nm.Size = UDim2.new(1,-198,1,0); nm.Position = UDim2.new(0,8,0,0)
            nm.BackgroundTransparency = 1; nm.TextColor3 = TX
            nm.Font = FONT_REG; nm.TextSize = SZ(10)
            nm.TextXAlignment = Enum.TextXAlignment.Left
            nm.TextTruncate = Enum.TextTruncate.AtEnd
            nm.ZIndex = 54; nm.Parent = row

            local bExp = rowBtn(row, btnExp, 24, rgb(180,160,30), -196)
            local bPlay = rowBtn(row, btnPlay, 24, AC, -170)
            local bPrev = rowBtn(row, btnPrev, 24, ACS, -144)
            local bEdit = rowBtn(row, btnEdit, 24, rgb(90,90,90), -118)
            local bCopy = rowBtn(row, btnCopy, 24, ACS, -92)
            local bRem = rowBtn(row, btnRem, 24, rgb(80,80,80), -66)
            local bDel = rowBtn(row, btnDel, 24, ST, -40)

            bExp.MouseButton1Click:Connect(function()
              local success = trySaveSong(id, s.name)
              bExp.Text = success and "OK" or "ERR"
              bExp.BackgroundColor3 = success and rgb(34,197,94) or rgb(200,60,60)
              task.wait(0.6)
              bExp.Text = btnExp
              bExp.BackgroundColor3 = rgb(180,160,30)
            end)
            bPlay.MouseButton1Click:Connect(function() radioPlay(id) end)
            bPrev.MouseButton1Click:Connect(function() prvPlay(id) end)
            bEdit.MouseButton1Click:Connect(function()
              local box = Instance.new("TextBox"); box.Text = s.name
              box.Size = UDim2.new(1,-205,1,-8); box.Position = UDim2.new(0,8,0,4)
              box.BackgroundColor3 = BG; box.TextColor3 = TX
              box.Font = FONT_BOLD; box.TextSize = SZ(10)
              box.TextXAlignment = Enum.TextXAlignment.Left
              box.BorderSizePixel = 0; box.ZIndex = 60; box.Parent = row
              Instance.new("UICorner", box).CornerRadius = UDim.new(0,4)
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
              local popup = Instance.new("Frame"); popup.Name = "CopyPopup"
              popup.BackgroundColor3 = BG; popup.BorderSizePixel = 0
              popup.ZIndex = 200; popup.Parent = gui
              Instance.new("UICorner", popup).CornerRadius = UDim.new(0,6)
              local popStroke = Instance.new("UIStroke", popup)
              popStroke.Color = AC; popStroke.Thickness = 1
              local popLay = Instance.new("UIListLayout", popup)
              popLay.Padding = UDim.new(0,2)
              local popH = 0
              for _, tm in ipairs(TabMeta) do
                if tm.id ~= "all" then
                  popH = popH + 24
                  local opt = Instance.new("TextButton"); opt.Text = "  " .. tm.label
                  opt.Size = UDim2.new(1,-4,0,22); opt.BackgroundColor3 = PANA
                  opt.TextColor3 = TX; opt.Font = FONT_REG; opt.TextSize = SZ(10)
                  opt.TextXAlignment = Enum.TextXAlignment.Left
                  opt.BorderSizePixel = 0; opt.ZIndex = 201; opt.Parent = popup
                  Instance.new("UICorner", opt).CornerRadius = UDim.new(0,4)
                  opt.MouseEnter:Connect(function() opt.BackgroundColor3 = AC end)
                  opt.MouseLeave:Connect(function() opt.BackgroundColor3 = PANA end)
                  opt.MouseButton1Click:Connect(function()
                    Tabs[tm.id] = Tabs[tm.id] or {}
                    local found = false
                    for _, x in ipairs(Tabs[tm.id]) do if x == id then found = true; break end end
                    if not found then table.insert(Tabs[tm.id], id); saveConfig() end
                    popup:Destroy()
                    bCopy.Text = "OK"
                    task.wait(0.4)
                    bCopy.Text = btnCopy
                  end)
                end
              end
              local popW = 140
              local popFullH = popH + 4
              local screenH = gui.AbsoluteSize.Y
              local yPos = btnPos.Y + btnSize.Y + 2
              if yPos + popFullH > screenH then yPos = btnPos.Y - popFullH - 2 end
              popup.Size = UDim2.new(0, popW, 0, popFullH)
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
              delSongModal.Visible = true
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

    local engRow = Instance.new("Frame"); engRow.Name = "SearchUI"; engRow.Size = UDim2.new(1,0,0,36)
    engRow.BackgroundColor3 = PAN; engRow.BorderSizePixel = 0; engRow.ZIndex = 53; engRow.Parent = scroll
    Instance.new("UICorner", engRow).CornerRadius = UDim.new(0,6)
    local engHL = Instance.new("UIListLayout", engRow)
    engHL.FillDirection = Enum.FillDirection.Horizontal; engHL.Padding = UDim.new(0,4)
    engHL.HorizontalAlignment = Enum.HorizontalAlignment.Center
    engHL.VerticalAlignment = Enum.VerticalAlignment.Center
    local engs = {{"catalog","Catalog"},{"id","Asset ID"}}
    for idx, e in ipairs(engs) do
      local b = Instance.new("TextButton"); b.Text = e[2]
      b.Size = UDim2.new(0.5,-4,1,-6); b.LayoutOrder = idx
      local active = CFG.searchEng == e[1]
      b.BackgroundColor3 = active and AC or PANA
      b.TextColor3 = active and Color3.new(1,1,1) or TXM
      b.Font = FONT_BOLD; b.TextSize = SZ(11)
      b.BorderSizePixel = 0; b.ZIndex = 54; b.Parent = engRow
      Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
      b.MouseButton1Click:Connect(function() CFG.searchEng = e[1]; saveConfig(); buildUI() end)
    end

    local inpRow = Instance.new("Frame"); inpRow.Name = "SearchUI"; inpRow.Size = UDim2.new(1,0,0,34)
    inpRow.BackgroundColor3 = PAN; inpRow.BorderSizePixel = 0; inpRow.ZIndex = 53; inpRow.Parent = scroll
    Instance.new("UICorner", inpRow).CornerRadius = UDim.new(0,6)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-90,1,0); box.Position = UDim2.new(0,10,0,0)
    box.BackgroundTransparency = 1; box.TextColor3 = TX
    box.Font = FONT_REG; box.TextSize = SZ(11)
    box.PlaceholderText = CFG.searchEng == "id" and "Paste asset id..." or "Type song name..."
    box.PlaceholderColor3 = TXM
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ZIndex = 54; box.Parent = inpRow
    local go = Instance.new("TextButton"); go.Text = "Search"
    go.Size = UDim2.new(0,80,1,-6); go.Position = UDim2.new(1,-84,0,3)
    go.BackgroundColor3 = AC; go.TextColor3 = Color3.new(1,1,1)
    go.Font = FONT_BOLD; go.TextSize = SZ(11)
    go.BorderSizePixel = 0; go.ZIndex = 54; go.Parent = inpRow
    Instance.new("UICorner", go).CornerRadius = UDim.new(0,5)

    local status = Instance.new("TextLabel"); status.Name = "SearchUI"; status.Text = ""
    status.Size = UDim2.new(1,0,0,18)
    status.BackgroundTransparency = 1; status.TextColor3 = TXM
    status.Font = FONT_REG; status.TextSize = SZ(10)
    status.TextXAlignment = Enum.TextXAlignment.Left; status.ZIndex = 53; status.Parent = scroll

    local resultsContainer = Instance.new("Frame"); resultsContainer.Name = "ResultsContainer"
    resultsContainer.Size = UDim2.new(1,0,0,0); resultsContainer.BackgroundTransparency = 1
    resultsContainer.BorderSizePixel = 0; resultsContainer.ZIndex = 53; resultsContainer.Parent = scroll
    resultsContainer.AutomaticSize = Enum.AutomaticSize.Y
    local resLay = Instance.new("UIListLayout", resultsContainer); resLay.Padding = UDim.new(0,3)
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
        local row = Instance.new("Frame"); row.Name = "Result"
        row.Size = UDim2.new(1,-2,0,30)
        row.BackgroundColor3 = PANA; row.BorderSizePixel = 0; row.ZIndex = 53
        row.Parent = resultsContainer
        local rowStroke = Instance.new("UIStroke", row)
        rowStroke.Color = AC; rowStroke.Transparency = 1; rowStroke.Thickness = 1
        row.MouseEnter:Connect(function() TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = ACS}):Play() end)
        row.MouseLeave:Connect(function() TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = PANA}):Play() end)
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,5)
        local nm = Instance.new("TextLabel")
        nm.Text = r.name .. " \u{B7} #" .. r.id
        nm.Size = UDim2.new(1,-120,1,0); nm.Position = UDim2.new(0,8,0,0)
        nm.BackgroundTransparency = 1; nm.TextColor3 = TX
        nm.Font = FONT_REG; nm.TextSize = SZ(10)
        nm.TextXAlignment = Enum.TextXAlignment.Left
        nm.TextTruncate = Enum.TextTruncate.AtEnd
        nm.ZIndex = 54; nm.Parent = row
        local bP = rowBtn(row, CFG.useEmoji and "\u{25B6}" or "Ply", 26, AC, -112)
        local bQ = rowBtn(row, CFG.useEmoji and "\u{266A}" or "Prv", 26, ACS, -84)
        local bA = rowBtn(row, "+ Add", 52, rgb(30,120,50), -58)
        bP.MouseButton1Click:Connect(function() radioPlay(r.id) end)
        bQ.MouseButton1Click:Connect(function() prvPlay(r.id) end)
        bA.MouseButton1Click:Connect(function()
          ensureSong(r.id, r.name, "ru", false, "new")
          bA.Text = "OK"; bA.BackgroundColor3 = rgb(34,197,94)
          task.wait(0.5)
          bA.Text = "+ Add"; bA.BackgroundColor3 = rgb(30,120,50)
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

    local statBox = Instance.new("Frame"); statBox.Name = "stat"
    statBox.Size = UDim2.new(1,-4,0,24); statBox.LayoutOrder = nextOrder()
    statBox.BackgroundColor3 = PANA; statBox.BorderSizePixel = 0; statBox.ZIndex = 53; statBox.Parent = scroll
    Instance.new("UICorner", statBox).CornerRadius = UDim.new(0,5)
    local statDot = Instance.new("Frame")
    statDot.Size = UDim2.new(0,8,0,8); statDot.Position = UDim2.new(0,8,0,8)
    statDot.BackgroundColor3 = importing and rgb(34,197,94) or TXM
    statDot.BorderSizePixel = 0; statDot.ZIndex = 54; statDot.Parent = statBox
    Instance.new("UICorner", statDot).CornerRadius = UDim.new(1,0)
    local stat = Instance.new("TextLabel")
    stat.Text = importing and ("LISTENING  " .. importCount .. " caught") or ("IDLE  " .. tempCount .. " pending")
    stat.Size = UDim2.new(1,-24,1,0); stat.Position = UDim2.new(0,20,0,0)
    stat.BackgroundTransparency = 1
    stat.TextColor3 = importing and rgb(34,197,94) or TXM
    stat.Font = FONT_BOLD; stat.TextSize = SZ(10)
    stat.TextXAlignment = Enum.TextXAlignment.Left; stat.ZIndex = 54; stat.Parent = statBox
    importStatus = stat

    local btnBar = Instance.new("Frame"); btnBar.Name = "btns"
    btnBar.Size = UDim2.new(1,-4,0,30); btnBar.LayoutOrder = nextOrder()
    btnBar.BackgroundTransparency = 1; btnBar.BorderSizePixel = 0
    btnBar.ZIndex = 53; btnBar.Parent = scroll

    local function impBtn(text, xPos, width, color)
      local b = Instance.new("TextButton"); b.Text = text
      b.Size = UDim2.new(0, width, 0, 26)
      b.Position = UDim2.new(0, xPos, 0, 2)
      b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1,1,1)
      b.Font = FONT_BOLD; b.TextSize = SZ(10)
      b.BorderSizePixel = 0; b.ZIndex = 54; b.Parent = btnBar
      Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
      return b
    end

    local bStart = impBtn("Start", 0, 72, rgb(30,120,50))
    local bStop = impBtn("Stop", 76, 72, ST)
    local bClear = impBtn("Clear", 152, 52, rgb(80,80,80))
    local bAddAll = impBtn("+ All", 208, 52, AC)

    bStart.MouseButton1Click:Connect(function() startImport(); refreshCurrentView() end)
    bStop.MouseButton1Click:Connect(function() stopImport(); refreshCurrentView() end)
    bClear.MouseButton1Click:Connect(function() clearTempImported(); refreshCurrentView() end)
    bAddAll.MouseButton1Click:Connect(function()
      for songId, _ in pairs(tempImported) do saveImportedSong(songId) end
      refreshCurrentView()
    end)

    local autoRow = Instance.new("Frame"); autoRow.Name = "auto"
    autoRow.Size = UDim2.new(1,-4,0,32); autoRow.LayoutOrder = nextOrder()
    autoRow.BackgroundColor3 = PANA; autoRow.BorderSizePixel = 0; autoRow.ZIndex = 53; autoRow.Parent = scroll
    Instance.new("UICorner", autoRow).CornerRadius = UDim.new(0,5)
    local autoLbl = Instance.new("TextLabel"); autoLbl.Text = "Auto Import (persists across restarts)"
    autoLbl.Size = UDim2.new(1,-60,1,0); autoLbl.Position = UDim2.new(0,10,0,0)
    autoLbl.BackgroundTransparency = 1; autoLbl.TextColor3 = TX
    autoLbl.Font = FONT_BOLD; autoLbl.TextSize = SZ(10)
    autoLbl.TextXAlignment = Enum.TextXAlignment.Left; autoLbl.ZIndex = 54; autoLbl.Parent = autoRow
    local autoTrack = Instance.new("Frame"); autoTrack.Size = UDim2.new(0,40,0,20)
    autoTrack.Position = UDim2.new(1,-50,0,6)
    autoTrack.BorderSizePixel = 0; autoTrack.ZIndex = 54; autoTrack.Parent = autoRow
    Instance.new("UICorner", autoTrack).CornerRadius = UDim.new(1,0)
    local autoKnob = Instance.new("Frame"); autoKnob.Size = UDim2.new(0,16,0,16)
    autoKnob.Position = UDim2.new(0,2,0,2)
    autoKnob.BackgroundColor3 = Color3.new(1,1,1)
    autoKnob.BorderSizePixel = 0; autoKnob.ZIndex = 55; autoKnob.Parent = autoTrack
    Instance.new("UICorner", autoKnob).CornerRadius = UDim.new(1,0)
    local function paintAuto()
      autoTrack.BackgroundColor3 = CFG.autoImport and AC or rgb(60,60,60)
      autoKnob.Position = CFG.autoImport and UDim2.new(1,-18,0,2) or UDim2.new(0,2,0,2)
    end
    paintAuto()
    local autoBtn = Instance.new("TextButton")
    autoBtn.BackgroundTransparency = 1; autoBtn.Size = UDim2.new(1,0,1,0); autoBtn.Text = ""
    autoBtn.ZIndex = 56; autoBtn.Parent = autoRow
    autoBtn.MouseButton1Click:Connect(function()
      CFG.autoImport = not CFG.autoImport
      saveConfig()
      if CFG.autoImport then startImport() else stopImport() end
      paintAuto()
      refreshCurrentView()
    end)

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
        local row = Instance.new("Frame"); row.Name = "imp"
        row.Size = UDim2.new(1,-4,0,28); row.LayoutOrder = nextOrder()
        row.BackgroundColor3 = PANA; row.BorderSizePixel = 0; row.ZIndex = 53; row.Parent = scroll
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,5)
        row.MouseEnter:Connect(function() TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = ACS}):Play() end)
        row.MouseLeave:Connect(function() TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = PANA}):Play() end)

        local nm = Instance.new("TextLabel")
        nm.Text = (data.name or songId) .. "  #" .. songId
        nm.Size = UDim2.new(1,-140,1,0); nm.Position = UDim2.new(0,6,0,0)
        nm.BackgroundTransparency = 1; nm.TextColor3 = TX
        nm.Font = FONT_REG; nm.TextSize = SZ(9)
        nm.TextXAlignment = Enum.TextXAlignment.Left
        nm.TextTruncate = Enum.TextTruncate.AtEnd
        nm.ZIndex = 54; nm.Parent = row

        local bPlay = rowBtn(row, "Ply", 26, AC, -134)
        local bPrev = rowBtn(row, "Prv", 26, ACS, -106)
        local bAdd = rowBtn(row, "+", 24, rgb(30,120,50), -78)
        local bExp = rowBtn(row, "Exp", 26, rgb(180,160,30), -50)
        local bRem = rowBtn(row, "X", 24, rgb(120,30,30), -20)

        bPlay.MouseButton1Click:Connect(function() radioPlay(songId) end)
        bPrev.MouseButton1Click:Connect(function() prvPlay(songId) end)
        bAdd.MouseButton1Click:Connect(function()
          if saveImportedSong(songId) then
            bAdd.Text = "OK"; bAdd.BackgroundColor3 = rgb(34,197,94)
            task.wait(0.4); refreshCurrentView()
          end
        end)
        bExp.MouseButton1Click:Connect(function()
          local success = trySaveSong(songId, data.name or songId)
          bExp.Text = success and "OK" or "ERR"
          bExp.BackgroundColor3 = success and rgb(34,197,94) or rgb(200,60,60)
          task.wait(0.5)
          bExp.Text = "Exp"; bExp.BackgroundColor3 = rgb(180,160,30)
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
    local thBox = Instance.new("Frame"); thBox.Size = UDim2.new(1,0,0,150)
    thBox.BackgroundColor3 = PAN; thBox.BorderSizePixel = 0; thBox.ZIndex = 53; thBox.Parent = scroll
    Instance.new("UICorner", thBox).CornerRadius = UDim.new(0,6)
    local thL = Instance.new("TextLabel")
    thL.Text = "Color Theme"
    thL.Size = UDim2.new(1,-10,0,18); thL.Position = UDim2.new(0,8,0,4)
    thL.BackgroundTransparency = 1; thL.TextColor3 = TX
    thL.Font = FONT_BOLD; thL.TextSize = SZ(11)
    thL.TextXAlignment = Enum.TextXAlignment.Left; thL.ZIndex = 54; thL.Parent = thBox
    for i, t in ipairs(TH) do
      local col = (i-1) % 3
      local rowN = math.floor((i-1)/3)
      local tb = Instance.new("TextButton"); tb.Size = UDim2.new(0,100,0,26)
      tb.Position = UDim2.new(0,8+col*105,0,26+rowN*30)
      tb.BackgroundColor3 = t[5]; tb.Text = t[1]; tb.TextColor3 = t[7]
      tb.Font = FONT_BOLD; tb.TextSize = SZ(10)
      tb.BorderSizePixel = 0; tb.ZIndex = 54; tb.Parent = thBox
      Instance.new("UICorner", tb).CornerRadius = UDim.new(0,6)
      if i == CFG.theme then
        local s2 = Instance.new("UIStroke", tb); s2.Color = Color3.new(1,1,1); s2.Thickness = 2
      end
      tb.MouseButton1Click:Connect(function() CFG.theme = i; saveConfig(); buildUI() end)
    end

    local function toggle(label, getter, setter, doFullRebuild)
      local row = Instance.new("Frame"); row.Size = UDim2.new(1,0,0,32)
      row.BackgroundColor3 = PAN; row.BorderSizePixel = 0; row.ZIndex = 53; row.Parent = scroll
      Instance.new("UICorner", row).CornerRadius = UDim.new(0,5)
      local lbl = Instance.new("TextLabel"); lbl.Text = label
      lbl.Size = UDim2.new(1,-60,1,0); lbl.Position = UDim2.new(0,10,0,0)
      lbl.BackgroundTransparency = 1; lbl.TextColor3 = TX
      lbl.Font = FONT_BOLD; lbl.TextSize = SZ(10)
      lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 54; lbl.Parent = row
      local track = Instance.new("Frame"); track.Size = UDim2.new(0,40,0,20)
      track.Position = UDim2.new(1,-50,0,6)
      track.BorderSizePixel = 0; track.ZIndex = 54; track.Parent = row
      Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
      local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,16,0,16)
      knob.Position = UDim2.new(0,2,0,2)
      knob.BackgroundColor3 = Color3.new(1,1,1)
      knob.BorderSizePixel = 0; knob.ZIndex = 55; knob.Parent = track
      Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
      local function paint()
        local on = getter()
        track.BackgroundColor3 = on and AC or rgb(60,60,60)
        knob.Position = on and UDim2.new(1,-18,0,2) or UDim2.new(0,2,0,2)
      end
      paint()
      local b = Instance.new("TextButton")
      b.BackgroundTransparency = 1; b.Size = UDim2.new(1,0,1,0); b.Text = ""; b.ZIndex = 56; b.Parent = row
      b.MouseButton1Click:Connect(function()
        setter(not getter()); saveConfig(); paint()
        if doFullRebuild then buildUI() else refreshCurrentView() end
      end)
    end
    toggle("Use emoji icons", function() return CFG.useEmoji end, function(v) CFG.useEmoji = v end, false)
    toggle("Show original Roblox names", function() return CFG.showOriginal end,
      function(v) CFG.showOriginal = v; showOrig = v end, false)
    toggle("Auto Import on load", function() return CFG.autoImport end,
      function(v) CFG.autoImport = v; if v then startImport() else stopImport() end end, false)
    toggle("Rounded corners", function() return CFG.corner > 0 end,
      function(v) CFG.corner = v and 10 or 0 end, true)

    local function action(label, col, cb)
      local b = Instance.new("TextButton"); b.Text = label; b.Size = UDim2.new(1,0,0,32)
      b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1,1,1)
      b.Font = FONT_BOLD; b.TextSize = SZ(10)
      b.BorderSizePixel = 0; b.ZIndex = 53; b.Parent = scroll
      Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
      b.MouseButton1Click:Connect(function() cb(b) end)
    end
    action("Fix gamepass scroll", rgb(50,70,130), function(b)
      b.Text = "..."; fixScroll(); b.Text = "Done"; task.wait(1); b.Text = "Fix gamepass scroll"
    end)
    action("Export all to gamepass", rgb(40,100,55), function(b)
      local n, total, fails = 0, 0, 0
      for _ in pairs(Songs) do total = total + 1 end
      for id, s in pairs(Songs) do
        n = n + 1
        if not trySaveSong(id, s.name) then fails = fails + 1 end
        b.Text = n.."/"..total; task.wait(0.3)
      end
      b.Text = fails > 0 and ("Done ("..fails.." failed)") or "Done"
      task.wait(1.2); b.Text = "Export all to gamepass"
    end)

    local function pickerRow(title, options, getIdx, onPick, boxW)
      local hdrLbl = Instance.new("TextLabel"); hdrLbl.Text = title
      hdrLbl.Size = UDim2.new(1,0,0,16); hdrLbl.BackgroundTransparency = 1
      hdrLbl.TextColor3 = TXM; hdrLbl.Font = FONT_BOLD; hdrLbl.TextSize = SZ(9)
      hdrLbl.TextXAlignment = Enum.TextXAlignment.Left; hdrLbl.ZIndex = 53; hdrLbl.Parent = scroll
      local rowFrame = Instance.new("Frame"); rowFrame.Size = UDim2.new(1,0,0,28)
      rowFrame.BackgroundTransparency = 1; rowFrame.ZIndex = 53; rowFrame.Parent = scroll
      local rl = Instance.new("UIListLayout", rowFrame)
      rl.FillDirection = Enum.FillDirection.Horizontal; rl.Padding = UDim.new(0,4)
      for oi, opt in ipairs(options) do
        local ob = Instance.new("TextButton"); ob.Text = opt
        ob.Size = UDim2.new(0, boxW, 1, 0)
        local active = getIdx() == oi
        ob.BackgroundColor3 = active and AC or PANA
        ob.TextColor3 = active and Color3.new(1,1,1) or TXM
        ob.Font = FONT_BOLD; ob.TextSize = SZ(10)
        ob.BorderSizePixel = 0; ob.ZIndex = 54; ob.Parent = rowFrame
        Instance.new("UICorner", ob).CornerRadius = UDim.new(0,6)
        ob.MouseButton1Click:Connect(function() onPick(oi) end)
      end
    end

    local fontNames = {}
    for _, fo in ipairs(FONT_OPTIONS) do table.insert(fontNames, fo[1]) end
    pickerRow(T("fontLabel"), fontNames, function() return CFG.font end, function(oi)
      CFG.font = oi; saveConfig(); buildUI()
      task.defer(function() if main and main.Parent then main.Visible = true; main.Position = UDim2.new(0.07,0,0.09,0) end end)
    end, 78)

    pickerRow(T("sizeLabel"), SCALE_LABELS, function() return CFG.textScale end, function(oi)
      CFG.textScale = oi; saveConfig(); buildUI()
      task.defer(function() if main and main.Parent then main.Visible = true; main.Position = UDim2.new(0.07,0,0.09,0) end end)
    end, 50)

    pickerRow(T("langLabel"), {"RU","EN"}, function() return CFG.lang2 == "ru" and 1 or 2 end, function(oi)
      CFG.lang2 = oi == 1 and "ru" or "en"; saveConfig(); buildUI()
      task.defer(function() if main and main.Parent then main.Visible = true; main.Position = UDim2.new(0.07,0,0.09,0) end end)
    end, 50)

    local brokenHdr = Instance.new("TextLabel"); brokenHdr.Text = T("brokenHdr")
    brokenHdr.Size = UDim2.new(1,0,0,20); brokenHdr.BackgroundTransparency = 1
    brokenHdr.TextColor3 = TX; brokenHdr.Font = FONT_BOLD; brokenHdr.TextSize = SZ(12)
    brokenHdr.TextXAlignment = Enum.TextXAlignment.Left; brokenHdr.ZIndex = 53; brokenHdr.Parent = scroll

    local scanBtn = Instance.new("TextButton"); scanBtn.Text = T("brokenScan")
    scanBtn.Size = UDim2.new(1,0,0,30); scanBtn.BackgroundColor3 = rgb(80,60,140)
    scanBtn.TextColor3 = Color3.new(1,1,1); scanBtn.Font = FONT_BOLD; scanBtn.TextSize = SZ(11)
    scanBtn.BorderSizePixel = 0; scanBtn.ZIndex = 53; scanBtn.Parent = scroll
    Instance.new("UICorner", scanBtn).CornerRadius = UDim.new(0,6)
    scanBtn.MouseButton1Click:Connect(function()
      scanBtn.Text = "0/0"
      scanForBroken(function(i, total) scanBtn.Text = i.."/"..total end, function()
        scanBtn.Text = T("brokenScan")
        refreshCurrentView()
      end)
    end)

    local brokenAny = false
    for id,_ in pairs(BrokenTracks) do
      if Songs[id] then
        brokenAny = true
        local row = Instance.new("Frame"); row.Size = UDim2.new(1,0,0,30)
        row.BackgroundColor3 = PANA; row.BorderSizePixel = 0; row.ZIndex = 53; row.Parent = scroll
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
        local nm = Instance.new("TextLabel"); nm.Text = Songs[id].name
        nm.Size = UDim2.new(1,-120,1,0); nm.Position = UDim2.new(0,8,0,0)
        nm.BackgroundTransparency = 1; nm.TextColor3 = ST
        nm.Font = FONT_REG; nm.TextSize = SZ(10)
        nm.TextXAlignment = Enum.TextXAlignment.Left; nm.TextTruncate = Enum.TextTruncate.AtEnd
        nm.ZIndex = 54; nm.Parent = row
        local okBtn = Instance.new("TextButton"); okBtn.Text = "OK"
        okBtn.Size = UDim2.new(0,50,0,22); okBtn.Position = UDim2.new(1,-116,0.5,-11)
        okBtn.BackgroundColor3 = rgb(60,60,60); okBtn.TextColor3 = Color3.new(1,1,1)
        okBtn.Font = FONT_BOLD; okBtn.TextSize = SZ(10); okBtn.BorderSizePixel = 0
        okBtn.ZIndex = 54; okBtn.Parent = row
        Instance.new("UICorner", okBtn).CornerRadius = UDim.new(0,5)
        okBtn.MouseButton1Click:Connect(function() BrokenTracks[id] = nil; saveBroken(); refreshCurrentView() end)
        local rmBtn = Instance.new("TextButton"); rmBtn.Text = "Del"
        rmBtn.Size = UDim2.new(0,56,0,22); rmBtn.Position = UDim2.new(1,-60,0.5,-11)
        rmBtn.BackgroundColor3 = ST; rmBtn.TextColor3 = Color3.new(1,1,1)
        rmBtn.Font = FONT_BOLD; rmBtn.TextSize = SZ(10); rmBtn.BorderSizePixel = 0
        rmBtn.ZIndex = 54; rmBtn.Parent = row
        Instance.new("UICorner", rmBtn).CornerRadius = UDim.new(0,5)
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

  local bar = Instance.new("Frame")
  bar.Size = UDim2.new(1,-16,0,36); bar.Position = UDim2.new(0,8,1,-44)
  bar.BackgroundTransparency = 1; bar.ZIndex = 51; bar.Parent = main
  local subViews = {{"songs","songs"},{"search","search"},{"import","import"},{"settings","settings"}}
  for i, sv in ipairs(subViews) do
    local b = Instance.new("TextButton"); b.Text = sv[2]
    b.Size = UDim2.new(0,76,0,28); b.Position = UDim2.new(0,(i-1)*80,0,4)
    b.BackgroundColor3 = (curView == sv[1]) and PANA or Color3.new(0,0,0)
    b.BackgroundTransparency = (curView == sv[1]) and 0 or 1
    b.TextColor3 = TX; b.Font = FONT_BOLD; b.TextSize = SZ(11)
    b.BorderSizePixel = 0; b.ZIndex = 52; b.Parent = bar
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(function() curView = sv[1]; buildUI() end)
  end

  local stopTrack = Instance.new("Frame")
  stopTrack.Size = UDim2.new(0,48,0,24); stopTrack.Position = UDim2.new(1,-56,0,6)
  stopTrack.BackgroundColor3 = rgb(30,30,30)
  stopTrack.BorderSizePixel = 0; stopTrack.ZIndex = 52; stopTrack.Parent = bar
  Instance.new("UICorner", stopTrack).CornerRadius = UDim.new(1,0)
  local stopKnob = Instance.new("TextButton")
  stopKnob.Size = UDim2.new(0,20,0,20); stopKnob.Position = UDim2.new(1,-22,0,2)
  stopKnob.BackgroundColor3 = rgb(34,197,94)
  stopKnob.Text = ""; stopKnob.BorderSizePixel = 0; stopKnob.ZIndex = 53; stopKnob.Parent = stopTrack
  Instance.new("UICorner", stopKnob).CornerRadius = UDim.new(1,0)
  local playing = false
  stopKnob.MouseButton1Click:Connect(function()
    playing = not playing
    if playing then
      radioStop(); stopKnob.BackgroundColor3 = ST; stopKnob.Position = UDim2.new(0,2,0,2)
    else
      stopKnob.BackgroundColor3 = rgb(34,197,94); stopKnob.Position = UDim2.new(1,-22,0,2)
    end
  end)

  renderSidebar()
  refreshCurrentView()

  if bHelp then
    bHelp.MouseButton1Click:Connect(function() curView = "import"; buildUI() end)
  end
  bSet.MouseButton1Click:Connect(function() curView = "settings"; buildUI() end)

  elseif activeApp == "scripts" then

  local content = Instance.new("Frame")
  content.Size = UDim2.new(1,-28,1,-148); content.Position = UDim2.new(0,14,0,76)
  content.BackgroundTransparency = 1; content.ZIndex = 51; content.Parent = main

  local scriptsSubHeader = Instance.new("Frame")
  scriptsSubHeader.Size = UDim2.new(1,0,0,32)
  scriptsSubHeader.BackgroundTransparency = 1
  scriptsSubHeader.ZIndex = 52
  scriptsSubHeader.Parent = content

  local backBtn = Instance.new("TextButton")
  backBtn.Size = UDim2.new(0,60,1,0)
  backBtn.Text = "< Root"
  backBtn.TextSize = SZ(12)
  backBtn.Font = FONT_BOLD
  backBtn.BackgroundColor3 = PANA
  backBtn.TextColor3 = AC
  backBtn.BorderSizePixel = 0
  backBtn.Visible = false
  backBtn.ZIndex = 53
  backBtn.Parent = scriptsSubHeader
  Instance.new("UICorner", backBtn).CornerRadius = UDim.new(0,8)

  local pathLabel = Instance.new("TextLabel")
  pathLabel.BackgroundTransparency = 1
  pathLabel.Position = UDim2.new(0,70,0,0)
  pathLabel.Size = UDim2.new(1,-150,1,0)
  pathLabel.Text = "Root"
  pathLabel.TextSize = SZ(12)
  pathLabel.Font = FONT_BOLD
  pathLabel.TextColor3 = TX
  pathLabel.TextXAlignment = Enum.TextXAlignment.Left
  pathLabel.ZIndex = 53
  pathLabel.Parent = scriptsSubHeader

  local newFolderBtn = Instance.new("TextButton")
  newFolderBtn.AnchorPoint = Vector2.new(1,0)
  newFolderBtn.Position = UDim2.new(1,0,0,0)
  newFolderBtn.Size = UDim2.new(0,64,1,0)
  newFolderBtn.Text = "+ Folder"
  newFolderBtn.TextSize = SZ(11)
  newFolderBtn.BackgroundColor3 = PANA
  newFolderBtn.TextColor3 = AC
  newFolderBtn.BorderSizePixel = 0
  newFolderBtn.ZIndex = 53
  newFolderBtn.Parent = scriptsSubHeader
  Instance.new("UICorner", newFolderBtn).CornerRadius = UDim.new(0,8)

  local scroll = Instance.new("ScrollingFrame")
  scroll.Size = UDim2.new(1,0,1,-82); scroll.Position = UDim2.new(0,0,0,38)
  scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 4
  scroll.ScrollBarImageColor3 = AC; scroll.ZIndex = 52; scroll.Parent = content
  local sLay = Instance.new("UIListLayout", scroll)
  sLay.Padding = UDim.new(0,6); sLay.SortOrder = Enum.SortOrder.LayoutOrder
  sLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,sLay.AbsoluteContentSize.Y+8)
  end)

  local addScriptBtn = Instance.new("TextButton")
  addScriptBtn.Size = UDim2.new(1,0,0,36)
  addScriptBtn.Position = UDim2.new(0,0,1,-36)
  addScriptBtn.BackgroundColor3 = AC
  addScriptBtn.TextColor3 = Color3.new(1,1,1)
  addScriptBtn.Text = "+ Add Script"
  addScriptBtn.Font = FONT_BOLD; addScriptBtn.TextSize = SZ(13)
  addScriptBtn.BorderSizePixel = 0; addScriptBtn.ZIndex = 52; addScriptBtn.Parent = content
  Instance.new("UICorner", addScriptBtn).CornerRadius = UDim.new(0,10)

  local delModal = Instance.new("Frame")
  delModal.Size = UDim2.new(0,240,0,110)
  delModal.AnchorPoint = Vector2.new(0.5,0.5)
  delModal.Position = UDim2.new(0.5,0,0.5,0)
  delModal.Visible = false
  delModal.BackgroundColor3 = PAN
  delModal.ZIndex = 200
  delModal.Parent = gui
  Instance.new("UICorner", delModal).CornerRadius = UDim.new(0,12)
  local delModalStroke = Instance.new("UIStroke", delModal)
  delModalStroke.Color = ST; delModalStroke.Thickness = 1

  local delLabel = Instance.new("TextLabel")
  delLabel.Text = "\u{423}\u{434}\u{430}\u{43B}\u{438}\u{442}\u{44C}?"
  delLabel.Size = UDim2.new(1,-20,0,35); delLabel.Position = UDim2.new(0,10,0,5)
  delLabel.BackgroundTransparency = 1; delLabel.TextColor3 = TX
  delLabel.Font = FONT_BOLD; delLabel.TextSize = SZ(14); delLabel.TextWrapped = true
  delLabel.ZIndex = 201; delLabel.Parent = delModal

  local yesBtn = Instance.new("TextButton")
  yesBtn.Text = "Yes"; yesBtn.Size = UDim2.new(0,70,0,28)
  yesBtn.Position = UDim2.new(0.5,-75,1,-38)
  yesBtn.BackgroundColor3 = AC; yesBtn.TextColor3 = Color3.new(1,1,1)
  yesBtn.Font = FONT_BOLD; yesBtn.TextSize = SZ(14)
  yesBtn.BorderSizePixel = 0; yesBtn.ZIndex = 201; yesBtn.Parent = delModal
  Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0,8)

  local noBtn = Instance.new("TextButton")
  noBtn.Text = "No"; noBtn.Size = UDim2.new(0,70,0,28)
  noBtn.Position = UDim2.new(0.5,5,1,-38)
  noBtn.BackgroundColor3 = ST; noBtn.TextColor3 = Color3.new(1,1,1)
  noBtn.Font = FONT_BOLD; noBtn.TextSize = SZ(14)
  noBtn.BorderSizePixel = 0; noBtn.ZIndex = 201; noBtn.Parent = delModal
  Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0,8)

  local renderScriptsView

  yesBtn.MouseButton1Click:Connect(function()
    if pendingDelete then
      if pendingDelete.type == "script" then
        local c2 = safeRead(pendingDelete.filename)
        if c2 then
          local n = getNextDeleteNumber()
          safeWrite("ScriptHasDelte.Loader." .. n .. ".txt", c2)
        end
        safeDelete(pendingDelete.filename)
      elseif pendingDelete.type == "folder" then
        for i, f in ipairs(Folders) do
          if f.id == pendingDelete.id then table.remove(Folders, i); break end
        end
        saveFolders()
        for _, s in ipairs(loadAllScriptFiles()) do
          if s.folderId == pendingDelete.id then
            local c3 = safeRead(s.filename)
            local ok3, data = pcall(function() return HttpService:JSONDecode(c3) end)
            if ok3 then data.folderId = "root"; safeWrite(s.filename, HttpService:JSONEncode(data)) end
          end
        end
      end
    end
    delModal.Visible = false
    pendingDelete = nil
    if renderScriptsView then renderScriptsView() end
  end)
  noBtn.MouseButton1Click:Connect(function()
    delModal.Visible = false; pendingDelete = nil
  end)

  local folderModal = Instance.new("Frame")
  folderModal.Size = UDim2.new(0,260,0,130)
  folderModal.AnchorPoint = Vector2.new(0.5,0.5)
  folderModal.Position = UDim2.new(0.5,0,0.5,0)
  folderModal.Visible = false
  folderModal.BackgroundColor3 = PAN
  folderModal.ZIndex = 200
  folderModal.Parent = gui
  Instance.new("UICorner", folderModal).CornerRadius = UDim.new(0,12)
  local folderModalStroke = Instance.new("UIStroke", folderModal)
  folderModalStroke.Color = AC; folderModalStroke.Thickness = 1

  local folderTitle = Instance.new("TextLabel")
  folderTitle.Text = "\u{41D}\u{43E}\u{432}\u{430}\u{44F} \u{43F}\u{430}\u{43F}\u{43A}\u{430}"; folderTitle.Size = UDim2.new(1,0,0,24)
  folderTitle.Position = UDim2.new(0,0,0,8)
  folderTitle.BackgroundTransparency = 1; folderTitle.TextColor3 = AC
  folderTitle.Font = FONT_BOLD; folderTitle.TextSize = SZ(14)
  folderTitle.ZIndex = 201; folderTitle.Parent = folderModal

  local folderNameInput = Instance.new("TextBox")
  folderNameInput.Size = UDim2.new(1,-20,0,32); folderNameInput.Position = UDim2.new(0,10,0,38)
  folderNameInput.PlaceholderText = "\u{41D}\u{430}\u{437}\u{432}\u{430}\u{43D}\u{438}\u{435} \u{43F}\u{430}\u{43F}\u{43A}\u{438}..."; folderNameInput.Text = ""
  folderNameInput.BackgroundColor3 = PANA; folderNameInput.TextColor3 = TX
  folderNameInput.Font = FONT_REG; folderNameInput.TextSize = SZ(13)
  folderNameInput.ZIndex = 201; folderNameInput.Parent = folderModal
  Instance.new("UICorner", folderNameInput).CornerRadius = UDim.new(0,8)

  local folderConfirmBtn = Instance.new("TextButton")
  folderConfirmBtn.Text = "\u{421}\u{43E}\u{437}\u{434}\u{430}\u{442}\u{44C}"; folderConfirmBtn.Size = UDim2.new(0,90,0,30)
  folderConfirmBtn.Position = UDim2.new(0.5,-95,1,-40)
  folderConfirmBtn.BackgroundColor3 = AC; folderConfirmBtn.TextColor3 = Color3.new(1,1,1)
  folderConfirmBtn.Font = FONT_BOLD; folderConfirmBtn.TextSize = SZ(13)
  folderConfirmBtn.BorderSizePixel = 0; folderConfirmBtn.ZIndex = 201; folderConfirmBtn.Parent = folderModal
  Instance.new("UICorner", folderConfirmBtn).CornerRadius = UDim.new(0,8)

  local folderCancelBtn = Instance.new("TextButton")
  folderCancelBtn.Text = "\u{41E}\u{442}\u{43C}\u{435}\u{43D}\u{430}"; folderCancelBtn.Size = UDim2.new(0,90,0,30)
  folderCancelBtn.Position = UDim2.new(0.5,5,1,-40)
  folderCancelBtn.BackgroundColor3 = ST; folderCancelBtn.TextColor3 = Color3.new(1,1,1)
  folderCancelBtn.Font = FONT_BOLD; folderCancelBtn.TextSize = SZ(13)
  folderCancelBtn.BorderSizePixel = 0; folderCancelBtn.ZIndex = 201; folderCancelBtn.Parent = folderModal
  Instance.new("UICorner", folderCancelBtn).CornerRadius = UDim.new(0,8)

  folderCancelBtn.MouseButton1Click:Connect(function() folderModal.Visible = false end)
  folderConfirmBtn.MouseButton1Click:Connect(function()
    local name = folderNameInput.Text
    if name ~= "" then
      table.insert(Folders, {id = genId(), name = name})
      saveFolders()
      folderModal.Visible = false
      if renderScriptsView then renderScriptsView() end
    else
      warn("\u{412}\u{432}\u{435}\u{434}\u{438}\u{442}\u{435} \u{43D}\u{430}\u{437}\u{432}\u{430}\u{43D}\u{438}\u{435} \u{43F}\u{430}\u{43F}\u{43A}\u{438}!")
    end
  end)
  newFolderBtn.MouseButton1Click:Connect(function()
    folderNameInput.Text = ""
    folderModal.Visible = true
  end)
  backBtn.MouseButton1Click:Connect(function()
    currentFolder = "root"
    if renderScriptsView then renderScriptsView() end
  end)

  local addModal = Instance.new("Frame")
  addModal.Size = UDim2.new(0,300,0,230)
  addModal.AnchorPoint = Vector2.new(0.5,0.5)
  addModal.Position = UDim2.new(0.5,0,0.5,0)
  addModal.Visible = false
  addModal.BackgroundColor3 = PAN
  addModal.ZIndex = 200
  addModal.Parent = gui
  Instance.new("UICorner", addModal).CornerRadius = UDim.new(0,12)
  local addModalStroke = Instance.new("UIStroke", addModal)
  addModalStroke.Color = AC; addModalStroke.Thickness = 1

  local addTitle = Instance.new("TextLabel")
  addTitle.Text = "\u{41D}\u{43E}\u{432}\u{44B}\u{439} \u{441}\u{43A}\u{440}\u{438}\u{43F}\u{442}"; addTitle.Size = UDim2.new(1,0,0,30)
  addTitle.BackgroundTransparency = 1; addTitle.TextColor3 = AC
  addTitle.Font = FONT_BOLD; addTitle.TextSize = SZ(15)
  addTitle.ZIndex = 201; addTitle.Parent = addModal

  local nameInput = Instance.new("TextBox")
  nameInput.Size = UDim2.new(1,-20,0,30); nameInput.Position = UDim2.new(0,10,0,35)
  nameInput.PlaceholderText = "Script Name..."; nameInput.Text = ""
  nameInput.BackgroundColor3 = PANA; nameInput.TextColor3 = TX
  nameInput.Font = FONT_REG; nameInput.TextSize = SZ(13)
  nameInput.ZIndex = 201; nameInput.Parent = addModal
  Instance.new("UICorner", nameInput).CornerRadius = UDim.new(0,8)

  local codeInput = Instance.new("TextBox")
  codeInput.Size = UDim2.new(1,-20,0,90); codeInput.Position = UDim2.new(0,10,0,75)
  codeInput.PlaceholderText = "loadstring(game:HttpGet(...))()"; codeInput.Text = ""
  codeInput.BackgroundColor3 = PANA; codeInput.TextColor3 = TX
  codeInput.Font = Enum.Font.Code; codeInput.TextSize = SZ(12)
  codeInput.MultiLine = true; codeInput.TextWrapped = true
  codeInput.TextYAlignment = Enum.TextYAlignment.Top
  codeInput.ZIndex = 201; codeInput.Parent = addModal
  Instance.new("UICorner", codeInput).CornerRadius = UDim.new(0,8)

  local confirmAddBtn = Instance.new("TextButton")
  confirmAddBtn.Text = "Add"; confirmAddBtn.Size = UDim2.new(0,90,0,30)
  confirmAddBtn.Position = UDim2.new(0.5,-95,1,-40)
  confirmAddBtn.BackgroundColor3 = AC; confirmAddBtn.TextColor3 = Color3.new(1,1,1)
  confirmAddBtn.Font = FONT_BOLD; confirmAddBtn.TextSize = SZ(14)
  confirmAddBtn.BorderSizePixel = 0; confirmAddBtn.ZIndex = 201; confirmAddBtn.Parent = addModal
  Instance.new("UICorner", confirmAddBtn).CornerRadius = UDim.new(0,8)

  local cancelAddBtn = Instance.new("TextButton")
  cancelAddBtn.Text = "Cancel"; cancelAddBtn.Size = UDim2.new(0,90,0,30)
  cancelAddBtn.Position = UDim2.new(0.5,5,1,-40)
  cancelAddBtn.BackgroundColor3 = ST; cancelAddBtn.TextColor3 = Color3.new(1,1,1)
  cancelAddBtn.Font = FONT_BOLD; cancelAddBtn.TextSize = SZ(14)
  cancelAddBtn.BorderSizePixel = 0; cancelAddBtn.ZIndex = 201; cancelAddBtn.Parent = addModal
  Instance.new("UICorner", cancelAddBtn).CornerRadius = UDim.new(0,8)

  cancelAddBtn.MouseButton1Click:Connect(function() addModal.Visible = false end)
  confirmAddBtn.MouseButton1Click:Connect(function()
    local name, code = nameInput.Text, codeInput.Text
    if name ~= "" and code ~= "" then
      local num = getNextScriptNumber()
      local filename = "Script.Loader." .. num .. ".txt"
      safeWrite(filename, HttpService:JSONEncode({name=name, code=code, folderId=currentFolder}))
      addModal.Visible = false
      if renderScriptsView then renderScriptsView() end
    else
      warn("\u{412}\u{432}\u{435}\u{434}\u{438}\u{442}\u{435} \u{43D}\u{430}\u{437}\u{432}\u{430}\u{43D}\u{438}\u{435} \u{438} \u{43A}\u{43E}\u{434} \u{441}\u{43A}\u{440}\u{438}\u{43F}\u{442}\u{430}!")
    end
  end)
  addScriptBtn.MouseButton1Click:Connect(function()
    nameInput.Text = ""; codeInput.Text = ""
    addModal.Visible = true
  end)

  renderScriptsView = function()
    for _,c in pairs(scroll:GetChildren()) do
      if c:IsA("Frame") then c:Destroy() end
    end

    if currentFolder == "root" then
      backBtn.Visible = false
      pathLabel.Text = "Root"
    else
      backBtn.Visible = true
      local f
      for _, ff in ipairs(Folders) do
        if ff.id == currentFolder then f = ff; break end
      end
      pathLabel.Text = f and f.name or "?"
    end

    if currentFolder == "root" then
      for _, f in ipairs(Folders) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1,-4,0,42); row.BackgroundColor3 = PANA
        row.BorderSizePixel = 0; row.ZIndex = 53; row.Parent = scroll
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

        local openBtn = Instance.new("TextButton")
        openBtn.Size = UDim2.new(1,-40,1,0); openBtn.BackgroundTransparency = 1
        openBtn.Text = "> " .. f.name; openBtn.TextSize = SZ(13)
        openBtn.Font = FONT_BOLD; openBtn.TextColor3 = TX
        openBtn.TextXAlignment = Enum.TextXAlignment.Left; openBtn.ZIndex = 54; openBtn.Parent = row
        local pad = Instance.new("UIPadding", openBtn); pad.PaddingLeft = UDim.new(0,10)
        openBtn.MouseButton1Click:Connect(function()
          currentFolder = f.id
          if renderScriptsView then renderScriptsView() end
        end)

        local delFolderBtn = Instance.new("TextButton")
        delFolderBtn.AnchorPoint = Vector2.new(1,0.5)
        delFolderBtn.Position = UDim2.new(1,-6,0.5,0)
        delFolderBtn.Size = UDim2.new(0,28,0,28)
        delFolderBtn.BackgroundColor3 = ST
        delFolderBtn.Text = "X"; delFolderBtn.TextColor3 = Color3.new(1,1,1); delFolderBtn.TextSize = SZ(12)
        delFolderBtn.Font = FONT_BOLD
        delFolderBtn.BorderSizePixel = 0
        delFolderBtn.ZIndex = 54; delFolderBtn.Parent = row
        Instance.new("UICorner", delFolderBtn).CornerRadius = UDim.new(0,6)
        delFolderBtn.MouseButton1Click:Connect(function()
          pendingDelete = {type = "folder", id = f.id}
          delModal.Visible = true
        end)
      end

      local riseRow = Instance.new("Frame")
      riseRow.Size = UDim2.new(1,-4,0,42); riseRow.BackgroundColor3 = PANA
      riseRow.BorderSizePixel = 0; riseRow.ZIndex = 53; riseRow.Parent = scroll
      Instance.new("UICorner", riseRow).CornerRadius = UDim.new(0,8)
      local riseStroke = Instance.new("UIStroke", riseRow)
      riseStroke.Color = AC; riseStroke.Thickness = 1

      local riseBtn = Instance.new("TextButton")
      riseBtn.Size = UDim2.new(1,0,1,0); riseBtn.BackgroundTransparency = 1
      riseBtn.Text = "Rise"; riseBtn.TextSize = SZ(14)
      riseBtn.Font = FONT_BOLD; riseBtn.TextColor3 = AC
      riseBtn.ZIndex = 54; riseBtn.Parent = riseRow
      riseBtn.MouseButton1Click:Connect(function()
        pcall(function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/joshhhie/rise/refs/heads/main/loader.lua"))()
        end)
      end)
    end

    for _, s in ipairs(loadAllScriptFiles()) do
      if s.folderId == currentFolder then
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1,-4,0,42); row.BackgroundColor3 = PANA
        row.BorderSizePixel = 0; row.ZIndex = 53; row.Parent = scroll
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

        local runBtn = Instance.new("TextButton")
        runBtn.Size = UDim2.new(1,-40,1,0); runBtn.BackgroundTransparency = 1
        runBtn.Text = s.name; runBtn.TextSize = SZ(13)
        runBtn.Font = FONT_BOLD; runBtn.TextColor3 = TX
        runBtn.TextXAlignment = Enum.TextXAlignment.Left; runBtn.ZIndex = 54; runBtn.Parent = row
        local pad = Instance.new("UIPadding", runBtn); pad.PaddingLeft = UDim.new(0,10)
        pcall(function() runBtn.TextTruncate = Enum.TextTruncate.AtEnd end)
        runBtn.MouseButton1Click:Connect(function()
          pcall(function() loadstring(s.code)() end)
        end)

        local delBtn = Instance.new("TextButton")
        delBtn.AnchorPoint = Vector2.new(1,0.5)
        delBtn.Position = UDim2.new(1,-6,0.5,0)
        delBtn.Size = UDim2.new(0,28,0,28)
        delBtn.BackgroundColor3 = ST
        delBtn.Text = "X"; delBtn.TextColor3 = Color3.new(1,1,1); delBtn.TextSize = SZ(12)
        delBtn.Font = FONT_BOLD
        delBtn.BorderSizePixel = 0
        delBtn.ZIndex = 54; delBtn.Parent = row
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0,6)
        delBtn.MouseButton1Click:Connect(function()
          pendingDelete = {type = "script", filename = s.filename}
          delModal.Visible = true
        end)
      end
    end
  end

  renderScriptsView()

  bSet.MouseButton1Click:Connect(function()
    CFG.theme = CFG.theme % #TH + 1
    saveConfig(); buildUI()
    task.defer(function()
      if main and main.Parent then main.Visible = true; main.Position = UDim2.new(0.07,0,0.09,0) end
    end)
  end)

  elseif activeApp == "servers" then

  local content = Instance.new("Frame")
  content.Size = UDim2.new(1,-28,1,-148); content.Position = UDim2.new(0,14,0,76)
  content.BackgroundTransparency = 1; content.ZIndex = 51; content.Parent = main

  local scroll = Instance.new("ScrollingFrame")
  scroll.Size = UDim2.new(1,0,1,-44); scroll.Position = UDim2.new(0,0,0,0)
  scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 4
  scroll.ScrollBarImageColor3 = AC; scroll.ZIndex = 52; scroll.Parent = content
  local sLay = Instance.new("UIListLayout", scroll)
  sLay.Padding = UDim.new(0,6); sLay.SortOrder = Enum.SortOrder.LayoutOrder
  sLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,sLay.AbsoluteContentSize.Y+8)
  end)

  local addServerBtn = Instance.new("TextButton")
  addServerBtn.Size = UDim2.new(1,0,0,36)
  addServerBtn.Position = UDim2.new(0,0,1,-36)
  addServerBtn.BackgroundColor3 = AC
  addServerBtn.TextColor3 = Color3.new(1,1,1)
  addServerBtn.Text = "+ \u{414}\u{43E}\u{431}\u{430}\u{432}\u{438}\u{442}\u{44C} \u{442}\u{435}\u{43A}\u{443}\u{449}\u{438}\u{439} \u{441}\u{435}\u{440}\u{432}\u{435}\u{440}"
  addServerBtn.Font = FONT_BOLD; addServerBtn.TextSize = SZ(13)
  addServerBtn.BorderSizePixel = 0; addServerBtn.ZIndex = 52; addServerBtn.Parent = content
  Instance.new("UICorner", addServerBtn).CornerRadius = UDim.new(0,10)

  local delModal = Instance.new("Frame")
  delModal.Size = UDim2.new(0,240,0,110)
  delModal.AnchorPoint = Vector2.new(0.5,0.5)
  delModal.Position = UDim2.new(0.5,0,0.5,0)
  delModal.Visible = false
  delModal.BackgroundColor3 = PAN
  delModal.ZIndex = 200
  delModal.Parent = gui
  Instance.new("UICorner", delModal).CornerRadius = UDim.new(0,12)
  local delModalStroke = Instance.new("UIStroke", delModal)
  delModalStroke.Color = ST; delModalStroke.Thickness = 1

  local delLabel = Instance.new("TextLabel")
  delLabel.Text = "\u{423}\u{434}\u{430}\u{43B}\u{438}\u{442}\u{44C} \u{441}\u{435}\u{440}\u{432}\u{435}\u{440}?"
  delLabel.Size = UDim2.new(1,-20,0,35); delLabel.Position = UDim2.new(0,10,0,5)
  delLabel.BackgroundTransparency = 1; delLabel.TextColor3 = TX
  delLabel.Font = FONT_BOLD; delLabel.TextSize = SZ(14); delLabel.TextWrapped = true
  delLabel.ZIndex = 201; delLabel.Parent = delModal

  local yesBtn = Instance.new("TextButton")
  yesBtn.Text = "Yes"; yesBtn.Size = UDim2.new(0,70,0,28)
  yesBtn.Position = UDim2.new(0.5,-75,1,-38)
  yesBtn.BackgroundColor3 = AC; yesBtn.TextColor3 = Color3.new(1,1,1)
  yesBtn.Font = FONT_BOLD; yesBtn.TextSize = SZ(14)
  yesBtn.BorderSizePixel = 0; yesBtn.ZIndex = 201; yesBtn.Parent = delModal
  Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0,8)

  local noBtn = Instance.new("TextButton")
  noBtn.Text = "No"; noBtn.Size = UDim2.new(0,70,0,28)
  noBtn.Position = UDim2.new(0.5,5,1,-38)
  noBtn.BackgroundColor3 = ST; noBtn.TextColor3 = Color3.new(1,1,1)
  noBtn.Font = FONT_BOLD; noBtn.TextSize = SZ(14)
  noBtn.BorderSizePixel = 0; noBtn.ZIndex = 201; noBtn.Parent = delModal
  Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0,8)

  local pendingServerDelete = nil
  local renderServersView

  yesBtn.MouseButton1Click:Connect(function()
    if pendingServerDelete then deleteServerEntry(pendingServerDelete) end
    delModal.Visible = false
    pendingServerDelete = nil
    if renderServersView then renderServersView() end
  end)
  noBtn.MouseButton1Click:Connect(function()
    delModal.Visible = false; pendingServerDelete = nil
  end)

  local function rowBtn(parent, txt, w, bg, xFromRight, yPos)
    local b = Instance.new("TextButton"); b.Text = txt; b.Size = UDim2.new(0,w,0,22)
    b.Position = UDim2.new(1, xFromRight, 1, yPos)
    b.BackgroundColor3 = bg; b.TextColor3 = Color3.new(1,1,1)
    b.Font = FONT_BOLD; b.TextSize = SZ(11)
    b.BorderSizePixel = 0; b.ZIndex = 54; b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
  end

  renderServersView = function()
    for _,c in pairs(scroll:GetChildren()) do
      if c:IsA("Frame") then c:Destroy() end
    end
    for _, entry in ipairs(Store) do
      local card = Instance.new("Frame")
      card.Size = UDim2.new(1,-4,0,78)
      card.BackgroundColor3 = PANA
      card.BorderSizePixel = 0
      card.ZIndex = 53
      card.Parent = scroll
      Instance.new("UICorner", card).CornerRadius = UDim.new(0,8)

      local isCurrent = entry.JobId == CurrentJobId
      local badge = Instance.new("TextLabel")
      badge.BackgroundTransparency = 1
      badge.Position = UDim2.new(0,10,0,6)
      badge.Size = UDim2.new(1,-20,0,16)
      badge.Text = isCurrent and "\u{422}\u{435}\u{43A}\u{443}\u{449}\u{438}\u{439} \u{441}\u{435}\u{440}\u{432}\u{435}\u{440}" or ("PlaceId: " .. tostring(entry.PlaceId))
      badge.TextColor3 = isCurrent and AC or TXM
      badge.Font = FONT_REG; badge.TextSize = SZ(11)
      badge.TextXAlignment = Enum.TextXAlignment.Left
      badge.ZIndex = 54; badge.Parent = card

      local playersLabel = Instance.new("TextLabel")
      playersLabel.BackgroundTransparency = 1
      playersLabel.Position = UDim2.new(0,10,0,24)
      playersLabel.Size = UDim2.new(1,-20,0,24)
      local playersText = (#entry.Players > 0) and table.concat(entry.Players, ", ") or "\u{41D}\u{435}\u{442} \u{434}\u{430}\u{43D}\u{43D}\u{44B}\u{445}"
      playersLabel.Text = "\u{418}\u{433}\u{440}\u{43E}\u{43A}\u{438}: " .. playersText
      playersLabel.TextWrapped = true
      playersLabel.Font = FONT_REG; playersLabel.TextSize = SZ(11)
      playersLabel.TextColor3 = TX
      playersLabel.TextXAlignment = Enum.TextXAlignment.Left
      playersLabel.TextYAlignment = Enum.TextYAlignment.Top
      playersLabel.ZIndex = 54; playersLabel.Parent = card

      local timeLabel = Instance.new("TextLabel")
      timeLabel.BackgroundTransparency = 1
      timeLabel.Position = UDim2.new(0,10,1,-18)
      timeLabel.Size = UDim2.new(0.5,-10,0,14)
      timeLabel.Text = formatTime(entry.SavedAt)
      timeLabel.Font = FONT_REG; timeLabel.TextSize = SZ(9)
      timeLabel.TextColor3 = TXM
      timeLabel.TextXAlignment = Enum.TextXAlignment.Left
      timeLabel.ZIndex = 54; timeLabel.Parent = card

      local joinBtn = rowBtn(card, "Join", 56, AC, -128, -30)
      joinBtn.MouseButton1Click:Connect(function() joinServerEntry(entry) end)

      local delBtn = rowBtn(card, "Delete", 56, ST, -66, -30)
      delBtn.MouseButton1Click:Connect(function()
        pendingServerDelete = entry.JobId
        delModal.Visible = true
      end)
    end
  end

  addServerBtn.MouseButton1Click:Connect(function()
    addCurrentServer()
    if renderServersView then renderServersView() end
  end)

  renderServersView()

  bSet.MouseButton1Click:Connect(function()
    CFG.theme = CFG.theme % #TH + 1
    saveConfig(); buildUI()
    task.defer(function()
      if main and main.Parent then main.Visible = true; main.Position = UDim2.new(0.07,0,0.09,0) end
    end)
  end)

  elseif activeApp == "explorer" then

  local content = Instance.new("Frame")
  content.Size = UDim2.new(1,-28,1,-148); content.Position = UDim2.new(0,14,0,76)
  content.BackgroundTransparency = 1; content.ZIndex = 51; content.Parent = main

  local searchBar = Instance.new("Frame"); searchBar.Size = UDim2.new(1,0,0,28)
  searchBar.BackgroundColor3 = PAN; searchBar.BorderSizePixel = 0; searchBar.ZIndex = 52; searchBar.Parent = content
  Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0,6)
  local searchBox = Instance.new("TextBox")
  searchBox.Size = UDim2.new(1,-40,1,0); searchBox.Position = UDim2.new(0,10,0,0)
  searchBox.BackgroundTransparency = 1; searchBox.TextColor3 = TX
  searchBox.PlaceholderText = "Search instances..."; searchBox.PlaceholderColor3 = TXM
  searchBox.Font = FONT_REG; searchBox.TextSize = SZ(11)
  searchBox.TextXAlignment = Enum.TextXAlignment.Left
  searchBox.ZIndex = 53; searchBox.Parent = searchBar
  local searchGo = Instance.new("TextButton"); searchGo.Text = "X"
  searchGo.Size = UDim2.new(0,24,0,20); searchGo.Position = UDim2.new(1,-30,0,4)
  searchGo.BackgroundColor3 = rgb(60,60,60); searchGo.TextColor3 = Color3.new(1,1,1)
  searchGo.Font = FONT_BOLD; searchGo.TextSize = SZ(10)
  searchGo.BorderSizePixel = 0; searchGo.ZIndex = 53; searchGo.Parent = searchBar
  Instance.new("UICorner", searchGo).CornerRadius = UDim.new(0,4)

  local pathBar = Instance.new("Frame"); pathBar.Size = UDim2.new(1,0,0,22)
  pathBar.Position = UDim2.new(0,0,0,32)
  pathBar.BackgroundTransparency = 1; pathBar.ZIndex = 52; pathBar.Parent = content
  local backBtn = Instance.new("TextButton")
  backBtn.Size = UDim2.new(0,50,1,0)
  backBtn.Text = "< Up"
  backBtn.TextSize = SZ(11)
  backBtn.Font = FONT_BOLD
  backBtn.BackgroundColor3 = PANA
  backBtn.TextColor3 = AC
  backBtn.BorderSizePixel = 0
  backBtn.ZIndex = 53
  backBtn.Parent = pathBar
  Instance.new("UICorner", backBtn).CornerRadius = UDim.new(0,6)
  local pathLabel = Instance.new("TextLabel")
  pathLabel.BackgroundTransparency = 1
  pathLabel.Position = UDim2.new(0,58,0,0)
  pathLabel.Size = UDim2.new(1,-58,1,0)
  pathLabel.Text = "game"
  pathLabel.TextSize = SZ(10)
  pathLabel.Font = FONT_REG
  pathLabel.TextColor3 = TXM
  pathLabel.TextXAlignment = Enum.TextXAlignment.Left
  pathLabel.TextTruncate = Enum.TextTruncate.AtEnd
  pathLabel.ZIndex = 53
  pathLabel.Parent = pathBar

  local scroll = Instance.new("ScrollingFrame")
  scroll.Size = UDim2.new(1,0,1,-58); scroll.Position = UDim2.new(0,0,0,58)
  scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 4
  scroll.ScrollBarImageColor3 = AC; scroll.ZIndex = 52; scroll.Parent = content
  local sLay = Instance.new("UIListLayout", scroll)
  sLay.Padding = UDim.new(0,2); sLay.SortOrder = Enum.SortOrder.LayoutOrder
  sLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,sLay.AbsoluteContentSize.Y+8)
  end)

  local propModal = Instance.new("Frame")
  propModal.Size = UDim2.new(0,280,0,320)
  propModal.AnchorPoint = Vector2.new(0.5,0.5)
  propModal.Position = UDim2.new(0.5,0,0.5,0)
  propModal.Visible = false
  propModal.BackgroundColor3 = PAN
  propModal.ZIndex = 200
  propModal.Parent = gui
  Instance.new("UICorner", propModal).CornerRadius = UDim.new(0,12)
  local propStroke = Instance.new("UIStroke", propModal)
  propStroke.Color = AC; propStroke.Thickness = 1

  local propScroll = Instance.new("ScrollingFrame")
  propScroll.Size = UDim2.new(1,-16,1,-52); propScroll.Position = UDim2.new(0,8,0,8)
  propScroll.BackgroundTransparency = 1; propScroll.BorderSizePixel = 0
  propScroll.ScrollBarThickness = 3; propScroll.ScrollBarImageColor3 = AC
  propScroll.ZIndex = 201; propScroll.Parent = propModal
  local propLay = Instance.new("UIListLayout", propScroll)
  propLay.Padding = UDim.new(0,6)
  propLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    propScroll.CanvasSize = UDim2.new(0,0,0,propLay.AbsoluteContentSize.Y+8)
  end)

  local propCloseBtn = Instance.new("TextButton")
  propCloseBtn.Text = "Close"
  propCloseBtn.Size = UDim2.new(1,-16,0,32)
  propCloseBtn.Position = UDim2.new(0,8,1,-40)
  propCloseBtn.BackgroundColor3 = ST; propCloseBtn.TextColor3 = Color3.new(1,1,1)
  propCloseBtn.Font = FONT_BOLD; propCloseBtn.TextSize = SZ(12)
  propCloseBtn.BorderSizePixel = 0; propCloseBtn.ZIndex = 201; propCloseBtn.Parent = propModal
  Instance.new("UICorner", propCloseBtn).CornerRadius = UDim.new(0,8)
  propCloseBtn.MouseButton1Click:Connect(function() propModal.Visible = false end)

  local explorerRoot = workspace
  local explorerExpanded = {}
  local renderExplorer

  local function getPath(inst)
    local ok1, p = pcall(function() return inst:GetFullName() end)
    return ok1 and p or inst.Name
  end

  local function openPropPanel(inst)
    for _,c in pairs(propScroll:GetChildren()) do
      if c:IsA("Frame") then c:Destroy() end
    end
    local function field(label, value)
      local row = Instance.new("Frame"); row.Size = UDim2.new(1,0,0,36)
      row.BackgroundColor3 = PANA; row.BorderSizePixel = 0; row.ZIndex = 202; row.Parent = propScroll
      Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
      local l1 = Instance.new("TextLabel"); l1.Text = label
      l1.Size = UDim2.new(1,-8,0,14); l1.Position = UDim2.new(0,6,0,2)
      l1.BackgroundTransparency = 1; l1.TextColor3 = TXM
      l1.Font = FONT_BOLD; l1.TextSize = SZ(9)
      l1.TextXAlignment = Enum.TextXAlignment.Left; l1.ZIndex = 203; l1.Parent = row
      local l2 = Instance.new("TextLabel"); l2.Text = tostring(value)
      l2.Size = UDim2.new(1,-8,0,16); l2.Position = UDim2.new(0,6,0,17)
      l2.BackgroundTransparency = 1; l2.TextColor3 = TX
      l2.Font = FONT_REG; l2.TextSize = SZ(11)
      l2.TextXAlignment = Enum.TextXAlignment.Left; l2.TextTruncate = Enum.TextTruncate.AtEnd
      l2.ZIndex = 203; l2.Parent = row
      return row
    end
    field("Name", inst.Name)
    field("ClassName", inst.ClassName)
    field("Path", getPath(inst))

    local nameRow = Instance.new("Frame"); nameRow.Size = UDim2.new(1,0,0,32)
    nameRow.BackgroundColor3 = PANA; nameRow.BorderSizePixel = 0; nameRow.ZIndex = 202; nameRow.Parent = propScroll
    Instance.new("UICorner", nameRow).CornerRadius = UDim.new(0,6)
    local nameBox = Instance.new("TextBox"); nameBox.Text = inst.Name
    nameBox.Size = UDim2.new(1,-70,1,-6); nameBox.Position = UDim2.new(0,6,0,3)
    nameBox.BackgroundColor3 = BG; nameBox.TextColor3 = TX
    nameBox.Font = FONT_REG; nameBox.TextSize = SZ(11)
    nameBox.TextXAlignment = Enum.TextXAlignment.Left
    nameBox.ZIndex = 203; nameBox.Parent = nameRow
    Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0,4)
    local renameBtn = Instance.new("TextButton"); renameBtn.Text = "Rename"
    renameBtn.Size = UDim2.new(0,60,1,-6); renameBtn.Position = UDim2.new(1,-64,0,3)
    renameBtn.BackgroundColor3 = AC; renameBtn.TextColor3 = Color3.new(1,1,1)
    renameBtn.Font = FONT_BOLD; renameBtn.TextSize = SZ(9)
    renameBtn.BorderSizePixel = 0; renameBtn.ZIndex = 203; renameBtn.Parent = nameRow
    Instance.new("UICorner", renameBtn).CornerRadius = UDim.new(0,5)
    renameBtn.MouseButton1Click:Connect(function()
      pcall(function() inst.Name = nameBox.Text end)
      if renderExplorer then renderExplorer() end
    end)

    local function toggleField(label, getter, setter)
      local row = Instance.new("Frame"); row.Size = UDim2.new(1,0,0,32)
      row.BackgroundColor3 = PANA; row.BorderSizePixel = 0; row.ZIndex = 202; row.Parent = propScroll
      Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
      local l1 = Instance.new("TextLabel"); l1.Text = label
      l1.Size = UDim2.new(1,-56,1,0); l1.Position = UDim2.new(0,8,0,0)
      l1.BackgroundTransparency = 1; l1.TextColor3 = TX
      l1.Font = FONT_BOLD; l1.TextSize = SZ(11)
      l1.TextXAlignment = Enum.TextXAlignment.Left; l1.ZIndex = 203; l1.Parent = row
      local track = Instance.new("Frame"); track.Size = UDim2.new(0,40,0,20)
      track.Position = UDim2.new(1,-48,0.5,-10)
      track.BorderSizePixel = 0; track.ZIndex = 203; track.Parent = row
      Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
      local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,16,0,16)
      knob.Position = UDim2.new(0,2,0,2)
      knob.BackgroundColor3 = Color3.new(1,1,1)
      knob.BorderSizePixel = 0; knob.ZIndex = 204; knob.Parent = track
      Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
      local function paint()
        local on = getter()
        track.BackgroundColor3 = on and AC or rgb(60,60,60)
        knob.Position = on and UDim2.new(1,-18,0,2) or UDim2.new(0,2,0,2)
      end
      paint()
      local b = Instance.new("TextButton")
      b.BackgroundTransparency = 1; b.Size = UDim2.new(1,0,1,0); b.Text = ""; b.ZIndex = 205; b.Parent = row
      b.MouseButton1Click:Connect(function() setter(not getter()); paint() end)
    end

    local okPart, isPart = pcall(function() return inst:IsA("BasePart") end)
    if okPart and isPart then
      toggleField("Anchored", function() return inst.Anchored end, function(v) pcall(function() inst.Anchored = v end) end)
      toggleField("CanCollide", function() return inst.CanCollide end, function(v) pcall(function() inst.CanCollide = v end) end)

      local transRow = Instance.new("Frame"); transRow.Size = UDim2.new(1,0,0,32)
      transRow.BackgroundColor3 = PANA; transRow.BorderSizePixel = 0; transRow.ZIndex = 202; transRow.Parent = propScroll
      Instance.new("UICorner", transRow).CornerRadius = UDim.new(0,6)
      local tl = Instance.new("TextLabel"); tl.Text = "Transparency"
      tl.Size = UDim2.new(0,90,1,0); tl.Position = UDim2.new(0,8,0,0)
      tl.BackgroundTransparency = 1; tl.TextColor3 = TX
      tl.Font = FONT_BOLD; tl.TextSize = SZ(11)
      tl.TextXAlignment = Enum.TextXAlignment.Left; tl.ZIndex = 203; tl.Parent = transRow
      local tBox = Instance.new("TextBox"); tBox.Text = tostring(inst.Transparency)
      tBox.Size = UDim2.new(0,60,0,24); tBox.Position = UDim2.new(1,-96,0.5,-12)
      tBox.BackgroundColor3 = BG; tBox.TextColor3 = TX
      tBox.Font = FONT_REG; tBox.TextSize = SZ(11)
      tBox.ZIndex = 203; tBox.Parent = transRow
      Instance.new("UICorner", tBox).CornerRadius = UDim.new(0,4)
      local tApply = Instance.new("TextButton"); tApply.Text = "Set"
      tApply.Size = UDim2.new(0,30,0,24); tApply.Position = UDim2.new(1,-32,0.5,-12)
      tApply.BackgroundColor3 = AC; tApply.TextColor3 = Color3.new(1,1,1)
      tApply.Font = FONT_BOLD; tApply.TextSize = SZ(9)
      tApply.BorderSizePixel = 0; tApply.ZIndex = 203; tApply.Parent = transRow
      Instance.new("UICorner", tApply).CornerRadius = UDim.new(0,4)
      tApply.MouseButton1Click:Connect(function()
        local n = tonumber(tBox.Text)
        if n then pcall(function() inst.Transparency = n end) end
      end)
    end

    local destroyBtn = Instance.new("TextButton"); destroyBtn.Text = "Destroy Instance"
    destroyBtn.Size = UDim2.new(1,0,0,32)
    destroyBtn.BackgroundColor3 = ST; destroyBtn.TextColor3 = Color3.new(1,1,1)
    destroyBtn.Font = FONT_BOLD; destroyBtn.TextSize = SZ(11)
    destroyBtn.BorderSizePixel = 0; destroyBtn.ZIndex = 202; destroyBtn.Parent = propScroll
    Instance.new("UICorner", destroyBtn).CornerRadius = UDim.new(0,6)
    destroyBtn.MouseButton1Click:Connect(function()
      pcall(function() inst:Destroy() end)
      propModal.Visible = false
      if renderExplorer then renderExplorer() end
    end)

    local copyBtn = Instance.new("TextButton"); copyBtn.Text = "Copy Path"
    copyBtn.Size = UDim2.new(1,0,0,32)
    copyBtn.BackgroundColor3 = rgb(60,60,60); copyBtn.TextColor3 = Color3.new(1,1,1)
    copyBtn.Font = FONT_BOLD; copyBtn.TextSize = SZ(11)
    copyBtn.BorderSizePixel = 0; copyBtn.ZIndex = 202; copyBtn.Parent = propScroll
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0,6)
    copyBtn.MouseButton1Click:Connect(function()
      local p = getPath(inst)
      local didCopy = false
      pcall(function() setclipboard(p); didCopy = true end)
      copyBtn.Text = didCopy and "Copied!" or p
      task.wait(1)
      copyBtn.Text = "Copy Path"
    end)

    propModal.Visible = true
  end

  renderExplorer = function()
    for _,c in pairs(scroll:GetChildren()) do
      if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
    end
    pathLabel.Text = getPath(explorerRoot)

    local query = searchBox.Text
    if query ~= "" then
      local qlow = query:lower()
      local results = {}
      local okd, desc = pcall(function() return explorerRoot:GetDescendants() end)
      if okd then
        for _, inst in ipairs(desc) do
          if inst.Name:lower():find(qlow, 1, true) then
            table.insert(results, inst)
            if #results >= 150 then break end
          end
        end
      end
      for _, inst in ipairs(results) do
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1,-2,0,28)
        row.BackgroundColor3 = PANA; row.BorderSizePixel = 0
        row.Text = inst.Name .. "  (" .. inst.ClassName .. ")"
        row.TextColor3 = TX; row.Font = FONT_REG; row.TextSize = SZ(10)
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.ZIndex = 53; row.Parent = scroll
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,5)
        local pad = Instance.new("UIPadding", row); pad.PaddingLeft = UDim.new(0,8)
        row.MouseButton1Click:Connect(function() openPropPanel(inst) end)
      end
      return
    end

    local okc, children = pcall(function() return explorerRoot:GetChildren() end)
    if not okc then return end
    table.sort(children, function(a,b) return a.Name < b.Name end)
    for _, inst in ipairs(children) do
      local row = Instance.new("Frame")
      row.Size = UDim2.new(1,-2,0,28)
      row.BackgroundColor3 = PANA; row.BorderSizePixel = 0
      row.ZIndex = 53; row.Parent = scroll
      Instance.new("UICorner", row).CornerRadius = UDim.new(0,5)

      local okcc, hasChildren = pcall(function() return #inst:GetChildren() > 0 end)
      local expandBtn = Instance.new("TextButton")
      expandBtn.Size = UDim2.new(0,24,1,0)
      expandBtn.BackgroundTransparency = 1
      expandBtn.Text = (okcc and hasChildren) and ">" or ""
      expandBtn.TextColor3 = AC; expandBtn.Font = FONT_BOLD; expandBtn.TextSize = SZ(12)
      expandBtn.ZIndex = 54; expandBtn.Parent = row
      expandBtn.MouseButton1Click:Connect(function()
        explorerRoot = inst
        renderExplorer()
      end)

      local nameBtn = Instance.new("TextButton")
      nameBtn.Size = UDim2.new(1,-28,1,0); nameBtn.Position = UDim2.new(0,26,0,0)
      nameBtn.BackgroundTransparency = 1
      nameBtn.Text = inst.Name .. "  (" .. inst.ClassName .. ")"
      nameBtn.TextColor3 = TX; nameBtn.Font = FONT_REG; nameBtn.TextSize = SZ(11)
      nameBtn.TextXAlignment = Enum.TextXAlignment.Left
      nameBtn.TextTruncate = Enum.TextTruncate.AtEnd
      nameBtn.ZIndex = 54; nameBtn.Parent = row
      nameBtn.MouseButton1Click:Connect(function() openPropPanel(inst) end)
    end
  end

  backBtn.MouseButton1Click:Connect(function()
    local okp, parent = pcall(function() return explorerRoot.Parent end)
    if okp and parent then
      explorerRoot = parent
      renderExplorer()
    end
  end)
  searchGo.MouseButton1Click:Connect(function() searchBox.Text = ""; renderExplorer() end)
  searchBox.FocusLost:Connect(function(enter) if enter then renderExplorer() end end)

  renderExplorer()

  bSet.MouseButton1Click:Connect(function()
    CFG.theme = CFG.theme % #TH + 1
    saveConfig(); buildUI()
    task.defer(function()
      if main and main.Parent then main.Visible = true; main.Position = UDim2.new(0.07,0,0.09,0) end
    end)
  end)

  end

  bMin.MouseButton1Click:Connect(function() hideMain() end)
  bX.MouseButton1Click:Connect(function() hideMain() end)
  tog.MouseButton1Click:Connect(function()
    if main.Visible then hideMain() else showMain() end
  end)

  if not _G.__RiseUltimateFirstShow then
    _G.__RiseUltimateFirstShow = true
    showMain()
  else
    main.Visible = true
    main.Position = UDim2.new(0.07,0,0.09,0)
  end
end

buildUI()
fixScroll()
print("[RiseUltimate] loaded!")
end)

if not ok then warn("[RiseUltimate] ERROR: "..tostring(err)) end
