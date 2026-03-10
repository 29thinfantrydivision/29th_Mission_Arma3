/**
 * Function: DOTT_ticket_fnc_add
 * Author:   Dott [29th ID]
 *
 * Description:
 *   Adds (or subtracts) tickets for a given side without using
 *   BIS_fnc_respawnTickets. Also handles a "reset" case that
 *   zeroes all sides.
 *
 * Parameters:
 *   _ticketSide   (String) - Side identifier: "WEST", "EAST",
 *                             "GUER", or "reset"
 *   _ticketAmount (Number) - Amount to add (negative to subtract)
 *
 * Returns:
 *   Nothing
 */

params
[
    ["_ticketSide", "noside", [""]],
    ["_ticketAmount", 0, [0]]
];

if (!DOTT_ticketEnabled) exitWith
{
    systemChat "Error: Ticket system disabled!";
};

switch (_ticketSide) do
{
    case "WEST":
    {
        DOTT_ticketWEST = DOTT_ticketWEST + _ticketAmount;
        publicVariable "DOTT_ticketWEST";
        format [
            "Blufor tickets set to %1", DOTT_ticketWEST
        ] remoteExec ["hint"];
    };
    case "EAST":
    {
        DOTT_ticketEAST = DOTT_ticketEAST + _ticketAmount;
        publicVariable "DOTT_ticketEAST";
        format [
            "Opfor tickets set to %1", DOTT_ticketEAST
        ] remoteExec ["hint"];
    };
    case "GUER":
    {
        DOTT_ticketGUER = DOTT_ticketGUER + _ticketAmount;
        publicVariable "DOTT_ticketGUER";
        format [
            "Grnfor tickets set to %1", DOTT_ticketGUER
        ] remoteExec ["hint"];
    };
    case "reset":
    {
        DOTT_ticketWEST = 0;
        publicVariable "DOTT_ticketWEST";
        DOTT_ticketEAST = 0;
        publicVariable "DOTT_ticketEAST";
        DOTT_ticketGUER = 0;
        publicVariable "DOTT_ticketGUER";
        "All tickets reset to zero!" remoteExec ["hint"];
    };
    default
    {
        systemChat "Error: No side defined!";
    };
};
