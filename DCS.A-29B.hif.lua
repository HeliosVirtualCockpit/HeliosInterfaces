function driver.processHighImportance(mainPanelDevice)
    -- called at configured update rate
        helios.send(2001, string.format("%0.1f", mainPanelDevice:get_argument_value(226))) -- Light MainPump L
        helios.send(2002, string.format("%0.1f", mainPanelDevice:get_argument_value(227))) -- Light MainPump R
        helios.send(2003, string.format("%0.1f", mainPanelDevice:get_argument_value(228))) -- Light AuxPump L
        helios.send(2004, string.format("%0.1f", mainPanelDevice:get_argument_value(229))) -- Light AuxPump R
        helios.send(2005, string.format("%0.1f", mainPanelDevice:get_argument_value(230))) -- Light OVRD L
        helios.send(2006, string.format("%0.1f", mainPanelDevice:get_argument_value(231))) -- Light OVRD R
        helios.send(2007, string.format("%0.1f", mainPanelDevice:get_argument_value(232))) -- Light VNTRL
        helios.send(2008, string.format("%0.4f", mainPanelDevice:get_argument_value(80))) -- Throttle Position Lock

end

--[[

function driver.processLowImportance(mainPanelDevice) --luacheck: no unused args
    -- same things as processHighImportance can be done here, called a few times per second at most
end

]]