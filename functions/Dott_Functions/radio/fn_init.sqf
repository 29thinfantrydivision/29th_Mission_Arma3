if (hasInterface) then
{
	if (isClass (configFile >> "CfgPatches" >> "ace_main")) then {
		["ace_arsenal_displayClosed", 
		{
			call DOTT_radio_fnc_add;
		}] call CBA_fnc_addEventHandler;
	};

	["DOTT_radio_removeOnDeath", "Killed", 		
		{		
			if (TN_removeRadiosOnDeath) then
			{
				(_this select 0) call DOTT_radio_fnc_remove;
			};
		}
	] call CBA_fnc_addBISPlayerEventHandler;

	call DOTT_radio_fnc_initTransferSettings;
};

