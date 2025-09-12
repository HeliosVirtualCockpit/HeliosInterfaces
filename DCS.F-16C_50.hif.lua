-- Helios functions for F-16C_50 1.6.609.2
--[[
function driver.processHighImportance(mainPanelDevice)
    -- called at configured update rate

    -- example for combining/processing arguments:
    helios.send(2001, string.format(
            "%0.4f;%0.4f;%0.4f",
            mainPanelDevice:get_argument_value(220),
            mainPanelDevice:get_argument_value(219),
            mainPanelDevice:get_argument_value(218)
        )
    )

    -- example for structured indications data:
    local li = helios.parseIndication(1)
    if li then
        helios.send(2002, string.format("%s", helios.ensureString(li.someNamedField1)))
        helios.send(2003, string.format("%s", helios.ensureString(li.someNamedField2)))
    end
end
]]
function driver.processLowImportance(mainPanelDevice) --luacheck: no unused args
    -- same things as processHighImportance can be done here, called a few times per second at most
	
	-- 184 and 185 are required for multiple interface items, so they are sent under alias id's
	helios.send(2184, string.format("%1d", mainPanelDevice:get_argument_value(184)))
    helios.send(2185, string.format("%1d", mainPanelDevice:get_argument_value(185)))
	helios.send(3184, string.format("%1d", mainPanelDevice:get_argument_value(184)))
    helios.send(3185, string.format("%1d", mainPanelDevice:get_argument_value(185)))

    -- Fuel Total
        helios.send(
        2180,
        string.format(
            "%d",
            (math.floor(mainPanelDevice:get_argument_value(730)*10)*10000)+ (math.floor(mainPanelDevice:get_argument_value(731) * 10) * 1000) + (math.floor(mainPanelDevice:get_argument_value(732) * 1000))
        )
    )
end
