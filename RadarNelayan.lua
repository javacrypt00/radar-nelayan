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
local WEBHOOK_URL = ""
local WEBHOOK_STATS = ""
local WEBHOOK_FISH = ""
local DISCORD_ROLE_ID = "1489557585764810802"
local WEBHOOK_AVATAR = ""
local PROXY = "https://square-haze-a007.remediashop.workers.dev"
local SCRIPT_ACTIVE = false

-- // MEMBER LIST //
-- Format: { username = "RobloxUsername", display = "DisplayName", id = "DiscordID" }
-- Bisa pakai Username ATAU DisplayName, keduanya akan dikenali
local MemberList = {
    -- { username = "x_ibo21", display = "Ibo", id = "123456789012345678" },
    -- { username = "PandaBertaring", display = "Panda", id = "987654321098765432" },
}

-- // CACHE DISCORD MENTION (username/displayname -> discordId) //
local MentionCache = {}

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
    "Mutant Runic Koi", "Ketupat Whale", "Cosmic Mutant Shark", "Strawberry Orca",
    "Bonemaw Tyrant",
    -- Forgotten Tier
    "Sea Eater", "Thunderzilla", "Iridesca",
}

-- // DATABASE FORGOTTEN TIER //
local ForgottenList = {
    "Sea Eater", "Thunderzilla", "Iridesca",
}

-- // DATABASE CHANCE IKAN SECRET //
local FishChanceData = {
    ["Crystal Crab"] = "1 in 750K",
    ["Orca"] = "1 in 1.5M",
    ["Zombie Shark"] = "1 in 250K",
    ["Zombie Megalodon"] = "1 in 4M",
    ["Dead Zombie Shark"] = "1 in 500K",
    ["Blob Shark"] = "1 in 250K",
    ["Ghost Shark"] = "1 in 500K",
    ["Skeleton Narwhal"] = "1 in 600K",
    ["Ghost Worm Fish"] = "1 in 1M",
    ["Worm Fish"] = "1 in 3M",
    ["Megalodon"] = "1 in 4M",
    ["1x1x1x1 Comet Shark"] = "1 in 4M",
    ["Bloodmoon Whale"] = "1 in 5M",
    ["Lochness Monster"] = "1 in 3M",
    ["Monster Shark"] = "1 in 2.5M",
    ["Eerie Shark"] = "1 in 250K",
    ["Great Whale"] = "1 in 900K",
    ["Frostborn Shark"] = "1 in 500K",
    ["Thin Armored Shark"] = "1 in 300K",
    ["Scare"] = "1 in 3M",
    ["Queen Crab"] = "1 in 800K",
    ["King Crab"] = "1 in 1.2M",
    ["Cryoshade Glider"] = "1 in 450K",
    ["Panther Eel"] = "1 in 750K",
    ["Giant Squid"] = "1 in 800K",
    ["Depthseeker Ray"] = "1 in 1.2M",
    ["Robot Kraken"] = "1 in 3.5M",
    ["Mosasaur Shark"] = "1 in 800K",
    ["King Jelly"] = "1 in 1.5M",
    ["Bone Whale"] = "1 in 2M",
    ["Elshark Gran Maja"] = "1 in 4M",
    ["Elpirate Gran Maja"] = "1 in 4M",
    ["ElRetro Gran Maja"] = "1 in 4M",
    ["Ancient Whale"] = "1 in 2.75M",
    ["Gladiator Shark"] = "1 in 1M",
    ["Ancient Lochness Monster"] = "1 in 3M",
    ["Talon Serpent"] = "1 in 3M",
    ["Hacker Shark"] = "1 in 2M",
    ["Strawberry Choc Megalodon"] = "1 in 4M",
    ["Krampus Shark"] = "1 in 1M",
    ["Emerald Winter Whale"] = "1 in 1.5M",
    ["Winter Frost Shark"] = "1 in 3M",
    ["Icebreaker Whale"] = "1 in 4M",
    ["Cursed Kraken"] = "1 in 3M",
    ["Pirate Megalodon"] = "1 in 4M",
    ["Leviathan"] = "1 in 5M",
    ["Viridis Lurker"] = "1 in 1.4M",
    ["Ancient Magma Whale"] = "1 in 5M",
    ["Mutant Runic Koi"] = "1 in ??",
    ["Cosmic Mutant Shark"] = "1 in 2M",
    ["Strawberry Orca"] = "1 in 3M",
    ["Bonemaw Tyrant"] = "1 in 2.5M",
    ["Sea Eater"] = "1 in 25M",
    ["Thunderzilla"] = "1 in 30M",
    ["Iridesca"] = "1 in 25M",
    ["Eggy Enchant Stone"] = "1 in 100K",
}

