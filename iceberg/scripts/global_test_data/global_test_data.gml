enum ENEMY {
	ORC,
	DEMON,
}
/// @desc	this is an example of a data_file that is structured as a lookup table,
///			but can be setup and accessed using ENUMs directly, so that enum-to-integer
///			binding does not need to be explicitly defined.
///
global._enemies = {}; with (global._enemies) {
	self[$ ENEMY.ORC] = {
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

#macro ENEMIES	  global._enemies
global._n_enemies = array_length(ENEMIES);
#macro N_ENEMIES  global._n_enemies

