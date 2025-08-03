local PANEL = {}

function PANEL:Init()
end

function PANEL:SetPlayer(steamid64)
    self.steamid64 = steamid64

    if GameProfile.profiles[steamid64] then
        self:UpdateProfile(GameProfile.profiles[steamid64])
    end
end

function PANEL:UpdateProfile(profile)
    local topPanel = vgui.Create('DPanel', self)
    topPanel:Dock(TOP)
    topPanel:SetTall(116)

    topPanel.Paint = function(_, w, h)
        RNDX.Draw(16, 0, 0, w, h, Mantle.color.panel_alpha[1], SHAPE_IOS)
        
        -- Аватар
        RNDX.Draw(16, 8, 8, 100, 100, Mantle.color.panel_alpha[3], SHAPE_IOS)

        -- Информация
        draw.SimpleText(profile.nickname, 'Fated.24', 116, 16, Mantle.color.text)
        draw.SimpleText(profile.gender .. ', ' .. profile.status, 'Fated.16', 116, 40, Mantle.color.gray)
        local ageWide = draw.SimpleText('Возраст: ', 'Fated.16', 116, 60, Mantle.color.gray)
        draw.SimpleText(profile.age, 'Fated.16', 116 + ageWide, 60, Mantle.color.theme)
        local ageWide = draw.SimpleText('Город: ', 'Fated.16', 116, 80, Mantle.color.gray)
        draw.SimpleText(profile.city, 'Fated.16', 116 + ageWide, 80, Mantle.color.theme)
    end
end

function PANEL:PerformLayout()

end

vgui.Register('GameProfile.Profile', PANEL, 'EditablePanel')
