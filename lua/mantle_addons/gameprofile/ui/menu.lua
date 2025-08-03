local tabsList = {
    {'Мои Достижения', 'GameProfile.Achievements'},
    {'Мой Инвентарь', 'GameProfile.Inventory'},
    {'Игроки', 'GameProfile.Players'},
    {'Магазин', 'GameProfile.Shop'}
}

local function CreateMenu()
    GameProfile.ui.menu = vgui.Create('MantleFrame')
    GameProfile.ui.menu:SetSize(800, 500)
    GameProfile.ui.menu:Center()
    GameProfile.ui.menu:MakePopup()
    GameProfile.ui.menu:SetTitle('Система профиля')
    GameProfile.ui.menu:SetCenterTitle('Главное меню')
    GameProfile.ui.menu:SetKeyBoardInputEnabled(false)

    local tabs = vgui.Create('MantleTabs', GameProfile.ui.menu)
    tabs:Dock(FILL)
    tabs:SetTabStyle('classic')

    GameProfile.ui.menu.tabProfile = vgui.Create('GameProfile.Profile')
    GameProfile.ui.menu.tabProfile:SetPlayer(LocalPlayer():SteamID64())
    tabs:AddTab('Мой Профиль', GameProfile.ui.menu.tabProfile)

    for _, tab in ipairs(tabsList) do
        local pan = vgui.Create(tab[2])
        tabs:AddTab(tab[1], pan)
    end
end

concommand.Add('gameprofile_menu', function()
    CreateMenu()
end)
