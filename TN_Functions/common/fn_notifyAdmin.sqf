#include "script_component.hpp"

if !(isServer) exitWith { _this remoteExecCall [QFUNC(notifyAdmin), 2] };

params ["_msg"];

if (GVAR(adminClient) == 2 && isDedicated) exitWith {};

_this remoteExecCall ["systemChat", GVAR(adminClient)];