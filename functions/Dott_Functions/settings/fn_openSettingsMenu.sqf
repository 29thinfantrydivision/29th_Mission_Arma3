params [["_display", findDisplay 46, [displayNull]]];

if (ctrlIDD _display in [37, 52, 53]) then {
    (_display displayCtrl 1001) lnbSetCurSelRow 0;
};

private _dlgSettings = _display createDisplay "RscDisplayGameOptions";

private _ctrlConfigureAddons = _dlgSettings displayCtrl 4302;
_ctrlConfigureAddons call DOTT_settings_fnc_gui_configure;

_ctrlConfigureAddons ctrlEnable false;
_ctrlConfigureAddons ctrlShow false;


private _ctrlScriptedOK = _dlgSettings displayCtrl 999;
_ctrlScriptedOK ctrlEnable false;
_ctrlScriptedOK ctrlShow false;

private _ctrlConfirm = _dlgSettings ctrlCreate ["RscButtonMenuOK", 2];
_ctrlConfirm ctrlSetPosition ctrlPosition _ctrlScriptedOK;
_ctrlConfirm ctrlCommit 0;
_ctrlConfirm ctrlAddEventHandler ["ButtonClick", {call cba_settings_fnc_gui_saveTempData}];

private _ctrlPlayersName = _dlgSettings displayCtrl 601;
_ctrlPlayersName ctrlEnable false;
_ctrlPlayersName ctrlShow false;

private _ctrlTitle = _dlgSettings displayCtrl 1000;
_ctrlTitle ctrlSetText "Mission Settings";

private _ctrlbackgroundShadow = _dlgSettings displayCtrl 114999;
_ctrlbackgroundShadow ctrlShow false;

private _overwriteClientText = _dlgSettings displayCtrl 9040;
_overwriteClientText ctrlSetText "";

private _overwriteMissionText = _dlgSettings displayCtrl 9041;
_overwriteMissionText ctrlSetText "";

private _volatileWarningText = _dlgSettings displayCtrl 9042;
_volatileWarningText ctrlSetText "Changes will not persist after mission restart";
_volatileWarningText ctrlSetToolTip "";