--[[
  Lua functions for the DCS UH-1H Huey
  "version": "1.6.6160.0000",
  "commit": "f114afb9621c70d0211b82d84cb4664ab140dec4",
]]

function driver.processHighImportance(mainPanelDevice)
    -- called at configured update rate

	-- Pilot ADI ball combined movement values
	helios.send(2049, string.format("%0.3f;0.0;%0.3f", mainPanelDevice:get_argument_value(143), mainPanelDevice:get_argument_value(142)))
	-- Operator ADI ball combined movement values
	helios.send(2050, string.format("%0.3f;0.0;%0.3f", mainPanelDevice:get_argument_value(136), mainPanelDevice:get_argument_value(135)))

    -- example for structured indications data:
    local li = helios.parseIndication(1)
    if li then
        helios.send(2002, string.format("%s", helios.ensureString(li.someNamedField1)))
        helios.send(2003, string.format("%s", helios.ensureString(li.someNamedField2)))
    end
end

--[[

function driver.processLowImportance(mainPanelDevice) --luacheck: no unused args
    -- same things as processHighImportance can be done here, called a few times per second at most
end

]]