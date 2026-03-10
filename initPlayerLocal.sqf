/**
 * initPlayerLocal.sqf
 * Purpose: Client-side initialization executed locally when a player joins
 *          the mission (including both mission start and JIP).
 *          Sets up ambient settings, misfire prevention, respawn visuals,
 *          and chat display fix.
 * Params:  _theClient - Object - the player unit
 *          _didJIP    - Boolean - true if player joined in progress
 * Return:  None
 */

#include "data\defines.hpp"

diag_log text format [
    "|===== %1: initPlayerLocal.sqf Running =====|",
    missionName
];

params ["_theClient", "_didJIP"];

enableSentences false;
enableEnvironment [false, true];

// Maintain neutral rating so team kills don't tank score.
_theClient addEventHandler ["HandleRating", {0}];

// --- Misfire prevention ---
// Waits for the player to have a weapon equipped, then holsters it.
// Prevents accidental discharge on spawn.
[_theClient] spawn
{
    private _theMan = _this select 0;
    waitUntil {currentWeapon _theMan != ""};
    if !(weaponLowered _theMan) then
    {
        _theMan action ["WeaponOnBack", _theMan];
    };
};

// --- Respawn flicker prevention ---
// Hides newly created remote units for 1 second to prevent the
// brief visual glitch of the old body during respawn.
addMissionEventHandler ["EntityCreated",
{
    params ["_entity"];
    if !(_entity isKindOf "Man") exitWith {};
    if (local _entity) exitWith {};
    _entity hideObject true;
    [{
        (_this select 0) hideObject false;
    }, [_entity], 1.0] call CBA_fnc_waitAndExecute;
}];

// --- Chat display fix ---
// Inconsistent engine bug: chat sometimes disappears after leaving
// the pause menu. 0.1s delay lets the UI settle before re-enabling.
["DOTT_exitedPauseMenu", {
    [] spawn {
        sleep 0.1;
        showChat true;
    };
}] call CBA_fnc_addEventHandler;
