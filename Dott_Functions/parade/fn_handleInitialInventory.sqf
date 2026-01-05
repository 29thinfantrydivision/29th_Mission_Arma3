/*
 * Name:	DOTT_parade_fnc_handleInitialInventory
 * Date:	9/30/2025
 * Version: 1.2
 * Author:  Hill [29th ID]
 *
 * Description:
 * Ensures joining player has correct loadout on joining the server, using custom parade if available on BLUFOR.
 *
 * Parameter(s): 
 * none
 *
 * Returns:
 * n/a
 *
 * Example:
 * [player] spawn DOTT_parade_fnc_handleInitialInventory
 */

if (!hasInterface) exitWith {};

waitUntil {!isNull player};

if (side (group player) == WEST) then {
	addMissionEventHandler ["PreloadFinished", {
		[true] call DOTT_parade_fnc_load;
		removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
	}];
};
if (side (group player) == EAST) then {
	[player, missionConfigfile >> "CfgRespawnInventory" >> "29TH_PARADE_EAST"] call BIS_fnc_loadInventory;
};
if (side (group player) == INDEPENDENT) then {
	[player, missionConfigfile >> "CfgRespawnInventory" >> "29TH_PARADE_INDEPENDENT"] call BIS_fnc_loadInventory;
};