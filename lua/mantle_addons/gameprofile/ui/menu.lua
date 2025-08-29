function GameProfile.OpenMenu(steamid)
    if GameProfile.ui.menu then
        GameProfile.ui.menu:Remove()
    end

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
    GameProfile.ui.menu.tabProfile:SetPlayer(steamid)
    tabs:AddTab('Мой Профиль', GameProfile.ui.menu.tabProfile)

    GameProfile.ui.menu.tabAchievements = vgui.Create('GameProfile.Achievements')
    tabs:AddTab('Мои Достижения', GameProfile.ui.menu.tabAchievements)

    GameProfile.ui.menu.tabInventory = vgui.Create('GameProfile.Inventory')
    GameProfile.ui.menu.tabInventory:SetPlayer(steamid)
    tabs:AddTab('Мой Инвентарь', GameProfile.ui.menu.tabInventory)

    GameProfile.ui.menu.tabPlayers = vgui.Create('GameProfile.Players')
    tabs:AddTab('Игроки', GameProfile.ui.menu.tabPlayers)

    GameProfile.ui.menu.tabShop = vgui.Create('GameProfile.Shop')
    tabs:AddTab('Магазин', GameProfile.ui.menu.tabShop)
end

concommand.Add('gameprofile_menu', function()
    GameProfile.OpenMenu(LocalPlayer():SteamID())
end)
