#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Client-side OCAP initialization.
 * Handles JIP player registration.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * remoteExecCall ["TN_ocap_fnc_initClient", 0, true];
 */

if !(hasInterface) exitWith {};

[{!isNull player}, {
    [player] remoteExecCall
        [QFUNC(initializePlayer), 2];
}] call CBA_fnc_waitUntilAndExecute;

nil
