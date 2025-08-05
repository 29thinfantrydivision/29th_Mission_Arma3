/*
 * Name:	fnc_checkPlayerWeaponState
 * Date:	8/5/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Check if a player's weapon state is correct to prevent one known case of silent weapon bug.
 * If weapon is incorrect, then notify all players of player name and weapon state.
 * Should be called server side, player won't desync his own weapon.
 *
 * Parameter(s): 
 * _unit: The unit to check the weapon state of.
 * _event (Optional): A string to append to the message, useful for context (e.g., "Arsenal", "Respawn").
 *
 * Returns:
 * true if the weapon state is correct, false otherwise.
 *
 * Example:
 * [player, "Arsenal"] call DOTT_fn_checkPlayerWeaponState;
 * 
 */

if (!isServer) exitWith {};
params [["_unit", objNull, [objNull]],["_event", "", [""]]];
private _weapon = currentWeapon _unit; 

if !(_weapon in ["Throw", "Put"]) exitWith {true};

private _msg = format [
    "%1 has incorrect weapon state ""%2"" - Drop and re-equip your weapon. %3",
    name _unit,
    _weapon,
    if (_event != "") then { " - " + _event } else { "" }
];

_msg remoteExec ["systemChat", 0];
false;


