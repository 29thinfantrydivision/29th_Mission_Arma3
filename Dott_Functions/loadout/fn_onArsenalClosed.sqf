/**
 * DOTT_loadout_fnc_onArsenalClosed
 *
 * Purpose: Post-arsenal cleanup. Saves the player's current inventory
 *          as their respawn loadout, attempts to fix the silent weapon
 *          bug by cycling primary weapon magazines, reapplies insignia,
 *          and lowers the weapon.
 *
 * Params:  None
 * Returns: true
 */

// --- Persist inventory for respawn ---
[player, [missionNamespace, "Current Inventory"]]
    call BIS_fnc_saveInventory;
[player, ["missionNamespace:Current Inventory"]]
    call BIS_fnc_setRespawnInventory;

resetLoadout = [player] call CBA_fnc_getLoadout;

// --- Silent weapon bug mitigation ---
// Cycle primary magazines after reload completes.
// Fixes some (not all) cases where the weapon produces no sound
// after respawning and re-selecting the same loadout in ACE arsenal.
[] spawn
{
    waitUntil { sleep 1; (weaponState player) select 6 == 0 };

    private _primaryMags = primaryWeaponMagazine player;

    {
        player removePrimaryWeaponItem _x;
    } forEach _primaryMags;

    sleep 1;

    {
        player addPrimaryWeaponItem _x;
    } forEach _primaryMags;
};

// --- Insignia and weapon state ---
player spawn DOTT_loadout_fnc_setInsignia;

if !(weaponLowered player) then
{
    player action ["WeaponOnBack", player];
};

systemChat "Your gear has been saved.";

true
