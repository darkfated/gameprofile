local PANEL = {}

function PANEL:Init()
    self.sp = vgui.Create('MantleScrollPanel', self)
    self.sp:Dock(FILL)
end

function PANEL:SetPlayer(steamid)
    self.steamid = steamid
    RunConsoleCommand('gameprofile_get_inv', self.steamid)

    timer.Simple(0.1, function()
        self:UpdateAchievements()
    end)
end

function PANEL:UpdateAchievements()
    if !GameProfile.active_inventory then return end

    self.sp:Clear()
end

function PANEL:Paint(w, h)

end

function PANEL:PerformLayout(w, h)

end

vgui.Register('GameProfile.Achievements', PANEL, 'Panel')
