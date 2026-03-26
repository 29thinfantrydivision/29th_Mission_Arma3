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
if (isNil "TN_ticket_enabled") then
{
    TN_ticket_enabled = false;
};
if (isNil "TN_ticket_WEST") then
{
    TN_ticket_WEST = 0;
};
if (isNil "TN_ticket_EAST") then
{
    TN_ticket_EAST = 0;
};
if (isNil "TN_ticket_GUER") then
{
    TN_ticket_GUER = 0;
};

if (isServer) then
{
    TN_ticket_adminClient = 2;

    // Catch any admin already logged in before this runs.
    {
        if (admin (owner _x) isEqualTo 2) exitWith
        {
            TN_ticket_adminClient = owner _x;
        };
    } forEach (allPlayers - entities "HeadlessClient_F");

    [
        "TN_adminStateChanged",
        {
            params ["_unit", "_loggedIn"];
            if (isNull _unit) exitWith {};
            TN_ticket_adminClient = [2, owner _unit] select _loggedIn;
        }
    ] call CBA_fnc_addEventHandler;
};

if (hasInterface) then
{
    [
        "TN_ticket_respawnCount",
        "Respawn",
        {
            if (TN_ticket_enabled) then
            {
                private _playerSide = playerSide;
                [_playerSide] remoteExecCall ["TN_ticket_fnc_count", 2];
            };
        }
    ] call CBA_fnc_addBISPlayerEventHandler;
};

nil
