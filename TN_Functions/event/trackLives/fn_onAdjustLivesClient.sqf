#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Handles custom adjustLivesClient event during a live round with limited lives.
 * Manages moving player into/out of spectator properly.
 *
 * Arguments:
 * 0: New number of lives <NUMBER>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [2] call TN_event_fnc_onAdjustLivesClient;
 */

params ["_livesLeft"];

private _oldLivesLeft = GVAR(livesLeft);
if (_oldLivesLeft isEqualTo _livesLeft) exitWith {};
GVAR(livesLeft) = _livesLeft;

if (_oldLivesLeft isEqualTo 0) then {
    call EFUNC(spectator,exit);
    player setVariable ["BIS_fnc_showRespawnMenu_disable", false];
    if (!alive player) then { 
        ["open"] call BIS_fnc_showRespawnMenu;
        setPlayerRespawnTime 1;
    };
};

systemChat format ["You now have %1 lives left.", _livesLeft];

// --- Out of lives ---
if (_livesLeft isEqualTo 0) then {
    setPlayerRespawnTime 9999;
    player setVariable ["BIS_fnc_showRespawnMenu_disable", true];
    //disable Respawn in Pause Menu if player is in it
    ((findDisplay 49) displayCtrl 1010) ctrlEnable false;

    private _extraDelay = [2, 0] select (alive player);
    private _lastDamageSource = player getVariable ["ace_medical_lastDamageSource", player];
// ----- Show Notification -----
    [
        {
            titleText [
                "<t color='#ffffff' size='4'>Out of Lives!</t>",
                "BLACK OUT", 0.5, true, true
            ];
        },
        {},
        0 + _extraDelay //wait so transition is less jarring for the player
    ] call CBA_fnc_waitAndExecute;

    [
        {
            titleText [
                "<t color='#ffffff' size='4'>Out of Lives!</t>",
                "BLACK IN", 0.5, true, true
            ];
        },
        {},
        3 + _extraDelay
    ] call CBA_fnc_waitAndExecute;
// ----------------------------

    [
        {
            params ["_lastDamageSource"];
            [player, true] call EFUNC(spectator,enter);
            player setVariable ["BIS_fnc_showRespawnMenu_disable", false];
            if (!isNil "ace_spectator_fnc_setFocus") then {
                [_lastDamageSource] call ace_spectator_fnc_setFocus;
            };
        },
        [_lastDamageSource],
        3 + _extraDelay
    ] call CBA_fnc_waitAndExecute;
};

nil
