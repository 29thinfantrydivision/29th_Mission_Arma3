/**
 * Function: DOTT_training_fnc_initDateAndWeather
 * Author: Bae [29th ID]
 *
 * Description:
 *     Sets date, overcast, and fog on the server. The engine
 *     automatically syncs weather to clients. Must only run
 *     on the server.
 *
 * Parameters:
 *     _forcedDate     (Array)        - Date array [y, m, d, h, min]
 *     _forcedOvercast (Number)       - Overcast level 0..1
 *     _forcedFog      (Number/Array) - Fog density or
 *                                      [value, decay, base]
 *
 * Returns:
 *     Nothing
 */

if (!isServer) exitWith {};

params ["_forcedDate", "_forcedOvercast", "_forcedFog"];

setDate _forcedDate;
0 setOvercast _forcedOvercast;
0 setFog _forcedFog;

forceWeatherChange;

diag_log format [
    "Server Set Weather: date=%1, overcast=%2, fog=%3",
    date, overcast, fogParams
];
