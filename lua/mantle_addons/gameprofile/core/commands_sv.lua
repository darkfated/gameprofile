-- КАСТОМИЗАЦИЯ

function GameProfile.ChangeNickname(pl, nickname)
    if !IsValid(pl) then return end
    if nickname == '' then return end

    local steamid = pl:SteamID()
    GameProfile.profiles[steamid].nickname = nickname
    sql.QueryTyped('UPDATE gameprofile SET nickname = ? WHERE steamid = ?', nickname, steamid)
    net.Start('GameProfile-GetProfile')
        net.WriteString(steamid)
        net.WriteTable(GameProfile.profiles[steamid])
    net.Broadcast()
end

concommand.Add('gameprofile_change_nickname', function(_, _, args)
    local target = args[1]
    local nickname = args[2]
    GameProfile.ChangeNickname(target, nickname)
end)

function GameProfile.ChangeGender(pl, gender)
    if !IsValid(pl) then return end
    if gender != 'Парень' or gender != 'Девушка' then return end

    local steamid = pl:SteamID()
    GameProfile.profiles[steamid].gender = gender
    sql.QueryTyped('UPDATE gameprofile SET gender = ? WHERE steamid = ?', gender, steamid)
    net.Start('GameProfile-GetProfile')
        net.WriteString(steamid)
        net.WriteTable(GameProfile.profiles[steamid])
    net.Broadcast()
end

concommand.Add('gameprofile_change_gender', function(_, _, args)
    local target = args[1]
    local gender = args[2]
    GameProfile.ChangeGender(target, gender)
end)

function GameProfile.ChangeStatus(pl, status)
    if !IsValid(pl) then return end
    if status == '' then return end

    local steamid = pl:SteamID()
    GameProfile.profiles[steamid].status = status
    sql.QueryTyped('UPDATE gameprofile SET status = ? WHERE steamid = ?', status, steamid)
    net.Start('GameProfile-GetProfile')
        net.WriteString(steamid)
        net.WriteTable(GameProfile.profiles[steamid])
    net.Broadcast()
end

concommand.Add('gameprofile_change_status', function(pl, _, args)
    local target = args[1]
    local status = args[2]
    GameProfile.ChangeStatus(target, status)
end)

function GameProfile.ChangeAge(pl, age)
    if !IsValid(pl) then return end
    if age < 7 or age > 30 then return end

    local steamid = pl:SteamID()
    GameProfile.profiles[steamid].age = age
    sql.QueryTyped('UPDATE gameprofile SET age = ? WHERE steamid = ?', age, steamid)
    net.Start('GameProfile-GetProfile')
        net.WriteString(steamid)
        net.WriteTable(GameProfile.profiles[steamid])
    net.Broadcast()
end

concommand.Add('gameprofile_change_age', function(_, _, args)
    local target = args[1]
    local age = tonumber(args[2])
    GameProfile.ChangeAge(target, age)
end)

function GameProfile.ChangeCity(pl, city)
    if !IsValid(pl) then return end
    if city == '' then return end

    local steamid = pl:SteamID()
    GameProfile.profiles[steamid].city = city
    sql.QueryTyped('UPDATE gameprofile SET city = ? WHERE steamid = ?', city, steamid)
    net.Start('GameProfile-GetProfile')
        net.WriteString(steamid)
        net.WriteTable(GameProfile.profiles[steamid])
    net.Broadcast()
end

concommand.Add('gameprofile_change_city', function(_, _, args)
    local target = args[1]
    local city = tonumber(args[2])
    GameProfile.ChangeCity(target, city)
end)

-- ИНВЕНТАРЬ

concommand.Add('gameprofile_get_inv', function(pl, _, args)
    local steamid = args[1]
    if !steamid then return end

    local inventory = sql.QueryTyped('SELECT * FROM gameprofile_inv WHERE steamid = ?', pl:SteamID())[1]

    if inventory then
        net.Start('GameProfile-GetInventory')
            net.WriteTable(inventory)
        net.Send(pl)
    end
end)

function GameProfile.InventoryUse(pl, item)
    if !pl or !item then return end
    if !GameProfile.config.shop[item] then return end

    local itemTable = GameProfile.config.shop[item]

    if itemTable.t == 'Аватарки' then
        GameProfile.profiles[pl].avatar = item
        sql.QueryTyped('UPDATE gameprofile SET avatar = ? WHERE steamid = ?', item, pl)
    elseif itemTable.t == 'Банеры' then
        GameProfile.profiles[pl].banner = item
        sql.QueryTyped('UPDATE gameprofile SET banner = ? WHERE steamid = ?', banitemner, pl)
    end

    net.Start('GameProfile-GetProfile')
        net.WriteString(pl)
        net.WriteTable(GameProfile.profiles[pl])
    net.Broadcast()
end

concommand.Add('gameprofile_inv_use', function(_, _, args)
    local target = args[1]
    local item = args[2]
    GameProfile.InventoryUse(target, item)
end)

function GameProfile.InventoryBuy(pl, item)
    if !pl or !item then return end
    if !GameProfile.config.shop[item] then return end

    local itemTable = GameProfile.config.shop[item]
    local inventory = sql.QueryTyped('SELECT * FROM gameprofile_inv WHERE steamid = ?', pl)[1]
    local tablVisual = util.JSONToTable(inventory.visual)
    tablVisual[#tablVisual + 1] = item
    tablVisual = util.TableToJSON(tablVisual)

    sql.QueryTyped('UPDATE gameprofile_inv SET visual = ? WHERE steamid = ?', tablVisual, pl)

    net.Start('GameProfile-GetProfile')
        net.WriteString(pl)
        net.WriteTable(GameProfile.profiles[pl])
    net.Broadcast()
end

concommand.Add('gameprofile_inv_buy', function(_, _, args)
    local target = args[1]
    local item = args[2]
    GameProfile.InventoryBuy(target, item)
end)
