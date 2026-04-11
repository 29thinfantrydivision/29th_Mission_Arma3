#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Handles player respawn during a live round with limited lives.
 * Decrements local lives counter and, when exhausted, transitions
 * the player into spectator mode.
 *
 * Called via CBA BIS "Respawn" player event handler.
 *
 * Arguments:
 * 0: New unit <OBJECT>
 * 1: Old unit <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [] call TN_event_fnc_respawn;
 */

if (!hasInterface) exitWith {};
if (GVAR(numberOfLives) isEqualTo 0) exitWith {};
if (!GVAR(trackingLives)) exitWith {};

GVAR(livesLeft) = GVAR(livesLeft) - 1;

diag_log text format ["%1: Player respawned, %2 lives remaining",
    QFUNC(respawn), GVAR(livesLeft)];

if (GVAR(livesLeft) > 0) exitWith {};

// --- Out of lives ---
player allowDamage false;

titleText [
    "<t color='#ffffff' size='4'>Out of Lives!</t>",
    "BLACK OUT", 0.5, true, true
];

if (GVAR(respawnDisarmPlayers)) then {
    removeAllWeapons player;
};

[{
    [player] call EFUNC(spectator,enter);

    [{
        player allowDamage true;
    }, [], 1] call CBA_fnc_waitAndExecute;

    titleText [
        "<t color='#ffffff' size='4'>Out of Lives!</t>",
        "BLACK IN", 0.5, true, true
    ];
}, [], 0.5] call CBA_fnc_waitAndExecute;

nil
