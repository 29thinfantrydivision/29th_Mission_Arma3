#include "..\..\data\roundState.hpp"

/*
 * Author: Bae [29th ID]
 * Evaluates win conditions each tick during an active round.
 * Supports point-based victory via sector ownership and kill
 * tracking. Conditions can trigger mid-round (loopChecks) or
 * at round end (endChecks).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_checkWinCondition;
 */

private _loopChecks = [[{ false }], [{ false }], [{ false }]];
private _endChecks = [[{ false }], [{ false }], [{ false }]];

{
    private _pointValue = _x getVariable ["TN_pointValue", 0];

    if (_pointValue isEqualTo 0) then { continue };

    switch (typeOf _x) do
    {
        case "ModuleSector_F":
        {
            [_x, "ownerChanged",
                {
                    params [
                        "_sector",
                        "_newOwner",
                        "_oldOwner"
                    ];
                    private _pointValue = _sector getVariable ["TN_pointValue", 0];
                    private _newOwnerId = _newOwner call BIS_fnc_sideId;
                    private _oldOwnerId = _oldOwner call BIS_fnc_sideId;

                    if (_newOwnerId <= 2) then
                    {
                        TN_event_score set [
                            _newOwnerId,
                            (TN_event_score
                                select _newOwnerId)
                                + _pointValue
                        ];
                    };
                    if (_oldOwnerId <= 2) then
                    {
                        TN_event_score set [
                            _oldOwnerId,
                            (TN_event_score
                                select _oldOwnerId)
                                - _pointValue
                        ];
                    };
                }
            ] call BIS_fnc_addScriptedEventHandler;

            private _owner = _x getVariable ["owner", sideUnknown];
            private _idx = _owner call BIS_fnc_sideID;
            if (_idx <= 2) then
            {
                TN_event_score set [
                    _idx,
                    (TN_event_score select _idx)
                        + _pointValue
                ];
            };
        };
        default
        {
            _x addEventHandler ["Killed",
            {
                params [
                    "_unit", "_killer", "_instigator"
                ];
                private _pointValue = _unit getVariable ["TN_pointValue", 0];
                private _awardTeam = _unit getVariable ["TN_awardTeam", sideUnknown];
                private _idx = _awardTeam call BIS_fnc_sideID;
                if (_idx <= 2) then
                {
                    TN_event_score set [
                        _idx,
                        (TN_event_score select _idx)
                            + _pointValue
                    ];
                };
            }];
        };
    };
} forEach (allMissionObjects "all");

private _sideSettings =
[
    TN_event_opforWinConditions,
    TN_event_bluforWinConditions,
    TN_event_grnforWinConditions
];

{
    if (_x isEqualType "") then { continue };

    _x params ["_winCon", "_winArgs", "_atEnd"];
    _winCon = toLowerANSI _winCon;

    private _checkFn = switch (_winCon) do
    {
        case "points":
        {
            [{
                params ["_sideId", "_pointsRequired"];
                TN_event_score select _sideId >= _pointsRequired
            }, [_forEachIndex, _winArgs]];
        };
        default
        {
            [{ false }];
        };
    };

    if (_atEnd) then
    {
        _endChecks set [_forEachIndex, _checkFn];
    }
    else
    {
        _loopChecks set [_forEachIndex, _checkFn];
    };
} forEach _sideSettings;

[
    "TN_round_ended",
    {
        private _endChecks = _thisArgs;
        {
            _x params ["_fnCheck", ["_args", []]];
            if (_args call _fnCheck) exitWith
            {
                private _winningSide = _forEachIndex call BIS_fnc_sideType;
                [_winningSide] call TN_event_fnc_game;
            };
        } forEach _endChecks;

        [] call TN_event_fnc_game;
    }, _endChecks
] call CBA_fnc_addEventHandlerArgs;

if (isNil "TN_event_winCheckInterval") then
{
    TN_event_winCheckInterval = 0.5;
};

[{
    private _loopChecks = _this getVariable "params";

    {
        _x params ["_fnCheck", ["_args", []]];
        if (_args call _fnCheck) exitWith
        {
            private _winningSide = _forEachIndex call BIS_fnc_sideType;
            [_winningSide] call TN_event_fnc_game;
        };
    } forEach _loopChecks;
}, TN_event_winCheckInterval, _loopChecks, {}, {}, {true}, {NOT_ROUND_LIVE}] call CBA_fnc_createPerFrameHandlerObject;

nil
