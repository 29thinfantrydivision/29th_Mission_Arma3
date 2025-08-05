if (!hasInterface) exitWith {};
[player, [missionNamespace, "Current Inventory"]] call BIS_fnc_saveInventory;
[player, ["missionNamespace:Current Inventory"]] call BIS_fnc_setRespawnInventory;

resetLoadout = getUnitLoadout player;
/*
//prevent inaudible weapon bug
[] spawn {
	sleep 1;
	[player, resetLoadout, true] call DOTT_fnc_fullSetUnitLoadout;	
};
*/

[] spawn 
{
	sleep 2;
	[player] remoteExec ["DOTT_fnc_checkPlayerWeaponState", 2];	
};

player spawn Hill_fnc_setInsignia;
if (!(weaponLowered player)) then {
	player action ["WeaponOnBack", player];
};
systemChat "Your gear has been saved.";
hintSilent "Your gear has been saved.";
true