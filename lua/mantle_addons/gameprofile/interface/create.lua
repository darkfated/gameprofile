function GameProfile.open_create_menu()
    if IsValid(GameProfile.create_menu) then
        GameProfile.create_menu:Remove()
    end

    local pl = LocalPlayer()

    GameProfile.create_menu = vgui.Create('DFrame')
    Mantle.ui.frame(GameProfile.create_menu, 'GameProfile', 380, 292)
    GameProfile.create_menu:Center()
    GameProfile.create_menu:MakePopup()
    GameProfile.create_menu.center_title = 'Создание профиля'
    GameProfile.create_menu.settings = {
        nick = '',
        gender = '',
        status = '',
        avatar = ''
    }

    local entry_nick = Mantle.ui.desc_entry(GameProfile.create_menu, 'Ник', 'Например: Master89')
    entry_nick.OnLoseFocus = function(self)
        GameProfile.create_menu.settings.nick = self:GetValue()
    end
    
    local combobox_gender = vgui.Create('DComboBox', GameProfile.create_menu)
    combobox_gender:Dock(TOP)
    combobox_gender:DockMargin(4, 8, 4, 0)
    combobox_gender:SetTall(26)
    combobox_gender:SetFont('Fated.16')
    combobox_gender:SetValue('Выберите пол')
    combobox_gender:AddChoice('Парень', nil, nil, 'icon16/user.png')
    combobox_gender:AddChoice('Девушка', nil, nil, 'icon16/user_female.png')
    combobox_gender.OnSelect = function(_, _, value)
        GameProfile.create_menu.settings.gender = value
    end

    local combobox_status = vgui.Create('DComboBox', GameProfile.create_menu)
    combobox_status:Dock(TOP)
    combobox_status:DockMargin(4, 8, 4, 0)
    combobox_status:SetTall(26)
    combobox_status:SetFont('Fated.16')
    combobox_status:SetValue('Выберите статус', nil, nil, 'icon16/tag_green.png')
    combobox_status:AddChoice('В активном поиске', nil, nil, 'icon16/tag_orange.png')
    combobox_status:AddChoice('Встречаюсь', nil, nil, 'icon16/tag_pink.png')
    combobox_status:AddChoice('В браке', nil, nil, 'icon16/tag_purple.png')
    combobox_status:AddChoice('Влюблён', nil, nil, 'icon16/tag_red.png')
    combobox_status:AddChoice('Всё сложно', nil, nil, 'icon16/tag_yellow.png')
    combobox_status.OnSelect = function(_, _, value)
        GameProfile.create_menu.settings.status = value
    end

    local btn_avatar = vgui.Create('DButton', GameProfile.create_menu)
    btn_avatar:Dock(TOP)
    btn_avatar:DockMargin(4, 8, 4, 0)
    btn_avatar:SetTall(80)
    btn_avatar:SetText('')
    btn_avatar.Paint = function(self, w, h)
        if self.mat then
            surface.SetDrawColor(color_white)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(w * 0.5 - h * 0.5, 0, h, h)
        else
            draw.RoundedBox(8, w * 0.5 - h * 0.5, 0, h, h, Mantle.color.panel[1])
            draw.SimpleText('Аватарка', 'Fated.18', w * 0.5, h * 0.5 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local function accept_img(img)
        GameProfile.create_menu.settings.avatar = img
            
        http.DownloadMaterial('https://i.imgur.com/' .. img .. '.png', img .. '.png', function(icon)
            if IsValid(btn_avatar) then
                btn_avatar.mat = icon
            end
        end)
    end

    btn_avatar.DoClick = function()
        Mantle.ui.text_box('Аватарка', 'Вставьте ссылку на imgur-картинку', function(s)
            s = string.Replace(s, '.jpeg', '.jpg')
            
            if string.len(s) == 31 then
                s = string.sub(s, 21, 27)
            else
                return
            end

            accept_img(s)
        end)
    end

    local random_img = table.Random({'BY5ExFg', 'P0c0dcJ', 'cuABvez'})

    btn_avatar.btn_standart = vgui.Create('DButton', btn_avatar)
    Mantle.ui.btn(btn_avatar.btn_standart)
    btn_avatar.btn_standart:Dock(RIGHT)
    btn_avatar.btn_standart:SetWide(80)
    btn_avatar.btn_standart:SetText('Стандарт')
    btn_avatar.btn_standart.DoClick = function()
        accept_img(random_img)
    end

    local btn_create = vgui.Create('DButton', GameProfile.create_menu)
    Mantle.ui.btn(btn_create)
    btn_create:Dock(TOP)
    btn_create:DockMargin(4, 8, 4, 0)
    btn_create:SetTall(40)
    btn_create:SetText('Создать свой профиль')
    btn_create.DoClick = function()
        if GameProfile.create_menu.settings.nick == '' then
            return
        end

        if GameProfile.create_menu.settings.gender == '' then
            return
        end

        if GameProfile.create_menu.settings.status == '' then
            return
        end

        if GameProfile.create_menu.settings.avatar == '' then
            accept_img(random_img)
        end

        net.Start('GameProfile-Create')
            net.WriteString(GameProfile.create_menu.settings.nick)
            net.WriteString(GameProfile.create_menu.settings.gender)
            net.WriteString(GameProfile.create_menu.settings.status)
            net.WriteString(GameProfile.create_menu.settings.avatar)
        net.SendToServer()

        GameProfile.create_menu:Remove()
    end
end
