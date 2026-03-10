/**
 * DOTT_ocap_fnc_initClient
 *
 * Purpose:
 *   Client-side OCAP initialization. Handles JIP player
 *   registration (when autoStart is off) and sets up an ACE
 *   marker-move event handler so moved markers are tracked by
 *   OCAP with correct alpha values.
 *
 * Parameter(s):
 *   0: BOOL - Whether OCAP autoStart is enabled
 *
 * Returns: Nothing
 */

params ["_autoStart"];

if !(hasInterface) exitWith {};

// Register JIP players outside the capture loop so marker
// data is saved correctly.
if !(_autoStart) then
{
    [] spawn
    {
        waitUntil {!isNull player};

        if !(didJIP) exitWith {};

        [player] remoteExecCall
            ["DOTT_ocap_fnc_initializePlayer", 2];
    };
};

// --- Track marker moves via ACE event --- //
// Uses ACE's marker-move event instead of polling, which
// reduces network traffic to the server.
[
    "ace_markers_markerMoveEnded",
    {
        params
            ["_player", "_marker",
            "_originalPos", "_finalPos"];

        private _isExcluded = false;

        if (!isNil
            "ocap_recorder_settings_excludeMarkerFromRecord"
        ) then
        {
            {
                if ((str _marker) find _x > -1)
                    exitWith
                {
                    _isExcluded = true;
                };
            } forEach (parseSimpleArray
                ocap_recorder_settings_excludeMarkerFromRecord);
        };

        if (_isExcluded) exitWith {};

        private _pos = ATLToASL _finalPos;

        // Force alpha to 1 because ACE temporarily sets it
        // to 0.5 during the move, and the OCAP extension
        // truncates that to 0.
        ["ocap_handleMarker",
            ["UPDATED", _marker, _player, _pos,
            "", "", "", markerDir _marker,
            "", "", 1]]
            call CBA_fnc_serverEvent;
    }
] call CBA_fnc_addEventHandler;
