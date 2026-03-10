/**
 * cfgInventories.hpp
 * Purpose: Respawn inventory loadouts for each faction's parade role.
 *          Included inside CfgRespawnInventory in description.ext.
 *
 * NOTE: Each faction uses faction-specific ammo types that don't
 *       cross-interchange:
 *       - WEST:  .30-06 M1 Garand en-bloc clips (tracer)
 *       - EAST:  7.62x39 AKM magazines (tracer)
 *       - INDEP: 7.62x54R Mosin clips
 *       Weapon/magazine pairings must stay matched per faction.
 *
 * Params:  None (engine config)
 * Return:  None (engine config)
 */

// ===================================================================
// BLUFOR parade loadout
// ===================================================================
class 29TH_PARADE_WEST
{
    displayName = "Parade";
    icon = "\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa";
    role = "PARADE";

    weapons[] = {
        "rhs_weap_m1garand_sa43"
    };
    magazines[] = {
        "rhsgref_8Rnd_762x63_Tracer_M1T_M1rifle",
        "rhsgref_8Rnd_762x63_Tracer_M1T_M1rifle",
        "rhsgref_8Rnd_762x63_Tracer_M1T_M1rifle",
        "rhsgref_8Rnd_762x63_Tracer_M1T_M1rifle"
    };
    items[] = {
        "ACE_EarPlugs",
        "ACE_fieldDressing",
        "ACE_fieldDressing",
        "ACE_fieldDressing",
        "ACE_morphine"
    };
    linkedItems[] = {
        "r_Garrison_cap_qtr_crp_en",
        "29th_rhs_iotv_ocp_base_retex",
        "ItemMap",
        "ItemCompass",
        "TFAR_anprc152"
    };
    uniformClass = "29th_rhs_combat_uniform_ocp_retex";
    backpack = "";
};

// ===================================================================
// OPFOR parade loadout
// ===================================================================
class 29TH_PARADE_EAST
{
    displayName = "Parade";
    icon = "\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa";
    role = "PARADE";

    weapons[] = {
        "rhs_weap_akm"
    };
    magazines[] = {
        "rhs_30Rnd_762x39mm_tracer",
        "rhs_30Rnd_762x39mm_tracer"
    };
    items[] = {
        "ACE_EarPlugs",
        "ACE_fieldDressing",
        "ACE_fieldDressing",
        "ACE_fieldDressing",
        "ACE_morphine"
    };
    linkedItems[] = {
        "rhs_fieldcap_khk",
        "rhs_vest_pistol_holster",
        "ItemMap",
        "ItemCompass",
        "TFAR_fadak"
    };
    uniformClass = "rhs_uniform_m88_patchless";
    backpack = "";
};

// ===================================================================
// Independent parade loadout
// ===================================================================
class 29TH_PARADE_INDEPENDENT
{
    displayName = "Parade";
    icon = "\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa";
    role = "PARADE";

    weapons[] = {
        "rhs_weap_m38"
    };
    magazines[] = {
        "rhsgref_5Rnd_762x54_m38",
        "rhsgref_5Rnd_762x54_m38"
    };
    items[] = {
        "ACE_EarPlugs",
        "ACE_fieldDressing",
        "ACE_fieldDressing",
        "ACE_fieldDressing",
        "ACE_morphine"
    };
    linkedItems[] = {
        "rhsgref_ssh68_ttsko_digi",
        "rhs_vest_pistol_holster",
        "ItemMap",
        "ItemCompass",
        "TFAR_anprc148jem"
    };
    uniformClass = "U_BG_Guerrilla_6_1";
    backpack = "";
};
