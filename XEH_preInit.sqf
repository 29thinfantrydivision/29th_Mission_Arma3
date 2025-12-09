#define SECTOR_SETTINGS_CATEGORY "29th - Sector Settings"

[
    "DOTT_costInfantry", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    ["Infantry Weight", "Capture Weight of Infantry"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    SECTOR_SETTINGS_CATEGORY, // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [0, 10, 1, 2], // data for this setting: [min, max, default, number of shown trailing decimals]
	1
] call CBA_fnc_addSetting;

[
    "DOTT_costWheeled", 
    "SLIDER", 
    ["Wheeled Weight", "Capture Weight of Wheeled Vehicles"], 
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 1, 2],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_costTracked", 
    "SLIDER", 
    ["Tracked Weight", "Capture Weight of Tracked Vehicles"],
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 2, 2],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_costStatic", 
    "SLIDER", 
    ["Static Weight", "Capture Weight of Static Weapons"], 
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 1, 2],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_costWater", 
    "SLIDER", 
    ["Water Weight", "Capture Weight of Naval Vehicles"], 
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 1, 2],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_costAir", 
    "SLIDER", 
    ["Air Weight", "Capture Weight of Air Vehicles"], 
    SECTOR_SETTINGS_CATEGORY,
    [0, 10, 0, 2],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_captureCoef", 
    "SLIDER", 
    "Capture Speed", 
    SECTOR_SETTINGS_CATEGORY,
    [0, 1, 0.05, 3],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_checkCrew", 
    "LIST", 
    ["Count Vehicle Crew Weight", "Units inside vehicle types contribute weight towards capture"], 
    SECTOR_SETTINGS_CATEGORY,
    [[[false,false],[true, false], [true, true]],["No", "Land/Naval Only", "Yes"], 0],
	1
] call CBA_fnc_addSetting;

[
    "DOTT_useThreat", 
    "CHECKBOX", 
    ["Use Vehicle Threat Value", "Vehicle capture weight is further modified by config threat values."], 
    SECTOR_SETTINGS_CATEGORY,
    false,
	1
] call CBA_fnc_addSetting;

#define RADIO_SETTINGS_CATEGORY "29th - Radio Settings"
[
    "DOTT_removeRadiosOnDeath", 
    "CHECKBOX", 
    "Remove SR radios on death",
    RADIO_SETTINGS_CATEGORY,
    true,
	1
] call CBA_fnc_addSetting;

#define GENERAL_SETTINGS_CATEGORY "29th - General Settings"

[
    "DOTT_removeDefaultVehicleInventories", 
    "CHECKBOX", 
    "Remove default inventories from vehicles",
    GENERAL_SETTINGS_CATEGORY,
    true,
	1
] call CBA_fnc_addSetting;

#define SPECTATOR_SUBCATEGORY "Spectator"

[
    "DOTT_autoSpectate", 
    "CHECKBOX", 
    "Automatic Spectate on Respawn",
    [GENERAL_SETTINGS_CATEGORY, SPECTATOR_SUBCATEGORY],
    false,
	1
] call CBA_fnc_addSetting;

#define RESTRICTIONS_SUBCATEGORY "Restrictions"
[
    "DOTT_disableTI", 
    "CHECKBOX", 
    "Disable thermal imaging optics?",
    [GENERAL_SETTINGS_CATEGORY, RESTRICTIONS_SUBCATEGORY],
    true,
	1,
    {
        if (hasInterface) then 
        {
            ace_javelin_ignoreVisionMode = _this;
            if (!alive player || isNull (objectParent player)) exitWith {};
            systemChat format ["Thermal imaging optics have been %1. Kicking player out of vehicles to apply changes.", if !(_this) then {"enabled"} else {"disabled"}];
            moveOut player; //pip thermal disable needs this
        };

        if (isServer) then
        {
            {
                if !(_x isKindOf "Man") then 
                {
                    _x disableTIEquipment _this;
                };
            } forEach allMissionObjects "AllVehicles";
        };
    }
] call CBA_fnc_addSetting;

[
    "DOTT_artilleryComputer", 
    "CHECKBOX", 
    "Enable Artillery Computer?",
    [GENERAL_SETTINGS_CATEGORY, RESTRICTIONS_SUBCATEGORY],
    false,
	1,
    {
        if (isServer) then 
        {
            ["ace_artillerytables_disableArtilleryComputer", !(_this), nil, "server", false] call cba_settings_fnc_set;
            ["ace_mk6mortar_allowComputerRangefinder", _this, nil, "server", false] call cba_settings_fnc_set;            
        };  

        if (hasInterface) then
        {
            enableEngineArtillery _this;
        };   
    }
] call CBA_fnc_addSetting;