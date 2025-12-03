params ["_display"];
uiNamespace setVariable ["cba_settings_display", _display];

private _ctrlAddonsGroup = _display displayCtrl 4301;
private _ctrlServerButton = _display displayCtrl 9003;
private _ctrlMissionButton = _display displayCtrl 9002;
private _ctrlClientButton = _display displayCtrl 9001;


{
    _x ctrlEnable false;
    _x ctrlShow false;
} forEach [_ctrlAddonsGroup, _ctrlServerButton, _ctrlMissionButton, _ctrlClientButton];

with uiNamespace do {
    cba_settings_clientTemp  = _display ctrlCreate ["RscText", -1];
    cba_settings_missionTemp = _display ctrlCreate ["RscText", -1];
    cba_settings_serverTemp  = _display ctrlCreate ["RscText", -1];
};

private _ctrlAddonList = _display ctrlCreate ["cba_settings_AddonsList", -1, _ctrlAddonsGroup];

_ctrlAddonList ctrlAddEventHandler ["LBSelChanged", {_this call cba_settings_fnc_gui_addonChanged}];

_display setVariable ["cba_settings_lists",[]];


private _categories = [];
{
    (cba_settings_default getVariable _x) params ["", "", "", "", "_category"];
    private _categoryLower = toLower _category;

    if !(_categoryLower in _categories) then {
        private _categoryLocalized = _category;
        if (isLocalized _category) then {
            _categoryLocalized = localize _category;
        };

        private _index = _ctrlAddonList lbAdd _categoryLocalized;
        _ctrlAddonList lbSetData [_index, str _index];
        _display setVariable [str _index, _categoryLower];

        _categories pushBack _categoryLower;
    };
} forEach cba_settings_allSettings;

lbSort _ctrlAddonList;
_ctrlAddonList lbSetCurSel (uiNamespace getVariable ["cba_settings_addonIndex", 0]);

/*
private _ctrlButtonSave = _display ctrlCreate ["RscButtonMenu", 9020];

_ctrlButtonSave ctrlSetPosition [
    ((1.5) * (((safeZoneW / safeZoneH) min 1.2) / 40) + (safeZoneX + (safeZoneW - ((safeZoneW / safeZoneH) min 1.2))/2)),
    ((20.5) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) + (safeZoneY + (safeZoneH - (((safeZoneW / safeZoneH) min 1.2) / 1.2))/2)),
    ((6) * (((safeZoneW / safeZoneH) min 1.2) / 40)),
    ((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))
];

_ctrlButtonSave ctrlCommit 0;
_ctrlButtonSave ctrlSetText localize "STR_DISP_INT_SAVE";
_ctrlButtonSave ctrlSetTooltip localize "STR_cba_settings_ButtonSave_tooltip";
_ctrlButtonSave ctrlEnable false;
_ctrlButtonSave ctrlShow false;
_ctrlButtonSave ctrlAddEventHandler ["ButtonClick", {[ctrlParent (_this select 0), "save"] call cba_settings_fnc_gui_preset}];

private _ctrlButtonLoad = _display ctrlCreate ["RscButtonMenu", 9021];

_ctrlButtonLoad ctrlSetPosition [
    ((7.6) * (((safeZoneW / safeZoneH) min 1.2) / 40) + (safeZoneX + (safeZoneW - ((safeZoneW / safeZoneH) min 1.2))/2)),
    ((20.5) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) + (safeZoneY + (safeZoneH - (((safeZoneW / safeZoneH) min 1.2) / 1.2))/2)),
    ((6) * (((safeZoneW / safeZoneH) min 1.2) / 40)),
    ((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))
];

_ctrlButtonLoad ctrlCommit 0;
_ctrlButtonLoad ctrlSetText localize "STR_DISP_INT_LOAD";
_ctrlButtonLoad ctrlSetTooltip localize "STR_cba_settings_ButtonLoad_tooltip";
_ctrlButtonLoad ctrlEnable false;
_ctrlButtonLoad ctrlShow false;
_ctrlButtonLoad ctrlAddEventHandler ["ButtonClick", {[ctrlParent (_this select 0), "load"] call cba_settings_fnc_gui_preset}];
*/
/*
private _ctrlButtonImport = _display ctrlCreate ["RscButtonMenu", 9010];

_ctrlButtonImport ctrlSetPosition [
    ((26.4) * (((safeZoneW / safeZoneH) min 1.2) / 40) + (safeZoneX + (safeZoneW - ((safeZoneW / safeZoneH) min 1.2))/2)),
    ((20.5) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) + (safeZoneY + (safeZoneH - (((safeZoneW / safeZoneH) min 1.2) / 1.2))/2)),
    ((6) * (((safeZoneW / safeZoneH) min 1.2) / 40)),
    ((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))
];

_ctrlButtonImport ctrlCommit 0;
_ctrlButtonImport ctrlSetText localize "STR_cba_settings_ButtonImport";
_ctrlButtonImport ctrlSetTooltip localize "STR_cba_settings_ButtonImport_tooltip";
_ctrlButtonImport ctrlEnable false;
_ctrlButtonImport ctrlShow false;
_ctrlButtonImport ctrlAddEventHandler ["ButtonClick", {
    [ctrlParent (_this select 0), "import"] call cba_settings_fnc_gui_export;
}];


private _ctrlButtonExport = _display ctrlCreate ["RscButtonMenu", 9011];

_ctrlButtonExport ctrlSetPosition [
    ((32.5) * (((safeZoneW / safeZoneH) min 1.2) / 40) + (safeZoneX + (safeZoneW - ((safeZoneW / safeZoneH) min 1.2))/2)),
    ((20.5) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) + (safeZoneY + (safeZoneH - (((safeZoneW / safeZoneH) min 1.2) / 1.2))/2)),
    ((6) * (((safeZoneW / safeZoneH) min 1.2) / 40)),
    ((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))
];

_ctrlButtonExport ctrlCommit 0;
_ctrlButtonExport ctrlSetText localize "STR_cba_settings_ButtonExport";
_ctrlButtonExport ctrlSetTooltip localize "STR_cba_settings_ButtonExport_tooltip";
_ctrlButtonExport ctrlEnable false;
_ctrlButtonExport ctrlShow false;
_ctrlButtonExport ctrlAddEventHandler ["ButtonClick", {
    [ctrlParent (_this select 0), "export"] call cba_settings_fnc_gui_export;
}];
*/

/*
{
    _x ctrlAddEventHandler ["ButtonClick", cba_settings_fnc_gui_sourceChanged];
} forEach [_ctrlServerButton, _ctrlMissionButton, _ctrlClientButton];
*/

//(_display displayCtrl 4302) ctrlAddEventHandler ["ButtonClick", {_this call cba_settings_fnc_gui_configure}];


(_display displayCtrl 999) ctrlAddEventHandler ["ButtonClick", {call cba_settings_fnc_gui_saveTempData}];
