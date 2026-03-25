local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local BG      = Color3.fromRGB(22, 22, 28)
local HEADER  = Color3.fromRGB(30, 30, 38)
local ELEM    = Color3.fromRGB(32, 32, 40)
local ELEMHOV = Color3.fromRGB(42, 42, 52)
local ACCENT  = Color3.fromRGB(90, 150, 255)
local ACCDARK = Color3.fromRGB(55, 100, 200)
local STR     = Color3.fromRGB(55, 55, 70)
local STRACC  = Color3.fromRGB(90, 150, 255)
local TXTPRI  = Color3.fromRGB(240, 240, 245)
local TXTSEC  = Color3.fromRGB(160, 160, 175)
local WHITE   = Color3.fromRGB(255, 255, 255)
local TOGOFF  = Color3.fromRGB(50, 50, 62)

local function tw(obj, props, t, sty, dir)
    TweenService:Create(obj, TweenInfo.new(t or 0.25, sty or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function stroke(p, col, thick)
    local s = Instance.new("UIStroke")
    s.Color = col or STR
    s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function pad(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    u.PaddingLeft   = UDim.new(0, l or 0)
    u.PaddingRight  = UDim.new(0, r or 0)
    u.Parent = p
end

function Library:NewWindow(title)
    local Window = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "MiniLibUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent = CoreGui end)
    if not gui.Parent then
        gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 295, 0, 0)
    main.Position = UDim2.new(0.5, -147, 0.5, -170)
    main.BackgroundColor3 = BG
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui
    corner(main, 10)
    stroke(main, STR, 1)

    local hdr = Instance.new("Frame")
    hdr.Size = UDim2.new(1, 0, 0, 44)
    hdr.BackgroundColor3 = HEADER
    hdr.BorderSizePixel = 0
    hdr.Parent = main
    corner(hdr, 10)

    local hdrLine = Instance.new("Frame")
    hdrLine.Size = UDim2.new(1, 0, 0, 1)
    hdrLine.Position = UDim2.new(0, 0, 1, -1)
    hdrLine.BackgroundColor3 = STR
    hdrLine.BorderSizePixel = 0
    hdrLine.Parent = hdr

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, 13, 0.5, -4)
    dot.BackgroundColor3 = ACCENT
    dot.BorderSizePixel = 0
    dot.Parent = hdr
    corner(dot, 4)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -80, 1, 0)
    titleLbl.Position = UDim2.new(0, 28, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = TXTPRI
    titleLbl.TextSize = 15
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = hdr

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -35, 0.5, -14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 68)
    closeBtn.Text = "x"
    closeBtn.TextColor3 = TXTPRI
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = hdr
    corner(closeBtn, 7)
    stroke(closeBtn, STR, 1)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -18, 1, -52)
    scroll.Position = UDim2.new(0, 9, 0, 48)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = ACCENT
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Parent = main

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = scroll

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    local dragging, dragInput, dragStart, startPos
    hdr.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startPos = main.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    hdr.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement then dragInput = inp end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local d = inp.Position - dragStart
            tw(main, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)}, 0.07)
        end
    end)

    local minimized = false
    closeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tw(main, {Size = UDim2.new(0, 295, 0, 44)}, 0.3)
            closeBtn.Text = "+"
        else
            tw(main, {Size = UDim2.new(0, 295, 0, layout.AbsoluteContentSize.Y + 62)}, 0.3)
            closeBtn.Text = "x"
        end
    end)
    closeBtn.MouseEnter:Connect(function() tw(closeBtn, {BackgroundColor3 = Color3.fromRGB(200, 55, 55)}, 0.15) end)
    closeBtn.MouseLeave:Connect(function() tw(closeBtn, {BackgroundColor3 = Color3.fromRGB(55, 55, 68)}, 0.15) end)

    task.delay(0.05, function()
        tw(main, {Size = UDim2.new(0, 295, 0, 320)}, 0.4)
    end)

    function Window:NewSection(secTitle)
        local Section = {}

        local secHdr = Instance.new("Frame")
        secHdr.Size = UDim2.new(1, 0, 0, 24)
        secHdr.BackgroundTransparency = 1
        secHdr.Parent = scroll

        local secLine = Instance.new("Frame")
        secLine.Size = UDim2.new(0.28, 0, 0, 1)
        secLine.Position = UDim2.new(0, 0, 1, -1)
        secLine.BackgroundColor3 = ACCENT
        secLine.BorderSizePixel = 0
        secLine.Parent = secHdr

        local secLbl = Instance.new("TextLabel")
        secLbl.Size = UDim2.new(1, 0, 1, 0)
        secLbl.BackgroundTransparency = 1
        secLbl.Text = string.upper(secTitle)
        secLbl.TextColor3 = ACCENT
        secLbl.TextSize = 11
        secLbl.Font = Enum.Font.GothamBold
        secLbl.TextXAlignment = Enum.TextXAlignment.Left
        secLbl.Parent = secHdr

        function Section:CreateButton(txt, cb)
            local bf = Instance.new("Frame")
            bf.Size = UDim2.new(1, 0, 0, 36)
            bf.BackgroundColor3 = ELEM
            bf.BorderSizePixel = 0
            bf.Parent = scroll
            corner(bf, 8)
            local bs = stroke(bf, STR, 1)

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = txt
            btn.TextColor3 = TXTPRI
            btn.TextSize = 13
            btn.Font = Enum.Font.Gotham
            btn.Parent = bf

            btn.MouseButton1Click:Connect(function()
                tw(bf, {BackgroundColor3 = ACCENT}, 0.1)
                tw(bs, {Color = STRACC}, 0.1)
                task.delay(0.13, function()
                    tw(bf, {BackgroundColor3 = ELEM}, 0.2)
                    tw(bs, {Color = STR}, 0.2)
                end)
                pcall(cb)
            end)
            btn.MouseEnter:Connect(function() tw(bf, {BackgroundColor3 = ELEMHOV}, 0.15) tw(bs, {Color = STRACC}, 0.15) end)
            btn.MouseLeave:Connect(function() tw(bf, {BackgroundColor3 = ELEM}, 0.15) tw(bs, {Color = STR}, 0.15) end)
        end

        function Section:CreateToggle(txt, default, cb)
            local toggled = default or false

            local tf = Instance.new("Frame")
            tf.Size = UDim2.new(1, 0, 0, 36)
            tf.BackgroundColor3 = ELEM
            tf.BorderSizePixel = 0
            tf.Parent = scroll
            corner(tf, 8)
            local ts = stroke(tf, STR, 1)

            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, -55, 1, 0)
            tl.Position = UDim2.new(0, 12, 0, 0)
            tl.BackgroundTransparency = 1
            tl.Text = txt
            tl.TextColor3 = TXTPRI
            tl.TextSize = 13
            tl.Font = Enum.Font.Gotham
            tl.TextXAlignment = Enum.TextXAlignment.Left
            tl.Parent = tf

            local track = Instance.new("TextButton")
            track.Size = UDim2.new(0, 40, 0, 20)
            track.Position = UDim2.new(1, -46, 0.5, -10)
            track.BackgroundColor3 = toggled and ACCENT or TOGOFF
            track.Text = ""
            track.BorderSizePixel = 0
            track.Parent = tf
            corner(track, 10)
            stroke(track, STR, 1)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 14, 0, 14)
            circle.Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            circle.BackgroundColor3 = WHITE
            circle.BorderSizePixel = 0
            circle.Parent = track
            corner(circle, 7)

            local function apply(state, fire)
                toggled = state
                if toggled then
                    tw(track, {BackgroundColor3 = ACCENT}, 0.2)
                    tw(circle, {Position = UDim2.new(1, -17, 0.5, -7)}, 0.2)
                    tw(ts, {Color = STRACC}, 0.2)
                else
                    tw(track, {BackgroundColor3 = TOGOFF}, 0.2)
                    tw(circle, {Position = UDim2.new(0, 3, 0.5, -7)}, 0.2)
                    tw(ts, {Color = STR}, 0.2)
                end
                if fire then pcall(cb, toggled) end
            end

            track.MouseButton1Click:Connect(function() apply(not toggled, true) end)
            tf.MouseEnter:Connect(function() tw(tf, {BackgroundColor3 = ELEMHOV}, 0.15) end)
            tf.MouseLeave:Connect(function() tw(tf, {BackgroundColor3 = ELEM}, 0.15) end)

            return {SetState = function(_, s) apply(s, true) end}
        end

        function Section:CreateLabel(txt)
            local lf = Instance.new("Frame")
            lf.Size = UDim2.new(1, 0, 0, 32)
            lf.BackgroundColor3 = ELEM
            lf.BorderSizePixel = 0
            lf.Parent = scroll
            corner(lf, 8)
            stroke(lf, STR, 1)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -18, 1, 0)
            lbl.Position = UDim2.new(0, 9, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = txt
            lbl.TextColor3 = TXTSEC
            lbl.TextSize = 12
            lbl.Font = Enum.Font.Gotham
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.Parent = lf

            return {
                Set = function(_, t)
                    lbl.Text = t
                    tw(lf, {BackgroundColor3 = ACCDARK}, 0.12)
                    task.delay(0.2, function() tw(lf, {BackgroundColor3 = ELEM}, 0.3) end)
                end,
                SetColor = function(_, c) tw(lbl, {TextColor3 = c}, 0.2) end
            }
        end

        function Section:CreateKeybind(txt, defaultKey, cb)
            local curKey = defaultKey or Enum.KeyCode.E
            local binding = false

            local kf = Instance.new("Frame")
            kf.Size = UDim2.new(1, 0, 0, 36)
            kf.BackgroundColor3 = ELEM
            kf.BorderSizePixel = 0
            kf.Parent = scroll
            corner(kf, 8)
            local ks = stroke(kf, STR, 1)

            local kl = Instance.new("TextLabel")
            kl.Size = UDim2.new(1, -80, 1, 0)
            kl.Position = UDim2.new(0, 12, 0, 0)
            kl.BackgroundTransparency = 1
            kl.Text = txt
            kl.TextColor3 = TXTPRI
            kl.TextSize = 13
            kl.Font = Enum.Font.Gotham
            kl.TextXAlignment = Enum.TextXAlignment.Left
            kl.Parent = kf

            local kb = Instance.new("TextButton")
            kb.Size = UDim2.new(0, 56, 0, 24)
            kb.Position = UDim2.new(1, -61, 0.5, -12)
            kb.BackgroundColor3 = Color3.fromRGB(42, 42, 55)
            kb.Text = curKey.Name
            kb.TextColor3 = TXTPRI
            kb.TextSize = 11
            kb.Font = Enum.Font.GothamBold
            kb.BorderSizePixel = 0
            kb.Parent = kf
            corner(kb, 5)
            stroke(kb, STR, 1)

            kb.MouseButton1Click:Connect(function()
                binding = true
                kb.Text = "..."
                tw(kb, {BackgroundColor3 = ACCDARK}, 0.15)
                tw(ks, {Color = STRACC}, 0.15)
            end)

            UserInputService.InputBegan:Connect(function(inp, gp)
                if binding and inp.UserInputType == Enum.UserInputType.Keyboard then
                    curKey = inp.KeyCode
                    kb.Text = curKey.Name
                    binding = false
                    tw(kb, {BackgroundColor3 = Color3.fromRGB(42, 42, 55)}, 0.15)
                    tw(ks, {Color = STR}, 0.15)
                end
                if not gp and inp.KeyCode == curKey and not binding then pcall(cb) end
            end)

            kf.MouseEnter:Connect(function() tw(kf, {BackgroundColor3 = ELEMHOV}, 0.15) end)
            kf.MouseLeave:Connect(function() tw(kf, {BackgroundColor3 = ELEM}, 0.15) end)
        end

        function Section:CreateSlider(txt, min, max, default, cb)
            min     = min or 0
            max     = max or 100
            default = math.clamp(default or min, min, max)
            local value = default
            local drag = false

            local sf = Instance.new("Frame")
            sf.Size = UDim2.new(1, 0, 0, 52)
            sf.BackgroundColor3 = ELEM
            sf.BorderSizePixel = 0
            sf.Parent = scroll
            corner(sf, 8)
            stroke(sf, STR, 1)

            local sl = Instance.new("TextLabel")
            sl.Size = UDim2.new(1, -50, 0, 22)
            sl.Position = UDim2.new(0, 12, 0, 5)
            sl.BackgroundTransparency = 1
            sl.Text = txt
            sl.TextColor3 = TXTPRI
            sl.TextSize = 13
            sl.Font = Enum.Font.Gotham
            sl.TextXAlignment = Enum.TextXAlignment.Left
            sl.Parent = sf

            local vl = Instance.new("TextLabel")
            vl.Size = UDim2.new(0, 42, 0, 22)
            vl.Position = UDim2.new(1, -48, 0, 5)
            vl.BackgroundTransparency = 1
            vl.Text = tostring(value)
            vl.TextColor3 = ACCENT
            vl.TextSize = 12
            vl.Font = Enum.Font.GothamBold
            vl.TextXAlignment = Enum.TextXAlignment.Right
            vl.Parent = sf

            local trackBg = Instance.new("Frame")
            trackBg.Size = UDim2.new(1, -24, 0, 6)
            trackBg.Position = UDim2.new(0, 12, 0, 36)
            trackBg.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
            trackBg.BorderSizePixel = 0
            trackBg.Parent = sf
            corner(trackBg, 3)
            stroke(trackBg, STR, 1)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = ACCENT
            fill.BorderSizePixel = 0
            fill.Parent = trackBg
            corner(fill, 3)

            local thumb = Instance.new("Frame")
            thumb.Size = UDim2.new(0, 14, 0, 14)
            thumb.AnchorPoint = Vector2.new(0.5, 0.5)
            thumb.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
            thumb.BackgroundColor3 = WHITE
            thumb.BorderSizePixel = 0
            thumb.ZIndex = 3
            thumb.Parent = trackBg
            corner(thumb, 7)
            stroke(thumb, ACCENT, 2)

            local function setValue(v, fire)
                v = math.clamp(math.round(v), min, max)
                value = v
                local p = (value - min) / (max - min)
                tw(fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.05)
                tw(thumb, {Position = UDim2.new(p, 0, 0.5, 0)}, 0.05)
                vl.Text = tostring(value)
                if fire then pcall(cb, value) end
            end

            local function fromInput(inp)
                local rel = math.clamp((inp.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
                return min + rel * (max - min)
            end

            trackBg.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    drag = true
                    setValue(fromInput(inp), true)
                end
            end)
            trackBg.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if drag and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    setValue(fromInput(inp), true)
                end
            end)
            sf.MouseEnter:Connect(function() tw(sf, {BackgroundColor3 = ELEMHOV}, 0.15) end)
            sf.MouseLeave:Connect(function() tw(sf, {BackgroundColor3 = ELEM}, 0.15) drag = false end)

            return {
                SetValue = function(_, v) setValue(v, true) end,
                GetValue = function() return value end
            }
        end

        function Section:CreateDropdown(txt, options, default, cb)
            local selected = default or options[1] or ""
            local open = false

            local wrapper = Instance.new("Frame")
            wrapper.Size = UDim2.new(1, 0, 0, 36)
            wrapper.BackgroundTransparency = 1
            wrapper.ClipsDescendants = false
            wrapper.Parent = scroll

            local dh = Instance.new("Frame")
            dh.Size = UDim2.new(1, 0, 0, 36)
            dh.BackgroundColor3 = ELEM
            dh.BorderSizePixel = 0
            dh.ZIndex = 5
            dh.Parent = wrapper
            corner(dh, 8)
            local dhs = stroke(dh, STR, 1)

            local dsel = Instance.new("TextLabel")
            dsel.Size = UDim2.new(1, -38, 1, 0)
            dsel.Position = UDim2.new(0, 12, 0, 0)
            dsel.BackgroundTransparency = 1
            dsel.Text = selected
            dsel.TextColor3 = TXTPRI
            dsel.TextSize = 13
            dsel.Font = Enum.Font.Gotham
            dsel.TextXAlignment = Enum.TextXAlignment.Left
            dsel.ZIndex = 6
            dsel.Parent = dh

            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 24, 1, 0)
            arrow.Position = UDim2.new(1, -28, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "v"
            arrow.TextColor3 = ACCENT
            arrow.TextSize = 13
            arrow.Font = Enum.Font.GothamBold
            arrow.ZIndex = 6
            arrow.Parent = dh

            local list = Instance.new("Frame")
            list.Size = UDim2.new(1, 0, 0, 0)
            list.Position = UDim2.new(0, 0, 1, 4)
            list.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
            list.BorderSizePixel = 0
            list.ClipsDescendants = true
            list.ZIndex = 10
            list.Parent = dh
            corner(list, 8)
            stroke(list, STR, 1)

            local ll = Instance.new("UIListLayout")
            ll.SortOrder = Enum.SortOrder.LayoutOrder
            ll.Padding = UDim.new(0, 2)
            ll.Parent = list
            pad(list, 4, 4, 0, 0)

            local IH = 30
            local fullH = #options * (IH + 2) + 10

            for _, opt in ipairs(options) do
                local item = Instance.new("TextButton")
                item.Size = UDim2.new(1, -8, 0, IH)
                item.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
                item.Text = opt
                item.TextColor3 = opt == selected and ACCENT or TXTPRI
                item.TextSize = 13
                item.Font = opt == selected and Enum.Font.GothamBold or Enum.Font.Gotham
                item.BorderSizePixel = 0
                item.ZIndex = 11
                item.Parent = list
                corner(item, 6)
                pad(item, 0, 0, 6, 6)

                item.MouseEnter:Connect(function() tw(item, {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}, 0.1) end)
                item.MouseLeave:Connect(function()
                    tw(item, {BackgroundColor3 = opt == selected and Color3.fromRGB(42,42,58) or Color3.fromRGB(38,38,50)}, 0.1)
                end)
                item.MouseButton1Click:Connect(function()
                    selected = opt
                    dsel.Text = opt
                    for _, ch in ipairs(list:GetChildren()) do
                        if ch:IsA("TextButton") then
                            ch.TextColor3 = ch.Text == selected and ACCENT or TXTPRI
                            ch.Font = ch.Text == selected and Enum.Font.GothamBold or Enum.Font.Gotham
                            tw(ch, {BackgroundColor3 = ch.Text == selected and Color3.fromRGB(42,42,58) or Color3.fromRGB(38,38,50)}, 0.1)
                        end
                    end
                    open = false
                    tw(list, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    tw(wrapper, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                    tw(dhs, {Color = STR}, 0.15)
                    arrow.Text = "v"
                    pcall(cb, selected)
                end)
            end

            local dbtn = Instance.new("TextButton")
            dbtn.Size = UDim2.new(1, 0, 1, 0)
            dbtn.BackgroundTransparency = 1
            dbtn.Text = ""
            dbtn.ZIndex = 7
            dbtn.Parent = dh

            dbtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    tw(list, {Size = UDim2.new(1, 0, 0, fullH)}, 0.25)
                    tw(wrapper, {Size = UDim2.new(1, 0, 0, 36 + fullH + 4)}, 0.25)
                    tw(dhs, {Color = STRACC}, 0.15)
                    arrow.Text = "^"
                else
                    tw(list, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    tw(wrapper, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                    tw(dhs, {Color = STR}, 0.15)
                    arrow.Text = "v"
                end
            end)

            dh.MouseEnter:Connect(function() if not open then tw(dh, {BackgroundColor3 = ELEMHOV}, 0.15) end end)
            dh.MouseLeave:Connect(function() tw(dh, {BackgroundColor3 = ELEM}, 0.15) end)

            return {
                SetSelected = function(_, opt)
                    if table.find(options, opt) then
                        selected = opt
                        dsel.Text = opt
                        pcall(cb, selected)
                    end
                end,
                GetSelected = function() return selected end
            }
        end

        return Section
    end

    return Window
end

return Library
