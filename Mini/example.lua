--Load Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Utkaky/Main/refs/heads/main/Mini/MiniLib.lua"))()
--Create the window
local Window = Library:NewWindow("MiniLib Example")
--Create Section
local MainSection = Window:NewSection("Main Features")
--Create Label(Update)
local label = MainSection:CreateLabel("Status: Waiting...")
--Create Button
MainSection:CreateButton("Click Me", function()
    print("Botão clicado!")
    --How To Update Label:
    label:Set("Status: Button Clicked!")
end)
--Create Toggle
MainSection:CreateToggle("Auto Farm", false, function(state)
    print("Toggle:", state)
    if state then
      --Other Example Label
        label:Set("Status: Auto Farm ON")
    else
        label:Set("Status: Auto Farm OFF")
    end
end)
--Create Bind
MainSection:CreateKeybind("Press Key", Enum.KeyCode.E, function()
    print("Keybind ativado!")
    label:Set("Status: Key Pressed!")
end)
--Other Example
local ExtraSection = Window:NewSection("Extras")

ExtraSection:CreateButton("Print Hello", function()
    print("Hello World!")
end)

ExtraSection:CreateToggle("Test Toggle", true, function(state)
    print("Test Toggle:", state)
end)
