/// @desc obj_test : Create
event_inherited();

setup	 = method_inherit(setup,  function() {
	/// @func setup()
	///	
	mover = new Moveable().setup();
})();
teardown = method_inherit(teardown, function() {
	/// @func teardown()
	///
	mover.teardown();
	mover = undefined;
});
update	 = method_inherit(update, function() {
	/// @func update()
	///
	static _speed = 5;
	if (INPUT.keyboard.button(vk_right)) x += _speed;
	if (INPUT.keyboard.button(vk_left))  x -= _speed;
	if (INPUT.keyboard.button(vk_down))  y += _speed;
	if (INPUT.keyboard.button(vk_up))    y -= _speed;
	
	mover.update();
	log("hspd: {0}, vspd: {1}, speed: {2}, accel: {3}, fric: {4}, mult: {5}",
		mover.__hspd, mover.__vspd, mover.__speed, mover.__accel, mover.__fric, mover.__mult);
});
render	 = method_inherit(render, function() {
	/// @func render()
	///
	draw_circle_color(x, y, 20, c_red, c_red, false);
});