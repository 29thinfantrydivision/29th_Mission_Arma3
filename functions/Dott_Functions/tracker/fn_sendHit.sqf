/*
 * Name:	DOTT_tracker_fnc_sendHit
 * Date:	9/25/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Function to check server side that if player is alive before setting hit info, as 
 * sometimes player may be considered alive client side but dead server side due to latency.
 *
 * Parameter(s): 
 * _unit: Object to check alive state and set hit info on
 * _hitInfo: Information about the hit - see fn_addEventHandlersClient and fn_hit
 *
 * Returns:
 * Nothing
 *
 * Example:
 * [_hitEntity, _lastHit] remoteExecCall ["DOTT_tracker_fnc_sendHit", 2];
 * 
 */

params ["_unit", "_instigatorInfo"];
if !(alive _unit) exitWith {};

private _key = [_instigatorInfo select 0, _instigatorInfo select 1]; //name, side
private _value = [_instigatorInfo select 2, _instigatorInfo select 3, _instigatorInfo select 4]; //firing pos, weapon, time

private _hitMap = _unit getVariable ["DOTT_hitMap", createHashMap];
_hitMap set [_key, _value];

_unit setVariable ["DOTT_lastHit", _key];
_unit setVariable ["DOTT_hitMap", _hitMap];