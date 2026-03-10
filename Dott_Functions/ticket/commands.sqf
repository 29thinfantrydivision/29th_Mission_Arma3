/**
 * Module: ticket commands
 * Author: Dott [29th ID]
 *
 * Description:
 *   Registers the "!tickets" admin chat command. Provides
 *   enable / disable, per-side add/subtract, reset, and
 *   status query for the ticket system.
 *
 * Parameters:
 *   None (self-registering)
 *
 * Returns:
 *   Nothing
 */

[
    [
        [
            "tickets",
            {
                private _argument = toLower (_this select 0);

                // --- Enable ticket system ---
                if (_argument isEqualTo "enable") exitWith
                {
                    systemChat "Ticket system enabled!";
                    DOTT_ticketEnabled = true;
                    publicVariable "DOTT_ticketEnabled";
                };

                // --- Require enabled system for everything else ---
                if (!DOTT_ticketEnabled) exitWith
                {
                    systemChat
                        "Error: You must enable the ticket system first with '!tickets enable'";
                };

                // --- No argument: show current ticket values ---
                if (_argument isEqualTo "") exitWith
                {
                    systemChat format [
                        "Current Tickets: Blu: %1, Opf: %2, Grn: %3",
                        DOTT_ticketWEST,
                        DOTT_ticketEAST,
                        DOTT_ticketGUER
                    ];
                };

                // --- Parse side name and numeric amount ---
                private _filterAmount = [
                    _argument, "-0123456789"
                ] call BIS_fnc_filterString;
                private _filterArg = [
                    _argument, "abcdefghijklmnopqrstuvwxyz"
                ] call BIS_fnc_filterString;
                private _ticketAmount = parseNumber _filterAmount;

                switch (_filterArg) do
                {
                    case "blufor":
                    {
                        systemChat format [
                            "Changing Blufor tickets by %1",
                            _ticketAmount
                        ];
                        ["WEST", _ticketAmount]
                            call DOTT_ticket_fnc_add;
                    };
                    case "opfor":
                    {
                        systemChat format [
                            "Changing Opfor tickets by %1",
                            _ticketAmount
                        ];
                        ["EAST", _ticketAmount]
                            call DOTT_ticket_fnc_add;
                    };
                    case "grnfor":
                    {
                        systemChat format [
                            "Changing Grnfor tickets by %1",
                            _ticketAmount
                        ];
                        ["GUER", _ticketAmount]
                            call DOTT_ticket_fnc_add;
                    };
                    case "reset":
                    {
                        systemChat "Resetting tickets to zero!";
                        ["reset"] call DOTT_ticket_fnc_add;
                    };
                    case "disable":
                    {
                        systemChat "Ticket system disabled!";
                        DOTT_ticketEnabled = false;
                        publicVariable "DOTT_ticketEnabled";
                        DOTT_ticketWEST = 0;
                        publicVariable "DOTT_ticketWEST";
                        DOTT_ticketEAST = 0;
                        publicVariable "DOTT_ticketEAST";
                        DOTT_ticketGUER = 0;
                        publicVariable "DOTT_ticketGUER";
                    };
                    default
                    {
                        systemChat
                            "Error: Invalid input! Must be 'blufor', 'opfor', 'grnfor', 'reset', 'enable', 'disable'";
                    };
                };
            }
        ]
    ],
    [
        [
            "tickets",
            "Manages tickets and changes tickets for a given side, by the given value (E.G. '!tickets Blufor 5' will add 5 tickets to Blufor). '!tickets reset' sets all tickets to zero. '!tickets' returns the current value of all teams tickets. '!tickets enable' or 'disable' to enable/disable ticket system"
        ]
    ]
] call DOTT_commands_fnc_addModule;
