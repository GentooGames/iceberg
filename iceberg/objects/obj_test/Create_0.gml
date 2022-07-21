/// @desc obj_test : Create
event_inherited();

setup	 = method_inherit(setup,  function() {
	/// @func setup()
	///
	form = "human";
	/*	ACCOUNT FOR:
		- entities weight
		- terrain move scalar
		- general multiplier
	*/
	new_component(Moveable);
	
	/// Speeds
	get_component(Moveable)
		.new_movespeed("walk",   4.0)
		.new_movespeed("run",    8.0)
		.new_movespeed("crouch", 2.0)
		.change_movespeed("walk")
	
	/// Movesets
	get_component(Moveable)
		.new_moveset("grass", MOVESETS[$ MOVESET.GRASS])
		.new_moveset("sand",  MOVESETS[$ MOVESET.SAND ])
		.new_moveset("ice",   MOVESETS[$ MOVESET.ICE  ])
		.change_moveset("dirt")
		
	/// Moveset Triggers
	get_component(Moveable)
		.add_moveset_trigger("grass", "touching_grass", function() {
			
		})
		//.new_moveset_trigger("sand", "touching_sand", function() { 
		//	return (collision_point(x, y, obj_terrain_sand, false, true) != noone);
		//})
		//.new_moveset_trigger("sand", "pangolin_form", function() { 
		//	return (form == "pangolin");
		//})
		//.new_moveset_trigger("ice",  "", function() { /* condition 1 ... */ })
		//.new_moveset_trigger("dirt", "", function() { /* condition 1 ... */ })
			
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
});
render	 = method_inherit(render, function() {
	/// @func render()
	///
	draw_circle_color(x, y, 20, c_red, c_red, false);
});
	
