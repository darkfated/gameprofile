util.AddNetworkString('GameProfile-CreateProfile')

net.Receive('GameProfile-CreateProfile', function(len, pl)
    local steamid = pl:SteamID()
    local nickname = net.ReadString()
    local gender = net.ReadString()
    local status = net.ReadString()
    local age = net.ReadUInt(5)

    if nickname == '' or !gender or !status then
        return
    end

    if GameProfile.profiles[steamid] then
        Mantle.notify(pl, Color(255, 0, 0), 'Система профиля', 'У вас уже есть созданный профиль!')
        return
    end

    sql.QueryTyped('INSERT INTO gameprofile (steamid, nickname, gender, status, age) VALUES (?, ?, ?, ?, ?)',
        steamid,
        nickname,
        gender,
        status,
        age)

    sql.QueryTyped('INSERT INTO gameprofile_inv (steamid) VALUES (?)', steamid)

    local profile = sql.QueryTyped('SELECT * FROM gameprofile WHERE steamid = ?', steamid)[1]

    if profile then
        local tableProfile = {
            steamid = profile.steamid,
            nickname = profile.nickname,
            gender = profile.gender,
            status = profile.status,
            age = profile.age,
            city = profile.city,
            avatar = profile.avatar,
            banner = profile.banner
        }
        GameProfile.profiles[steamid] = tableProfile

        net.Start('GameProfile-GetProfile')
            net.WriteString(steamid)
            net.WriteTable(tableProfile)
        net.Broadcast()
    end
end)
