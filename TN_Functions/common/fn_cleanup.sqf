#include "script_component.hpp"

/*
 * Author: Hill [29th ID]
 * Removes all dead bodies and loose ground items
 * (weapons, magazines) globally.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * false if nothing was deleted, true otherwise <BOOL>
 *
 * Example:
 * call TN_common_fnc_cleanup;
 */

private _dead = allDeadMen;

private _groundItems = entities [["WeaponHolder", "GroundWeaponHolder"], [], true, true];

private _countItems = count _groundItems;
private _countDead = count _dead;
private _countAll = _countItems + _countDead;

if (_countAll < 1) exitWith {
    hintSilent "Nothing to delete.";
    false
};

{ deleteVehicle _x; } forEach _dead;
{ deleteVehicle _x; } forEach _groundItems;

private _text = format ["Cleaned:\n%1 Items\n%2 Dead Bodies", _countItems, _countDead];
hintSilent _text;
true
