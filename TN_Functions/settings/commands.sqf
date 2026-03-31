#include "script_component.hpp"
[
    [
        [
            "s", {
                if !(isServer || IS_ADMIN_LOGGED) exitWith { systemChat "You must be logged in admin, not voted in." };
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
] call EFUNC(commands,addModule);
