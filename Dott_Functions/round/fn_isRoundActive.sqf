/*
 * Function: DOTT_round_fnc_isRoundActive
 *
 * Description:
 *     Checks if the round is currently active. A round is active when
 *     the BIS countdown is running AND safe start is not in progress.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     <Boolean> - true if the round is active, false otherwise.
 */

(([true] call BIS_fnc_countdown) && isNil "DOTT_round_safeStartActive")
