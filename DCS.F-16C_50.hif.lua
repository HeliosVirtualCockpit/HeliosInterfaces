-- Helios functions for F-16C_50
-- version: "1.6.6170.1000",
-- commit: "f771ff19c726dca0343b9865edeec7200755ee15"
function driver.processHighImportance(mainPanelDevice)
    -- called at configured update rate

    -- Send ADI Ball Values	
	helios.send(2050, string.format("%0.4f;0.0;%0.4f", mainPanelDevice:get_argument_value(17), mainPanelDevice:get_argument_value(18)))

    -- Fuel Total
        helios.send(
        2180,
        string.format(
            "%d",
            (math.floor(mainPanelDevice:get_argument_value(730)*10)*10000)+ (math.floor(mainPanelDevice:get_argument_value(731) * 10) * 1000) + (math.floor(mainPanelDevice:get_argument_value(732) * 1000))
        )
    )
    -- Fuel Flow
        helios.send(
        2181,
        string.format(
            "%d",
			math.floor(mainPanelDevice:get_argument_value(88)*10)*10000 + math.floor(mainPanelDevice:get_argument_value(89)*10)*1000 + math.floor(mainPanelDevice:get_argument_value(90)*100)*10
        )
	)

end

function driver.processLowImportance(mainPanelDevice)

	helios.send(2184, string.format("%1d", mainPanelDevice:get_argument_value(184)))
    helios.send(2185, string.format("%1d", mainPanelDevice:get_argument_value(185)))
	helios.send(3184, string.format("%1d", mainPanelDevice:get_argument_value(184)))
    helios.send(3185, string.format("%1d", mainPanelDevice:get_argument_value(185)))

end
