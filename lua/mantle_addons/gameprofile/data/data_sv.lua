util.AddNetworkString('GameProfile-GetProfile')
util.AddNetworkString('GameProfile-GetInventory')

hook.Add('Initialize', 'GameProfile.Data', function()
    if !sql.TableExists('gameprofile') then
        sql.Query([[
            CREATE TABLE IF NOT EXISTS gameprofile (
                steamid TEXT,
                nickname TEXT,
                gender TEXT,
                status TEXT,
                age UNSIGNED INTEGER,
                city TEXT DEFAULT 'Не указано',
                avatar TEXT DEFAULT 'default',
                banner TEXT DEFAULT 'default'
            )
        ]])
    end

    if !sql.TableExists('gameprofile_inv') then
        sql.Query([[
            CREATE TABLE IF NOT EXISTS gameprofile_inv (
                steamid TEXT,
                visual TEXT DEFAULT '[]',
                medal TEXT DEFAULT '[]',
                achievement TEXT DEFAULT '[]'
            )
        ]])
    end

    local profiles = sql.Query('SELECT * FROM gameprofile')

    if profiles then
        for _, row in ipairs(profiles) do
            GameProfile.profiles[row.steamid] = row
        end
    end
end)

hook.Add('PlayerInitialSpawn', 'GameProfile.SendProfiles', function(newPlayer)
    for _, pl in player.Iterator() do
        local steamid = pl:SteamID()

        net.Start('GameProfile-GetProfile')
            net.WriteString(steamid)
            net.WriteTable(GameProfile.profiles[steamid])
        net.Send(newPlayer)
    end
end)

hook.Add('PlayerDisconnected', 'GameProfile.RemoveProfile', function(pl)
    local steamid = pl:SteamID()

    net.Start('GameProfile-GetProfile')
        net.WriteString(steamid)
        net.WriteTable(nil)
    net.Broadcast()
end)
