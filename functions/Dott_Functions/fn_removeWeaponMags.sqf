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
 * false if !hasInterface, true otherwise
 *
 * Example:
 * player call DOTT_fn_removeWeaponMags;
 * 
 */
if(!hasInterface) exitWith {false};
params["_unit"];

//Find all magazines currently loaded in weapons, group with corresponding removal function
private _removeTasks =
[
    [primaryWeaponMagazine _unit,    { _unit removePrimaryWeaponItem _this }],
    [secondaryWeaponMagazine _unit,  { _unit removeSecondaryWeaponItem _this }],
    [handgunMagazine _unit,          { _unit removeHandgunItem _this }],
    [binocularMagazine _unit,        { _unit removeBinocularItem _this }]
];

// Iterate through each weapon type and remove its magazines
{
    private _magazines = _x#0;
    private _remover = _x#1;

    {
        _x call _remover;
    } forEach _magazines;

} forEach _removeTasks;

true