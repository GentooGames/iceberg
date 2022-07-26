// Move Object
function scr_move_object_create() {
	#region Properties
	
	#region States
	
	fall_state = undefined;
	roll_state = undefined;
	
	#endregion
	#region Environment Flags
	
	touching_slow = false;
	touching_slide = false;
	
	#endregion
	#region Movement

	hspd = 0;
	vspd = 0;
	move_speed = 0;
	accel = 0;
	fric  = 0;
	walk_speed = 0;
	run_speed  = 0;
	dash_speed = 0;
	
	// Multipliers
	move_mult = 1;
	attack_move_mult = 1;

	// Dynamic Movement Vars
	accel_normal = 0;
	fric_normal  = 0;
	walk_speed_normal = 0;
	run_speed_normal  = 0;
	dash_speed_normal = 0;
	push_speed_normal = 0;	
	////////////////////////
	accel_slow = 0;
	fric_slow  = 0;
	walk_speed_slow = 0;
	run_speed_slow  = 0;
	dash_speed_slow = 0;
	push_speed_slow = 0;
	////////////////////////
	accel_slide = 0;
	fric_slide  = 0;
	walk_speed_slide = 0;
	run_speed_slide  = 0;
	dash_speed_slide = 0;
	push_speed_slide = 0;
	////////////////////////

	#endregion
	#region Collisions
	
	collisions = ds_list_create();

	#endregion
	#region Point Tracking
	
	move_point_x = undefined;
	move_point_y = undefined;
	land_x       = x;
	land_y       = y;
	nonhazard_x	 = x;	// after falling dont respawn on a hazard
	nonhazard_y	 = y;	// after falling dont respawn on a hazard
	pitfall_anchor_x = 0;
	pitfall_anchor_y = 0;

	#endregion
	#region Path
	
	path = path_add();
	path_set_kind(path, 0);	
	path_set_closed(path, false);
	
	#endregion
	#region Other
	
	pushing  = false;
	push_dir = undefined;

	#endregion
	
	#endregion
	#region Methods
	
	/// Logic
	apply_pushing = function(_dir) {
		var _list = ds_list_create(); // move this to create event for performance boost
		var _n_blocks  = 0;
		var _push_hspd = 0;
		var _push_vspd = 0;
		static _push_range = 1;
		
		switch (_dir) {
			case DIR.RIGHT: {
				_n_blocks = collision_rectangle_list(bbox_right, bbox_top, bbox_right + _push_range, bbox_bottom, obj_pushable, false, true, _list, false);
				if (_n_blocks > 0) {
					 hspd = move_speed;
					_push_hspd = hspd;
				}
				break;
			}
			case DIR.LEFT: {
				_n_blocks = collision_rectangle_list(bbox_left, bbox_top, bbox_left - _push_range, bbox_bottom, obj_pushable, false, true, _list, false);
				if (_n_blocks > 0) {
					 hspd = -move_speed;
					_push_hspd = hspd;
				}
				break;
			}
			case DIR.DOWN: {
				_n_blocks = collision_rectangle_list(bbox_left, bbox_bottom, bbox_right, bbox_bottom + _push_range, obj_pushable, false, true, _list, false);
				if (_n_blocks > 0) {
					 vspd = move_speed;
					_push_vspd = vspd;
				}
				break;
			}
			case DIR.UP: {
				_n_blocks = collision_rectangle_list(bbox_left, bbox_top, bbox_right, bbox_top - _push_range, obj_pushable, false, true, _list, false);
				if (_n_blocks > 0) {
					 vspd = -move_speed;
					_push_vspd = vspd;
				}
				break;
			}
		};
		
		if (_n_blocks > 0) {
			for (var _i = 0; _i < _n_blocks; _i++) {
				var _block = _list[|_i];
				with (_block) {
					hspd = _push_hspd;
					vspd = _push_vspd;
					apply_pushing(_dir);
					scr_move_and_collide_no_input();
				}
			}
		}
		ds_list_destroy(_list);
	};
	
	/// Checkers
	is_moving_up = function() {
		return vspd < 0;
	};
	is_moving_down = function() {
		return vspd > 0;	
	};
	is_moving_left = function() {
		return hspd < 0;	
	};
	is_moving_right = function() {
		return hspd > 0;	
	};
	is_moving_up_with_input = function() {
		return (is_moving_up() 
			&&	input_check(pid, KEY.UP)
		);
	};
	is_moving_down_with_input = function() {
		return (is_moving_down() 
			&&	input_check(pid, KEY.DOWN)
		);
	};
	is_moving_left_with_input = function() {
		return (is_moving_left() 
			&&	input_check(pid, KEY.LEFT)
		);
	};
	is_moving_right_with_input = function() {
		return (is_moving_right() 
			&&	input_check(pid, KEY.RIGHT)
		);
	};
	is_moving_horizontal = function() {
		return hspd != 0;
	};
	is_moving_vertical = function() {
		return vspd != 0;	
	};
	
	#endregion
};
function scr_move_object_beginstep() {
	#region Update Dynamic Land Properties
	
	var _touching_ice   = collision_point(x, y, obj_ice, false, false);
	var _touching_water = collision_point(x, y, obj_water, false, false);

	touching_slow  = _touching_water != noone;
	touching_slide = _touching_ice   != noone;

	if (touching_slow) {
		accel		= accel_slow		* move_mult * attack_move_mult;
		fric		= fric_slow			* move_mult * attack_move_mult;
		run_speed	= run_speed_slow	* move_mult * attack_move_mult;
		walk_speed	= walk_speed_slow	* move_mult * attack_move_mult;
		push_speed	= push_speed_slow	* move_mult * attack_move_mult;
	}
	else if (touching_slide) {
		accel		= accel_slide		* move_mult * attack_move_mult;
		fric		= fric_slide		* move_mult * attack_move_mult;
		run_speed	= run_speed_slide	* move_mult * attack_move_mult;
		walk_speed	= walk_speed_slide	* move_mult * attack_move_mult;
		push_speed	= push_speed_slide	* move_mult * attack_move_mult;
	}
	else {
		accel		= accel_normal		 * move_mult * attack_move_mult;
		fric		= fric_normal		 * move_mult * attack_move_mult;
		run_speed	= run_speed_normal	 * move_mult * attack_move_mult;
		walk_speed	= walk_speed_normal	 * move_mult * attack_move_mult;
		push_speed	= push_speed_normal	 * move_mult * attack_move_mult;
	}

	#endregion
	#region Store Land Pos
	
	// Check For Land
	var _pitfall_touching = collision_point(x, y, obj_pitfall, false, false) != noone;
	if (!_pitfall_touching && state != fall_state) {
		land_x = x;
		land_y = y;
	} 
	// Check For Hazards
	static _hazards = [
		obj_collapsible_parent,
		obj_environment_wind
	];

	var _touching_hazard = false;
	for (var i = 0, _n_hazards = array_length(_hazards); i < _n_hazards; i++) {
		var _hazard_obj = _hazards[i];
		var _hazard_hit = collision_rectangle(bbox_left + hspd, bbox_top, bbox_right + hspd, bbox_bottom, _hazard_obj, false, false) != noone;
		if (_hazard_hit) {
			_touching_hazard = true;
			break;
		}
	}
	if (!_pitfall_touching && !_touching_hazard && state != fall_state && state != roll_state) {
		nonhazard_x = x;
		nonhazard_y = y;
	}
		
	#endregion
};
function scr_move_object_cleanup() {
	ds_list_destroy(collisions);
	path_delete(path);
};

