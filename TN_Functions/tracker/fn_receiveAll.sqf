/**
 * Function: TN_tracker_fnc_receiveAll
 * Author:   Bae [29th ID]
 *
 * Purpose:
 * Client-side function that receives all previous round
 * histories at once and processes them sequentially.
 * Called via remoteExec from fn_sendAll.
 *
 * Parameters:
 * _allRounds (Array): TN_tracker_previous from server.
 *     Each element is [events, names, sides, weapons].
 *
 * Returns:
 * true
 */

if (!hasInterface) exitWith {};
params ["_allRounds"];

{
    _x params ["_events", "_names", "_sides", "_weapons"];
    private _roundNum = _forEachIndex + 1;
    [
        _events, _names, _sides,
        _weapons, _roundNum
    ] call TN_tracker_fnc_createDiaryEntries;
} forEach _allRounds;

true
