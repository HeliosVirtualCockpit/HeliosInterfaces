function driver.processHighImportance(mainPanelDevice)
    -- called at configured update rate

    -- EXT_POSITION_LIGHT_LEFT, "External Aircraft Model", "Left Position Light (red)"
    helios.send(2001, string.format("%d", LoGetAircraftDrawArgumentValue(190) > 0 and 1 or 0))
end

--[[

function driver.processLowImportance(mainPanelDevice) --luacheck: no unused args
    -- same things as processHighImportance can be done here, called a few times per second at most
end

]]