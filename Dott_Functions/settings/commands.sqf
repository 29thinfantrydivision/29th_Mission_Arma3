/**
 * commands.sqf
 * Registers the "S" key shortcut that opens the global
 * mission-settings dialog (RscDisplayMissionOptions).
 *
 * Params: none
 * Return: none (delegates to DOTT_commands_fnc_addModule)
 */

[
    [
        [
            "s",
            {
                createDialog [
                    "RscDisplayMissionOptions",
                    true
                ];
            }
        ]
    ],
    [
        ["s", "Opens the GUI for global mission settings."]
    ],
    [],
    [],
    ["s"]
] call DOTT_commands_fnc_addModule;
