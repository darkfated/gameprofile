net.Receive('GameProfile-GetProfile', function()
    local steamid64 = net.ReadString()
    local profile = net.ReadTable()

    GameProfile.profiles[steamid64] = profile
end)
