    local slide_tp_en
	local loop_tp_en

	local last_house

	local houses = {
	[1] = CFrame.new(-491, -7, -166),
	[2] = CFrame.new(-535, -7, 93),
	[3] = CFrame.new(250, -6, 463),
	[4] = CFrame.new(554, 123, -72),
	[5] = CFrame.new(510, 83, -339),
	[6] = CFrame.new(3, -7, -2)
	}

	local function tp(pos)
	last_house = pos

	local me = game.Players.LocalPlayer
	local char = me.Character or me.CharacterAdded
	local hrp = char and char:FindFirstChild("HumanoidRootPart")

	if hrp then
		if not slide_tp_en then
			hrp.CFrame = pos
		else
			local info = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0)
			local cf = {["CFrame"] = pos}
			game:GetService("TweenService"):Create(hrp, info, cf):Play()
		end
		
		hrp.Velocity = Vector3.new(0, 0, 0)
	end
	end

	local l = loadstring(game:HttpGet("https://raw.githubusercontent.com/m1kp0/libraries/refs/heads/main/TheWorstUI.lua"))():CreateWindow({
    CanResize = "X",
    SizeX = 200,
    Name = "Sound",
    SizeY = 0,
    })

l:CreateButton({
    Name = "pink house",
    Callback = function(bool)
        tp(houses[1])
    end,
})

l:CreateButton({
    Name = "green house",
    Callback = function(bool)
        tp(houses[2])
    end,
})
l:CreateButton({
    Name = "purple house",
    Callback = function(bool)
        tp(houses[3])
    end,
})
l:CreateButton({
    Name = "china house",
    Callback = function(bool)
        tp(houses[4])
    end,
})
l:CreateButton({
    Name = "blue house",
    Callback = function(bool)
        tp(houses[5])
    end,
})
l:CreateButton({
    Name = "spawn",
    Callback = function(bool)
        tp(houses[6])
    end,
})
l:CreateToggle({
    Name = "slide tp",
    Callback = function(bool)
        slide_tp_en = bool
    end,
})
l:CreateToggle({
    Name = "loop tp",
    Callback = function(bool)
        loop_tp_en = bool
        while loop_tp_en do
            tp(last_house or houses[0])
            task.wait()
        end
    end,
})
