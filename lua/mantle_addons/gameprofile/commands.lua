concommand.Add('gameprofile_get_player', function(pl, _, args)
    local steamid = args[1]

    if !steamid then
        return
    end

    local result = sql.Query("SELECT * FROM gameprofile WHERE steamid = '" .. steamid .. "'")

    if result then
        net.Start('GameProfile-GetPlayerData')
            net.WriteTable(result[1])
        net.Send(pl)
    end
end)

concommand.Add('gameprofile_settings_nick', function(pl, _, args)
    local steamid = args[1]
    local nick = args[2]

    if !steamid or !nick then
        return
    end

    if pl:SteamID() != steamid and !pl:IsSuperAdmin() then
        return
    end

    local query = string.format("UPDATE gameprofile SET nick = '%s' WHERE steamid = '%s'", nick, steamid)
    sql.Query(query)

    ChangeProfileData(steamid, 'nick', nick)
end)

concommand.Add('gameprofile_settings_gender', function(pl, _, args)
    local steamid = args[1]
    local gender = args[2]

    if !steamid or !gender then
        return
    end

    if pl:SteamID() != steamid and !pl:IsSuperAdmin() then
        return
    end

    local query = string.format("UPDATE gameprofile SET gender = '%s' WHERE steamid = '%s'", gender, steamid)
    sql.Query(query)

    ChangeProfileData(steamid, 'gender', gender)
end)

concommand.Add('gameprofile_settings_status', function(pl, _, args)
    local steamid = args[1]
    local status = args[2]

    if !steamid or !status then
        return
    end

    if pl:SteamID() != steamid and !pl:IsSuperAdmin() then
        return
    end

    local query = string.format("UPDATE gameprofile SET status = '%s' WHERE steamid = '%s'", status, steamid)
    sql.Query(query)

    ChangeProfileData(steamid, 'status', status)
end)

concommand.Add('gameprofile_settings_avatar', function(pl, _, args)
    local steamid = args[1]
    local avatar = args[2]

    if !steamid or !avatar then
        return
    end

    if pl:SteamID() != steamid and !pl:IsSuperAdmin() then
        return
    end

    local query = string.format("UPDATE gameprofile SET avatar = '%s' WHERE steamid = '%s'", avatar, steamid)
    sql.Query(query)

    ChangeProfileData(steamid, 'avatar', avatar)
end)

concommand.Add('gameprofile_settings_city', function(pl, _, args)
    local steamid = args[1]
    local city = args[2]

    if !steamid or !city then
        return
    end

    if pl:SteamID() != steamid and !pl:IsSuperAdmin() then
        return
    end

    local query = string.format("UPDATE gameprofile SET city = '%s' WHERE steamid = '%s'", city, steamid)
    sql.Query(query)

    ChangeProfileData(steamid, 'city', city)
end)

concommand.Add('gameprofile_settings_age', function(pl, _, args)
    local steamid = args[1]
    local age = tonumber(args[2])

    if !steamid or !age then
        return
    end

    if pl:SteamID() != steamid and !pl:IsSuperAdmin() then
        return
    end

    if age < 7 or age > 60 then
        return
    end

    local query = string.format("UPDATE gameprofile SET age = '%s' WHERE steamid = '%s'", age, steamid)
    sql.Query(query)

    ChangeProfileData(steamid, 'age', age)
end)

concommand.Add('gameprofile_settings_banner', function(pl, _, args)
    local steamid = args[1]
    local banner_id = tonumber(args[2])

    if !steamid or !banner_id then
        return
    end

    if pl:SteamID() != steamid and !pl:IsSuperAdmin() then
        return
    end

    if banner_id < 0 or banner_id > 16 then
        return
    end

    local querySelect = string.format("SELECT visual FROM gameprofile WHERE steamid = '%s'", steamid)
    local resultSelect = sql.Query(querySelect)

    if resultSelect then
        local visual_table = util.JSONToTable(resultSelect[1].visual)

        if banner_id == 0 then
            visual_table.banner = nil
        else
            visual_table.banner = banner_id
        end

        local visual_table_json = util.TableToJSON(visual_table)

        local queryUpdate = string.format("UPDATE gameprofile SET visual = '%s' WHERE steamid = '%s'", visual_table_json, steamid)
        sql.Query(queryUpdate)

        ChangeProfileData(steamid, 'visual', visual_table_json)

        if !pl.ach_custom_banner then
            pl.ach_custom_banner = true
        end

        if pl.ach_custom_background then
            GameProfile.add_achievement(pl, 'custom', 1)
        end
    end
end)

