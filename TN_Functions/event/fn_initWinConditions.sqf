#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Initializes win condition tracking. Sets up event handlers
 * on sectors and killable objects to update scores and trigger
 * win condition checks. Pre-builds condition arrays for
 * evaluation by checkWinConditions.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_initWinConditions;
 */

GVAR(loopChecks) = [{ false }, { false }, { false }];
GVAR(endChecks) = [{ false }, { false }, { false }];

{
    private _pointValue = _x getVariable [QGVARMAIN(pointValue), 0];

    if (_pointValue isEqualTo 0) then { continue };

    switch (typeOf _x) do {
        case "ModuleSector_F": {
            [_x, "ownerChanged", {
                    params [
                        "_sector",
                        "_newOwner",
                        "_oldOwner"
                    ];
                    private _pointValue = _sector getVariable [QGVARMAIN(pointValue), 0];
                    private _newOwnerId = _newOwner call BIS_fnc_sideId;
                    private _oldOwnerId = _oldOwner call BIS_fnc_sideId;

                    if (_newOwnerId <= 2) then {
                        GVAR(score) set [
                            _newOwnerId,
                            (GVAR(score)
                                select _newOwnerId)
                                + _pointValue
                        ];
                    };
                    if (_oldOwnerId <= 2) then {
                        GVAR(score) set [
                            _oldOwnerId,
                            (GVAR(score)
                                select _oldOwnerId)
                                - _pointValue
                        ];
                    };

                    [false] call FUNC(checkWinConditions);
                }
            ] call BIS_fnc_addScriptedEventHandler;

            private _owner = _x getVariable ["owner", sideUnknown];
            private _idx = _owner call BIS_fnc_sideID;
            if (_idx <= 2) then {
                GVAR(score) set [
                    _idx,
                    (GVAR(score) select _idx)
                        + _pointValue
                ];
            };
        };
        default {
            _x addEventHandler ["Killed", {
                params [
                    "_unit", "_killer", "_instigator"
                ];
                private _pointValue = _unit getVariable [QGVARMAIN(pointValue), 0];
                private _awardTeam = _unit getVariable [QGVARMAIN(awardTeam), sideUnknown];
                private _idx = _awardTeam call BIS_fnc_sideID;
                if (_idx <= 2) then {
                    GVAR(score) set [
                        _idx,
                        (GVAR(score) select _idx)
                            + _pointValue
                    ];
                };

                [false] call FUNC(checkWinConditions);
            }];
        };
    };
} forEach (allMissionObjects "all");

private _sideSettings =
[
    GVAR(opforWinConditions),
    GVAR(bluforWinConditions),
    GVAR(grnforWinConditions)
];

{
    if (_x isEqualTo []) then { continue };

    _x params ["_pointsRequired", "_atEnd"];

    private _checkFn = compile format
        ['GVAR(score) select %1 >= %2', _forEachIndex, _pointsRequired];

    if (_atEnd) then {
        GVAR(endChecks) set [_forEachIndex, _checkFn];
    } else {
        GVAR(loopChecks) set [_forEachIndex, _checkFn];
    };
} forEach _sideSettings;

if (GVAR(useRoundSystem)) then {
    [
        QEGVAR(round,ended), {
            [true] call FUNC(checkWinConditions);
        }
    ] call CBA_fnc_addEventHandler;
};

nil
