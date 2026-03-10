/**
 * fn_gui_addonChanged.sqf
 * Fired when the user selects a different addon/category in
 * the sidebar listbox.  Lazily builds every setting row for
 * that category (checkbox / list / slider / time) the first
 * time it is viewed, then toggles panel visibility.
 *
 * Params:
 *   _control - the addon listbox control
 *   _index   - selected listbox index
 * Return: none
 */

#define SERVER_TEMP \
    (uiNamespace getVariable "DOTT_settings_serverTemp")

params ["_control", "_index"];

private _display = ctrlParent _control;
private _selectedAddon =
    _display getVariable (_control lbData _index);

if (isNil "_selectedAddon") exitWith {};

if (_selectedAddon isEqualType "") then
{
    uiNamespace setVariable [
        "DOTT_settings_addon", _selectedAddon
    ];
};

uiNamespace setVariable [
    "DOTT_settings_addonIndex", _index
];

private _selectedSource = "server";

// --- Build rows on first visit for this addon ---
if !(_display getVariable [_selectedAddon, false]) then
{
    // Helper: position a control at the next table row.
    private _fnc_controlSetTablePosY =
    {
        params [
            "_control", "_tablePosY", "_height"
        ];

        private _config =
            configFile >> ctrlClassName _control;
        if (isNull _config) then
        {
            _config =
                missionConfigFile
                >> ctrlClassName _control;
        };

        private _posX =
            getNumber (_config >> "x");
        private _posY =
            getNumber (_config >> "y") + _tablePosY;
        private _width =
            getNumber (_config >> "w");

        if (isNil "_height") then
        {
            _height = getNumber (_config >> "h");
        };

        _control ctrlSetPosition [
            _posX, _posY, _width, _height
        ];
        _control ctrlCommit 0;

        _posY + _height
    };

    private _lists =
        _display getVariable "cba_settings_lists";

    // Gather and sort settings for this category.
    private _categorySettings = [];

    {
        (DOTT_settings_default getVariable _x) params [
            "", "_setting", "", "",
            "_category", "", "", "", "",
            "_subCategory"
        ];

        if (toLower _category == _selectedAddon) then
        {
            if (isLocalized _subCategory) then
            {
                _subCategory = localize _subCategory;
            };

            _categorySettings pushBack [
                parseNumber (_subCategory != ""),
                _subCategory,
                _forEachIndex,
                _setting
            ];
        };
    } forEach DOTT_settings_allSettings;

    _categorySettings sort true;
    private _lastSubCategory = "$START";

    // --- Build each setting row ---
    {
        _x params [
            "", "_subCategory", "", "_setting"
        ];

        private _createHeader = false;
        if (_subCategory != _lastSubCategory) then
        {
            _lastSubCategory = _subCategory;
            if (_subCategory == "") exitWith {};
            _createHeader = true;
        };

        (DOTT_settings_default getVariable _setting)
            params [
                "_defaultValue", "",
                "_settingType", "_settingData",
                "_category", "_displayName",
                "_tooltip", "_isGlobal"
            ];

        if (isLocalized _displayName) then
        {
            _displayName = localize _displayName;
        };

        if (isLocalized _tooltip) then
        {
            _tooltip = localize _tooltip;
        };

        // Append the raw setting name to the tooltip.
        if (_tooltip != _setting) then
        {
            if (_tooltip isEqualTo "") then
            {
                _tooltip = _setting;
            }
            else
            {
                _tooltip = format [
                    "%1\n%2", _tooltip, _setting
                ];
            };
        };

        private _settingControlsGroups = [];

        {
            private _source = toLower _x;

            private _currentValue =
                SERVER_TEMP getVariable [
                    _setting, [nil, nil]
                ] select 0;
            private _wasEdited = false;

            if (isNil "_currentValue") then
            {
                _currentValue = [_setting, _source]
                    call cba_settings_fnc_get;
            }
            else
            {
                _wasEdited = true;
            };

            private _list = [
                "DOTT_settings_list",
                toLower _category,
                _source
            ] joinString "$";

            private _ctrlOptionsGroup = controlNull;

            if !(_list in _lists) then
            {
                _ctrlOptionsGroup = _display ctrlCreate [
                    "cba_settings_OptionsGroup",
                    -1,
                    _display displayCtrl 4301
                ];
                _ctrlOptionsGroup ctrlEnable false;
                _ctrlOptionsGroup ctrlShow false;

                _lists pushBack _list;
                _display setVariable [
                    _list, _ctrlOptionsGroup
                ];
            }
            else
            {
                _ctrlOptionsGroup =
                    _display getVariable _list;
            };

            // Sub-category header row.
            if (_createHeader) then
            {
                private _ctrlHeaderGroup =
                    _display ctrlCreate [
                        "cba_settings_subCat",
                        -1,
                        _ctrlOptionsGroup
                    ];
                private _ctrlHeaderName =
                    _ctrlHeaderGroup
                    controlsGroupCtrl 5010;
                _ctrlHeaderName ctrlSetText format [
                    "%1:", _subCategory
                ];

                private _halfRow =
                    ((0.4)
                    * ((((safeZoneW / safeZoneH)
                        min 1.2) / 1.2) / 25))
                    / 2;
                private _tablePosY =
                    _ctrlOptionsGroup getVariable [
                        "cba_settings_tablePosY",
                        _halfRow
                    ];
                _tablePosY = [
                    _ctrlHeaderGroup, _tablePosY
                ] call _fnc_controlSetTablePosY;
                _ctrlOptionsGroup setVariable [
                    "cba_settings_tablePosY",
                    _tablePosY
                ];
            };

            // Create the type-specific row control.
            private _ctrlSettingGroup =
                switch (toUpper _settingType) do
                {
                    case "CHECKBOX":
                    {
                        _display ctrlCreate [
                            "DOTT_settings_Row_Checkbox",
                            5000,
                            _ctrlOptionsGroup
                        ]
                    };
                    case "LIST":
                    {
                        _display ctrlCreate [
                            "DOTT_settings_Row_List",
                            5000,
                            _ctrlOptionsGroup
                        ]
                    };
                    case "SLIDER":
                    {
                        _display ctrlCreate [
                            "DOTT_settings_Row_Slider",
                            5000,
                            _ctrlOptionsGroup
                        ]
                    };
                    case "TIME":
                    {
                        _display ctrlCreate [
                            "DOTT_settings_Row_Time",
                            5000,
                            _ctrlOptionsGroup
                        ]
                    };
                    default {controlNull};
                };

            // Default-value tooltip per type.
            private _defaultValueTooltip =
                switch (toUpper _settingType) do
                {
                    case "LIST":
                    {
                        _settingData params [
                            "_values", "_labels"
                        ];
                        private _label = _labels param [
                            _values find _defaultValue, ""
                        ];
                        if (isLocalized _label) then
                        {
                            _label = localize _label;
                        };
                        _label
                    };
                    case "SLIDER":
                    {
                        if (_settingData param [
                            3, false
                        ]) then
                        {
                            format [
                                localize
                                    "STR_3DEN_percentageUnit",
                                round (_defaultValue * 100),
                                "%"
                            ]
                        }
                        else
                        {
                            _defaultValue
                        };
                    };
                    case "TIME":
                    {
                        _defaultValue
                            call CBA_fnc_formatElapsedTime
                    };
                    default {_defaultValue};
                };

            // Wire up the default-reset button tooltip.
            private _ctrlDefault =
                _ctrlSettingGroup
                controlsGroupCtrl 5020;
            _ctrlDefault ctrlSetTooltip (format [
                "%1\n%2",
                localize
                    "STR_cba_settings_default_tooltip",
                _defaultValueTooltip
            ]);

            _ctrlSettingGroup setVariable [
                "cba_settings_setting", _setting
            ];
            _ctrlSettingGroup setVariable [
                "cba_settings_source", _source
            ];
            _ctrlSettingGroup setVariable [
                "cba_settings_params", _settingData
            ];
            _ctrlSettingGroup setVariable [
                "cba_settings_groups",
                _settingControlsGroups
            ];
            _settingControlsGroups
                pushBack _ctrlSettingGroup;

            // Position the row in the table.
            private _halfRow =
                ((0.4)
                * ((((safeZoneW / safeZoneH)
                    min 1.2) / 1.2) / 25))
                / 2;
            private _tablePosY =
                _ctrlOptionsGroup getVariable [
                    "cba_settings_tablePosY",
                    _halfRow
                ];
            _tablePosY = [
                _ctrlSettingGroup, _tablePosY
            ] call _fnc_controlSetTablePosY;
            _ctrlOptionsGroup setVariable [
                "cba_settings_tablePosY", _tablePosY
            ];

            // List rows need extra vertical space.
            if (_settingType == "LIST") then
            {
                private _ctrlEmpty =
                    _display ctrlCreate [
                        "cba_settings_Row_Empty",
                        -1,
                        _ctrlOptionsGroup
                    ];
                private _rowUnit =
                    (((safeZoneW / safeZoneH)
                    min 1.2) / 1.2) / 25;
                private _height =
                    (count (_settingData select 0))
                    * _rowUnit + 0.4 * _rowUnit;
                [_ctrlEmpty, _tablePosY, _height]
                    call _fnc_controlSetTablePosY;
            };

            // Label + tooltip for the setting name.
            private _ctrlSettingName =
                _ctrlSettingGroup
                controlsGroupCtrl 5010;
            _ctrlSettingName ctrlSetText format [
                "%1:", _displayName
            ];
            _ctrlSettingName ctrlSetTooltip _tooltip;

            // Yellow highlight if the user already
            // edited this setting earlier.
            if (_wasEdited) then
            {
                _ctrlSettingName ctrlSetTextColor [
                    0.95, 0.95, 0.1, 1
                ];
            };

            // Invoke the type-specific init script.
            private _script = getText (
                configFile
                >> ctrlClassName _ctrlSettingGroup
                >> "cba_settings_script"
            );
            if (_script == "") then
            {
                _script = getText (
                    missionConfigFile
                    >> ctrlClassName _ctrlSettingGroup
                    >> "cba_settings_script"
                );
            };
            [
                _ctrlSettingGroup, _setting,
                _source, _currentValue, _settingData
            ] call (uiNamespace getVariable _script);

            // Wire up the default-reset button.
            [
                _ctrlSettingGroup, _setting,
                _source, _currentValue, _defaultValue
            ] call DOTT_settings_fnc_gui_settingDefault;
        } forEach ["server"];
    } forEach _categorySettings;

    _display setVariable [_selectedAddon, true];
};

// --- Toggle panel visibility ---
{
    (_x splitString "$") params [
        "", "_addon", "_source"
    ];

    private _ctrlOptionsGroup =
        _display getVariable _x;
    private _isSelected =
        _source == _selectedSource
        && {_addon == _selectedAddon};

    _ctrlOptionsGroup ctrlEnable _isSelected;
    _ctrlOptionsGroup ctrlShow _isSelected;
} forEach (_display getVariable "cba_settings_lists");
