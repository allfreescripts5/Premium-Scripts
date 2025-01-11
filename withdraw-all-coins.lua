local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local closestIsland
local closestDistance = math.huge
for _, island in pairs(workspace.Islands:GetChildren()) do
    if island:FindFirstChild("Blocks") and island.PrimaryPart then
        local distance = (root.Position - island.PrimaryPart.Position).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestIsland = island
        end
    end
end
local blocks = closestIsland.Blocks
for _, block in ipairs(blocks:GetChildren()) do
    if block.Name == "vendingMachine" then
        local coinBalance = block:FindFirstChild("CoinBalance")
        if coinBalance and coinBalance:IsA("IntValue") then
            local totalCoins = coinBalance.Value
            if totalCoins > 0 then
                local netService = game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged
                local openVendingString = "vgvigLycuBykEisGk/JjddhzhzqeZivADimaohvbSzef"
                local editVendingString = "vgvigLycuBykEisGk/cbpaapiybvLGnerxxycxc"
                local takeCoinsString = "vgvigLycuBykEisGk/thdheckjectsj"
                local closeVendingString = "vgvigLycuBykEisGk/rgcydxOfeiiwrhdqfdvvEiviibRulezdEq"
                local vendingData = { [1] = { ["vendingMachine"] = block } }
                netService[openVendingString]:FireServer(openVendingString, vendingData)
                netService[editVendingString]:FireServer(editVendingString, vendingData)
                netService[takeCoinsString]:FireServer(takeCoinsString, { 
                    [1] = { 
                        ["vendingMachine"] = block, 
                        ["amount"] = totalCoins 
                    } 
                })
                local ohTable1 = { ["vendingMachine"] = block }
                netService[closeVendingString]:FireServer(ohTable1)
                task.wait(0.01)
            end
        end
    end
end
