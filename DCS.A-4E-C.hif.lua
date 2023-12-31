
function driver.processHighImportance(mainPanelDevice)
    -- called at configured update rate

        helios.send(2001, string.format("%0.1f", mainPanelDevice:get_argument_value(105))) -- MANUAL_FUEL_CONTROL_WARN
        helios.send(2002, string.format("%0.4f", mainPanelDevice:get_argument_value(870))) -- PITCH_TRIM_GAUGE
        helios.send(2003, string.format("%0.4f", mainPanelDevice:get_argument_value(871))) -- YAW_TRIM_GAUGE
        helios.send(2004, string.format("%0.4f", mainPanelDevice:get_argument_value(80)))  -- Throttle Position Lock
        helios.send(2005, string.format("%0.4f", mainPanelDevice:get_argument_value(508))) -- Compass SYNC
        helios.send(2006, string.format("%0.2f", mainPanelDevice:get_argument_value(901))) -- TACAN Channel MAJOR Disp
        helios.send(2007, string.format("%0.1f", mainPanelDevice:get_argument_value(902))) -- TACAN Channel Minor Disp

end

--[[

function driver.processLowImportance(mainPanelDevice) --luacheck: no unused args
    -- same things as processHighImportance can be done here, called a few times per second at most
end

]]