// Input 
function scr_input_get_h(_invert = false) {
	var _input_h = 0;
	/// GAMEPAD
	if (input_get_active_device(pid) == input_type_gamepad()) {
		var _left_key = KEY.LEFT;
		var _right_key = KEY.RIGHT;
		var _left_is_button = gamepad_key_is_button(_left_key );
		var _right_is_button = gamepad_key_is_button(_right_key);
		
		// Get Just Stick Input
		if (!_left_is_button && !_right_is_button) {
			_input_h = input_get_gamepad_axis_raw(pid, _left_key);
		}
		// Get Split Input Between Stick & Button Input
		else if (_left_is_button && !_right_is_button) {
			var _input_left = input_check(pid, _left_key);	
			var _input_right = clamp(input_get_gamepad_axis_raw(pid, _right_key), 0, 1);
			
			_input_h = _input_right - _input_left;
		}
		// Get Split Input Between Stick & Button Input
		else if (!_left_is_button && _right_is_button) {
			var _input_left = clamp(input_get_gamepad_axis_raw(pid, _left_key), -1, 0);
			var _input_right = input_check(pid, _right_key);
			_input_h = _input_right - _input_left;
		}
		// Get Just Button Input
		else { 
			_input_h = input_check(pid, _right_key) - input_check(pid, _left_key); 
		}
	}
	
	/// KEYBOARD
	else if (input_get_active_device(pid) == input_type_keyboard_mouse()) {
		_input_h = input_check(pid, KEY.RIGHT) - input_check(pid, KEY.LEFT);
	}
	
	if (_invert) _input_h *= -1;	
	return _input_h;
};
function scr_input_get_v(_invert = false) {
	var _input_v = 0;
	/// GAMEPAD
	if (input_get_active_device(pid) == input_type_gamepad()) {
		var _up_key   = KEY.UP;
		var _down_key = KEY.DOWN;
		var _up_is_button	= gamepad_key_is_button(_up_key );
		var _down_is_button = gamepad_key_is_button(_down_key);
		
		// Get Just Stick Input
		if (!_up_is_button && !_down_is_button) {
			_input_v = input_get_gamepad_axis_raw(pid, _up_key);
		}
		// Get Split Input Between Stick & Button Input
		else if (_up_is_button && !_down_is_button) {
			var _input_up   = input_check(pid, _up_key);	
			var _input_down = clamp(input_get_gamepad_axis_raw(pid, _down_key), 0, 1);
			_input_v = _input_down - _input_up;
		}
		// Get Split Input Between Stick & Button Input
		else if (!_up_is_button && _down_is_button) {
			var _input_up	= clamp(input_get_gamepad_axis_raw(pid, _up_key), -1, 0);
			var _input_down = input_check(pid, _down_key);
			_input_v = _input_down - _input_up;
		}
		// Get Just Button Input
		else { 
			_input_v = input_check(pid, _down_key) - input_check(pid, _up_key); 
		}
	}
	
	/// KEYBOARD
	else if (input_get_active_device(pid) == input_type_keyboard_mouse()) {
		_input_v = input_check(pid, KEY.DOWN) - input_check(pid, KEY.UP);
	}
	
	if (_invert) _input_v *= -1;
	return _input_v;
};

