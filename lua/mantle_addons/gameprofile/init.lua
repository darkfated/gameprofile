--[[
    * GameProfile *
    GitHub: https://github.com/darkfated/gameprofile
    Author's discord: darkfated
]]--

local function run_scripts() 
    Mantle.run_cl('client.lua')
    Mantle.run_sv('server.lua')
    Mantle.run_cl('shared.lua')
    Mantle.run_sv('shared.lua')

    Mantle.run_cl('config/achievements.lua')
    Mantle.run_sv('config/achievements.lua')
    Mantle.run_cl('config/medals.lua')
    Mantle.run_sv('config/medals.lua')

    Mantle.run_cl('interface/create.lua')
    Mantle.run_cl('interface/menu.lua')
    Mantle.run_cl('interface/target.lua')
    Mantle.run_cl('interface/profile.lua')
    Mantle.run_cl('interface/ach.lua')
    Mantle.run_cl('interface/notify.lua')
    Mantle.run_cl('interface/menu_tabs/main.lua')
    Mantle.run_cl('interface/menu_tabs/achievements.lua')
    Mantle.run_cl('interface/menu_tabs/players_online.lua')

    Mantle.run_sv('commands.lua')
    Mantle.run_sv('hooks.lua')
end

local function init()
    if SERVER then
        resource.AddFile('3152678466')
    end

    GameProfile = GameProfile or {
        menu_tabs = {},
        achievements = {},
        medals = {},
        visual = {},
        profiles = {}
    }

    run_scripts()
end

init()
