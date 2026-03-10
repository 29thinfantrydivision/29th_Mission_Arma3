/**
 * Function: DOTT_parade_fnc_checkNonCombatLoadout
 * Author:   Bae [29th ID]
 *
 * Description:
 *   Checks whether a unit is in a non-combat loadout suitable
 *   for formation / parade. Returns true if the unit wears a
 *   BLUFOR garrison cap with the M1 Garand parade rifle, or if
 *   the unit has no primary weapon (common officer loadout).
 *
 * Parameters:
 *   _unit (Object) - The unit to check
 *
 * Returns:
 *   Boolean - true if the unit is in a non-combat loadout
 */

params ["_unit"];

// "r_Garrison_cap" prefix -- matches 29th ID BLUFOR garrison caps.
// "rhs_weap_m1garand_sa43" -- standard 29th parade rifle.
private _hasBluforParadeGear =
    (headgear _unit) find "r_Garrison_cap" == 0
    && primaryWeapon _unit == "rhs_weap_m1garand_sa43";

// Officers typically have no primary weapon.
private _hasNoPrimary = primaryWeapon _unit == "";

_hasBluforParadeGear || _hasNoPrimary
