#include "eventNumbers.hpp"
params ["_unit", "_killer", "_instigator"];
if (DOTT_tracker_startTime == -1) exitWith { false };

_instigator = [_killer, _unit, _instigator] call DOTT_tracker_fnc_findInstigator;

private _timeStamp = round(serverTime - DOTT_tracker_startTime);

private _event = [KILL_NUM, _timeStamp];

private _unitName = "";
//if unit is not man then name does not work properly
if (_unit isKindOf "Man") then 
{
    _unitName = name _unit;
} else 
{
	_unitName = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName");
	if (_unitName == "") then {_unitName = "Vehicle"}; 
};

private _unitSide = side (group _unit); //need group since ACE3? sets dead men to CIV but not the group

private _killInfo = [[_unitName, _unitSide]]; 
if !(isNull _instigator) then 
{
	_killInfo pushBack [name _instigator, side (group _instigator)];
	private _distance = round (_unit distance _instigator);
	_killInfo pushBack _distance;
};

_event pushBack _killInfo;

//_event is now either
//[[KILL_NUM, _timeStamp, [[name _unit, side _unit], [name _instigator, side _instigator], _distance]]
//[[KILL_NUM, _timeStamp, [name _unit, side _unit]]
[_event] remoteExec ["DOTT_tracker_fnc_sendEvent", 2];

true