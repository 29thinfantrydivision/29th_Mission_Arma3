/*
 * Name:	DOTT_commands_fnc_remove
 * Date:	12/24/2025
 * Version: 1.2
 * Author:  Bae [29th ID]
 *
 * Description:
 * Removes a chat command from the DOTT command system.
 *
 * Parameter(s): 
 * _name - String - The name of the command (without the leading marker) 
 *
 * Returns:
 * Nothing
 *
 * Example:
 * ["arsenal"] call DOTT_commands_fnc_remove;
 * 
 */

params ["_name"];

pvpfw_chatIntercept_noLogCommands = pvpfw_chatIntercept_noLogCommands - [_name];
pvpfw_chatIntercept_restrictedCommands = pvpfw_chatIntercept_restrictedCommands - [_name];
pvpfw_chatIntercept_adminCommands = pvpfw_chatIntercept_adminCommands - [_name];

pvpfw_chatIntercept_allCommands deleteAt _name;
