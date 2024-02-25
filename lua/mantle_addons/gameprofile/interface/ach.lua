local convar_gameprofile_ach_active = CreateClientConVar('gameprofile_ach_active', 0, true, false)

function GameProfile.open_ach()
    local pl_data = GameProfile.active_player_data

    if !IsValid(GameProfile.menu) then
        RunConsoleCommand('gameprofile_menu')
    end

    GameProfile.menu.main_panel:Clear()

    local visual_data = util.JSONToTable(pl_data.visual)
    
    local panel_background = vgui.Create('DPanel', GameProfile.menu.main_panel)
    panel_background:Dock(FILL)
    panel_background:DockPadding(6, 6, 6, 6)

    if visual_data.background then
        panel_background.background_mat = Material('gameprofile/background/' .. visual_data.background .. '.png')
    end

    panel_background.Paint = function(self, w, h)
        if self.background_mat then
            surface.SetDrawColor(color_white)
            surface.SetMaterial(self.background_mat)
            surface.DrawTexturedRect(0, 0, w, h)
        end
    end

    local pl_data_ach = util.JSONToTable(pl_data.achievements)

    local function BuildList()
        panel_background:Clear()

        local tabs = Mantle.ui.panel_tabs(panel_background)
        tabs:Dock(FILL)
        tabs.categories = {}

        for k, ach_data in pairs(GameProfile.achievements) do
            if !pl_data_ach[k] and convar_gameprofile_ach_active:GetBool() then
                continue
            end 

            if !tabs.categories[ach_data.category] then
                tabs.categories[ach_data.category] = vgui.Create('DScrollPanel')
                Mantle.ui.sp(tabs.categories[ach_data.category])

                tabs:AddTab(ach_data.category, tabs.categories[ach_data.category])
            end

            local panel_ach = vgui.Create('DPanel', tabs.categories[ach_data.category])
            panel_ach:Dock(TOP)
            panel_ach:DockMargin(0, 0, 0, 8)
            panel_ach:SetTall(74)
    
            if pl_data_ach[k] then
                panel_ach.ach = pl_data_ach[k]
            end
    
            local mat_ach = Material('gameprofile/ach/' .. ach_data.icon .. '.png')
    
            panel_ach.Paint = function(self, w, h)
                draw.RoundedBoxEx(8, 0, 0, w, h, Mantle.color.panel_alpha[2], false, true, false, true)
    
                surface.SetDrawColor(color_white)
                surface.SetMaterial(mat_ach)
                surface.DrawTexturedRect(0, 0, h, h)
    
                draw.SimpleText(ach_data.name, 'Fated.22', 88, 24, color_white, TEXT_ALIGN_TOP, TEXT_ALIGN_CENTER)
                draw.SimpleText(ach_data.desc, 'Fated.18', 88, h - 24, Mantle.color.gray, TEXT_ALIGN_BOTTOM, TEXT_ALIGN_CENTER)
    
                if GameProfile.achievements[k].k != -1 then
                    draw.SimpleText((self.ach and self.ach or '0') .. ' / ' .. ach_data.k, 'Fated.20', w - 18, h * 0.5 - 1, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                end
    
                if !self.ach or self.ach < ach_data.k then
                    draw.RoundedBoxEx(8, 0, 0, w, h, Mantle.color.background_alpha, false, true, false, true)
                end
            end
        end

        tabs:ActiveTab('Геймплейные')
    end

    GameProfile.menu.main_panel.active_btn_back, GameProfile.menu.main_panel.active_btn = Mantle.ui.checkbox(GameProfile.menu.main_panel, 'Скрыть неактивные достижения')
    GameProfile.menu.main_panel.active_btn_back:DockMargin(0, 0, 0, 6)
    GameProfile.menu.main_panel.active_btn.enabled = convar_gameprofile_ach_active:GetBool()
    GameProfile.menu.main_panel.active_btn.DoClick = function(self)
        self.enabled = !self.enabled

        RunConsoleCommand('gameprofile_ach_active', self.enabled and 1 or 0)

        timer.Simple(0.1, function()
            BuildList()
        end)
    end

    BuildList()
end
