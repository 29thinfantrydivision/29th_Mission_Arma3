/**
 * Function: DOTT_event_fnc_flagActions
 * Author:   Bae [29th ID]
 *
 * Adds a single "Event Menu" scroll-wheel action to timer
 * objects and the ending object. The action opens a GUI
 * dialog (DOTT_event_fnc_gui_flagMenu) that presents
 * context-sensitive options based on the current round state
 * and admin status.
 *
 * Adds Side Ready and Unready actions to players in
 * BLUFOR, OPFOR, or GRNFOR if round has not started.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Requires:
 *     DOTT_event_timerObjects (global array)
 *     DOTT_event_endingObject (global object)
 *     DOTT_event_fnc_gui_flagMenu
 */

{
    if (isNil {_x}) then
    {
        DOTT_event_timerObjects set
            [_forEachIndex, objNull];
    };
} forEach DOTT_event_timerObjects;

if (isNil "DOTT_event_endingObject") then
{
    DOTT_event_endingObject = objNull;
    systemChat "WARNING: Admin object (endingObject) not found!";
};

/* --- Add actions to all objects --- */

private _validSide =
    playerSide in [west, east, resistance];

private _allObjects =
    DOTT_event_timerObjects + [DOTT_event_endingObject];

{
    if (!isNull _x) then
    {
        if (_validSide
            && {!(call DOTT_round_fnc_isRoundActive)}) then
        {
            private _readyId = _x addAction [
                "<t color='#bf3eff'>"
                    + "Side Ready</t>",
                {
                    [playerSide, true]
                        call DOTT_round_fnc_manageReady;
                },
                nil,
                1.5, true, true, "",
                "!(DOTT_round_sideReady select"
                + " (playerSide call BIS_fnc_sideID))",
                8
            ];

            private _unreadyId = _x addAction [
                "<t color='#bf3eff'>"
                    + "Side Unready</t>",
                {
                    [playerSide, false]
                        call DOTT_round_fnc_manageReady;
                },
                nil,
                1.5, true, true, "",
                "DOTT_round_sideReady select"
                + " (playerSide call BIS_fnc_sideID)",
                8
            ];

            _x setVariable [
                "DOTT_event_readyActionIds",
                [_readyId, _unreadyId]
            ];
        };

        _x addAction [
            "<t color='#bf3eff'>"
                + "Event Menu</t>",
            { call DOTT_event_fnc_gui_flagMenu },
            nil,
            1.5, true, true, "",
            "serverCommandAvailable '#lock'",
            8
        ];
    };
} forEach _allObjects;

/* --- Remove ready actions on round start --- */

[
    "DOTT_round_started",
    {
        private _objects =
            DOTT_event_timerObjects
            + [DOTT_event_endingObject];
        {
            if (!isNull _x) then
            {
                private _obj = _x;
                private _ids = _obj getVariable
                    ["DOTT_event_readyActionIds", []];
                { _obj removeAction _x }
                    forEach _ids;
            };
        } forEach _objects;
    }
] call CBA_fnc_addEventHandler;

/* --- Remove actions after game is called --- */

[
    "DOTT_event_gameCalled",
    {
        {
            if (!isNull _x) then
            {
                removeAllActions _x;
            };
        } forEach (
            DOTT_event_timerObjects
            + [DOTT_event_endingObject]
        );
    }
] call CBA_fnc_addEventHandler;
