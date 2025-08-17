#include "eventNumbers.hpp"
params["_event"];
private _eventType = _event select 0;
private _eventTime = _event select 1;
private _eventInfo = _event select 2;

switch (_eventType) do 
{
	case ACE_CONSCIOUSNESS_NUM: 
	{
		private _unit = _eventInfo select 0;		
		private _unitName = _unit select 0;
		private _unitSide = _unit select 1;
		_eventInfo set [0, [_unitName, _unitSide, _eventTime] call DOTT_tracker_fnc_nameToNum];
		if(count _eventInfo > 2) then 
		{ 
			private _instigator = _eventInfo select 2;
			private _instigatorName = _instigator select 0;
			private _instigatorSide = _instigator select 1;
			_eventInfo set [2, [_instigatorName, _instigatorSide, _eventTime] call DOTT_tracker_fnc_nameToNum];
		};
	};
	case KILL_NUM: 
	{
		private _unit = _eventInfo select 0;		
		private _unitName = _unit select 0;
		private _unitSide = _unit select 1;
		_eventInfo set [0, [_unitName, _unitSide, _eventTime] call DOTT_tracker_fnc_nameToNum];
		if(count _eventInfo > 1) then 
		{
			private _instigator = _eventInfo select 1;
			private _instigatorName = _instigator select 0;
			private _instigatorSide = _instigator select 1;
			_eventInfo set [1, [_instigatorName, _instigatorSide, _eventTime] call DOTT_tracker_fnc_nameToNum];
		};
	};
};

DOTT_tracker_trackedEvents pushBack _event;