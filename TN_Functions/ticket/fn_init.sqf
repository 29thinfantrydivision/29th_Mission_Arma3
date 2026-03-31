#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes ticket system.
 * NOTE: Unsure if finished.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_ticket_fnc_init;
 */

// Ensure JIP client is aware of the status of the ticket system.
if (isNil QGVAR(enabled)) then {
    GVAR(enabled) = false;
};
if (isNil QGVAR(counts)) then {
    GVAR(counts) = [0, 0, 0];
};

if (hasInterface) then {
    [
        QGVAR(respawnCount),
        "Respawn", {
            if (GVAR(enabled)) then {
                private _playerSide = playerSide;
                [_playerSide] remoteExecCall [QFUNC(count), 2];
            };
        }
    ] call CBA_fnc_addBISPlayerEventHandler;
};

nil
