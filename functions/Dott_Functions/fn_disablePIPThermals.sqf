/*
 * Name:	DOTT_fnc_disablePIPThermals
 * Date:	9/2/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Checks every RenderTarget's camera of player vehicle and disables any that have thermal vision.
 * Must be called every time player enters a vehicle.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * true if at least one PiP camera disabled, false otherwise
 *
 * Example:
 * call DOTT_fnc_disablePIPThermals;
 * 
 */
private _veh = vehicle player; 
private _disabledSomething = false;
{ 
    private _rtCfg = _x;                                    
    private _rtName = getText (_rtCfg >> "renderTarget");   
  
    { 
        private _camCfg = _x;                   
        private _visionMode = getNumber (_camCfg >> "renderVisionMode");  
 
        if (_visionMode == 2) exitWith 
		{ 
			_veh CameraEffect ["terminate","back", _rtName];
			_disabledSomething = true; 
		}; 
    } forEach (configProperties [_rtCfg, "isClass _x", true]); 

} forEach (configProperties [configFile >> "CfgVehicles" >> typeOf _veh >> "RenderTargets", "isClass _x", true]);

if (_disabledSomething) then { systemChat "EXPERIMENTAL: Disabled PiP Thermals" };

_disabledSomething