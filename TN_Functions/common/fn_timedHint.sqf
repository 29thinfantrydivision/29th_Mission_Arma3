#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Displays a hint for a specified duration then clears it.
 * Safe to call multiple times — a newer call prevents stale clears.
 *
 * Arguments:
 * 0: Message <STRING>
 * 1: Duration in seconds <NUMBER>
 * 2: True to use hintSilent instead of hint <BOOL> (default: false)
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * ["Round starting in 10 seconds!", 5] call TN_common_fnc_timedHint;
 */

params [
    ["_msg", "", [""]],
    ["_duration", 5, [0]],
    ["_silent", false, [false]]
];

//Hints fade out after 30ish seconds, so cap duration.
_duration = _duration min 30;

// Increment the hint ID so any pending clear from a prior call is invalidated
private _id = (GVAR(timedHintId) + 1);
GVAR(timedHintId) = _id;

if (_silent) then { hintSilent _msg } else { hint _msg };

[{
    params ["_id"];
    if (GVAR(timedHintId) == _id) then {
        hintSilent "";
    };
}, [_id], _duration] call CBA_fnc_waitAndExecute;

nil
