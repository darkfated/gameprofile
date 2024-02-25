local scrw, scrh = ScrW(), ScrH()
local color_text = Color(171, 171, 171, 200)

hook.Add('HUDPaint', 'GameProfile.TargetHud', function()
    local pl = LocalPlayer()
    local target = pl:GetEyeTrace().Entity

    if IsValid(target) and target:IsPlayer() then
        if pl:GetPos():DistToSqr(target:GetPos()) < 3000 then
            draw.SimpleText('F - профиль', 'Fated.16', scrw * 0.5, scrh * 0.5 + 50, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end)

local lastPressTime = 0
local isPressingE = false

hook.Add('PlayerButtonDown', 'GameProfile.F', function(pl, key)
    if key == KEY_F and not isPressingE then
        local trace = pl:GetEyeTrace()
        local target_pl = trace.Entity

        if IsValid(target_pl) and target_pl:IsPlayer() then
            if pl:GetPos():DistToSqr(target_pl:GetPos()) < 3000 then
                isPressingE = true

                RunConsoleCommand('gameprofile_get_player', target_pl:SteamID())

                timer.Simple(0.2, function()
                    if !isPressingE then
                        GameProfile.open_profile(true)

                        lastPressTime = CurTime()
                    end
                end)
            end
        end
    end
end)

hook.Add('PlayerButtonUp', 'GameProfile.F', function(pl, key)
    if key == KEY_F then
        isPressingE = false
    end
end)
