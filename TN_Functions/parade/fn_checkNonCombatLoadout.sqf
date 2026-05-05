#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Checks if a unit is in a non-combat loadout (suitable for
 * lining up).
 *
 * Arguments:
 * 0: The unit to check for non-combat loadout <OBJECT>
 *
 * Return Value:
 * true if the unit is in a non-combat loadout, false otherwise <BOOL>
 *
 * Example:
 * [player] call TN_parade_fnc_checkNonCombatLoadout;
 */

// "r_Garrison_cap" prefix -- matches 29th ID BLUFOR garrison caps.
#define PARADE "r_Garrison_cap" in (headgear _unit)
// "U_US_class_A" prefix -- matches 29th ID Class A uniforms.
#define CLASS_A "U_US_class_A" in (uniform _unit)
// Officers typically have no primary weapon.
#define OFFICER primaryWeapon _unit isEqualTo "";

params ["_unit"];

PARADE || CLASS_A || OFFICER
