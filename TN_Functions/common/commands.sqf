#include "script_component.hpp"

[
	[
		[
			"cleanup", {
				call FUNC(cleanup);
				systemChat "Cleaning up!"
			}
		]
	],
	[
		["cleanup", "Cleans up bodies (trash can function)"]
	]
] call EFUNC(commands,addModule);
