function GameProfile.open_menu(bool_main_off)
    if IsValid(GameProfile.menu) then
        GameProfile.menu:Remove()
    end

    GameProfile.menu = vgui.Create('DFrame')
    Mantle.ui.frame(GameProfile.menu, 'GameProfile', 960, 540, true)
    GameProfile.menu:Center()
    GameProfile.menu:MakePopup()
    GameProfile.menu:SetKeyBoardInputEnabled(false)
    GameProfile.menu.center_title = 'Главное меню'
    GameProfile.menu.background_alpha = false

    GameProfile.menu.main_panel = vgui.Create('DPanel', GameProfile.menu)
    GameProfile.menu.main_panel:Dock(FILL)
    GameProfile.menu.main_panel.Paint = nil

    local tabs_sp = vgui.Create('DScrollPanel', GameProfile.menu)
    tabs_sp:Dock(LEFT)
    tabs_sp:DockMargin(0, 0, 6, 0)
    tabs_sp:SetWide(180)

    local color_btn_hovered = Color(255, 255, 255, 10)

    for i, tab in pairs(GameProfile.menu_tabs) do
        local btn_tab = vgui.Create('DButton', tabs_sp)
        btn_tab:Dock(TOP)
        btn_tab:DockMargin(0, 0, 0, 6)
        btn_tab:SetTall(36)
        btn_tab:SetText('')

        local mat_tab = Material(tab.icon)

        btn_tab.Paint = function(self, w, h)
            if self:IsHovered() then
                draw.RoundedBox(8, 0, 0, w, h, color_btn_hovered)
            end

            surface.SetDrawColor(tabs_sp.active_tab == i and Mantle.color.theme or color_white)
            surface.SetMaterial(mat_tab)
            surface.DrawTexturedRect(4, 4, 28, 28)

            draw.SimpleText(tab.name, 'Fated.20', 42, h * 0.5 - 1, tabs_sp.active_tab == i and Mantle.color.theme or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        btn_tab.DoClick = function()
            Mantle.func.sound()
            
            GameProfile.menu.main_panel:Clear()
            
            tab.func(GameProfile.menu.main_panel)

            tabs_sp.active_tab = i
        end
    end

    if !bool_main_off then
        tabs_sp.active_tab = 1

        GameProfile.menu_tabs[1].func(GameProfile.menu.main_panel)
    end
end

concommand.Add('gameprofile_menu', function()
    GameProfile.open_menu()
end)
