enum ENEMY {
	ORC = 0,
	DEMON = 1,
}

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
////////////////////////////////////////////
show_message(ENEMIES[$ ENEMY.ORC].name);



