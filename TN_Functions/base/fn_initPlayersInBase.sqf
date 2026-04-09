#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Opt-in initializer for a server-side roster of players currently
 * inside any arsenal zone. Bridges the client-local enter/exit
 * arsenal zone CBA events up to the server via CBA_fnc_serverEvent,
 * and cleans up on disconnect. Idempotent; safe to call multiple
 * times from any consumer.
 *
 * Provides:
 *   TN_base_playersInBase (server) - array of unit objects currently
 *                                    inside any arsenal zone.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_base_fnc_initPlayersInBase;
 */

if (!isNil QGVAR(playersInBaseInitialized)) exitWith {};
GVAR(playersInBaseInitialized) = true;

if (isServer) then {
    GVAR(playersInBase) = [];

    [QGVAR(presenceUpdate), {
        params ["_unit", "_inZone"];
        if (_inZone) then {
            if (isNull _unit) exitWith {};
            GVAR(playersInBase) pushBackUnique _unit;
        } else {
            private _idx = GVAR(playersInBase) find _unit;
            if (_idx > -1) then {
                GVAR(playersInBase) deleteAt _idx;
            };
        };
    }] call CBA_fnc_addEventHandler;

    addMissionEventHandler ["HandleDisconnect", {
        params ["_unit"];
        [QGVAR(presenceUpdate), [_unit, false]] call CBA_fnc_localEvent;
        false
    }];
};

if (hasInterface) then {
    [QGVAR(enteredArsenalZone), {
        [QGVAR(presenceUpdate), [player, true]] call CBA_fnc_serverEvent;
    }] call CBA_fnc_addEventHandler;

    [QGVAR(exitedArsenalZone), {
        [QGVAR(presenceUpdate), [player, false]] call CBA_fnc_serverEvent;
    }] call CBA_fnc_addEventHandler;

    // If the player is already inside a zone at the moment init runs, sync once.
    if (!isNil QGVAR(inArsenalZone) && { GVAR(inArsenalZone) }) then {
        [QGVAR(presenceUpdate), [player, true]] call CBA_fnc_serverEvent;
    };
};

nil
