local PANEL = {}

function PANEL:Init()
end

function PANEL:SetPlayer(steamid)
    if !GameProfile.profiles[steamid] then
        return
    end

    self.steamid = steamid
    self:UpdateProfile()
end

local color_shadow = Color(0, 0, 0, 100)

function PANEL:UpdateProfile()
    self:Clear()
    self.profile = GameProfile.profiles[self.steamid]

    self.topPanel = vgui.Create('Panel', self)
    self.topPanel:Dock(TOP)
    self.topPanel:SetTall(116)

    self.topPanel.Paint = function(_, w, h)
        local function drawText(text, font, x, y, color)
            draw.SimpleText(text, font, x + 1, y + 1, Mantle.color.background)
            return draw.SimpleText(text, font,x, y, color)
        end

        RNDX().Rect(0, 0, w, h)
            :Rad(16)
            :Color(Mantle.color.panel_alpha[1])
            :Shape(SHAPE_IOS)
        :Draw()

        if self.profile.banner != 'default' then
            RNDX().Rect(0, 0, w, h)
                :Rad(16)
                :Material(GameProfile.config.shop[self.profile.banner].image)
                :Shape(SHAPE_IOS)
            :Draw()
            RNDX().Rect(0, 0, w, h)
                :Rad(16)
                :Color(color_shadow)
                :Shape(SHAPE_IOS)
            :Draw()
        end

        -- Аватар
        RNDX().Rect(8, 8, 100, 100)
            :Rad(16)
            :Color(Mantle.color.panel_alpha[1])
            :Shape(SHAPE_IOS)
        :Draw()

        if self.profile.avatar != 'default' then
            RNDX().Rect(8, 8, 100, 100)
                :Rad(16)
                :Material(GameProfile.config.shop[self.profile.avatar].image)
                :Shape(SHAPE_IOS)
            :Draw()
        end

        -- Информация
        drawText(self.profile.nickname, 'Fated.24', 116, 16, Mantle.color.text)
        drawText(self.profile.gender .. ', ' .. self.profile.status, 'Fated.16', 116, 40, Mantle.color.text)
        local ageWide = drawText('Возраст: ', 'Fated.16', 116, 60, Mantle.color.text)
        drawText(self.profile.age, 'Fated.16', 116 + ageWide, 60, Mantle.color.theme)
        local ageWide = drawText('Город: ', 'Fated.16', 116, 80, Mantle.color.text)
        drawText(self.profile.city, 'Fated.16', 116 + ageWide, 80, Mantle.color.theme)
    end

    self.topPanel.editBtn = vgui.Create('MantleBtn', self.topPanel)
    self.topPanel.editBtn:SetTxt('')
    self.topPanel.editBtn:SetIcon('icon16/brick_edit.png', 16)
    self.topPanel.editBtn.DoClick = function()
        local dm = Mantle.ui.derma_menu()

        local optionChange = dm:AddOption('Сменить...')
        local changeSubMenu = optionChange:AddSubMenu()
        changeSubMenu:AddOption('Никнейм', function()

        end)
        changeSubMenu:AddOption('Пол', function()

        end)
        changeSubMenu:AddOption('Статус', function()

        end)
        changeSubMenu:AddOption('Возраст', function()

        end)
        changeSubMenu:AddOption('Город', function()

        end)
    end
end

function PANEL:PerformLayout()
    if IsValid(self.topPanel.editBtn) then
        self.topPanel.editBtn:SetSize(24, 24)
        self.topPanel.editBtn:SetPos(self.topPanel:GetWide() - 32, 8)
    end
end

vgui.Register('GameProfile.Profile', PANEL, 'EditablePanel')