concommand.Add('gameprofile_settings_background', function(pl, _, args)
    local steamid = args[1]
    local background_id = tonumber(args[2])

    if !steamid or !background_id then
        return
    end

    if pl:SteamID() != steamid and !pl:IsSuperAdmin() then
        return
    end

    if background_id < 0 or background_id > 11 then
        return
    end

    local querySelect = string.format("SELECT visual FROM gameprofile WHERE steamid = '%s'", steamid)
    local resultSelect = sql.Query(querySelect)

    if resultSelect then
        local visual_table = util.JSONToTable(resultSelect[1].visual)

        if background_id == 0 then
            visual_table.background = nil
        else
            visual_table.background = background_id
        end

        local visual_table_json = util.TableToJSON(visual_table)

        local queryUpdate = string.format("UPDATE gameprofile SET visual = '%s' WHERE steamid = '%s'", visual_table_json, steamid)
        sql.Query(queryUpdate)

        ChangeProfileData(steamid, 'visual', visual_table_json)

        if !pl.ach_custom_background then
            pl.ach_custom_background = true
        end

        if pl.ach_custom_banner then
            GameProfile.add_achievement(pl, 'custom', 1)
        end
    end
end)

concommand.Add('gameprofile_settings_desc', function(pl, _, args)
    local steamid = args[1]
    local desc = args[2]

    if !steamid or !desc then
        return
    end

    if pl:SteamID() != steamid and !pl:IsSuperAdmin() then
        return
    end

    local querySelect = string.format("SELECT visual FROM gameprofile WHERE steamid = '%s'", steamid)
    local resultSelect = sql.Query(querySelect)

    if resultSelect then
        local visual_table = util.JSONToTable(resultSelect[1].visual)
        visual_table.desc = desc

        local visual_table_json = util.TableToJSON(visual_table)

        local queryUpdate = string.format("UPDATE gameprofile SET visual = '%s' WHERE steamid = '%s'", visual_table_json, steamid)
        sql.Query(queryUpdate)

        ChangeProfileData(steamid, 'visual', visual_table_json)
    end
end)

concommand.Add('gameprofile_add_medal', function(pl, _, args)
    local steamid = args[1]
    local medal = args[2]

    if !steamid or !medal then
        return
    end

    if !pl:IsSuperAdmin() then
        return
    end

    GameProfile.add_medal(steamid, medal)
end)

concommand.Add('gameprofile_remove_medal', function(pl, _, args)
    local steamid = args[1]
    local medal = args[2]

    if !steamid or !medal then
        return
    end

    if !pl:IsSuperAdmin() then
        return
    end

    GameProfile.remove_medal(steamid, medal)
end)

concommand.Add('gameprofile_like', function(pl, _, args)
    local steamid = args[1]

    if !steamid then
        return
    end

    local pl_steamid = pl:SteamID()

    if pl_steamid == steamid then
        Mantle.notify(pl, Color(47, 151, 80), 'Игровой профиль', 'Самому себе лайк не поставишь!')
        
        return
    end

    local result = sql.QueryRow("SELECT * FROM gameprofile WHERE steamid = '" .. steamid .. "' LIMIT 1")

    if result then
        local likes_table = util.JSONToTable(result.likes)


        if table.HasValue(likes_table, pl_steamid) then
            table.RemoveByValue(likes_table, pl_steamid)

            Mantle.notify(pl, Color(47, 151, 80), 'Игровой профиль', 'Лайк был убран с игрока.')
        else
            table.insert(likes_table, pl_steamid)

            Mantle.notify(pl, Color(47, 151, 80), 'Игровой профиль', 'Ты лайкнул игрока.')
        end

        local likes_table_json = util.TableToJSON(likes_table)

        sql.Query("UPDATE gameprofile SET likes = '" .. likes_table_json .. "' WHERE steamid = '" .. steamid .. "'")

        ChangeProfileData(steamid, 'likes', likes_table_json)
    end
end)
