enum MOVESET {
	DIRT,
	SAND,
	ICE,
};

function global_moveset_data() {
	/// @func	global_moveset_data()
	///
	global.__movesets = {}; 
	////////////////////////
	with (global.__movesets) {
		self[$ MOVESET.DIRT] = { 
			speed_mult: 1.0,
			accel:		0.8,
			fric:		0.3,
		};
		self[$ MOVESET.SAND] = { 
			speed_mult: 0.6,
			accel:		0.3,
			fric:		0.2,
		};
		self[$ MOVESET.ICE]  = { 
			speed_mult: 1.2,
			accel:		0.2,
			fric:		0.1,
		};
	};
	////////////////////////
	#macro MOVESETS		global.__movesets
	global.__n_movesets	= array_length(MOVESETS);
	#macro N_MOVESETS	global.__n_movesets
}
