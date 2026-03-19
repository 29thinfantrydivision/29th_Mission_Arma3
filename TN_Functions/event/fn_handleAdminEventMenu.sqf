/*
 * Author: Bae [29th ID]
 * Adds or removes the Event Menu self-action on the local
 * player based on admin login/logout state.
 *
 * Arguments:
 * 0: Admin logged in <BOOL>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [true] call TN_event_fnc_handleAdminEventMenu;
 */

params ["_loggedIn"];

if (_loggedIn) exitWith
{
    if (!isNil "TN_event_adminMenuActionId") exitWith {};

    TN_event_adminMenuActionId = player addAction [
        "<t color='#bf3eff'>"
            + "Event Menu (Admin)</t>",
        { call TN_event_fnc_gui_flagMenu },
        nil,
        1.5, false, true, "",
        "",
        50
    ];
};

// logging out
if (!isNil "TN_event_adminMenuActionId") then
{
    player removeAction TN_event_adminMenuActionId;
    TN_event_adminMenuActionId = nil;
};

nil
