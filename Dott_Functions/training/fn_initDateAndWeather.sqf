/**
 * DOTT_training_fnc_initDateAndWeather
 *
 * Purpose:
 *   Sets date, overcast, and fog on the server. The engine
 *   automatically syncs weather to clients. Must only run
 *   on the server.
 *
 * Parameter(s):
 *   _forcedDate     (Array)        - Date array [y, m, d, h, min]
 *   _forcedOvercast (Number)       - Overcast level 0..1
 *   _forcedFog      (Number/Array) - Fog density or
 *                                    [value, decay, base]
 *
 * Returns: Nothing
 *
 * Example:
 *   private _forcedDate     = [2018, 3, 30, 12, 0];
 *   private _forcedOvercast = 0.1;
 *   private _forcedFog      = [0.1, 0.01, 0];
 *   [_forcedDate, _forcedOvercast, _forcedFog]
 *       call DOTT_training_fnc_initDateAndWeather;
 *
 * Date: 7/24/2025
 * Version: 1.0
 * Author: Bae [29th ID]
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
