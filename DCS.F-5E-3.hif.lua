-- Exports.Lua from Helios DCS F-5E-3 Tiger II
function driver.processHighImportance(mainPanelDevice)
	-- Send Altimeter Values	
	helios.send(2051, string.format("%0.4f;%0.4f;%0.4f", mainPanelDevice:get_argument_value(11), mainPanelDevice:get_argument_value(520), mainPanelDevice:get_argument_value(521)))													--  Altitude
	helios.send(2059, string.format("%0.2f;%0.2f;%0.2f;%0.3f", mainPanelDevice:get_argument_value(56), mainPanelDevice:get_argument_value(57), mainPanelDevice:get_argument_value(58), mainPanelDevice:get_argument_value(59)))		-- QNH pressure 	
end
function driver.processLowImportance(mainPanelDevice)		
end
