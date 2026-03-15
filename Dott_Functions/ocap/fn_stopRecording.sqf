/**
 * DOTT_ocap_fnc_stopRecording
 *
 * Purpose:
 *   Stops OCAP recording by firing a CBA server event, pushing a
 *   diary entry to clients, updating timestamps, and clearing the
 *   recording flag.
 *   Modified from OCAP 2 Addon for this mission's round system.
 *
 * Parameter(s): None
 * Returns: Nothing
 */

//Modified version from OCAP 2 Addon tweaked for this mission
private _systemTimeFormat = ["%1-%2-%3T%4:%5:%6.%7"];
_systemTimeFormat append (systemTimeUTC apply {if (_x < 10) then {"0" + str _x} else {str _x}});
private _missionDateFormat = ["%1-%2-%3T%4:%5:00"];
_missionDateFormat append (date apply {if (_x < 10) then {"0" + str _x} else {str _x}});

["ocap_customEvent", ["generalEvent", "Recording paused."]] call CBA_fnc_serverEvent;

// Log times
[] call ocap_recorder_fnc_updateTime;

ocap_recorder_recording = false;
publicVariable "ocap_recorder_recording";