// Move & Collide Abstractions
function scr_move_and_collide_with_input(_invert = false) {

	scr_move_with_input(_invert);	// scr_move_update_hspd_vspd_with_input()
	scr_ramp_adjust();
	scr_moving_platform_adjust();	// needs to come after friction
	scr_collisions();

	x += hspd;
	y += vspd;
};
function scr_move_and_collide_facing_with_input(_invert = false) {
	/// @desc only move in the current direction facing
	///
	scr_move_facing_with_input(_invert);
	scr_ramp_adjust();
	scr_moving_platform_adjust();	// needs to come after friction
	scr_collisions();

	x += hspd;
	y += vspd;
};
function scr_move_and_collide_bounce_with_input() {

	scr_move_with_input();
	scr_ramp_adjust();
	scr_just_friction();
	scr_moving_platform_adjust();	// needs to come after friction
	scr_collisions_bounce();

	x += hspd;
	y += vspd;
};
function scr_move_and_collide_no_input() {

	scr_ramp_adjust();
	scr_just_friction();
	scr_moving_platform_adjust();	// needs to come after friction
	scr_collisions();

	x += hspd;
	y += vspd;
};

// Move Util
function scr_move_to_and_face_point(_target_point) {
	if (_target_point == undefined) return;
	if (array_length(_target_point) != 2) return;

	var _x = _target_point[0];
	var _y = _target_point[1];

	// Constantly Try To Move To Target Point
	if (do_every_x_frame(AI_UPDATE_INTERVAL)) {
		//mp_grid_path(navmesh.grid, path, x, y, _x, _y, true);
	}
	scr_move_path_natural();
	face_point(id, x + hspd, y + vspd);
	path_speed = move_speed;
};
function scr_move_slide_new(_id = id, _hspd, _vspd, _limit, _dir) {
	with (_id) {	
		hspd += lengthdir_x(_hspd, _dir);
		vspd += lengthdir_y(_vspd, _dir);
		hspd  = clamp(hspd, -_limit, _limit);
		vspd  = clamp(vspd, -_limit, _limit);
	
		scr_collisions();	// use this to prevent clipping into walls
	
		x += hspd;
		y += vspd;
	}
};
function scr_move_slight(_id = id, _dir, _len) {
	with (_id) {
		hspd = lengthdir_x(_len, _dir);
		vspd = lengthdir_y(_len, _dir);

		scr_collisions();

		x += hspd;
		y += vspd;
	}
};
function scr_move_set_facing_with_input() {
	if (!can_act()) return false;
	
	var _key_left = input_check(PID.P1, KEY.LEFT);
	var _key_right = input_check(PID.P1, KEY.RIGHT);
	var _key_up = input_check(PID.P1, KEY.UP);
	var _key_down = input_check(PID.P1, KEY.DOWN);

	if (_key_right && !(_key_up || _key_down)) facing = DIR.RIGHT;
	if (_key_left && !(_key_up || _key_down)) facing = DIR.LEFT;
	if (_key_up && !(_key_left || _key_right)) facing = DIR.UP;
	if (_key_down && !(_key_left || _key_right)) facing = DIR.DOWN;
	
	if (_key_up && _key_right) facing = DIR.UP;
	if (_key_up && _key_left) facing = DIR.UP;
	if (_key_down && _key_right) facing = DIR.DOWN;
	if (_key_down && _key_left) facing = DIR.LEFT;
};
function scr_move_with_input(_invert = false) {
	if (!can_act()) return false;
	
	scr_move_update_hspd_vspd_with_input(
		scr_input_get_h(), 
		scr_input_get_v(),
	);
};
function scr_move_facing_with_input(_invert = false) {
	if (!can_act()) return false;

	var _input_h = 0;
	var _input_v = 0;
	
	if (facing == DIR.LEFT || facing == DIR.RIGHT) {
		_input_h = scr_input_get_h();
	}
	else if (facing == DIR.UP || facing == DIR.DOWN) {
		_input_v = scr_input_get_v();
	}
	scr_move_update_hspd_vspd_with_input(_input_h, _input_v);
};
function scr_move_update_hspd_vspd_with_input(_input_h, _input_v) {
	var _input_dir = point_direction(0, 0, _input_h, _input_v);
	var _hspd = hspd;
	var _vspd = vspd;
	_hspd  = (sign(_input_h) != sign(_hspd)) ? approach(_hspd, 0, fric) : _hspd;
	_vspd  = (sign(_input_v) != sign(_vspd)) ? approach(_vspd, 0, fric) : _vspd;
	_hspd += accel * _input_h;
	_vspd += accel * _input_v;

	// Truncate Input Values
	var _dist = point_distance(0, 0, _hspd, _vspd);
	if (_dist > move_speed) {
		var _dir = point_direction(0, 0, _hspd, _vspd);
		_hspd	 = lengthdir_x(move_speed, _dir);
		_vspd	 = lengthdir_y(move_speed, _dir);
	}
	// Apply Input
	if (_input_h != 0 || _input_v != 0) {
		facing = scr_angle_to_dir_enum(_input_dir);
	}
	hspd = _hspd;
	vspd = _vspd;
};

