/**
 * XEH_preInit (loadout module)
 *
 * Purpose: Registers the CBA setting that controls whether automatic
 *          29th insignia application is enabled.
 *
 * Params:  None
 * Returns: Nothing
 */

#include "..\..\data\settingCategories.hpp"

[
    "TN_setInsignia",
    "CHECKBOX",
    "Automatically set 29th Insignia",
    [GENERAL_SETTINGS_CATEGORY, LOADOUT_SUBCATEGORY],
    true,
    1
] call CBA_fnc_addSetting;
