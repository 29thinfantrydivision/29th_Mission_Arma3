#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Initializes the lives tracking system of event template.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_initTrackLives;
 */
if !(GVAR(useRoundSystem) && {GVAR(numberOfLives > 0)}) exitWith {};

if (isServer) then {
    GVAR(trackingLives) = false;
    publicVariable QGVAR(trackingLives);
    GVAR(livesByUID) = createHashMap;

    [QGVAR(adjustLivesServer), {
        params ["_player", "_newLives"];
        private _uid = getPlayerUID _player;
        private _oldLives = GVAR(livesByUID) getOrDefault [_uid, GVAR(numberOfLives)];
        GVAR(livesByUID) set [_uid, _newLives];
        if (_newLives isEqualTo 0) then {
            [QGVAR(outOfLives), [_player]] call CBA_fnc_localEvent;
        };
        if (_oldLives isEqualTo 0) then {
            [QGVAR(backInAction), [_player]] call CBA_fnc_localEvent;
        };
    }] call CBA_fnc_addEventHandler;

    [QGVAR(checkLivesJIP), {
        params ["_player"];
        private _uid = getPlayerUID _player;
        private _lives = GVAR(livesByUID) getOrDefault [
            _uid, GVAR(numberOfLives)
        ];
        if (GVAR(useRoundSystem) && {GVAR(penalizeJIPLives)} && {GVAR(trackingLives)}) then {
            if (_lives isNotEqualTo 0) then
            {
                _lives = (_lives - 1) max 0;
                [QGVAR(adjustLivesServer), [_player, _lives]] call CBA_fnc_localEvent;
            };
        };
        [QGVAR(adjustLivesClient), [_lives], _player]
            call CBA_fnc_targetEvent;
    }] call CBA_fnc_addEventHandler;

    if (GVAR(useRoundSystem)) then {
        [QEGVAR(round,started), {
            GVAR(livesByUID) = createHashMap;
            GVAR(trackingLives) = true;
            publicVariable QGVAR(trackingLives);
        }] call CBA_fnc_addEventHandler;
    };
};

if (hasInterface) then {
    GVAR(livesLeft) = GVAR(numberOfLives); //default to prevent nil

    [QGVAR(killed), "Killed", FUNC(handleLivesOnKilled)]
        call CBA_fnc_addBISPlayerEventHandler;

    [QGVAR(adjustLivesClient), 
        FUNC(handleAdjustLivesClient)
    ] call CBA_fnc_addEventHandler;

    [{!isNull player}, {
        [QGVAR(checkLivesJIP), [player]]
            call CBA_fnc_serverEvent;
    }] call CBA_fnc_waitUntilAndExecute;
    
    //disable Respawn button in Pause menu if out of lives
    [   
        QGVARMAIN(enteredPauseMenu),
        { 
            if (GVAR(livesLeft) <= 0) then {
                [{!isNull ((findDisplay 49) displayCtrl 1010)}, 
                {((findDisplay 49) displayCtrl 1010) ctrlEnable false}
                ] call CBA_fnc_waitUntilAndExecute;
            };
        }
    ] call CBA_fnc_addEventHandler;
};