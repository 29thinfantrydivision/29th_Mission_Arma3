//Only autospectate init here right now
if (hasInterface) then
{
	//If the respawn menu button is active
	if (!isNumber (missionConfigFile >> "respawnButton") || {getNumber (missionConfigFile >> "respawnButton") > 0}) then 
	{
		_respawnMenu = [] spawn 
		{
			waitUntil {!isNull (uiNamespace getVariable ["RscDisplayMPInterrupt", displayNull])};
			uiNamespace getVariable "RscDisplayMPInterrupt" displayCtrl 1010 ctrlAddEventHandler ["ButtonClick", 
			{
				missionNamespace setVariable ["menuRespawn", true];
			}];
		};
	};

	["DOTT_spectator_autoSpectate", "Respawn", 		
		{	
			params ["_newUnit", "_oldUnit"];	
			if (!isNull _oldUnit) then {
				if (missionNamespace getVariable ["menuRespawn", true]) then 
				{
					if (TN_autoSpectate) then 
					{
						systemChat "AutoSpectate is ON.";
						[_newUnit] spawn DOTT_spectator_fnc_enter;
					};
				};
			};
		}
	] call CBA_fnc_addBISPlayerEventHandler;	
};


