/**
 * cfgNotifications.hpp
 * Purpose: Notification class definitions for in-game HUD notifications.
 *          Included inside CfgNotifications in description.ext.
 * Params:  None (engine config)
 * Return:  None (engine config)
 */

class Default
{
    title = "";
    iconPicture = "";
    iconText = "";
    description = "";
    color[] = {1, 1, 1, 1};
    duration = 5;
    priority = 0;
    difficulty[] = {};
};

class General
{
    title = "%1";
    description = "%2";
    iconPicture = "\A3\ui_f\data\map\mapcontrol\taskIcon_ca.paa";
    color[] = {1, 0.81, 0.06, 1};
    duration = 4;
    priority = 1;
};

class TimeWarning
{
    title = "Time Warning";
    description = "%1";
    iconPicture = "\A3\Modules_F_Curator\Data\portraitCountdown_ca.paa";
    color[] = {1, 0.81, 0.06, 1};
    duration = 3;
    priority = 2;
};

class Reset
{
    title = "%1";
    description = "%2";
    iconPicture = "\A3\modules_f_curator\data\portraitrespawntickets_ca.paa";
    color[] = {1, 1, 1, 1};
    duration = 5;
    priority = 2;
};

class Document
{
    title = "%1";
    description = "%2";
    iconPicture = "\A3\ui_f\data\igui\cfg\simpletasks\types\documents_ca.paa";
    color[] = {1, 1, 1, 1};
    duration = 5;
    priority = 2;
};

class Health
{
    title = "%1";
    description = "%2";
    iconPicture = "\A3\characters_f\data\ui\icon_medic_ca.paa";
    color[] = {1, 1, 1, 1};
    duration = 5;
    priority = 2;
};

class FlagTaken
{
    title = "%1";
    description = "%2";
    iconPicture = "\CA\ui\data\markers\sc_marker_flagc_w_ca.paa";
    color[] = {1, 1, 1, 1};
    duration = 5;
    priority = 2;
};

class FlagCaptured
{
    title = "%1";
    description = "%2";
    iconPicture = "\CA\ui\data\markers\sc_marker_flag_w_ca.paa";
    color[] = {1, 1, 1, 1};
    duration = 5;
    priority = 2;
};

class FlagReturned
{
    title = "%1";
    description = "%2";
    iconPicture = "\A3\ui_f\data\igui\cfg\actions\returnflag_ca.paa";
    color[] = {1, 1, 1, 1};
    duration = 5;
    priority = 2;
};
