#include "script_component.hpp"

/*
 * Author: Claude prompted by Bae [29th ID]
 * Opens a GUI dialog that lets an admin view and adjust
 * the lives of any connected player during a live round.
 *
 * Uses createDialog (TN_RscDisplaySafeStartTime, IDD 29141)
 * which overlays on display 46 — readyUI stays visible.
 *
 * Fires a fetchLivesData server event on open; the server
 * responds via livesDataResponse targeted event, which then
 * populates the player combo box.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_gui_adjustLives;
 */

#define IDD_ADJUST_LIVES   29141
#define IDC_AL_BG          6000
#define IDC_AL_TITLE       6001
#define IDC_AL_LABEL_SEL   6002
#define IDC_AL_COMBO       6003
#define IDC_AL_LABEL_LIVES 6004
#define IDC_AL_BTN_DEC     6005
#define IDC_AL_LIVES_EDIT  6006
#define IDC_AL_BTN_INC     6007
#define IDC_AL_STATUS      6008
#define IDC_AL_BTN_CANCEL  6009
#define IDC_AL_BTN_APPLY   6010
#define BG_ALPHA           0.82
#define DIK_ESCAPE         1

#define PANEL_W  0.38
#define PAD      0.012
#define ROW_H    0.033
#define GAP      0.008

#define W_LABEL  0.07
#define W_DEC    0.03
#define W_EDIT   0.06
#define W_INC    0.03

if !(isNull (findDisplay IDD_ADJUST_LIVES)) exitWith {};

createDialog "TN_RscDisplaySafeStartTime";
private _display = findDisplay IDD_ADJUST_LIVES;
if (isNull _display) exitWith {};

/* --- Layout constants --- */

private _innerW  = PANEL_W - PAD * 2;
private _hCancel = getNumber (configFile >> "RscButtonMenuCancel" >> "h");
private _wCancel = (_innerW - GAP) / 2;
private _wStatus = _innerW - W_LABEL - W_DEC - W_EDIT - W_INC - GAP * 3;
private _panelX  = 0.5 - PANEL_W / 2;
private _panelH  = PAD + ROW_H + GAP + ROW_H + GAP + ROW_H + GAP + _hCancel + PAD;
private _panelY  = 0.5 - _panelH / 2;

private _xDec    = _panelX + PAD + W_LABEL + GAP;
private _xEdit   = _xDec + W_DEC + GAP;
private _xInc    = _xEdit + W_EDIT + GAP;
private _xStatus = _xInc + W_INC + GAP;

/* --- Background --- */

private _bg = _display ctrlCreate ["RscText", IDC_AL_BG];
_bg ctrlSetPosition [_panelX, _panelY, PANEL_W, _panelH];
_bg ctrlSetBackgroundColor [0, 0, 0, BG_ALPHA];
_bg ctrlCommit 0;

/* --- Row 0: title --- */

private _yRow0 = _panelY + PAD;
private _title = _display ctrlCreate ["RscStructuredText", IDC_AL_TITLE];
_title ctrlSetPosition [_panelX + PAD, _yRow0 - GAP, _innerW, ROW_H + GAP];
_title ctrlSetStructuredText parseText
    "<t color='#bf3eff' align='center' size='1.1'>Adjust Player Lives</t>";
_title ctrlCommit 0;

/* --- Row 1: player selector --- */

private _yRow1 = _yRow0 + ROW_H + GAP;

private _lblSel = _display ctrlCreate ["RscText", IDC_AL_LABEL_SEL];
_lblSel ctrlSetPosition [_panelX + PAD, _yRow1, W_LABEL, ROW_H];
_lblSel ctrlSetText "Player:";
_lblSel ctrlCommit 0;

private _ctrlCombo = _display ctrlCreate ["RscCombo", IDC_AL_COMBO];
_ctrlCombo ctrlSetPosition [
    _xDec,
    _yRow1,
    _innerW - W_LABEL - GAP,
    ROW_H
];
_ctrlCombo ctrlEnable false;
_ctrlCombo ctrlCommit 0;

/* --- Row 2: lives adjuster --- */

private _yRow2 = _yRow1 + ROW_H + GAP;

private _lblLives = _display ctrlCreate ["RscText", IDC_AL_LABEL_LIVES];
_lblLives ctrlSetPosition [_panelX + PAD, _yRow2, W_LABEL, ROW_H];
_lblLives ctrlSetText "Lives:";
_lblLives ctrlCommit 0;

private _ctrlBtnDec = _display ctrlCreate ["RscButton", IDC_AL_BTN_DEC];
_ctrlBtnDec ctrlSetPosition [_xDec, _yRow2, W_DEC, ROW_H];
_ctrlBtnDec ctrlSetText "-";
_ctrlBtnDec ctrlEnable false;
_ctrlBtnDec ctrlCommit 0;

private _ctrlLivesEdit = _display ctrlCreate ["RscEdit", IDC_AL_LIVES_EDIT];
_ctrlLivesEdit ctrlSetPosition [_xEdit, _yRow2, W_EDIT, ROW_H];
_ctrlLivesEdit ctrlEnable false;
_ctrlLivesEdit ctrlCommit 0;

private _ctrlBtnInc = _display ctrlCreate ["RscButton", IDC_AL_BTN_INC];
_ctrlBtnInc ctrlSetPosition [_xInc, _yRow2, W_INC, ROW_H];
_ctrlBtnInc ctrlSetText "+";
_ctrlBtnInc ctrlEnable false;
_ctrlBtnInc ctrlCommit 0;

private _ctrlStatus = _display ctrlCreate ["RscText", IDC_AL_STATUS];
_ctrlStatus ctrlSetPosition [_xStatus, _yRow2, _wStatus, ROW_H];
_ctrlStatus ctrlSetText "Loading...";
_ctrlStatus ctrlCommit 0;

