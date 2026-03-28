#include "script_component.hpp"

[
    [
        [
            "tickets",
            {
                private _argument = _this select 0;
                _argument = toLower _argument;

                // Enable ticket system.
                if (_argument isEqualTo "enable") exitWith
                {
                    systemChat "Ticket system enabled!";
                    GVAR(enabled) = true;
                    publicVariable QGVAR(enabled);
                };

                // Only allow '!tickets enable' if system
                // is disabled.
                if (!GVAR(enabled)) exitWith
                {
                    systemChat "Error: You must enable the ticket system first with '!tickets enable'";
                };

                // '!tickets' with no argument to see current
                // ticket values.
                if (_argument isEqualTo "") exitWith
                {
                    systemChat format [
                        "Current Tickets: Blu: %1, Opf: %2, Grn: %3",
                        GVAR(WEST),
                        GVAR(EAST),
                        GVAR(GUER)
                    ];
                };

                // Filter out side and number the admin provides.
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
                        ["WEST", _ticketAmount] call FUNC(add);
                    };
                    case "opfor":
                    {
                        systemChat format [
                            "Changing Opfor tickets by %1",
                            _ticketAmount
                        ];
                        ["EAST", _ticketAmount] call FUNC(add);
                    };
                    case "grnfor":
                    {
                        systemChat format [
                            "Changing Grnfor tickets by %1",
                            _ticketAmount
                        ];
                        ["GUER", _ticketAmount] call FUNC(add);
                    };
                    case "reset":
                    {
                        systemChat "Resetting tickets to zero!";
                        ["reset"] call FUNC(add);
                    };
                    case "disable":
                    {
                        // Case for disable at the end.
                        systemChat "Ticket system disabled!";
                        GVAR(enabled) = false;
                        publicVariable QGVAR(enabled);
                        GVAR(WEST) = 0;
                        publicVariable QGVAR(WEST);
                        GVAR(EAST) = 0;
                        publicVariable QGVAR(EAST);
                        GVAR(GUER) = 0;
                        publicVariable QGVAR(GUER);
                    };
                    default
                    {
                        systemChat "Error: Invalid input! Must be 'blufor', 'opfor', 'grnfor',  'reset', 'enable', 'disable'";
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
] call EFUNC(commands,addModule);
