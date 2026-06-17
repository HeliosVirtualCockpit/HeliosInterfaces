--[[
Contributed by NoNoBearDuNord 10th Dec 2025
]]
-- Liste des ID ajoutés ========================================================================================
-- APR36 =======================================================================================================
-- 3074 :etat voyant 6
-- 3075 :etat voyant 1
-- 3076 :etat voyant 3
-- 3077 :etat voyant 7
-- 3078 :etat voyant 8
-- HSI =========================================================================================================
-- 3079 : position angulaire absolue marqueur
-- 3080 : position angulaire absolu disque
-- 3083 : clone de 3080
-- IAS =========================================================================================================
-- 3081 : rotation absolu graduation mach
-- 3082 : rotation absolu marqueur mach
-- WSO BDHI ====================================================================================================
-- 3085 (951): rotation absolue needle 2 (seule needle 2 est en relatif par rapport au disque)
-- =============================================================================================================
-- =============================================================================================================
-- ID que je réserve aux commandes JESTER et PILOT
-- 3100 à 3300
-- =============================================================================================================
-- =============================================================================================================
-- AOA voyant indicator ========================================================================================
-- Affichage distance cible
-- 8100 : texte distance range
-- Affichage canal UHF
-- 8101 : texte canal UHF pilot
-- 8102 : texte canal UHF WSO
-- 8103 : texte minutes WSO
-- =============================================================================================================

