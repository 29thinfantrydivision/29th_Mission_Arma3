#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Sends a message in systemChat to the current admin.
 *
 * Arguments:
 * 0: Message to send <STRING> (default: "")
 * 1: Whether the admin should self-send message if applicable <BOOL> (default: false)
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * ["Someone did something", true] call TN_common_fnc_notifyAdmin;
 */

params [["_msg", "", [""]], ["_notifySelf", false, [true]]];

if !(isServer) exitWith {
    if (!IS_ADMIN || _notifySelf) then {
        _this remoteExecCall [QFUNC(notifyAdmin), 2]
    }
};

//Local hosting support for testing
if (GVAR(adminClient) IsEqualTo 2 && isDedicated) exitWith {};

_msg remoteExecCall ["systemChat", GVAR(adminClient)];

nil