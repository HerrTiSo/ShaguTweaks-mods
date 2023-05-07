local module = ShaguTweaks:register({
    title = "Basic Chat",
    description = "Creates General, Combat Log and 'Loot & Spam' chat boxes and resets chat channels on every login.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Social & Chat",
    enabled = nil,
})
  
module.enable = function(self)
    local function Create()
        FCF_SetWindowName(ChatFrame1, GENERAL)

        FCF_DockFrame(ChatFrame2)
        FCF_SetWindowName(ChatFrame2, COMBAT_LOG)
    
        FCF_DockFrame(ChatFrame3)
        FCF_SetWindowName(ChatFrame3, "Loot & Spam")

        FCF_SelectDockFrame(ChatFrame1)
    end
    
    local function Channels()
        ChatFrame_RemoveAllMessageGroups(ChatFrame1)
        ChatFrame_RemoveAllMessageGroups(ChatFrame2)
        ChatFrame_RemoveAllMessageGroups(ChatFrame3)
    
        ChatFrame_RemoveAllChannels(ChatFrame1)
        ChatFrame_RemoveAllChannels(ChatFrame2)
        ChatFrame_RemoveAllChannels(ChatFrame3)
    
        local normalg = { "SYSTEM", "SAY", "YELL", "WHISPER", "PARTY", "GUILD", "GUILD_OFFICER", "CREATURE", "CHANNEL", "EMOTE", "RAID", "RAID_LEADER", "RAID_WARNING", "BATTLEGROUND", "BATTLEGROUND_LEADER", "MONSTER_SAY", "MONSTER_EMOTE", "MONSTER_YELL", "MONSTER_WHISPER", "MONSTER_BOSS_EMOTE", "MONSTER_BOSS_WHISPER" }
        for _,group in pairs(normalg) do
          ChatFrame_AddMessageGroup(ChatFrame1, group)
        end
    
        ChatFrame_ActivateCombatMessages(ChatFrame2)    
        
        local spamg = { "COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "SKILL", "LOOT" }
        for _,group in pairs(spamg) do
        ChatFrame_AddMessageGroup(ChatFrame3, group)
        end
    
        for _, chan in pairs({EnumerateServerChannels()}) do
        ChatFrame_AddChannel(ChatFrame3, chan)
        ChatFrame_RemoveChannel(ChatFrame1, chan)
        end
    
        -- JoinChannelByName("World")
        -- ChatFrame_AddChannel(ChatFrame3, "World")
    end

    local events = CreateFrame("Frame", nil, UIParent)	
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        if not this.loaded then
            this.loaded = true
            Create()
            Channels()
        end
    end)
end
