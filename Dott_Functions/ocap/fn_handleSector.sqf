/**
 * DOTT_ocap_fnc_handleSector
 *
 * Purpose:
 *   Attaches OCAP tracking to a sector module. Logs ownership
 *   changes as custom events and keeps area/icon markers in sync
 *   when the sector moves or resizes. Also cleans up markers on
 *   module deletion.
 *
 * Parameter(s):
 *   0: OBJECT - Sector logic module (ModuleSector_F)
 *
 * Returns: Nothing
 */

params ["_logic"];

// --- Log ownership changes and update marker colors --- //
[_logic, "ownerChanged",
{
    params ["_sector", "_owner", "_ownerOld"];

    private _sectorName =
        _sector getVariable ["name", "sector"];
    private _ownerName = _owner call BIS_fnc_sideName;

    ["ocap_customEvent",
        ["generalEvent",
        format ["%1 captured by %2",
            _sectorName, _ownerName]]]
        call CBA_fnc_serverEvent;

    [_sector, _owner] call DOTT_ocap_fnc_createSectorMarkers;
}] call BIS_fnc_addScriptedEventHandler;

// --- Poll for position/size changes until finalized --- //
[_logic] spawn
{
    params ["_logic"];

    // Brief pause so the module's owner/name vars are set.
    sleep 0.5;

    // The `sleep 3` inside waitUntil's condition keeps the
    // polling rate low, reducing per-frame overhead while
    // still catching moves/resizes within a few seconds.
    while
    {
        sleep 3;
        !((_logic getVariable ["finalized", false])
            || (isNull _logic))
    } do
    {
        private _areas =
            _logic getVariable ["areas", []];
        private _areaMarkers =
            _logic getVariable ["DOTT_areaMarkers", []];

        // Count mismatch can happen transiently due to
        // delayed marker deletion; skip this cycle.
        if (count _areas != count _areaMarkers) then
        {
            continue;
        };

        private _moved = false;

        // Check if any trigger area has relocated.
        {
            private _trigger = _x;
            private _triggerPos = position _trigger;
            private _marker =
                _areaMarkers select _forEachIndex;

            if (_triggerPos distance2D
                (getMarkerPos _marker) > 1) then
            {
                _marker setMarkerPosLocal _triggerPos;
                _moved = true;
            };
        } forEach _areas;

        if (_moved) then
        {
            private _markerIconText =
                _logic getVariable
                    ["DOTT_nameMarker", ""];
            _markerIconText setMarkerPosLocal
                position _logic;
        };

        // Check if any trigger area has resized.
        {
            private _trigger = _x;
            private _triggerArea =
                (triggerArea _trigger) select [0, 2];
            private _marker =
                _areaMarkers select _forEachIndex;
            private _markerArea =
                (getMarkerSize _marker) select [0, 2];

            if (_triggerArea isNotEqualTo _markerArea)
                exitWith
            {
                private _owner = _logic getVariable
                    ["owner", sideUnknown];
                [_logic, _owner] call
                    DOTT_ocap_fnc_createSectorMarkers;
            };
        } forEach _areas;
    };
};

// --- Clean up markers when the module is deleted --- //
_logic addEventHandler ["Deleted",
{
    params ["_entity"];

    private _areaMarkers =
        _entity getVariable ["DOTT_areaMarkers", []];

    {
        deleteMarkerLocal _x;
    } forEach _areaMarkers;

    deleteMarkerLocal
        (_entity getVariable ["DOTT_nameMarker", ""]);
}];
