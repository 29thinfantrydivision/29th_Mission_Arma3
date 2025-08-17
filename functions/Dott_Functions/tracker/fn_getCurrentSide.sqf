params ["_unitIndex", "_time"];

private _sides = DOTT_tracker_sides select _unitIndex;
private _currentSide = sideUnknown;
for "_i" from (count _sides - 1) to 0 step - 1 do {
	private _sideTime = (_sides select _i) select 1;
	if (_time >= _sideTime) exitWith {_currentSide = (_sides select _i) select 0};
};

_currentSide
