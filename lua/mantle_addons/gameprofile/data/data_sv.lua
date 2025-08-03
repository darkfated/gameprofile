util.AddNetworkString('GameProfile-GetProfile')

hook.Add('Initialize', 'GameProfile.Data', function()
    if !sql.TableExists('gameprofile') then
        sql.Query([[
            CREATE TABLE IF NOT EXISTS gameprofile (
                steamid64 TEXT,
                nickname TEXT,
                gender TEXT,
                status TEXT,
                age UNSIGNED INTEGER,
                city TEXT DEFAULT 'Не указано'
            )
        ]])
    end

    local profiles = sql.Query('SELECT * FROM gameprofile')

    if profiles then
        local tabl = {}

        for _, row in ipairs(profiles) do            
            tabl[row.steamid64] = row
        end

        GameProfile.profiles = tabl
    end
end)

hook.Add('PlayerInitialSpawn', 'GameProfile.SendProfiles', function(newPlayer)
    for _, pl in player.Iterator() do
        local steamid64 = pl:SteamID64()

        net.Start('GameProfile-GetProfile')
            net.WriteString(steamid64)
            net.WriteTable(GameProfile.profiles[steamid64])
        net.Send(newPlayer)
    end
end)
