#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Registers a single OnUserAdminStateChanged mission event
 * handler that extracts the admin unit and fires a CBA event
 * ("TN_common_adminStateChanged") for all consumer modules.
 * Also sets up logic for keeping track of current admin machine network ID
 * (if admin is in mission).
 *
 * Consumers subscribe via:
 *     ["TN_common_adminStateChanged", { params ["_unit", "_loggedIn"]; ... }]
 *         call CBA_fnc_addEventHandler;
 *
 * _unit may be objNull if user info was unavailable.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_common_fnc_initAdminStateChanged;
 */

if (isServer) then {
    GVAR(adminClient) = 2;

    //Case when player login in mission
    [
        QGVAR(adminStateChanged), {
            params ["_unit", "_loggedIn"];
            if (_loggedIn && isNull _unit) exitWith {};
            GVAR(adminClient) = [2, owner _unit] select _loggedIn;
        }
    ] call CBA_fnc_addEventHandler;

    //Create component adminStateChanged event
    addMissionEventHandler [
        "OnUserAdminStateChanged", {
        params ["_networkId", "_loggedIn"];

        private _userInfo = getUserInfo _networkId;
        private _unit = if (count _userInfo > 10) then
            { _userInfo select 10 } else { objNull };

        [QGVAR(adminStateChanged), [_unit, _loggedIn]] call CBA_fnc_localEvent;
    }];

    //Reset adminClient when admin disconnects
    //hardcoded objNull in params, no listeners have an issue due to this currently
    addMissionEventHandler [
        "PlayerDisconnected", {
        params ["", "", "", "", "_owner"];

        if (_owner isEqualTo GVAR(adminClient)) then {
            [QGVAR(adminStateChanged), [objNull, false]] call CBA_fnc_localEvent;
        };
    }];
};

if (hasInterface) then
{
    //Case when player login in lobby
    //Wait after mission start to ensure it is called after event handler is made server side
    [{!isNull player && time > 0}, {
        if (IS_ADMIN) then {
            [QGVAR(adminStateChanged), [player, true]] call CBA_fnc_serverEvent;
        };
    }] call CBA_fnc_waitUntilAndExecute;

};

nil
