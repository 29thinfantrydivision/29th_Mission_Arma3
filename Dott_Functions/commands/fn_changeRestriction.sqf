/*
 * Name:	DOTT_commands_fnc_changeRestriction
 * Date:	12/24/2025
 * Version: 1.2
 * Author:  Bae [29th ID]
 *
 * Description:
 * Removes a chat command from the DOTT command system.
 *
 * Parameter(s): 
 * _name - String - The name of the command (without the leading marker) 
 * _newRestrictionLevel - Number - The new restriction level for the command. 0 for none, 1 for restricted, 2 for admin only.
 *
 * Returns:
 * Nothing
 *
 * Example:
 * ["arsenal"] call DOTT_commands_fnc_changeRestriction;
 * 
 */

params ["_name", "_newRestrictionLevel"];

if (isNil "DOTT_commands_finishedInit") exitWith
{
	[
		"DOTT_commands_initCompleted",
		{ _thisArgs call DOTT_commands_fnc_changeRestriction },
		_this
	]
	call CBA_fnc_addEventHandlerArgs;
};

pvpfw_chatIntercept_noLogCommands = pvpfw_chatIntercept_noLogCommands - [_name];
pvpfw_chatIntercept_restrictedCommands = pvpfw_chatIntercept_restrictedCommands - [_name];
pvpfw_chatIntercept_adminCommands = pvpfw_chatIntercept_adminCommands - [_name];

switch (_newRestrictionLevel) do
{
	case 0: {
		// No restriction
	};
	case 1: {
		// Restricted
		pvpfw_chatIntercept_restrictedCommands pushBack _name;
	};
	case 2: {
		// Admin only
		pvpfw_chatIntercept_adminCommands pushBack _name;
	};
};

nil