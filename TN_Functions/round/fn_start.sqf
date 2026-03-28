#include "defines.hpp"

/*
 * Author: Bae [29th ID], modified from Dott [29th ID]
 * Starts the round with a specified timer length. Displays a LIVE
 * notification, kicks off the countdown, schedules the end-of-round
 * check, fires the round_started event, and clears safe start state.
 *
 * Arguments:
 * 0: Round duration in seconds (default: TN_round_timerLength) <NUMBER>
 *
 * Return Value:
 * false if round already active, true otherwise <BOOL>
 *
 * Example:
 * [] call TN_round_fnc_start;
 */

params [["_roundLength", GVAR(timerLength), [0]]];

if (ROUND_LIVE) exitWith {false};

[_roundLength] call BIS_fnc_countdown;

/* --- LIVE notification --- */
private _msgText = format [
    "<t color='#ffffff'><t size='4'>LIVE LIVE LIVE</t><br/><t size='2'>%1 Time Limit</t></t>",
    [_roundLength, true] call FUNC(formatTime)
];

[
    _msgText,
    "PLAIN",
    0.5,
    false
] remoteExecCall [QEFUNC(common,displayMsg)];

/* --- Schedule end-of-round check on server --- */
[{
    [
        {call FUNC(getTime) <= 0},
        {call FUNC(end)},
        []
    ] call CBA_fnc_waitUntilAndExecute;
}] remoteExecCall ["call", 2];

/* --- Reset state --- */
UNREADY_ALL_SIDES;

GVAR(state) = 2;
publicVariable QGVAR(state);

[] remoteExecCall [QFUNC(roundEvents)];

[QGVAR(started), []] call CBA_fnc_globalEvent;

true
