local ADDON_NAME = ...
local frame = CreateFrame("Frame")

local defaults = {
    enabled = false,
    message = "I am currently AFK. I will reply when I am back.",
    cooldown = 300,
}

local recentReplies = {}
local optionsPanel

local function Print(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99AutoWhisperReply:|r " .. tostring(message))
end

local function InitialiseDatabase()
    if type(AutoWhisperReplyDB) ~= "table" then
        AutoWhisperReplyDB = {}
    end

    if AutoWhisperReplyDB.enabled == nil then
        AutoWhisperReplyDB.enabled = defaults.enabled
    end

    if type(AutoWhisperReplyDB.message) ~= "string" or AutoWhisperReplyDB.message == "" then
        AutoWhisperReplyDB.message = defaults.message
    end

    if type(AutoWhisperReplyDB.cooldown) ~= "number" then
        AutoWhisperReplyDB.cooldown = defaults.cooldown
    end
end

local function SetEnabled(enabled)
    AutoWhisperReplyDB.enabled = enabled and true or false

    if optionsPanel and optionsPanel.enableCheckbox then
        optionsPanel.enableCheckbox:SetChecked(AutoWhisperReplyDB.enabled)
    end

    if AutoWhisperReplyDB.enabled then
        Print("Enabled.")
    else
        Print("Disabled.")
    end
end

local function SaveMessage(text)
    text = text or ""
    text = text:gsub("^%s+", ""):gsub("%s+$", "")

    if text == "" then
        Print("The reply message cannot be empty.")
        return false
    end

    AutoWhisperReplyDB.message = text

    if optionsPanel and optionsPanel.messageBox then
        optionsPanel.messageBox:SetText(AutoWhisperReplyDB.message)
    end

    Print("Reply message updated.")
    return true
end

local function SetCooldown(seconds)
    seconds = tonumber(seconds)

    if not seconds or seconds < 0 then
        Print("Cooldown must be 0 or more seconds.")
        return false
    end

    AutoWhisperReplyDB.cooldown = math.floor(seconds)

    if optionsPanel and optionsPanel.cooldownBox then
        optionsPanel.cooldownBox:SetText(tostring(AutoWhisperReplyDB.cooldown))
    end

    Print("Per-player cooldown set to " .. AutoWhisperReplyDB.cooldown .. " seconds.")
    return true
end

local function ShowHelp()
    Print("Commands:")
    Print("/awr on - enable automatic replies")
    Print("/awr off - disable automatic replies")
    Print("/awr toggle - toggle automatic replies")
    Print("/awr msg <message> - change the reply message")
    Print("/awr cooldown <seconds> - change the per-player reply cooldown")
    Print("/awr status - show current settings")
    Print("/awr config - open the settings panel")
end

local function ShowStatus()
    Print("Status: " .. (AutoWhisperReplyDB.enabled and "ON" or "OFF"))
    Print("Message: " .. AutoWhisperReplyDB.message)
    Print("Cooldown: " .. AutoWhisperReplyDB.cooldown .. " seconds per player")
end

local function OpenConfig()
    if InterfaceOptionsFrame_OpenToCategory and optionsPanel then
        InterfaceOptionsFrame_OpenToCategory(optionsPanel)
        InterfaceOptionsFrame_OpenToCategory(optionsPanel)
    else
        Print("Open Interface > AddOns > Auto Whisper Reply.")
    end
end

local function CreateOptionsPanel()
    local panel = CreateFrame("Frame", "AutoWhisperReplyOptionsPanel", UIParent)
    panel.name = "Auto Whisper Reply"
    optionsPanel = panel

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Auto Whisper Reply")

    local description = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    description:SetWidth(560)
    description:SetJustifyH("LEFT")
    description:SetText("Automatically reply to incoming player whispers while this addon is enabled.")

    local enableCheckbox = CreateFrame("CheckButton", "AutoWhisperReplyEnableCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
    enableCheckbox:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -18)
    local checkboxText = _G[enableCheckbox:GetName() .. "Text"]
    if checkboxText then
        checkboxText:SetText("Enable automatic whisper replies")
    end
    enableCheckbox:SetScript("OnClick", function(self)
        SetEnabled(self:GetChecked())
    end)
    panel.enableCheckbox = enableCheckbox

    local messageLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    messageLabel:SetPoint("TOPLEFT", enableCheckbox, "BOTTOMLEFT", 0, -24)
    messageLabel:SetText("Automatic reply message:")

    local messageBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    messageBox:SetPoint("TOPLEFT", messageLabel, "BOTTOMLEFT", 5, -8)
    messageBox:SetWidth(500)
    messageBox:SetHeight(24)
    messageBox:SetAutoFocus(false)
    messageBox:SetMaxLetters(255)
    messageBox:SetScript("OnEnterPressed", function(self)
        if SaveMessage(self:GetText()) then
            self:ClearFocus()
        end
    end)
    messageBox:SetScript("OnEscapePressed", function(self)
        self:SetText(AutoWhisperReplyDB.message)
        self:ClearFocus()
    end)
    messageBox:SetScript("OnEditFocusLost", function(self)
        if self:GetText() ~= AutoWhisperReplyDB.message then
            if not SaveMessage(self:GetText()) then
                self:SetText(AutoWhisperReplyDB.message)
            end
        end
    end)
    panel.messageBox = messageBox

    local cooldownLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    cooldownLabel:SetPoint("TOPLEFT", messageBox, "BOTTOMLEFT", -5, -24)
    cooldownLabel:SetText("Reply cooldown for the same player (seconds):")

    local cooldownBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    cooldownBox:SetPoint("TOPLEFT", cooldownLabel, "BOTTOMLEFT", 5, -8)
    cooldownBox:SetWidth(100)
    cooldownBox:SetHeight(24)
    cooldownBox:SetAutoFocus(false)
    cooldownBox:SetNumeric(true)
    cooldownBox:SetMaxLetters(6)
    cooldownBox:SetScript("OnEnterPressed", function(self)
        if SetCooldown(self:GetText()) then
            self:ClearFocus()
        end
    end)
    cooldownBox:SetScript("OnEscapePressed", function(self)
        self:SetText(tostring(AutoWhisperReplyDB.cooldown))
        self:ClearFocus()
    end)
    cooldownBox:SetScript("OnEditFocusLost", function(self)
        local value = tonumber(self:GetText())
        if value ~= AutoWhisperReplyDB.cooldown then
            if not SetCooldown(self:GetText()) then
                self:SetText(tostring(AutoWhisperReplyDB.cooldown))
            end
        end
    end)
    panel.cooldownBox = cooldownBox

    local note = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    note:SetPoint("TOPLEFT", cooldownBox, "BOTTOMLEFT", -5, -18)
    note:SetWidth(560)
    note:SetJustifyH("LEFT")
    note:SetText("The cooldown prevents repeated whispers from causing reply spam. Set it to 0 to reply to every whisper.")

    panel:SetScript("OnShow", function()
        enableCheckbox:SetChecked(AutoWhisperReplyDB.enabled)
        messageBox:SetText(AutoWhisperReplyDB.message)
        cooldownBox:SetText(tostring(AutoWhisperReplyDB.cooldown))
    end)

    if InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(panel)
    end
end

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("CHAT_MSG_WHISPER")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon ~= ADDON_NAME then
            return
        end

        InitialiseDatabase()
        CreateOptionsPanel()
        Print("Loaded. Type /awr for commands.")
        return
    end

    if event == "CHAT_MSG_WHISPER" then
        if not AutoWhisperReplyDB or not AutoWhisperReplyDB.enabled then
            return
        end

        local message, sender = ...
        if not sender or sender == "" then
            return
        end

        local playerName = UnitName("player")
        if sender == playerName then
            return
        end

        local replyText = AutoWhisperReplyDB.message
        if not replyText or replyText == "" then
            return
        end

        local now = GetTime()
        local lastReply = recentReplies[sender]
        local cooldown = AutoWhisperReplyDB.cooldown or 0

        if cooldown > 0 and lastReply and (now - lastReply) < cooldown then
            return
        end

        recentReplies[sender] = now
        SendChatMessage(replyText, "WHISPER", nil, sender)
    end
end)

SLASH_AUTOWHISPERREPLY1 = "/awr"
SLASH_AUTOWHISPERREPLY2 = "/autoreply"
SlashCmdList["AUTOWHISPERREPLY"] = function(msg)
    msg = msg or ""
    local command, rest = msg:match("^(%S*)%s*(.-)$")
    command = string.lower(command or "")

    if command == "on" then
        SetEnabled(true)
    elseif command == "off" then
        SetEnabled(false)
    elseif command == "toggle" then
        SetEnabled(not AutoWhisperReplyDB.enabled)
    elseif command == "msg" or command == "message" then
        if rest == "" then
            Print("Current message: " .. AutoWhisperReplyDB.message)
            Print("Use /awr msg <your message> to change it.")
        else
            SaveMessage(rest)
        end
    elseif command == "cooldown" then
        if rest == "" then
            Print("Current cooldown: " .. AutoWhisperReplyDB.cooldown .. " seconds.")
        else
            SetCooldown(rest)
        end
    elseif command == "status" then
        ShowStatus()
    elseif command == "config" or command == "options" then
        OpenConfig()
    elseif command == "" then
        OpenConfig()
        ShowHelp()
    else
        ShowHelp()
    end
end
