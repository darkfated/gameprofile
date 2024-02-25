GameProfile.add_tab(2, 'Мои достижения', 'gameprofile/achievements.png', function(self)
    RunConsoleCommand('gameprofile_get_player', LocalPlayer():SteamID())
    
    timer.Simple(0.2, function()
        GameProfile.open_ach()
    end)
end)
