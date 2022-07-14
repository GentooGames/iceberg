/// @desc obj_test : Create
/// MANUALLY PLACE INSIDE OF rm_test
event_inherited();

setup  = method_inherit(setup,  function() {
	/// @func setup()
	///	
	color = color_get_random();
	mover = new Moveable().setup();
	
})();
update = method_inherit(update, function() {
	/// @func update()
	///
	
});
render = method_inherit(render, function() {
	/// @func render()
	///
	draw_circle_color(x, y, 20, color, color, false);
	
});
