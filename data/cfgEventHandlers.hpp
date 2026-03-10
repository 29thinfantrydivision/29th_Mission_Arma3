/**
 * cfgEventHandlers.hpp
 * Purpose: CBA Extended Event Handlers configuration.
 *          - PreInit: compiles XEH_preInit.sqf for module bootstrapping.
 *          - DisplayLoad/Unload: fires local CBA events for Zeus and
 *            pause menu transitions.
 * Params:  None (engine config)
 * Return:  None (engine config)
 */

class Extended_PreInit_EventHandlers
{
    class DOTT_MissionSettings
    {
        init = "call compile preprocessFileLineNumbers ""XEH_preInit.sqf""";
    };
};

class Extended_DisplayLoad_EventHandlers
{
    class RscDisplayCurator
    {
        DOTT_round = "[""DOTT_enteredZeus"", []] call CBA_fnc_localEvent";
    };
};

class Extended_DisplayUnload_EventHandlers
{
    class RscDisplayCurator
    {
        DOTT_round = "[""DOTT_exitedZeus"", []] call CBA_fnc_localEvent";
    };

    class RscDisplayMPInterrupt
    {
        DOTT = "[""DOTT_exitedPauseMenu"", []] call CBA_fnc_localEvent";
    };
};
