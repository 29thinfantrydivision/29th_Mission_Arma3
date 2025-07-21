// By Dott [29th ID]
// Looping script that checks the status of the timer and overtime and displays game calls when necessary

if (!isServer) exitWith {};

overTimePeriod = 5; //default overtime length, in minutes
overTime = false; //prevents nil errors for overTime check
timerLength = 20; publicVariable "timerLength"; //default timer length, in minutes

while {true} do
{
	private _timerRunning = [true] call BIS_fnc_countdown; //Check if timer is on
	sleep 0.5;
	private _timerEnded = [true] call BIS_fnc_countdown; //Check if timer is still on after 0.5 seconds
	
	if (_timerRunning and !_timerEnded) then //if timer is not still on then continue, otherwise repeat
	{
		// Check if overtime is enabled, if so, start overtime timer, otherwise call game
		
		if (overTime) then
		{
			["<t color='#ffffff' size='3'><br/>%1 Minute OVERTIME</t>","PLAIN",0.5, true, overTimePeriod] remoteExec ["DOTT_fnc_displayMsg"];
			[((overTimePeriod) * 60)] call BIS_fnc_countdown;
			overTime = false; //Prevents overtime from repeating forever
		}
		else
		{
			["<t color='#ffffff' size='5'>GAME!</t>","PLAIN",0.4] remoteExec ["DOTT_fnc_displayMsg"];
			[-1] call BIS_fnc_countdown;
		}
	};
};