// Friction
function scr_just_friction(_ratio = 1.0) {
	
	var _fric = fric * _ratio;
	
	// Horizontal Friction
	if (hspd > 0) {
		if (hspd > _fric) {
			hspd -= _fric;
		}
		else {
			hspd = 0;
		}
	}
	if (hspd < 0) {
		if (hspd < _fric) {
			hspd += _fric;
		}
		else {
			hspd = 0;
		}
	}

	// Vertical Friction
	if (vspd > 0) {
		if (vspd > _fric) {
			vspd -= _fric;
		}
		else {
			vspd = 0;
		}
	}
	if (vspd < 0) {
		if (vspd < _fric) {
			vspd += _fric;
		}
		else {
			vspd = 0;
		}
	}
}
function scr_apply_friction(_ratio = 1.0) {
	
	scr_just_friction(_ratio);
	x += hspd;
	y += vspd;
}

// Collisions
function scr_collisions() {
	scr_collisions_basic();
};
function scr_collisions_basic() {
	// Horizontal Collisions
	if (place_meeting(x + hspd, y, obj_solid)) {
		while (!place_meeting(x + sign(hspd), y, obj_solid)) {
			x += sign(hspd);
		}
		hspd = 0;
	}
	// Vertical Collisions
	if (place_meeting(x, y + vspd, obj_solid)) {
		while (!place_meeting(x, y + sign(vspd), obj_solid)) {
			y += sign(vspd);
		}
		vspd = 0;
	}
};
function scr_collisions_climbing() {
	// Horizontal Collisions
	if (!place_meeting(x + hspd, y, obj_climb_parent)) {
		while (!place_meeting(x + sign(hspd), y, obj_climb_parent)) {
			x += sign(hspd);
		}
		hspd = 0;
	}
	// Vertical Collisions
	if (!place_meeting(x, y + vspd, obj_climb_parent)) {
		while (!place_meeting(x, y + sign(vspd), obj_climb_parent)) {
			y += sign(vspd);
		}
		vspd = 0;
	}
};
function scr_collisions_bounce() {
	#region Horizontal Collisions
	
	ds_list_clear(collisions);

	// Get All Collisions
	if (sign(hspd) == 1)	   collision_line_list(bbox_right,	  y, bbox_right	+ hspd, y, obj_solid, false, true, collisions, false);
	else if (sign(hspd) == -1) collision_line_list(bbox_left,	  y, bbox_left	+ hspd, y, obj_solid, false, true, collisions, false);
	else if (sign(hspd) == 0)  collision_line_list(bbox_left - 1, y, bbox_right	+ 1,	y, obj_solid, false, true, collisions, false);
	
	var _n_collisions = ds_list_size(collisions);
	for (var i = 0; i < _n_collisions; i++) {
		var _solid = collisions[| i];
		var _bear_climb = (_solid.object_index == obj_climb_wall && PLAYER_DATA[pid, PP.EQUIP] == "bear");
	
		if (_solid != noone && _solid.active && !_bear_climb) {
			// Check For Individual Collision
			if (sign(hspd) == 1)		var _solid_coll = collision_line(bbox_right,	y, bbox_right	+ 1, y, _solid, true, false);	
			else if (sign(hspd) == -1)	var _solid_coll = collision_line(bbox_left,		y, bbox_left	- 1, y, _solid, true, false);
			else if (sign(hspd) == 0)	var _solid_coll = collision_line(bbox_left - 1, y, bbox_right	+ 1, y, _solid, true, false);
		
			while (_solid_coll == noone) {
				x += sign(hspd);
			
				// Update Individual Collision
				if (sign(hspd) == 1)		_solid_coll = collision_line(bbox_right,	y, bbox_right	+ 1, y, _solid, true, false);	
				else if (sign(hspd) == -1)	_solid_coll = collision_line(bbox_left,		y, bbox_left	- 1, y, _solid, true, false);
				else if (sign(hspd) == 0)	break;//_solid_coll = collision_line(bbox_left - 1, y, bbox_right	+ 1, y, _solid, true, false);
			}
			hspd *= -1;
		}
	}
	
	#endregion
	#region Vertical Collisions
	
	ds_list_clear(collisions);

	// Get All Collisions
	if (sign(vspd) == 1)		collision_line_list(x,	bbox_bottom,	x, bbox_bottom	+ vspd, obj_solid, false, true, collisions, false);
	else if (sign(vspd) == -1)	collision_line_list(x,	bbox_top,		x, bbox_top		+ vspd, obj_solid, false, true, collisions, false);
	else if (sign(vspd) == 0)	collision_line_list(x,	bbox_top - 1,	x, bbox_bottom	+ 1,	obj_solid, false, true, collisions, false);
	
	var _n_collisions = ds_list_size(collisions);
	for (var i = 0; i < _n_collisions; i++) {
		var _solid		= collisions[| i];
		var _bear_climb = (_solid.object_index == obj_climb_wall && PLAYER_DATA[pid, PP.EQUIP] == "bear");

		if (_solid != noone && _solid.active && !_bear_climb) {	
			// Check For Individual Collision
			if (sign(vspd) == 1)		var _solid_coll = collision_line(x,	bbox_bottom,	x, bbox_bottom	+ vspd, _solid, true, false);
			else if (sign(vspd) == -1)	var _solid_coll = collision_line(x,	bbox_top,		x, bbox_top		+ vspd, _solid, true, false);
			else if (sign(vspd) == 0)	var _solid_coll = collision_line(x,	bbox_top - 1,	x, bbox_bottom	+ 1,	_solid, true, false);
		
			while (_solid_coll == noone) {
				y += sign(vspd);
			
				// Update Individual Collision
				if (sign(vspd) == 1)		_solid_coll = collision_line(x,	bbox_bottom,	x, bbox_bottom	+ vspd, _solid, true, false);
				else if (sign(vspd) == -1)	_solid_coll = collision_line(x,	bbox_top,		x, bbox_top		+ vspd, _solid, true, false);
				else if (sign(vspd) == 0)	break;//_solid_coll = collision_line(x,	bbox_top - 1,	x, bbox_bottom	+ 1,	_solid, true, false);
			}
			vspd *= -1;
		}
	}
	
	#endregion
};
function scr_collisions_tile_layer() {
	// static definitions
	static _collide_identifier = "collide";
	static _get_horizontal_collisions = function(_layer_tiles) {
		if (hspd > 0) {
			return {
				top: tilemap_get_at_pixel(_layer_tiles, bbox_right + hspd, bbox_top),
				bottom: tilemap_get_at_pixel(_layer_tiles, bbox_right + hspd, bbox_bottom),
			};
		}
		else {
			return {
				top: tilemap_get_at_pixel(_layer_tiles, bbox_left + hspd, bbox_top),
				bottom: tilemap_get_at_pixel(_layer_tiles, bbox_left + hspd, bbox_bottom),
			};
		}
	};
	static _get_vertical_collisions = function(_layer_tiles) {
		if (vspd > 0) {
			return {
				left: tilemap_get_at_pixel(_layer_tiles, bbox_left, bbox_bottom + vspd),
				right: tilemap_get_at_pixel(_layer_tiles, bbox_right, bbox_bottom + vspd),
			};
		}
		else {
			return {
				left: tilemap_get_at_pixel(_layer_tiles, bbox_left, bbox_top + vspd),
				right: tilemap_get_at_pixel(_layer_tiles, bbox_right, bbox_top + vspd),
			};
		}
	};
	
	// get each tile layer in the room that contains the identifier substring
	var _layers_all	= layer_get_all(); // <-- bake this into a var that get's calculated only once per room transition
	var _layers_collide = [];
	var _layer_name = "";
	var _layer_id = undefined;
	
	for (var _i = 0, _len = array_length(_layers_all); _i < _len; _i++) {
		_layer_id = _layers_all[_i];
		_layer_name =  layer_get_name(_layer_id);
		
		if (string_contains(_layer_name, _collide_identifier)) {
			array_push(_layers_collide, _layer_id);
		}
	}
	
	// check for collisions with any of those tile layers
	var _layer_tiles = undefined;
	var _horizontal_collisions = undefined;
	var _horizontal_top = undefined;
	var _horizontal_bottom = undefined;
	var _vertical_collisions = undefined;
	var _vertical_left = undefined;
	var _vertical_right = undefined;
		
	for (var _i = 0, _len = array_length(_layers_collide); _i < _len; _i++) {
		_layer_id = _layers_collide[_i];
		_layer_tiles = layer_tilemap_get_id(_layer_id);
		
		// calculate horizontal collisions
		_horizontal_collisions = _get_horizontal_collisions(_layer_tiles);
		_horizontal_top = _horizontal_collisions.top;
		_horizontal_bottom = _horizontal_collisions.bottom;		
			
		// if about to horizontally collide, ease into collision
		if (_horizontal_top != 0 || _horizontal_bottom != 0) {
			while (_horizontal_top == 0 && _horizontal_bottom == 0) {
				x += sign(hspd);
				
				// recalculate collisions to see if we should exit while() loop
				_horizontal_collisions = _get_horizontal_collisions(_layer_tiles);
				_horizontal_top = _horizontal_collisions.top;
				_horizontal_bottom = _horizontal_collisions.bottom;		
			}
			hspd = 0;
		}
		
		// calculate vertical collisions
		_vertical_collisions = _get_vertical_collisions(_layer_tiles);
		_vertical_left = _vertical_collisions.left;
		_vertical_right = _vertical_collisions.right;		
			
		// if about to vertically collide, ease into collision
		if (_vertical_left != 0 || _vertical_right != 0) {
			while (_vertical_left == 0 && _vertical_right == 0) {
				y += sign(vspd);
				
				// recalculate collisions to see if we should exit while() loop
				_vertical_collisions = _get_vertical_collisions(_layer_tiles);
				_vertical_left = _vertical_collisions.left;
				_vertical_right = _vertical_collisions.right;		
			}
			vspd = 0;
		}
	}
};
function scr_collisions_tile() {
	static _tile_indexes = [ 
		651, 
	];
	static _layer_name = "Tiles_0_land_base";
	
	var _layer_id = layer_tilemap_get_id(_layer_name);
	var _tile_data = tilemap_get_at_pixel(_layer_id, x, y);
	
	if (_tile_data != 0 && _tile_data != -1) {
		for (var _i = 0, _len = array_length(_tile_indexes); _i < _len; _i++) {
			if (tile_get_index(_tile_data) == _tile_indexes[_i]) {
				// ... collide ...
			}
		}
	}
};

