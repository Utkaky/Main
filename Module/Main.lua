ReplicatedStorage = game:GetService("ReplicatedStorage")
Workspace = game:GetService("Workspace")
Players = game:GetService("Players")

module = {}

-- main variables

module.Services = {
    rs = ReplicatedStorage,
    w = Workspace,
    p = Players
}
module.RemotesGrab = {
    Grab = {
        SetOwner = ReplicatedStorage.GrabEvents.SetNetworkOwner,
        EndGrab = ReplicatedStorage.GrabEvents.DestroyGrabLine,
        Extend = ReplicatedStorage.GrabEvents.ExtendGrabLine
    }
}
module.Values = {
    Loss = 67
}
module.Map = {
    Plots = Workspace:WaitForChild("Plots")
}

-- functions

function module:GetPlot(player)
    for _, plot in pairs(self.Map.Plots:GetChildren()) do
        local owner = plot:FindFirstChild("Owner")

        if owner and owner.Value == player then
            return plot
        end
    end

    return nil
end
function module:useGrab(part)
    if not part then
        return
    end

    self.RemotesGrab.Grab.SetOwner:FireServer(part)
end
function module:Teleport(pos)
    local lp = self.Services.p.LocalPlayer

    if not lp.Character then
        return
    end

    local hrp = lp.Character:FindFirstChild("HumanoidRootPart")

    if not hrp then
        return
    end

    hrp.CFrame = CFrame.new(pos)
end

return module
--[[
ex for use:
local lib = require(path.to.module)

lib:useGrab(workspace.Part)

print(lib.Values.Loss)


local plot = lib:GetPlot(game.Players.LocalPlayer)
print(plot)

lib:Teleport(CFrame.new(0, 100, 0)) or lib:Teleport(workspace.Part.CFrame)
]]
