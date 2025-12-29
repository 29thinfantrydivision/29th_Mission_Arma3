if (hasInterface) then 
{
	[missionNamespace, "arsenalClosed", {
		call DOTT_loadout_fnc_arsenalClosed;
	}] call BIS_fnc_addScriptedEventHandler;

	if (isClass (configFile >> "CfgPatches" >> "ace_main")) then {
		["ace_arsenal_displayClosed", 
			{
				call DOTT_loadout_fnc_arsenalClosed;
			}
		] call CBA_fnc_addEventHandler;
	};

	["DOTT_loadout_setInsigniaRespawn", "Respawn", {(_this select 0) spawn DOTT_loadout_fnc_setInsignia}] call CBA_fnc_addBISPlayerEventHandler;
};

if (isServer) then
{

};