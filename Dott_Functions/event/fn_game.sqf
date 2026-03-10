/**
 * DOTT_event_fnc_game
 *
 * Manages round endings by forcing a specific side victory,
 * neutral ending, or named ending class. Redirects to server
 * if called on a client. Prevents duplicate endings via the
 * gameCalled guard.
 *
 * Parameters:
 *     _forceEnding      (bool)   - True to skip evaluations
 *                                  and force an ending.
 *     _sideVictory      (side)   - Winning side when forced.
 *                                  Omit for neutral ending.
 *     _forceEndingClass (string) - Named ending class from
 *                                  CfgDebriefing. Overrides
 *                                  _sideVictory if set.
 *
 * Returns:
 *     Nothing
 */

params
[
    ["_forceEnding", false, [false]],
    ["_sideVictory", sideUnknown],
    ["_forceEndingClass", "", [""]]
];

if (!isServer) exitWith
{
    _this remoteExecCall ["DOTT_event_fnc_game", 2];
};

/* --- Config: ending class names from CfgDebriefing --- */

private _endNeutral = "EndNeutral";
private _endWest = "EndWestVictory";
private _endEast = "EndEastVictory";
private _endResistance = "EndGuerVictory";

/* --- Duplicate-call guard --- */

if (isNil "gameCalled") then { gameCalled = false };
if (gameCalled) exitWith {};
gameCalled = true;
publicVariable "gameCalled";
["DOTT_event_gameCalled", []] call CBA_fnc_globalEvent;

/* --- Force ending path --- */

if (_forceEnding) exitWith
{
    if (_forceEndingClass != "") then
    {
        // Named ending class takes priority.
        [_forceEndingClass]
            remoteExec ["BIS_fnc_endMission"];
    }
    else
    {
        // Side-based victory, or neutral if unrecognised.
        switch (_sideVictory) do
        {
            case west:
            {
                [_endWest]
                    remoteExec ["BIS_fnc_endMission"];
            };
            case east:
            {
                [_endEast]
                    remoteExec ["BIS_fnc_endMission"];
            };
            case resistance:
            {
                [_endResistance]
                    remoteExec ["BIS_fnc_endMission"];
            };
            default
            {
                [_endNeutral]
                    remoteExec ["BIS_fnc_endMission"];
            };
        };
    };
};
