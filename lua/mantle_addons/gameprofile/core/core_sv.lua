util.AddNetworkString('GameProfile-CreateProfile')

net.Receive('GameProfile-CreateProfile', function(len, pl)
    local steamid64 = pl:SteamID64()
    local nickname = net.ReadString()
    local gender = net.ReadString()
    local status = net.ReadString()
    local age = net.ReadUInt(5)

    if nickname == '' or !gender or !status then
        return
    end

    if GameProfile.profiles[steamid64] then
        Mantle.notify(pl, Color(255, 0, 0), 'Система профиля', 'У вас уже есть созданный профиль!')
        return
    end

    sql.QueryTyped('INSERT INTO gameprofile (steamid64, nickname, gender, status, age) VALUES (?, ?, ?, ?, ?)',
        steamid64,
        nickname,
        gender,
        status,
        age)

    local profile = sql.QueryTyped('SELECT * FROM gameprofile WHERE steamid64 = ?', steamid64)[1]

    if profile then
        local tableProfile = {
            steamid64 = profile.steamid64,
            nickname = profile.nickname,
            gender = profile.gender,
            status = profile.status,
            age = profile.age,
            city = profile.city
        }

        GameProfile.profiles[steamid64] = tableProfile

        net.Start('GameProfile-GetProfile')
            net.WriteString(steamid64)
            net.WriteTable(tableProfile)
        net.Broadcast()
    end
end)
