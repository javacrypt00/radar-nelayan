-- // Radar Nelayan Server Monitor //
-- Discord @bloxgank
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- // CONFIGURATION //
local WEBHOOK_FISH = ""     -- webhook khusus ikan secret
local WEBHOOK_PLAYER = ""   -- webhook khusus player join/leave
local WEBHOOK_AVATAR = ""   -- isi dengan URL gambar PNG kamu
local PROXY = "https://square-haze-a007.remediashop.workers.dev"
local SCRIPT_ACTIVE = false

-- // DATABASE NAMA SECRET FISH //
local SecretFishList = {
    "Crystal Crab", "Orca", "Zombie Shark", "Zombie Megalodon", "Dead Zombie Shark",
    "Blob Shark", "Ghost Shark", "Skeleton Narwhal", "Ghost Worm Fish", "Worm Fish",
    "Megalodon", "1x1x1x1 Comet Shark", "Bloodmoon Whale", "Lochness Monster",
    "Monster Shark", "Eerie Shark", "Great Whale", "Frostborn Shark", "Thin Armored Shark",
    "Scare", "Queen Crab", "King Crab", "Cryoshade Glider", "Panther Eel",
    "Giant Squid", "Depthseeker Ray", "Robot Kraken", "Mosasaur Shark", "King Jelly",
    "Bone Whale", "Elshark Gran Maja", "Elpirate Gran Maja", "Ancient Whale",
    "Gladiator Shark", "Ancient Lochness Monster", "Talon Serpent", "Hacker Shark",
    "ElRetro Gran Maja", "Strawberry Choc Megalodon", "Krampus Shark",
    "Emerald Winter Whale", "Winter Frost Shark", "Icebreaker Whale", "Leviathan",
    "Pirate Megalodon", "Viridis Lurker", "Cursed Kraken", "Ancient Magma Whale",
    "Rainbow Comet Shark", "Love Nessie", "Broken Heart Nessie",
    "Mutant Runic Koi", "Ketupat Whale",
}

-- // DATABASE FORGOTTEN TIER //
local ForgottenList = {
    "Sea Eater", "Thunderzilla"
}

-- // DATABASE RUBY GEMSTONE //
local RubyList = { "Ruby" }

-- // DATABASE LEGENDARY (khusus mutasi Crystalized) //
local LegendaryCrystalList = {
    "Blue Sea Dragon", "Star Snail", "Cute Dumbo",
    "Blossom Jelly", "Bioluminescent Octopus"
}

