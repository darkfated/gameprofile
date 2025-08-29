local PANEL = {}

function PANEL:Init()
    self.sp = vgui.Create('MantleScrollPanel', self)
    self.sp:Dock(FILL)
end

function PANEL:SetPlayer(steamid)
    self.steamid = steamid
    RunConsoleCommand('gameprofile_get_inv', self.steamid)

    timer.Simple(0.1, function()
        self:UpdateInventory()
    end)
end

function PANEL:UpdateInventory()
    if !GameProfile.active_inventory then return end

    self.sp:Clear()

    local tablVisual = util.JSONToTable(GameProfile.active_inventory.visual)

    local function CreateItem(item_name)
        local itemTable = GameProfile.config.shop[item_name]
        if !itemTable then return end

        local panItem = vgui.Create('DPanel', self.sp)
        panItem:Dock(TOP)
        panItem:DockMargin(0, 0, 0, 8)
        panItem:SetTall(60)
        panItem.Paint = function(_, w, h)
            RNDX().Rect(0, 0, w, h)
                :Rad(16)
                :Color(Mantle.color.panel_alpha[2])
                :Shape(RNDX_SHAPE_IOS)
            :Draw()

            RNDX().Rect(6, 6, 48, 48)
                :Rad(16)
                :Material(itemTable.image)
                :Shape(RNDX_SHAPE_IOS)
            :Draw()

            draw.SimpleText(itemTable.name, 'Fated.18', 60, 14, Mantle.color.text)
            draw.SimpleText(itemTable.t, 'Fated.16', 60, h - 14, Mantle.color.gray, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end

        local activeBtn = vgui.Create('MantleBtn', panItem)
        activeBtn:Dock(RIGHT)
        activeBtn:DockMargin(0, 12, 6, 12)
        activeBtn:SetWide(110)
        activeBtn:SetTxt('Активировать')
        activeBtn.DoClick = function()
            RunConsoleCommand('gameprofile_inv_use', self.steamid, item_name)
            timer.Simple(0.1, function()
                GameProfile.ui.menu.tabProfile:UpdateProfile()
            end)
        end
    end

    for _, visual in ipairs(tablVisual) do
        CreateItem(visual)
    end
end

function PANEL:Paint(w, h)

end

function PANEL:PerformLayout(w, h)

end

vgui.Register('GameProfile.Inventory', PANEL, 'Panel')
