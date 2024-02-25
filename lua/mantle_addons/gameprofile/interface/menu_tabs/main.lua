GameProfile.add_tab(1, 'Мой профиль', 'gameprofile/main.png', function(self)
    RunConsoleCommand('gameprofile_get_player', LocalPlayer():SteamID())
    
    timer.Simple(0.2, function()
        GameProfile.open_profile()
    end)
end)
