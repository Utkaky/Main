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
module.RemotesMain = {
    Grab = {
        SetOwner = ReplicatedStorage.GrabEvents.SetNetworkOwner,
        EndGrab = ReplicatedStorage.GrabEvents.DestroyGrabLine,
        Extend = ReplicatedStorage.GrabEvents.ExtendGrabLine,

        ToysD = ReplicatedStorage.MenuToys.DestroyToy,
        ToysS = ReplicatedStorage.MenuToys.SpawnToyRemoteFunction,

        HDrop = ReplicatedStorage.Drop,
        HGrab = ReplicatedStorage.Hold,
        HUse = ReplicatedStorage.Use
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

    self.RemotesMain.Grab.SetOwner:FireServer(part)
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
