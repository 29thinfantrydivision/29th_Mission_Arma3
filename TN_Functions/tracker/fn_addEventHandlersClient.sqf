/*
 * Author: Bae [29th ID]
 * Adds client-side event handlers for the tracker system.
 * Attaches instigator/weapon info to projectiles on fire,
 * propagates that info through submunitions, and handles
 * non-projectile damage sources (roadkill, fire, explosions).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 */

player addEventHandler ["FiredMan",
    { call TN_tracker_fnc_handleFired }];

["ace_advanced_throwing_throwFiredXEH",
{
    if (!local (_this select 0)) exitWith {};
    call TN_tracker_fnc_handleFired;
}] call CBA_fnc_addEventHandler;

["ace_explosives_place",
    { call TN_tracker_fnc_handleExplosivePlace }] call CBA_fnc_addEventHandler;

TN_tracker_lastFireCheck = 0;

// Easiest way to detect roadkill event.
// Will arrive on server later than projectile hit events
// however.
["ace_medical_woundReceived",
    { call TN_tracker_fnc_handleWoundReceived }] call CBA_fnc_addEventHandler;

["ace_fire_burnSimulation",
// We broadcast these variables since burning bodies can
// set people on fire and we need to track that too.
    { call TN_tracker_fnc_handleBurnSimulation }] call CBA_fnc_addEventHandler;

addMissionEventHandler ["EntityKilled",
    { call TN_tracker_fnc_handleVehicleKilled }];

player addEventHandler ["Respawn",
{
    params ["_unit"];
    _unit setVariable ["TN_burnInstigator", nil];
    _unit setVariable ["TN_burnInstigatorTime", nil];
    _unit setVariable ["TN_burnWeapon", nil];
}];

nil