-- // DATABASE GAMBAR IKAN (GitHub CDN) //
local FishImageURL = {
    ["Monster Shark"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Monster%20Shark.png",
    ["Megalodon"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Megalodon.png",
    ["Ancient Lochness Monster"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ancient%20Lochness%20Monster.png",
    ["Ancient Magma Whale"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ancient%20Magma%20Whale.png",
    ["Ancient Whale"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ancient%20Whale.png",
    ["Blob Shark"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Blob%20Shark.png",
    ["Bone Whale"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Bone%20Whale.png",
    ["Cosmic Mutant Shark"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Cosmic%20Mutant%20Shark.png",
    ["Cryoshade Glider"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Cryoshade%20Glider.png",
    ["Crystal Crab"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Crystal%20Crab.png",
    ["Cursed Kraken"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Cursed%20Kraken.png",
    ["Depthseeker Ray"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Depthseeker%20Ray.png",
    ["Eerie Shark"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Eerie%20Shark.png",
    ["Elpirate Gran Maja"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Elpirate%20Gran%20Maja.png",
    ["Elshark Gran Maja"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Elshark%20Gran%20Maja.png",
    ["Frostborn Shark"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Frostborn%20Shark.png",
    ["Ghost Shark"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ghost%20Shark.png",
    ["Giant Squid"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Giant%20Squid.png",
    ["Gladiator Shark"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Gladiator%20Shark.png",
    ["Great Whale"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Great%20Whale.png",
    ["Ketupat Whale"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ketupat%20Whale.png",
    ["King Crab"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/King%20Crab.png",
    ["King Jelly"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/King%20Jelly.png",
    ["Leviathan"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Leviathan.png",
    ["Lochness Monster"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Lochness%20Monster.png",
    ["Mosasaur Shark"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Mosasaur%20Shark.png",
    ["Orca"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Orca.png",
    ["Panther Eel"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Panther%20Eel.png",
    ["Pirate Megalodon"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Pirate%20Megalodon.png",
    ["Queen Crab"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Queen%20Crab.png",
    ["Rainbow Comet Shark"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Rainbow%20Comet%20Shark.png",
    ["Robot Kraken"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Robot%20Kraken.png",
    ["Ruby"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ruby%20Gemstone.png",
    ["Sea Eater"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Sea%20Eater.png",
    ["Skeleton Narwhal"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Skeleton%20Narwhal.png",
    ["Thin Armored Shark"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Thin%20Armor%20Shark.png",
    ["Thunderzilla"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Thunderzilla.png",
    ["Worm Fish"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Worm%20Fish.png",
}

local FishImageCache = {}
local AvatarCache = {}

-- // WEBHOOK SENDER — pisah fish vs player //
local function SendWebhookTo(webhookUrl, title, description, color, fields, imageUrl, thumbUrl)
    if not webhookUrl or webhookUrl == "" then return end
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not requestFunc then return end
    local embed = {
        ["title"] = title,
        ["description"] = description,
        ["color"] = color,
        ["fields"] = fields,
        ["footer"] = {["text"] = "Radar Nelayan Webhook | " .. os.date("%X")},
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    if imageUrl then embed["image"] = {["url"] = imageUrl} end
    if thumbUrl then embed["thumbnail"] = {["url"] = thumbUrl} end
    task.spawn(function()
        pcall(function()
            requestFunc({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    ["username"] = "Radar Nelayan",
                    ["avatar_url"] = WEBHOOK_AVATAR,
                    ["embeds"] = {embed}
                })
            })
        end)
    end)
end

local function SendFishWebhook(title, description, color, fields, imageUrl, thumbUrl)
    SendWebhookTo(WEBHOOK_FISH, title, description, color, fields, imageUrl, thumbUrl)
end

local function SendPlayerWebhook(title, description, color, fields, imageUrl, thumbUrl)
    SendWebhookTo(WEBHOOK_PLAYER, title, description, color, fields, imageUrl, thumbUrl)
end

-- // STRIP HTML TAGS //
local function StripTags(str)
    return string.gsub(str, "<[^>]+>", "")
end

local function FindSecretFish(fishName)
    local lower = string.lower(fishName)
    for _, baseName in ipairs(SecretFishList) do
        if string.find(lower, string.lower(baseName), 1, true) then
            local s = string.find(lower, string.lower(baseName), 1, true)
            local mutasi = nil
            if s and s > 1 then
                mutasi = fishName:sub(1, s - 1):match("^%s*(.-)%s*$")
                if mutasi == "" then mutasi = nil end
            end
            return baseName, mutasi
        end
    end
    return nil, nil
end

local function FindRuby(fishName)
    local lower = string.lower(fishName)
    if not string.find(lower, "ruby") then return nil end
    if not string.find(lower, "gemstone") then return nil end
    return "Ruby"
end

local function FindLegendaryCrystal(fishName)
    local lower = string.lower(fishName)
    if not string.find(lower, "crystalized") then return nil end
    for _, name in ipairs(LegendaryCrystalList) do
        if string.find(lower, string.lower(name), 1, true) then
            return name
        end
    end
    return nil
end

local function GetFishImageId(item)
    for _, desc in ipairs(item:GetDescendants()) do
        local ok, val = pcall(function()
            if desc:IsA("SpecialMesh") then return desc.TextureId
            elseif desc:IsA("Decal") or desc:IsA("Texture") then return desc.Texture
            elseif desc:IsA("ImageLabel") or desc:IsA("ImageButton") then return desc.Image
            end
            return nil
        end)
        if ok and val and val ~= "" and val ~= "rbxasset://" then
            local id = tostring(val):match("%d+")
            if id then return id end
        end
    end
    return nil
end

local function ParseChat(rawMsg)
    local msg = StripTags(rawMsg)
    msg = string.gsub(msg, "^%[Server%]:%s*", "")
    local playerName, fishFull, weight = string.match(msg, "^(.-) obtained an? (.-) %(([%d%.%a]+ ?kg)%)")
    if not playerName then
        playerName, fishFull = string.match(msg, "^(.-) obtained an? (.+)")
        weight = "N/A"
    end
    if not playerName or not fishFull then return nil end
    playerName = playerName:match("%[%a+%]:%s*(.+)") or playerName
    playerName = playerName:match("^%s*(.-)%s*$") or playerName
    weight = weight:match("^%s*(.-)%s*$") or weight
    fishFull = fishFull:match("^(.-)%s+with a 1 in") or fishFull
    fishFull = fishFull:match("^(.-)%s*[!%.]?$") or fishFull
    fishFull = fishFull:match("^%s*(.-)%s*$") or fishFull
    return { player = playerName, fish = fishFull, weight = weight }
end

local function CheckAndSend(rawMsg)
    if not SCRIPT_ACTIVE then return end
    if not string.find(string.lower(rawMsg), "obtained") then return end
    local data = ParseChat(rawMsg)
    if not data then return end

    local targetPlayer = Players:FindFirstChild(data.player)
    local avatarUrl = targetPlayer and (PROXY .. "/avatar/" .. tostring(targetPlayer.UserId) .. "?t=" .. tostring(os.time())) or nil

    local legendaryBase = FindLegendaryCrystal(data.fish)
    if legendaryBase then
        local imageUrl = FishImageURL[legendaryBase] or (FishImageCache[legendaryBase] and (PROXY .. "/asset/" .. FishImageCache[legendaryBase])) or nil
        SendFishWebhook("💎 CRYSTALIZED LEGENDARY!", nil, 3407871, {
            {["name"] = "Pemain", ["value"] = "**" .. data.player .. "**", ["inline"] = true},
            {["name"] = "Ikan",   ["value"] = "**" .. data.fish .. "**",   ["inline"] = true},
            {["name"] = "Mutasi", ["value"] = "✨ Crystalized",            ["inline"] = true},
            {["name"] = "Berat",  ["value"] = data.weight,                 ["inline"] = true},
        }, imageUrl, avatarUrl)
        return
    end

    local rubyBase = FindRuby(data.fish)
    if rubyBase then
        local imageUrl = FishImageURL[rubyBase] or (FishImageCache[rubyBase] and (PROXY .. "/asset/" .. FishImageCache[rubyBase])) or nil
        SendFishWebhook("💎 RUBY GEMSTONE!", nil, 16753920, {
            {["name"] = "Pemain", ["value"] = "**" .. data.player .. "**", ["inline"] = true},
            {["name"] = "Item",   ["value"] = "**" .. data.fish .. "**",   ["inline"] = true},
            {["name"] = "Berat",  ["value"] = data.weight,                 ["inline"] = true},
        }, imageUrl, avatarUrl)
        return
    end

    local baseName, mutasi = FindSecretFish(data.fish)
    if not baseName then return end
    local imageUrl = FishImageURL[baseName] or (FishImageCache[baseName] and (PROXY .. "/asset/" .. FishImageCache[baseName])) or nil
    local fishLabel = "**" .. data.fish .. "**"
    if mutasi then fishLabel = "**" .. data.fish .. "** *(mutasi: " .. baseName .. ")*" end
    SendFishWebhook("🚨 SECRET FISH DETECTED!", nil, 1752220, {
        {["name"] = "Pemain", ["value"] = "**" .. data.player .. "**", ["inline"] = true},
        {["name"] = "Ikan",   ["value"] = fishLabel,                   ["inline"] = true},
        {["name"] = "Berat",  ["value"] = data.weight,                 ["inline"] = true},
    }, imageUrl, avatarUrl)
end

local function WatchBackpack(player, bp)
    bp.ChildAdded:Connect(function(item)
        task.wait(0.1)
        local baseName, _ = FindSecretFish(item.Name)
        if baseName and not FishImageURL[baseName] and not FishImageCache[baseName] then
            local imgId = GetFishImageId(item)
            if imgId then FishImageCache[baseName] = imgId end
        end
    end)
end

local function WatchForFish(player)
    local bp = player:FindFirstChild("Backpack")
    if bp then WatchBackpack(player, bp) end
    player.CharacterAdded:Connect(function()
        local newBp = player:WaitForChild("Backpack", 15)
        if newBp then WatchBackpack(player, newBp) end
    end)
end

local function HookChat()
    if TextChatService then
        TextChatService.MessageReceived:Connect(function(msg)
            if msg.TextSource == nil then CheckAndSend(msg.Text or "") end
        end)
    end
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local onMessage = chatEvents:FindFirstChild("OnMessageDoneFiltering")
        if onMessage then
            onMessage.OnClientEvent:Connect(function(d)
                if d and d.Message then CheckAndSend(d.Message) end
            end)
        end
    end
end

local function StartMonitoring()
    local allPlayers = Players:GetPlayers()
    local names = {}
    for _, p in ipairs(allPlayers) do table.insert(names, p.Name) end

    -- Startup notif ke webhook player
    SendPlayerWebhook("🚀 WEBHOOK STARTED", nil, 65280, {
        {["name"] = "Host",          ["value"] = "👤 " .. Players.LocalPlayer.Name,            ["inline"] = true},
        {["name"] = "Total Player",  ["value"] = "👥 " .. tostring(#allPlayers),                ["inline"] = true},
        {["name"] = "Daftar Player", ["value"] = "```\n" .. table.concat(names, ", ") .. "```", ["inline"] = false}
    })

    HookChat()

    for _, p in ipairs(Players:GetPlayers()) do
        WatchForFish(p)
        AvatarCache[p.UserId] = PROXY .. "/avatar/" .. tostring(p.UserId) .. "?t=" .. tostring(os.time())
    end

    Players.PlayerAdded:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        task.spawn(function()
            task.wait(1)
            local avatarUrl = PROXY .. "/avatar/" .. tostring(player.UserId) .. "?t=" .. tostring(os.time())
            AvatarCache[player.UserId] = avatarUrl
            SendPlayerWebhook("✅ PLAYER JOINED SERVER", nil, 65280, {
                {["name"] = "Username", ["value"] = "**" .. player.Name .. "**",              ["inline"] = true},
                {["name"] = "Total",    ["value"] = "👥 " .. tostring(#Players:GetPlayers()), ["inline"] = true}
            }, nil, avatarUrl)
        end)
        WatchForFish(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        task.spawn(function()
            local pName = player.Name
            local pId = player.UserId
            local avatarUrl = AvatarCache[pId] or (PROXY .. "/avatar/" .. tostring(pId) .. "?t=" .. tostring(os.time()))
            AvatarCache[pId] = nil
            SendPlayerWebhook("👋 PLAYER LEFT SERVER", nil, 16729344, {
                {["name"] = "Username", ["value"] = "**" .. pName .. "**",                        ["inline"] = true},
                {["name"] = "Total",    ["value"] = "👥 " .. tostring(#Players:GetPlayers() - 1), ["inline"] = true}
            }, nil, avatarUrl)
        end)
    end)
end

-- // UI //
local function CreateUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "RadarNelayanUI"
    gui.ResetOnSpawn = false
    gui.Parent = (gethui and gethui()) or CoreGui

    -- // MAIN FRAME — tinggi diperbesar untuk 2 input //
    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.new(0, 310, 0, 230)
    frame.Position = UDim2.new(0.5, -155, 0.5, -115)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    -- Top bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 36)
    topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topBar.BorderSizePixel = 0
    topBar.Parent = frame
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

    local topBarFix = Instance.new("Frame")
    topBarFix.Size = UDim2.new(1, 0, 0, 8)
    topBarFix.Position = UDim2.new(0, 0, 1, -8)
    topBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topBarFix.BorderSizePixel = 0
    topBarFix.Parent = topBar

    local title = Instance.new("TextLabel")
    title.Text = "🎣 Radar Nelayan Monitor"
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    local minBtn = Instance.new("TextButton")
    minBtn.Text = "—"
    minBtn.Size = UDim2.new(0, 28, 0, 22)
    minBtn.Position = UDim2.new(1, -58, 0.5, -11)
    minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    minBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 12
    minBtn.BorderSizePixel = 0
    minBtn.Parent = topBar
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Size = UDim2.new(0, 28, 0, 22)
    closeBtn.Position = UDim2.new(1, -28, 0.5, -11)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = topBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

    local isMinimized = false
    local fullSize = UDim2.new(0, 310, 0, 230)
    local miniSize = UDim2.new(0, 310, 0, 36)

    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(frame, TweenInfo.new(0.2), {Size = miniSize}):Play()
            minBtn.Text = "□"
        else
            TweenService:Create(frame, TweenInfo.new(0.2), {Size = fullSize}):Play()
            minBtn.Text = "—"
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.15), {
            Size = UDim2.new(0, 310, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.2)
        gui:Destroy()
    end)

    minBtn.MouseEnter:Connect(function()
        TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
    end)
    minBtn.MouseLeave:Connect(function()
        TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(230, 70, 70)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
    end)

    -- Draggable
    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Status dot + label
    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 8, 0, 8)
    statusDot.Position = UDim2.new(0, 16, 0, 50)
    statusDot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    statusDot.BorderSizePixel = 0
    statusDot.Parent = frame
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = "Tidak Aktif"
    statusLabel.Size = UDim2.new(1, -40, 0, 18)
    statusLabel.Position = UDim2.new(0, 30, 0, 42)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = frame

    -- // INPUT 1 — Webhook Ikan Secret //
    local label1 = Instance.new("TextLabel")
    label1.Text = "🐟  Webhook Ikan Secret"
    label1.Size = UDim2.new(1, -24, 0, 16)
    label1.Position = UDim2.new(0, 12, 0, 64)
    label1.BackgroundTransparency = 1
    label1.TextColor3 = Color3.fromRGB(100, 200, 255)
    label1.Font = Enum.Font.GothamBold
    label1.TextSize = 10
    label1.TextXAlignment = Enum.TextXAlignment.Left
    label1.Parent = frame

    local inputFish = Instance.new("TextBox")
    inputFish.PlaceholderText = "Paste webhook ikan secret..."
    inputFish.Size = UDim2.new(1, -24, 0, 30)
    inputFish.Position = UDim2.new(0, 12, 0, 82)
    inputFish.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    inputFish.TextColor3 = Color3.fromRGB(220, 220, 220)
    inputFish.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    inputFish.Font = Enum.Font.Gotham
    inputFish.TextSize = 10
    inputFish.ClearTextOnFocus = false
    inputFish.BorderSizePixel = 0
    inputFish.Text = ""
    inputFish.TextXAlignment = Enum.TextXAlignment.Left
    inputFish.ClipsDescendants = true
    inputFish.Parent = frame
    Instance.new("UICorner", inputFish).CornerRadius = UDim.new(0, 6)
    local p1 = Instance.new("UIPadding", inputFish)
    p1.PaddingLeft = UDim.new(0, 8)
    p1.PaddingRight = UDim.new(0, 8)

    -- // INPUT 2 — Webhook Player Join/Leave //
    local label2 = Instance.new("TextLabel")
    label2.Text = "👥  Webhook Player Join/Leave"
    label2.Size = UDim2.new(1, -24, 0, 16)
    label2.Position = UDim2.new(0, 12, 0, 118)
    label2.BackgroundTransparency = 1
    label2.TextColor3 = Color3.fromRGB(255, 200, 80)
    label2.Font = Enum.Font.GothamBold
    label2.TextSize = 10
    label2.TextXAlignment = Enum.TextXAlignment.Left
    label2.Parent = frame

    local inputPlayer = Instance.new("TextBox")
    inputPlayer.PlaceholderText = "Paste webhook player join/leave..."
    inputPlayer.Size = UDim2.new(1, -24, 0, 30)
    inputPlayer.Position = UDim2.new(0, 12, 0, 136)
    inputPlayer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    inputPlayer.TextColor3 = Color3.fromRGB(220, 220, 220)
    inputPlayer.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    inputPlayer.Font = Enum.Font.Gotham
    inputPlayer.TextSize = 10
    inputPlayer.ClearTextOnFocus = false
    inputPlayer.BorderSizePixel = 0
    inputPlayer.Text = ""
    inputPlayer.TextXAlignment = Enum.TextXAlignment.Left
    inputPlayer.ClipsDescendants = true
    inputPlayer.Parent = frame
    Instance.new("UICorner", inputPlayer).CornerRadius = UDim.new(0, 6)
    local p2 = Instance.new("UIPadding", inputPlayer)
    p2.PaddingLeft = UDim.new(0, 8)
    p2.PaddingRight = UDim.new(0, 8)

    -- // START BUTTON //
    local startBtn = Instance.new("TextButton")
    startBtn.Text = "START MONITORING"
    startBtn.Size = UDim2.new(1, -24, 0, 30)
    startBtn.Position = UDim2.new(0, 12, 0, 174)
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 12
    startBtn.BorderSizePixel = 0
    startBtn.Parent = frame
    Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1
    stroke.Parent = frame

    startBtn.MouseButton1Click:Connect(function()
        if SCRIPT_ACTIVE then return end

        local fishUrl = inputFish.Text
        local playerUrl = inputPlayer.Text

        -- Minimal salah satu webhook harus valid
        local fishValid = fishUrl:find("discord.com/api/webhooks")
        local playerValid = playerUrl:find("discord.com/api/webhooks")

        if not fishValid and not playerValid then
            startBtn.Text = "❌ WEBHOOK INVALID!"
            startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            task.wait(2)
            startBtn.Text = "START MONITORING"
            startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
            return
        end

        if fishValid then WEBHOOK_FISH = fishUrl end
        if playerValid then WEBHOOK_PLAYER = playerUrl end
        SCRIPT_ACTIVE = true

        statusDot.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
        statusLabel.Text = "Aktif — Monitoring..."
        statusLabel.TextColor3 = Color3.fromRGB(0, 220, 100)
        startBtn.Text = "✅ MONITORING AKTIF"
        startBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        inputFish.TextEditable = false
        inputPlayer.TextEditable = false

        StartMonitoring()
    end)

    startBtn.MouseEnter:Connect(function()
        if not SCRIPT_ACTIVE then
            TweenService:Create(startBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 210, 120)}):Play()
        end
    end)
    startBtn.MouseLeave:Connect(function()
        if not SCRIPT_ACTIVE then
            TweenService:Create(startBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 180, 100)}):Play()
        end
    end)
end

-- // INITIALIZE //
CreateUI()
