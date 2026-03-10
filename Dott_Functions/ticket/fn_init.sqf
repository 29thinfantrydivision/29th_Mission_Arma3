/**
 * Function: DOTT_ticket_fnc_init
 * Author:   Bae [29th ID]
 *
 * Description:
 *   Initializes the ticket system. Ensures JIP clients receive
 *   current ticket state, and registers a respawn event handler
 *   that decrements tickets on the server.
 *
 * TODO: Verify this function is feature-complete. Original author
 *       was unsure if finished.
 *
 * Parameters:
 *   None
 *
 * Returns:
 *   Nothing
 */

// Ensure JIP clients have valid ticket globals.
if (isNil "DOTT_ticketEnabled") then { DOTT_ticketEnabled = false; };
if (isNil "DOTT_ticketWEST") then { DOTT_ticketWEST = 0; };
if (isNil "DOTT_ticketEAST") then { DOTT_ticketEAST = 0; };
if (isNil "DOTT_ticketGUER") then { DOTT_ticketGUER = 0; };

// On respawn, tell the server to decrement a ticket for this side.
if (hasInterface) then
{
    [
        "DOTT_ticket_respawnCount",
        "Respawn",
        {
            if (DOTT_ticketEnabled) then
            {
                private _playerSide = playerSide;
                [_playerSide] remoteExec [
                    "DOTT_ticket_fnc_count", 2
                ];
            };
        }
    ] call CBA_fnc_addBISPlayerEventHandler;
};
