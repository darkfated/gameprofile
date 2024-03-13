util.AddNetworkString('GameProfile-Create')
util.AddNetworkString('GameProfile-GetPlayerData')
util.AddNetworkString('GameProfile-Notify')
util.AddNetworkString('GameProfile-SendAllProfile')
util.AddNetworkString('GameProfile-SendProfile')
util.AddNetworkString('GameProfile-SendProfileData')

hook.Add('Initialize', 'GameProfile', function()
    if !sql.TableExists('gameprofile') then
        sql.Query([[
            CREATE TABLE IF NOT EXISTS gameprofile (
                steamid TEXT,
                nick TEXT,
                gender TEXT,
                status TEXT,
                avatar TEXT,
                city TEXT,
                age UNSIGNED INTEGER DEFAULT '',
                likes TEXT DEFAULT '[]',
                achievements TEXT DEFAULT '{}',
                medals TEXT DEFAULT '[]',
                visual TEXT DEFAULT '{}'
            )
        ]])
    end

    local query_all_data = sql.Query('SELECT * FROM gameprofile')

    if query_all_data then
        local tabl = {}

        for _, row in ipairs(query_all_data) do            
            tabl[row.steamid] = row
        end

        GameProfile.profiles = tabl
    end
end)

hook.Add('PlayerInitialSpawn', 'GameProfile', function(pl)
    local steamid = pl:SteamID()
    local result = sql.QueryRow("SELECT * FROM gameprofile WHERE steamid = '" .. steamid .. "' LIMIT 1")

    if !result then
        pl:SendLua('GameProfile.open_create_menu()')
    end

    if pl:IsBot() then
        return
    end

    local gameprofile_table = {}

    for _, game_pl in player.Iterator() do
        gameprofile_table[game_pl:SteamID()] = GameProfile.profiles[game_pl:SteamID()]
    end

    local k = 0

    for gp_steamid, gp_data in pairs(gameprofile_table) do
        timer.Simple(k, function()
            net.Start('GameProfile-SendProfileData')
                net.WriteString(gp_steamid)
                net.WriteTable(gp_data)
            net.Broadcast()
        end)

        k = k + 0.5
    end
end)

function ChangeProfileData(steamid, t, data)
    net.Start('GameProfile-SendProfile')
        net.WriteString(steamid)
        net.WriteString(t)
        net.WriteString(data)
    net.Broadcast()

    GameProfile.profiles[steamid][t] = data
end

net.Receive('GameProfile-Create', function(_, pl)
    local nick = net.ReadString()
    local gender = net.ReadString()
    local status = net.ReadString()
    local avatar = net.ReadString()

    if !nick or !gender or !status or !avatar then
        return
    end

    local steamid = pl:SteamID()

    sql.Query("INSERT INTO gameprofile (steamid, nick, gender, status, avatar, city) VALUES ('" .. steamid .. "', '" .. nick .. "', '" .. gender .. "', '" .. status .. "', '" .. avatar .. "', 'Не указано')")

    local result = sql.QueryRow("SELECT * FROM gameprofile WHERE steamid = '" .. steamid .. "' LIMIT 1")
    GameProfile.profiles[steamid] = result

    net.Start('GameProfile-SendProfileData')
        net.WriteString(steamid)
        net.WriteTable(result)
    net.Broadcast()

    Mantle.notify(pl, Color(47, 151, 80), 'Игровой профиль', 'Чтобы открыть профиль нажми C>Игровой профиль.')
end)

function GameProfile.add_achievement(pl, id, k)
    local steamid = pl:SteamID()
    local result = sql.QueryRow("SELECT * FROM gameprofile WHERE steamid = '" .. steamid .. "' LIMIT 1")

    if result then
        local ach_table = util.JSONToTable(result.achievements)
        local ach_config_table = GameProfile.achievements[id]
        local bool_send_notify = false

        if ach_table[id] then
            if ach_table[id] == -1 then
                return
            end

            ach_table[id] = ach_table[id] + k

            if ach_table[id] == ach_config_table.k then
                bool_send_notify = true
            end
        else
            if ach_config_table.k == -1 then
                ach_table[id] = -1

                bool_send_notify = true
            else
                ach_table[id] = k
            end
        end

        if bool_send_notify then
            net.Start('GameProfile-Notify')
                net.WriteString(id)
            net.Send(pl)
        end

        local ach_table_json = util.TableToJSON(ach_table)

        sql.Query("UPDATE gameprofile SET achievements = '" .. ach_table_json .. "' WHERE steamid = '" .. steamid .. "'")
    end
end

function GameProfile.add_medal(steamid, id)
    local result = sql.QueryRow("SELECT * FROM gameprofile WHERE steamid = '" .. steamid .. "' LIMIT 1")

    if result then
        local medals_table = util.JSONToTable(result.medals)

        if !table.HasValue(medals_table, id) then
            table.insert(medals_table, id)
        end

        local medals_table_json = util.TableToJSON(medals_table)

        sql.Query("UPDATE gameprofile SET medals = '" .. medals_table_json .. "' WHERE steamid = '" .. steamid .. "'")

        net.Start('GameProfile-SendProfile')
            net.WriteString(steamid)
            net.WriteString('medals')
            net.WriteString(medals_table_json)
        net.Broadcast()

        ChangeProfileData(steamid, 'medals', medals_table_json)

        local target = player.GetBySteamID(steamid)

        if target then
            Mantle.notify(target, Color(47, 151, 80), 'Игровой профиль', 'Вы получили медаль: ' .. id)
        end
    end
end

function GameProfile.remove_medal(steamid, id)
    local result = sql.QueryRow("SELECT * FROM gameprofile WHERE steamid = '" .. steamid .. "' LIMIT 1")

    if result then
        local medals_table = util.JSONToTable(result.medals)

        if table.HasValue(medals_table, id) then
            table.RemoveByValue(medals_table, id)
        end

        local medals_table_json = util.TableToJSON(medals_table)

        sql.Query("UPDATE gameprofile SET medals = '" .. medals_table_json .. "' WHERE steamid = '" .. steamid .. "'")

        ChangeProfileData(steamid, 'medals', medals_table_json)

        local target = player.GetBySteamID(steamid)

        if target then
            Mantle.notify(target, Color(47, 151, 80), 'Игровой профиль', 'Убрана медаль: ' .. id)
        end
    end
end