// Clipping
function scr_clipping_check() {
	// Check For Clipping
	/*
	ds_list_clear(collisions);
	collision_rectangle_list(bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, obj_solid, false, false, collisions, false);

	var _n_collisions = ds_list_size(collisions);
	for (var i = 0; i < _n_collisions; i++) {
	
		var _solid = collisions[| i];
		if (defined(_solid)) {
		
			var _head  = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_top,	_solid, false, false);
			var _feet  = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom, _solid, false, false);
			var _left  = collision_rectangle(bbox_left, bbox_top, bbox_left, bbox_bottom, _solid, false, false);
			var _right = collision_rectangle(bbox_right, bbox_top, bbox_right, bbox_bottom,	_solid, false, false);

			// Head Clipping
			if  (_head && !_feet) {
				var _while_loop_count = 0;
				while (_head) {
					y++;	
					_head = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_top, _solid, false, false);
			
					// Hard Exit In Case of Infinite Loop
					_while_loop_count++;
					if (_while_loop_count >= 1000)
						break;
				}
			}

			// Feet Clipping
			if (_feet && !_head) {
				var _while_loop_count = 0;
				while (_feet) {
					y--;	
					_feet = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom, _solid, false, false);
			
					// Hard Exit In Case of Infinite Loop
					_while_loop_count++;
					if (_while_loop_count >= 1000)
						break;
				}
			}	

			// Right Clipping
			if  (_right && !_left) {
				var _while_loop_count = 0;
				while (_right) {
					x--;	
					_right = collision_rectangle(bbox_left, bbox_top, bbox_left, bbox_bottom, _solid, false, false);
			
					// Hard Exit In Case of Infinite Loop
					_while_loop_count++;
					if (_while_loop_count >= 1000)
						break;
				}
			}

			// Feet Clipping
			if (_left && !_right) {
				var _while_loop_count = 0;
				while (_left) {
					x++;	
					_left = collision_rectangle(bbox_right, bbox_top, bbox_right, bbox_bottom, _solid, false, false);
			
					// Hard Exit In Case of Infinite Loop
					_while_loop_count++;
					if (_while_loop_count >= 1000)
						break;
				}
			}	
		}
	}

/* end scr_clipping_check */
}

