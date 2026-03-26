/*
 * Author: Bae [29th ID]
 * Handles the ace_fire_burnSimulation event.
 * Broadcasts burn instigator variables since burning bodies
 * can set people on fire and we need to track that too.
 *
 * Arguments:
 * ace_fire_burnSimulation EH params
 *
 * Return Value:
 * Nothing
 */

#define COOKOFF_DISTANCE 10
#define INFANTRY_GRENADE_DISTANCE 5

params ["_unit", "_instigator"];
if (!alive _unit) exitWith {};

if (!isNull _instigator) then
{
    _unit setVariable ["TN_burnInstigator", _instigator, true];
    _unit setVariable ["TN_burnInstigatorTime", time];
    _unit setVariable ["TN_burnWeapon", "Fire", true];
}
else
{
    // Skip expensive spatial searches if we recently
    // cached who set this unit on fire.
    if (
        !isNull (_unit getVariable
            ["TN_burnInstigator", objNull])
        && {
            time - (_unit getVariable
                ["TN_burnInstigatorTime", -999])
            < 5
        }
    ) exitWith {};
    // Look for nearby ACE incendiary grenade (RHS one
    // doesn't set people on fire).
    private _grenades = (position _unit)
        nearObjects [
            "ACE_G_M14", INFANTRY_GRENADE_DISTANCE
        ];
    if (_grenades isNotEqualTo []) then
    {
        private _grenade = _grenades select 0;
        _unit setVariable [
            "TN_burnInstigator",
            (getShotParents _grenade) select 0,
            true
        ];
        _unit setVariable ["TN_burnInstigatorTime", time];
        _unit setVariable ["TN_burnWeapon", "ACE AN-M14", true];
    }
    else
    {
        // Look through cookoffs.
        {
            if (
                (_x select 0)
                    distance (getPosASL _unit)
                < COOKOFF_DISTANCE
            ) exitWith
            {
                _unit setVariable [
                    "TN_burnInstigator",
                    _x select 1, true
                ];
                _unit setVariable [
                    "TN_burnInstigatorTime", time
                ];
                _unit setVariable [
                    "TN_burnWeapon",
                    "Cookoff Fire", true
                ];
            };
        }
        forEach TN_tracker_cookOffs;

        // Look for nearby burning people.
        if (isNull _instigator) then
        {
            private _men = (position _unit) nearObjects ["Man", 5];
            {
                private _burnInstigator = _x getVariable ["TN_burnInstigator", objNull];
                if (!isNull _burnInstigator) exitWith
                {
                    private _burnWeapon = _x getVariable ["TN_burnWeapon", "Fire"];
                    _unit setVariable ["TN_burnInstigator", _burnInstigator, true];
                    _unit setVariable ["TN_burnInstigatorTime", time];
                    _unit setVariable ["TN_burnWeapon", _burnWeapon, true];
                };
            }
            forEach _men;
        };
    };
};

nil
