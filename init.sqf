/**
 * init.sqf
 * Purpose: Mission initialization entry point. Iterates through DOTT_MODULES
 *          and calls each module's init function in order.
 * Params:  None
 * Return:  None
 */

diag_log text format [
    "|===== %1: init.sqf Running =====|",
    missionName
];

#include "data\defines.hpp"

// Modules are defined in defines.hpp as a preprocessor macro.
// Guard against undefined or empty module list.
if (isNil "DOTT_MODULES") exitWith {
    diag_log text "ERROR: DOTT_MODULES is not defined.";
};

{
    private _moduleInitName =
        format ["DOTT_%1_fnc_init", _x];
    private _function =
        missionNamespace getVariable [_moduleInitName, {}];
    call _function;
} forEach DOTT_MODULES;
