/*
 * Author: Bae [29th ID]
 * Initializes shared common utilities on the server.
 * Registers the centralized admin state change handler.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_common_fnc_init;
 */

if (isServer) then
{
    call TN_common_fnc_initAdminStateChanged;
};

nil