// Adjustments
function scr_moving_platform_adjust() {
	var _ice_block_top = collision_rectangle_bbox(obj_ice_block_top, false, false);
	if (_ice_block_top != noone && defined_exists_tru(_ice_block_top.owner)) {
	
		/// NEED TO ADJUST IN ORDER TO ACCOUNT FOR 8 DIRECTIONAL MOVEMENT
	
		if (state == idle_state)
			vspd = _ice_block_top.owner.vspd;
		else {
			if (facing == DIR.DOWN || facing == DIR.LEFT || facing == DIR.RIGHT)
				vspd = max(vspd, _ice_block_top.owner.vspd);
			//else if (facing == DIR.UP)
			//	vspd += _ice_block_top.owner.vspd;
		}
	}
};
function scr_ramp_adjust() {
	// Horizontal Ramps
	// Only Apply To Entities When Explicitly Moving
	var _is_player = object_get_parent(object_index) == obj_player_parent;
	if (_is_player && can_act() && !input_check(PID.P1, KEY.LEFT) && !input_check(PID.P1, KEY.RIGHT)) return;

	if (instance_exists_tru(obj_ramp_horiz)) {
		var _ramp_horiz = collision_point(x, y, obj_ramp_horiz, true, false);
		if (_ramp_horiz != noone) {
			var _vertical_adjust = 2;
			// Move Up Ramp
			if (sign(image_xscale) == sign(_ramp_horiz.image_xscale)) {
				if (hspd != 0 && !place_meeting(x, y - _vertical_adjust, obj_solid)) {
					y -= _vertical_adjust * abs(hspd / move_speed);
				}
			}
			// Move Down Ramp
			else if (sign(image_xscale) == sign(_ramp_horiz.image_xscale) * -1) {
				if (hspd != 0 && !place_meeting(x, y + _vertical_adjust, obj_solid)) {
					y += _vertical_adjust * abs(hspd / move_speed);
				}
			}
		}
	}

	// // Vertical Ramps
	// if (instance_exists_tru(obj_ramp_vert) || instance_exists_tru(obj_ramp_horiz)) {
	// 	var _ramp_vert		 = collision_point(x, y, obj_ramp_vert,  true, false);
	// 	var _ramp_horiz		 = collision_point(x, y, obj_ramp_horiz, true, false);
	// 	var _vertical_adjust = 1;
	
	// 	if ((_ramp_vert != noone) || (_ramp_horiz != noone && _ramp_horiz.apply_vertical)) {
	// 		// Move Up Ramp
	// 		if (facing == DIR.UP) {
	// 			if (vspd != 0 && !place_meeting(x, y - _vertical_adjust, obj_solid))
	// 				y += _vertical_adjust * abs(hspd / move_speed);
	// 		}	
	// 		// Move Down Ramp	
	// 		if (facing == DIR.DOWN) {
	// 			if (vspd != 0 && !place_meeting(x, y + _vertical_adjust, obj_solid))
	// 				y += _vertical_adjust * abs(hspd / move_speed);	
	// 		}
	// 	}
	// }
};

