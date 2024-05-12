GameProfile.add_tab(3, 'Игроки онлайн', 'gameprofile/players.png', function(self)
    local sp = vgui.Create('DScrollPanel', self)
    Mantle.ui.sp(sp)
    sp:Dock(FILL)

    for _, pl in player.Iterator() do
        local pan_pl = vgui.Create('DPanel', sp)
        pan_pl:Dock(TOP)
        pan_pl:DockMargin(0, 0, 0, 6)
        pan_pl:SetTall(44)
        pan_pl.nick = pl:Name()
        pan_pl.steamid = pl:SteamID()

        if DarkRP then
            pan_pl.job = pl:getDarkRPVar('job') or 'Неизвестно'
        end

        pan_pl.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Mantle.color.panel_alpha[2])
            draw.SimpleText(self.nick, 'Fated.18', 44, h * 0.5 - 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            if self.job then
                draw.SimpleText(self.job, 'Fated.18', w - 236, h * 0.5 - 1, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end
        end

        pan_pl.avatar = vgui.Create('AvatarImage', pan_pl)
        pan_pl.avatar:SetSize(32, 32)
        pan_pl.avatar:SetPos(6, 6)
        pan_pl.avatar:SetSteamID(pl:SteamID64(), 64)

        pan_pl.btn_profile = vgui.Create('DButton', pan_pl)
        Mantle.ui.btn(pan_pl.btn_profile)
        pan_pl.btn_profile:Dock(RIGHT)
        pan_pl.btn_profile:DockMargin(4, 4, 4, 4)
        pan_pl.btn_profile:SetWide(220)
        pan_pl.btn_profile:SetText('Открыть профиль')
        pan_pl.btn_profile.DoClick = function()
            Mantle.func.sound()

            RunConsoleCommand('gameprofile_get_player', pan_pl.steamid)
    
            timer.Simple(0.2, function()
                GameProfile.open_profile()
            end)
        end
    end
end)
