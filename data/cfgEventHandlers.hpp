class Extended_PreInit_EventHandlers {
    class TN_MissionSettings {
        init = "call compile preprocessFileLineNumbers ""XEH_preInit.sqf""";
    };
};

class Extended_DisplayLoad_EventHandlers {
    class RscDisplayCurator {
        onLoad = "[""TN_enteredZeus"", []] call CBA_fnc_localEvent";
    };
};

class Extended_DisplayUnload_EventHandlers {
    class RscDisplayCurator {
        onUnload = "[""TN_exitedZeus"", []] call CBA_fnc_localEvent";
    };

    class RscDisplayMPInterrupt {
        onUnload = "[""TN_exitedPauseMenu"", []] call CBA_fnc_localEvent";
    };
};
