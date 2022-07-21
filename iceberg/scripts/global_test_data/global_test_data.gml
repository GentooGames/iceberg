enum ENEMY {
	ORC,
	DEMON,
};

function global_test_data() {
	/// @func	global_test_data()
	/// @desc	this is an example of a data_file that is structured as a lookup table,
	///			but can be setup and accessed using ENUMs directly, so that enum-to-integer
	///			binding does not need to be explicitly defined.
	///
	global.__enemies = {}; 
	////////////////////////
	with (global.__enemies) {
		self[$ ENEMY.ORC]	= { 
			name:	"orc",
			life:   100,
			attack: 20,
		};
		self[$ ENEMY.DEMON] = {
			name:	"demon",
			life:   200,
			attack: 30,
		};
	};
	////////////////////////
	#macro ENEMIES		global.__enemies
	global.__n_enemies	= array_length(ENEMIES);
	#macro N_ENEMIES	global.__n_enemies
}