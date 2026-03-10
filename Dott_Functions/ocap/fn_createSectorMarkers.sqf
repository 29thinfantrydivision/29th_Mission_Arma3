/**
 * DOTT_ocap_fnc_createSectorMarkers
 *
 * Purpose:
 *   Creates local area and icon markers for a sector module,
 *   replacing any previous markers. Uses a 2-second delayed
 *   deletion of old markers so the transition appears seamless
 *   (OCAP delays new marker creation by ~2 seconds internally).
 *
 * Parameter(s):
 *   0: OBJECT - Sector logic module
 *   1: SIDE   - New owning side (sideUnknown for neutral)
 *
 * Returns: Nothing
 */

params ["_logic", "_owner"];

private _oldAreaMarkers =
    _logic getVariable ["DOTT_areaMarkers", []];

// Delay deletion to align with OCAP's ~2s marker creation
// lag, keeping the visual transition smooth.
[_oldAreaMarkers] spawn
{
    params ["_oldAreaMarkers"];

    sleep 2;

    {
        deleteMarkerLocal _x;
    } forEach _oldAreaMarkers;
};

private _newMarkers = [];

private _areas = _logic getVariable ["areas", []];

private _markerColor = "colorgrey";
if (_owner != sideUnknown) then
{
    _markerColor = [_owner, true] call bis_fnc_sidecolor;
};

// --- Create area outline markers for each trigger --- //
{
    private _trigger = _x;
    private _markerName =
        "DOTT_ocap_sectorArea" + str _trigger + str time;
    private _marker = createMarkerLocal
        [_markerName, position _trigger];

    private _triggerArea = triggerArea _trigger;

    if (_triggerArea select 3) then
    {
        _marker setMarkerShapeLocal "rectangle";
    }
    else
    {
        _marker setMarkerShapeLocal "ellipse";
    };

    _marker setMarkerDirLocal (_triggerArea select 2);
    _marker setMarkerSizeLocal
        [(_triggerArea select 0), (_triggerArea select 1)];
    _marker setMarkerBrushLocal "Border";
    _marker setMarkerAlphaLocal 1;
    _marker setMarkerColorLocal _markerColor;

    _newMarkers pushBack _marker;
} forEach _areas;

_logic setVariable ["DOTT_areaMarkers", _newMarkers];

// --- Recreate center icon marker with new color --- //

private _oldTextMarker =
    _logic getVariable ["DOTT_nameMarker", ""];

// Same 2-second delay rationale as area markers above.
[_oldTextMarker] spawn
{
    params ["_oldTextMarker"];

    sleep 2;
    deleteMarkerLocal _oldTextMarker;
};

private _sectorName =
    _logic getVariable ["name", ""];

private _markerIconText = createMarkerLocal
    ["DOTT_ocap_iconText" + str _logic + str time,
    position _logic];

_markerIconText setMarkerTypeLocal "hd_objective";
_markerIconText setMarkerColorLocal _markerColor;
_markerIconText setMarkerTextLocal _sectorName;
_markerIconText setMarkerSizeLocal [0.5, 0.5];
_markerIconText setMarkerAlphaLocal 1;

_logic setVariable ["DOTT_nameMarker", _markerIconText];
