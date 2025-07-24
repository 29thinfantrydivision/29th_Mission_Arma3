/*
 * Name:	fnc_removeWeaponMags
 * Date:	7/24/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Removes loaded magazines in primary weapon (incl. underbarrel), launcher, handgun, and binocular from unit.
 * Note: Has not been tested with param other than player.
 * Parameter(s): 
 * _unit
 *
 * Returns:
 * n/a
 *
 * Example:
 * player call DOTT_fn_removeWeaponMags;
 * 
 */
params["_unit"];
//Find all magazines currently loaded in weapons, group with corresponding removal function
private _removeTasks = 
[
    [primaryWeaponMagazine _unit, { _unit removePrimaryWeaponItem _x }],
    [secondaryWeaponMagazine _unit, { _unit removeSecondaryWeaponItem _x }],
    [handgunMagazine _unit, { _unit removeHandgunItem _x }],
    [binocularMagazine _unit, { _unit removeBinocularItem _x }]
];
//For every magazine in weapons, call corresponding removal function
{
    private _magArray = _x select 0;
    private _removeFunc = _x select 1;
    {
        [_x] call _removeFunc;
    } forEach _magArray;
} forEach _removeTasks;	