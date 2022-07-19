/// @desc obj_test : Create
event_inherited();

setup	 = method_inherit(setup,  function() {
	/// @func setup()
	///	
	//mover = new Moveable().setup();
	//show_message(mover.__system);
	//show_message(component_system);
	
	//mover.set_moveset_default_data({
	//		speed: 6.0,
	//		accel: 1.0,
	//		fric:  0.0,
	//		mult:  1.0,
	//	})
	//	.new_moveset("sand", {
	//		speed: 4.0,
	//		accel: 0.3,
	//		fric:  0.2,
	//		mult:  1.0,
	//	})
	//	.new_moveset("ice", {
	//		speed: 8.0,
	//		accel: 0.2,
	//		fric:  0.1,
	//		mult:  1.0,
	//	})
		
	//component_system()
	//	.get_component("Eventable")
	//	.destroy()
		
})();
teardown = method_inherit(teardown, function() {
	/// @func teardown()
	///
	//mover.teardown();
	//mover = undefined;
});
update	 = method_inherit(update, function() {
	/// @func update()
	///
	static _speed = 5;
	if (INPUT.keyboard.button(vk_right)) x += _speed;
	if (INPUT.keyboard.button(vk_left))  x -= _speed;
	if (INPUT.keyboard.button(vk_down))  y += _speed;
	if (INPUT.keyboard.button(vk_up))    y -= _speed;
	
	//mover.update();
	//log("moveset: {0}", mover.__moveset.__moveset.get_name());
	//log("hspd: {0}, vspd: {1}, speed: {2}, accel: {3}, fric: {4}, mult: {5}",
	//	mover.__hspd, mover.__vspd, mover.__speed, mover.__accel, mover.__fric, mover.__mult);
});
render	 = method_inherit(render, function() {
	/// @func render()
	///
	draw_circle_color(x, y, 20, c_red, c_red, false);
});
	