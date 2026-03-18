/*
 * Author: Bae [29th ID]
 * Handles the OnUserAdminStateChanged mission event.
 * On login, assigns the admin to zeus_admin curator module.
 * On logout, unassigns zeus_admin and recreates a personal
 * curator module if their role is in TN_curator_units.
 *
 * Arguments:
 * OnUserAdminStateChanged EH params
 *
 * Return Value:
 * Nothing
 */

params ["_networkId", "_loggedIn"];

private _userInfo = getUserInfo _networkId;
if (count _userInfo < 11) exitWith {};

private _unit = _userInfo select 10;
if (isNil "_unit") exitWith {};

if (_loggedIn) exitWith
{
    if (isNull getAssignedCuratorLogic _unit) then
    {
        [_unit] spawn
        {
            params ["_unit"];
            unassignCurator zeus_admin;
            sleep .1;
            _unit assignCurator zeus_admin;
        };
    };
};

//logging out
[_unit] spawn
{
    params ["_unit"];
    if (getAssignedCuratorLogic _unit == zeus_admin) then
    {
        [_unit] spawn
        {
            params ["_unit"];
            unassignCurator zeus_admin;
            sleep .1;
            isNil {
                [vehicleVarName _unit, roleDescription _unit]
                    call TN_curator_fnc_createModule;
            };
        };
    };
};
