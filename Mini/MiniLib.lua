local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Cores globais (fácil de personalizar)
local COLORS = {
    Background    = Color3.fromRGB(22, 22, 28),
    Header        = Color3.fromRGB(30, 30, 38),
    Element       = Color3.fromRGB(32, 32, 40),
    ElementHover  = Color3.fromRGB(42, 42, 52),
    Accent        = Color3.fromRGB(90, 150, 255),
    AccentDark    = Color3.fromRGB(55, 100, 200),
    Stroke        = Color3.fromRGB(55, 55, 70),
    StrokeAccent  = Color3.fromRGB(90, 150, 255),
    TextPrimary   = Color3.fromRGB(240, 240, 245),
    TextSecondary = Color3.fromRGB(160, 160, 175),
    White         = Color3.fromRGB(255, 255, 255),
    Toggle_Off    = Color3.fromRGB(50, 50, 62),
}

local function Tween(instance, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Cria UIStroke configurável
local function AddStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or COLORS.Stroke
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- Cria UICorner configurável
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- Cria Padding
local function AddPadding(parent, top, bottom, left, right)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop    = UDim.new(0, top    or 0)
    pad.PaddingBottom = UDim.new(0, bottom or 0)
    pad.PaddingLeft   = UDim.new(0, left   or 0)
    pad.PaddingRight  = UDim.new(0, right  or 0)
    pad.Parent = parent
    return pad
end

-- ─────────────────────────────────────────────────────────────────
function Library:NewWindow(title)
    local Window = {}

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ReplicateSignalUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if syn then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end

    -- ── Janela principal ──────────────────────────────────────────
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    MainFrame.BackgroundColor3 = COLORS.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    AddCorner(MainFrame, 10)
    AddStroke(MainFrame, COLORS.Stroke, 1.5)

    -- ── Header ────────────────────────────────────────────────────
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 44)
    Header.BackgroundColor3 = COLORS.Header
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    AddCorner(Header, 10)

    -- Linha decorativa no fundo do header
    local HeaderLine = Instance.new("Frame")
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, -1)
    HeaderLine.BackgroundColor3 = COLORS.Stroke
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = Header

    -- Accent dot
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 8, 0, 8)
    Dot.Position = UDim2.new(0, 14, 0.5, -4)
    Dot.BackgroundColor3 = COLORS.Accent
    Dot.BorderSizePixel = 0
    Dot.Parent = Header
    AddCorner(Dot, 4)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 30, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = COLORS.TextPrimary
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -36, 0.5, -14)
    CloseButton.BackgroundColor3 = Color3.fromRGB(55, 55, 68)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = COLORS.TextPrimary
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = Header
    AddCorner(CloseButton, 7)
    AddStroke(CloseButton, COLORS.Stroke, 1)

    -- ── Área de conteúdo ──────────────────────────────────────────
    local ContentContainer = Instance.new("ScrollingFrame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -20, 1, -54)
    ContentContainer.Position = UDim2.new(0, 10, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.ScrollBarThickness = 3
    ContentContainer.ScrollBarImageColor3 = COLORS.Accent
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentContainer.Parent = MainFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 6)
    ContentLayout.Parent = ContentContainer

    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
    end)

    -- ── Dragging ──────────────────────────────────────────────────
    local dragging, dragInput, dragStart, startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        Tween(MainFrame, {
            Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        }, 0.08)
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
            updateDrag(input)
        end
    end)

    -- ── Minimizar / Restaurar ─────────────────────────────────────
    local isMinimized = false

    CloseButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Tween(MainFrame, {Size = UDim2.new(0, 300, 0, 44)}, 0.35, Enum.EasingStyle.Back)
            CloseButton.Text = "+"
        else
            Tween(MainFrame, {Size = UDim2.new(0, 300, 0, ContentLayout.AbsoluteContentSize.Y + 64)}, 0.35, Enum.EasingStyle.Back)
            CloseButton.Text = "×"
        end
    end)

    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 55, 55)}, 0.15)
    end)
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(55, 55, 68)}, 0.15)
    end)

    -- Animação de abertura
    MainFrame.Size = UDim2.new(0, 300, 0, 0)
    task.delay(0.05, function()
        Tween(MainFrame, {Size = UDim2.new(0, 300, 0, 340)}, 0.45, Enum.EasingStyle.Back)
    end)

    -- ─────────────────────────────────────────────────────────────
    -- NewSection
    -- ─────────────────────────────────────────────────────────────
    function Window:NewSection(sectionTitle)
        local Section = {}

        -- Cabeçalho da seção
        local SectionHeader = Instance.new("Frame")
        SectionHeader.Size = UDim2.new(1, 0, 0, 26)
        SectionHeader.BackgroundTransparency = 1
        SectionHeader.Parent = ContentContainer

        local SectionLine = Instance.new("Frame")
        SectionLine.Size = UDim2.new(0.3, 0, 0, 1)
        SectionLine.Position = UDim2.new(0, 0, 1, -1)
        SectionLine.BackgroundColor3 = COLORS.Accent
        SectionLine.BorderSizePixel = 0
        SectionLine.Parent = SectionHeader

        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Size = UDim2.new(1, 0, 1, 0)
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.Text = string.upper(sectionTitle)
        SectionLabel.TextColor3 = COLORS.Accent
        SectionLabel.TextSize = 11
        SectionLabel.Font = Enum.Font.GothamBold
        SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

        SectionLabel.Parent = SectionHeader

        -- ── BUTTON ───────────────────────────────────────────────
        function Section:CreateButton(buttonText, callback)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Size = UDim2.new(1, 0, 0, 36)
            ButtonFrame.BackgroundColor3 = COLORS.Element
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = ContentContainer
            AddCorner(ButtonFrame, 8)
            local btnStroke = AddStroke(ButtonFrame, COLORS.Stroke, 1)

            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = buttonText
            Button.TextColor3 = COLORS.TextPrimary
            Button.TextSize = 13
            Button.Font = Enum.Font.Gotham
            Button.Parent = ButtonFrame

            Button.MouseButton1Click:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = COLORS.Accent}, 0.1)
                Tween(btnStroke, {Color = COLORS.StrokeAccent}, 0.1)
                task.delay(0.12, function()
                    Tween(ButtonFrame, {BackgroundColor3 = COLORS.Element}, 0.25)
                    Tween(btnStroke, {Color = COLORS.Stroke}, 0.25)
                end)
                pcall(callback)
            end)

            Button.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = COLORS.ElementHover}, 0.18)
                Tween(btnStroke, {Color = COLORS.StrokeAccent}, 0.18)
            end)
            Button.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = COLORS.Element}, 0.18)
                Tween(btnStroke, {Color = COLORS.Stroke}, 0.18)
            end)
        end

        -- ── TOGGLE ───────────────────────────────────────────────
        function Section:CreateToggle(toggleText, defaultState, callback)
            local toggled = defaultState or false

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
            ToggleFrame.BackgroundColor3 = COLORS.Element
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = ContentContainer
            AddCorner(ToggleFrame, 8)
            local tglStroke = AddStroke(ToggleFrame, COLORS.Stroke, 1)

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -55, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleText
            ToggleLabel.TextColor3 = COLORS.TextPrimary
            ToggleLabel.TextSize = 13
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame

            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(0, 40, 0, 20)
            Track.Position = UDim2.new(1, -46, 0.5, -10)
            Track.BackgroundColor3 = toggled and COLORS.Accent or COLORS.Toggle_Off
            Track.Text = ""
            Track.BorderSizePixel = 0
            Track.Parent = ToggleFrame
            AddCorner(Track, 10)
            AddStroke(Track, COLORS.Stroke, 1)

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            Circle.BackgroundColor3 = COLORS.White
            Circle.BorderSizePixel = 0
            Circle.Parent = Track
            AddCorner(Circle, 7)

            local function applyState(state, triggerCallback)
                toggled = state
                if toggled then
                    Tween(Track, {BackgroundColor3 = COLORS.Accent}, 0.2)
                    Tween(Circle, {Position = UDim2.new(1, -17, 0.5, -7)}, 0.2, Enum.EasingStyle.Back)
                    Tween(tglStroke, {Color = COLORS.StrokeAccent}, 0.2)
                else
                    Tween(Track, {BackgroundColor3 = COLORS.Toggle_Off}, 0.2)
                    Tween(Circle, {Position = UDim2.new(0, 3, 0.5, -7)}, 0.2, Enum.EasingStyle.Back)
                    Tween(tglStroke, {Color = COLORS.Stroke}, 0.2)
                end
                if triggerCallback then pcall(callback, toggled) end
            end

            Track.MouseButton1Click:Connect(function()
                applyState(not toggled, true)
            end)

            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = COLORS.ElementHover}, 0.18)
            end)
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = COLORS.Element}, 0.18)
            end)

            return {
                SetState = function(self, state)
                    applyState(state, true)
                end
            }
        end

        -- ── LABEL ────────────────────────────────────────────────
        function Section:CreateLabel(labelText)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Size = UDim2.new(1, 0, 0, 32)
            LabelFrame.BackgroundColor3 = COLORS.Element
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Parent = ContentContainer
            AddCorner(LabelFrame, 8)
            AddStroke(LabelFrame, COLORS.Stroke, 1)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = labelText
            Label.TextColor3 = COLORS.TextSecondary
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.Parent = LabelFrame

            return {
                Set = function(self, newText)
                    Label.Text = newText
                    Tween(LabelFrame, {BackgroundColor3 = COLORS.AccentDark}, 0.12)
                    task.delay(0.18, function()
                        Tween(LabelFrame, {BackgroundColor3 = COLORS.Element}, 0.3)
                    end)
                end,
                SetColor = function(self, color)
                    Tween(Label, {TextColor3 = color}, 0.2)
                end
            }
        end

        -- ── KEYBIND ──────────────────────────────────────────────
        function Section:CreateKeybind(keybindText, defaultKey, callback)
            local currentKey = defaultKey or Enum.KeyCode.E
            local binding = false

            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size = UDim2.new(1, 0, 0, 36)
            KeybindFrame.BackgroundColor3 = COLORS.Element
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = ContentContainer
            AddCorner(KeybindFrame, 8)
            local kbStroke = AddStroke(KeybindFrame, COLORS.Stroke, 1)

            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 12, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = keybindText
            KeybindLabel.TextColor3 = COLORS.TextPrimary
            KeybindLabel.TextSize = 13
            KeybindLabel.Font = Enum.Font.Gotham
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame

            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 58, 0, 24)
            KeybindButton.Position = UDim2.new(1, -63, 0.5, -12)
            KeybindButton.BackgroundColor3 = Color3.fromRGB(42, 42, 55)
            KeybindButton.Text = currentKey.Name
            KeybindButton.TextColor3 = COLORS.TextPrimary
            KeybindButton.TextSize = 11
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Parent = KeybindFrame
            AddCorner(KeybindButton, 5)
            AddStroke(KeybindButton, COLORS.Stroke, 1)

            KeybindButton.MouseButton1Click:Connect(function()
                binding = true
                KeybindButton.Text = "..."
                Tween(KeybindButton, {BackgroundColor3 = COLORS.AccentDark}, 0.15)
                Tween(kbStroke, {Color = COLORS.StrokeAccent}, 0.15)
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    KeybindButton.Text = currentKey.Name
                    binding = false
                    Tween(KeybindButton, {BackgroundColor3 = Color3.fromRGB(42, 42, 55)}, 0.15)
                    Tween(kbStroke, {Color = COLORS.Stroke}, 0.15)
                end
                if not gameProcessed and input.KeyCode == currentKey and not binding then
                    pcall(callback)
                end
            end)

            KeybindFrame.MouseEnter:Connect(function()
                Tween(KeybindFrame, {BackgroundColor3 = COLORS.ElementHover}, 0.18)
            end)
            KeybindFrame.MouseLeave:Connect(function()
                Tween(KeybindFrame, {BackgroundColor3 = COLORS.Element}, 0.18)
            end)
        end

        -- ── SLIDER ───────────────────────────────────────────────
        --[[
            Section:CreateSlider(text, min, max, default, callback)
            callback recebe o valor atual (number)
        ]]
        function Section:CreateSlider(sliderText, min, max, default, callback)
            min     = min     or 0
            max     = max     or 100
            default = math.clamp(default or min, min, max)

            local value = default
            local draggingSlider = false

            -- Container
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 52)
            SliderFrame.BackgroundColor3 = COLORS.Element
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = ContentContainer
            AddCorner(SliderFrame, 8)
            AddStroke(SliderFrame, COLORS.Stroke, 1)

            -- Texto + valor
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -50, 0, 22)
            SliderLabel.Position = UDim2.new(0, 12, 0, 6)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderText
            SliderLabel.TextColor3 = COLORS.TextPrimary
            SliderLabel.TextSize = 13
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 40, 0, 22)
            ValueLabel.Position = UDim2.new(1, -48, 0, 6)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(value)
            ValueLabel.TextColor3 = COLORS.Accent
            ValueLabel.TextSize = 12
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame

            -- Track
            local TrackBg = Instance.new("Frame")
            TrackBg.Size = UDim2.new(1, -24, 0, 6)
            TrackBg.Position = UDim2.new(0, 12, 0, 36)
            TrackBg.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
            TrackBg.BorderSizePixel = 0
            TrackBg.Parent = SliderFrame
            AddCorner(TrackBg, 3)
            AddStroke(TrackBg, COLORS.Stroke, 1)

            local TrackFill = Instance.new("Frame")
            TrackFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            TrackFill.BackgroundColor3 = COLORS.Accent
            TrackFill.BorderSizePixel = 0
            TrackFill.Parent = TrackBg
            AddCorner(TrackFill, 3)

            -- Thumb
            local Thumb = Instance.new("Frame")
            Thumb.Size = UDim2.new(0, 14, 0, 14)
            Thumb.AnchorPoint = Vector2.new(0.5, 0.5)
            Thumb.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
            Thumb.BackgroundColor3 = COLORS.White
            Thumb.BorderSizePixel = 0
            Thumb.ZIndex = 3
            Thumb.Parent = TrackBg
            AddCorner(Thumb, 7)
            AddStroke(Thumb, COLORS.Accent, 2)

            local function setSliderValue(newValue, trigger)
                newValue = math.clamp(math.round(newValue), min, max)
                value = newValue
                local pct = (value - min) / (max - min)
                Tween(TrackFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.05)
                Tween(Thumb, {Position = UDim2.new(pct, 0, 0.5, 0)}, 0.05)
                ValueLabel.Text = tostring(value)
                if trigger then pcall(callback, value) end
            end

            local function getValueFromInput(input)
                local absPos   = TrackBg.AbsolutePosition.X
                local absSize  = TrackBg.AbsoluteSize.X
                local relative = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
                return min + relative * (max - min)
            end

            TrackBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    setSliderValue(getValueFromInput(input), true)
                end
            end)

            TrackBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                    setSliderValue(getValueFromInput(input), true)
                end
            end)

            SliderFrame.MouseEnter:Connect(function()
                Tween(SliderFrame, {BackgroundColor3 = COLORS.ElementHover}, 0.18)
            end)
            SliderFrame.MouseLeave:Connect(function()
                Tween(SliderFrame, {BackgroundColor3 = COLORS.Element}, 0.18)
                draggingSlider = false
            end)

            return {
                SetValue = function(self, newVal)
                    setSliderValue(newVal, true)
                end,
                GetValue = function(self)
                    return value
                end
            }
        end

        -- ── DROPDOWN ─────────────────────────────────────────────
        --[[
            Section:CreateDropdown(text, options, default, callback)
            options  = {"Opção 1", "Opção 2", ...}
            default  = "Opção 1"   (string ou nil)
            callback recebe o item selecionado (string)
        ]]
        function Section:CreateDropdown(dropText, options, default, callback)
            local selected = default or options[1] or ""
            local open = false

            -- Wrapper que vai crescer para conter a lista
            local DDWrapper = Instance.new("Frame")
            DDWrapper.Name = "DDWrapper"
            DDWrapper.Size = UDim2.new(1, 0, 0, 36)
            DDWrapper.BackgroundTransparency = 1
            DDWrapper.ClipsDescendants = false
            DDWrapper.Parent = ContentContainer

            -- Header do dropdown
            local DDHeader = Instance.new("Frame")
            DDHeader.Size = UDim2.new(1, 0, 0, 36)
            DDHeader.BackgroundColor3 = COLORS.Element
            DDHeader.BorderSizePixel = 0
            DDHeader.ZIndex = 5
            DDHeader.Parent = DDWrapper
            AddCorner(DDHeader, 8)
            local ddStroke = AddStroke(DDHeader, COLORS.Stroke, 1)
            DDHeader.ZIndex = 5

            local DDLabel = Instance.new("TextLabel")
            DDLabel.Size = UDim2.new(1, -55, 1, 0)
            DDLabel.Position = UDim2.new(0, 12, 0, 0)
            DDLabel.BackgroundTransparency = 1
            DDLabel.Text = dropText
            DDLabel.TextColor3 = COLORS.TextSecondary
            DDLabel.TextSize = 11
            DDLabel.Font = Enum.Font.GothamBold
            DDLabel.TextXAlignment = Enum.TextXAlignment.Left
            DDLabel.ZIndex = 6
            DDLabel.Parent = DDHeader

            local DDSelected = Instance.new("TextLabel")
            DDSelected.Size = UDim2.new(1, -55, 1, 0)
            DDSelected.Position = UDim2.new(0, 12, 0, 0)
            DDSelected.BackgroundTransparency = 1
            DDSelected.Text = selected
            DDSelected.TextColor3 = COLORS.TextPrimary
            DDSelected.TextSize = 13
            DDSelected.Font = Enum.Font.Gotham
            DDSelected.TextXAlignment = Enum.TextXAlignment.Left
            DDSelected.ZIndex = 6
            DDSelected.Parent = DDHeader
            -- Empurra o texto do item selecionado para a direita do label
            DDLabel.Size = UDim2.new(0, 0, 0, 0) -- oculto, usamos só o Selected

            -- Ícone de seta
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 24, 1, 0)
            Arrow.Position = UDim2.new(1, -28, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▾"
            Arrow.TextColor3 = COLORS.Accent
            Arrow.TextSize = 14
            Arrow.Font = Enum.Font.GothamBold
            Arrow.ZIndex = 6
            Arrow.Parent = DDHeader

            -- Lista de opções (começa invisível/tamanho 0)
            local DDList = Instance.new("Frame")
            DDList.Size = UDim2.new(1, 0, 0, 0)
            DDList.Position = UDim2.new(0, 0, 1, 4)
            DDList.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            DDList.BorderSizePixel = 0
            DDList.ClipsDescendants = true
            DDList.ZIndex = 10
            DDList.Parent = DDHeader
            AddCorner(DDList, 8)
            AddStroke(DDList, COLORS.Stroke, 1)

            local DDListLayout = Instance.new("UIListLayout")
            DDListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DDListLayout.Padding = UDim.new(0, 2)
            DDListLayout.Parent = DDList

            AddPadding(DDList, 4, 4, 0, 0)

            local ITEM_H = 30
            local fullListH = #options * (ITEM_H + 2) + 10

            -- Cria os itens
            for _, opt in ipairs(options) do
                local Item = Instance.new("TextButton")
                Item.Size = UDim2.new(1, -8, 0, ITEM_H)
                Item.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
                Item.Text = opt
                Item.TextColor3 = opt == selected and COLORS.Accent or COLORS.TextPrimary
                Item.TextSize = 13
                Item.Font = opt == selected and Enum.Font.GothamBold or Enum.Font.Gotham
                Item.BorderSizePixel = 0
                Item.ZIndex = 11
                Item.Parent = DDList
                AddCorner(Item, 6)

                -- Margem lateral
                local ip = Instance.new("UIPadding")
                ip.PaddingLeft  = UDim.new(0, 4)
                ip.PaddingRight = UDim.new(0, 4)
                ip.Parent = Item

                Item.MouseEnter:Connect(function()
                    Tween(Item, {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}, 0.12)
                end)
                Item.MouseLeave:Connect(function()
                    Tween(Item, {
                        BackgroundColor3 = opt == selected
                            and Color3.fromRGB(42, 42, 58)
                            or  Color3.fromRGB(38, 38, 50)
                    }, 0.12)
                end)

                Item.MouseButton1Click:Connect(function()
                    selected = opt
                    DDSelected.Text = opt

                    -- Atualiza visual de todos os itens
                    for _, child in ipairs(DDList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.TextColor3 = child.Text == selected and COLORS.Accent or COLORS.TextPrimary
                            child.Font = child.Text == selected and Enum.Font.GothamBold or Enum.Font.Gotham
                            Tween(child, {
                                BackgroundColor3 = child.Text == selected
                                    and Color3.fromRGB(42, 42, 58)
                                    or  Color3.fromRGB(38, 38, 50)
                            }, 0.1)
                        end
                    end

                    -- Fecha
                    open = false
                    Tween(DDList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quad)
                    Tween(DDWrapper, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                    Tween(Arrow, {Rotation = 0}, 0.2)
                    Tween(ddStroke, {Color = COLORS.Stroke}, 0.15)

                    pcall(callback, selected)
                end)
            end

            -- Botão clicável no header
            local DDButton = Instance.new("TextButton")
            DDButton.Size = UDim2.new(1, 0, 1, 0)
            DDButton.BackgroundTransparency = 1
            DDButton.Text = ""
            DDButton.ZIndex = 7
            DDButton.Parent = DDHeader

            DDButton.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    Tween(DDList, {Size = UDim2.new(1, 0, 0, fullListH)}, 0.25, Enum.EasingStyle.Back)
                    Tween(DDWrapper, {Size = UDim2.new(1, 0, 0, 36 + fullListH + 4)}, 0.25, Enum.EasingStyle.Back)
                    Tween(Arrow, {Rotation = 180}, 0.2)
                    Tween(ddStroke, {Color = COLORS.StrokeAccent}, 0.15)
                else
                    Tween(DDList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quad)
                    Tween(DDWrapper, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                    Tween(Arrow, {Rotation = 0}, 0.2)
                    Tween(ddStroke, {Color = COLORS.Stroke}, 0.15)
                end
            end)

            DDHeader.MouseEnter:Connect(function()
                if not open then
                    Tween(DDHeader, {BackgroundColor3 = COLORS.ElementHover}, 0.18)
                end
            end)
            DDHeader.MouseLeave:Connect(function()
                Tween(DDHeader, {BackgroundColor3 = COLORS.Element}, 0.18)
            end)

            return {
                SetSelected = function(self, opt)
                    if table.find(options, opt) then
                        selected = opt
                        DDSelected.Text = opt
                        pcall(callback, selected)
                    end
                end,
                GetSelected = function(self)
                    return selected
                end
            }
        end

        return Section
    end

    return Window
end

return Library
