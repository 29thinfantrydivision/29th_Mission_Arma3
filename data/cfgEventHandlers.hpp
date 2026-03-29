#include "..\script_macros.hpp"

class Extended_PreInit_EventHandlers
{
    class TN_MissionSettings
    {
        init = "call compile preprocessFileLineNumbers ""XEH_preInit.sqf""";
    };
};

class Extended_DisplayLoad_EventHandlers
{
    class RscDisplayCurator
    {
        TN_round = '[QEGVAR(curator,entered), []] call CBA_fnc_localEvent';
    };
};

class Extended_DisplayUnload_EventHandlers
{
    class RscDisplayCurator
    {
        TN_round = '[QEGVAR(curator,exited), []] call CBA_fnc_localEvent';
    };

    class RscDisplayMPInterrupt
    {
        TN = '[QEGVAR(common,exitedPauseMenu), []] call CBA_fnc_localEvent';
    };
};