function driver.processHighImportance(mainPanelDevice)
	-- called at configured update rate
	-- Gestion des voyants qui ne s'éteignent pas ==============================================================
	-- APR36 ----------------------------------------- gestion des voyant qui ne s'éteignent pas quand power OFF
	local power
	local etat_v1, etat_v3, etat_v6, etat_v7,etat_v8
	power = mainPanelDevice:get_argument_value(2546)  -- etat du voyant power
	etat_v1 = mainPanelDevice:get_argument_value(2537)  -- etat du voyant bas du bouton 1
	etat_v3 = mainPanelDevice:get_argument_value(2539)  -- etat du voyant bas du bouton 3
	etat_v6 = mainPanelDevice:get_argument_value(2542)  -- etat du voyant bas du bouton 6
	etat_v7 = mainPanelDevice:get_argument_value(2543)  -- etat du voyant du bouton 7
	etat_v8 = mainPanelDevice:get_argument_value(2544)  -- etat du voyant bas du bouton 8
	if (power > 0) then
		helios.send(3075, string.format("%.3f", etat_v1 ))
		helios.send(3076, string.format("%.3f", etat_v3 ))
		helios.send(3074, string.format("%.3f", etat_v6 ))
		helios.send(3077, string.format("%.3f", etat_v7 ))
		helios.send(3078, string.format("%.3f", etat_v8 ))
	else
		helios.send(3075, string.format("%.3f", 0.5 ))  -- on force éteint B1
		helios.send(3076, string.format("%.3f", 0.5 ))  -- on force éteint B3
		helios.send(3074, string.format("%.3f", 0.5 ))  -- on force éteint B6
		helios.send(3077, string.format("%.3f", 0.5 ))  -- on force éteint B7
		helios.send(3078, string.format("%.3f", 0.5 ))  -- on force éteint B8
	end
	
	
	-- =========================================================================================================
	-- Badin nono
	local rot_abs3, rot_disque, rot_index, rot_grad, rot_grad_corr, rot_abs4
	rot_disque = mainPanelDevice:get_argument_value(102)	-- disque central IAS
	rot_index = mainPanelDevice:get_argument_value(105)		-- triangle indicateur Mac
	rot_grad = mainPanelDevice:get_argument_value(103)		-- graduation ext rotative
	-- Relation ci-dessous obtenue par interpolation linéaire à partir des valeurs des IF de usagi
	rot_grad_corr = 0.7675 * rot_grad - 0.002
	rot_abs3 = math.fmod(( rot_disque + (1 - rot_grad_corr)),1.000)	-- rotation absolue graduation ext rotative
	helios.send(3081, string.format("%.3f", rot_abs3 ))
	rot_abs4 = math.fmod(( rot_disque + rot_index - rot_grad),1.000)
	--helios.send(3082, string.format("%.4f", rot_abs4 ))
	
	-- Calculate proper movement combining rotation of the mach dial with
    -- offset of the mach marker bug so that it works with scale of 0...1
    -- in Helios giving full 360 degree movement when required.
    --   Mach Scale          2.5     2.0     1.6     1.2     1.0     0.8     0.7     0.6     0.5     0.4     dot
    local calculated, fullMovement
	--local array dcsValues = {1.0,  0.8729, 0.7501, 0.5848, 0.4769, 0.3540, 0.2878, 0.2100, 0.1206, 0.0152, 0.0 }
    --local array HeliosValues = { 0.768, 0.671, 0.573, 0.443, 0.359, 0.264, 0.211, 0.154, 0.086, 0.006, 0.0 }
    --local dDCS, dHelios;    
    calibrated = 0
    rot_index = mainPanelDevice:get_argument_value(105) -- Mach marker raw value
    --if (rot_index > 0.0) and (rot_index < 1.0) then  -- limits for calculations. Make sure that first item is never matched.
        --for k,v in ipairs(dcsValues) 
        --do
            --if rot_index > v then 
                --dDCS = dcsValues[k-1] - v
                --dHelios = HeliosValues[k-1] - HeliosValues[k]
                --calibrated = ((dHelios / dDCS) * (rot_index - v)) + HeliosValues[k]
                --break;
            --end        
        --end
    --end
	--calibrated = 0.7729 * rot_index - 0.0069  -- expression initiae obtenue par interpolation
	calibrated = 0.7720 * rot_index - 0.0069	-- expression ajustée au niveau des coeff
	fullMovement = rot_disque-rot_grad_corr
    helios.send(3082, string.format("%0.4f", fullMovement+calibrated ))
	--where the FullMovement is calculated using value from mach indicator:
	--fullMovement = val-calibrated
	

	-- HSI
	local rot_abs1, rot_compas, rot_marqueur, rot_arrow, rot_abs2
	rot_compas = mainPanelDevice:get_argument_value(668)	-- on recupère la position anti trigo du compas
	rot_marqueur = mainPanelDevice:get_argument_value(672)	-- on recupere la position angulaire relative horaire du marqueur
	rot_abs1 = math.fmod(((1-rot_compas)+rot_marqueur),1)	-- on détermine la position angulaire horaire abs du marqueur modulo 1
	helios.send(3079, string.format("%.3f", rot_abs1 ))		--	on communique la position angulaire du marqueur
	rot_arrow = mainPanelDevice:get_argument_value(670)	-- on recupere la position angulaire relative horaire disque central
	rot_abs2 = math.fmod(((1-rot_compas)+rot_arrow),1)	-- on détermine la position angulaire horaire abs du disque modulo 1
	helios.send(3080, string.format("%.3f", rot_abs2 ))		--	on communique la position angulaire du disque
	-- rot_abs2 = rot_abs2 - rot_arrow
	helios.send(3083, string.format("%.3f", rot_abs2)) --	on communique la position angulaire du disque a l'axe piste
	

	-- ===========================================================================================================
	-- Gestion distance Range
	local li = helios.parseIndication(8)  -- Range Indication
	if li then
		helios.send(8100, string.format("%3s",helios.ensureString(li.range_indicator_foreground)))
	end		
	-- Gestion canal UHF radio ===================================================================================
	local li1 = helios.parseIndication(9)  -- Pilot's UHF Channel Display
	local li2 = helios.parseIndication(10)  -- Pilot's UHF Channel Display
	if li1 then
		helios.send(8101, string.format("%2s",helios.ensureString(li1.freq_foreground)))
	end
	if li2 then
		helios.send(8102, string.format("%2s",helios.ensureString(li2.freq_foreground)))
	end
	-- ============================================================================================================
	-- Affichage minutes WSO
	local li3 = helios.parseIndication(11)  -- Affichage minutes WSO
	if li3 then
		helios.send(8103, string.format("%3s",helios.ensureString(li3.minutes_foreground)))
	end
	-- ============================================================================================================
	-- WSO BDHI
	-- ============================================================================================================
	local HBDI_disque,HBDI_needle2,HBDI_needle2_corr
	HBDI_disque = mainPanelDevice:get_argument_value(949)           -- position disque gradué
	HBDI_needle2 = mainPanelDevice:get_argument_value(951)          -- position needle 2
	HBDI_needle2_corr = math.fmod(((1-HBDI_disque)+HBDI_needle2),1)
	helios.send(3085, string.format("%.3f",HBDI_needle2_corr ))     -- pos abs needle 2
	-- =============================================================================================================
end



--[[

function driver.processLowImportance(mainPanelDevice) --luacheck: no unused args
    -- same things as processHighImportance can be done here, called a few times per second at most
end

]]