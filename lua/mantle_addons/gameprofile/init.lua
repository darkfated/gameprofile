--[[
    * GameProfile *
    GitHub: https://github.com/darkfated/gameprofile
    Author's discord: darkfated
]]--

GameProfile = {
    config = {
        shop = {}
    },
    ui = {},
    profiles = {},
    inventory = {}
}

Mantle.run_cl('config/main.lua')
Mantle.run_sv('config/main.lua')
Mantle.run_cl('config/shop.lua')
Mantle.run_sv('config/shop.lua')

Mantle.run_cl('core/core_cl.lua')
Mantle.run_sv('core/core_sv.lua')
Mantle.run_sv('core/commands_sv.lua')

Mantle.run_cl('data/data_cl.lua')
Mantle.run_sv('data/data_sv.lua')

Mantle.run_cl('ui/menu.lua')
Mantle.run_cl('ui/create_menu.lua')
Mantle.run_cl('ui/tabs/achievements.lua')
Mantle.run_cl('ui/tabs/inventory.lua')
Mantle.run_cl('ui/tabs/players.lua')
Mantle.run_cl('ui/tabs/profile.lua')
Mantle.run_cl('ui/tabs/shop.lua')

if SERVER then
    resource.AddWorkshop('3557983415')
end
