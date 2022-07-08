/// @desc obj_test : Create

event_inherited();

setup  = method_inherit(setup, function() {
	/// @func setup()
	///
	coop = new Coop()
		.add_component(new Actionable(), "fsm")
		.add_component(new Moveable())
	;
	
	coop.get_component("fsm")
		.actionable_state_add("test_state", {
			enter: function() {},
			step:  function() {},
			leave: function() {},
			draw:  function() {},
		})
	;
})();
update = method_inherit(update, function() {
	/// @func update()
	///
	coop.update();
});
render = method_inherit(render, function() {
	/// @func render()
	///
	coop.render();
});