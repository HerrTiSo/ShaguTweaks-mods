local module = ShaguTweaks:register({
    title = "Improved Castbar",
    description = "Adds a spell icon and remaining cast time to the cast bar.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Action Bar",
    enabled = nil,
})

module.enable = function(self)
    local _G = _G or getfenv(0)

    local UnitCastingInfo = ShaguTweaks.UnitCastingInfo
    local UnitChannelInfo = ShaguTweaks.UnitChannelInfo

    local castbar = CreateFrame("FRAME", nil, CastingBarFrame)
    castbar:Hide()

    castbar.texture = CreateFrame("Frame", nil, castbar)
    castbar.texture:SetPoint("RIGHT", CastingBarFrame, "LEFT", -10, 2)
    castbar.texture:SetWidth(28)
    castbar.texture:SetHeight(28)

    castbar.texture.icon = castbar.texture:CreateTexture(nil, "BACKGROUND")
    castbar.texture.icon:SetPoint("CENTER", 0, 0)
    castbar.texture.icon:SetWidth(24)
    castbar.texture.icon:SetHeight(24)
    castbar.texture:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 8, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })

    castbar.spellText = castbar:CreateFontString(nil, "HIGH", "GameFontWhite")
    castbar.spellText:SetPoint("CENTER", CastingBarFrame, "CENTER", 0, 3)
    local font, _, opts = castbar.spellText:GetFont()
    local size = 14
    castbar.spellText:SetFont(font, size - 2, "THINOUTLINE")

    castbar.timerText = castbar:CreateFontString(nil, "HIGH", "GameFontWhite")
    castbar.timerText:SetPoint("RIGHT", CastingBarFrame, "RIGHT", -5, 3)
    castbar.timerText:SetFont(font, size - 2, "THINOUTLINE")

    CastingBarText:Hide()

    castbar:SetScript("OnUpdate", function()
        local cast, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitCastingInfo("player")
        if not cast then
        -- scan for channel spells if no cast was found
        cast, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo("player")
        end

        local alpha = CastingBarFrame:GetAlpha()
        castbar:SetAlpha(alpha)

        if cast then
            local channel = UnitChannelInfo("player")
            local duration = endTime - startTime
            local max = duration / 1000
            local cur = GetTime() - startTime / 1000

            if channel then
                cur = max + startTime/1000 - GetTime()
            end

            cur = cur > max and max or cur
            cur = cur < 0 and 0 or cur

            local rem = max - cur
            rem = string.format("%.1fs", rem)

            castbar.spellText:SetText(cast)
            castbar.timerText:SetText(rem)

            if texture then
                castbar.texture.icon:SetTexture(texture)
                castbar.texture.icon:Show()
            else
                castbar.texture.icon:Hide()
            end            
        else
            if ( alpha == 0 ) then
                castbar:Hide()
            end
        end
    end)

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("SPELLCAST_START")
    events:RegisterEvent("SPELLCAST_CHANNEL_START")
    events:SetScript("OnEvent", function()
        castbar:Show()
    end)
end