#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Adds chat commands to the chat command system. Meant for modules to call on init.
 *
 * Arguments:
 * 0: Command definitions to add (see commands.sqf for format) <ARRAY>
 * 1: Help info definitions to add (see commands.sqf for format) <ARRAY>
 * 2: Level of notification to send to admin (see commands.sqf for format) <ARRAY>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_commands_fnc_addModule;
 */

if (isNil QGVAR(allCommands)) exitWith { false };

params [["_commands", [], [[]]], ["_helpInfo", [], [[]]], ["_adminNotificationLevel", [], [[]]]];

GVAR(allCommands) append _commands;
GVAR(helpInfo) append _helpInfo;
GVAR(adminNotificationLevel) append _adminNotificationLevel;

nil