-- // DATABASE MYTHIC TIER //
local MythicList = {
    "Eggy Enchant Stone"
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
    ["Bloodmoon Whale"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Bloodmoon%20Whale.png",
    ["Blob Shark"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Blob%20Shark.png",
    ["Bonemaw Tyrant"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Bonemaw%20Tyrant.png",
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
    ["Strawberry Orca"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Strawberry%20Orca.png",
    ["Eggy Enchant Stone"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Eggy%20Enchant%20Stone.png",
    ["Worm Fish"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Worm%20Fish.png",
    ["Iridesca"] = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Iridesca.png",
}

-- // CACHE TAMBAHAN DARI BACKPACK MONITOR //
local FishImageCache = {}

-- // CACHE AVATAR PLAYER (simpan sebelum player leave) //
local AvatarCache = {}

-- // TIMER PLAYER TIDAK BALIK (10 menit) //
local LeaveTimers = {}

-- // PLAYER STATS TRACKER //
local PlayerStats = {}
local PlayerNameToId = {}

-- // STATS WEBHOOK SENDER //
local function SendStatsWebhook(title, description, color, fields, imageUrl, thumbUrl)
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not requestFunc then return end
    local embed = {
        ["title"] = title, ["description"] = description, ["color"] = color, ["fields"] = fields,
        ["footer"] = {["text"] = "Radar Nelayan Stats | " .. os.date("%X")},
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    if imageUrl then embed["image"] = {["url"] = imageUrl} end
    if thumbUrl then embed["thumbnail"] = {["url"] = thumbUrl} end
    task.spawn(function()
        pcall(function()
            requestFunc({Url = WEBHOOK_STATS, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode({["embeds"] = {embed}})})
        end)
    end)
end

-- // FISH WEBHOOK SENDER //
local function SendFishWebhook(title, description, color, fields, imageUrl, thumbUrl, mention)
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not requestFunc then return end
    local url = (WEBHOOK_FISH ~= "") and WEBHOOK_FISH or WEBHOOK_URL
    if url == "" then return end
    local finalFields = {}
    for _, f in ipairs(fields) do table.insert(finalFields, f) end
    if mention and mention ~= "" then
        table.insert(finalFields, {["name"] = "📣 Mention", ["value"] = mention:match("^%s*(.-)%s*$"), ["inline"] = true})
    end
    local embed = {
        ["title"] = title, ["description"] = description, ["color"] = color, ["fields"] = finalFields,
        ["footer"] = {["text"] = "Radar Nelayan Webhook | " .. os.date("%X")},
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    if imageUrl then embed["image"] = {["url"] = imageUrl} end
    if thumbUrl then embed["thumbnail"] = {["url"] = thumbUrl} end
    task.spawn(function()
        pcall(function()
            requestFunc({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode({["embeds"] = {embed}})})
        end)
    end)
end

-- // WEBHOOK SENDER //
local function SendWebhook(title, description, color, fields, imageUrl, thumbUrl, mention)
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not requestFunc then return end
    local finalFields = {}
    for _, f in ipairs(fields) do table.insert(finalFields, f) end
    if mention and mention ~= "" then
        table.insert(finalFields, {["name"] = "📣 Mention", ["value"] = mention:match("^%s*(.-)%s*$"), ["inline"] = true})
    end
    local embed = {
        ["title"] = title, ["description"] = description, ["color"] = color, ["fields"] = finalFields,
        ["footer"] = {["text"] = "Radar Nelayan Webhook | " .. os.date("%X")},
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    if imageUrl then embed["image"] = {["url"] = imageUrl} end
    if thumbUrl then embed["thumbnail"] = {["url"] = thumbUrl} end
    task.spawn(function()
        pcall(function()
            requestFunc({
                Url = WEBHOOK_URL, Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({["username"] = "Radar Nelayan", ["avatar_url"] = WEBHOOK_AVATAR, ["embeds"] = {embed}})
            })
        end)
    end)
end

-- // AMBIL DISCORD MENTION //
local function GetMention(robloxName)
    if not robloxName then return "" end
    local lower = string.lower(robloxName)
    -- Cek MentionCache dulu
    if MentionCache[lower] then
        return "<@" .. MentionCache[lower] .. "> "
    end
    -- Fallback: cek MemberList langsung (username dan display)
    for _, member in ipairs(MemberList) do
        if string.lower(member.username) == lower or string.lower(member.display) == lower then
            return "<@" .. member.id .. "> "
        end
    end
    return ""
end

-- // BUILD MENTION CACHE //
local function BuildMentionCache(rbxName, rbxDisplay)
    for _, member in ipairs(MemberList) do
        if string.lower(member.username) == string.lower(rbxName) or
           string.lower(member.display) == string.lower(rbxDisplay) or
           string.lower(member.username) == string.lower(rbxDisplay) or
           string.lower(member.display) == string.lower(rbxName) then
            MentionCache[string.lower(rbxName)] = member.id
            MentionCache[string.lower(rbxDisplay)] = member.id
        end
    end
end

-- // FIND PLAYER (toleran nama) //
local function FindPlayer(name)
    local p = Players:FindFirstChild(name)
    if p then return p end
    local lower = string.lower(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == lower then return player end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if string.find(string.lower(player.Name), lower, 1, true) then return player end
        if string.find(lower, string.lower(player.Name), 1, true) then return player end
    end
    return nil
end

-- // STRIP HTML TAGS //
local function StripTags(str)
    return string.gsub(str, "<[^>]+>", "")
end

-- // CEK SECRET FISH + SUPPORT MUTASI //
local function FindSecretFish(fishName)
    local lower = string.lower(fishName)
    -- PASS 1: Exact match
    for _, baseName in ipairs(SecretFishList) do
        if lower == string.lower(baseName) then return baseName, nil end
    end
    -- PASS 2: Longest match
    local bestBase, bestLen, bestMutasi = nil, 0, nil
    for _, baseName in ipairs(SecretFishList) do
        local s = string.find(lower, string.lower(baseName), 1, true)
        if s then
            local mutasi = nil
            if s > 1 then
                mutasi = fishName:sub(1, s - 1):match("^%s*(.-)%s*$")
                if mutasi == "" then mutasi = nil end
            end
            if #baseName > bestLen then
                bestLen = #baseName; bestBase = baseName; bestMutasi = mutasi
            end
        end
    end
    return bestBase, bestMutasi
end

-- // CEK MYTHIC TIER //
local function FindMythic(fishName)
    local lower = string.lower(fishName)
    for _, name in ipairs(MythicList) do
        if string.find(lower, string.lower(name), 1, true) then return name end
    end
    return nil
end

-- // CEK RUBY GEMSTONE //
local function FindRuby(fishName)
    local lower = string.lower(fishName)
    if not string.find(lower, "ruby") then return nil end
    if not string.find(lower, "gemstone") then return nil end
    return "Ruby"
end

-- // CEK LEGENDARY CRYSTALIZED //
local function FindLegendaryCrystal(fishName)
    local lower = string.lower(fishName)
    if not string.find(lower, "crystalized") then return nil end
    for _, name in ipairs(LegendaryCrystalList) do
        if string.find(lower, string.lower(name), 1, true) then return name end
    end
    return nil
end

-- // AMBIL IMAGE DARI TOOL //
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

-- // PARSE CHAT SERVER //
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
    local chanceStr = rawMsg:match("with a 1 in%s+([%d%.%a]+)%s+chance")
    fishFull = fishFull:match("^(.-)%s+with a 1 in") or fishFull
    fishFull = fishFull:match("^(.-)%s*[!%.]?$") or fishFull
    fishFull = fishFull:match("^%s*(.-)%s*$") or fishFull
    return { player = playerName, fish = fishFull, weight = weight, chance = chanceStr or "N/A" }
end

-- // PROSES PESAN CHAT SERVER //
local function CheckAndSend(rawMsg)
    if not SCRIPT_ACTIVE then return end
    if not string.find(string.lower(rawMsg), "obtained") then return end
    local data = ParseChat(rawMsg)
    if not data then return end

    local targetPlayer = FindPlayer(data.player)
    local avatarUrl = targetPlayer and (PROXY .. "/avatar/" .. tostring(targetPlayer.UserId) .. "?t=" .. tostring(os.time())) or nil
    local uid = targetPlayer and targetPlayer.UserId or PlayerNameToId[string.lower(data.player)]
    if uid then
        if not PlayerStats[uid] then
            PlayerStats[uid] = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = data.player }
        end
        PlayerStats[uid].catchCount = PlayerStats[uid].catchCount + 1
        PlayerStats[uid].lastFishTime = os.time()
    end

    local legendaryBase = FindLegendaryCrystal(data.fish)
    if legendaryBase then
        local imageUrl = FishImageURL[legendaryBase] or (FishImageCache[legendaryBase] and (PROXY .. "/asset/" .. FishImageCache[legendaryBase])) or nil
        SendFishWebhook("💎 CRYSTALIZED LEGENDARY!", nil, 3407871, {
            {["name"] = "Pemain", ["value"] = "**" .. data.player .. "**", ["inline"] = true},
            {["name"] = "Ikan",   ["value"] = "**" .. data.fish .. "**",   ["inline"] = true},
            {["name"] = "Mutasi", ["value"] = "✨ Crystalized",            ["inline"] = true},
            {["name"] = "Berat",  ["value"] = data.weight,                 ["inline"] = true},
        }, imageUrl, avatarUrl, GetMention(data.player))
        return
    end

    local mythicBase = FindMythic(data.fish)
    if mythicBase then
        local imageUrl = FishImageURL[mythicBase] or nil
        SendFishWebhook("🔥 MYTHIC TIER DETECTED!", nil, 16711935, {
            {["name"] = "Pemain", ["value"] = "**" .. data.player .. "**", ["inline"] = true},
            {["name"] = "Item",   ["value"] = "**" .. data.fish .. "**",   ["inline"] = true},
            {["name"] = "Berat",  ["value"] = data.weight,                 ["inline"] = true},
        }, imageUrl, avatarUrl, GetMention(data.player))
        return
    end

    local rubyBase = FindRuby(data.fish)
    if rubyBase then
        local imageUrl = FishImageURL[rubyBase] or (FishImageCache[rubyBase] and (PROXY .. "/asset/" .. FishImageCache[rubyBase])) or nil
        SendFishWebhook("💎 RUBY GEMSTONE!", nil, 16753920, {
            {["name"] = "Pemain", ["value"] = "**" .. data.player .. "**", ["inline"] = true},
            {["name"] = "Item",   ["value"] = "**" .. data.fish .. "**",   ["inline"] = true},
            {["name"] = "Berat",  ["value"] = data.weight,                 ["inline"] = true},
        }, imageUrl, avatarUrl, GetMention(data.player))
        return
    end

    local baseName, mutasi = FindSecretFish(data.fish)
    if not baseName then return end
    local imageUrl = FishImageURL[baseName] or (FishImageCache[baseName] and (PROXY .. "/asset/" .. FishImageCache[baseName])) or nil

    local isForgotten = false
    for _, name in ipairs(ForgottenList) do
        if string.lower(baseName) == string.lower(name) then isForgotten = true; break end
    end

    if uid and PlayerStats[uid] then
        local existing = PlayerStats[uid].secretList[baseName] or 0
        PlayerStats[uid].secretList[baseName] = existing + 1
    end

    local chanceInfo = FishChanceData[baseName] or "Unknown"
    local ikanField = "**" .. data.fish .. "**"
    local mutasiField = mutasi and ("*" .. mutasi .. "*") or "-"

    if isForgotten then
        SendFishWebhook("🌟 FORGOTTEN TIER DETECTED!", nil, 16777215, {
            {["name"] = "Pemain",  ["value"] = "**" .. data.player .. "**", ["inline"] = true},
            {["name"] = "Ikan",    ["value"] = ikanField,                   ["inline"] = true},
            {["name"] = "Mutasi",  ["value"] = mutasiField,                 ["inline"] = true},
            {["name"] = "Berat",   ["value"] = data.weight,                 ["inline"] = true},
            {["name"] = "Chance",  ["value"] = "🎲 " .. chanceInfo,         ["inline"] = true},
        }, imageUrl, avatarUrl, GetMention(data.player))
    else
        SendFishWebhook("🚨 SECRET FISH DETECTED!", nil, 1752220, {
            {["name"] = "Pemain",  ["value"] = "**" .. data.player .. "**", ["inline"] = true},
            {["name"] = "Ikan",    ["value"] = ikanField,                   ["inline"] = true},
            {["name"] = "Mutasi",  ["value"] = mutasiField,                 ["inline"] = true},
            {["name"] = "Berat",   ["value"] = data.weight,                 ["inline"] = true},
            {["name"] = "Chance",  ["value"] = "🎲 " .. chanceInfo,         ["inline"] = true},
        }, imageUrl, avatarUrl, GetMention(data.player))
    end
end

-- // BACKPACK MONITOR //
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

-- // HOOK CHAT SERVER //
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

-- // STARTUP WEBHOOK //
local function StartMonitoring()
    local allPlayers = Players:GetPlayers()
    local names = {}
    for _, p in ipairs(allPlayers) do table.insert(names, p.Name) end
    SendWebhook("🚀 WEBHOOK STARTED", nil, 65280, {
        {["name"] = "Host",          ["value"] = "👤 " .. Players.LocalPlayer.Name,            ["inline"] = true},
        {["name"] = "Total Player",  ["value"] = "👥 " .. tostring(#allPlayers),                ["inline"] = true},
        {["name"] = "Daftar Player", ["value"] = "```\n" .. table.concat(names, ", ") .. "```", ["inline"] = false}
    })
    HookChat()

    -- // KIRIM STATS TIAP 20 MENIT //
    task.spawn(function()
        while SCRIPT_ACTIVE do
            task.wait(1200)
            if not SCRIPT_ACTIVE then break end
            for _, p in ipairs(Players:GetPlayers()) do
                local uid = p.UserId
                local stats = PlayerStats[uid]
                if not stats then continue end
                local duration = os.time() - stats.joinTime
                local durationStr = math.floor(duration / 60) .. "m " .. (duration % 60) .. "s"
                local lastFishStr = "Tidak ada"
                if stats.lastFishTime then
                    local diff = os.time() - stats.lastFishTime
                    lastFishStr = math.floor(diff / 60) .. "m " .. (diff % 60) .. "s yang lalu"
                end
                local secretLines = {}
                for fishName, count in pairs(stats.secretList) do
                    table.insert(secretLines, fishName .. " (" .. count .. "x)")
                end
                local secretStr = #secretLines > 0 and table.concat(secretLines, ", ") or "Tidak ada"
                local avatarUrl = AvatarCache[uid] or (PROXY .. "/avatar/" .. tostring(uid) .. "?t=" .. tostring(os.time()))
                SendStatsWebhook("📊 PLAYER STATS (20 Menit)", nil, 9807270, {
                    {["name"] = "👤 Username",      ["value"] = "**" .. p.Name .. "**",               ["inline"] = true},
                    {["name"] = "⏱️ Durasi Sesi",   ["value"] = durationStr,                           ["inline"] = true},
                    {["name"] = "🐟 Total Catch",   ["value"] = tostring(stats.catchCount) .. " ikan", ["inline"] = true},
                    {["name"] = "🕐 Last Fish",     ["value"] = lastFishStr,                           ["inline"] = true},
                    {["name"] = "🏆 Secret Caught", ["value"] = secretStr,                             ["inline"] = false},
                }, nil, avatarUrl)
                task.wait(0.5)
            end
        end
    end)

    for _, p in ipairs(Players:GetPlayers()) do
        WatchForFish(p)
        AvatarCache[p.UserId] = PROXY .. "/avatar/" .. tostring(p.UserId) .. "?t=" .. tostring(os.time())
        PlayerStats[p.UserId] = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = p.Name }
        PlayerNameToId[string.lower(p.Name)] = p.UserId
        PlayerNameToId[string.lower(p.DisplayName)] = p.UserId
        BuildMentionCache(p.Name, p.DisplayName)
    end

    Players.PlayerAdded:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        if LeaveTimers[player.UserId] then LeaveTimers[player.UserId] = nil end
        PlayerStats[player.UserId] = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = player.Name }
        PlayerNameToId[string.lower(player.Name)] = player.UserId
        PlayerNameToId[string.lower(player.DisplayName)] = player.UserId
        BuildMentionCache(player.Name, player.DisplayName)
        task.spawn(function()
            task.wait(1)
            local avatarUrl = PROXY .. "/avatar/" .. tostring(player.UserId) .. "?t=" .. tostring(os.time())
            AvatarCache[player.UserId] = avatarUrl
            SendWebhook("✅ PLAYER JOINED SERVER", nil, 65280, {
                {["name"] = "Username", ["value"] = "**" .. player.Name .. "**",              ["inline"] = true},
                {["name"] = "Total",    ["value"] = "👥 " .. tostring(#Players:GetPlayers()), ["inline"] = true}
            }, nil, avatarUrl, GetMention(player.Name))
        end)
        WatchForFish(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        local pName = player.Name
        local pId = player.UserId
        local avatarUrl = AvatarCache[pId] or (PROXY .. "/avatar/" .. tostring(pId) .. "?t=" .. tostring(os.time()))
        local stats = PlayerStats[pId] or { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil }
        local totalNow = #Players:GetPlayers() - 1
        AvatarCache[pId] = nil
        PlayerStats[pId] = nil
        PlayerNameToId[string.lower(pName)] = nil
        for k, v in pairs(PlayerNameToId) do if v == pId then PlayerNameToId[k] = nil end end
        for k, v in pairs(MentionCache) do if v == MentionCache[string.lower(pName)] and k ~= string.lower(pName) then MentionCache[k] = nil end end
        MentionCache[string.lower(pName)] = nil

        local duration = os.time() - stats.joinTime
        local durationStr = math.floor(duration / 60) .. "m " .. (duration % 60) .. "s"
        local lastFishStr = "Tidak ada"
        if stats.lastFishTime then
            local diff = os.time() - stats.lastFishTime
            lastFishStr = math.floor(diff / 60) .. "m " .. (diff % 60) .. "s yang lalu"
        end
        local secretLines = {}
        for fishName, count in pairs(stats.secretList) do
            table.insert(secretLines, fishName .. " (" .. count .. "x)")
        end
        local secretStr = #secretLines > 0 and table.concat(secretLines, ", ") or "Tidak ada"

        SendWebhook("👋 PLAYER LEFT SERVER", nil, 16729344, {
            {["name"] = "Username", ["value"] = "**" .. pName .. "**",        ["inline"] = true},
            {["name"] = "Total",    ["value"] = "👥 " .. tostring(totalNow),  ["inline"] = true}
        }, nil, avatarUrl, GetMention(pName))

        task.spawn(function()
            task.wait(0.3)
            SendStatsWebhook("📊 PLAYER STATS", nil, 9807270, {
                {["name"] = "👤 Username",      ["value"] = "**" .. pName .. "**",                 ["inline"] = true},
                {["name"] = "⏱️ Durasi Sesi",   ["value"] = durationStr,                           ["inline"] = true},
                {["name"] = "🐟 Total Catch",   ["value"] = tostring(stats.catchCount) .. " ikan", ["inline"] = true},
                {["name"] = "🕐 Last Fish",     ["value"] = lastFishStr,                           ["inline"] = true},
                {["name"] = "🏆 Secret Caught", ["value"] = secretStr,                             ["inline"] = false},
            }, nil, avatarUrl)
        end)

        LeaveTimers[pId] = true
        task.spawn(function()
            task.wait(600)
            if LeaveTimers[pId] then
                LeaveTimers[pId] = nil
                SendWebhook("⏰ PLAYER TIDAK KEMBALI", nil, 16711680, {
                    {["name"] = "Username", ["value"] = "**" .. pName .. "**",               ["inline"] = true},
                    {["name"] = "Info",     ["value"] = "Tidak kembali selama **10 menit**", ["inline"] = true}
                }, nil, nil)
            end
        end)
    end)
end

-- // UI //
local function CreateUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "RadarNelayanUI"
    gui.ResetOnSpawn = false
    gui.Parent = (gethui and gethui()) or CoreGui

    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.new(0, 300, 0, 320)
    frame.Position = UDim2.new(0.5, -150, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

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
    local fullSize = UDim2.new(0, 300, 0, 320)
    local miniSize = UDim2.new(0, 300, 0, 36)
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
        TweenService:Create(frame, TweenInfo.new(0.15), {Size = UDim2.new(0, 300, 0, 0), BackgroundTransparency = 1}):Play()
        task.wait(0.2); gui:Destroy()
    end)
    minBtn.MouseEnter:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play() end)
    minBtn.MouseLeave:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play() end)
    closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(230, 70, 70)}):Play() end)
    closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play() end)

    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 8, 0, 8)
    statusDot.Position = UDim2.new(0, 16, 0, 46)
    statusDot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    statusDot.BorderSizePixel = 0
    statusDot.Parent = frame
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = "Tidak Aktif"
    statusLabel.Size = UDim2.new(1, -40, 0, 20)
    statusLabel.Position = UDim2.new(0, 30, 0, 38)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = frame

    local function makeInput(placeholder, yPos)
        local box = Instance.new("TextBox")
        box.PlaceholderText = placeholder
        box.Size = UDim2.new(1, -24, 0, 30)
        box.Position = UDim2.new(0, 12, 0, yPos)
        box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        box.TextColor3 = Color3.fromRGB(220, 220, 220)
        box.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        box.Font = Enum.Font.Gotham
        box.TextSize = 10
        box.ClearTextOnFocus = false
        box.BorderSizePixel = 0
        box.Text = ""
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.ClipsDescendants = true
        box.Parent = frame
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        local pad = Instance.new("UIPadding", box)
        pad.PaddingLeft = UDim.new(0, 8)
        pad.PaddingRight = UDim.new(0, 8)
        return box
    end

    local function makeLabel(text, yPos)
        local lbl = Instance.new("TextLabel")
        lbl.Text = text
        lbl.Size = UDim2.new(1, -24, 0, 14)
        lbl.Position = UDim2.new(0, 12, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(130, 130, 130)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame
        return lbl
    end

    makeLabel("👋 Webhook Join / Leave", 58)
    local inputJoin = makeInput("Paste webhook join/leave...", 72)
    makeLabel("🚨 Webhook Secret Fish", 110)
    local inputFish = makeInput("Paste webhook secret fish...", 124)
    makeLabel("📊 Webhook Stats", 162)
    local inputStats = makeInput("Paste webhook stats...", 176)
    makeLabel("🔔 Discord Role ID (opsional)", 214)
    local inputRole = makeInput("Masukkan Role ID...", 228)

    local startBtn = Instance.new("TextButton")
    startBtn.Text = "START MONITORING"
    startBtn.Size = UDim2.new(1, -24, 0, 34)
    startBtn.Position = UDim2.new(0, 12, 0, 266)
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
        local joinText = inputJoin.Text
        local fishText = inputFish.Text
        local statsText = inputStats.Text
        if not joinText:find("discord.com/api/webhooks") then
            startBtn.Text = "❌ WEBHOOK JOIN INVALID!"
            startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            task.wait(2)
            startBtn.Text = "START MONITORING"
            startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
            return
        end
        WEBHOOK_URL = joinText
        if fishText:find("discord.com/api/webhooks") then WEBHOOK_FISH = fishText end
        if statsText:find("discord.com/api/webhooks") then WEBHOOK_STATS = statsText end
        local roleText = inputRole.Text:match("^%s*(.-)%s*$")
        if roleText ~= "" then DISCORD_ROLE_ID = roleText end
        SCRIPT_ACTIVE = true
        statusDot.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
        statusLabel.Text = "Aktif — Monitoring..."
        statusLabel.TextColor3 = Color3.fromRGB(0, 220, 100)
        startBtn.Text = "✅ MONITORING AKTIF"
        startBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        inputJoin.TextEditable = false
        inputFish.TextEditable = false
        inputStats.TextEditable = false
        inputRole.TextEditable = false
        StartMonitoring()
    end)

    startBtn.MouseEnter:Connect(function()
        if not SCRIPT_ACTIVE then TweenService:Create(startBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 210, 120)}):Play() end
    end)
    startBtn.MouseLeave:Connect(function()
        if not SCRIPT_ACTIVE then TweenService:Create(startBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 180, 100)}):Play() end
    end)
end

-- // INITIALIZE //
CreateUI()
