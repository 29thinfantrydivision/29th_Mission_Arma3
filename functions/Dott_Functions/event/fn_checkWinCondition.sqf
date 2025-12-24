//returns [opfor owned, blufor owned, resistance owned]
fn_getNumSectorsOwnedBySides = {
	private _result = [0,0,0];
	private _sectors = missionnamespace getvariable ["BIS_fnc_moduleSector_sectors",[]];

	{
		private _owner = _x getVariable ["owner", sideUnknown];
		private _idx = _owner call BIS_fnc_sideID;
		if (_idx >= 2) then { continue };
		_result set [_idx, (_result select _idx) + 1];		
	}
	forEach _sectors;

	_result;
};

/**** Win Condition Functions ****/
fn_numSectors = {
	params ["_sideID", "_numNeeded"];
	private _ownedSectors = call fn_getNumSectorsOwnedBySides;

	(_ownedSectors select _sideID) >= _numNeeded;
};

private _loopChecks = [[{ false }], [{ false }], [{ false }]];
private _endChecks = [[{ false }], [{ false }], [{ false }]];

private _sideSettings =
[
	DOTT_event_opforWinConditions,
	DOTT_event_bluforWinConditions,
	DOTT_event_grnforWinConditions
];

{
	if (_x isEqualType "") then { continue }; //no win condition for this side
	private _winCon  = _x select 0;
	private _winArgs = _x select 1;
	private _atEnd = _x select 2;
	private _checkFn = switch (_winCon) do
	{
		case "NumSectors": { [fn_numSectors, [_forEachIndex, _winArgs]]; };
		default { [{ false }] };
	};

	if (_atEnd) then
	{
		_endChecks set [_forEachIndex, _checkFn];
	} else 
	{
		_loopChecks set [_forEachIndex, _checkFn];
	};
}
forEach _sideSettings;

[
	"DOTT_round_ended",
	{
		private _endChecks = _thisArgs;
		{
			private _fnCheck = _x select 0;
			private _args = [];
			if (count _x >= 2) then {_args = _x select 1};
			if (_args call _fnCheck) exitWith
			{
				private _winningSide = _forEachIndex call BIS_fnc_sideType;
				[true, _winningSide] call DOTT_event_fnc_game;
			}
		} forEach _endChecks;

		[true] call DOTT_event_fnc_game; //no side met win conditions, call neutral ending
	}, _endChecks
] call CBA_fnc_addEventHandlerArgs;

while {call DOTT_round_fnc_isRoundActive} do
{
	sleep DOTT_event_winCheckInterval;

	{
		private _fnCheck = _x select 0;
		private _args = [];
		if (count _x >= 2) then {_args = _x select 1};
		if (_args call _fnCheck) exitWith
		{
			private _winningSide = _forEachIndex call BIS_fnc_sideType;
			[true, _winningSide] call DOTT_event_fnc_game;
		}
	} forEach _loopChecks;
};