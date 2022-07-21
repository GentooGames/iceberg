/// @desc obj_test : Create
event_inherited();

setup	 = method_inherit(setup,  function() {
	/// @func setup()
	///
	/*	ACCOUNT FOR:
		- entities weight
		- terrain move scalar
		
		- general multiplier
		- trigger conditions still need name
	*/
	new_component(Moveable);
	
	/// Speed
	get_component(Moveable)
		.new_movespeed("walk", 4.0)
		.new_movespeed("run",  8.0)
		.set_movespeed("walk")
	
	/// Moveset
	get_component(Moveable)
		.new_moveset("dirt", MOVESETS[$ MOVESET.DIRT])
		.new_moveset("sand", MOVESETS[$ MOVESET.SAND])
		.new_moveset("ice",  MOVESETS[$ MOVESET.ICE ])
		.set_moveset("dirt")
		
	/// Moveset Trigger
	get_component(Moveable)
		.new_moveset_trigger("sand", "", function() { /* condition 1 ... */ })
		.new_moveset_trigger("sand", "", function() { /* condition 2 ... */ })
		.new_moveset_trigger("ice",  "", function() { /* condition 1 ... */ })
		.new_moveset_trigger("dirt", "", function() { /* condition 1 ... */ })
			
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
	
