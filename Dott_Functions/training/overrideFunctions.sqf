/**
 * File: overrideFunctions.sqf
 * Author: Bae [29th ID]
 *
 * Description:
 *     Replaces the vanilla BIS_fnc_moduleSector with a custom
 *     version that supports CBA-configurable capture weights
 *     and vehicle cost settings.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 */

BIS_fnc_moduleSector = compileFinal
    preprocessFileLineNumbers
    "DOTT_Functions\training\BIS_fnc_moduleSectorAlt.sqf";
