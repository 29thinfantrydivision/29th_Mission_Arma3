params["_projectile", "_instigator"];
if (_projectile == "") exitWith { DOTT_tracker_lastInstigatorWeapon };
//not in vehicle
if (vehicle _instigator isEqualTo _instigator) then 
{
	//Check if damage was done by handheld frag grenade
	private _cfg = configFile >> "CfgAmmo" >> _projectile; 
	private _damageType = getText(_cfg >> "ACE_damageType");  
	if(_damageType == "grenade") then {
		//ace fragmentation can come from many sources, so default to last known weapon
		//if ((_projectile find "ace_frag") == 0) exitWith { DOTT_tracker_lastInstigatorWeapon };
		if (count (getArray (_cfg >> "ace_grenades_pullPinSound")) > 0) then { "Grenade" }
		else { getText (configFile >> "CfgWeapons" >> currentWeapon _instigator >> "displayName") + " (GL)" }
	} else 
	{
		//return weapon in hand (best guess)
		getText (configFile >> "CfgWeapons" >> currentWeapon _instigator >> "displayName")
	};
} else
{
	getText(configFile >> "CfgVehicles" >> typeOf (vehicle _instigator) >> "displayName")
};