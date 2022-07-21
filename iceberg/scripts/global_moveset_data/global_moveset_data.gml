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
			accel:		0.8,
			fric:		0.3,
			speed_mult: 1.0,
		};
		self[$ MOVESET.SAND] = { 
			accel:		0.3,
			fric:		0.2,
			speed_mult: 0.6,
		};
		self[$ MOVESET.ICE]  = { 
			accel:		0.2,
			fric:		0.1,
			speed_mult: 1.2,
		};
	};
	////////////////////////
	#macro MOVESETS		global.__movesets
	global.__n_movesets	= array_length(MOVESETS);
	#macro N_MOVESETS	global.__n_movesets
}