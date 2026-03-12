--[[
1.6.6180.0000 
This interface requires patches to be installed
]]
function driver.processHighImportance(mainPanelDevice)
	li = helios.parseIndication(7)  -- RadAlt
	if li then
		helios.send(2119, string.format("%4s", helios.ensureString(li.CURRENT_RALT):gsub(":", "!")))
		local lit
		if helios.ensureString(li.RAD_ALT_LOW_STAT) == "LO" then lit = 1 else lit = 0 end
		helios.send(2120, string.format("%1d", lit))
		if helios.ensureString(li.RAD_ALT_HIGH_STAT) == "HI" then lit = 1 else lit = 0 end
		helios.send(2121, string.format("%1d", lit))
	end
end

function driver.processLowImportance(mainPanelDevice)
    -- Engine N2 NR Gauge
    li = helios.parseIndication(5)
    if li then
		local gaugeN2 = string.format("%30s", "")
		local gaugeN2HWM = 0
		local gaugeN2LWM = 0
		local gaugeNR = string.format("%30s", "")
		local gaugeNRHWM = 0
		local gaugeNRLWM = 0
	  for v, vv in pairs(li) do
		if v and v ~= ""  and v ~= "." then
			if v:find("segment") ~= nil then
				v =  v:gsub("segment","")
				local seg = tonumber(v:sub(3))
				if v:sub(1,1) == "L" then
				  gaugeN2 = gaugeN2:sub(1, seg-1) .. "*" .. gaugeN2:sub(seg+1)
				  if gaugeN2HWM < seg then gaugeN2HWM = seg end
				  if gaugeN2LWM > seg then gaugeN2LWM = seg end
				else
				  gaugeNR = gaugeNR:sub(1, seg-1) .. "*" .. gaugeNR:sub(seg+1)
				  if gaugeNRHWM < seg then gaugeNRHWM = seg end
				  if gaugeNRLWM > seg then gaugeNRLWM = seg end
				end
			elseif v == "N2_PERCENT" then-- this requires a patch to mods\aircraft\AH-6J\Cockpit\Scripts\VDI_RPM\base_page.lua
				helios.send(2105, string.format("%s", helios.ensureString(vv):gsub(":", "!")))
			elseif v == "NR_PERCENT" then  -- this requires a patch to mods\aircraft\AH-6J\Cockpit\Scripts\VDI_RPM\base_page.lua 
				helios.send(2106, string.format("%s", helios.ensureString(vv):gsub(":", "!")))
			else
			end
		end
	  end	
      helios.send(2103, string.format("%s", helios.ensureString(gaugeN2):gsub(":", "!")))
      helios.send(2104, string.format("%s", helios.ensureString(gaugeNR):gsub(":", "!")))
      helios.send(2107, string.format("%d", gaugeN2LWM))
      helios.send(2108, string.format("%d", gaugeN2HWM))
      helios.send(2109, string.format("%d", gaugeNRLWM))
      helios.send(2110, string.format("%d", gaugeNRHWM))
	else
      helios.send(2103, string.format("%30s", ""))
      helios.send(2104, string.format("%30s", ""))
      helios.send(2107, string.format("%d", 0))
      helios.send(2108, string.format("%d", 0))
      helios.send(2109, string.format("%d", 0))
      helios.send(2110, string.format("%d", 0))
   end
	
    -- Engine Temp and Torque Gauge
    li = helios.parseIndication(6)
    if li then
		local gaugeTemp = string.format("%29s", "")
		local gaugeTempHWM = 0
		local gaugeTempLWM = 0

		local gaugeTorque = string.format("%29s", "")
		local gaugeTorqueHWM = 0
		local gaugeTorqueLWM = 0

	  for v, vv in pairs(li) do
		if v and v ~= ""  and v ~= "." then
			if v:find("segment") ~= nil then
    			v =  v:gsub("segment","")
    			local seg = tonumber(v:sub(3))
    			if v:sub(1,1) == "L" then
    			  gaugeTemp = gaugeTemp:sub(1, seg-1) .. "*" .. gaugeTemp:sub(seg+1)
 				  if gaugeTempHWM < seg then gaugeTempHWM = seg end
				  if gaugeTempLWM > seg then gaugeTempLWM = seg end
    			else
    			  gaugeTorque = gaugeTorque:sub(1, seg-1) .. "*" .. gaugeTorque:sub(seg+1)
				  if gaugeTorqueHWM < seg then gaugeTorqueHWM = seg end
				  if gaugeTorqueLWM > seg then gaugeTorqueLWM = seg end
    			end
			elseif v == "IND_TEMP" then  -- this requires a patch to mods\aircraft\AH-6J\Cockpit\Scripts\VDI_Torque\base_page.lua
				helios.send(2117, string.format("%s", helios.ensureString(vv):gsub(":", "!")))
			elseif v == "TORQUE_PSI" then  -- this requires a patch to mods\aircraft\AH-6J\Cockpit\Scripts\VDI_Torque\base_page.lua 
				helios.send(2118, string.format("%s", helios.ensureString(vv):gsub(":", "!")))
			else
			end
		end
	  end	
      helios.send(2111, string.format("%s", helios.ensureString(gaugeTemp):gsub(":", "!")))
      helios.send(2112, string.format("%s", helios.ensureString(gaugeTorque):gsub(":", "!")))
      helios.send(2113, string.format("%d", gaugeTempLWM))
      helios.send(2114, string.format("%d", gaugeTempHWM))
      helios.send(2115, string.format("%d", gaugeTorqueLWM))
      helios.send(2116, string.format("%d", gaugeTorqueHWM))
	else
      helios.send(2111, string.format("%29s", ""))
      helios.send(2112, string.format("%29s", ""))
      helios.send(2113, string.format("%d", 0))
      helios.send(2114, string.format("%d", 0))
      helios.send(2115, string.format("%d", 0))
      helios.send(2115, string.format("%d", 0))
    end
	
    -- Bearing / Range
    li = helios.parseIndication(10)
    if li then
	  for _, v in pairs(li) do
		if v and v ~= ""  and v ~= "." then
			helios.send(2100, string.format("%3s", helios.ensureString(v):gsub(":", "!")))
			break
		end
	  end	
	else
	        helios.send(2100, "   ")
    end
	--TNL3100
    li = helios.parseIndication(11) 
    if li then
	        helios.send(2101, string.format("%20s", helios.ensureString(li.TNL3100Text1):gsub(":", "!")))
	        helios.send(2102, string.format("%20s", helios.ensureString(li.TNL3100Text2):gsub(":", "!")))
	else
	        helios.send(2101, string.format("%20s", ""))
	        helios.send(2102, string.format("%20s", ""))
    end
	-- Barometric Altimeter
	helios.send(2122, string.format("%.0f", (math.floor(mainPanelDevice:get_argument_value(326)*10)*10000) + (math.floor(mainPanelDevice:get_argument_value(325)*10)*1000) + math.floor(mainPanelDevice:get_argument_value(324)*1000)))  -- Altitude
end