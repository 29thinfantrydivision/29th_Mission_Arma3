/**
 * File: XEH_preInit.sqf
 * Author: Bae [29th ID]
 *
 * Description:
 *     Registers CBA settings for sector capture weights and
 *     behavior. These sliders/checkboxes appear in the CBA
 *     Settings GUI under "29th - Sector Settings" and let
 *     mission makers tune how much each unit type contributes
 *     to sector capture score at runtime.
 *
 * Parameters:
 *     None (executed automatically by CBA XEH)
 *
 * Returns:
 *     Nothing
 */

#include "..\..\data\settingCategories.hpp"

// --- Infantry capture weight ---
[
    "TN_costInfantry",
    "SLIDER",
    ["Infantry Weight", "Capture Weight of Infantry"],
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 1, 2],
    1
] call CBA_fnc_addSetting;

// --- Wheeled vehicle capture weight ---
[
    "TN_costWheeled",
    "SLIDER",
    ["Wheeled Weight", "Capture Weight of Wheeled Vehicles"],
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 1, 2],
    1
] call CBA_fnc_addSetting;

// --- Tracked vehicle capture weight ---
[
    "TN_costTracked",
    "SLIDER",
    ["Tracked Weight", "Capture Weight of Tracked Vehicles"],
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 2, 2],
    1
] call CBA_fnc_addSetting;

// --- Static weapon capture weight ---
[
    "TN_costStatic",
    "SLIDER",
    ["Static Weight", "Capture Weight of Static Weapons"],
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 1, 2],
    1
] call CBA_fnc_addSetting;

// --- Naval vehicle capture weight ---
[
    "TN_costWater",
    "SLIDER",
    ["Water Weight", "Capture Weight of Naval Vehicles"],
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 1, 2],
    1
] call CBA_fnc_addSetting;

// --- Air vehicle capture weight ---
[
    "TN_costAir",
    "SLIDER",
    ["Air Weight", "Capture Weight of Air Vehicles"],
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 0, 2],
    1
] call CBA_fnc_addSetting;

// --- Capture speed multiplier ---
[
    "TN_captureCoef",
    "SLIDER",
    "Capture Speed",
    SECTOR_SETTINGS_CATEGORY,
    [0, 1, 0.05, 3],
    1
] call CBA_fnc_addSetting;

// --- Whether crew inside vehicles count toward capture ---
[
    "TN_checkCrew",
    "LIST",
    [
        "Count Vehicle Crew Weight",
        "Units inside vehicle types contribute weight towards capture"
    ],
    SECTOR_SETTINGS_CATEGORY,
    [
        [[false, false], [true, false], [true, true]],
        ["No", "Land/Naval Only", "Yes"],
        0
    ],
    1
] call CBA_fnc_addSetting;

// --- Whether config threat values modify vehicle weight ---
[
    "TN_useThreat",
    "CHECKBOX",
    [
        "Use Vehicle Threat Value",
        "Vehicle capture weight is further modified by config threat values."
    ],
    SECTOR_SETTINGS_CATEGORY,
    false,
    1
] call CBA_fnc_addSetting;
