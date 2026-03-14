/**
 * DOTT_event_fnc_gui_flagMenu
 *
 * Opens a centered GUI menu showing admin-only event actions
 * based on the current round state. Only accessible to
 * admins via the Event Menu addAction.
 *
 * Listens to CBA round-state events and rebuilds the menu
 * in-place whenever the state changes while the GUI is open.
 *
 * Uses createDialog (DOTT_RscDisplayFlagMenu, IDD 29140)
 * which overlays on display 46 — readyUI stays visible.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Requires:
 *     DOTT_round_fnc_isRoundActive
 *     DOTT_round_fnc_manageReady
 *     DOTT_round_fnc_initSafeStart
 *     DOTT_round_fnc_start
 *     DOTT_event_fnc_gui_setSafeStartTime
 *     DOTT_event_fnc_game
 *     DOTT_event_timerLength (global)
 *     CBA_fnc_addEventHandler
 *     CBA_fnc_removeEventHandler
 */

// Prevent double-open
if !(isNull (findDisplay 29140)) exitWith {};

createDialog "DOTT_RscDisplayFlagMenu";
private _display = findDisplay 29140;
if (isNull _display) exitWith {};

/* --- Close function (define once) --- */

if (isNil "DOTT_event_fnc_closeFlagMenu") then {
    DOTT_event_fnc_closeFlagMenu =
    {
        // Remove CBA event handlers
        {
            _x call CBA_fnc_removeEventHandler;
        } forEach (uiNamespace getVariable [
            "DOTT_flagMenu_ehIds", []
        ]);

        uiNamespace setVariable [
            "DOTT_flagMenu_ehIds", nil
        ];
        uiNamespace setVariable [
            "DOTT_flagMenu_rebuild", nil
        ];

        // Close the dialog — destroys all controls with it
        private _dlg = findDisplay 29140;
        if !(isNull _dlg) then { _dlg closeDisplay 2 };
    };
};

/* --- Rebuild function --- */

