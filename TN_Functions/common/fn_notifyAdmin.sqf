#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Sends a message in systemChat to the current admin.
 *
 * Arguments:
 * 0: Message to send <STRING> (default: "")
 * 1: Whether the admin should self-send message if applicable <BOOL> (default: false)
 * 2: Whether to also send notification via vanilla system <BOOL> (default: true)
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * ["Someone did something", true, false] call TN_common_fnc_notifyAdmin;
 */

params [["_msg", "", [""]], ["_notifySelf", false, [true]], ["_alsoNotify", true, [true]]];

if (hasInterface && !isServer) exitWith {
    if (!IS_ADMIN || _notifySelf) then {
        _this remoteExecCall [QFUNC(notifyAdmin), 2]
    };
    nil
};

if (hasInterface && !_notifySelf) exitWith { nil }; //local hosted case

_msg remoteExecCall ["systemChat", GVAR(adminClient)];

if (_alsoNotify) then {
    ["Document", ["Admin Notification", _msg]] remoteExecCall ["BIS_fnc_showNotification",  GVAR(adminClient)];
};

nil
