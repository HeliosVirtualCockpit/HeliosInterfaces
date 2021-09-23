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

--[[

function driver.processLowImportance(mainPanelDevice) --luacheck: no unused args
    -- same things as processHighImportance can be done here, called a few times per second at most
end

]]