private _fnc_rebuild =
{
    params ["_display"];

    /* Delete old menu controls */
    private _oldControls = uiNamespace getVariable [
        "DOTT_flagMenu_controls", []
    ];
    { ctrlDelete _x } forEach _oldControls;

    /* Determine current state */
    private _currentState = switch (true) do
    {
        case (call DOTT_round_fnc_isRoundActive):
        {
            2;
        };
        case (!isNil "DOTT_round_safeStartActive"):
        {
            1;
        };
        default { 0 };
    };

    /* --- Build action list: [label, code, colorRGBA] --- */

    private _actions = [];

    switch (_currentState) do
    {
        case 0:
        {
            _actions pushBack [
                "Begin Safe Start",
                {
                    params ["_ctrl"];
                    [DOTT_event_forcedSafeStart, true]
                        call DOTT_round_fnc_initSafeStart;
                    call DOTT_event_fnc_closeFlagMenu;
                },
                [0.75, 0.25, 1, 1]
            ];
        };

        case 1:
        {

            _actions pushBack [
                "Cancel Safestart",
                {
                    params ["_ctrl"];
                    [0] call DOTT_round_fnc_changeForcedSafeStart;
                    if (call DOTT_round_fnc_checkAllSidesReady) then
                    {
                        {
                            [_x, false] call DOTT_round_fnc_manageReady;
                        }
                        forEach [west, east, resistance];
                        systemChat "Unreadied all sides!";
                    };
                    call DOTT_event_fnc_closeFlagMenu;
                },
                [0.75, 0.25, 1, 1]
            ];


            _actions pushBack [
                "Change Safestart Time",
                {
                    params ["_ctrl"];
                    call DOTT_event_fnc_closeFlagMenu;
                    call DOTT_event_fnc_gui_setSafeStartTime;
                },
                [0.75, 0.25, 1, 1]
            ];


            _actions pushBack [
                "Force Live",
                {
                    params ["_ctrl"];
                    [DOTT_event_timerLength]
                        call DOTT_round_fnc_start;
                    call DOTT_event_fnc_closeFlagMenu;
                },
                [0.75, 0.25, 1, 1]
            ];
        };

        case 2:
        {
            _actions pushBack [
                "Neutral Ending",
                {
                    params ["_ctrl"];
                    [true] call DOTT_event_fnc_game;
                    call DOTT_event_fnc_closeFlagMenu;
                },
                [0.75, 0.25, 1, 1]
            ];

            private _allPlayers =
                call BIS_fnc_listPlayers;
            private _sides = [
                [west, "BLUFOR",
                    [0.08, 0.36, 0.99, 1]],
                [east, "OPFOR",
                    [0.70, 0.02, 0.02, 1]],
                [resistance, "GRNFOR",
                    [0.03, 0.54, 0.03, 1]]
            ];

            {
                _x params [
                    "_side", "_sideName", "_sideColor"
                ];

                if (({side group _x == _side}
                    count _allPlayers) > 0) then
                {
                    private _btn_code = compile format [
                        "params ['_ctrl'];"
                        + "[true, %1]"
                        + " call DOTT_event_fnc_game;"
                        + "call DOTT_event_fnc_closeFlagMenu;",
                        _side
                    ];

                    _actions pushBack [
                        _sideName + " Victory",
                        _btn_code,
                        _sideColor
                    ];
                };
            } forEach _sides;
        };
    };

    if (count _actions == 0) exitWith
    {
        call DOTT_event_fnc_closeFlagMenu;
    };

    /* --- Layout constants --- */

    private _btnW = 0.25;
    private _btnH = 0.035;
    private _gap = 0.005;
    private _padding = 0.015;
    private _titleH = 0.035;

    private _contentH = _titleH + _padding
        + (count _actions * (_btnH + _gap)) - _gap;
    private _totalH = _contentH + _padding * 2;
    private _totalW = _btnW + _padding * 2;

    private _startX = 0.5 - _totalW / 2;
    private _startY = 0.5 - _totalH / 2;

    private _controls = [];

    /* --- Background --- */

    private _bg =
        _display ctrlCreate ["RscText", -1];
    _bg ctrlSetPosition [
        _startX, _startY,
        _totalW, _totalH
    ];
    _bg ctrlSetBackgroundColor [0, 0, 0, 0.8];
    _bg ctrlCommit 0;
    _controls pushBack _bg;

    /* --- Title --- */

    private _title =
        _display ctrlCreate ["RscStructuredText", -1];
    _title ctrlSetPosition [
        _startX + _padding,
        _startY + _padding,
        _btnW,
        _titleH
    ];
    _title ctrlSetStructuredText parseText (
        "<t color='#bf3eff' align='center' size='1.1'>"
        + "Event Menu</t>");
    _title ctrlCommit 0;
    _controls pushBack _title;

    /* --- Buttons --- */

    private _yPos =
        _startY + _padding + _titleH + _padding;

    {
        _x params ["_label", "_code", "_color"];

        private _btn =
            _display ctrlCreate ["RscButton", -1];
        _btn ctrlSetText _label;
        _btn ctrlSetPosition [
            _startX + _padding, _yPos,
            _btnW, _btnH
        ];
        _btn ctrlSetBackgroundColor _color;
        _btn ctrlCommit 0;
        _btn ctrlAddEventHandler [
            "ButtonClick", _code
        ];
        _controls pushBack _btn;

        _yPos = _yPos + _btnH + _gap;
    } forEach _actions;

    uiNamespace setVariable [
        "DOTT_flagMenu_controls", _controls
    ];
};

/* --- Store rebuild fn in uiNamespace for CBA handlers --- */

uiNamespace setVariable [
    "DOTT_flagMenu_rebuild", _fnc_rebuild
];

/* --- Initial build --- */

[_display] call _fnc_rebuild;

/* --- Subscribe to round-state CBA events --- */

private _stateEvents = [
    "DOTT_round_safeStartBegin",
    "DOTT_round_safeStartAborted",
    "DOTT_round_started",
    "DOTT_round_ended"
];

private _ehIds = [];

{
    private _id = [_x,
    {
        private _dlg = findDisplay 29140;
        if !(isNull _dlg) then
        {
            [_dlg] call (uiNamespace getVariable
                "DOTT_flagMenu_rebuild");
        };
    }] call CBA_fnc_addEventHandler;

    _ehIds pushBack [_x, _id];
} forEach _stateEvents;

uiNamespace setVariable [
    "DOTT_flagMenu_ehIds", _ehIds
];

/* --- Close on ESC --- */

_display displayAddEventHandler [
    "KeyDown",
    {
        params ["_display", "_key"];
        if (_key == 1) then
        {
            call DOTT_event_fnc_closeFlagMenu;
            true
        }
        else
        {
            false
        };
    }
];

/* --- Clean up CBA EHs when dialog closes by any means --- */

_display displayAddEventHandler [
    "Unload",
    {
        {
            _x call CBA_fnc_removeEventHandler;
        } forEach (uiNamespace getVariable [
            "DOTT_flagMenu_ehIds", []
        ]);

        uiNamespace setVariable [
            "DOTT_flagMenu_controls", nil
        ];
        uiNamespace setVariable [
            "DOTT_flagMenu_ehIds", nil
        ];
        uiNamespace setVariable [
            "DOTT_flagMenu_rebuild", nil
        ];
    }
];
