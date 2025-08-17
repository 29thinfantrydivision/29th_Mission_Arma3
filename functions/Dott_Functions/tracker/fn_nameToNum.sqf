params["_name", "_side", "_eventTime"];
private _num = DOTT_tracker_names find _name;
if (_num == -1) then 
{
	DOTT_tracker_names pushBack _name;
	DOTT_tracker_sides pushBack [[_side, _eventTime]];

	_num = count DOTT_tracker_names - 1;
} else {
	private _sides = DOTT_tracker_sides select _num;
	private _lastSide = (_sides select ((count _sides) - 1)) select 0;
	if (_side != _lastSide) then {
		_sides pushBack [_side, _eventTime];
	}	
};

_num
