/**
 * DOTT_event_fnc_markEditorPlacedObjects
 *
 * Creates local map markers for editor-placed static objects
 * and cargo containers that are large enough to be tactically
 * relevant. Objects can opt in/out via object variables.
 *
 * Originally by Mallen [FNF], modified by Bae [29th ID].
 * https://github.com/FridayNightFight/FNF (BSD-3-Clause)
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 */

// Base classes whose subtypes are candidates for marking.
private _baseClasses = ["Static", "Cargo_base_F"];

/* --- Filter: is this object worth marking? --- */

private _canMark =
{
    params ["_obj"];

    // Force-included objects skip all other checks.
    if (_obj getVariable
        ["DOTT_autoMarkForceInclude", false]) exitWith
    {
        true;
    };

    private _classBlacklist = [
        "Land_DataTerminal_01_F",
        "Wreck_Base",
        "FlagCarrierCore",
        "Base_CUP_Plant"
    ];

    // Explicitly excluded by mission maker.
    if (_obj getVariable
        ["DOTT_autoMarkExclude", false]) exitWith
    {
        false;
    };

    // BUG FIX: was using _x (forEach magic var)
    // instead of _obj for the bounding sphere check.
    private _size = (boundingBox _obj) select 2;

    _size > 1.5
    && {
        {
            if (_obj isKindOf _x) exitWith { false };
            true
        } forEach _classBlacklist
    }
};

/* --- Collect qualifying objects --- */

private _objectsToMark = [];

{
    _objectsToMark append allMissionObjects _x;
} forEach _baseClasses;

_objectsToMark =
    _objectsToMark select { _x call _canMark };

/* --- Create a rectangle marker matching each object --- */

private _createMarker =
{
    params ["_obj", "_markerNum"];

    private _marker = createMarkerLocal [
        "DOTT_ObjectMarker" + str _markerNum,
        _obj
    ];

    _marker setMarkerShapeLocal "Rectangle";
    _marker setMarkerBrushLocal "SolidFull";
    _marker setMarkerColorLocal "ColorBlack";
    _marker setMarkerDirLocal getDir _obj;

    // Size marker to the object's real bounding box.
    private _bbr = boundingBoxReal _obj;
    private _p1 = _bbr select 0;
    private _p2 = _bbr select 1;
    private _maxWidth =
        abs ((_p2 select 0) - (_p1 select 0));
    private _maxLength =
        abs ((_p2 select 1) - (_p1 select 1));

    _marker setMarkerSizeLocal [
        _maxWidth / 2,
        _maxLength / 2
    ];
};

/* --- Apply markers --- */

private _markerNum = 0;

{
    [_x, _markerNum] call _createMarker;
    _markerNum = _markerNum + 1;
} forEach _objectsToMark;