/* --- Row 3: buttons --- */

private _yRow3 = _yRow2 + ROW_H + GAP;

private _ctrlBtnCancel = _display ctrlCreate ["RscButtonMenuCancel", IDC_AL_BTN_CANCEL];
_ctrlBtnCancel ctrlSetPosition [_panelX + PAD, _yRow3, _wCancel, _hCancel];
_ctrlBtnCancel ctrlCommit 0;

private _ctrlBtnApply = _display ctrlCreate ["RscButtonMenuOK", IDC_AL_BTN_APPLY];
_ctrlBtnApply ctrlSetPosition [
    _panelX + PAD + _innerW - _wCancel,
    _yRow3,
    _wCancel,
    _hCancel
];
_ctrlBtnApply ctrlEnable false;
_ctrlBtnApply ctrlCommit 0;

/* --- Event handlers --- */

private _ehId = [QGVAR(livesDataResponse), {
    params ["_livesData"];
    private _display = findDisplay IDD_ADJUST_LIVES;
    if (isNull _display) exitWith {};

    private _ctrlCombo = _display displayCtrl IDC_AL_COMBO;
    private _ctrlStatus = _display displayCtrl IDC_AL_STATUS;
    lbClear _ctrlCombo;
    _livesData = [_livesData, [], { _x select 1 }, "ascend"] call BIS_fnc_sortBy;

    if (_livesData isEqualTo []) exitWith {
        _ctrlStatus ctrlSetText "No players connected.";
        _ctrlStatus ctrlCommit 0;
    };

    {
        _x params ["_uid", "_playerName", "_lives"];
        private _idx = _ctrlCombo lbAdd _playerName;
        _ctrlCombo lbSetData [_idx, _uid];
        _ctrlCombo lbSetValue [_idx, _lives];
    } forEach _livesData;

    _ctrlCombo lbSetCurSel 0;
    (_display displayCtrl IDC_AL_LIVES_EDIT)
        ctrlSetText (str (round (_ctrlCombo lbValue 0)));

    {
        _x ctrlEnable true;
        _x ctrlCommit 0;
    } forEach [
        _ctrlCombo,
        _display displayCtrl IDC_AL_LIVES_EDIT,
        _display displayCtrl IDC_AL_BTN_DEC,
        _display displayCtrl IDC_AL_BTN_INC,
        _display displayCtrl IDC_AL_BTN_APPLY
    ];

    _ctrlStatus ctrlSetText "";
    _ctrlStatus ctrlCommit 0;
}] call CBA_fnc_addEventHandler;

_display setVariable [QGVAR(adjustLives_responseEhId), _ehId];

_ctrlCombo ctrlAddEventHandler ["LBSelChanged", {
    params ["_ctrlCombo", "_idx"];
    if (_idx < 0) exitWith {};
    (ctrlParent _ctrlCombo) displayCtrl IDC_AL_LIVES_EDIT
        ctrlSetText (str (round (_ctrlCombo lbValue _idx)));
}];

_ctrlBtnDec ctrlAddEventHandler ["ButtonClick", {
    params ["_ctrl"];
    private _edit = (ctrlParent _ctrl) displayCtrl IDC_AL_LIVES_EDIT;
    private _val = ((parseNumber ctrlText _edit) - 1) max 0;
    _edit ctrlSetText (str _val);
}];

_ctrlBtnInc ctrlAddEventHandler ["ButtonClick", {
    params ["_ctrl"];
    private _edit = (ctrlParent _ctrl) displayCtrl IDC_AL_LIVES_EDIT;
    private _val = (parseNumber ctrlText _edit) + 1;
    _edit ctrlSetText (str _val);
}];


_ctrlBtnCancel ctrlAddEventHandler ["ButtonClick", {
    params ["_ctrl"];
    (ctrlParent _ctrl) closeDisplay 2;
}];

_ctrlBtnApply ctrlAddEventHandler ["ButtonClick", {
    params ["_ctrl"];
    private _display = ctrlParent _ctrl;
    private _ctrlCombo = _display displayCtrl IDC_AL_COMBO;
    private _ctrlEdit = _display displayCtrl IDC_AL_LIVES_EDIT;

    private _selIdx = lbCurSel _ctrlCombo;
    if (_selIdx < 0) exitWith {
        systemChat "Adjust Player Lives: no player selected.";
    };

    private _uid = _ctrlCombo lbData _selIdx;
    private _text = ctrlText _ctrlEdit;
    if !(_text regexMatch "^[0-9]+$") exitWith {
        systemChat "Adjust Player Lives: invalid lives value.";
    };
    private _newLives = (parseNumber _text) max 0;

    private _player = objNull;
    {
        if ((getPlayerUID _x) isEqualTo _uid) exitWith {
            _player = _x;
        };
    } forEach (call BIS_fnc_listPlayers);

    if (isNull _player) exitWith {
        systemChat "Adjust Player Lives: player disconnected.";
    };

    [_player, _newLives] call FUNC(adjustLives);
    _display closeDisplay 1;
}];

_display displayAddEventHandler ["KeyDown", {
    params ["_display", "_key"];
    if (_key isEqualTo DIK_ESCAPE) then {
        _display closeDisplay 2;
        true
    } else {
        false
    };
}];

_display displayAddEventHandler ["Unload", {
    params ["_display"];
    private _ehId = _display getVariable [
        QGVAR(adjustLives_responseEhId), nil
    ];
    if (!isNil "_ehId") then {
        [QGVAR(livesDataResponse), _ehId] call CBA_fnc_removeEventHandler;
    };
}];

[QGVAR(fetchLivesData), [player]] call CBA_fnc_serverEvent;

nil
