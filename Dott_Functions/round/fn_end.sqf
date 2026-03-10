/*
 * Function: DOTT_round_fnc_end
 *
 * Description:
 *     Transitions to overtime if applicable, otherwise ends the round
 *     with notifications. When overtime triggers, it disables itself
 *     to prevent infinite repeats, then re-waits for the overtime
 *     countdown to expire before calling end again.
 *
 * Parameters:
 *     _force <Boolean> - Manual override to force round end.
 *                        Default: false
 *
 * Returns:
 *     <Boolean> - true
 */

params [["_force", false, [false]]];

if (DOTT_round_overtimeEnabled && !_force) then
{
    /* --- Overtime transition --- */
    private _overtimeMsg = format [
        "<t color='#ffffff' size='3'><br/>%1 Minute OVERTIME</t>",
        DOTT_round_overtimePeriod / 60
    ];
    [
        _overtimeMsg,
        "PLAIN",
        0.5,
        true
    ] remoteExecCall ["DOTT_common_fnc_displayMsg"];

    [DOTT_round_overtimePeriod] call BIS_fnc_countdown;

    DOTT_round_overtimeEnabled = false;
    publicVariable "DOTT_round_overtimeEnabled";

    DOTT_round_timeAdded = true;
    publicVariable "DOTT_round_timeAdded";

    [
        {(call DOTT_round_fnc_getTime) <= 0},
        {call DOTT_round_fnc_end},
        []
    ] call CBA_fnc_waitUntilAndExecute;
}
else
{
    /* --- Forced end while round is still running --- */
    if (call DOTT_round_fnc_isRoundActive) exitWith
    {
        DOTT_round_overtimeEnabled = false;
        publicVariable "DOTT_round_overtimeEnabled";
        [-1] call BIS_fnc_countdown;
        true
    };

    // Called when round is not running; nothing to do.
    if (_force) exitWith {true};

    /* --- Natural round end --- */
    [
        "<t color='#ffffff' size='5'>GAME!</t>",
        "PLAIN",
        0.4
    ] remoteExecCall ["DOTT_common_fnc_displayMsg"];

    [-1] call BIS_fnc_countdown;
    ["DOTT_round_ended", []] call CBA_fnc_globalEvent;
};

true