// "Natural" Path
function scr_move_path_natural() {

	var _n_points = path_get_number(path);
	if (_n_points >= 2) {
	
		move_point_x = path_get_point_x(path, clamp(_n_points - 1, 1, 2));
		move_point_y = path_get_point_y(path, clamp(_n_points - 1, 1, 2));	

		var _dir = point_direction(x, y, move_point_x, move_point_y);
		hspd += lengthdir_x(accel, _dir);
		vspd += lengthdir_y(accel, _dir);
		hspd  = clamp(hspd, -move_speed, move_speed);
		vspd  = clamp(vspd, -move_speed, move_speed);
	}
	else {
		path_clear_points(path);
		return;
	}
	scr_ramp_adjust();
	scr_just_friction();
	scr_collisions();

	x += hspd;
	y += vspd;
};
function scr_end_path_natural(_id = id) {
	if (path_get_number(_id.path) > 0 && abs(_id.hspd) < 1 && abs(_id.vspd) < 1) {
		var _point_x = path_get_point_x(_id.path, path_get_number(_id.path) - 1);
		var _point_y = path_get_point_y(_id.path, path_get_number(_id.path) - 1);
		var _dis = point_distance(_id.x, _id.y, _point_x, _point_y);
		return (_dis < 50);
	}
	return false;
}
function scr_path_finished_natural() {
	if (target_point != undefined && array_length(target_point) >= 2) {
		return (point_distance(x, y, target_point[0], target_point[1]) <= 5);
	}
	return true;
};
