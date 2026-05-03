#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Registers a single OnUserAdminStateChanged mission event
 * handler that extracts the admin unit and fires two CBA events:
 *
 *   "TN_common_adminStateChangedServer" — fired on the server only.
 *       Params: [_unit, _loggedIn]. _unit may be objNull.
 *       Server consumers subscribe here.
 *
 *   "TN_common_adminStateChangedClient" — relayed to the admin's
 *       client machine via targetEvent.
 *       Params: [_loggedIn]. No _unit (client is always player).
 *       Client consumers subscribe here.
 *
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
        QGVAR(adminStateChangedServer), {
            params ["_unit", "_loggedIn"];
            if (_loggedIn && isNull _unit) exitWith {};
            GVAR(adminClient) = [2, owner _unit] select _loggedIn;
            if (!isNull _unit) then {
                [QGVAR(adminStateChangedClient), [_loggedIn], _unit] call CBA_fnc_targetEvent;
            };
        }
    ] call CBA_fnc_addEventHandler;

    //Create component adminStateChangedServer event
    addMissionEventHandler [
        "OnUserAdminStateChanged", {
        params ["_networkId", "_loggedIn"];

        private _userInfo = getUserInfo _networkId;
        private _unit = if (count _userInfo > 10) then
            { _userInfo select 10 } else { objNull };

        [QGVAR(adminStateChangedServer), [_unit, _loggedIn]] call CBA_fnc_localEvent;
    }];

    //Reset adminClient when admin disconnects
    //hardcoded objNull in params, no listeners have an issue due to this currently
    addMissionEventHandler [
        "PlayerDisconnected", {
        params ["", "", "", "", "_owner"];

        if (_owner isEqualTo GVAR(adminClient)) then {
            [QGVAR(adminStateChangedServer), [objNull, false]] call CBA_fnc_localEvent;
        };
    }];
};

if (hasInterface) then
{
    //Case when player login in lobby
    //Wait after mission start to ensure it is called after event handler is made server side
    [{!isNull player && time > 0}, {
        if (IS_ADMIN) then {
            [QGVAR(adminStateChangedServer), [player, true]] call CBA_fnc_serverEvent;
        };
    }] call CBA_fnc_waitUntilAndExecute;

    //Don't call client event here, since server will send it to us
};

nil
