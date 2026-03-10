/**
 * Function: DOTT_ticket_fnc_count
 * Author:   Dott [29th ID]
 *
 * Description:
 *   Server-side handler that decrements a ticket for the
 *   respawning player's side. Notifies the player, their team,
 *   and any logged-in admin about ticket status. Does not use
 *   BIS_fnc_respawnTickets.
 *
 *   Called via remoteExec from the client respawn event handler
 *   registered in fn_init.sqf.
 *
 * Parameters:
 *   _playerSide (Side) - The side of the player who respawned
 *
 * Returns:
 *   Nothing
 */

params
[
    ["_playerSide", sideUnknown]
];

if (!isServer) exitWith {};

private _clientOwner = remoteExecutedOwner;

// ------------------------------------------------------------------
// Find the logged-in admin's client owner ID.
// Defaults to server (2) so hints don't go to random clients when
// no admin is logged in.
// ------------------------------------------------------------------
private _adminClient = 2;
{
    private _currentID = owner _x;
    private _adminStatus = admin _currentID;

    if (_adminStatus isEqualTo 2) exitWith
    {
        _adminClient = _currentID;
    };
} forEach (allPlayers - entities "HeadlessClient_F");

// ------------------------------------------------------------------
// Map the side to its global variable name and admin-facing label.
// Civilian and unknown sides are ignored.
// ------------------------------------------------------------------
private _varName = "";
private _adminLabel = "";

switch (_playerSide) do
{
    case west:
    {
        _varName = "DOTT_ticketWEST";
        _adminLabel = "Blufor";
    };
    case east:
    {
        _varName = "DOTT_ticketEAST";
        _adminLabel = "Opfor";
    };
    case resistance:
    {
        _varName = "DOTT_ticketGUER";
        _adminLabel = "Grnfor";
    };
    case civilian: {};
    default {};
};

// No-op for civilian / unknown sides.
if (_varName isEqualTo "") exitWith {};

// ------------------------------------------------------------------
// Core ticket logic: decrement, notify player and team.
// ------------------------------------------------------------------
private _tickets = missionNamespace getVariable [_varName, 0];

if (_tickets isEqualTo 0) then
{
    // Side is already at zero -- warn the respawning player.
    [
        "<t color='#ffffff' size='2'>Your team is out of tickets! Do not leave spawn!</t>",
        "PLAIN",
        0.8
    ] remoteExec ["DOTT_common_fnc_displayMsg", _clientOwner];
}
else
{
    // Subtract one ticket and broadcast.
    _tickets = _tickets - 1;
    missionNamespace setVariable [_varName, _tickets];
    publicVariable _varName;

    if (_tickets isEqualTo 0) then
    {
        // Last ticket -- warn team and admin.
        "Your team is out of tickets!" remoteExec [
            "hint", _playerSide
        ];
        format [
            "ADMIN: %1 is out of tickets!", _adminLabel
        ] remoteExec ["hint", _adminClient];
        [
            "<t color='#ffffff' size='2'>You are the last player allowed to leave spawn!</t>",
            "PLAIN",
            0.8
        ] remoteExec [
            "DOTT_common_fnc_displayMsg", _clientOwner
        ];
    }
    else
    {
        // Tickets remain -- silent hint to team, message to player.
        format [
            "Your team has %1 tickets remaining!", _tickets
        ] remoteExec ["hintSilent", _playerSide];
        [
            "<t color='#ffffff' size='2'>You may leave spawn!</t>",
            "PLAIN",
            0.5
        ] remoteExec [
            "DOTT_common_fnc_displayMsg", _clientOwner
        ];
    };
};
