/*
 * Function: DOTT_round_fnc_collectSilentWeapons
 *
 * Description:
 *     Collects the name of a player detected with the silent weapon
 *     bug into a server-side hashmap. Called via remoteExecCall from
 *     each client after round start.
 *
 * Parameters:
 *     _weaponHolder <String> - Display name of the player holding
 *                              the bugged weapon.
 *
 * Returns:
 *     None
 */

params ["_weaponHolder"];

if (isNil "DOTT_round_clientSilentWeapons") then
{
    DOTT_round_clientSilentWeapons = createHashMap;
};

DOTT_round_clientSilentWeapons set [_weaponHolder, true];
