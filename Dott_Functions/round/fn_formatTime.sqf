/*
 * Name:	DOTT_round_fnc_formatTime
 * Date:	12/22/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Formats a time value (seconds) into a human-readable string.
 *
 * Parameter(s): 
 * _seconds (Number) - Time in seconds to format.
 * _forceNoS (Boolean, optional) - If true, always use singular form for time units. Default is false.
 *
 * Returns:
 * String in the format of "X hours Y minutes Z seconds". Omit hours or minutes if they are zero. Omit s at ends of words for singular values.
 *
 * Example:
 * [1200] call DOTT_round_fnc_formatTime;
 * 
 */

params ["_seconds", ["_forceNoS", false]];

private _hours = floor (_seconds / 3600);
private _mins = floor ((_seconds mod 3600) / 60);
private _secs = _seconds mod 60;

private _timeParts = [];

// Add hours if >= 1
if (_hours > 0) then {
    private _hourWord = ["Hours", "Hour"] select (_hours == 1 || _forceNoS);
    _timeParts pushBack format ["%1 %2", _hours, _hourWord];
};

// Add minutes if >= 1
if (_mins > 0) then {
    private _minWord = ["Minutes", "Minute"] select (_mins == 1 || _forceNoS);
    _timeParts pushBack format ["%1 %2", _mins, _minWord];
};

// Always add seconds if > 0, or if nothing else was added
if (_secs > 0 || (count _timeParts == 0)) then {
    private _secWord = ["Seconds", "Second"] select (_secs == 1 || _forceNoS);
    _timeParts pushBack format ["%1 %2", _secs, _secWord];
};

// Combine all parts with spaces
private _timeText = _timeParts joinString " ";

_timeText