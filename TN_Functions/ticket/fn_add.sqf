#include "script_component.hpp"
/*
 * Author: Dott [29th ID]
 * Handles adding tickets to either side. Does not use
 * BIS_fnc_respawnTickets.
 *
 * Arguments:
 * 0: The side to apply the tickets to <STRING>
 * 1: The amount of tickets to be added (or subtracted) <NUMBER>
 *
 * Return Value:
 * Nothing
 */

params
[
    ["_ticketSide", "noside", [""]],
    ["_ticketAmount", 0, [0]]
];

if (!GVAR(enabled)) exitWith
{
    systemChat "Error: Ticket system disabled!";
};

private _ticketWEST = GVAR(WEST);
private _ticketEAST = GVAR(EAST);
private _ticketGUER = GVAR(GUER);

switch (_ticketSide) do
{
    case "WEST":
    {
        GVAR(WEST) = _ticketWEST + _ticketAmount;
        publicVariable QGVAR(WEST);
        format ["Blufor tickets set to %1", GVAR(WEST)] remoteExecCall ["hint"];
    };
    case "EAST":
    {
        GVAR(EAST) = _ticketEAST + _ticketAmount;
        publicVariable QGVAR(EAST);
        format ["Opfor tickets set to %1", GVAR(EAST)] remoteExecCall ["hint"];
    };
    case "GUER":
    {
        GVAR(GUER) = _ticketGUER + _ticketAmount;
        publicVariable QGVAR(GUER);
        format ["Grnfor tickets set to %1", GVAR(GUER)] remoteExecCall ["hint"];
    };
    case "reset":
    {
        GVAR(WEST) = 0;
        publicVariable QGVAR(WEST);
        GVAR(EAST) = 0;
        publicVariable QGVAR(EAST);
        GVAR(GUER) = 0;
        publicVariable QGVAR(GUER);
        "All tickets reset to zero!" remoteExecCall ["hint"];
    };
    default
    {
        systemChat "Error: No side defined!";
    };
};

nil
