function ___control() {
	/// @func ___control()
	///
	global.___control = {
		system: {
			time_frame: 0,	
		},
		game: {
			is_paused: false,	
		},
	};
	#macro CONTROL		 global.___control
	#macro CURRENT_FRAME CONTROL.system.time_frame
	#macro IS_PAUSED	 CONTROL.game.is_paused
}