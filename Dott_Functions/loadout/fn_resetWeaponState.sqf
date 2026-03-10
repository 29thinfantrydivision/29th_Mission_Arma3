/**
 * DOTT_loadout_fnc_resetWeaponState
 *
 * Purpose: Fully removes and re-adds the primary and handgun weapons
 *          to reset internal weapon state, preventing the silent weapon
 *          bug. Also strips and restores all container items so that
 *          addWeapon cannot auto-insert stray magazines.
 *          Does nothing if the unit has no primary weapon.
 *          Must be spawned (uses sleep/waitUntil).
 *
 * Params:  _unit - Object, local unit whose weapons need resetting
 * Returns: Nothing
 */

params ["_unit"];

// --- Snapshot current weapon state ---
private _primary = primaryWeapon _unit;
private _primaryItems = primaryWeaponItems _unit;
private _primaryMags = primaryWeaponMagazine _unit;

// Handgun is removed too so the engine doesn't auto-swap to it.
private _handgun = handgunWeapon _unit;
private _handgunItems = handgunItems _unit;
private _handgunMags = handgunMagazine _unit;

// Container items must be stripped so addWeapon can't pull mags from them.
private _uniformItems = uniformItems _unit;
private _vestItems = vestItems _unit;
private _backpackItems = backpackItems _unit;

// --- Strip weapons and container items ---
_unit removeWeapon _primary;
_unit removeWeapon _handgun;

{
    _unit removeItemFromUniform _x;
} forEach _uniformItems;

{
    _unit removeItemFromVest _x;
} forEach _vestItems;

{
    _unit removeItemFromBackpack _x;
} forEach _backpackItems;

waitUntil { sleep 1; !isSwitchingWeapon _unit };

// --- Restore primary weapon and attachments ---
_unit addWeapon _primary;

{
    _unit addPrimaryWeaponItem _x;
} forEach _primaryItems;

// Handgun mags added before the weapon to avoid reload sound after delay.
{
    _unit addMagazine _x;
} forEach _handgunMags;

// --- Restore handgun ---
_unit addWeapon _handgun;

{
    _unit addHandgunItem _x;
} forEach _handgunItems;

sleep 1;

// --- Restore primary magazines and container contents ---
{
    _unit addPrimaryWeaponItem _x;
} forEach _primaryMags;

{
    [_unit, _x, "uniform"] call ace_common_fnc_addToInventory;
} forEach _uniformItems;

{
    [_unit, _x, "vest"] call ace_common_fnc_addToInventory;
} forEach _vestItems;

{
    [_unit, _x, "backpack"] call ace_common_fnc_addToInventory;
} forEach _backpackItems;
