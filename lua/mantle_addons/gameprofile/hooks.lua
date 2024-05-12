hook.Add('PlayerDeath', 'GameProfile.Ach', function(pl, _, attacker)
    GameProfile.add_achievement(pl, 'deaths', 1)

    if attacker:IsPlayer() then
        if pl:SteamID() == 'STEAM_0:1:231677511' then
            GameProfile.add_achievement(attacker, 'matrix_error', 1)
        end

        if DarkRP then
            if attacker:getJobTable().name == 'Пухляш' then
                GameProfile.add_achievement(attacker, 'fat_good', 1)
            end

            if pl:getJobTable().name == 'Забанен' then
                GameProfile.add_achievement(attacker, 'kill_banned', 1)
            end
        end
    end
end)

hook.Add('playerCanChangeTeam', 'GameProfile.Ach', function(pl)
    GameProfile.add_achievement(pl, 'change_job', 1)
end)

hook.Add('playerGaveMoney', 'GameProfile.Ach', function(pl, _, amount)
    if amount >= 5000000 then
        GameProfile.add_achievement(pl, 'give_5kk', 1)
    end
end)

hook.Add('PlayerSay', 'GameProfile.Ach', function(pl, text)
    if string.lower(text) == 'schoolrp' then
        GameProfile.add_achievement(pl, 'secret_word', 1)
    end
end)

hook.Add('KeyPress', 'GameProfile.Ach', function(pl, key)
    if pl:IsValid() and key == IN_JUMP and CurTime() - (pl.jump_time and pl.jump_time or 0) > 0.5 then
        GameProfile.add_achievement(pl, 'jump', 1)

        pl.jump_time = CurTime()
    end
end)

hook.Add('onDarkRPWeaponDropped', 'GameProfile.Ach', function(pl)
    GameProfile.add_achievement(pl, 'small_gift', 1)
end)
