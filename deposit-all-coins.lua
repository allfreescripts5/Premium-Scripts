local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local closestIsland, closestDistance = nil, math.huge
for _, island in workspace.Islands:GetChildren() do
    local primary = island.PrimaryPart
    if island:FindFirstChild("Blocks") and primary then
        local dist = (root.Position - primary.Position).Magnitude
        if dist < closestDistance then
            closestDistance = dist
            closestIsland = island
        end
    end
end
if closestIsland then
    local blocks = closestIsland.Blocks
    local netService = game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged
    local openVendingString = "vgvigLycuBykEisGk/JjddhzhzqeZivADimaohvbSzef"
    local editVendingString = "vgvigLycuBykEisGk/cbpaapiybvLGnerxxycxc"
    local depositCoinsString = "vgvigLycuBykEisGk/cuvpgbjalvx"
    local closeVendingString = "vgvigLycuBykEisGk/rgcydxOfeiiwrhdqfdvvEiviibRulezdEq"
    local depositAmount = 5000000000
    local processed = {}
    for _, block in blocks:GetChildren() do
        if block.Name == "vendingMachine" and not processed[block] then
            processed[block] = true
            local vendingData = { [1] = { ["vendingMachine"] = block } }
            netService[openVendingString]:FireServer(openVendingString, vendingData)
            netService[editVendingString]:FireServer(editVendingString, vendingData)
            netService[depositCoinsString]:FireServer(depositCoinsString, { 
                [1] = { 
                    ["vendingMachine"] = block, 
                    ["amount"] = depositAmount 
                } 
            })
            local closeData = { ["vendingMachine"] = block }
            netService[closeVendingString]:FireServer(closeData)
            task.wait(0.01)
        end
    end
end
