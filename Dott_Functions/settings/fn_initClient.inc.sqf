/**
 * fn_initClient.inc.sqf
 * Lazy-compiles GUI helper scripts on the client the first
 * time the settings dialog is opened.  UI-thread functions
 * go into uiNamespace; logic functions into missionNamespace.
 * Included (not called) by fn_initDisplayMissionOptions.sqf.
 *
 * Params: none (relies on ambient scope)
 * Return: none
 */

// --- UI-thread widget scripts (uiNamespace) ---
{
    private _scriptName =
        format ["DOTT_settings_fnc_%1", _x];

    if (isNil {uiNamespace getVariable _scriptName}) then
    {
        private _filePath = format [
            "Dott_Functions\settings\gui\fn_%1.sqf", _x
        ];
        uiNamespace setVariable [
            _scriptName,
            compile preprocessFile _filePath
        ];
    };
}
forEach [
    "gui_settingCheckbox",
    "gui_settingSlider",
    "gui_settingList",
    "gui_settingTime"
];

// --- Logic / event scripts (missionNamespace) ---
{
    private _scriptName =
        format ["DOTT_settings_fnc_%1", _x];

    if (isNil {missionNamespace getVariable _scriptName}) then
    {
        private _filePath = format [
            "Dott_Functions\settings\gui\fn_%1.sqf", _x
        ];
        missionNamespace setVariable [
            _scriptName,
            compile preprocessFile _filePath
        ];
    };
}
forEach [
    "gui_settingDefault",
    "gui_sourceChanged",
    "gui_addonChanged",
    "gui_saveTempData"
];
