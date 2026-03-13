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

//do OCAP initalization on players outside of capture loop so we can save proper marker info
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