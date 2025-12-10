#define DEFAULT_INDEX 0
#define MISSION_ADDON "dott"
if (isServer) then
{
	if !(isNil "DOTT_settings_allSettings") exitWith {};
	DOTT_settings_allSettings = [];

	private _missionAddonStrLen = count MISSION_ADDON;
	{
		if (_x select [0,_missionAddonStrLen] != MISSION_ADDON) then {continue};
		
		DOTT_settings_allSettings pushBack _x;
	}
	forEach cba_settings_allSettings;

	publicVariable "DOTT_settings_allSettings";
};