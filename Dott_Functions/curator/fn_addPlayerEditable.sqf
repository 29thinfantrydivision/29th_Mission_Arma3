/*
 * Name:	DOTT_curator_fnc_addPlayerEditable
 * Date:	12/29/2025
 * Version: 1.0
 * Author:  Hill [29th ID]
 *
 * Description:
 * Adds the specified player as an editable object for all curators.
 *
 * Parameter(s): 
 * _unit: Player to add as editable object
 *
 * Returns:
 * n/a
 *
 * Example:
 * [player] remoteExec ["DOTT_curator_fnc_addPlayerEditable", 2];	
 */

params ["_unit"];

if (!(_unit isKindOf "HeadlessClient_F")) then 
{
	{
		_x addCuratorEditableObjects [[_unit], true];
	} forEach allCurators;
};