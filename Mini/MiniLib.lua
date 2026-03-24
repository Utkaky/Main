local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local function Tween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function AddStroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(80, 80, 90)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
end

function Library:NewWindow(title)
    local Window = {}

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MiniLibUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if syn then
        syn.protect_gui(ScreenGui)
    end
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 280, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -140, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
    AddStroke(MainFrame)

    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(45, 45, 50)

    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)
    AddStroke(Header)

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseButton = Instance.new("TextButton", Header)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.new(1,1,1)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 20

    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 10)
    AddStroke(CloseButton)

    local Content = Instance.new("ScrollingFrame", MainFrame)
    Content.Size = UDim2.new(1, -20, 1, -50)
    Content.Position = UDim2.new(0, 10, 0, 45)
    Content.BackgroundTransparency = 1
    Content.ScrollBarThickness = 4

    local Layout = Instance.new("UIListLayout", Content)
    Layout.Padding = UDim.new(0, 8)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Content.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    -- DRAG
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        Tween(MainFrame, {
            Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        }, 0.1)
    end

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- OPEN/CLOSE
    local isOpen = false
    CloseButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            Tween(MainFrame, {Size = UDim2.new(0, 280, 0, 40)}, 0.3)
            CloseButton.Text = "+"
        else
            Tween(MainFrame, {Size = UDim2.new(0, 280, 0, Layout.AbsoluteContentSize.Y + 60)}, 0.3)
            CloseButton.Text = "×"
        end
    end)

    -- SECTION
    function Window:NewSection(name)
        local Section = {}

        local Title = Instance.new("TextLabel", Content)
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.BackgroundTransparency = 1
        Title.Text = name
        Title.TextColor3 = Color3.fromRGB(200,200,200)
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left

        function Section:CreateButton(text, callback)
            local Frame = Instance.new("Frame", Content)
            Frame.Size = UDim2.new(1,0,0,35)
            Frame.BackgroundColor3 = Color3.fromRGB(45,45,50)

            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
            AddStroke(Frame)

            local Btn = Instance.new("TextButton", Frame)
            Btn.Size = UDim2.new(1,0,1,0)
            Btn.BackgroundTransparency = 1
            Btn.Text = text
            Btn.TextColor3 = Color3.new(1,1,1)

            Btn.MouseButton1Click:Connect(function()
                Tween(Frame,{BackgroundColor3 = Color3.fromRGB(60,140,220)},0.1)
                task.wait(0.1)
                Tween(Frame,{BackgroundColor3 = Color3.fromRGB(45,45,50)},0.2)
                pcall(callback)
            end)
        end

        function Section:CreateToggle(text, default, callback)
            local state = default or false

            local Frame = Instance.new("Frame", Content)
            Frame.Size = UDim2.new(1,0,0,35)
            Frame.BackgroundColor3 = Color3.fromRGB(45,45,50)

            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
            AddStroke(Frame)

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(1,-50,1,0)
            Label.Position = UDim2.new(0,10,0,0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.new(1,1,1)

            local Toggle = Instance.new("TextButton", Frame)
            Toggle.Size = UDim2.new(0,40,0,20)
            Toggle.Position = UDim2.new(1,-45,0.5,-10)
            Toggle.BackgroundColor3 = state and Color3.fromRGB(80,170,255) or Color3.fromRGB(60,60,65)

            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1,0)
            AddStroke(Toggle)

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Tween(Toggle,{
                    BackgroundColor3 = state and Color3.fromRGB(80,170,255) or Color3.fromRGB(60,60,65)
                },0.2)
                pcall(callback,state)
            end)
        end

        function Section:CreateLabel(text)
            local Frame = Instance.new("Frame", Content)
            Frame.Size = UDim2.new(1,0,0,30)
            Frame.BackgroundColor3 = Color3.fromRGB(45,45,50)

            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
            AddStroke(Frame)

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(1,-20,1,0)
            Label.Position = UDim2.new(0,10,0,0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(200,200,200)

            return {
                Set = function(_, new)
                    Label.Text = new
                end
            }
        end

        function Section:CreateKeybind(text, key, callback)
            local current = key or Enum.KeyCode.E

            local Frame = Instance.new("Frame", Content)
            Frame.Size = UDim2.new(1,0,0,35)
            Frame.BackgroundColor3 = Color3.fromRGB(45,45,50)

            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
            AddStroke(Frame)

            local Btn = Instance.new("TextButton", Frame)
            Btn.Size = UDim2.new(0,60,0,25)
            Btn.Position = UDim2.new(1,-65,0.5,-12)
            Btn.Text = current.Name

            Btn.MouseButton1Click:Connect(function()
                Btn.Text = "..."
                local conn
                conn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        current = input.KeyCode
                        Btn.Text = current.Name
                        conn:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(input,gp)
                if not gp and input.KeyCode == current then
                    pcall(callback)
                end
            end)
        end

        return Section
    end

    return Window
end

return Library
