params ["_control"];

private _display = ctrlParent _control;

private _ctrlGeneralGroup = _display displayCtrl 2300;
private _ctrlColorsGroup = _display displayCtrl 2301;
private _ctrlDifficultyGroup = _display displayCtrl 2302;
private _ctrlPresetsButton = _display displayCtrl 114;
private _ctrlDefaultButton = _display displayCtrl 101;
private _ctrlDifficultyButton = _display displayCtrl 304;
private _ctrlGeneralButton = _display displayCtrl 2402;
private _ctrlGUIButton = _display displayCtrl 2404;
private _ctrlLayoutButton = _display displayCtrl 2405;
private _ctrlButtonOK = _display displayCtrl 1;

private _ctrlAddonsGroup = _display displayCtrl 4301;
private _ctrlServerButton = _display displayCtrl 9003;
private _ctrlMissionButton = _display displayCtrl 9002;
private _ctrlClientButton = _display displayCtrl 9001;
private _ctrlButtonImport = _display displayCtrl 9010;
private _ctrlButtonExport = _display displayCtrl 9011;
private _ctrlButtonSave = _display displayCtrl 9020;
private _ctrlButtonLoad = _display displayCtrl 9021;
private _ctrlToggleButton = _display displayCtrl 4302;

_ctrlGeneralGroup ctrlEnable false;
_ctrlGeneralGroup ctrlShow false;
_ctrlColorsGroup ctrlEnable false;
_ctrlColorsGroup ctrlShow false;
_ctrlDifficultyGroup ctrlEnable false;
_ctrlDifficultyGroup ctrlShow false;
_ctrlPresetsButton ctrlEnable false;
_ctrlPresetsButton ctrlShow false;
_ctrlDefaultButton ctrlEnable false;
_ctrlDefaultButton ctrlShow false;
_ctrlDifficultyButton ctrlEnable false;
_ctrlDifficultyButton ctrlShow false;
_ctrlGeneralButton ctrlEnable false;
_ctrlGeneralButton ctrlShow false;
_ctrlGUIButton ctrlEnable false;
_ctrlGUIButton ctrlShow false;
_ctrlLayoutButton ctrlEnable false;
_ctrlLayoutButton ctrlShow false;
_ctrlButtonOK ctrlEnable false;
_ctrlButtonOK ctrlShow false;


_ctrlAddonsGroup ctrlEnable true;
_ctrlAddonsGroup ctrlShow true;
_ctrlServerButton ctrlEnable false;
_ctrlServerButton ctrlShow false;
_ctrlMissionButton ctrlEnable false;
_ctrlMissionButton ctrlShow false;
_ctrlClientButton ctrlEnable false;
_ctrlClientButton ctrlShow false;
_ctrlButtonImport ctrlEnable false;
_ctrlButtonImport ctrlShow false;
_ctrlButtonExport ctrlEnable false;
_ctrlButtonExport ctrlShow false;
_ctrlButtonSave ctrlEnable false;
_ctrlButtonSave ctrlShow false;
_ctrlButtonLoad ctrlEnable false;
_ctrlButtonLoad ctrlShow false;

private _previousSelectedSource = "server";

private _ctrlPreviousButton = [_ctrlServerButton, _ctrlMissionButton, _ctrlClientButton] param [
	["server", "mission", "client"] find _previousSelectedSource,
	_ctrlServerButton
];

_ctrlPreviousButton call DOTT_settings_fnc_gui_sourceChanged;