// By Dott [29th ID]
// Script checks which sides are occupied, which sides are ready, and starts a timer if conditions are met, defined by "timerLength"
// Server side script
// Ready status and timerLength defined in module_chatintercept\commands.sqf

if (!isServer) exitWith {};

// Check to see if timer is running, if so unready sides to prevent ready states being stuck on true and exit script

if ([true] call BIS_fnc_countdown) exitwith 
{
	bluReady = false; publicVariable "bluReady";
	opfReady = false; publicVariable "opfReady";
	grnReady = false; publicVariable "grnReady";
};

private ["_bluOccupied", "_opfOccupied", "_grnOccupied", "_bluCount", "_opfCount", "_grnCount"];

private _startTimer = false; // Define variables as false to avoid nil errors
private _launchTimer = false;
private _safeStartTime = 10; // time between all sides ready and automatic live call (default 10)

// count players on each side to to verify if side has players and define math for sides

_bluCount = west countSide allplayers;
_opfCount = east countSide allplayers;
_grnCount = resistance countSide allplayers;

if (_bluCount > 0) then { _bluOccupied = 1 } else { _bluOccupied = 0 };
if (_opfCount > 0) then { _opfOccupied = 2 } else { _opfOccupied = 0 };
if (_grnCount > 0) then { _grnOccupied = 4 } else { _grnOccupied = 0 };

// Compare sides and do math to determine which of 7 possibilities is current

private _startCondition = (_bluOccupied + _opfOccupied + _grnOccupied);

switch (_startCondition) do
{
	case 1: { if (bluReady) then { _startTimer = true }; };
	case 2: { if (opfReady) then { _startTimer = true }; };
	case 3: { if (bluReady && opfReady) then { _startTimer = true }; };
	case 4: { if (grnReady) then { _startTimer = true }; };
	case 5: { if (bluReady && grnReady) then { _startTimer = true }; };
	case 6: { if (opfReady && grnReady) then { _startTimer = true }; };
	case 7: { if (bluReady && opfReady && grnReady) then { _startTimer = true }; };
	default {hint "Error calling start"};
};

if (!_startTimer) exitWith {}; //Exit script if sides aren't all ready

//If the proper condition is met, begin safe count

["<t color='#ffffff' size='3'>Live in %1 Seconds!</t>", "PLAIN", 0.5, true, _safeStartTime] remoteExec ["DOTT_fnc_displayMsg"];

sleep _safeStartTime;

//Double check that sides are still ready, after _safeStartTime, before launching timer

switch (_startCondition) do
{
	case 1: { if (bluReady) then { _launchTimer = true }; };
	case 2: { if (opfReady) then { _launchTimer = true }; };
	case 3: { if (bluReady && opfReady) then { _launchTimer = true }; };
	case 4: { if (grnReady) then { _launchTimer = true }; };
	case 5: { if (bluReady && grnReady) then { _launchTimer = true }; };
	case 6: { if (opfReady && grnReady) then { _launchTimer = true }; };
	case 7: { if (bluReady && opfReady && grnReady) then { _launchTimer = true }; };
	default {hint "Error calling start"};
};

// Check to see if timer is running, for cases of rapid readying/unreadying during safe start phase

if ([true] call BIS_fnc_countdown) exitWith {};

// Display aborted message if they are not still ready

if (_startTimer and !_launchTimer) exitWith 
{
	["<t color='#ffffff' size='4'>Timer Aborted!</t>","PLAIN",0.5] remoteExec ["DOTT_fnc_displayMsg"];
};

// launch the timer dependent on timerLength defined elsewhere

if (_launchTimer) then 
{
	["<t color='#ffffff' size='4'>LIVE LIVE LIVE</t><br/>%1 Minute Time Limit","PLAIN",0.5, true, timerLength] remoteExec ["DOTT_fnc_displayMsg"];
	[((timerLength) * 60)] call BIS_fnc_countdown;
	bluReady = false; publicVariable "bluReady";
	opfReady = false; publicVariable "opfReady";
	grnReady = false; publicVariable "grnReady";
};