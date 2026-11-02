-- Helios functions for F-16C_50
-- Stock Helios DCS.F-16C_50.hif.lua with F-16C DED and CMDS text export added.
--
-- Install: Documents\Helios\Interfaces\HeliosInterfaces\DCS.F-16C_50.hif.lua
-- together with the DCS.F-16C_50.hif.json supplied with it (same folder), then rerun the DCS setup
-- step in Helios Profile Editor so it regenerates the export driver.
--
-- Sent to Helios on the "DCS F-16C_50" interface:
--   DED Output Data / DED_LINE_1 .. DED_LINE_5   24 characters each
--   DED Output Data / DED_ALL_LINES               all 5 rows, separated by line breaks
--   CMDS / CMDS_O1_Amount                         4 characters
--   CMDS / CMDS_O2_Amount                         4 characters
--   CMDS / CMDS_CH_Amount                         4 characters
--   CMDS / CMDS_FL_Amount                         4 characters
--   UHF / UHF_CHAN_DISP                           2 characters, UHF panel CHAN display
--   UHF / UHF_FREQ_DISP                           7 characters, UHF panel frequency display
--   PFL Output Data / PFL_LINE_1 .. PFL_LINE_5    24 characters each, Pilot Fault List
--   PFL Output Data / PFL_ALL_LINES               all 5 PFL rows, separated by line breaks
-- IDs: DED 2600-2605, CMDS 2606-2609, UHF 2620-2621, PFL 2630-2635 (see the JSON).
-- ":" is sent as "!" and "=" as "-" (Helios reserves both). To show colons in a
-- Text Display tick  Use Parser  and set  Parser Info  to  !=:
--
-- The DED layout table is from DCS-BIOS
-- (Scripts/DCS-BIOS/lib/modules/displays/F_16C_DED.lua, GPL-3.0,
-- https://github.com/DCS-Skunkworks/dcs-bios). Each entry is
--     ["element name"] = { {column, row, {pages the element appears on}}, ... }

-- ============================== DED / CMDS text ===============================

local DED = {}

DED.WIDTH = 24
DED.ROWS = 5

local LAYOUT = {
	["ACAL_ALEV"]={{9,3,{"A_CAL_MAN"}}},
	["ACAL_ALT_DELTA"]={{9,4,{"A_CAL_MAN"}}},
	["ACAL_ALT_DELTA_label"]={{3,4,{"A_CAL_MAN"}}},
	["ACAL_ALT_label"]={{15,1,{"A_CAL_MAN"}}},
	["ACAL_AUTO_Sensors"]={{13,1,{"A_CAL_AUTO"}}},
	["ACAL_AUTO_Sensors_inv"]={{13,1,{"A_CAL_AUTO"}}},
	["ACAL_MODE"]={{9,2,{"A_CAL_MAN"}}},
	["ACAL_POS_DELTA"]={{9,5,{"A_CAL_MAN"}}},
	["ACAL_POS_DELTA_label"]={{3,5,{"A_CAL_MAN"}}},
	["ACAL_SENSORS"]={{2,1,{"A_CAL_MAN"}}},
	["ACAL_SelectedSensors"]={{9,1,{"A_CAL_MAN"}}},
	["ACAL_SelectedSensors_inv"]={{9,1,{"A_CAL_MAN"}}},
	["AG DL lbl"]={{8,1,{"AG_DL"}}},
	["ALOW label"]={{11,1,{"ALOW"}}},
	["ATP LASER MODE AA"]={{14,4,{"LASER"}}},
	["ATP LASER MODE AG"]={{2,4,{"LASER"}}},
	["ATP LASER MODE Asteriscs AA_lhs"]={{18,4,{"LASER"}}},
	["ATP LASER MODE Asteriscs AA_rhs"]={{23,4,{"LASER"}}},
	["ATP LASER MODE Asteriscs AG_lhs"]={{6,4,{"LASER"}}},
	["ATP LASER MODE Asteriscs AG_rhs"]={{11,4,{"LASER"}}},
	["ATP LASER MODE VALUE AA"]={{19,4,{"LASER"}}},
	["ATP LASER MODE VALUE AA_inv"]={{19,4,{"LASER"}}},
	["ATP LASER MODE VALUE AG"]={{7,4,{"LASER"}}},
	["ATP LASER MODE VALUE AG_inv"]={{7,4,{"LASER"}}},
	["AUTO_ACAL"]={{2,1,{"A_CAL_AUTO"}}},
	["Active Frequency or Channe"]={{3,2,{"COM_2"}}},
	["Active Frequency or Channel"]={{3,2,{"COM_1"}}},
	["Active Mode 3 Code"]={{10,5,{"CNI"}}},
	["Angles"]={{11,1,{"HARM"}}},
	["Asterisks on Band_lhs"]={{18,5,{"COM_1","COM_2"}}},
	["Asterisks on Band_rhs"]={{21,5,{"COM_1","COM_2"}}},
	["Asterisks on CS Name_lhs"]={{11,2,{"LINK16"}}},
	["Asterisks on CS Name_rhs"]={{14,2,{"LINK16"}}},
	["Asterisks on CS Number_lhs"]={{16,2,{"LINK16"}}},
	["Asterisks on CS Number_rhs"]={{19,2,{"LINK16"}}},
	["Asterisks on ETR_lhs"]={{9,2,{"NET_STATUS"}}},
	["Asterisks on ETR_rhs"]={{13,2,{"NET_STATUS"}}},
	["Asterisks on FC_lhs"]={{6,2,{"LINK16"}}},
	["Asterisks on FC_rhs"]={{10,2,{"LINK16"}}},
	["Asterisks on FL_lhs"]={{16,3,{"LINK16"}}},
	["Asterisks on FL_rhs"]={{20,3,{"LINK16"}}},
	["Asterisks on IPF_lhs"]={{14,2,{"NET_STATUS"}}},
	["Asterisks on IPF_rhs"]={{24,2,{"NET_STATUS"}}},
	["Asterisks on MC_lhs"]={{6,3,{"LINK16"}}},
	["Asterisks on MC_rhs"]={{10,3,{"LINK16"}}},
	["Asterisks on NTR_lhs"]={{9,4,{"NET_STATUS"}}},
	["Asterisks on NTR_rhs"]={{13,4,{"NET_STATUS"}}},
	["Asterisks on Own_lhs"]={{22,3,{"LINK16_STN"}}},
	["Asterisks on Own_rhs"]={{24,3,{"LINK16_STN"}}},
	["Asterisks on PresetChannel_lhs"]={{7,4,{"COM_1","COM_2"}}},
	["Asterisks on PresetChannel_rhs"]={{10,4,{"COM_1","COM_2"}}},
	["Asterisks on PresetFrequency_lhs"]={{5,5,{"COM_1","COM_2"}}},
	["Asterisks on PresetFrequency_rhs"]={{12,5,{"COM_1","COM_2"}}},
	["Asterisks on RESET_lhs"]={{6,4,{"NAV_COMMANDS"}}},
	["Asterisks on RESET_rhs"]={{18,4,{"NAV_COMMANDS"}}},
	["Asterisks on SC_lhs"]={{6,4,{"LINK16"}}},
	["Asterisks on SC_rhs"]={{10,4,{"LINK16"}}},
	["Asterisks on STN TDOA_1_lhs"]={{2,2,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_1_rhs"]={{4,2,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_2_lhs"]={{2,3,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_2_rhs"]={{4,3,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_3_lhs"]={{2,4,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_3_rhs"]={{4,4,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_4_lhs"]={{2,5,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_4_rhs"]={{4,5,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_5_lhs"]={{12,2,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_5_rhs"]={{14,2,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_6_lhs"]={{12,3,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_6_rhs"]={{14,3,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_7_lhs"]={{12,4,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_7_rhs"]={{14,4,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_8_lhs"]={{12,5,{"LINK16_STN"}}},
	["Asterisks on STN TDOA_8_rhs"]={{14,5,{"LINK16_STN"}}},
	["Asterisks on STN_1_lhs"]={{4,2,{"LINK16_STN"}}},
	["Asterisks on STN_1_rhs"]={{10,2,{"LINK16_STN"}}},
	["Asterisks on STN_2_lhs"]={{4,3,{"LINK16_STN"}}},
	["Asterisks on STN_2_rhs"]={{10,3,{"LINK16_STN"}}},
	["Asterisks on STN_3_lhs"]={{4,4,{"LINK16_STN"}}},
	["Asterisks on STN_3_rhs"]={{10,4,{"LINK16_STN"}}},
	["Asterisks on STN_4_lhs"]={{4,5,{"LINK16_STN"}}},
	["Asterisks on STN_4_rhs"]={{10,5,{"LINK16_STN"}}},
	["Asterisks on STN_5_lhs"]={{14,2,{"LINK16_STN"}}},
	["Asterisks on STN_5_rhs"]={{20,2,{"LINK16_STN"}}},
	["Asterisks on STN_6_lhs"]={{14,3,{"LINK16_STN"}}},
	["Asterisks on STN_6_rhs"]={{20,3,{"LINK16_STN"}}},
	["Asterisks on STN_7_lhs"]={{14,4,{"LINK16_STN"}}},
	["Asterisks on STN_7_rhs"]={{20,4,{"LINK16_STN"}}},
	["Asterisks on STN_8_lhs"]={{14,5,{"LINK16_STN"}}},
	["Asterisks on STN_8_rhs"]={{20,5,{"LINK16_STN"}}},
	["Asterisks on SYNC_lhs"]={{9,5,{"NET_STATUS"}}},
	["Asterisks on SYNC_rhs"]={{16,5,{"NET_STATUS"}}},
	["Asterisks on Scratchpad_lhs"]={{14,3,{"COM_1","COM_2"}},{16,3,{"INS_INFLT_ALGN"}},{12,4,{"NAV_STATUS"}}},
	["Asterisks on Scratchpad_rhs"]={{21,3,{"COM_1","COM_2","INS_INFLT_ALGN"}},{15,4,{"NAV_STATUS"}}},
	["Asterisks on TIME_lhs"]={{9,3,{"NET_STATUS"}}},
	["Asterisks on TIME_rhs"]={{18,3,{"NET_STATUS"}}},
	["Asterisks on XMT_lhs"]={{16,4,{"LINK16"}}},
	["Asterisks on XMT_rhs"]={{21,4,{"LINK16"}}},
	["Asterisks on ZEROIZE_lhs"]={{6,5,{"NAV_COMMANDS"}}},
	["Asterisks on ZEROIZE_rhs"]={{18,5,{"NAV_COMMANDS"}}},
	["Asterisks_ACAL_SENSORS_lhs"]={{8,1,{"A_CAL_MAN"}}},
	["Asterisks_ACAL_SENSORS_rhs"]={{13,1,{"A_CAL_MAN"}}},
	["Asterisks_ACAL_SelectedMode_lhs"]={{8,2,{"A_CAL_MAN"}}},
	["Asterisks_ACAL_SelectedMode_rhs"]={{13,2,{"A_CAL_MAN"}}},
	["Asterisks_AUTO_lhs"]={{12,1,{"A_CAL_AUTO"}}},
	["Asterisks_AUTO_rhs"]={{17,1,{"A_CAL_AUTO"}}},
	["Asterisks_AZ_ELAZ_EL_lhs"]={{2,3,{"HMCS_ALIGN"}}},
	["Asterisks_AZ_ELAZ_EL_rhs"]={{8,3,{"HMCS_ALIGN"}}},
	["Asterisks_BRG_lhs"]={{8,4,{"DEST_OA1","DEST_OA2"}}},
	["Asterisks_BRG_rhs"]={{15,4,{"DEST_OA1","DEST_OA2"}}},
	["Asterisks_CKPT_BLANK_lhs"]={{2,3,{"HMCS_DISPLAY"}}},
	["Asterisks_CKPT_BLANK_rhs"]={{12,3,{"HMCS_DISPLAY"}}},
	["Asterisks_CNVRT_lhs"]={{18,2,{"DEST_UTM_DIR"}}},
	["Asterisks_CNVRT_rhs"]={{24,2,{"DEST_UTM_DIR"}}},
	["Asterisks_COARSE_lhs"]={{2,2,{"HMCS_ALIGN"}}},
	["Asterisks_COARSE_rhs"]={{9,2,{"HMCS_ALIGN"}}},
	["Asterisks_DECLUTTER_lhs"]={{12,4,{"HMCS_DISPLAY"}}},
	["Asterisks_DECLUTTER_rhs"]={{18,4,{"HMCS_DISPLAY"}}},
	["Asterisks_DES_TOS_lhs"]={{12,3,{"CRUS_TOS"}}},
	["Asterisks_DES_TOS_rhs"]={{22,3,{"CRUS_TOS"}}},
	["Asterisks_EAST/NORTH_lhs"]={{12,4,{"DEST_UTM_DIR"}}},
	["Asterisks_EAST/NORTH_rhs"]={{24,4,{"DEST_UTM_DIR"}}},
	["Asterisks_ELEV_lhs"]={{16,3,{"A_CAL_MAN"}},{8,4,{"DEST_DIR"}},{8,5,{"DEST_OA1","DEST_OA2"}},{12,5,{"DEST_UTM_DIR"}}},
	["Asterisks_ELEV_rhs"]={{24,3,{"A_CAL_MAN"}},{16,4,{"DEST_DIR"}},{17,5,{"DEST_OA1","DEST_OA2"}},{20,5,{"DEST_UTM_DIR"}}},
	["Asterisks_FIX_SENSORS_lhs"]={{11,1,{"FIX"}}},
	["Asterisks_FIX_SENSORS_rhs"]={{16,1,{"FIX"}}},
	["Asterisks_GRID_DIGIT_lhs"]={{12,2,{"DEST_UTM_DIR"}}},
	["Asterisks_GRID_DIGIT_rhs"]={{16,2,{"DEST_UTM_DIR"}}},
	["Asterisks_GRID_SYMBOL_lhs"]={{12,2,{"DEST_UTM_DIR"}}},
	["Asterisks_GRID_SYMBOL_rhs"]={{16,2,{"DEST_UTM_DIR"}}},
	["Asterisks_HOME_STPT_NUM_lhs"]={{12,2,{"CRUS_HOME"}}},
	["Asterisks_HOME_STPT_NUM_rhs"]={{18,2,{"CRUS_HOME"}}},
	["Asterisks_HUD_BLANK_lhs"]={{2,2,{"HMCS_DISPLAY"}}},
	["Asterisks_HUD_BLANK_rhs"]={{11,2,{"HMCS_DISPLAY"}}},
	["Asterisks_LAT_lhs"]={{8,2,{"DEST_DIR"}}},
	["Asterisks_LAT_rhs"]={{21,2,{"DEST_DIR"}}},
	["Asterisks_LON_lhs"]={{8,3,{"DEST_DIR"}}},
	["Asterisks_LON_rhs"]={{21,3,{"DEST_DIR"}}},
	["Asterisks_NUM_STEERPOINT_lhs"]={{12,1,{"DEST_DIR","DEST_UTM_DIR"}},{11,1,{"DEST_OA1","DEST_OA2"}}},
	["Asterisks_NUM_STEERPOINT_rhs"]={{16,1,{"DEST_DIR","DEST_UTM_DIR"}},{15,1,{"DEST_OA1","DEST_OA2"}}},
	["Asterisks_RNG_MODE_lhs"]={{13,1,{"CRUS_EDR","CRUS_HOME","CRUS_RNG"}}},
	["Asterisks_RNG_MODE_rhs"]={{17,1,{"CRUS_EDR","CRUS_RNG"}},{18,1,{"CRUS_HOME"}}},
	["Asterisks_RNG_lhs"]={{8,3,{"DEST_OA1","DEST_OA2"}}},
	["Asterisks_RNG_rhs"]={{17,3,{"DEST_OA1","DEST_OA2"}}},
	["Asterisks_ROLL_lhs"]={{2,4,{"HMCS_ALIGN"}}},
	["Asterisks_ROLL_rhs"]={{7,4,{"HMCS_ALIGN"}}},
	["Asterisks_RWR_DISPLAY_lhs"]={{12,5,{"HMCS_DISPLAY"}}},
	["Asterisks_RWR_DISPLAY_rhs"]={{16,5,{"HMCS_DISPLAY"}}},
	["Asterisks_SQUARE2_lhs"]={{12,3,{"DEST_UTM_DIR"}}},
	["Asterisks_SQUARE2_rhs"]={{15,3,{"DEST_UTM_DIR"}}},
	["Asterisks_SQUARE_lhs"]={{12,3,{"DEST_UTM_DIR"}}},
	["Asterisks_SQUARE_rhs"]={{15,3,{"DEST_UTM_DIR"}}},
	["Asterisks_STPT_NUMBER_lhs"]={{10,2,{"FIX"}}},
	["Asterisks_STPT_NUMBER_rhs"]={{14,2,{"FIX"}}},
	["Asterisks_T1_lhs"]={{18,1,{"HARM"}},{3,2,{"HTS_MAN"}}},
	["Asterisks_T1_rhs"]={{22,1,{"HARM"}},{8,2,{"HTS_MAN"}}},
	["Asterisks_T2_lhs"]={{18,2,{"HARM"}},{3,3,{"HTS_MAN"}}},
	["Asterisks_T2_rhs"]={{22,2,{"HARM"}},{8,3,{"HTS_MAN"}}},
	["Asterisks_T3_lhs"]={{18,3,{"HARM"}},{3,4,{"HTS_MAN"}}},
	["Asterisks_T3_rhs"]={{22,3,{"HARM"}},{8,4,{"HTS_MAN"}}},
	["Asterisks_T4_lhs"]={{18,4,{"HARM"}},{3,5,{"HTS_MAN"}}},
	["Asterisks_T4_rhs"]={{22,4,{"HARM"}},{8,5,{"HTS_MAN"}}},
	["Asterisks_T5_lhs"]={{18,5,{"HARM"}},{12,2,{"HTS_MAN"}}},
	["Asterisks_T5_rhs"]={{22,5,{"HARM"}},{17,2,{"HTS_MAN"}}},
	["Asterisks_T6_lhs"]={{12,3,{"HTS_MAN"}}},
	["Asterisks_T6_rhs"]={{17,3,{"HTS_MAN"}}},
	["Asterisks_T7_lhs"]={{12,4,{"HTS_MAN"}}},
	["Asterisks_T7_rhs"]={{17,4,{"HTS_MAN"}}},
	["Asterisks_T8_lhs"]={{12,5,{"HTS_MAN"}}},
	["Asterisks_T8_rhs"]={{17,5,{"HTS_MAN"}}},
	["Asterisks_TOS_MODE_lhs"]={{13,1,{"CRUS_TOS"}}},
	["Asterisks_TOS_MODE_rhs"]={{17,1,{"CRUS_TOS"}}},
	["Asterisks_TOS_lhs"]={{8,5,{"DEST_DIR"}}},
	["Asterisks_TOS_rhs"]={{18,5,{"DEST_DIR"}}},
	["Asterisks_lhs"]={{16,3,{"NAV_COMMANDS"}}},
	["Asterisks_on_DATE_lhs"]={{13,5,{"TIME"}}},
	["Asterisks_on_DATE_rhs"]={{22,5,{"TIME"}}},
	["Asterisks_on_DELTA_TOS_lhs"]={{12,4,{"TIME"}}},
	["Asterisks_on_DELTA_TOS_rhs"]={{22,4,{"TIME"}}},
	["Asterisks_on_HACK_lhs"]={{13,3,{"TIME"}}},
	["Asterisks_on_HACK_rhs"]={{22,3,{"TIME"}}},
	["Asterisks_on_LAT_Scratchpad_lhs"]={{7,2,{"INS"}}},
	["Asterisks_on_LAT_Scratchpad_rhs"]={{18,2,{"INS"}}},
	["Asterisks_on_LNG_Scratchpad_lhs"]={{7,3,{"INS"}}},
	["Asterisks_on_LNG_Scratchpad_rhs"]={{18,3,{"INS"}}},
	["Asterisks_on_MAGV_Mode_lhs"]={{13,1,{"MAGV"}}},
	["Asterisks_on_MAGV_Mode_rhs"]={{18,1,{"MAGV"}}},
	["Asterisks_on_MAGV_Scratchpad_lhs"]={{9,3,{"MAGV"}}},
	["Asterisks_on_MAGV_Scratchpad_rhs"]={{16,3,{"MAGV"}}},
	["Asterisks_on_SALT_Scratchpad_lhs"]={{8,4,{"INS"}}},
	["Asterisks_on_SALT_Scratchpad_rhs"]={{16,4,{"INS"}}},
	["Asterisks_on_SYSTEM_lhs"]={{13,2,{"TIME"}}},
	["Asterisks_on_SYSTEM_rhs"]={{22,2,{"TIME"}}},
	["Asterisks_on_THDG_Scratchpad_lhs"]={{7,5,{"INS"}}},
	["Asterisks_on_THDG_Scratchpad_rhs"]={{14,5,{"INS"}}},
	["Asterisks_rhs"]={{21,3,{"NAV_COMMANDS"}}},
	["BACKUP label"]={{10,3,{"IFF_BACKUP"}}},
	["BACKUP lbl"]={{3,4,{"T_ILS_BACKUP"}}},
	["BINGO Asterisks_lhs"]={{11,3,{"BINGO"}}},
	["BINGO Asterisks_rhs"]={{20,3,{"BINGO"}}},
	["BINGO IncDecSymbol"]={{24,1,{"BINGO"}}},
	["BINGO STPT Num"]={{21,1,{"BINGO"}}},
	["BINGO Scratchpad"]={{12,3,{"BINGO"}}},
	["BINGO Scratchpad_inv"]={{12,3,{"BINGO"}}},
	["BINGO label"]={{10,1,{"BINGO"}}},
	["BRG"]={{9,4,{"DEST_OA1","DEST_OA2"}}},
	["BRG_inv"]={{9,4,{"DEST_OA1","DEST_OA2"}}},
	["BULL POINT LABEL"]={{7,2,{"BULLSEYE"}}},
	["BULLSEYE IncDecSymbol"]={{17,2,{"BULLSEYE"}}},
	["BULLSEYE LABEL"]={{7,1,{"BULLSEYE"}}},
	["BULLSEYE LABEL Asteriscs_lhs"]={{6,1,{"BULLSEYE"}}},
	["BULLSEYE LABEL Asteriscs_rhs"]={{15,1,{"BULLSEYE"}}},
	["BULLSEYE LABEL_inv"]={{7,1,{"BULLSEYE"}}},
	["BULLSEYE NUMBER"]={{13,2,{"BULLSEYE"}}},
	["BULLSEYE NUMBER_inv"]={{13,2,{"BULLSEYE"}}},
	["BULLSEYE SEQUENCE Asteriscs_lhs"]={{12,2,{"BULLSEYE"}}},
	["BULLSEYE SEQUENCE Asteriscs_rhs"]={{16,2,{"BULLSEYE"}}},
	["Bandwidth"]={{19,5,{"COM_1","COM_2"}}},
	["Bandwidth_inv"]={{19,5,{"COM_1","COM_2"}}},
	["CARA ALOW Asterisks_lhs"]={{15,3,{"ALOW"}}},
	["CARA ALOW Asterisks_rhs"]={{23,3,{"ALOW"}}},
	["CARA ALOW Scratchpad"]={{16,3,{"ALOW"}}},
	["CARA ALOW Scratchpad_inv"]={{16,3,{"ALOW"}}},
	["CARA ALOW label"]={{4,3,{"ALOW"}}},
	["CMDS_BINGO_Asterisks_lhs"]={{19,5,{"CMDS_BINGO"}}},
	["CMDS_BINGO_Asterisks_rhs"]={{23,5,{"CMDS_BINGO"}}},
	["CMDS_BINGO_label"]={{6,1,{"CMDS_BINGO"}}},
	["CMDS_BINGO_lbl"]={{12,5,{"CMDS_BINGO"}}},
	["CMDS_BINGO_value"]={{20,5,{"CMDS_BINGO"}}},
	["CMDS_BINGO_value_inv"]={{20,5,{"CMDS_BINGO"}}},
	["CMDS_BI_Asterisks_lhs"]={{10,3,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_BI_Asterisks_rhs"]={{17,3,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_BI_Scratchpad"]={{11,3,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_BI_Scratchpad_inv"]={{11,3,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_BI_lbl"]={{7,3,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_BQ_Asterisks_lhs"]={{10,2,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_BQ_Asterisks_rhs"]={{13,2,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_BQ_Scratchpad"]={{11,2,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_BQ_Scratchpad_inv"]={{11,2,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_BQ_lbl"]={{7,2,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_CHAFF_label"]={{3,1,{"CMDS_CHAFF"}}},
	["CMDS_CH_Asterisks_lhs"]={{7,2,{"CMDS_BINGO"}}},
	["CMDS_CH_Asterisks_rhs"]={{10,2,{"CMDS_BINGO"}}},
	["CMDS_CH_Scratchpad"]={{8,2,{"CMDS_BINGO"}}},
	["CMDS_CH_Scratchpad_inv"]={{8,2,{"CMDS_BINGO"}}},
	["CMDS_CH_lbl"]={{3,2,{"CMDS_BINGO"}}},
	["CMDS_FDBK_Asterisks_lhs"]={{19,3,{"CMDS_BINGO"}}},
	["CMDS_FDBK_Asterisks_rhs"]={{23,3,{"CMDS_BINGO"}}},
	["CMDS_FDBK_lbl"]={{12,3,{"CMDS_BINGO"}}},
	["CMDS_FDBK_value"]={{20,3,{"CMDS_BINGO"}}},
	["CMDS_FDBK_value_inv"]={{20,3,{"CMDS_BINGO"}}},
	["CMDS_FLARE_label"]={{3,1,{"CMDS_FLARE"}}},
	["CMDS_FL_Asterisks_lhs"]={{7,3,{"CMDS_BINGO"}}},
	["CMDS_FL_Asterisks_rhs"]={{10,3,{"CMDS_BINGO"}}},
	["CMDS_FL_Scratchpad"]={{8,3,{"CMDS_BINGO"}}},
	["CMDS_FL_Scratchpad_inv"]={{8,3,{"CMDS_BINGO"}}},
	["CMDS_FL_lbl"]={{3,3,{"CMDS_BINGO"}}},
	["CMDS_O1_Asterisks_lhs"]={{7,4,{"CMDS_BINGO"}}},
	["CMDS_O1_Asterisks_rhs"]={{10,4,{"CMDS_BINGO"}}},
	["CMDS_O1_Scratchpad"]={{8,4,{"CMDS_BINGO"}}},
	["CMDS_O1_Scratchpad_inv"]={{8,4,{"CMDS_BINGO"}}},
	["CMDS_O1_lbl"]={{3,4,{"CMDS_BINGO"}}},
	["CMDS_O2_Asterisks_lhs"]={{7,5,{"CMDS_BINGO"}}},
	["CMDS_O2_Asterisks_rhs"]={{10,5,{"CMDS_BINGO"}}},
	["CMDS_O2_Scratchpad"]={{8,5,{"CMDS_BINGO"}}},
	["CMDS_O2_Scratchpad_inv"]={{8,5,{"CMDS_BINGO"}}},
	["CMDS_O2_lbl"]={{3,5,{"CMDS_BINGO"}}},
	["CMDS_OTHER1_label"]={{3,1,{"CMDS_OTHER_1"}}},
	["CMDS_OTHER2_label"]={{3,1,{"CMDS_OTHER_2"}}},
	["CMDS_Prog_IncDecSymbol"]={{24,1,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_Prog_label"]={{16,1,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_REQCTR_Asterisks_lhs"]={{19,4,{"CMDS_BINGO"}}},
	["CMDS_REQCTR_Asterisks_rhs"]={{23,4,{"CMDS_BINGO"}}},
	["CMDS_REQCTR_lbl"]={{12,4,{"CMDS_BINGO"}}},
	["CMDS_REQCTR_value"]={{20,4,{"CMDS_BINGO"}}},
	["CMDS_REQCTR_value_inv"]={{20,4,{"CMDS_BINGO"}}},
	["CMDS_SI_Asterisks_lhs"]={{10,5,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_SI_Asterisks_rhs"]={{17,5,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_SI_Scratchpad"]={{11,5,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_SI_Scratchpad_inv"]={{11,5,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_SI_lbl"]={{7,5,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_SQ_Asterisks_lhs"]={{10,4,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_SQ_Asterisks_rhs"]={{13,4,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_SQ_Scratchpad"]={{11,4,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_SQ_Scratchpad_inv"]={{11,4,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_SQ_lbl"]={{7,4,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["CMDS_Selected_Program"]={{22,1,{"CMDS_CHAFF","CMDS_COMMON","CMDS_FLARE","CMDS_OTHER_1","CMDS_OTHER_2"}}},
	["COM 1 Mode"]={{6,1,{"COM_1"}},{9,1,{"COM_1_GUARD"}}},
	["COM 1 Power Status"]={{14,1,{"COM_1_GUARD"}}},
	["COM 2 Mode"]={{9,1,{"COM_2"}}},
	["COM 2 Receiver Band"]={{9,3,{"COM_2_GUARD"}}},
	["COM 2 Receiver Mode"]={{14,1,{"COM_2_GUARD"}}},
	["COMM lbl"]={{13,2,{"AG_DL"}},{14,2,{"INTRAFLIGHT"}}},
	["COMM status"]={{18,2,{"AG_DL"}},{19,2,{"INTRAFLIGHT"}}},
	["CRUS_MODE"]={{8,1,{"CRUS_COMMON","CRUS_EDR","CRUS_HOME","CRUS_RNG","CRUS_TOS"}}},
	["CallSign Name char1"]={{12,2,{"LINK16"}}},
	["CallSign Name char1_inv"]={{12,2,{"LINK16"}}},
	["CallSign Name char2"]={{13,2,{"LINK16"}}},
	["CallSign Name char2_inv"]={{13,2,{"LINK16"}}},
	["CallSign Number"]={{17,2,{"LINK16"}}},
	["CallSign Number_inv"]={{17,2,{"LINK16"}}},
	["Code Group State"]={{23,1,{"IFF_MAIN_TIM"}}},
	["DATA lbl"]={{13,3,{"AG_DL"}},{14,3,{"INTRAFLIGHT"}}},
	["DATA status"]={{18,3,{"AG_DL"}},{19,3,{"INTRAFLIGHT"}}},
	["DATE_FORMAT_label"]={{3,5,{"TIME"}}},
	["DATE_value"]={{14,5,{"TIME"}}},
	["DATE_value_inv"]={{14,5,{"TIME"}}},
	["DAYS label"]={{17,4,{"NAV_STATUS"}}},
	["DELTA"]={{14,3,{"FIX"}}},
	["DELTA_ALT"]={{17,4,{"A_CAL_MAN"}}},
	["DELTA_POS"]={{17,5,{"A_CAL_MAN"}}},
	["DELTA_TOS_label"]={{2,4,{"TIME"}}},
	["DELTA_TOS_value"]={{13,4,{"TIME"}}},
	["DELTA_TOS_value_inv"]={{13,4,{"TIME"}}},
	["DEST_DIR"]={{3,1,{"DEST_DIR"}}},
	["DEST_DIR_STPT_IncDecSymbol"]={{17,1,{"DEST_DIR"}}},
	["DEST_DIR_SelectedSteerpoint"]={{13,1,{"DEST_DIR"}}},
	["DEST_DIR_SelectedSteerpoint_inv"]={{13,1,{"DEST_DIR"}}},
	["DEST_ELEV"]={{3,4,{"DEST_DIR"}}},
	["DEST_LAT"]={{4,2,{"DEST_DIR"}}},
	["DEST_LON"]={{4,3,{"DEST_DIR"}}},
	["DEST_OA1"]={{3,1,{"DEST_OA1"}}},
	["DEST_OA1_BRG"]={{4,4,{"DEST_OA1"}}},
	["DEST_OA1_ELEV"]={{3,5,{"DEST_OA1"}}},
	["DEST_OA1_RNG"]={{4,3,{"DEST_OA1"}}},
	["DEST_OA1_STPT_IncDecSymbol"]={{16,1,{"DEST_OA1"}}},
	["DEST_OA1_SelectedSteerpoint"]={{12,1,{"DEST_OA1"}}},
	["DEST_OA1_SelectedSteerpoint_inv"]={{12,1,{"DEST_OA1"}}},
	["DEST_OA2"]={{3,1,{"DEST_OA2"}}},
	["DEST_OA2_BRG"]={{4,4,{"DEST_OA2"}}},
	["DEST_OA2_ELEV"]={{3,5,{"DEST_OA2"}}},
	["DEST_OA2_RNG"]={{4,3,{"DEST_OA2"}}},
	["DEST_OA2_STPT_IncDecSymbol"]={{16,1,{"DEST_OA2"}}},
	["DEST_OA2_SelectedSteerpoint"]={{12,1,{"DEST_OA2"}}},
	["DEST_OA2_SelectedSteerpoint_inv"]={{12,1,{"DEST_OA2"}}},
	["DEST_TOS"]={{4,5,{"DEST_DIR"}}},
	["DTS_ACCURACY_HPU_label"]={{22,4,{"A_CAL_AUTO"}}},
	["DTS_ACCURACY_HPU_value"]={{24,4,{"A_CAL_AUTO"}}},
	["DTS_ACCURACY_VPU_label"]={{22,5,{"A_CAL_AUTO"}}},
	["DTS_ACCURACY_VPU_value"]={{24,5,{"A_CAL_AUTO"}}},
	["DTS_STATUS_label"]={{10,4,{"A_CAL_AUTO"}}},
	["DTS_STATUS_value"]={{15,4,{"A_CAL_AUTO"}}},
	["Default Value Indication"]={{12,2,{"CNI"}}},
	["EAST/NORTH"]={{13,4,{"DEST_UTM_DIR"}}},
	["EAST/NORTH_inv"]={{13,4,{"DEST_UTM_DIR"}}},
	["EDR_INS_STPT_IncDecSymbol"]={{17,2,{"CRUS_EDR"}}},
	["EDR_INS_SelectedSteerpoint"]={{13,2,{"CRUS_EDR"}}},
	["EDR_MODE"]={{14,1,{"CRUS_EDR"}}},
	["EDR_MODE_inv"]={{14,1,{"CRUS_EDR"}}},
	["EDR_OPT_MACH_label"]={{4,4,{"CRUS_EDR"}}},
	["EDR_OPT_MACH_value"]={{14,4,{"CRUS_EDR"}}},
	["EDR_STPT_NUM"]={{8,2,{"CRUS_EDR"}}},
	["EDR_TO_BINGO_label"]={{5,3,{"CRUS_EDR"}}},
	["EDR_TO_BINGO_value"]={{14,3,{"CRUS_EDR"}}},
	["EDR_WIND_AT_ALTITUDE"]={{8,5,{"CRUS_EDR"}}},
	["EDR_WIND_AT_ALTITUDE_Value"]={{14,5,{"CRUS_EDR"}}},
	["ELEV"]={{17,3,{"A_CAL_MAN"}},{9,4,{"DEST_DIR"}},{9,5,{"DEST_OA1","DEST_OA2"}},{13,5,{"DEST_UTM_DIR"}}},
	["ELEV_inv"]={{17,3,{"A_CAL_MAN"}},{9,4,{"DEST_DIR"}},{9,5,{"DEST_OA1","DEST_OA2"}},{13,5,{"DEST_UTM_DIR"}}},
	["EVENT - Time"]={{19,4,{"IFF_MAIN_TIM"}}},
	["Elevation"]={{5,5,{"VIP","VRP"}}},
	["Elevation Asteriscs_lhs"]={{10,5,{"VIP","VRP"}}},
	["Elevation Asteriscs_rhs"]={{19,5,{"VIP","VRP"}}},
	["Elevation value"]={{11,5,{"VIP","VRP"}}},
	["Elevation value_inv"]={{11,5,{"VIP","VRP"}}},
	["Event Occured"]={{19,1,{"IFF_MAIN_POS","IFF_MAIN_STAT","IFF_MAIN_TIM"}}},
	["FC lbl"]={{4,2,{"LINK16"}}},
	["FC value"]={{7,2,{"LINK16"}}},
	["FC value_inv"]={{7,2,{"LINK16"}}},
	["FILL lbl"]={{3,4,{"AG_DL"}}},
	["FILL status"]={{8,4,{"AG_DL"}}},
	["FILTER MODE label"]={{4,3,{"NAV_COMMANDS"}}},
	["FILTER MODE value"]={{17,3,{"NAV_COMMANDS"}}},
	["FIX_DELTA"]={{4,3,{"FIX"}}},
	["FIX_SENSORS"]={{7,1,{"FIX"}}},
	["FIX_STPT"]={{5,2,{"FIX"}}},
	["FIX_SelectedSensors"]={{12,1,{"FIX"}}},
	["FIX_SelectedSensors_inv"]={{12,1,{"FIX"}}},
	["FL lbl"]={{13,3,{"LINK16"}}},
	["FL status"]={{17,3,{"LINK16"}}},
	["GPS ACCURACY label"]={{5,5,{"FIX"}},{4,3,{"NAV_STATUS"}}},
	["GPS ACCURACY value"]={{15,5,{"FIX"}},{15,3,{"NAV_STATUS"}}},
	["GPS TIME lbl"]={{1,2,{"NET_STATUS"}}},
	["GPS TIME status"]={{10,2,{"NET_STATUS"}}},
	["GPS_ACCURACY_label"]={{4,3,{"A_CAL_AUTO"}}},
	["GPS_ACCURACY_value"]={{15,3,{"A_CAL_AUTO"}}},
	["GPS_SYSTEM_label"]={{1,2,{"TIME"}}},
	["GRID_DIGIT"]={{13,2,{"DEST_UTM_DIR"}}},
	["GRID_DIGIT_inv"]={{13,2,{"DEST_UTM_DIR"}}},
	["GRID_SYMBOL"]={{15,2,{"DEST_UTM_DIR"}}},
	["GRID_SYMBOL_inv"]={{15,2,{"DEST_UTM_DIR"}}},
	["Guard Label"]={{13,3,{"COM_2_GUARD"}}},
	["Guard or Backup Frequency"]={{11,5,{"COM_1_GUARD"}}},
	["Guard or Backup Status"]={{10,3,{"COM_1_GUARD"}}},
	["HACK_IncDecSymbol"]={{23,3,{"TIME"}}},
	["HACK_label"]={{7,3,{"TIME"}}},
	["HACK_value"]={{14,3,{"TIME"}}},
	["HACK_value_inv"]={{14,3,{"TIME"}}},
	["HARM"]={{2,1,{"HARM"}}},
	["HMCS_ALIGN_label"]={{7,1,{"HMCS_ALIGN"}}},
	["HMCS_AZ_EL"]={{3,3,{"HMCS_ALIGN"}}},
	["HMCS_AZ_EL_inv"]={{3,3,{"HMCS_ALIGN"}}},
	["HMCS_CKPT_BLANK"]={{3,3,{"HMCS_DISPLAY"}}},
	["HMCS_CKPT_BLANK_inv"]={{3,3,{"HMCS_DISPLAY"}}},
	["HMCS_COARSE"]={{3,2,{"HMCS_ALIGN"}}},
	["HMCS_COARSE_inv"]={{3,2,{"HMCS_ALIGN"}}},
	["HMCS_DECLUTTER"]={{3,4,{"HMCS_DISPLAY"}}},
	["HMCS_DECLUTTER_STATUS"]={{17,4,{"HMCS_DISPLAY"}}},
	["HMCS_DISPLAY_label"]={{7,1,{"HMCS_DISPLAY"}}},
	["HMCS_HUD_BLANK"]={{3,2,{"HMCS_DISPLAY"}}},
	["HMCS_HUD_BLANK_inv"]={{3,2,{"HMCS_DISPLAY"}}},
	["HMCS_ROLL"]={{3,4,{"HMCS_ALIGN"}}},
	["HMCS_ROLL_inv"]={{3,4,{"HMCS_ALIGN"}}},
	["HMCS_RWR_DISPLAY"]={{3,5,{"HMCS_DISPLAY"}}},
	["HMCS_RWR_DISPLAY_STATUS"]={{13,5,{"HMCS_DISPLAY"}}},
	["HOME_FUEL_REMANING"]={{8,3,{"CRUS_HOME"}}},
	["HOME_FUEL_REMANING_Value"]={{13,3,{"CRUS_HOME"}}},
	["HOME_INS_STPT_IncDecSymbol"]={{17,2,{"CRUS_HOME"}}},
	["HOME_INS_SelectedSteerpoint"]={{13,2,{"CRUS_HOME"}}},
	["HOME_INS_SelectedSteerpoint_inv"]={{13,2,{"CRUS_HOME"}}},
	["HOME_MODE"]={{14,1,{"CRUS_HOME"}}},
	["HOME_MODE_inv"]={{14,1,{"CRUS_HOME"}}},
	["HOME_OPT_ALT_label"]={{5,4,{"CRUS_HOME"}}},
	["HOME_OPT_ALT_value"]={{14,4,{"CRUS_HOME"}}},
	["HOME_STPT_NUM"]={{8,2,{"CRUS_HOME"}}},
	["HOME_WIND_AT_ALTITUDE"]={{8,5,{"CRUS_HOME"}}},
	["HOME_WIND_AT_ALTITUDE_Value"]={{14,5,{"CRUS_HOME"}}},
	["HTS"]={{9,1,{"HTS_MAN"}},{5,1,{"HTS_SEAD"}}},
	["HTS_ELEV"]={{8,4,{"HTS_SEAD"}}},
	["HTS_ELEV_lbl"]={{3,4,{"HTS_SEAD"}}},
	["HTS_LAT"]={{8,2,{"HTS_SEAD"}}},
	["HTS_LAT_lbl"]={{3,2,{"HTS_SEAD"}}},
	["HTS_LNG"]={{8,3,{"HTS_SEAD"}}},
	["HTS_LNG_lbl"]={{3,3,{"HTS_SEAD"}}},
	["HTS_TOT"]={{8,5,{"HTS_SEAD"}}},
	["HTS_TOT_lbl"]={{3,5,{"HTS_SEAD"}}},
	["Hack Time"]={{16,4,{"CNI"}}},
	["IFF Modes Enabled"]={{3,5,{"CNI"}}},
	["IFF Modes Label"]={{2,5,{"CNI"}}},
	["IFF Power Status"]={{6,1,{"IFF_MAIN_POS","IFF_MAIN_STAT","IFF_MAIN_TIM"}}},
	["IFF Status"]={{13,1,{"IFF_BACKUP"}}},
	["IFF Switching"]={{15,5,{"CNI"}}},
	["IFF label"]={{9,1,{"IFF_BACKUP"}},{2,1,{"IFF_MAIN_POS","IFF_MAIN_STAT","IFF_MAIN_TIM"}}},
	["ILS CMD STRG"]={{16,3,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS CMD STRG_inv"]={{16,3,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS CRS Asterisks_lhs"]={{17,5,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS CRS Asterisks_rhs"]={{22,5,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS CRS Label"]={{13,5,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS CRS Scratchpad"]={{18,5,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS CRS Scratchpad_inv"]={{18,5,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS FRQ Asterisks_lhs"]={{17,4,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS FRQ Asterisks_rhs"]={{24,4,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS FRQ Label"]={{13,4,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS FRQ Scratchpad"]={{18,4,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS FRQ Scratchpad_inv"]={{18,4,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS Label"]={{14,1,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["ILS Mode"]={{19,1,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["INS_AlignSlash"]={{12,1,{"INS"}}},
	["INS_AlignStatusCode"]={{13,1,{"INS"}}},
	["INS_AlignTime"]={{8,1,{"INS"}}},
	["INS_COMPASS_HDG_lbl"]={{4,3,{"INS_INFLT_ALGN"}}},
	["INS_CompassHdgScratchpad"]={{17,3,{"INS_INFLT_ALGN"}}},
	["INS_CompassHdgScratchpad_inv"]={{17,3,{"INS_INFLT_ALGN"}}},
	["INS_FIX_NECESSARY_lbl"]={{4,4,{"INS_INFLT_ALGN"}}},
	["INS_GS_lbl"]={{17,5,{"INS"}}},
	["INS_GS_value"]={{21,5,{"INS"}}},
	["INS_INFLT_ALGN_lbl"]={{9,1,{"INS_INFLT_ALGN"}}},
	["INS_LAT_Scratchpad"]={{8,2,{"INS"}}},
	["INS_LAT_Scratchpad_inv"]={{8,2,{"INS"}}},
	["INS_LAT_lbl"]={{3,2,{"INS"}}},
	["INS_LNG_Scratchpad"]={{8,3,{"INS"}}},
	["INS_LNG_Scratchpad_inv"]={{8,3,{"INS"}}},
	["INS_LNG_lbl"]={{3,3,{"INS"}}},
	["INS_MAGV_Scratchpad"]={{10,3,{"MAGV"}}},
	["INS_MAGV_Scratchpad_inv"]={{10,3,{"MAGV"}}},
	["INS_Ready"]={{16,1,{"INS"}}},
	["INS_SALT_Scratchpad"]={{9,4,{"INS"}}},
	["INS_SALT_Scratchpad_inv"]={{9,4,{"INS"}}},
	["INS_SALT_lbl"]={{2,4,{"INS"}}},
	["INS_STPT_IncDecSymbol"]={{15,2,{"FIX"}},{24,1,{"A_CAL_AUTO","A_CAL_MAN","CRUS_TOS","HMCS_ALIGN","HMCS_DISPLAY","HTS_MAN","INS","INS_COMMON","INS_INFLT_ALGN","MAGV","NAV_COMMANDS","NAV_COMMON","NAV_STATUS"}}},
	["INS_SelectedSteerpoint"]={{11,2,{"FIX"}},{21,1,{"A_CAL_AUTO","A_CAL_MAN","CRUS_TOS","HMCS_ALIGN","HMCS_DISPLAY","HTS_MAN","INS","INS_COMMON","INS_INFLT_ALGN","MAGV","NAV_COMMANDS","NAV_COMMON","NAV_STATUS"}}},
	["INS_SelectedSteerpoint_inv"]={{11,2,{"FIX"}}},
	["INS_THDG_Scratchpad"]={{8,5,{"INS"}}},
	["INS_THDG_Scratchpad_inv"]={{8,5,{"INS"}}},
	["INS_THDG_lbl"]={{2,5,{"INS"}}},
	["INS_lbl"]={{3,1,{"INS"}},{5,1,{"INS_INFLT_ALGN"}}},
	["INTG Asterisks_lhs"]={{10,5,{"INTG"}}},
	["INTG Asterisks_rhs"]={{16,5,{"INTG"}}},
	["INTG COUPLE Key"]={{21,5,{"INTG"}}},
	["INTG COUPLE Mode"]={{17,5,{"INTG"}}},
	["INTG IJAM Key"]={{21,4,{"INTG"}}},
	["INTG IJAM Mode"]={{16,4,{"INTG"}}},
	["INTG IJAM Mode_inv"]={{16,4,{"INTG"}}},
	["INTG INTG Mode"]={{9,1,{"INTG"}}},
	["INTG INTG label"]={{14,1,{"INTG"}}},
	["INTG M1 Code"]={{5,3,{"INTG"}}},
	["INTG M1 Decoupled Status"]={{4,3,{"INTG"}}},
	["INTG M1 Mode"]={{1,3,{"INTG"}}},
	["INTG M1 Mode_inv"]={{1,3,{"INTG"}}},
	["INTG M2 Code"]={{5,4,{"INTG"}}},
	["INTG M2 Decoupled Status"]={{4,4,{"INTG"}}},
	["INTG M2 Mode"]={{1,4,{"INTG"}}},
	["INTG M2 Mode_inv"]={{1,4,{"INTG"}}},
	["INTG M3 Code"]={{5,5,{"INTG"}}},
	["INTG M3 Decoupled Status"]={{4,5,{"INTG"}}},
	["INTG M3 Mode"]={{1,5,{"INTG"}}},
	["INTG M3 Mode_inv"]={{1,5,{"INTG"}}},
	["INTG M4 Code"]={{21,3,{"INTG"}}},
	["INTG M4 Decoupled Status"]={{20,3,{"INTG"}}},
	["INTG M4 Key"]={{22,3,{"INTG"}}},
	["INTG M4 Mode"]={{17,3,{"INTG"}}},
	["INTG M4 Mode_inv"]={{17,3,{"INTG"}}},
	["INTG Scratchpad"]={{11,5,{"INTG"}}},
	["INTG Scratchpad_inv"]={{11,5,{"INTG"}}},
	["INTG TIM Event"]={{21,1,{"INTG"}}},
	["INTRAFLIGHT lbl"]={{8,1,{"INTRAFLIGHT"}}},
	["IPF Reset lbl"]={{15,2,{"NET_STATUS"}}},
	["IncDec Symbol"]={{24,1,{"IFF_MAIN_POS","IFF_MAIN_TIM"}}},
	["Keys Msg"]={{4,5,{"NAV_STATUS"}}},
	["LASR LABEL"]={{12,1,{"LASER"}}},
	["LAST lbl"]={{14,5,{"INTRAFLIGHT"}}},
	["LAST value"]={{19,5,{"INTRAFLIGHT"}}},
	["LAT"]={{9,2,{"DEST_DIR"}}},
	["LAT_inv"]={{9,2,{"DEST_DIR"}}},
	["LINK16 STN lbl"]={{8,1,{"LINK16_STN"}}},
	["LINK16 lbl"]={{10,1,{"LINK16"}}},
	["LIST Label"]={{11,1,{"LIST"}}},
	["LON"]={{9,3,{"DEST_DIR"}}},
	["LON_inv"]={{9,3,{"DEST_DIR"}}},
	["LST CODE Asteriscs_lhs"]={{13,3,{"LASER"}}},
	["LST CODE Asteriscs_rhs"]={{18,3,{"LASER"}}},
	["LST CODE LABEL"]={{2,3,{"LASER"}}},
	["LST CODE VALUE"]={{14,3,{"LASER"}}},
	["LST CODE VALUE_inv"]={{14,3,{"LASER"}}},
	["Laser ST Time Asteriscs_lhs"]={{16,5,{"LASER"}}},
	["Laser ST Time Asteriscs_rhs"]={{20,5,{"LASER"}}},
	["Laser ST Time LABEL"]={{2,5,{"LASER"}}},
	["Laser ST Time VALUE"]={{17,5,{"LASER"}}},
	["Laser ST Time VALUE_inv"]={{17,5,{"LASER"}}},
	["List Item 0 Name"]={{20,4,{"LIST"}}},
	["List Item 0 Number"]={{19,4,{"LIST"}}},
	["List Item 1 Name"]={{2,2,{"LIST"}}},
	["List Item 1 Number"]={{1,2,{"LIST"}}},
	["List Item 2 Name"]={{8,2,{"LIST"}}},
	["List Item 2 Number"]={{7,2,{"LIST"}}},
	["List Item 3 Name"]={{14,2,{"LIST"}}},
	["List Item 3 Number"]={{13,2,{"LIST"}}},
	["List Item 4 Name"]={{2,3,{"LIST"}}},
	["List Item 4 Number"]={{1,3,{"LIST"}}},
	["List Item 5 Name"]={{8,3,{"LIST"}}},
	["List Item 5 Number"]={{7,3,{"LIST"}}},
	["List Item 6 Name"]={{14,3,{"LIST"}}},
	["List Item 6 Number"]={{13,3,{"LIST"}}},
	["List Item 7 Name"]={{2,4,{"LIST"}}},
	["List Item 7 Number"]={{1,4,{"LIST"}}},
	["List Item 8 Name"]={{8,4,{"LIST"}}},
	["List Item 8 Number"]={{7,4,{"LIST"}}},
	["List Item 9 Name"]={{14,4,{"LIST"}}},
	["List Item 9 Number"]={{13,4,{"LIST"}}},
	["List Item E Name"]={{20,3,{"LIST"}}},
	["List Item E Number"]={{19,3,{"LIST"}}},
	["List Item R Name"]={{20,2,{"LIST"}}},
	["List Item R Number"]={{19,2,{"LIST"}}},
	["M1 Code"]={{5,3,{"IFF_MAIN_STAT","IFF_MAIN_TIM"}}},
	["M1 Lockout Status"]={{4,3,{"IFF_MAIN_STAT"}}},
	["M1 Mode"]={{2,3,{"IFF_MAIN_POS","IFF_MAIN_TIM"}},{1,3,{"IFF_MAIN_STAT"}}},
	["M1 Mode_inv"]={{2,3,{"IFF_MAIN_POS","IFF_MAIN_TIM"}},{1,3,{"IFF_MAIN_STAT"}}},
	["M2 Code"]={{5,4,{"IFF_MAIN_POS","IFF_MAIN_STAT"}}},
	["M2 Lockout Status"]={{4,4,{"IFF_MAIN_STAT"}}},
	["M2 Mode"]={{2,4,{"IFF_MAIN_POS","IFF_MAIN_TIM"}},{1,4,{"IFF_MAIN_STAT"}}},
	["M2 Mode_inv"]={{2,4,{"IFF_MAIN_POS","IFF_MAIN_TIM"}},{1,4,{"IFF_MAIN_STAT"}}},
	["M3 Code"]={{5,5,{"IFF_MAIN_STAT","IFF_MAIN_TIM"}}},
	["M3 Lockout Status"]={{4,5,{"IFF_MAIN_STAT"}}},
	["M3 Mode"]={{2,5,{"IFF_MAIN_POS","IFF_MAIN_TIM"}},{1,5,{"IFF_MAIN_STAT"}}},
	["M3 Mode_inv"]={{2,5,{"IFF_MAIN_POS","IFF_MAIN_TIM"}},{1,5,{"IFF_MAIN_STAT"}}},
	["M4 Code"]={{13,3,{"IFF_MAIN_STAT"}},{14,3,{"IFF_MAIN_TIM"}}},
	["M4 Key"]={{15,3,{"IFF_MAIN_STAT","IFF_MAIN_TIM"}}},
	["M4 Mode"]={{10,3,{"IFF_MAIN_POS","IFF_MAIN_TIM"}},{9,3,{"IFF_MAIN_STAT"}}},
	["M4 Mode_inv"]={{10,3,{"IFF_MAIN_POS","IFF_MAIN_TIM"}},{9,3,{"IFF_MAIN_STAT"}}},
	["M4 Monitoring"]={{10,5,{"IFF_MAIN_STAT"}}},
	["M4 Monitoring Key"]={{15,5,{"IFF_MAIN_STAT"}}},
	["MAGV Mode"]={{14,1,{"MAGV"}}},
	["MAGV lbl"]={{8,1,{"MAGV"}}},
	["MAN IncDecSymbol"]={{24,1,{"MAN"}}},
	["MAN Label"]={{11,1,{"MAN"}}},
	["MAN STPT Num"]={{21,1,{"MAN"}}},
	["MARK"]={{2,1,{"MARK"}}},
	["MARK EAST Value"]={{13,5,{"MARK"}}},
	["MARK EAST Value_inv"]={{13,5,{"MARK"}}},
	["MARK Elevation"]={{2,4,{"MARK"}}},
	["MARK Elevation Asteriscs_lhs"]={{6,4,{"MARK"}}},
	["MARK Elevation Asteriscs_rhs"]={{15,4,{"MARK"}}},
	["MARK Elevation Value"]={{7,4,{"MARK"}}},
	["MARK Elevation Value_inv"]={{7,4,{"MARK"}}},
	["MARK GRID DIGIT Value"]={{7,5,{"MARK"}}},
	["MARK GRID DIGIT Value_inv"]={{7,5,{"MARK"}}},
	["MARK GRID SYMBOL Value"]={{9,5,{"MARK"}}},
	["MARK GRID SYMBOL Value_inv"]={{9,5,{"MARK"}}},
	["MARK IncDecSymbol"]={{18,1,{"MARK"}}},
	["MARK Latitude"]={{3,2,{"MARK"}}},
	["MARK Latitude Asteriscs_lhs"]={{6,2,{"MARK"}}},
	["MARK Latitude Asteriscs_rhs"]={{19,2,{"MARK"}}},
	["MARK Latitude Value"]={{7,2,{"MARK"}}},
	["MARK Latitude Value_inv"]={{7,2,{"MARK"}}},
	["MARK Longitude"]={{3,3,{"MARK"}}},
	["MARK Longitude Asteriscs_lhs"]={{6,3,{"MARK"}}},
	["MARK Longitude Asteriscs_rhs"]={{19,3,{"MARK"}}},
	["MARK Longitude Value"]={{7,3,{"MARK"}}},
	["MARK Longitude Value_inv"]={{7,3,{"MARK"}}},
	["MARK MGRS"]={{2,5,{"MARK"}}},
	["MARK MGRS Asteriscs_lhs"]={{6,5,{"MARK"}}},
	["MARK MGRS Asteriscs_rhs"]={{24,5,{"MARK"}}},
	["MARK NORTH Value"]={{19,5,{"MARK"}}},
	["MARK NORTH Value_inv"]={{19,5,{"MARK"}}},
	["MARK Number Asteriscs_lhs"]={{14,1,{"MARK"}}},
	["MARK Number Asteriscs_rhs"]={{19,1,{"MARK"}}},
	["MARK SOURCE"]={{8,1,{"MARK"}}},
	["MARK SOURCE Asteriscs_lhs"]={{7,1,{"MARK"}}},
	["MARK SOURCE Asteriscs_rhs"]={{12,1,{"MARK"}}},
	["MARK SQUARE Value1"]={{10,5,{"MARK"}}},
	["MARK SQUARE Value1_inv"]={{10,5,{"MARK"}}},
	["MARK SQUARE Value2"]={{11,5,{"MARK"}}},
	["MARK SQUARE Value2_inv"]={{11,5,{"MARK"}}},
	["MARK Slash"]={{18,5,{"MARK"}}},
	["MBAL Label"]={{11,3,{"MAN"}}},
	["MC Code"]={{13,4,{"IFF_MAIN_STAT"}}},
	["MC Key"]={{15,4,{"IFF_MAIN_POS","IFF_MAIN_STAT"}}},
	["MC Mode"]={{10,4,{"IFF_MAIN_POS","IFF_MAIN_STAT","IFF_MAIN_TIM"}}},
	["MC Mode_inv"]={{10,4,{"IFF_MAIN_POS","IFF_MAIN_STAT","IFF_MAIN_TIM"}}},
	["MC lbl"]={{4,3,{"LINK16"}}},
	["MC value"]={{7,3,{"LINK16"}}},
	["MC value_inv"]={{7,3,{"LINK16"}}},
	["MISC Label"]={{11,1,{"MISC"}}},
	["MS Code"]={{21,5,{"IFF_MAIN_POS","IFF_MAIN_STAT"}}},
	["MS Key"]={{22,5,{"IFF_MAIN_POS","IFF_MAIN_STAT"}}},
	["MS Mode"]={{19,5,{"IFF_MAIN_POS","IFF_MAIN_STAT","IFF_MAIN_TIM"}}},
	["MS Mode_inv"]={{19,5,{"IFF_MAIN_POS","IFF_MAIN_STAT","IFF_MAIN_TIM"}}},
	["MSL FLOOR Asterisks_lhs"]={{15,4,{"ALOW"}}},
	["MSL FLOOR Asterisks_rhs"]={{23,4,{"ALOW"}}},
	["MSL FLOOR Scratchpad"]={{16,4,{"ALOW"}}},
	["MSL FLOOR Scratchpad_inv"]={{16,4,{"ALOW"}}},
	["MSL FLOOR label"]={{4,4,{"ALOW"}}},
	["MSN DUR label"]={{4,4,{"NAV_STATUS"}}},
	["Master_mode"]={{11,1,{"MODE"}}},
	["Master_mode_ast_lhs"]={{10,1,{"MODE"}}},
	["Master_mode_ast_rhs"]={{14,1,{"MODE"}}},
	["Master_mode_inv"]={{11,1,{"MODE"}}},
	["Master_mode_label"]={{5,1,{"MODE"}}},
	["Misc Item 0 Name"]={{20,4,{"MISC"}}},
	["Misc Item 0 Number"]={{19,4,{"MISC"}}},
	["Misc Item 1 Name"]={{2,2,{"MISC"}}},
	["Misc Item 1 Number"]={{1,2,{"MISC"}}},
	["Misc Item 2 Name"]={{8,2,{"MISC"}}},
	["Misc Item 2 Number"]={{7,2,{"MISC"}}},
	["Misc Item 3 Name"]={{14,2,{"MISC"}}},
	["Misc Item 3 Number"]={{13,2,{"MISC"}}},
	["Misc Item 4 Name"]={{2,3,{"MISC"}}},
	["Misc Item 4 Number"]={{1,3,{"MISC"}}},
	["Misc Item 5 Name"]={{8,3,{"MISC"}}},
	["Misc Item 5 Number"]={{7,3,{"MISC"}}},
	["Misc Item 6 Name"]={{14,3,{"MISC"}}},
	["Misc Item 6 Number"]={{13,3,{"MISC"}}},
	["Misc Item 7 Name"]={{2,4,{"MISC"}}},
	["Misc Item 7 Number"]={{1,4,{"MISC"}}},
	["Misc Item 8 Name"]={{8,4,{"MISC"}}},
	["Misc Item 8 Number"]={{7,4,{"MISC"}}},
	["Misc Item 9 Name"]={{14,4,{"MISC"}}},
	["Misc Item 9 Number"]={{13,4,{"MISC"}}},
	["Misc Item E Name"]={{20,3,{"MISC"}}},
	["Misc Item E Number"]={{19,3,{"MISC"}}},
	["Misc Item R Name"]={{20,2,{"MISC"}}},
	["Misc Item R Number"]={{19,2,{"MISC"}}},
	["Mode Asterisks_lhs"]={{19,3,{"IFF_MAIN_POS","IFF_MAIN_TIM"}},{18,2,{"IFF_MAIN_STAT"}}},
	["Mode Asterisks_rhs"]={{24,3,{"IFF_MAIN_POS","IFF_MAIN_TIM"}},{24,2,{"IFF_MAIN_STAT"}}},
	["Mode Group State"]={{23,1,{"IFF_MAIN_POS"}}},
	["Mode Scratchpad"]={{20,3,{"IFF_MAIN_POS","IFF_MAIN_TIM"}},{19,2,{"IFF_MAIN_STAT"}}},
	["Mode Scratchpad_inv"]={{20,3,{"IFF_MAIN_POS","IFF_MAIN_TIM"}},{19,2,{"IFF_MAIN_STAT"}}},
	["Mode label"]={{13,1,{"IFF_MAIN_STAT"}}},
	["NAV Status lbl"]={{7,1,{"NAV_COMMANDS"}},{8,1,{"NAV_STATUS"}}},
	["NAV_FILTER_label"]={{3,2,{"A_CAL_AUTO"}}},
	["NAV_FILTER_mode"]={{15,2,{"A_CAL_AUTO"}}},
	["NET STATUS lbl"]={{6,1,{"NET_STATUS"}}},
	["NTR lbl"]={{6,4,{"NET_STATUS"}}},
	["NTR status"]={{10,4,{"NET_STATUS"}}},
	["NUM lbl"]={{21,3,{"LINK16_STN"}}},
	["OWN lbl"]={{4,3,{"AG_DL"}},{15,4,{"INTRAFLIGHT"}},{21,2,{"LINK16_STN"}}},
	["OWN value"]={{8,3,{"AG_DL"}},{19,4,{"INTRAFLIGHT"}}},
	["Own num value"]={{23,3,{"LINK16_STN"}}},
	["Own num value_inv"]={{23,3,{"LINK16_STN"}}},
	["P1 lbl"]={{22,5,{"DEST_UTM_DIR","NET_STATUS"}}},
	["P2 lbl"]={{22,5,{"LINK16"}}},
	["P2lbl"]={{22,5,{"DEST_DIR"}}},
	["P3 lbl"]={{22,5,{"LINK16_STN"}}},
	["P3lbl"]={{22,5,{"DEST_OA1"}}},
	["P4lbl"]={{22,5,{"DEST_OA2"}}},
	["P5 lbl"]={{22,5,{"AG_DL"}}},
	["P6 lbl"]={{22,5,{"INTRAFLIGHT"}}},
	["POS EVENT - Number"]={{23,4,{"IFF_MAIN_POS"}},{23,3,{"IFF_MAIN_STAT"}}},
	["POS EVENT - OF"]={{21,4,{"IFF_MAIN_POS"}},{21,3,{"IFF_MAIN_STAT"}}},
	["POS EVENT - Side"]={{20,4,{"IFF_MAIN_POS"}},{20,3,{"IFF_MAIN_STAT"}}},
	["PRTL lbl"]={{13,4,{"AG_DL"}}},
	["PRTL status"]={{18,4,{"AG_DL"}}},
	["Preset Channel Number"]={{8,5,{"COM_1_GUARD"}}},
	["Preset Frequency"]={{6,5,{"COM_1","COM_2"}}},
	["Preset Frequency_inv"]={{6,5,{"COM_1","COM_2"}}},
	["Preset Label"]={{3,4,{"COM_1","COM_2"}}},
	["Preset Number"]={{8,4,{"COM_1","COM_2"}}},
	["Preset Number_inv"]={{8,4,{"COM_1","COM_2"}}},
	["RESET GPS label"]={{7,4,{"NAV_COMMANDS"}}},
	["RESET GPS label_inv"]={{7,4,{"NAV_COMMANDS"}}},
	["RNG"]={{9,3,{"DEST_OA1","DEST_OA2"}}},
	["RNG Data"]={{12,4,{"MAN"}}},
	["RNG FT"]={{19,4,{"MAN"}}},
	["RNG Label"]={{9,4,{"MAN"}}},
	["RNG_FUEL_REMANING"]={{8,3,{"CRUS_RNG"}}},
	["RNG_FUEL_REMANING_Value"]={{13,3,{"CRUS_RNG"}}},
	["RNG_INS_STPT_IncDecSymbol"]={{17,2,{"CRUS_RNG"}}},
	["RNG_INS_SelectedSteerpoint"]={{13,2,{"CRUS_RNG"}}},
	["RNG_MODE"]={{14,1,{"CRUS_RNG"}}},
	["RNG_MODE_inv"]={{14,1,{"CRUS_RNG"}}},
	["RNG_STPT_NUM"]={{8,2,{"CRUS_RNG"}}},
	["RNG_WIND_AT_ALTITUDE"]={{8,5,{"CRUS_RNG"}}},
	["RNG_WIND_AT_ALTITUDE_Value"]={{14,5,{"CRUS_RNG"}}},
	["RNG_inv"]={{9,3,{"DEST_OA1","DEST_OA2"}}},
	["Range"]={{6,4,{"VIP","VRP"}}},
	["Range Asteriscs_lhs"]={{12,4,{"VIP"}},{10,4,{"VRP"}}},
	["Range Asteriscs_rhs"]={{17,4,{"VIP"}},{19,4,{"VRP"}}},
	["Range NM"]={{18,4,{"VIP"}}},
	["Range value"]={{13,4,{"VIP"}},{11,4,{"VRP"}}},
	["Range value_inv"]={{13,4,{"VIP"}},{11,4,{"VRP"}}},
	["Receiver Mode"]={{14,1,{"COM_1"}}},
	["Receiver Power Status"]={{14,1,{"COM_2"}}},
	["SC lbl"]={{4,4,{"LINK16"}}},
	["SC value"]={{7,4,{"LINK16"}}},
	["SC value_inv"]={{7,4,{"LINK16"}}},
	["SET label"]={{7,3,{"BINGO"}}},
	["SQUARE"]={{13,3,{"DEST_UTM_DIR"}}},
	["SQUARE2"]={{14,3,{"DEST_UTM_DIR"}}},
	["SQUARE2_inv"]={{14,3,{"DEST_UTM_DIR"}}},
	["SQUARE_inv"]={{13,3,{"DEST_UTM_DIR"}}},
	["STEERPOINT CNVRT Asteriscs_lhs"]={{17,2,{"STPT"}}},
	["STEERPOINT CNVRT Asteriscs_rhs"]={{23,2,{"STPT"}}},
	["STEERPOINT EAST NORTH"]={{1,4,{"STPT"}}},
	["STEERPOINT EAST NORTH Asteriscs_lhs"]={{12,4,{"STPT"}}},
	["STEERPOINT EAST NORTH Asteriscs_rhs"]={{24,4,{"STPT"}}},
	["STEERPOINT EAST NORTH Value"]={{13,4,{"STPT"}}},
	["STEERPOINT EAST NORTH Value_inv"]={{13,4,{"STPT"}}},
	["STEERPOINT Elevation"]={{3,4,{"STPT"}}},
	["STEERPOINT Elevation Asteriscs_lhs"]={{8,4,{"STPT"}}},
	["STEERPOINT Elevation Asteriscs_rhs"]={{17,4,{"STPT"}}},
	["STEERPOINT Elevation Value"]={{9,4,{"STPT"}}},
	["STEERPOINT Elevation Value_inv"]={{9,4,{"STPT"}}},
	["STEERPOINT ElevationMGRS"]={{7,5,{"STPT"}}},
	["STEERPOINT ElevationMGRS Asteriscs_lhs"]={{12,5,{"STPT"}}},
	["STEERPOINT ElevationMGRS Asteriscs_rhs"]={{21,5,{"STPT"}}},
	["STEERPOINT ElevationMGRS Value"]={{12,5,{"STPT"}}},
	["STEERPOINT ElevationMGRS Value_inv"]={{12,5,{"STPT"}}},
	["STEERPOINT GRID"]={{7,2,{"STPT"}}},
	["STEERPOINT GRID CNVRT"]={{18,2,{"STPT"}}},
	["STEERPOINT GRID CNVRT_inv"]={{18,2,{"STPT"}}},
	["STEERPOINT GRID DIGIT Asteriscs_lhs"]={{12,2,{"STPT"}}},
	["STEERPOINT GRID DIGIT Asteriscs_rhs"]={{16,2,{"STPT"}}},
	["STEERPOINT GRID DIGIT Value"]={{13,2,{"STPT"}}},
	["STEERPOINT GRID DIGIT Value_inv"]={{13,2,{"STPT"}}},
	["STEERPOINT GRID SYMBOL Asteriscs_lhs"]={{12,2,{"STPT"}}},
	["STEERPOINT GRID SYMBOL Asteriscs_rhs"]={{16,2,{"STPT"}}},
	["STEERPOINT GRID SYMBOL Value"]={{15,2,{"STPT"}}},
	["STEERPOINT GRID SYMBOL Value_inv"]={{15,2,{"STPT"}}},
	["STEERPOINT IncDecSymbol"]={{17,1,{"STPT"}}},
	["STEERPOINT LABEL"]={{7,1,{"STPT"}}},
	["STEERPOINT Latitude"]={{4,2,{"STPT"}}},
	["STEERPOINT Latitude Asteriscs_lhs"]={{8,2,{"STPT"}}},
	["STEERPOINT Latitude Asteriscs_rhs"]={{21,2,{"STPT"}}},
	["STEERPOINT Latitude Value"]={{9,2,{"STPT"}}},
	["STEERPOINT Latitude Value_inv"]={{9,2,{"STPT"}}},
	["STEERPOINT Longitude"]={{4,3,{"STPT"}}},
	["STEERPOINT Longitude Asteriscs_lhs"]={{8,3,{"STPT"}}},
	["STEERPOINT Longitude Asteriscs_rhs"]={{21,3,{"STPT"}}},
	["STEERPOINT Longitude Value"]={{9,3,{"STPT"}}},
	["STEERPOINT Longitude Value_inv"]={{9,3,{"STPT"}}},
	["STEERPOINT NUMBER"]={{13,1,{"STPT"}}},
	["STEERPOINT NUMBER Asteriscs_lhs"]={{12,1,{"STPT"}}},
	["STEERPOINT NUMBER Asteriscs_rhs"]={{16,1,{"STPT"}}},
	["STEERPOINT NUMBER_inv"]={{13,1,{"STPT"}}},
	["STEERPOINT SEQUENCE"]={{19,1,{"STPT"}}},
	["STEERPOINT SEQUENCE Asteriscs_lhs"]={{18,1,{"STPT"}}},
	["STEERPOINT SEQUENCE Asteriscs_rhs"]={{23,1,{"STPT"}}},
	["STEERPOINT SQUARE"]={{5,3,{"STPT"}}},
	["STEERPOINT SQUARE Asteriscs_lhs"]={{12,3,{"STPT"}}},
	["STEERPOINT SQUARE Asteriscs_rhs"]={{15,3,{"STPT"}}},
	["STEERPOINT SQUARE Value1"]={{13,3,{"STPT"}}},
	["STEERPOINT SQUARE Value1_inv"]={{13,3,{"STPT"}}},
	["STEERPOINT SQUARE Value2"]={{14,3,{"STPT"}}},
	["STEERPOINT SQUARE Value2_inv"]={{14,3,{"STPT"}}},
	["STEERPOINT SQUARE2 Asteriscs_lhs"]={{12,3,{"STPT"}}},
	["STEERPOINT SQUARE2 Asteriscs_rhs"]={{15,3,{"STPT"}}},
	["STEERPOINT TOS Asteriscs_lhs"]={{8,5,{"STPT"}}},
	["STEERPOINT TOS Asteriscs_rhs"]={{18,5,{"STPT"}}},
	["STEERPOINT TOS Value"]={{9,5,{"STPT"}}},
	["STEERPOINT TOS Value_inv"]={{9,5,{"STPT"}}},
	["STEERPOINT Time over current STP"]={{4,5,{"STPT"}}},
	["STEERPOINT UTM LABEL"]={{3,1,{"STPT"}}},
	["STN TDOA value_1"]={{3,2,{"LINK16_STN"}}},
	["STN TDOA value_2"]={{3,3,{"LINK16_STN"}}},
	["STN TDOA value_3"]={{3,4,{"LINK16_STN"}}},
	["STN TDOA value_4"]={{3,5,{"LINK16_STN"}}},
	["STN TDOA value_5"]={{13,2,{"LINK16_STN"}}},
	["STN TDOA value_6"]={{13,3,{"LINK16_STN"}}},
	["STN TDOA value_7"]={{13,4,{"LINK16_STN"}}},
	["STN TDOA value_8"]={{13,5,{"LINK16_STN"}}},
	["STN id lbl1"]={{1,2,{"INTRAFLIGHT"}}},
	["STN id lbl2"]={{1,3,{"INTRAFLIGHT"}}},
	["STN id lbl3"]={{1,4,{"INTRAFLIGHT"}}},
	["STN id lbl4"]={{1,5,{"INTRAFLIGHT"}}},
	["STN id lbl5"]={{11,2,{"INTRAFLIGHT"}}},
	["STN id lbl6"]={{11,3,{"INTRAFLIGHT"}}},
	["STN id lbl7"]={{11,4,{"INTRAFLIGHT"}}},
	["STN id lbl8"]={{11,5,{"INTRAFLIGHT"}}},
	["STN id lbl_1"]={{1,2,{"LINK16_STN"}}},
	["STN id lbl_2"]={{1,3,{"LINK16_STN"}}},
	["STN id lbl_3"]={{1,4,{"LINK16_STN"}}},
	["STN id lbl_4"]={{1,5,{"LINK16_STN"}}},
	["STN id lbl_5"]={{11,2,{"LINK16_STN"}}},
	["STN id lbl_6"]={{11,3,{"LINK16_STN"}}},
	["STN id lbl_7"]={{11,4,{"LINK16_STN"}}},
	["STN id lbl_8"]={{11,5,{"LINK16_STN"}}},
	["STN value1"]={{4,2,{"INTRAFLIGHT"}}},
	["STN value2"]={{4,3,{"INTRAFLIGHT"}}},
	["STN value3"]={{4,4,{"INTRAFLIGHT"}}},
	["STN value4"]={{4,5,{"INTRAFLIGHT"}}},
	["STN value5"]={{14,2,{"INTRAFLIGHT"}}},
	["STN value6"]={{14,3,{"INTRAFLIGHT"}}},
	["STN value7"]={{14,4,{"INTRAFLIGHT"}}},
	["STN value8"]={{14,5,{"INTRAFLIGHT"}}},
	["STN value_1"]={{5,2,{"LINK16_STN"}}},
	["STN value_1_inv"]={{5,2,{"LINK16_STN"}}},
	["STN value_2"]={{5,3,{"LINK16_STN"}}},
	["STN value_2_inv"]={{5,3,{"LINK16_STN"}}},
	["STN value_3"]={{5,4,{"LINK16_STN"}}},
	["STN value_3_inv"]={{5,4,{"LINK16_STN"}}},
	["STN value_4"]={{5,5,{"LINK16_STN"}}},
	["STN value_4_inv"]={{5,5,{"LINK16_STN"}}},
	["STN value_5"]={{15,2,{"LINK16_STN"}}},
	["STN value_5_inv"]={{15,2,{"LINK16_STN"}}},
	["STN value_6"]={{15,3,{"LINK16_STN"}}},
	["STN value_6_inv"]={{15,3,{"LINK16_STN"}}},
	["STN value_7"]={{15,4,{"LINK16_STN"}}},
	["STN value_7_inv"]={{15,4,{"LINK16_STN"}}},
	["STN value_8"]={{15,5,{"LINK16_STN"}}},
	["STN value_8_inv"]={{15,5,{"LINK16_STN"}}},
	["STPT"]={{20,1,{"MARK"}}},
	["STPT NUMBER"]={{15,1,{"MARK"}}},
	["STPT NUMBER_inv"]={{15,1,{"MARK"}}},
	["STPT_inv"]={{20,1,{"MARK"}}},
	["SYNC lbl"]={{5,5,{"NET_STATUS"}}},
	["SYNC status"]={{10,5,{"NET_STATUS"}}},
	["SYS ACCURACY label"]={{5,4,{"FIX"}},{4,2,{"NAV_STATUS"}}},
	["SYS ACCURACY value"]={{15,4,{"FIX"}},{15,2,{"NAV_STATUS"}}},
	["SYSTEM_label"]={{5,2,{"TIME"}}},
	["SYSTEM_value"]={{14,2,{"TIME"}}},
	["SYSTEM_value_inv"]={{14,2,{"TIME"}}},
	["Scratchpad"]={{15,3,{"COM_1","COM_2"}},{13,4,{"NAV_STATUS"}}},
	["Scratchpad_inv"]={{15,3,{"COM_1","COM_2"}},{13,4,{"NAV_STATUS"}}},
	["Secure Voice"]={{2,1,{"COM_1","COM_2"}}},
	["Selected Steerpoint"]={{21,1,{"ALOW","CMDS_BINGO","CNI","LASER","LINK16","LINK16_STN","LIST","MISC","MODE","NET_STATUS"}}},
	["Selected UHF Frequency"]={{7,1,{"CNI"}}},
	["Selected VHF Frequency"]={{7,3,{"CNI"}}},
	["Steerpoint Use"]={{15,1,{"CNI"}}},
	["System Time"]={{16,3,{"CNI"}}},
	["T1"]={{15,1,{"HARM"}},{2,2,{"HTS_MAN"}}},
	["T1_code"]={{19,1,{"HARM"}},{4,2,{"HTS_MAN"}}},
	["T1_code_inv"]={{19,1,{"HARM"}},{4,2,{"HTS_MAN"}}},
	["T2"]={{15,2,{"HARM"}},{2,3,{"HTS_MAN"}}},
	["T2_code"]={{19,2,{"HARM"}},{4,3,{"HTS_MAN"}}},
	["T2_code_inv"]={{19,2,{"HARM"}},{4,3,{"HTS_MAN"}}},
	["T3"]={{15,3,{"HARM"}},{2,4,{"HTS_MAN"}}},
	["T3_code"]={{19,3,{"HARM"}},{4,4,{"HTS_MAN"}}},
	["T3_code_inv"]={{19,3,{"HARM"}},{4,4,{"HTS_MAN"}}},
	["T4"]={{15,4,{"HARM"}},{2,5,{"HTS_MAN"}}},
	["T4_code"]={{19,4,{"HARM"}},{4,5,{"HTS_MAN"}}},
	["T4_code_inv"]={{19,4,{"HARM"}},{4,5,{"HTS_MAN"}}},
	["T5"]={{15,5,{"HARM"}},{11,2,{"HTS_MAN"}}},
	["T5_code"]={{19,5,{"HARM"}},{13,2,{"HTS_MAN"}}},
	["T5_code_inv"]={{19,5,{"HARM"}},{13,2,{"HTS_MAN"}}},
	["T6"]={{11,3,{"HTS_MAN"}}},
	["T6_code"]={{13,3,{"HTS_MAN"}}},
	["T6_code_inv"]={{13,3,{"HTS_MAN"}}},
	["T7"]={{11,4,{"HTS_MAN"}}},
	["T7_code"]={{13,4,{"HTS_MAN"}}},
	["T7_code_inv"]={{13,4,{"HTS_MAN"}}},
	["T8"]={{11,5,{"HTS_MAN"}}},
	["T8_code"]={{13,5,{"HTS_MAN"}}},
	["T8_code_inv"]={{13,5,{"HTS_MAN"}}},
	["TACAN A-A Distance"]={{20,5,{"CNI"}}},
	["TACAN A-A Distance_inv"]={{20,5,{"CNI"}}},
	["TACAN Band"]={{24,5,{"CNI"}}},
	["TACAN Channel"]={{21,5,{"CNI"}}},
	["TACAN Label"]={{20,5,{"CNI"}}},
	["TCN BAND Key"]={{7,5,{"T_ILS_PRIMARY"}}},
	["TCN BAND Label"]={{1,5,{"T_ILS_PRIMARY"}}},
	["TCN BAND XY"]={{6,5,{"T_ILS_PRIMARY"}}},
	["TCN BCN ID"]={{5,3,{"T_ILS_PRIMARY"}}},
	["TCN BCN Label"]={{1,3,{"T_ILS_PRIMARY"}}},
	["TCN BIG OFF Label"]={{6,1,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["TCN CHAN Asterisks_lhs"]={{5,4,{"T_ILS_PRIMARY"}}},
	["TCN CHAN Asterisks_rhs"]={{9,4,{"T_ILS_PRIMARY"}}},
	["TCN CHAN Label"]={{1,4,{"T_ILS_PRIMARY"}}},
	["TCN CHAN Scratchpad"]={{6,4,{"T_ILS_PRIMARY"}}},
	["TCN CHAN Scratchpad_inv"]={{6,4,{"T_ILS_PRIMARY"}}},
	["TCN Label"]={{2,1,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["TCN Mode"]={{6,1,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["TGP CODE Asteriscs_lhs"]={{13,2,{"LASER"}}},
	["TGP CODE Asteriscs_rhs"]={{18,2,{"LASER"}}},
	["TGP CODE LABEL"]={{2,2,{"LASER"}}},
	["TGP CODE VALUE"]={{14,2,{"LASER"}}},
	["TGP CODE VALUE_inv"]={{14,2,{"LASER"}}},
	["TILS Asterisks_lhs"]={{8,3,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["TILS Asterisks_rhs"]={{15,3,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["TILS Scratchpad"]={{9,3,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["TILS Scratchpad_inv"]={{9,3,{"T_ILS_BACKUP","T_ILS_COMMON","T_ILS_PRIMARY"}}},
	["TIM EVENT - Time"]={{19,4,{"IFF_MAIN_STAT"}}},
	["TIME lbl"]={{5,3,{"NET_STATUS"}}},
	["TIME value"]={{10,3,{"NET_STATUS"}}},
	["TIME value_inv"]={{10,3,{"NET_STATUS"}}},
	["TIME_label"]={{10,1,{"TIME"}}},
	["TOD Label"]={{18,4,{"COM_1"}}},
	["TODO remove label"]={{5,4,{"CORR_CAMERA","CORR_COMMON_1_5","CORR_COMMON_6_9","CORR_COMMON_ANGLES","CORR_CTVS_1","CORR_CTVS_2","CORR_FCR","CORR_FLIR","CORR_HUD_1","CORR_HUD_2","CORR_INS","CORR_LT_HDPT","CORR_RT_HDPT","DRNG","GPS_INIT_1","GPS_INIT_2","INSM","OFP_1","OFP_2","OFP_COMMON","STPT_BACKUP"}}},
	["TODO remove lbl"]={{5,2,{"CORR_CAMERA","CORR_COMMON_1_5","CORR_COMMON_6_9","CORR_COMMON_ANGLES","CORR_CTVS_1","CORR_CTVS_2","CORR_FCR","CORR_FLIR","CORR_HUD_1","CORR_HUD_2","CORR_INS","CORR_LT_HDPT","CORR_RT_HDPT","DRNG","GPS_INIT_1","GPS_INIT_2","INSM","OFP_1","OFP_2","OFP_COMMON","STPT_BACKUP"}}},
	["TOF Data"]={{12,5,{"MAN"}}},
	["TOF Label"]={{9,5,{"MAN"}}},
	["TOF SEC"]={{18,5,{"MAN"}}},
	["TOS"]={{9,5,{"DEST_DIR"}}},
	["TOS_DES_TOS_label"]={{5,3,{"CRUS_TOS"}}},
	["TOS_DES_TOS_value"]={{13,3,{"CRUS_TOS"}}},
	["TOS_DES_TOS_value_inv"]={{13,3,{"CRUS_TOS"}}},
	["TOS_ETA_label"]={{9,4,{"CRUS_TOS"}}},
	["TOS_ETA_value"]={{13,4,{"CRUS_TOS"}}},
	["TOS_MODE"]={{14,1,{"CRUS_TOS"}}},
	["TOS_MODE_inv"]={{14,1,{"CRUS_TOS"}}},
	["TOS_REQ_GS_label"]={{5,5,{"CRUS_TOS"}}},
	["TOS_REQ_GS_value"]={{14,5,{"CRUS_TOS"}}},
	["TOS_SYSTEM_TIME_label"]={{8,2,{"CRUS_TOS"}}},
	["TOS_SYSTEM_TIME_value"]={{14,2,{"CRUS_TOS"}}},
	["TOS_VALID_STPT_value"]={{4,4,{"CRUS_TOS"}}},
	["TOS_inv"]={{9,5,{"DEST_DIR"}}},
	["TOTAL LBS label"]={{17,4,{"BINGO"}}},
	["TOTAL label"]={{5,4,{"BINGO"}}},
	["TOTAL value"]={{12,4,{"BINGO"}}},
	["Target bearing"]={{5,3,{"VRP"}}},
	["Target bearing Asteriscs_lhs"]={{10,3,{"VRP"}}},
	["Target bearing Asteriscs_rhs"]={{17,3,{"VRP"}}},
	["Target bearing value"]={{11,3,{"VRP"}}},
	["Target bearing value_inv"]={{11,3,{"VRP"}}},
	["Target number"]={{6,2,{"VRP"}}},
	["Target number Asteriscs_lhs"]={{10,2,{"VRP"}}},
	["Target number Asteriscs_rhs"]={{14,2,{"VRP"}}},
	["Target number up down arrows"]={{15,2,{"VRP"}}},
	["Target number value"]={{11,2,{"VRP"}}},
	["Target number value_inv"]={{11,2,{"VRP"}}},
	["Target to VRP Label"]={{7,1,{"VRP"}}},
	["Target to VRP Label Asteriscs_lhs"]={{6,1,{"VRP"}}},
	["Target to VRP Label Asteriscs_rhs"]={{17,1,{"VRP"}}},
	["Target to VRP Label_inv"]={{7,1,{"VRP"}}},
	["TblNum"]={{7,1,{"HARM"}}},
	["UHF IncDecSymbol"]={{6,1,{"CNI"}}},
	["UHF Mode Rotary"]={{2,1,{"CNI"}}},
	["UHF Mode Rotary_inv"]={{2,1,{"CNI"}}},
	["UHF Status"]={{2,2,{"CNI"}}},
	["UTM_DEST"]={{3,1,{"DEST_UTM_DIR"}}},
	["UTM_DEST_CNVRT"]={{19,2,{"DEST_UTM_DIR"}}},
	["UTM_DEST_CNVRT_inv"]={{19,2,{"DEST_UTM_DIR"}}},
	["UTM_DEST_EAST/NORTH"]={{1,4,{"DEST_UTM_DIR"}}},
	["UTM_DEST_ELEV"]={{7,5,{"DEST_UTM_DIR"}}},
	["UTM_DEST_GRID"]={{7,2,{"DEST_UTM_DIR"}}},
	["UTM_DEST_SQUARE"]={{5,3,{"DEST_UTM_DIR"}}},
	["UTM_DEST_STPT_IncDecSymbol"]={{17,1,{"DEST_UTM_DIR"}}},
	["UTM_DEST_SelectedSteerpoint"]={{13,1,{"DEST_UTM_DIR"}}},
	["UTM_DEST_SelectedSteerpoint_inv"]={{13,1,{"DEST_UTM_DIR"}}},
	["VCS IncDecSymbol"]={{15,2,{"LINK16"}}},
	["VHF IncDecSymbol"]={{6,3,{"CNI"}}},
	["VHF Label"]={{2,3,{"CNI"}},{9,1,{"COM_2_GUARD"}}},
	["VHF Label_inv"]={{2,3,{"CNI"}}},
	["VHF Status"]={{2,4,{"CNI"}}},
	["VIP bearing"]={{5,3,{"VIP"}}},
	["VIP bearing Asteriscs_lhs"]={{10,3,{"VIP"}}},
	["VIP bearing Asteriscs_rhs"]={{17,3,{"VIP"}}},
	["VIP bearing value"]={{11,3,{"VIP"}}},
	["VIP bearing value_inv"]={{11,3,{"VIP"}}},
	["VIP number Asteriscs_lhs"]={{10,2,{"VIP"}}},
	["VIP number Asteriscs_rhs"]={{14,2,{"VIP"}}},
	["VIP number up down arrows"]={{15,2,{"VIP"}}},
	["VIP number value"]={{11,2,{"VIP"}}},
	["VIP number value_inv"]={{11,2,{"VIP"}}},
	["VIP to TGT Label Asteriscs_lhs"]={{6,1,{"VIP"}}},
	["VIP to TGT Label Asteriscs_rhs"]={{17,1,{"VIP"}}},
	["Visual initial point number"]={{6,2,{"VIP"}}},
	["Visual initial point to TGT Label"]={{7,1,{"VIP"}}},
	["Visual initial point to TGT Label_inv"]={{7,1,{"VIP"}}},
	["WPT IncDecSymbol"]={{24,1,{"ALOW","CMDS_BINGO","LASER","LINK16","LINK16_STN","LIST","MISC","MODE","NET_STATUS"}},{20,1,{"CNI"}}},
	["WSPAN Asteriscs_lhs"]={{13,2,{"MAN"}}},
	["WSPAN Asteriscs_rhs"]={{19,2,{"MAN"}}},
	["WSPAN DATA"]={{14,2,{"MAN"}}},
	["WSPAN Label"]={{7,2,{"MAN"}}},
	["Wind Magnetic Direction"]={{17,2,{"CNI"}}},
	["Wind Speed"]={{21,2,{"CNI"}}},
	["XMT lbl"]={{4,2,{"AG_DL"}},{12,4,{"LINK16"}}},
	["XMT status"]={{17,4,{"LINK16"}}},
	["XMT value"]={{8,2,{"AG_DL"}}},
	["ZEROIZE GPS label"]={{7,5,{"NAV_COMMANDS"}}},
	["ZEROIZE GPS label_inv"]={{7,5,{"NAV_COMMANDS"}}},
}

DED.LAYOUT = LAYOUT

local BLANK = string.rep(" ", DED.WIDTH)

--- Works out which DED page is showing. The page name is not in the dump, so it
--- is inferred from the elements present.
--- @param indicator table parsed indicator (element name -> text)
--- @return string page name, or "" when it cannot be determined
function DED.getPage(indicator)
	if type(indicator) ~= "table" then
		return ""
	end

	-- an element that exists in one place on one page identifies that page
	local votes = {}
	for name in pairs(indicator) do
		local candidates = LAYOUT[name]
		if candidates and #candidates == 1 and #candidates[1][3] == 1 then
			local page = candidates[1][3][1]
			votes[page] = (votes[page] or 0) + 1
		end
	end

	-- otherwise fall back to the page that the most elements could belong to
	if next(votes) == nil then
		for name in pairs(indicator) do
			local candidates = LAYOUT[name]
			if candidates then
				for _, candidate in ipairs(candidates) do
					for _, page in ipairs(candidate[3]) do
						votes[page] = (votes[page] or 0) + 1
					end
				end
			end
		end
	end

	local best, best_count = "", 0
	for page, count in pairs(votes) do
		if count > best_count or (count == best_count and page < best) then
			best, best_count = page, count
		end
	end
	return best
end

--- Picks where an element is drawn on the given page.
local function placement(name, page)
	local candidates = LAYOUT[name]
	if not candidates then
		return nil
	end
	if #candidates == 1 then
		return candidates[1]
	end
	for _, candidate in ipairs(candidates) do
		for _, candidate_page in ipairs(candidate[3]) do
			if candidate_page == page then
				return candidate
			end
		end
	end
	return nil
end

--- Returns all five rows as an array of strings, each 24 characters.
--- @param indicator table parsed indicator (element name -> text)
--- @return table lines lines[1] is the top row, lines[5] the bottom row
function DED.getLines(indicator)
	local rows = {}
	for row = 1, DED.ROWS do
		local chars = {}
		for i = 1, DED.WIDTH do
			chars[i] = " "
		end
		rows[row] = chars
	end

	if type(indicator) == "table" then
		local page = DED.getPage(indicator)
		for name, text in pairs(indicator) do
			if type(name) == "string" then
				local place = placement(name, page)
				local chars = place and rows[place[2]]
				if chars then
					text = tostring(text)
					for i = 1, #text do
						local column = place[1] + i - 1
						local c = text:sub(i, i)
						-- spaces never erase what another element put there
						if column >= 1 and column <= DED.WIDTH and c ~= " " then
							chars[column] = c
						end
					end
				end
			end
		end
	end

	local lines = {}
	for row = 1, DED.ROWS do
		lines[row] = table.concat(rows[row])
	end
	return lines
end

--- Returns the text currently shown on one row of the DED.
--- @param indicator table parsed indicator (element name -> text)
--- @param row number DED row, 1 (top) to 5 (bottom)
--- @return string line always 24 characters, padded with spaces
function DED.getLine(indicator, row)
	row = tonumber(row)
	if not row or row < 1 or row > DED.ROWS or row % 1 ~= 0 then
		return BLANK
	end
	return DED.getLines(indicator)[row]
end

-- Helios ----------------------------------------------------------------------

--- Characters the Helios network protocol cannot carry, and what replaces them.
DED.HELIOS_REPLACE = { [":"] = "!", ["="] = "-" }

local function heliosSafe(line)
	return (line:gsub("[%c:=]", function(c)
		return DED.HELIOS_REPLACE[c] or " "
	end))
end

--- Same as DED.getLine, with ":" and "=" replaced so the result can be passed
--- to helios.send().
function DED.getHeliosLine(indicator, row)
	return heliosSafe(DED.getLine(indicator, row))
end

--- Same as DED.getLines, with ":" and "=" replaced for helios.send().
function DED.getHeliosLines(indicator)
	local lines = DED.getLines(indicator)
	for row = 1, DED.ROWS do
		lines[row] = heliosSafe(lines[row])
	end
	return lines
end

--- Returns all five rows in one string, rows separated by a line break
--- (or by `separator` when given). Each row is 24 characters.
function DED.getAllLines(indicator, separator)
	return table.concat(DED.getLines(indicator), separator or "\n")
end

--- Same as DED.getAllLines, safe to pass to helios.send(). A Helios Text
--- Display shows the line breaks, so one display can show the whole DED.
function DED.getHeliosAllLines(indicator, separator)
	return table.concat(DED.getHeliosLines(indicator), separator or "\n")
end

-- CMDS display ------------------------------------------------------------------

DED.CMDS_INDICATOR = 16
DED.CMDS_WIDTH = 4

--- The four CMDS windows, left to right, with the indicator element behind each.
DED.CMDS_FIELDS = { "O1", "O2", "CH", "FL" }
local CMDS_ELEMENTS = {
	O1 = "CMDS_O1_Amount",
	O2 = "CMDS_O2_Amount",
	CH = "CMDS_CH_Amount",
	FL = "CMDS_FL_Amount",
}
local CMDS_BLANK = string.rep(" ", DED.CMDS_WIDTH)

local function cmdsField(field)
	if type(field) == "number" then
		return DED.CMDS_FIELDS[field]
	end
	if type(field) == "string" then
		field = field:upper()
		if CMDS_ELEMENTS[field] then
			return field
		end
	end
	return nil
end

--- Returns the text in one CMDS window.
--- @param indicator table parsed CMDS indicator (helios.parseIndication(16))
--- @param field string|number "O1", "O2", "CH", "FL" (or 1 to 4, left to right)
--- @return string text always 4 characters, padded with spaces
function DED.getCMDS(indicator, field)
	field = cmdsField(field)
	if not field or type(indicator) ~= "table" then
		return CMDS_BLANK
	end
	local value = indicator[CMDS_ELEMENTS[field]]
	if value == nil then
		return CMDS_BLANK
	end
	value = tostring(value):gsub("%c", " ")
	return (value .. CMDS_BLANK):sub(1, DED.CMDS_WIDTH)
end

--- Returns all four CMDS windows as a table keyed O1, O2, CH, FL.
function DED.getCMDSAll(indicator)
	local all = {}
	for _, field in ipairs(DED.CMDS_FIELDS) do
		all[field] = DED.getCMDS(indicator, field)
	end
	return all
end

--- Returns the whole CMDS display as one line: the four windows left to
--- right separated by single spaces (19 characters).
function DED.getCMDSLine(indicator)
	local parts = {}
	for i, field in ipairs(DED.CMDS_FIELDS) do
		parts[i] = DED.getCMDS(indicator, field)
	end
	return table.concat(parts, " ")
end

--- Same as DED.getCMDS, safe to pass to helios.send().
function DED.getHeliosCMDS(indicator, field)
	return heliosSafe(DED.getCMDS(indicator, field))
end

--- Same as DED.getCMDSLine, safe to pass to helios.send().
function DED.getHeliosCMDSLine(indicator)
	return heliosSafe(DED.getCMDSLine(indicator))
end

-- UHF backup control panel displays ------------------------------------------------
-- The UHF panel on the left console has two displays of its own:
--   CHAN display      indicator 10, element txtPresetChannel   2 characters
--   frequency display indicator 11, elements txtFreqStatus (6 digits) and
--                     txtDot (the decimal point), shown as "305.000"
-- Element names as used by DCS-BIOS (F-16C_50.lua, UHF_CHAN_DISP / UHF_FREQ_DISP).

DED.UHF_CHAN_INDICATOR = 10
DED.UHF_FREQ_INDICATOR = 11
DED.UHF_CHAN_WIDTH = 2
DED.UHF_FREQ_WIDTH = 7

local function fit(text, width, alignRight)
	text = tostring(text or ""):gsub("%c", " ")
	local pad = string.rep(" ", width)
	if alignRight then
		return (pad .. text):sub(-width)
	end
	return (text .. pad):sub(1, width)
end

--- Returns the UHF CHAN display: 2 characters, right aligned, blank when off.
--- @param indicator table parsed indicator (helios.parseIndication(10))
function DED.getUHFChannel(indicator)
	if type(indicator) ~= "table" then
		return fit("", DED.UHF_CHAN_WIDTH)
	end
	return fit(indicator.txtPresetChannel, DED.UHF_CHAN_WIDTH, true)
end

--- Returns the UHF frequency display: 7 characters such as "305.000",
--- blank when off.
--- @param indicator table parsed indicator (helios.parseIndication(11))
function DED.getUHFFrequency(indicator)
	if type(indicator) ~= "table" or indicator.txtFreqStatus == nil then
		return fit("", DED.UHF_FREQ_WIDTH)
	end
	local digits = tostring(indicator.txtFreqStatus)
	local dot = indicator.txtDot or " "
	return fit(digits:sub(1, 3) .. dot .. digits:sub(4, 6), DED.UHF_FREQ_WIDTH)
end

--- Same as DED.getUHFChannel / DED.getUHFFrequency, safe to pass to helios.send().
function DED.getHeliosUHFChannel(indicator)
	return heliosSafe(DED.getUHFChannel(indicator))
end
function DED.getHeliosUHFFrequency(indicator)
	return heliosSafe(DED.getUHFFrequency(indicator))
end

-- PFL (Pilot Fault List) -------------------------------------------------------------
-- Where DCS shows the PFL is not documented by DCS-BIOS or Helios, so this part
-- is generic and configurable:
--   PFL.INDICATOR     the DCS indicator to read. The default, 6, is the DED:
--                     on the Block 50 the fault list is shown on the DED.
--   PFL.SKIP_DED      true = ignore every element the DED layout table knows,
--                     so normal DED pages give a blank PFL and only the
--                     unknown (fault list) elements are shown.
-- Each remaining element becomes one row, in the order DCS lists them, up to
-- 5 rows of 24 characters. If the rows come out wrong, turn on
-- DED.DUMP_INDICATORS (below), reproduce the fault list in DCS, and look in
-- Saved Games\DCS\Logs\dcs.log for "F-16C INDICATOR" to see the real layout.

local PFL = {}
DED.PFL = PFL
PFL.INDICATOR = 6
PFL.SKIP_DED = true
PFL.WIDTH = 24
PFL.ROWS = 5

--- Reads an indicator keeping DCS's element order (helios.parseIndication
--- returns an unordered table). Returns a list of { name, text }.
local function orderedIndication(id)
	local raw = list_indication(id)
	local items = {}
	if type(raw) ~= "string" or raw == "" then
		return items
	end
	local split = string.rep("-", 41)
	local expect = nil
	for line in (raw:gsub("\r", "") .. "\n"):gmatch("([^\n]*)\n") do
		if line == split then
			expect = "name"
		elseif expect == "name" then
			items[#items + 1] = { line, "" }
			expect = "value"
		elseif expect == "value" then
			if line ~= "children are {" and line ~= "}" then
				items[#items][2] = line
			end
			expect = nil
		end
	end
	return items
end

--- Returns the PFL rows as an array of 5 strings, each 24 characters.
function PFL.getLines()
	local lines = {}
	for _, item in ipairs(orderedIndication(PFL.INDICATOR)) do
		local name, text = item[1], item[2]
		local known = PFL.SKIP_DED and PFL.INDICATOR == 6 and LAYOUT[name] ~= nil
		if not known and text:find("%S") and #lines < PFL.ROWS then
			lines[#lines + 1] = fit(text, PFL.WIDTH)
		end
	end
	for row = #lines + 1, PFL.ROWS do
		lines[row] = fit("", PFL.WIDTH)
	end
	return lines
end

--- Same as PFL.getLines, safe to pass to helios.send().
function PFL.getHeliosLines()
	local lines = PFL.getLines()
	for row = 1, PFL.ROWS do
		lines[row] = heliosSafe(lines[row])
	end
	return lines
end

-- Indicator dump (diagnostics, off by default) ----------------------------------------
-- true = write the contents of every F-16 indicator to dcs.log whenever one
-- changes (checked at most once every 2 seconds). Use it to find the PFL, then
-- set it back to false: it makes dcs.log grow quickly.
DED.DUMP_INDICATORS = false
local dumpLast, dumpTime = {}, 0

local function dumpIndicators()
	local now = LoGetModelTime and LoGetModelTime() or 0
	if now - dumpTime < 2 then
		return
	end
	dumpTime = now
	for id = 0, 40 do
		local raw = list_indication(id)
		if type(raw) == "string" and raw ~= "" and raw ~= dumpLast[id] then
			dumpLast[id] = raw
			log.write("HELIOS.EXPORT", log.INFO,
				string.format("F-16C INDICATOR %d\n%s", id, raw))
		end
	end
end

-- ============================== Helios driver =================================

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

    -- ---- DED: helios.parseIndication(6) -> DED Output Data / DED_LINE_1..5 ----
    local ded = helios.parseIndication(6)
    helios.send("2601", DED.getHeliosLine(ded, 1))  -- DED_LINE_1
    helios.send("2602", DED.getHeliosLine(ded, 2))  -- DED_LINE_2
    helios.send("2603", DED.getHeliosLine(ded, 3))  -- DED_LINE_3
    helios.send("2604", DED.getHeliosLine(ded, 4))  -- DED_LINE_4
    helios.send("2605", DED.getHeliosLine(ded, 5))  -- DED_LINE_5
    helios.send("2600", DED.getHeliosAllLines(ded)) -- DED_ALL_LINES (all 5 rows)

    -- ---- CMDS: helios.parseIndication(16) -> CMDS / CMDS_xx_Amount ----
    local cmds = helios.parseIndication(16)
    helios.send("2606", DED.getHeliosCMDS(cmds, "O1")) -- CMDS_O1_Amount
    helios.send("2607", DED.getHeliosCMDS(cmds, "O2")) -- CMDS_O2_Amount
    helios.send("2608", DED.getHeliosCMDS(cmds, "CH")) -- CMDS_CH_Amount
    helios.send("2609", DED.getHeliosCMDS(cmds, "FL")) -- CMDS_FL_Amount

    -- ---- UHF panel: indicators 10 and 11 -> UHF / UHF_CHAN_DISP, UHF_FREQ_DISP ----
    helios.send("2620", DED.getHeliosUHFChannel(helios.parseIndication(DED.UHF_CHAN_INDICATOR)))   -- UHF_CHAN_DISP
    helios.send("2621", DED.getHeliosUHFFrequency(helios.parseIndication(DED.UHF_FREQ_INDICATOR))) -- UHF_FREQ_DISP

    -- ---- PFL -> PFL Output Data / PFL_LINE_1..5, PFL_ALL_LINES ----
    -- run protected: a problem here must not stop the other exports
    local ok, pfl = pcall(PFL.getHeliosLines)
    if ok then
        for row = 1, PFL.ROWS do
            helios.send(tostring(2630 + row), pfl[row])  -- PFL_LINE_1..5
        end
        helios.send("2630", table.concat(pfl, "\n"))      -- PFL_ALL_LINES
    elseif not PFL.errorLogged then
        PFL.errorLogged = true
        log.write("HELIOS.EXPORT", log.ERROR, "F-16C PFL export failed: " .. tostring(pfl))
    end

    if DED.DUMP_INDICATORS then
        pcall(dumpIndicators)
    end

end



function driver.processHighImportance(mainPanelDevice)

end
