EventTrace = LibStub("AceAddon-3.0"):NewAddon("EventTrace", "AceConsole-3.0", "AceEvent-3.0")

-- ---------------------------------------------------------------------------------------
-- General variables and declarations
-- ---------------------------------------------------------------------------------------
local frame = CreateFrame("FRAME", "EventTraceAddonFrame");
local db

local character = UnitName("player")

-- ---------------------------------------------------------------------------------------
-- Standard Ace addon state handlers
-- ---------------------------------------------------------------------------------------
function EventTrace:OnInitialize()
    -- Called when the addon is loaded

    self.db = LibStub("AceDB-3.0"):New("EventTraceDB")

    db = self.db

    db.char.events = {} -- always reset on load ...

    EventTrace:Print("DB init")
end

function EventTrace:OnEnable()
    -- Called when the addon is enabled

    frame:RegisterAllEvents()

    EventTrace:RegisterChatCommand("eventTrace", "EventTraceToggleCommand")

    EventTrace:Print("EventTrace enabled.")
end

function EventTrace:OnDisable()
    -- Called when the addon is disabled
end

-- ---------------------------------------------------------------------------------------
-- Slash command handlers
-- ---------------------------------------------------------------------------------------
function EventTrace:EventTraceToggleCommand(comment, ...)
    local state = "off"
    if (eventTrace == false) then
        eventTrace = true
        state = "on"
    else
        eventTrace = false
    end
    RecordEvent("EventTrace: ["..state.."] "..comment)
    EventTrace:Print("EventTrace: ["..state.."] "..comment)
end

-- ---------------------------------------------------------------------------------------
-- Utility functions
-- ---------------------------------------------------------------------------------------
function Timestamp()
    return time()
end

function RecordEvent(event)
    table.insert(db.char.events, Timestamp()..","..event)
    EventTrace:Print(Timestamp()..","..event)
end

-- ---------------------------------------------------------------------------------------
-- WoW event handling -- basically the app body, define here as a backstop in case I've
-- not declared one or more functions, variables. For each event parse args and call a
-- descriptive method
-- ---------------------------------------------------------------------------------------
local function eventHandler(self, event, ...)
    if (eventTrace == true) then
        RecordEvent(event)
    end
end

local function onLoadHandler()
    print("EventTrace loaded")
end

frame:SetScript("OnLoad", onLoadHandler)
frame:SetScript("OnEvent", eventHandler);
