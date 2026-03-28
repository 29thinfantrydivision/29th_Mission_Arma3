#include "script_component.hpp"
#include "..\..\data\settingCategories.hpp"

[
    QGVARMAIN(setInsignia),
    "CHECKBOX",
    "Automatically set 29th Insignia",
    [GENERAL_SETTINGS_CATEGORY, LOADOUT_SUBCATEGORY],
    true,
    1
] call CBA_fnc_addSetting;
