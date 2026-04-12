#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Adjust lives of player when lives system is enabled.
 * The system does not use this function internally,
 * this is intended for manually adjusting specific players
 * (ex. by admin).
 *
 * Arguments:
 * 0: Player unit to reference <OBJECT>
 * 1: New number of lives <NUMBER>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [] call TN_event_fnc_adjustLives;
 */

if !(isServer) exitWith {_this remoteExecCall [QFUNC(adjustLives), 2]};

params ["_player", "_newLives"];
private _uid = getPlayerUID _player;
if (_uid isEqualTo "") exitWith {};

GVAR(livesByUID) set [_uid, _newLives];

[QGVAR(adjustLives), [_newLives], _player] call CBA_fnc_targetEvent;