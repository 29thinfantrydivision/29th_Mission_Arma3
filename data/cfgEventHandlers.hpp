#include "..\script_macros.hpp"

class Extended_PreInit_EventHandlers {
    class TN_MissionSettings {
        init = "call compile preprocessFileLineNumbers ""XEH_preInit.sqf""";
    };
};

class Extended_DisplayLoad_EventHandlers {
    class RscDisplayCurator {
        onLoad = '[QGVARMAIN(enteredZeus), []] call CBA_fnc_localEvent';
    };
};

class Extended_DisplayUnload_EventHandlers {
    class RscDisplayCurator {
        onUnload = '[QGVARMAIN(exitedZeus), []] call CBA_fnc_localEvent';
    };

    class RscDisplayMPInterrupt {
        onUnload = '[QGVARMAIN(exitedPauseMenu), []] call CBA_fnc_localEvent';
    };
};
