-- Helios version 1.6.6210.000

-- Helios functions for the DCS F-14B(U) (Heatblur, vehicle "F-14BU")
--
-- Custom export Lua for a Helios 1.6 DCS interface.  Helios loads this file together with the
-- interface file of the same name, so keep the two side by side:
--     Documents\Helios\Interfaces\HeliosInterfaces\DCS.F-14BU.hif.json
--     Documents\Helios\Interfaces\HeliosInterfaces\DCS.F-14BU.hif.lua    (this file)
-- If your interface file has another name, rename this file to match it (<name>.hif.lua).
--
-- What it sends (each id needs a "DCS.Common.Text" function in the interface, see the end):
--     30001  Pilot left console UHF radio display (AN/ARC-159), e.g. "243.000"
--     30002  Pilot left panel DFCS fault display (4 characters)
--     30003  RIO CMDS display (AN/ALE-47 countermeasures; wider gaps, see CMDS_EXTRA_GAP)
--     30004  RIO CDNU display line 1   (22 characters per line)
--       ...
--     30011  RIO CDNU display line 8
--     30012  RIO CDNU display, ALL eight lines in one value (for a single Text Display)
-- The DFCS, CMDS and CDNU displays exist only on the F-14B(U); on other F-14s they are blank.
--
-- Where the text comes from (DCS cockpit indications, read with list_indication):
--     Pilot UHF display     indication 4 on the F-14B(U)  (10 on the F-14A/B)
--                           entry 3 = the six frequency digits, entry 4 = the decimal point
--     DFCS fault display    indication 33 on the F-14B(U), entry 7
--     CMDS display          indication 33 on the F-14B(U), entry 4
--                           (the same indication also holds the TIS display, entries 5 and 6)
--     CDNU display          indication 28 on the F-14B(U), entries 6 to 13 = lines 1 to 8
-- These indication numbers and entries are the ones the DCS-BIOS project uses
-- (https://github.com/DCS-Skunkworks/dcs-bios, aircraft_modules/F-14.lua).
--
-- Helios Text Display setup (its "parser dictionary"):
--     !=:     shows the colons again (":" cannot be sent, see TEXT_CHAR_MAP)
--     ¶ -> a line break   for the all-lines CDNU value 30012 (see CDNU.lineSeparator)

-- ------------------------------ settings ------------------------------------
-- Export ids sent to Helios.  Change them here if they clash with your interface.
local EXPORT_ID_PLT_UHF_DISPLAY = 30001
local EXPORT_ID_DFCS_FAULT_DISPLAY = 30002
local EXPORT_ID_CMDS_DISPLAY = 30003

-- Extra space added to every gap between the entries of the CMDS display (the groups of
-- characters separated by spaces), for a wider layout.  Four spaces = one tab stop.  "\t" (a
-- real tab) also works if your Text Display shows tabs; "" sends the display unchanged.
-- Spaces before the first and after the last entry are not changed.
local CMDS_EXTRA_GAP = "    "

-- Character substitutions applied to everything that is sent.
--   ":" and "=" are reserved by the Helios network protocol and must never be sent.
--   "!" is the Helios convention for ":"; give the Text Display the parser dictionary
--   !=:  to show the colon again.
local TEXT_CHAR_MAP = {
    [":"] = "!",
    ["="] = "-",
}

local CDNU = {
    -- DCS indicator number of the CDNU in the F-14B(U) and the entry that holds line 1
    -- (line n is entry firstLineEntry + n - 1)
    indicatorId = 28,
    firstLineEntry = 6,

    -- size of the display in characters; every line is padded / cut to this width so the
    -- lines of the all-lines value stay in columns
    width = 22,
    height = 8,

    -- Helios value IDs.  They must match the "id" entries of the CDNU Text functions in
    -- DCS.F-14BU.hif.json.
    idLine = { 30004, 30005, 30006, 30007, 30008, 30009, 30010, 30011 },  -- one value per line
    idAll = 30012,                                                         -- all eight lines

    -- Character placed between the lines in the all-lines value.  A line break itself cannot
    -- be sent (it ends a Helios network packet), so the Text Display's parser dictionary
    -- turns this character into one.  "\182" is the pilcrow sign (¶) of ISO-8859-1.
    lineSeparator = "\182",

    -- Blank lines added between the CDNU lines in the all-lines value, for more space between
    -- them: 0 = none (lines touch), 1 = one empty line between each line, 2 = two, ...
    -- (each blank line is one more lineSeparator).  For finer steps, use the Text Display's
    -- own line spacing / font size instead, or one Text Display per line (ids 30004-30011).
    blankLinesBetween = 0,

    -- The CDNU draws its arrows and degree sign with control characters; this is what is sent
    -- for each.  The defaults are single ISO-8859-1 characters (as DCS-BIOS uses), so every
    -- symbol stays one column wide.  Change any of them to a character your font has.
    symbols = {
        [string.char(0x10)] = "\187",   -- right arrow      -> »
        [string.char(0x0F)] = "\171",   -- left arrow       -> «
        [string.char(0x11)] = "\169",   -- left-right arrow -> ©
        [string.char(0x12)] = "\174",   -- up-down arrow    -> ®
        [string.char(0x0E)] = "\176",   -- degree sign      -> °
        [string.char(0x15)] = "{",      -- up arrow         -> {
        [string.char(0x16)] = "}",      -- down arrow       -> }
    },
}

-- Indication numbers of the other displays
local UHF_INDICATION_F14BU = 4      -- pilot ARC-159 (left console) on the F-14B(U)
local UHF_INDICATION_F14AB = 10     -- the same display on the F-14A / F-14B
local ALE47_INDICATION_F14BU = 33   -- ALE-47 (CMDS) / TIS / DFCS fault display (F-14B(U) only)
local CMDS_ENTRY = 4
local DFCS_FAULT_ENTRY = 7

-- ------------------------------ implementation ------------------------------
local ENTRY_SEPARATOR = string.rep("-", 41)

-- Split list_indication text into the texts of its elements, in the order they appear
-- (entries[1], entries[2], ...); "" for an element without text.  Each block starts with a
-- line of dashes, then the element's name, then its text.  An element that opens a
-- "children are {" group counts as one entry, so the numbering matches DCS-BIOS.
local function splitIndication(indication)
    local entries = {}
    if type(indication) ~= "string" or indication == "" then
        return entries
    end
    if string.sub(indication, -1) ~= "\n" then
        indication = indication .. "\n"
    end

    local inEntry, name, lines = false, nil, {}
    local function finishEntry()
        if inEntry and name ~= nil then
            entries[#entries + 1] = table.concat(lines, "\n")
        end
        inEntry, name, lines = false, nil, {}
    end

    for line in string.gmatch(indication, "([^\n]*)\n") do
        line = string.gsub(line, "\r", "")
        if line == ENTRY_SEPARATOR then
            finishEntry()
            inEntry = true
        elseif line == "children are {" then
            finishEntry()
        elseif line == "}" and inEntry and name ~= nil and #lines > 0 then
            finishEntry()                    -- end of a group of child elements
        elseif inEntry then
            if name == nil then
                name = line
            else
                lines[#lines + 1] = line
            end
        end
    end
    finishEntry()
    return entries
end

-- list_indication(n) as text ("" when it cannot be read).
local function readIndication(indicationNumber)
    local ok, indication = pcall(list_indication, indicationNumber)
    if not ok or type(indication) ~= "string" then
        return ""
    end
    return indication
end

-- A value made safe to send: the reserved characters swapped (TEXT_CHAR_MAP).
local function heliosText(value)
    if value == nil then
        return ""
    end
    return (string.gsub(tostring(value), "[:=]", TEXT_CHAR_MAP))
end

-- CMDS display with CMDS_EXTRA_GAP added to each gap between its entries:
-- "CH 30 FL 30" -> "CH     30     FL     30".
local function cmdsText(text)
    text = text or ""
    if CMDS_EXTRA_GAP == "" then
        return text
    end
    local leading, middle, trailing = string.match(text, "^(%s*)(.-)(%s*)$")
    middle = string.gsub(middle, "%s+", function(gap)
        return gap .. CMDS_EXTRA_GAP
    end)
    return leading .. middle .. trailing
end

-- True when the aircraft being flown is the F-14B(U).
local function isF14BU()
    local ok, selfData = pcall(LoGetSelfData)
    return ok and type(selfData) == "table" and selfData.Name == "F-14BU"
end

-- Pilot UHF (ARC-159) display: the six digits with the decimal point after the third,
-- "243000" + "." -> "243.000".  Blank while the radio shows nothing.
local function pilotUhfDisplay(upgrade)
    local entries = splitIndication(readIndication(upgrade and UHF_INDICATION_F14BU or UHF_INDICATION_F14AB))
    local digits, separator = entries[3], entries[4]
    if digits == nil or digits == "" then
        return ""
    end
    return string.sub(digits, 1, 3) .. (separator or "") .. string.sub(digits, 4)
end

-- ---- CDNU ----
local cdnuState = {
    raw = nil,    -- last text returned by list_indication (the lines are rebuilt only when it changes)
    line = {},    -- the eight lines, ready to send
    all = "",     -- the eight lines joined with CDNU.lineSeparator (plus blankLinesBetween)
}

local function cdnuBlank()
    for y = 1, CDNU.height do
        cdnuState.line[y] = ""
    end
    cdnuState.all = ""
end
cdnuBlank()

-- One CDNU line: symbols swapped, reserved characters swapped, padded / cut to the width.
local function cdnuLine(text)
    text = string.gsub(text or "", "[%z\1-\31]", function(character)
        return CDNU.symbols[character] or " "
    end)
    text = heliosText(text)
    if #text < CDNU.width then
        text = text .. string.rep(" ", CDNU.width - #text)
    end
    return string.sub(text, 1, CDNU.width)
end

local function cdnuUpdate(upgrade)
    local raw = upgrade and readIndication(CDNU.indicatorId) or ""
    if raw ~= cdnuState.raw then
        cdnuState.raw = raw
        if raw == "" then
            cdnuBlank()                    -- display off, or not an F-14B(U)
        else
            local entries = splitIndication(raw)
            for y = 1, CDNU.height do
                cdnuState.line[y] = cdnuLine(entries[CDNU.firstLineEntry + y - 1])
            end
            local between = string.rep(CDNU.lineSeparator, 1 + math.max(0, math.floor(CDNU.blankLinesBetween or 0)))
            cdnuState.all = table.concat(cdnuState.line, between)
        end
    end
    -- helios.send only transmits values that changed since the last send
    for y = 1, CDNU.height do
        helios.send(CDNU.idLine[y], cdnuState.line[y])
    end
    helios.send(CDNU.idAll, cdnuState.all)
end

-- ---- all displays ----
local errorLogged = false

local function exportDisplays()
    local upgrade = isF14BU()
    helios.send(EXPORT_ID_PLT_UHF_DISPLAY, heliosText(pilotUhfDisplay(upgrade)))

    -- DFCS fault display (pilot) and CMDS display (RIO) come from the same indication.
    local ale47 = upgrade and splitIndication(readIndication(ALE47_INDICATION_F14BU)) or {}
    helios.send(EXPORT_ID_DFCS_FAULT_DISPLAY, heliosText(ale47[DFCS_FAULT_ENTRY]))
    helios.send(EXPORT_ID_CMDS_DISPLAY, heliosText(cmdsText(ale47[CMDS_ENTRY])))

    cdnuUpdate(upgrade)
end

function driver.processHighImportance(mainPanelDevice) --luacheck: no unused args
    -- nothing here needs the full update rate
end

-- Called a few times per second at most: plenty for these displays.  An error here is
-- written once to dcs.log and never stops the other exports.
function driver.processLowImportance(mainPanelDevice) --luacheck: no unused args
    local ok, err = pcall(exportDisplays)
    if not ok and not errorLogged then
        errorLogged = true
        if log and log.write then
            log.write("HELIOS.EXPORT", log.ERROR, "F-14B(U) display export failed: " .. tostring(err))
        end
    end
end
