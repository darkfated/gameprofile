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

net.Receive('GameProfile-SendAllProfile', function()
    local data_size = net.ReadUInt(32)
    local data = net.ReadData(data_size)

    GameProfile.profiles = util.JSONToTable(util.Decompress(data))
end)

net.Receive('GameProfile-SendProfile', function()
    local pl_steamid = net.ReadString()
    local pl_tag = net.ReadString()
    local pl_tag_data = net.ReadString()

    if GameProfile.profiles[pl_steamid] then
        GameProfile.profiles[pl_steamid][pl_tag] = pl_tag_data
    end
end)

net.Receive('GameProfile-SendProfileData', function()
    local pl_steamid = net.ReadString()
    local pl_data = net.ReadTable()

    GameProfile.profiles[pl_steamid] = pl_data
end)
