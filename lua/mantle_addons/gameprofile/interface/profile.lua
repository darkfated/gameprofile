function GameProfile.open_profile(bool_main_off)
    local pl_data = GameProfile.active_player_data

    if table.IsEmpty(GameProfile.active_player_data) then
        return
    end

    local lp = LocalPlayer()

    if !IsValid(GameProfile.menu) then
        GameProfile.open_menu(bool_main_off)
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

    local top_panel = vgui.Create('DPanel', panel_background)
    top_panel:Dock(TOP)
    top_panel:SetTall(120)

    local color_back = Color(0, 0, 0)

    local function draw_text(txt, x, y, col, font)
        draw.SimpleText(txt, font and font or 'Fated.20', x + 1, y + 1, color_back, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(txt, font and font or 'Fated.20', x, y, col and col or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    if visual_data.banner then
        top_panel.banner_mat = Material('gameprofile/banners/' .. visual_data.banner .. '.png')
    end

    surface.SetFont('Fated.22')
    local nick_size = surface.GetTextSize(pl_data.nick)
    local color_likes = Color(198, 64, 64)
    local pl_likes_table = util.JSONToTable(pl_data.likes)
    local pl_likes_count = table.Count(pl_likes_table)

    top_panel.Paint = function(self, w, h)
        if self.banner_mat then
            surface.SetDrawColor(color_white)
            surface.SetMaterial(self.banner_mat)
            surface.DrawTexturedRect(0, 0, w, h)
        else
            draw.RoundedBox(8, 0, 0, w, h, Mantle.color.panel_alpha[2])
        end

        draw.SimpleText(pl_data.nick, 'Fated.22', 120, 30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        draw_text('Лайков: ' .. pl_likes_count, nick_size + 126, 31, color_likes, 'Fated.16')

        draw_text('Пол:', 120, 60)
        draw_text(pl_data.gender, 158, 60, Mantle.color.theme)

        draw_text('Город:', 326, 60)
        draw_text(pl_data.city, 380, 60, Mantle.color.theme)

        draw_text('Статус:', 120, 88)
        draw_text(pl_data.status, 176, 88, Mantle.color.theme)

        draw_text('Возраст:', 326, 88)
        draw_text(pl_data.age != '' and pl_data.age or 'Не указано', 395, 88, Mantle.color.theme)
    end

    top_panel.avatar = vgui.Create('DPanel', top_panel)
    top_panel.avatar:Dock(LEFT)
    top_panel.avatar:DockMargin(12, 12, 12, 12)
    top_panel.avatar:SetWide(96)

    http.DownloadMaterial('https://i.imgur.com/' .. pl_data.avatar .. '.png', pl_data.avatar .. '.png', function(icon)
        if IsValid(top_panel.avatar) then
            top_panel.avatar.mat = icon
        end
    end)

    top_panel.avatar.Paint = function(self, w, h)
        if self.mat then
            surface.SetDrawColor(color_white)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0, 0, w, h)
        end
    end

    local color_shadow = Color(0, 0, 0, 130)

    top_panel.right_panel = vgui.Create('DPanel', top_panel)
    top_panel.right_panel:Dock(RIGHT)
    top_panel.right_panel:DockMargin(0, 10, 10, 10)
    top_panel.right_panel:SetWide(32)
    top_panel.right_panel.btns = 1
    top_panel.right_panel.Paint = function(self, w, h)
        local tall = self.btns * 35 - 5

        draw.RoundedBox(8, 0, h - tall, w, tall, color_shadow)
    end

    local function right_btn_paint(pan, mat, col)
        pan.Paint = function(self, w, h)
            surface.SetDrawColor(col and col or color_white)
            surface.SetMaterial(mat)

            if self.Depressed then
                surface.DrawTexturedRect(1, 1, w - 2, h - 2)
            else
                surface.DrawTexturedRect(0, 0, w, h)
            end
        end
    end

    if pl_data.steamid == lp:SteamID() or lp:IsSuperAdmin() then
        local mat_edit_btn = Material('gameprofile/more.png', 'noclamp')

        top_panel.right_panel.edit_btn = vgui.Create('DButton', top_panel.right_panel)
        top_panel.right_panel.edit_btn:Dock(BOTTOM)
        top_panel.right_panel.edit_btn:SetTall(30)
        top_panel.right_panel.edit_btn:SetText('')
        top_panel.right_panel.edit_btn.DoClick = function(_, w, h)
            Mantle.func.sound()

            local DM = Mantle.ui.derma_menu()
            DM:AddOption('Аватарка', function()
                Mantle.ui.text_box('Изменение аватарки', 'Вставьте ссылку на imgur-картинку', function(s)
                    s = string.Replace(s, '.jpeg', '.jpg')

                    if string.len(s) == 31 then
                        s = string.sub(s, 21, 27)
                    else
                        return
                    end

                    RunConsoleCommand('gameprofile_settings_avatar', pl_data.steamid, s)
                    RunConsoleCommand('gameprofile_get_player', pl_data.steamid)    

                    timer.Simple(0.2, function()
                        GameProfile.open_profile(true)
                    end)
                end)
            end)
            DM:AddOption('Ник', function()
                Mantle.ui.text_box('Изменение ника', 'На какой желаете изменить?', function(s)
                    RunConsoleCommand('gameprofile_settings_nick', pl_data.steamid, s)
                    RunConsoleCommand('gameprofile_get_player', pl_data.steamid)    

                    timer.Simple(0.2, function()
                        GameProfile.open_profile(true)
                    end)
                end)
            end)
            DM:AddSpacer()
            DM:AddOption('Пол', function()
                timer.Simple(0.1, function()
                    local GenderDM = Mantle.ui.derma_menu()

                    local function add_option(name, icon)
                        GenderDM:AddOption(name, function()
                            RunConsoleCommand('gameprofile_settings_gender', pl_data.steamid, name)
                            RunConsoleCommand('gameprofile_get_player', pl_data.steamid)    

                            timer.Simple(0.2, function()
                                GameProfile.open_profile(true)
                            end)
                        end, icon)
                    end

                    add_option('Парень', 'icon16/user.png')
                    add_option('Девушка', 'icon16/user_female.png')
                end)
            end)
            DM:AddOption('Статус', function()
                timer.Simple(0.1, function()
                    local StatusDM = Mantle.ui.derma_menu()

                    local function add_option(name, icon)
                        StatusDM:AddOption(name, function()
                            RunConsoleCommand('gameprofile_settings_status', pl_data.steamid, name)
                            RunConsoleCommand('gameprofile_get_player', pl_data.steamid)    

                            timer.Simple(0.2, function()
                                GameProfile.open_profile(true)
                            end)
                        end, icon)
                    end

                    add_option('В активном поиске', 'icon16/tag_green.png')
                    add_option('Встречаюсь', 'icon16/tag_orange.png')
                    add_option('В браке', 'icon16/tag_pink.png')
                    add_option('Влюблён', 'icon16/tag_purple.png')
                    add_option('Всё сложно', 'icon16/tag_red.png')
                end)
            end)
            DM:AddOption('Город', function()
                Mantle.ui.text_box('Изменение города', 'Какой желаете поставить?', function(s)
                    RunConsoleCommand('gameprofile_settings_city', pl_data.steamid, s)
                    RunConsoleCommand('gameprofile_get_player', pl_data.steamid)    

                    timer.Simple(0.2, function()
                        GameProfile.open_profile(true)
                    end)
                end)
            end)
            DM:AddOption('Возраст', function()
                Mantle.ui.text_box('Изменение возраста', 'Сколько вам лет?', function(s)
                    s = tonumber(s)

                    if !s then
                        return
                    end

                    RunConsoleCommand('gameprofile_settings_age', pl_data.steamid, s)
                    RunConsoleCommand('gameprofile_get_player', pl_data.steamid)    

                    timer.Simple(0.2, function()
                        GameProfile.open_profile(true)
                    end)
                end)
            end)
            DM:AddSpacer()
            DM:AddOption('Баннер', function()
                local menu = vgui.Create('DFrame')
                Mantle.ui.frame(menu, 'GameProfile', 758, 470, true)
                menu:Center()
                menu:MakePopup()
                menu:SetKeyBoardInputEnabled(false)
                menu.center_title = 'Изменить баннер'
                menu.active_banner = visual_data.banner

                menu.sp = vgui.Create('DScrollPanel', menu)
                Mantle.ui.sp(menu.sp)
                menu.sp:Dock(FILL)

                local btn_clear = vgui.Create('DButton', menu.sp)
                btn_clear:Dock(TOP)
                btn_clear:DockMargin(0, 0, 0, 4)
                btn_clear:SetTall(120)
                btn_clear:SetText('')
                btn_clear.Paint = function(_, w, h)
                    surface.SetDrawColor(color_white)
                    surface.DrawOutlinedRect(0, 0, w, h)

                    draw.SimpleText('Пустой баннер', 'Fated.16', w * 0.5, h * 0.5 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                local function apply_banner(k)
                    Mantle.func.sound()

                    RunConsoleCommand('gameprofile_settings_banner', pl_data.steamid, k)
                    RunConsoleCommand('gameprofile_get_player', pl_data.steamid)

                    timer.Simple(0.2, function()
                        GameProfile.open_profile(true)
                    end)

                    menu.active_banner = k
                end

                btn_clear.DoClick = function()
                    apply_banner(0)
                end

                for k = 1, 16 do
                    local btn_banner = vgui.Create('DButton', menu.sp)
                    btn_banner:Dock(TOP)
                    btn_banner:DockMargin(0, 0, 0, 4)
                    btn_banner:SetTall(120)
                    btn_banner:SetText('')

                    local mat_banner = Material('gameprofile/banners/' .. k .. '.png')

                    btn_banner.Paint = function(_, w, h)
                        local indent = menu.active_banner == k and 2 or 0

                        surface.SetDrawColor(color_white)
                        surface.SetMaterial(mat_banner)
                        surface.DrawTexturedRect(indent, indent, w - indent * 2, h - indent * 2)
                    end
                    btn_banner.DoClick = function()
                        apply_banner(k)
                    end
                end
            end)
            DM:AddOption('Фон', function()
                local menu = vgui.Create('DFrame')
                Mantle.ui.frame(menu, 'GameProfile', 381, 400, true)
                menu:Center()
                menu:MakePopup()
                menu:SetKeyBoardInputEnabled(false)
                menu.center_title = 'Изменить баннер'

                menu.sp = vgui.Create('DScrollPanel', menu)
                Mantle.ui.sp(menu.sp)
                menu.sp:Dock(FILL)

                local btn_clear = vgui.Create('DButton', menu.sp)
                btn_clear:Dock(TOP)
                btn_clear:DockMargin(0, 0, 0, 4)
                btn_clear:SetTall(120)
                btn_clear:SetText('')
                btn_clear.Paint = function(_, w, h)
                    surface.SetDrawColor(color_white)
                    surface.DrawOutlinedRect(0, 0, w, h)

                    draw.SimpleText('Пустой фон', 'Fated.16', w * 0.5, h * 0.5 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                local function apply_background(k)
                    RunConsoleCommand('gameprofile_settings_background', pl_data.steamid, k)
                    RunConsoleCommand('gameprofile_get_player', pl_data.steamid)

                    timer.Simple(0.2, function()
                        GameProfile.open_profile(true)
                    end)
                end

                btn_clear.DoClick = function()
                    apply_background(0)
                end

                for k = 1, 11 do
                    local btn_background = vgui.Create('DButton', menu.sp)
                    btn_background:Dock(TOP)
                    btn_background:DockMargin(0, 0, 0, 4)
                    btn_background:SetTall(252)
                    btn_background:SetText('')

                    local mat_background = Material('gameprofile/background/' .. k .. '.png')

                    btn_background.Paint = function(_, w, h)
                        surface.SetDrawColor(color_white)
                        surface.SetMaterial(mat_background)
                        surface.DrawTexturedRect(0, 0, w, h)
                    end
                    btn_background.DoClick = function()
                        apply_background(k)
                    end
                end
            end)
            DM:AddOption('Описание', function()
                Mantle.ui.text_box('Изменить описание', 'Чтобы сделать перенос - напишите \\n', function(s)
                    RunConsoleCommand('gameprofile_settings_desc', pl_data.steamid, s)
                    RunConsoleCommand('gameprofile_get_player', pl_data.steamid)

                    timer.Simple(0.2, function()
                        GameProfile.open_profile(true)
                    end)
                end)
            end)
        end

        right_btn_paint(top_panel.right_panel.edit_btn, mat_edit_btn)

        top_panel.right_panel.btns = top_panel.right_panel.btns + 1
    end

    if lp:IsSuperAdmin() then
        local mat_medals_btn = Material('gameprofile/medal.png', 'noclamp')

        top_panel.right_panel.medals_btn = vgui.Create('DButton', top_panel.right_panel)
        top_panel.right_panel.medals_btn:Dock(BOTTOM)
        top_panel.right_panel.medals_btn:DockMargin(0, 0, 0, 5)
        top_panel.right_panel.medals_btn:SetTall(30)
        top_panel.right_panel.medals_btn:SetText('')
        top_panel.right_panel.medals_btn.DoClick = function(_, w, h)
            Mantle.func.sound()

            local menu = vgui.Create('DFrame')
            Mantle.ui.frame(menu, '', 300, 400, true)
            menu:Center()
            menu:MakePopup()
            menu:SetKeyBoardInputEnabled(false)
            menu.center_title = 'Добавить медаль'

            menu.sp = vgui.Create('DScrollPanel', menu)
            Mantle.ui.sp(menu.sp)
            menu.sp:Dock(FILL)

            for id, medal_table in pairs(GameProfile.medals) do
                local btn_medal = vgui.Create('DButton', menu.sp)
                Mantle.ui.btn(btn_medal, Material('gameprofile/medals/' .. medal_table.icon .. '.png', 'smooth'), 24)
                btn_medal:Dock(TOP)
                btn_medal:DockMargin(0, 0, 0, 6)
                btn_medal:SetText(medal_table.name)
                btn_medal.DoClick = function()
                    Mantle.func.sound()

                    RunConsoleCommand('gameprofile_add_medal', pl_data.steamid, id)
                    RunConsoleCommand('gameprofile_get_player', pl_data.steamid)    

                    timer.Simple(0.2, function()
                        GameProfile.open_profile(true)
                    end)

                    menu:Remove()
                end
            end
        end

        right_btn_paint(top_panel.right_panel.medals_btn, mat_medals_btn)

        top_panel.right_panel.btns = top_panel.right_panel.btns + 1
    end

    local mat_like_btn = Material('gameprofile/like.png', 'noclamp')
    
    top_panel.right_panel.like_btn = vgui.Create('DButton', top_panel.right_panel)
    top_panel.right_panel.like_btn:Dock(BOTTOM)

    if top_panel.right_panel.btns != 1 then
        top_panel.right_panel.like_btn:DockMargin(0, 0, 0, 5)
    end

    top_panel.right_panel.like_btn:SetTall(30)
    top_panel.right_panel.like_btn:SetText('')
    top_panel.right_panel.like_btn.DoClick = function()
        Mantle.func.sound()

        RunConsoleCommand('gameprofile_like', pl_data.steamid)
        RunConsoleCommand('gameprofile_get_player', pl_data.steamid)    

        timer.Simple(0.2, function()
            GameProfile.open_profile(true)
        end)
    end

    local have_lp_like = false
    
    if table.HasValue(pl_likes_table, lp:SteamID()) then
        top_panel.right_panel.like_btn:SetTooltip('Твой лайк поставлен.')

        have_lp_like = true
    end

    right_btn_paint(top_panel.right_panel.like_btn, mat_like_btn, have_lp_like and Color(104, 104, 104) or nil)

    if visual_data.desc and visual_data.desc != '' then
        local panel_right = vgui.Create('DPanel', panel_background)
        panel_right:Dock(RIGHT)
        panel_right:DockMargin(0, 12, 0, 0)
        panel_right:SetWide(228)
        panel_right.Paint = nil

        panel_right.panel_info = vgui.Create('DPanel', panel_right)
        panel_right.panel_info:Dock(TOP)
        panel_right.panel_info:SetTall(260)
        panel_right.panel_info.Paint = function(_, w, h)
            surface.SetDrawColor(Mantle.color.panel_alpha[2])
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end

        visual_data.desc = string.gsub(visual_data.desc, '\\n', '\n')

        panel_right.panel_info.text = vgui.Create('RichText', panel_right.panel_info)
        panel_right.panel_info.text:Dock(FILL)
        panel_right.panel_info.text:DockMargin(6, 8, 6, 8)
        panel_right.panel_info.text.PerformLayout = function(self)
            self:SetFontInternal('Fated.16')
        end
        panel_right.panel_info.text:InsertColorChange(255, 255, 255, 255)
        panel_right.panel_info.text:AppendText(visual_data.desc)
    end

    local main_sp = vgui.Create('DScrollPanel', panel_background)
    main_sp:Dock(FILL)
    main_sp:DockMargin(10, 8, 10, 0)

    local panel_achievements_title = vgui.Create('DPanel', main_sp)
    panel_achievements_title:Dock(TOP)
    panel_achievements_title:SetTall(30)
    panel_achievements_title.Paint = function(_, w, h)
        draw.SimpleText('Достижений из ' .. table.Count(GameProfile.achievements) .. ' получено:', 'Fated.18', 8, h * 0.5 - 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local panel_achievements = vgui.Create('DPanel', main_sp)
    panel_achievements:Dock(TOP)
    panel_achievements:SetTall(90)
    panel_achievements.Paint = function(_, w, h)
        surface.SetDrawColor(Mantle.color.panel_alpha[2])
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    end

    panel_achievements.sp = vgui.Create('DHorizontalScroller', panel_achievements)
    panel_achievements.sp:Dock(FILL)
    panel_achievements.sp:DockMargin(8, 8, 8, 8)
    panel_achievements.sp:SetOverlap(-8)

    local btn_ach_all = vgui.Create('DButton', panel_achievements.sp)
    Mantle.ui.btn(btn_ach_all)
    btn_ach_all:SetWide(74)
    btn_ach_all:SetText('Все')
    btn_ach_all.DoClick = function()
        GameProfile.open_ach()
    end

    panel_achievements.sp:AddPanel(btn_ach_all)

    for id, k in pairs(util.JSONToTable(pl_data.achievements)) do
        local ach_table = GameProfile.achievements[id]

        if !ach_table then
            continue
        end

        if k > 0 and k < ach_table.k then
            continue
        end

        local panel_ach = vgui.Create('DPanel', panel_achievements.sp)
        panel_ach:SetWide(74)
        panel_ach:SetTooltip(ach_table.name)

        local mat_ach = Material('gameprofile/ach/' .. ach_table.icon .. '.png')

        panel_ach.Paint = function(_, w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(mat_ach)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        panel_achievements.sp:AddPanel(panel_ach)
    end

    local pl_medals_table = util.JSONToTable(pl_data.medals)

    local panel_medals_title = vgui.Create('DPanel', main_sp)
    panel_medals_title:Dock(TOP)
    panel_medals_title:SetTall(30)
    panel_medals_title.Paint = function(_, w, h)
        draw.SimpleText('Медали:', 'Fated.18', 8, h * 0.5 - 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local panel_medals = vgui.Create('DPanel', main_sp)
    panel_medals:Dock(TOP)
    panel_medals:SetTall(90)
    panel_medals.Paint = function(_, w, h)
        surface.SetDrawColor(Mantle.color.panel_alpha[2])
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        if #pl_medals_table == 0 then
            draw.SimpleText('Пусто', 'Fated.18', w * 0.5, h * 0.5 - 1, Mantle.color.gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    panel_medals.sp = vgui.Create('DHorizontalScroller', panel_medals)
    panel_medals.sp:Dock(FILL)
    panel_medals.sp:DockMargin(8, 8, 8, 8)
    panel_medals.sp:SetOverlap(-8)

    for _, id in pairs(pl_medals_table) do
        local medal_table = GameProfile.medals[id]

        if !medal_table then
            continue
        end

        local panel_medal = vgui.Create('DPanel', panel_medals.sp.sp)
        panel_medal:SetWide(74)
        panel_medal:SetTooltip(medal_table.name)

        local mat_medal = Material('gameprofile/medals/' .. medal_table.icon .. '.png')

        panel_medal.Paint = function(_, w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(mat_medal)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        if lp:IsSuperAdmin() then
            panel_medal.btn = vgui.Create('DButton', panel_medal)
            panel_medal.btn:Dock(FILL)
            panel_medal.btn:SetText('')
            panel_medal.btn.Paint = nil
            panel_medal.btn.DoRightClick = function()
                local DM = Mantle.ui.derma_menu()
                DM:AddOption('Удалить медаль', function()
                    Mantle.func.sound()

                    RunConsoleCommand('gameprofile_remove_medal', pl_data.steamid, id)
                    RunConsoleCommand('gameprofile_get_player', pl_data.steamid)    

                    timer.Simple(0.2, function()
                        GameProfile.open_profile(true)
                    end)
                end, 'icon16/delete.png')
            end
        end

        panel_medals.sp:AddPanel(panel_medal)
    end

    if FatedGang then
        for _, gang_table in pairs(FatedGang.gangs) do
            local players_table = util.JSONToTable(gang_table.players)

            if players_table[pl_data.steamid] then
                local info_table = util.JSONToTable(gang_table.info)

                local panel_gang = vgui.Create('DPanel', main_sp)
                panel_gang:Dock(TOP)
                panel_gang:DockMargin(0, 8, 0, 0)
                panel_gang:SetTall(46)
                panel_gang.Paint = function(_, w, h)
                    draw.RoundedBox(8, 0, 4, w, h - 8, Mantle.color.panel_alpha[2])
            
                    draw.SimpleText('Игрок находиться в банде: ', 'Fated.18', 10, h * 0.5 - 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(info_table.name, 'Fated.18', 201, h * 0.5 - 1, info_table.col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
                
                if lp:GangId() then
                    panel_gang.btn_open = vgui.Create('DButton', panel_gang)
                    Mantle.ui.btn(panel_gang.btn_open)
                    panel_gang.btn_open:Dock(RIGHT)
                    panel_gang.btn_open:SetWide(100)
                    panel_gang.btn_open:SetText('Посмотреть')
                    panel_gang.btn_open.DoClick = function()
                        GameProfile.menu:Remove()

                        FatedGang.open_menu(gang_table.id)
                    end
                end

                break
            end
        end
    end
end
