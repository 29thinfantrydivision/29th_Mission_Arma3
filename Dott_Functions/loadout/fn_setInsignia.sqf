/**
 * DOTT_loadout_fnc_setInsignia
 *
 * Purpose: If a unit has a valid 29th squad.xml configuration, applies
 *          the appropriate insignia to their uniform. HQ members get
 *          the non-drab/non-combat variant when not in a combat loadout.
 *
 * Params:  _target - Object, local unit wearing a uniform
 * Returns: true if insignia was applied, false otherwise
 *
 * Example: player spawn DOTT_loadout_fnc_setInsignia
 */

if !(TN_setInsignia) exitWith { false };

// === Insignia Map ===
// Second element (when present) is the non-combat color variant.
private _insigniaMap = createHashMapFromArray [
    ["1st Bn. HQ",     ["BnHQ"]],
    ["Charlie Co. HQ", ["CoHQdrab", "CoHQ"]],
    ["CP1 HQ",         ["CP1drab", "CP1"]],
    ["CP2 HQ",         ["CP2drab", "CP2"]],
    ["CP1S1",          ["CP1S1"]],
    ["CP1S2",          ["CP1S2", "CP1S2colour"]],
    ["CP1S3",          ["CP1S3"]],
    ["CP2S1",          ["CP2S1"]],
    ["CP2S2",          ["CP2S2drab", "CP2S2"]],
    ["CP2S3",          ["CP2S3"]]
];

params [["_target", objNull, [objNull]]];

if (isNull _target) exitWith
{
    ["Invalid parameters."] call BIS_fnc_error;
    false;
};

if (!local _target) exitWith
{
    ["%1 must be local.", _target] call BIS_fnc_error;
    false;
};

if (!isClass (configFile >> "CfgPatches" >> "29th_Insignias")) exitWith
{
    false;
};

waitUntil { sleep 0.5; !isNull _target && alive _target };

private _sqdParams = squadParams _target;

if (count _sqdParams == 0) exitWith
{
    false;
};

// --- Resolve target insignia ---
// Squad string is stored in the memberICQ field of squad.xml.
private _targetSquad = (_sqdParams select 1) select 4;
private _foundInsignias =
    _insigniaMap getOrDefault [_targetSquad, []];

if (count _foundInsignias == 0) exitWith
{
    false;
};

// Default to the combat / only variant.
private _targetInsignia = _foundInsignias select 0;

// Switch to non-combat variant if one exists and loadout qualifies.
if (count _foundInsignias == 2) then
{
    private _isNotCombatLoadout =
        _target call DOTT_parade_fnc_checkNonCombatLoadout;

    if (_isNotCombatLoadout) then
    {
        _targetInsignia = _foundInsignias select 1;
    };
};

private _curInsignia = _target call BIS_fnc_getUnitInsignia;

// --- Clerk / Sniper exception ---
// Don't replace an existing insignia for these roles so they can
// keep their personal squad insignia.
private _targetRole = (_sqdParams select 1) select 5;

if (_targetRole find "Clerk" != -1
    || _targetRole find "Sniper" != -1) then
{
    if (_curInsignia != "") exitWith {};
};

if (_curInsignia != _targetInsignia && _curInsignia != "") then
{
    systemChat ("Insignia swapped to " + _targetInsignia + ".");
};

// Clear then set to force a refresh.
[_target, ""] call BIS_fnc_setUnitInsignia;
[_target, _targetInsignia] call BIS_fnc_setUnitInsignia;
