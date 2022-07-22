/// @desc obj_test : Create
event_inherited();

/*	
	ToDo:
		-	entities weight
		-	terrain move scalar
		-	general multiplier
		-	default moveset that executes when all other triggers fail
		-	have component system process components
				-	if component system processing, do not check for is_active() within component, 
					checkout from outside from system
		-	freezing/locking components?
		-	move MoveSet trigger into MoveSet
*/

setup	 = method_inherit(setup,  function() {
	/// @func setup()
	///
	form = "human";
	new_component(Moveable);
	
	/// Speeds
	get_component(Moveable)
		.set_movespeed("walk",   4.0)
		.set_movespeed("run",    8.0)
		.set_movespeed("crouch", 2.0)
		.change_movespeed("walk")
	
	/// Movesets
	get_component(Moveable)
		.set_moveset("dirt",  MOVESETS[$ MOVESET.DIRT ])
		.set_moveset("grass", MOVESETS[$ MOVESET.GRASS])
		.set_moveset("sand",  MOVESETS[$ MOVESET.SAND ])
		.set_moveset("ice",   MOVESETS[$ MOVESET.ICE  ])
		.change_moveset("dirt")
		
	/// Moveset Triggers
	get_component(Moveable)
		.set_moveset_condition("grass", function() {
			return collision_point(x, y, obj_terrain_grass, false, true) != noone;
		})
		.set_moveset_condition("sand",  function() {
			return collision_point(x, y, obj_terrain_sand, false, true) != noone;
		})
		.set_moveset_condition("ice",   function() {
			return collision_point(x, y, obj_terrain_ice, false, true) != noone;
		})
	
})();
teardown = method_inherit(teardown, function() {
	/// @func teardown()
	///
});
update	 = method_inherit(update, function() {
	/// @func update()
	///
	static _speed = 5;
	if (INPUT.keyboard.button(vk_right)) x += _speed;
	if (INPUT.keyboard.button(vk_left))  x -= _speed;
	if (INPUT.keyboard.button(vk_down))  y += _speed;
	if (INPUT.keyboard.button(vk_up))    y -= _speed;
	
	get_component(Moveable).update();
});
render	 = method_inherit(render, function() {
	/// @func render()
	///
	draw_circle_color(x, y, 20, c_red, c_red, false);
	draw_text(x, y, get_component(Moveable).__moveset.__current.get_name());
});
	
