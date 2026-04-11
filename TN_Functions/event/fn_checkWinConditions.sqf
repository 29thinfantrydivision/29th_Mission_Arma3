#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Evaluates pre-built win condition arrays. Called reactively
 * from sector/kill event handlers and on round end.
 *
 * Arguments:
 * 0: Game/round has ended <BOOL> (default: false)
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [false] call TN_event_fnc_checkWinConditions;
 * [true] call TN_event_fnc_checkWinConditions;
 */

params [["_gameEnded", false, [false]]];

if (GVAR(useRoundSystem)
    && {NOT_ROUND_LIVE}
    && {!_gameEnded}) exitWith {};

private _checks = if (_gameEnded) then {
    GVAR(endChecks)
} else {
    GVAR(loopChecks)
};

{
    if (call _x) exitWith {
        private _winningSide = _forEachIndex call BIS_fnc_sideType;
        [_winningSide] call FUNC(game);
    };
} forEach _checks;

if (_gameEnded) then {
    [] call FUNC(game);
};

nil
