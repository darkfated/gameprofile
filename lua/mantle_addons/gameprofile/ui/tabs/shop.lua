local PANEL = {}

function PANEL:Init()
    self.tabs = vgui.Create('MantleTabs', self)
    self.tabs:Dock(FILL)

    self.steamid = LocalPlayer():SteamID()
    RunConsoleCommand('gameprofile_get_inv', self.steamid)

    timer.Simple(0.1, function()
        self:CreateShop()
    end)
end

function PANEL:CreateShop()
    if !GameProfile.active_inventory then return end

    local sortedItems = {}
    for itemName, itemTable in pairs(GameProfile.config.shop) do
        if !sortedItems[itemTable.t] then
            sortedItems[itemTable.t] = {}
        end

        sortedItems[itemTable.t][itemName] = itemTable
    end

    for categoryName, items in pairs(sortedItems) do
        local categoryPanel = vgui.Create('MantleScrollPanel', self.tabs)

        for itemName, itemTable in pairs(items) do
            local panItem = vgui.Create('DPanel', categoryPanel)
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
            activeBtn:SetTxt('Купить')
            activeBtn.DoClick = function()
                RunConsoleCommand('gameprofile_inv_buy', self.steamid, itemName)
                GameProfile.ui.menu.tabInventory:SetPlayer(self.steamid)
            end
        end

        self.tabs:AddTab(categoryName, categoryPanel)
    end
end

function PANEL:Paint(w, h)

end

function PANEL:PerformLayout(w, h)

end

vgui.Register('GameProfile.Shop', PANEL, 'Panel')
