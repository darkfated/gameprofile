local scrw, scrh = ScrW(), ScrH()

local function create_ach_notify(id)
    local ach_table = GameProfile.achievements[id]
    
    if IsValid(achievementPanel) then
        notify_achievement:Remove()
    end

    surface.SetFont('Fated.15')
    Mantle.func.sound('gameprofile/notify.mp3')

    local notify_achievement = vgui.Create('DPanel')
    notify_achievement:SetSize(50 + math.max(surface.GetTextSize(ach_table.name), 131) + 48, 50)
    notify_achievement:SetPos(scrw, scrh * 0.5 - notify_achievement:GetTall() * 0.5 + 65)

    local mat_ach = Material('gameprofile/ach/' .. ach_table.icon .. '.png', 'smooth')

    notify_achievement.Paint = function(self, w, h)
        draw.RoundedBoxEx(16, 0, 0, w, h, Mantle.color.background_alpha, false, true, false, true)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(mat_ach)
        surface.DrawTexturedRect(0, 0, h, h)

        draw.SimpleText('Достижение получено', 'Fated.18', w * 0.5 + 25, 7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(ach_table.name, 'Fated.18', w * 0.5 + 25, h - 8, Mantle.color.gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    end
    notify_achievement:MoveTo(scrw - notify_achievement:GetWide() - 10, scrh / 2 - 30, 0.3, 0, -1, function()
        timer.Simple(3, function()
            if IsValid(notify_achievement) then
                notify_achievement:AlphaTo(0, 1, 0, function()
                    notify_achievement:Remove()
                end)
            end
        end)
    end, EASE_INOUTCUBIC)
end

net.Receive('GameProfile-Notify', function()
    local id = net.ReadString()

    create_ach_notify(id)
end)

concommand.Add('gameprofile_ach_notify_test', function()
    create_ach_notify('heal_medic_2')
end)
