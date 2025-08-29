net.Receive('GameProfile-GetProfile', function()
    local steamid = net.ReadString()
    local profile = net.ReadTable()

    GameProfile.profiles[steamid] = profile
end)

net.Receive('GameProfile-GetInventory', function()
    local inventory = net.ReadTable()

    GameProfile.active_inventory = inventory
end)
