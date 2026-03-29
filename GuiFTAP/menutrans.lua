local EuGui = game.Players.LocalPlayer.PlayerGui

local GameCorrectKickNotify = EuGui:WaitForChild("GameCorrectionsGui"):WaitForChild("TweenFrame"):WaitForChild("Flying")
GameCorrectKickNotify.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
GameCorrectKickNotify.BackgroundTransparency = 0.5

local GameCorrectNonseNotify = EuGui:WaitForChild("GameCorrectionsGui"):WaitForChild("TweenFrame"):WaitForChild("NonsenseGrab")
GameCorrectNonseNotify.BackgroundTransparency = 0.7

local MenuGuiTabbar = EuGui:WaitForChild("MenuGui"):WaitForChild("Menu"):WaitForChild("TabBar")
MenuGuiTabbar.BackgroundTransparency = 0.7

local MetterFrametransMOdi = EuGui:WaitForChild("MenuGui"):WaitForChild("Menu"):WaitForChild("TabContents"):WaitForChild("Toys"):WaitForChild("MeterFrame")
MetterFrametransMOdi.BackgroundTransparency = 0.7

local MenuDentro2 = EuGui:WaitForChild("MenuGui"):WaitForChild("Menu"):WaitForChild("TabContents"):WaitForChild("Toys"):WaitForChild("Contents")
task.spawn(function()
    while true do
        MenuDentro2.BackgroundTransparency = 0.7
        task.wait(1)
    end
end)

local ColorImageFav = EuGui:WaitForChild("MenuGui"):WaitForChild("Menu"):WaitForChild("TabContents"):WaitForChild("Toys"):WaitForChild("FavoritesFrame"):WaitForChild("Favorites")
task.spawn(function()
    while true do
        ColorImageFav.ImageColor3 = Color3.fromRGB(255, 238, 5)
        task.wait(1)
    end
end)

local SorTabFrameTrans = EuGui:WaitForChild("MenuGui"):WaitForChild("Menu"):WaitForChild("TabContents"):WaitForChild("Toys"):WaitForChild("SortingTabs")
task.spawn(function()
    while true do
        SorTabFrameTrans.BackgroundTransparency = 0.7
        task.wait(0.2)
    end
end)

local TittleModiTrans = EuGui:WaitForChild("MenuGui"):WaitForChild("Menu"):WaitForChild("TabContents"):WaitForChild("Toys"):WaitForChild("Title")
task.spawn(function()
    while true do
        TittleModiTrans.BackgroundTransparency = 0.5
        task.wait(0.2)
    end
end)
