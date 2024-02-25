function GameProfile.create_achievement(id, data)
    GameProfile.achievements[id] = data
end

function GameProfile.create_medal(id, data)
    GameProfile.medals[id] = data
end
