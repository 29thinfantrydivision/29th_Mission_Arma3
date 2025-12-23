{	//if timer object is nil, set to objNull to avoid errors
	if (isNil {_x}) then 
	{
		DOTT_event_timerObjects set [_forEachIndex, objNull];
	}; 
}
forEach DOTT_event_timerObjects;

if (isNil "DOTT_event_endingObject") then
{
	DOTT_event_endingObject = objNull;
	systemChat "WARNING: Admin object (endingObject) not found!";
};

if (isNil "DOTT_round_safeStartHappened") then //add ready actions and removal events if safe start didn't happen yet
{
	{ 
		_x addAction ["<t color='#bf3eff'>Side Ready</t>", {(_this select 3) call DOTT_round_fnc_manageReady}, [playerSide, true], 1.5, true, true, "", "true", 8];
		_x addAction ["<t color='#bf3eff'>Ready All Sides (Admin)</t>", {call DOTT_round_fnc_initSafeStart}, nil, 1.5, true, true, "", "serverCommandAvailable '#lock'", 8];
	}
	forEach DOTT_event_timerObjects;

	[
		"DOTT_round_sideReady",
		{
			private _side = _this select 0;
			if (_side != playerSide) exitWith {};
			{
				_x removeAction 0; //remove ready action from flags when player's side is ready
			} forEach DOTT_event_timerObjects;						
		} 
	] call CBA_fnc_addEventHandler;

	DOTT_event_endingObject addAction ["<t color='#bf3eff'>Ready All Sides (Admin)</t>", {call DOTT_round_fnc_initSafeStart}, nil, 1.5, true, true, "", "serverCommandAvailable '#lock'", 8];

	[
		"DOTT_round_safeStartBegin", 
		{
			{ removeAllActions _x } forEach DOTT_event_timerObjects;
			removeAllActions DOTT_event_endingObject; //remove ready all sides
			DOTT_event_endingObject addAction ["<t color='#bf3eff'>Force End Safestart (Admin)</t>", {[DOTT_event_timerLength] call DOTT_round_fnc_start}, nil, 1.5, true, true, "", "serverCommandAvailable '#lock'", 8];
		} 
	] call CBA_fnc_addEventHandler;	
};

if (!isNil "DOTT_round_safeStartHappened" && !(call DOTT_round_fnc_isRoundActive)) then //if JIP after safestart happened but before round start
{
	DOTT_event_endingObject addAction ["<t color='#bf3eff'>Force End Safestart (Admin)</t>", {[DOTT_event_timerLength] call DOTT_round_fnc_start}, nil, 1.5, true, true, "", "serverCommandAvailable '#lock'", 8];
};

private _fnc_addEndingActions = 
{
	removeAllActions DOTT_event_endingObject;
	DOTT_event_endingObject addAction ["<t color='#bf3eff'>Neutral Ending (Admin)</t>", 
	{ 
		[true] call DOTT_event_fnc_game; 
	},
	nil, 1.5, true, true, "", "serverCommandAvailable '#lock'", 8];	

	private _allPlayers = call BIS_fnc_listPlayers;
	private _sides = [[west, "BLUFOR", "#155DFC"], [east, "OPFOR", "#B40404"], [resistance, "GRNFOR", "#088A08"]];
	{
		private _side = _x select 0;
		private _sideName = _x select 1;
		private _sideColor = _x select 2;
		if (({side group _x == _side} count _allPlayers) > 0) then
		{
			private _actionText = format ["<t color='%1'>%2 Victory (Admin)</t>", _sideColor, _sideName];
			DOTT_event_endingObject addAction [_actionText, 
			{ 
				[true, _this select 3] call DOTT_event_fnc_game; 
			},
			_side, 1.5, true, true, "", "serverCommandAvailable '#lock'", 8];		
		};
	}
	forEach _sides; 			
};

if (call DOTT_round_fnc_isRoundActive) then //if JIP after round start
{
	call _fnc_addEndingActions;
} else
{
	[
		"DOTT_round_started", 
		_fnc_addEndingActions
	] call CBA_fnc_addEventHandler;	
};

[
	"DOTT_event_gameCalled", //remove all ending options after one is selected
	{
		removeAllActions DOTT_event_endingObject;
	} 
] call CBA_fnc_addEventHandler;