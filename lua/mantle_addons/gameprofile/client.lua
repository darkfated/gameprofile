GameProfile.active_player_data = GameProfile.active_player_data or {}

function GameProfile.add_tab(id, name, icon, func)
    GameProfile.menu_tabs[id] = {
        name = name,
        icon = icon,
        func = func
    }
end

net.Receive('GameProfile-GetPlayerData', function()
    local data = net.ReadTable()

    GameProfile.active_player_data = data
end)
