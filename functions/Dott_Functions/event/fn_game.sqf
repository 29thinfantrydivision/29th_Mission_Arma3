/* By Dott [29th ID]
 *
 * Manages evaluations for endings based on sectors, or forces endings
 * Is called by eventTimerCheck.sqf when the timer runs out, also by admin game call addAction in eventTimer.sqf
 * May be called anywhere needed, but should only be run on server
 * Server only, will remoteExec endings for clients
 *
 * Configurable:
 *	_endNeutral (string): Neutral ending defined in description.ext class CfgDebriefing
 *	_end*SIDE* (string): Victory ending for that respective side defined in description.ext class CfgDebriefing
 * 	
 * Parameters:
 *	_forceEnding (bool): (OPTIONAL) True if an ending should be forced (I.E. no evaluations)
 *	_sideVictory (side): (OPTIONAL) If _forceEnding = true then specific side that has won. If left empty then triggers neutral ending.
 *	_forceEndingClass (string): (OPTIONAL) Ignore side, and instead use string name of ending to be forced, defined in description.ext class CfgDebriefing
 *
 * Requires:
 *	n/a
 *
 */

params 
[
	["_forceEnding", false, [false]],
	["_sideVictory", sideUnknown],
	["_forceEndingClass", "", [""]]
];

if (!isServer) exitWith {_this remoteExecCall ["DOTT_event_fnc_game", 2]}; //server only

/******** CONFIG ********/
private _endNeutral = "EndNeutral";
private _endWest = "EndWestVictory";
private _endEast = "EndEastVictory";
private _endResistance = "EndGuerVictory";


/************************/

//check if game was called already, exit if true, prevents duplicate endings
if (isnil "gameCalled") then { gameCalled = false; };
if (gameCalled) exitwith { };
gameCalled = true; publicVariable "gameCalled";
["DOTT_event_gameCalled", []] call CBA_fnc_globalEvent;

//if ending is forced, then call the specified ending for all clients
if (_forceEnding) exitwith
{
	//if a specific ending is specified when called, then do that
	if (_forceEndingClass != "") then
	{
		[_forceEndingClass] remoteExec ["BIS_fnc_endMission"];
	}
	else
	{
		//else trigger victory ending for given side, or neutral ending if not west, east, or resistance
		switch (_sideVictory) do
		{
			case west: { [_endWest] remoteExec ["BIS_fnc_endMission"]; };
			case east: { [_endEast] remoteExec ["BIS_fnc_endMission"]; };
			case resistance: { [_endResistance] remoteExec ["BIS_fnc_endMission"]; };
			default { [_endNeutral] remoteExec ["BIS_fnc_endMission"]; };
		};
	};
};

//NO EVAL RIGHT NOW - WILL BE WRITTEN LATER - Dott

//get the number of sectors in the mission, and count them
//private _eventSectors = missionnamespace getvariable ["BIS_fnc_moduleSector_sectors",[]];
//private _eventSectorCount = count _eventSectors;

//["end1"] remoteExec ["BIS_fnc_endMission"];

//call{t_sector_1 getVariable "owner" == WEST}
//call{t_sector_1 enablesimulation false;}