local color_error = Color(255, 0, 0)

local function CreateMenu()
    local m = vgui.Create('MantleFrame')
    m:SetSize(300, 274)
    m:Center()
    m:MakePopup()
    m:SetTitle('')
    m:SetCenterTitle('Создание профиля')
    m:DisableCloseBtn()

    local entryNickname = vgui.Create('MantleEntry', m)
    entryNickname:Dock(TOP)
    entryNickname:DockMargin(4, 0, 4, 0)
    entryNickname:SetTitle('Ваш никнейм')
    entryNickname:SetPlaceholder('Вася Пупкин')

    local comboboxGender = vgui.Create('MantleComboBox', m)
    comboboxGender:Dock(TOP)
    comboboxGender:DockMargin(4, 8, 4, 0)
    comboboxGender:SetPlaceholder('Выберите пол')
    comboboxGender:AddChoice('Парень')
    comboboxGender:AddChoice('Девушка')
    comboboxGender:AddChoice('Не указано')

    local comboboxStatus = vgui.Create('MantleComboBox', m)
    comboboxStatus:Dock(TOP)
    comboboxStatus:DockMargin(4, 8, 4, 0)
    comboboxStatus:SetPlaceholder('Выберите статус')
    for _, status in ipairs(GameProfile.config.statuses) do
        comboboxStatus:AddChoice(status)
    end

    local sliderAge = vgui.Create('MantleSlideBox', m)
    sliderAge:Dock(TOP)
    sliderAge:DockMargin(0, 4, 0, 0)
    sliderAge:SetRange(7, 30)
    sliderAge:SetText('Укажите возраст')

    local btnCreate = vgui.Create('MantleBtn', m)
    btnCreate:Dock(TOP)
    btnCreate:DockMargin(4, 8, 4, 4)
    btnCreate:SetTall(40)
    btnCreate:SetTxt('Создать профиль')
    btnCreate.DoClick = function()
        local nickname = entryNickname:GetValue()
        local gender = comboboxGender:GetValue()
        local status = comboboxStatus:GetValue()
        local age = sliderAge:GetValue()

        if nickname == '' then
            m:Notify('Вы не указали никнейм профиля!', 2, color_error)
            return
        end

        if !gender then
            m:Notify('Вы не указали пол профиля!')
            return
        end

        if !status then
            m:Notify('Вы не указали статус профиля!')
            return
        end

        net.Start('GameProfile-CreateProfile')
            net.WriteString(nickname)
            net.WriteString(gender)
            net.WriteString(status)
            net.WriteUInt(age, 5)
        net.SendToServer()

        m:Remove()
    end
end

concommand.Add('gameprofile_createmenu', function()
    if GameProfile.profiles[LocalPlayer():SteamID()] then
        chat.AddText(color_error, 'У вас уже есть созданный профиль!')
        return
    end

    CreateMenu()
end)

hook.Add('InitPostEntity', 'GameProfile.CreateMenu', function()
    local lp = LocalPlayer()
    timer.Simple(1, function()
        if !GameProfile.profiles[lp:SteamID()] then
            lp:ConCommand('gameprofile_createmenu')
        end
    end)
end)
